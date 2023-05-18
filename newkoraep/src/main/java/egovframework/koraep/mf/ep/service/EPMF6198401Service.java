package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF6198401Mapper;
  
/**
 * 출고대비초과회수현황 Service  
 * @author 양성수
 *  
 */
@Service("epmf6198401Service")  
public class EPMF6198401Service {  
	
	   
	@Resource(name="epmf6198401Mapper")
	private EPMF6198401Mapper epmf6198401Mapper;  //출고대비초과회수현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 출고대비초과회수현황 초기화면
	 * @param inputMap  
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf6198401_select(ModelMap model, HttpServletRequest request) {
		  
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
			List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역    E002
			List<?>	whsdlList		=commonceService.mfc_bizrnm_select4(request, map);				//도매업					
			
			try {
				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
				model.addAttribute("areaList", util.mapToJson(areaList));	
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block

			}	
			return model;    	
	    }
	  
		/**  
		 * 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회   
		 * @param inputMap     
		 * @param request     
		 * @return     
		 * @   
		 */   
		public HashMap epmf6198401_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      	rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		    	inputMap.put("BIZR_TP_CD", "");
				rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); 		// 생산자 직매장
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 //사업자 직매장/공장 조회	
			return rtnMap;    	  
	    }
	    
		/**    
		 * 업체명 조회   
		 * @param inputMap  
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf6198401_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
  		try {
				rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  //업체명 조회	
			return rtnMap;    	     
	    }
		  
		/**   
		 * 출고대비초과회수현황  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @   
		 */   
		public HashMap epmf6198401_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	   
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			inputMap.put("MFC_BIZRID", vo.getBIZRID());
			inputMap.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				inputMap.put("S_BRCH_ID", vo.getBRCH_ID());
				inputMap.put("S_BRCH_NO", vo.getBRCH_NO());
			}
	    	
	    		try {    
	    			if( inputMap.get("CHART_YN") !=null && inputMap.get("CHART_YN").equals("Y")  ){
		    	  		rtnMap.put("selList_chart", util.mapToJson(epmf6198401Mapper.epmf6198401_select2(inputMap)));	  
		    	  	}
					rtnMap.put("selList", util.mapToJson(epmf6198401Mapper.epmf6198401_select(inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block

				}	  
	    		//rtnMap.put("totalCnt", epmf6198401Mapper.epmf6198401_select_cnt(inputMap));
	    	return rtnMap;    	
	    }
		
		/**
		 * 출고대비초과회수현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf6198401_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
				
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				data.put("MFC_BIZRID", vo.getBIZRID());
				data.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
				if(!vo.getBRCH_NO().equals("9999999999")){
					data.put("S_BRCH_ID", vo.getBRCH_ID());
					data.put("S_BRCH_NO", vo.getBRCH_NO());
				}
				
				//멀티selectbox 일경우
				List<?> list = epmf6198401Mapper.epmf6198401_select(data);
				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>(); 
				map.put("fileName", data.get("fileName").toString());
				map.put("columns", data.get("columns").toString());
				//엑셀파일 저장
				commonceService.excelSave(request, map, list);
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
