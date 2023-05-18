package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.mapper.mf.ep.EPMF8149094Mapper;

/**
 * 공지사항 등록 Service
 * @author pc
 *
 */
@Service("epmf8149094Service")
public class EPMF8149094Service {
	
	@Resource(name="epmf8149094Mapper")
	private EPMF8149094Mapper epmf8149094Mapper;
	
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil EgovFileMngUtil;
	
	/**
	 * 공지사항 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf8149094(ModelMap model, HttpServletRequest request)  {

		List<?> notiInfo = null;
		List<?> fileList = null;
		
		if(null != request.getParameter("NOTI_SEQ")){
			
			Map<String, String> inputMap = new HashMap<String, String>();
			
			inputMap.put("NOTI_SEQ", request.getParameter("NOTI_SEQ"));
			
			//공지사항 상세조회
			notiInfo = epmf8149094Mapper.epmf8149094_select2(inputMap);
			
			for(int i=0;i<notiInfo.size();i++){
				Map<String, String> rtn = (Map<String, String>) notiInfo.get(i);
				
				//rtn.put("CNTN", XSSFilter.getFilter(rtn.get("CNTN")));

			}
			
			//공지사항 첨부파일 조회
			fileList = epmf8149094Mapper.epmf8149094_select3(inputMap);

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
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
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
	public String epmf8149094_update(HashMap<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		//크로스 추가
//		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
		MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
		Iterator fileIter = mptRequest.getFileNames();
		
		if(!inputMap.containsKey("NOTI_SEQ") || inputMap.get("NOTI_SEQ").equals("")){
			
			//등록
			//내용유형 : 1 - HTML, 2 - TEXT => 1 로 고정 등록
			inputMap.put("CNTN_TP", "1");
			inputMap.put("REG_PRSN_ID", vo.getUSER_ID());
			
			int regSn = 1;
			
			//공지사항 등록 순번 조회(마지막 등록 번호에서 +1 해서 받아옴)
			List<?> seqList = epmf8149094Mapper.epmf8149094_select1();
			
			for(int i=0;i<seqList.size();i++){
				Map<String, String> rtn = (Map<String, String>) seqList.get(i);
				
				inputMap.put("NOTI_SEQ", String.valueOf(rtn.get("NOTI_SEQ")));
				
			}
			
			//공지사항 등록
			epmf8149094Mapper.epmf8149094_update1(inputMap);
			
			//첨부파일 등록
			while (fileIter.hasNext()) {
				MultipartFile mFile = mptRequest.getFile((String)fileIter.next());
				if (mFile.getSize() > 0) {
					HashMap map = new HashMap();
					try {
						map = EgovFileMngUtil.uploadNotiFile(mFile);
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
					} catch (Exception e) {
						// TODO Auto-generated catch block
						org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
					}	//파일저장
					String fileName = (String)map.get("uploadFileName");
					
					inputMap.put("FILE_NM", (String)map.get("originalFileName"));
					inputMap.put("SAVE_FILE_NM", (String)map.get("uploadFileName"));
					inputMap.put("FILE_PATH", (String)map.get("filePath"));
					inputMap.put("REG_SN", String.valueOf(regSn));
	
					epmf8149094Mapper.epmf8149094_update2(inputMap);
					
					regSn++;
					
				}//if
			}//while
						
		} else {
			
			//수정
			inputMap.put("UPD_PRSN_ID", vo.getUSER_ID());
			//String delSeq = request.getParameter("DEL_SEQ");
			String delSeq = (null == inputMap.get("DEL_SEQ")) ? "" : inputMap.get("DEL_SEQ");
			String[] delSeqList = delSeq.split(",");
			
			//기존 첨부파일 삭제
			for(int i=0; i<delSeqList.length; i++) {
				
				inputMap.put("REG_SN", delSeqList[i]);
				
				//삭제할 첨부파일 이름 조회
				List<?> delFile = epmf8149094Mapper.epmf8149094_select4(inputMap);
				
				for(int j=0;j<delFile.size();j++){
					
					Map<String, String> rtn = (Map<String, String>) delFile.get(j);
					
					inputMap.put("SAVE_FILE_NM", rtn.get("SAVE_FILE_NM"));
					
					try {
						EgovFileMngUtil.deleteNotiFile(inputMap.get("SAVE_FILE_NM"));
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
					} catch (Exception e) {
						// TODO Auto-generated catch block
						org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
					}
					
				}
				
				//첨부파일 테이블 삭제
				epmf8149094Mapper.epmf8149094_delete(inputMap);
				
			}
			
			//공지사항 수정
			epmf8149094Mapper.epmf8149094_update3(inputMap);
			
			//첨부파일 순번 재조정
			
			int regSn = 1;
			
			//공지사항 기존 첨부파일 리스트 조회
			List<?> filePre = epmf8149094Mapper.epmf8149094_select5(inputMap);
			
			for(int i=0;i<filePre.size();i++){
				Map<String, String> rtn = (Map<String, String>) filePre.get(i);
				
				rtn.put("REG_SN", String.valueOf(regSn));
				
				epmf8149094Mapper.epmf8149094_update4(rtn);
				
				regSn++;
			}
			
			//첨부파일 등록
			while (fileIter.hasNext()) {
				MultipartFile mFile = mptRequest.getFile((String)fileIter.next());
				if (mFile.getSize() > 0) {
					HashMap map = new HashMap();
					try {
						map = EgovFileMngUtil.uploadNotiFile(mFile);
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
					} catch (Exception e) {
						// TODO Auto-generated catch block
						org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
					}	//파일저장
					String fileName = (String)map.get("uploadFileName");
					
					inputMap.put("FILE_NM", (String)map.get("originalFileName"));
					inputMap.put("SAVE_FILE_NM", (String)map.get("uploadFileName"));
					inputMap.put("FILE_PATH", (String)map.get("filePath"));
					inputMap.put("REG_SN", String.valueOf(regSn));
					inputMap.put("REG_PRSN_ID", vo.getUSER_ID());
	
					epmf8149094Mapper.epmf8149094_update2(inputMap);
					
					regSn++;
					
				}//if
			}//while
			
		}
		
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
    }
	
}
