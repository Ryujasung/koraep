package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE3951201Mapper;


/**
 * 표준용기코드관리  Service
 * @author 양성수
 *
 */
@Service("epce3951201Service")
public class EPCE3951201Service {
	
	@Resource(name="epce3951201Mapper")
	private EPCE3951201Mapper epce3951201Mapper;  //표준용기코드관리 Mapper
	  
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통 Mapper
	
	
	/**
	 * 표준용기코드관리 초기값 셋팅
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3951201_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> inputMap = new HashMap<String, String>();
    	
		HashMap<String, String> map = new HashMap<String, String>();
		List<?> langSeList     = commonceService.getLangSeCdList();                     // 언어코드
		map = (HashMap<String, String>)langSeList.get(0);                                   // 표준인놈으로 기타코드 가져오기
		map.put("GRP_CD", "E001");   
		List<?> cpctCdList  = commonceService.getCommonCdListNew2(map);   // 기타코드 용량코드

		map.put("GRP_CD", "E002");
		List<?> prpsCdList  = commonceService.getCommonCdListNew2(map);   // 기타코드 용어코드
		
		map.put("GRP_CD", "E003");
		List<?> mfcSeCdList  = commonceService.getCommonCdListNew2(map);   // 기타코드 생산자구분
		
		map.put("GRP_CD", "E004");
		List<?> alkndCdList  = commonceService.getCommonCdListNew2(map);   // 기타코드 주종구분
		
		
		try {
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
			model.addAttribute("alkndCdList", util.mapToJson(alkndCdList));
			model.addAttribute("cpctCdList", util.mapToJson(cpctCdList));
			model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));
			model.addAttribute("langSeList", util.mapToJson(langSeList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
       // List<?> stdCtnrList =	epce3951201Mapper.epce3951201_select(inputMap);
	   // model.addAttribute("stdCtnrList", util.mapToJson(stdCtnrList));  
	
		return model;
		
	}
	
	/**
	 * 표준용기코드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce3951201_select2(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
			rtnMap.put("stdCtnrList", util.mapToJson(epce3951201Mapper.epce3951201_select(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    
		return rtnMap;    	
    }
	
	
	/**
	 * 표준용기코드 조회시 입력값이 있을경우 수정 없을경우 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
public String epce3951201_select3(Map<String, String> data, HttpServletRequest request)  {
	
	String errCd = "0000";
	try {
		int sel_rst =epce3951201Mapper.epce3951201_select2(data);  
		
		
      if(sel_rst>0){
    	  errCd ="A003";
      }
	}catch(Exception e){
		return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
	}

	return errCd;
}
	
/**
 * 표준용기코드관리  저장 및 수정
 * @param data
 * @param request
 * @return
 * @throws Exception 
 * @
 */
public String epce3951201_insert(Map<String, String> data, HttpServletRequest request) throws Exception  {
	
	String errCd = "0000";
	try {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		data.put("RGST_PRSN_ID"    ,vo.getUSER_ID());
	
		if("S".equals(data.get("SAVE_CHK"))){  
			epce3951201Mapper.epce3951201_insert(data);    //표준용기 저장
		}else{   
			epce3951201Mapper.epce3951201_update(data);  //표준용기 수정
		}
		
	}catch(Exception e){
		throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
	}
	return errCd;	
}
	
}
