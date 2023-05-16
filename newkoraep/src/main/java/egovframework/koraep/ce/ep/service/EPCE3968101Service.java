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
import egovframework.mapper.ce.ep.EPCE3944888Mapper;
import egovframework.mapper.ce.ep.EPCE3944801Mapper;
import egovframework.mapper.ce.ep.EPCE3968101Mapper;


/**
 *  기타코드관리 Service
 * @author 양성수
 *
 */
@Service("epce3968101Service")
public class EPCE3968101Service {

	@Resource(name="epce3968101Mapper")
	private EPCE3968101Mapper epce3968101Mapper;  //기타코드관리 Mapper
	
	@Resource(name="epce3944801Mapper")
	private EPCE3944801Mapper epce3944801Mapper; //다국어관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 *  기타코드관리 초기 셋팅값
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3968101_select(ModelMap model, HttpServletRequest request)  {
		Map<String, String> map = new HashMap<String, String>();
		//언어구분 리스트
		List<?> lang_se_cd_list = commonceService.getLangSeCdList();
		
		try {
			model.addAttribute("lang_se_cd_lst", util.mapToJson(lang_se_cd_list));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
	}
	/**
	 *  기타코드관리 그룹코드 저장 수정여부 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public String epce3968101_select2(Map<String, String> data, HttpServletRequest request)  {
		
		String errCd = "0000";
		try {
			int sel_rst =epce3968101Mapper.epce3968101_select2(data);  
          if(sel_rst>0){
        	  errCd ="A003";
          }
		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		return errCd;
	}
	
	/**
	 * 기타코드관리 그룹코드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce3968101_select3(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
			rtnMap.put("etc_cd_grp_lst", util.mapToJson(epce3968101Mapper.epce3968101_select(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    
		return rtnMap;    	
    }
	
	
	/**
	 * 기타코드관리 상세코드 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce3968101_select4(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
			rtnMap.put("etc_cd_dtl_lst", util.mapToJson(epce3968101Mapper.epce3968101_select3(inputMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    
		return rtnMap;    	
    }
	
	/**
	 *  기타코드관리 상세코드 저장 수정여부 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public String epce3968101_select5(Map<String, String> data, HttpServletRequest request)  {
		
		String errCd = "0000";
		try {
			int sel_rst =epce3968101Mapper.epce3968101_select4(data);  
          if(sel_rst>0){
        	  errCd ="A003";
          }
		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		return errCd;
	}
	
	/**
	 * 기타코드관리 그룹코드 저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3968101_insert(Map<String, String> data, HttpServletRequest request) throws Exception  {
		
		String errCd = "0000";
		try {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			data.put("RGST_PRSN_ID"    ,vo.getUSER_ID());
			
			if("S".equals(data.get("SAVE_CHK"))){  // 그룹저장
			  epce3968101Mapper.epce3968101_insert(data);
			}else{   //그룹수정
			  epce3968101Mapper.epce3968101_update(data);
			}
			
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
	/**
	 * 기타코드관리 상세코드 저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3968101_insert2(Map<String, String> data, HttpServletRequest request) throws Exception  {
		
		String errCd = "0000";
		try {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			data.put("RGST_PRSN_ID"    ,vo.getUSER_ID());
	
			

           System.out.println("--------------------------------------------------------------------------------------");
			for (String mapkey :data.keySet()){
				System.out.println("key:                                 "+mapkey+",  value:                                    "+data.get(mapkey));
		    }	
			System.out.println("--------------------------------------------------------------------------------------");	
			
			
		 if("U".equals(data.get("SEL_ORD_CHK"))){  
			 System.out.println("상대순번병경");
    	   epce3968101Mapper.epce3968101_update3(data); //상대 순번 변경
		 }
         
         if("S".equals(data.get("SAVE_CHK"))){  // 상세코드저장
        	 System.out.println("상세코드 저장");
        	 epce3968101Mapper.epce3968101_insert2(data);
         }else if("U".equals(data.get("SAVE_CHK"))){   //상세코드수정
        	 
        	 System.out.println("상세코드 수정");
        	 epce3968101Mapper.epce3968101_update2(data);
         }
			
			
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
	
	
}
