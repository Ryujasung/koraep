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
import egovframework.mapper.ce.ep.EPCE3965701Mapper;


/**
 * 오류코드 Service
 * @author 양성수
 *
 */
@Service("epce3965701Service")
public class EPCE3965701Service {

	@Resource(name="epce3965701Mapper")
	private EPCE3965701Mapper epce3965701Mapper; //다국어관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	

    /**
     * 오류코드페이지 초기값 셋팅
     * @param model
     * @param request
     * @return
     * @
     */
	public ModelMap epce3965701_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		List<?> langSeList     = commonceService.getLangSeCdList();                     // 언어코드
		
		map = (HashMap<String, String>)langSeList.get(0);
		map.put("GRP_CD", "S002");
		
		List<?> menuSetList  = commonceService.getCommonCdListNew2(map);   // 기타코드 오류구분코드 

		try {
			model.addAttribute("err_cd_list", util.mapToJson(menuSetList));
			model.addAttribute("lang_se_cd_list", util.mapToJson(langSeList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		
	return model;
	}
	
	/**
	 * 오류코드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce3965701_select2(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
			rtnMap.put("err_cd_sel_list", util.mapToJson(epce3965701Mapper.epce3965701_select(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    
		return rtnMap;    	
    }
	
	/**
	 * 언어구분 변경시 언어에 맞는 오류구분으로  변경
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce3965701_select3(HashMap<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	inputMap.put("GRP_CD", "S002");
    
    	try {
			rtnMap.put("err_cd_sel_list", util.mapToJson(commonceService.getCommonCdListNew2(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    
		return rtnMap;    	
    }
	
	/**
	 * 오류코드 조회시 입력값이 있을경우 수정 없을경우 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
public String epce3965701_select4(Map<String, String> data, HttpServletRequest request)  {
	
	String errCd = "0000";
	try {
		int sel_rst =epce3965701Mapper.epce3965701_select2(data);  
      if(sel_rst>0){
    	  errCd ="A003";
      }
	}catch(Exception e){
		return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
	}
	return errCd;
}

/**
 * 오류코드관리  저장 및 수정
 * @param data
 * @param request
 * @return
 * @throws Exception 
 * @
 */
public String epce3965701_insert(Map<String, String> data, HttpServletRequest request) throws Exception  {
	
	String errCd = "0000";
	try {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		data.put("RGST_PRSN_ID"    ,vo.getUSER_ID());
	
		if("S".equals(data.get("SAVE_CHK"))){  
			System.out.println("저장");
			epce3965701Mapper.epce3965701_insert(data);    //오류코드 저장
		}else{   
			System.out.println("수정");
			epce3965701Mapper.epce3965701_update(data);  //오류코드 수정
		}
		
	}catch(Exception e){
		throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
	}
	
	return errCd;
	
}	
	
}
