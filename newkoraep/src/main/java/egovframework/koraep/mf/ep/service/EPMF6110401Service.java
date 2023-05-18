package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF6110401Mapper;

/**
 * 입고현황 Service
 * @author 양성수
 *
 */
@Service("epmf6110401Service")
public class EPMF6110401Service {  
	
	
	@Resource(name="epmf6110401Mapper")
	private EPMF6110401Mapper epmf6110401Mapper;  //입고현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 입고현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf6110401_select(ModelMap model, HttpServletRequest request) {
		  
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			List<?> ctnr_cd			= commonceService.ctnr_nm_select2(request, map);					//빈용기명 조회
			List<?> prps_cd			= commonceService.getCommonCdListNew("E002");		//빈용기구분 유흥/가정/직접 조회
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
			List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역    E002
			String   title					= commonceService.getMenuTitle("EPMF6110401");		//타이틀
			List<?>	whsdlList		=commonceService.mfc_bizrnm_select4(request, map);				//도매업					
			
			try {
				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
				model.addAttribute("areaList", util.mapToJson(areaList));	
				model.addAttribute("prps_cd", util.mapToJson(prps_cd));	
				model.addAttribute("ctnr_cd", util.mapToJson(ctnr_cd));
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
			model.addAttribute("titleSub", title);
			return model;    	
	    }
	  
		/**
		 * 입고현황 생산자변경시  생산자에맞는 빈용기명  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf6110401_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	      		
	    		try {
	    			rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 도매업자 업체명조회
					rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  //빈용기
	      		return rtnMap;    	
	    }
		/**
		 * 입고현황 생산자변경시  생산자에맞는 빈용기명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf6110401_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
					rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap))); //빈용기
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
		 * 입고현황  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf6110401_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				inputMap.put("MFC_BIZRID", vo.getBIZRID());  					
				inputMap.put("MFC_BIZRNO", vo.getBIZRNO_ORI());  
				if(!vo.getBRCH_NO().equals("9999999999")){
					inputMap.put("S_BRCH_ID", vo.getBRCH_ID());  					
					inputMap.put("S_BRCH_NO", vo.getBRCH_NO()); 
				}
			}
			
	    		try {
	    			if( inputMap.get("CHART_YN") !=null && inputMap.get("CHART_YN").equals("Y")  ){
		    	  		rtnMap.put("selList_chart", util.mapToJson(epmf6110401Mapper.epmf6110401_select2(inputMap)));	  
		    	  	}
		    	
		    		rtnMap.put("selList", util.mapToJson(epmf6110401Mapper.epmf6110401_select(inputMap)));	  
					rtnMap.put("totalList", epmf6110401Mapper.epmf6110401_select_cnt(inputMap));
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
		 * 입고현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf6110401_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {

				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				if(vo != null){
					data.put("MFC_BIZRID", vo.getBIZRID());  					
					data.put("MFC_BIZRNO", vo.getBIZRNO_ORI());  
					if(!vo.getBRCH_NO().equals("9999999999")){
						data.put("S_BRCH_ID", vo.getBRCH_ID());  					
						data.put("S_BRCH_NO", vo.getBRCH_NO()); 
					}
				}
				
				List<?> list = epmf6110401Mapper.epmf6110401_select(data);
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);
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
		
}
