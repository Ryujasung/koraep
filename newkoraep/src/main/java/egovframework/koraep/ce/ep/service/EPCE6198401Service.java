package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE6198401Mapper;
  
/**
 * 출고대비초과회수현황 Service  
 * @author 양성수
 *  
 */
@Service("epce6198401Service")  
public class EPCE6198401Service {  
	
	   
	@Resource(name="epce6198401Mapper")
	private EPCE6198401Mapper epce6198401Mapper;  //출고대비초과회수현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 출고대비초과회수현황 초기화면
	 * @param inputMap  
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce6198401_select(ModelMap model, HttpServletRequest request) {
		  
		  
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
		public HashMap epce6198401_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      	rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		    	inputMap.put("BIZR_TP_CD", "");
				rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); 		// 생산자 직매장
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
		public HashMap epce6198401_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
  		try {
				rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
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
		public HashMap epce6198401_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	   
			    	//멀티selectbox 일경우
					List<?> list_m = JSONArray.fromObject(inputMap.get("MFC_LIST"));
					inputMap.put("MFC_LIST", list_m); 
					List<?> list_w = JSONArray.fromObject(inputMap.get("WHSDL_LIST"));
					inputMap.put("WHSDL_LIST", list_w); 
					List<?> list_a = JSONArray.fromObject(inputMap.get("AREA_LIST"));
					inputMap.put("AREA_LIST", list_a); 
					
	    		try {    
	    			if( inputMap.get("CHART_YN") !=null && inputMap.get("CHART_YN").equals("Y")  ){
		    	  		rtnMap.put("selList_chart", util.mapToJson(epce6198401Mapper.epce6198401_select2(inputMap)));	  
		    	  	}
					rtnMap.put("selList", util.mapToJson(epce6198401Mapper.epce6198401_select(inputMap)));
				} catch (Exception e) {
					// TODO Auto-generated catch block
				}	  
	    		//rtnMap.put("totalCnt", epce6198401Mapper.epce6198401_select_cnt(inputMap));
	    	return rtnMap;    	
	    }
		
		/**
		 * 출고대비초과회수현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce6198401_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
				
				//멀티selectbox 일경우
				List<?> list_m = JSONArray.fromObject(data.get("MFC_LIST"));
				data.put("MFC_LIST", list_m); 
    			List<?> list_w = JSONArray.fromObject(data.get("WHSDL_LIST"));
    			data.put("WHSDL_LIST", list_w); 
    			List<?> list_a = JSONArray.fromObject(data.get("AREA_LIST"));
    			data.put("AREA_LIST", list_a); 
				
				//멀티selectbox 일경우
				List<?> list = epce6198401Mapper.epce6198401_select(data);
				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>(); 
				map.put("fileName", data.get("fileName").toString());
				map.put("columns", data.get("columns").toString());
				//엑셀파일 저장
				commonceService.excelSave(request, map, list);
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
		}	
		
}
