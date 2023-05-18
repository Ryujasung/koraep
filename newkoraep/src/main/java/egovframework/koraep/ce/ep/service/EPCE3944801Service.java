package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
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

/**
 * 다국어관리 Service
 * @author 양성수
 * 
 */
@Service("epce3944801Service")
public class EPCE3944801Service {
	                    
	@Resource(name="epce3944801Mapper")
	private EPCE3944801Mapper epce3944801Mapper; //다국어관리 Mapper
	
	@Resource(name="epce3944888Mapper")
	private EPCE3944888Mapper epce3944888Mapper;  //언어구분관리 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;
	/**
	 * 다국어관리 초기 셋팅값
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3944801_select(ModelMap model, HttpServletRequest request) {
		
		Map<String, String> map = new HashMap<String, String>();
		Map<String, String> map2 = new HashMap<String, String>();
		String selectLangSeCe ="";
		//언어구분 리스트
		List<?> lang_se_cd_list = commonceService.getLangSeCdList();
		map = (Map<String, String>)lang_se_cd_list.get(0);
	    map.put("LANG_GRP_CD","");
	    map.put("LANG_NM","");

		//용어구분
		List<?> lang_grp_cd_list =  epce3944801Mapper.epce3944801_select(map);
		List<?> lang_info_list     =  epce3944801Mapper.epce3944801_select2(map);
		
		try {
			model.addAttribute("lang_se_cd_list", util.mapToJson(lang_se_cd_list));     //언어구분코드
			model.addAttribute("lang_grp_cd_list", util.mapToJson(lang_grp_cd_list));  //용어구분
			model.addAttribute("lang_info_list", util.mapToJson(lang_info_list));
		} catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
		
	}
	
	/**
	 * 언어구분 SELECTBOX 변경시  용어구분 값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce3944801_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	   
	    	try {
				rtnMap.put("lang_grp_cd_list", util.mapToJson(epce3944801Mapper.epce3944801_select(inputMap)));
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
			
			return rtnMap;    	
	  }
	
	     
		/**
		 * 다국어관리 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
	public HashMap epce3944801_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
				rtnMap.put("lang_info_list", util.mapToJson(epce3944801Mapper.epce3944801_select2(inputMap)));
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
			return rtnMap;    	
	    }
		  
		  
	  /**
		 * 다국어관리 조회시 입력값이 있을경우 수정 없을경우 저장
		 * @param data
		 * @param request
		 * @return
		 * @
		 */
	public String epce3944801_select4(Map<String, String> data, HttpServletRequest request)  {
		
		String errCd = "0000";
		try {
	
			int sel_rst =epce3944801Mapper.epce3944801_select3(data);  
          if(sel_rst>0){
        	  errCd ="A003";
          }
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		return errCd;
	}
  

	  /**
		 * 다국어관리 저장
		 * @param data
		 * @param request
		 * @return
	 * @throws Exception 
		 * @
		 */
	public String epce3944801_insert(Map<String, String> data, HttpServletRequest request) throws Exception  {
			
			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				data.put("RGST_PRSN_ID"    ,vo.getUSER_ID());
				
				epce3944801Mapper.epce3944801_insert(data);
				
				//다국어 조회 데이터 초기화
				util.setLANG_CD_LIST(null);
				
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

		 /**
		 * 다국어관리 수정
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	public String epce3944801_update(Map<String, String> data, HttpServletRequest request) throws Exception  {
			
			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				data.put("UPD_PRSN_ID"    ,vo.getUSER_ID());

				epce3944801Mapper.epce3944801_update(data);
				
				//다국어 조회 데이터 초기화
				util.setLANG_CD_LIST(null);
				
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
