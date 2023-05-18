package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE6110401Mapper;

/**
 * 입고현황 Service
 * @author 양성수
 *
 */
@Service("epce6110401Service")
public class EPCE6110401Service {  
	
	
	@Resource(name="epce6110401Mapper")
	private EPCE6110401Mapper epce6110401Mapper;  //입고현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 입고현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce6110401_select(ModelMap model, HttpServletRequest request) {

		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			List<?> ctnr_cd			= commonceService.ctnr_nm_select2(request, map);		//빈용기명 조회
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 		//생산자
			List<?> whsl_se_cdList = commonceService.whsdl_se_select(request, map);		//도매업자구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");			//지역    E002
			List<?>	whsdlList		=commonceService.mfc_bizrnm_select4(request, map);	//도매업자	
			List<?> ctnrSe = commonceService.getCommonCdListNew("E005"); //빈용기구분 구/신
			List<?> prpsCdList	 = commonceService.getCommonCdListNew("E002"); //용도
			List<?> alkndCdList	 = commonceService.getCommonCdListNew("E004"); //주종

			try {
				model.addAttribute("ctnrSe", util.mapToJson(ctnrSe));
				model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));	
				model.addAttribute("alkndCdList", util.mapToJson(alkndCdList));	
				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
				model.addAttribute("areaList", util.mapToJson(areaList));	
				model.addAttribute("ctnr_cd", util.mapToJson(ctnr_cd));
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
		 * 입고현황 생산자변경시  생산자에맞는 빈용기명  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce6110401_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	      		
	    		try {
	    			rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 도매업자 업체명조회
					rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap))); //빈용기
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
				}	 
	      		return rtnMap;    	
	    }
		/**
		 * 입고현황 생산자변경시  생산자에맞는 빈용기명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce6110401_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
					rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
				}	  //빈용기
	      		return rtnMap;    	  
	    }        
		    
		/**   
		 * 입고현황  조회
		 * @param inputMap  
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce6110401_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			//로그인자가 센터일경우
			if(vo != null ){
				inputMap.put("T_USER_ID", vo.getUSER_ID());
			}
	    	
	    		try {
	    			//멀티selectbox 일경우
	    			List<?> list_m = JSONArray.fromObject(inputMap.get("MFC_LIST"));
	    			inputMap.put("MFC_LIST", list_m); 
	    			List<?> list_c = JSONArray.fromObject(inputMap.get("CTNR_LIST"));
	    			inputMap.put("CTNR_LIST", list_c); 
	    			List<?> list_w = JSONArray.fromObject(inputMap.get("WHSDL_LIST"));
	    			inputMap.put("WHSDL_LIST", list_w); 
	    			List<?> list_a = JSONArray.fromObject(inputMap.get("AREA_LIST"));
	    			inputMap.put("AREA_LIST", list_a); 
	    			
	    			if( inputMap.get("CHART_YN") !=null && inputMap.get("CHART_YN").equals("Y")  ){
		    	  		rtnMap.put("selList_chart", util.mapToJson(epce6110401Mapper.epce6110401_select2(inputMap)));	  
		    	  	}
					rtnMap.put("selList", util.mapToJson(epce6110401Mapper.epce6110401_select(inputMap)));
					
					rtnMap.put("totalList", epce6110401Mapper.epce6110401_select_cnt(inputMap));
					
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
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
		public String epce6110401_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			//로그인자가 센터일경우
			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}
			
			String errCd = "0000";
			try {
				//멀티selectbox 일경우
				List<?> list_m = JSONArray.fromObject(data.get("MFC_LIST"));
				data.put("MFC_LIST", list_m); 
    			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
    			data.put("CTNR_LIST", list_c); 
    			List<?> list_w = JSONArray.fromObject(data.get("WHSDL_LIST"));
    			data.put("WHSDL_LIST", list_w); 
    			List<?> list_a = JSONArray.fromObject(data.get("AREA_LIST"));
    			data.put("AREA_LIST", list_a); 
    			
				
				List<?> list = epce6110401Mapper.epce6110401_select(data);
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
