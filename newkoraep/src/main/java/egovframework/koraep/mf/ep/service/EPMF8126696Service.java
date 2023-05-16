package egovframework.koraep.mf.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.mf.ep.EPMF8126696Mapper;

/**
 * 문의/답변 등록 Service
 * @author pc
 *
 */
@Service("epmf8126696Service")
public class EPMF8126696Service {
	
	@Resource(name="epmf8126696Mapper")
	private EPMF8126696Mapper epmf8126696Mapper;
	
	/**
	 * 문의/답변 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf8126696(ModelMap model, HttpServletRequest request)  {
		
		List<?> askInfo = null;
		
		if(null != request.getParameter("ASK_SEQ")){
			
			Map<String, String> inputMap = new HashMap<String, String>();
			
			inputMap.put("ASK_SEQ", request.getParameter("ASK_SEQ"));
			inputMap.put("CNTN_SE", request.getParameter("CNTN_SE"));
			
			//문의/답변 상세조회
			askInfo = epmf8126696Mapper.epmf8126696_select1(inputMap);
			
			if(0 == askInfo.size()){
				
				model.addAttribute("CNTN_SE", request.getParameter("CNTN_SE"));
				model.addAttribute("ASK_SEQ", request.getParameter("ASK_SEQ"));
			} else {
				
				for(int i=0;i<askInfo.size();i++){
					Map<String, String> rtn = (Map<String, String>) askInfo.get(i);
					//rtn.put("CNTN", XSSFilter.getFilter(rtn.get("CNTN")));
					model.addAttribute("CNTN_SE", rtn.get("CNTN_SE"));
					
				}
				
			}
			
		} else {
			
			model.addAttribute("CNTN_SE", "Q");
			
		}
		
		if(null == askInfo) {
			model.addAttribute("askInfo", "{}");
		} else {
			try {
				model.addAttribute("askInfo", util.mapToJson(askInfo));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
		}
		
		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}
	
	/**
	 * 문의/답변 등록 및 수정
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional
	public String epmf8126696_update(HashMap<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		
		if(!inputMap.containsKey("ASK_SEQ") || inputMap.get("ASK_SEQ").equals("")){
			
			//문의등록
			
			//내용유형 : 1 - HTML, 2 - TEXT => 1 로 고정 등록
			inputMap.put("CNTN_TP", "1");
			inputMap.put("REG_PRSN_ID", vo.getUSER_ID());
			inputMap.put("CNTN_SE", "Q");
			
			//문의 등록 순번 조회(마지막 등록 번호에서 +1 해서 받아옴)
			List<?> seqList = epmf8126696Mapper.epmf8126696_select2();
			
			for(int i=0;i<seqList.size();i++){
				Map<String, String> rtn = (Map<String, String>) seqList.get(i);
				
				inputMap.put("ASK_SEQ", String.valueOf(rtn.get("ASK_SEQ")));
			}
			
			//문의 등록
			epmf8126696Mapper.epmf8126696_update1(inputMap);

		} else {
			
			inputMap.put("ASK_SEQ", request.getParameter("ASK_SEQ"));
			inputMap.put("CNTN_SE", request.getParameter("CNTN_SE"));
			
			//답변 등록인지 수정인지 확인
			List<?> chkAnsr = epmf8126696Mapper.epmf8126696_select3(inputMap);
			
			if(0 == chkAnsr.size()){
				
				//답변 등록
				
				//내용유형 : 1 - HTML, 2 - TEXT => 1 로 고정 등록
				inputMap.put("CNTN_TP", "1");
				inputMap.put("REG_PRSN_ID", vo.getUSER_ID());
				
				//답변 등록
				epmf8126696Mapper.epmf8126696_update2(inputMap);
				
			} else {
			
				//수정
				inputMap.put("UPD_PRSN_ID", vo.getUSER_ID());
				
				//공지사항 수정
				epmf8126696Mapper.epmf8126696_update3(inputMap);
			
			}
			
		}

		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
    }

}
