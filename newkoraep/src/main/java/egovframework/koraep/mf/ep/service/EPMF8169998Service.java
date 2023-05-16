package egovframework.koraep.mf.ep.service;

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
import egovframework.mapper.mf.ep.EPMF8169998Mapper;

/**
 * FAQ 등록 Service
 * @author pc
 *
 */
@Service("epmf8169998Service")
public class EPMF8169998Service {
	
	@Resource(name="epmf8169998Mapper")
	private EPMF8169998Mapper epmf8169998Mapper;
	
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil EgovFileMngUtil;
	
	/**
	 * FAQ 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf8169998(ModelMap model, HttpServletRequest request)  {
		
		List<?> askInfo = null;
		List<?> fileList = null;
		
		if(null != request.getParameter("FAQ_SEQ")){
			
			Map<String, String> inputMap = new HashMap<String, String>();
			
			inputMap.put("FAQ_SEQ", request.getParameter("FAQ_SEQ"));
			
			//FAQ 상세조회
			askInfo = epmf8169998Mapper.epmf8169998_select2(inputMap);
			
			for(int i=0;i<askInfo.size();i++){
				Map<String, String> rtn = (Map<String, String>) askInfo.get(i);
				
				//rtn.put("CNTN", XSSFilter.getFilter(rtn.get("CNTN")));
			}
			
			//FAQ 첨부파일 조회
			fileList = epmf8169998Mapper.epmf8169998_select3(inputMap);
			
		}
		
		try {
		
			if(null == askInfo) {
				model.addAttribute("askInfo", "{}");
			} else {
				model.addAttribute("askInfo", util.mapToJson(askInfo));
			}
			
			if(null == fileList) {
				model.addAttribute("fileList", "{}");
			} else {
				model.addAttribute("fileList", util.mapToJson(fileList));
			}
			
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
	 * FAQ 등록 및 수정
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional
	public String epmf8169998_update(HashMap<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		//크로스 추가
//		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
		MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
		Iterator fileIter = mptRequest.getFileNames();
		
		if(!inputMap.containsKey("FAQ_SEQ") || inputMap.get("FAQ_SEQ").equals("")){
			
			//등록
			
			//내용유형 : 1 - HTML, 2 - TEXT => 1 로 고정 등록
			inputMap.put("CNTN_TP", "1");
			inputMap.put("REG_PRSN_ID", vo.getUSER_ID());
			
			int regSn = 1;
			
			//FAQ 등록 순번 조회(마지막 등록 번호에서 +1 해서 받아옴)
			List<?> seqList = epmf8169998Mapper.epmf8169998_select1();
			
			for(int i=0;i<seqList.size();i++){
				Map<String, String> rtn = (Map<String, String>) seqList.get(i);
				
				inputMap.put("FAQ_SEQ", String.valueOf(rtn.get("FAQ_SEQ")));
			}
			
			//FAQ 등록
			epmf8169998Mapper.epmf8169998_update1(inputMap);
			
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
	
					epmf8169998Mapper.epmf8169998_update2(inputMap);
					
					regSn++;
					
				}//if
			}//while
			
		} else {
			
			//수정
			
			inputMap.put("FAQ_SEQ", request.getParameter("FAQ_SEQ"));
			inputMap.put("UPD_PRSN_ID", vo.getUSER_ID());
			String delSeq = (null == request.getParameter("DEL_SEQ")) ? "" : request.getParameter("DEL_SEQ");
			String[] delSeqList = delSeq.split(",");
			
			//기존 첨부파일 삭제
			for(int i=0; i<delSeqList.length; i++) {
				
				inputMap.put("REG_SN", delSeqList[i]);
				
				//삭제할 첨부파일 이름 조회
				List<?> delFile = epmf8169998Mapper.epmf8169998_select4(inputMap);
				
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
				epmf8169998Mapper.epmf8169998_delete(inputMap);
				
			}
			
			//FAQ 수정
			epmf8169998Mapper.epmf8169998_update3(inputMap);
			
			//첨부파일 순번 재조정
			
			int regSn = 1;
			
			//FAQ 기존 첨부파일 리스트 조회
			List<?> filePre = epmf8169998Mapper.epmf8169998_select5(inputMap);
			
			for(int i=0;i<filePre.size();i++){
				Map<String, String> rtn = (Map<String, String>) filePre.get(i);
				
				rtn.put("REG_SN", String.valueOf(regSn));
				
				epmf8169998Mapper.epmf8169998_update4(rtn);
				
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
					
					inputMap.put("FILE_NM", (String)map.get("originalFileName"));
					inputMap.put("SAVE_FILE_NM", (String)map.get("uploadFileName"));
					inputMap.put("FILE_PATH", (String)map.get("filePath"));
					inputMap.put("REG_SN", String.valueOf(regSn));
					inputMap.put("REG_PRSN_ID", vo.getUSER_ID());
	
					epmf8169998Mapper.epmf8169998_update2(inputMap);
					
					regSn++;
					
				}//if
			}//while
			
			
		}

		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
    }

}
