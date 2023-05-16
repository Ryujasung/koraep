package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE8149093Mapper;
import egovframework.mapper.ce.ep.EPCE8149094Mapper;

/**
 * 공지사항 등록 Service
 * @author pc
 *
 */
@Service("epce8149094Service")
public class EPCE8149094Service {
	@Resource(name="epce8149093Mapper")
	private EPCE8149093Mapper epce8149093Mapper;
	
	@Resource(name="epce8149094Mapper")
	private EPCE8149094Mapper epce8149094Mapper;
	
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil EgovFileMngUtil;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 공지사항 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce8149094(ModelMap model, HttpServletRequest request)  {

		List<?> notiInfo = null;
		List<?> fileList = null;
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String userId = vo.getUSER_ID();
		Map<String,Object> userInfo = (Map<String, Object>) epce8149093Mapper.getUserInfo(userId);
		
		model.addAttribute("userInfo", userInfo);
		if(null != request.getParameter("NOTI_SEQ")){
			
			Map<String, String> inputMap = new HashMap<String, String>();
			
			inputMap.put("NOTI_SEQ", request.getParameter("NOTI_SEQ"));
			
			//공지사항 상세조회
			notiInfo = epce8149094Mapper.epce8149094_select2(inputMap);
			
			for(int i=0;i<notiInfo.size();i++){
				Map<String, String> rtn = (Map<String, String>) notiInfo.get(i);
				
				//rtn.put("CNTN", XSSFilter.getFilter(rtn.get("CNTN")));

			}
			
			//공지사항 첨부파일 조회
			fileList = epce8149094Mapper.epce8149094_select3(inputMap);

		}
		
		try {
		
			if(null == notiInfo) {
				model.addAttribute("notiInfo", "{}");
			} else {
				model.addAttribute("notiInfo", util.mapToJson(notiInfo));
			}
			
			if(null == fileList) {
				model.addAttribute("fileList", "{}");
			} else {
				model.addAttribute("fileList", util.mapToJson(fileList));
			}
			
			List<?> ancSeList = commonceService.getCommonCdListNew("S019");//알림대상
			model.addAttribute("ancSeList", util.mapToJson(ancSeList));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		
		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}
	
	/**
	 * 공지사항 등록 및 수정
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional
	public String epce8149094_update(HashMap<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try{
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			String ssUserId = "";
			if(vo != null){
				ssUserId = vo.getUSER_ID();
			}
			//크로스 사이트 스크립트
//			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
			MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
			Iterator fileIter = mptRequest.getFileNames();
			
			if(!inputMap.containsKey("NOTI_SEQ") || inputMap.get("NOTI_SEQ").equals("")){
				
				//등록
				//내용유형 : 1 - HTML, 2 - TEXT => 1 로 고정 등록
				inputMap.put("CNTN_TP", "1");
				inputMap.put("REG_PRSN_ID", ssUserId);
				
				int regSn = 1;
				
				//공지사항 등록 순번 조회(마지막 등록 번호에서 +1 해서 받아옴)
				List<?> seqList = epce8149094Mapper.epce8149094_select1();
				
				for(int i=0;i<seqList.size();i++){
					Map<String, String> rtn = (Map<String, String>) seqList.get(i);
					
					inputMap.put("NOTI_SEQ", String.valueOf(rtn.get("NOTI_SEQ")));
					
				}
				
				//공지사항 등록
				epce8149094Mapper.epce8149094_update1(inputMap);
				
				//첨부파일 등록
				while (fileIter.hasNext()) {
					MultipartFile mFile = mptRequest.getFile((String)fileIter.next());
					if (mFile.getSize() > 0) {
						HashMap map = new HashMap();
						try {
							map = EgovFileMngUtil.uploadNotiFile(mFile);
						} catch (Exception e) {
							// TODO Auto-generated catch block
							org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
						}	//파일저장
						String fileName = (String)map.get("uploadFileName");
						
						inputMap.put("FILE_NM", (String)map.get("originalFileName"));
						inputMap.put("SAVE_FILE_NM", (String)map.get("uploadFileName"));
						inputMap.put("FILE_PATH", (String)map.get("filePath"));
						inputMap.put("REG_SN", String.valueOf(regSn));
		
						epce8149094Mapper.epce8149094_update2(inputMap);
						
						regSn++;
						
					}//if
				}//while
							
			} else {
				
				//수정
				inputMap.put("UPD_PRSN_ID", ssUserId);
				//String delSeq = request.getParameter("DEL_SEQ");
				String delSeq = (null == inputMap.get("DEL_SEQ")) ? "" : inputMap.get("DEL_SEQ");
				String[] delSeqList = delSeq.split(",");
				
				//기존 첨부파일 삭제
				for(int i=0; i<delSeqList.length; i++) {
					
					inputMap.put("REG_SN", delSeqList[i]);
					
					//삭제할 첨부파일 이름 조회
					List<?> delFile = epce8149094Mapper.epce8149094_select4(inputMap);
					
					for(int j=0;j<delFile.size();j++){
						
						Map<String, String> rtn = (Map<String, String>) delFile.get(j);
						
						inputMap.put("SAVE_FILE_NM", rtn.get("SAVE_FILE_NM"));
						
						try {
							EgovFileMngUtil.deleteNotiFile(inputMap.get("SAVE_FILE_NM"));
						} catch (Exception e) {
							// TODO Auto-generated catch block
							org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
						}
						
					}
					
					//첨부파일 테이블 삭제
					epce8149094Mapper.epce8149094_delete(inputMap);
					
				}
				
				//공지사항 수정
				epce8149094Mapper.epce8149094_update3(inputMap);
				
				//첨부파일 순번 재조정
				
				int regSn = 1;
				
				//공지사항 기존 첨부파일 리스트 조회
				List<?> filePre = epce8149094Mapper.epce8149094_select5(inputMap);
				
				for(int i=0;i<filePre.size();i++){
					Map<String, String> rtn = (Map<String, String>) filePre.get(i);
					
					rtn.put("REG_SN", String.valueOf(regSn));
					
					epce8149094Mapper.epce8149094_update4(rtn);
					
					regSn++;
				}
				
				//첨부파일 등록
				while (fileIter.hasNext()) {
					MultipartFile mFile = mptRequest.getFile((String)fileIter.next());
					if (mFile.getSize() > 0) {
						HashMap map = new HashMap();
						try {
							map = EgovFileMngUtil.uploadNotiFile(mFile);
						} catch (Exception e) {
							// TODO Auto-generated catch block
							org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
						}	//파일저장
						String fileName = (String)map.get("uploadFileName");
						
						inputMap.put("FILE_NM", (String)map.get("originalFileName"));
						inputMap.put("SAVE_FILE_NM", (String)map.get("uploadFileName"));
						inputMap.put("FILE_PATH", (String)map.get("filePath"));
						inputMap.put("REG_SN", String.valueOf(regSn));
						inputMap.put("REG_PRSN_ID", ssUserId);
		
						epce8149094Mapper.epce8149094_update2(inputMap);
						
						regSn++;
						
					}//if
				}//while
				
			}
			
			
			//알림등록
			if(inputMap.containsKey("ANC_APLC_YN") && inputMap.get("ANC_APLC_YN").equals("Y")){
				
				Map<String, String> ancMap = new HashMap<String, String>();
				ancMap.put("ANC_SE", "C1"); //공지사항
				ancMap.put("USER_ID", ssUserId); //등록자
				
				ancMap.put("TRGT_SE", inputMap.get("TRGT_SE")); //알림적용대상
				ancMap.put("ANC_SBJ", inputMap.get("SBJ")); //제목
				ancMap.put("LK_INFO", "8149001.do?NOTI_SEQ="+inputMap.get("NOTI_SEQ")); //url
				
				commonceService.anc_insert(ancMap);
				
			}
			
			
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
    }
	
}
