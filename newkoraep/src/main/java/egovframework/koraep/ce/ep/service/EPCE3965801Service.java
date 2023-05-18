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
import egovframework.mapper.ce.ep.CommonCeMapper;
import egovframework.mapper.ce.ep.EPCE3965801Mapper;


/**
 * 생산자제품코드관리 Service
 * @author 유병승
 *
 */
@Service("epce3965801Service")
public class EPCE3965801Service {

	@Resource(name="epce3965801Mapper")
	private EPCE3965801Mapper epce3965801Mapper; //다국어관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="commonceMapper")
	private CommonCeMapper commonceMapper;
	

    /**
     * 생산자제품코드관리페이지 초기값 셋팅
     * @param model
     * @param request
     * @return
     * @
     */
	public ModelMap epce3965801_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		List<?> mfc_bizrnm_sel = commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스

		try {
			model.addAttribute("mfc_bizrnm_sel", util.mapToJson(mfc_bizrnm_sel));	//생산자구분 리스트
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
		
		
	return model;
	}
	
	/**
	 * 생산자제품코드관리 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce3965801_select2(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {
			rtnMap.put("err_cd_sel_list", util.mapToJson(epce3965801Mapper.epce3965801_select(inputMap)));
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
	 * 빈용기 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce3965801_select3(HashMap<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	try {	
    		if(null != inputMap){
	            
	            //생산자코드 조회
	            String bizr_tp_cd = commonceMapper.bizr_tp_cd_select((HashMap<String, String>) inputMap);
	         
	            //생산자 기타코드(소주표준화병 제외하기 위해 처리) 
	            //W1 주류 생산자 W2 음료생산자
	            if(bizr_tp_cd == null || bizr_tp_cd.equals("")){
	            	//빈용기명 조회
			       	 rtnMap.put("ctnr_nm", "");
	            }else{
	            	if(bizr_tp_cd.equals("M2")){
	                	inputMap.put("BIZR_TP_CD", "M2");
	                } else {
	                	inputMap.put("BIZR_TP_CD", "M1");
	                }
	            	
			        //빈용기명 조회
			       	rtnMap.put("ctnr_nm", util.mapToJson(epce3965801Mapper.epce3965801_select5(inputMap)));
	            }
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
		return rtnMap;    	
    }
	
	/**
	 * 생산자제품코드관리 조회시 입력값이 있을경우 수정 없을경우 저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public String epce3965801_select4(Map<String, String> data, HttpServletRequest request)  {
		String errCd = "0000";
		try {
			int sel_rst = epce3965801Mapper.epce3965801_select2(data);  
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
	 * 생산자제품코드관리관리  저장 및 수정
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce3965801_insert(Map<String, String> data, HttpServletRequest request) throws Exception  {
		String errCd = "0000";
		try {
			if("S".equals(data.get("SAVE_CHK"))){  
				epce3965801Mapper.epce3965801_insert(data);    //생산자제품코드관리 저장
			}else{   
				epce3965801Mapper.epce3965801_update(data);  //생산자제품코드관리 수정
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
