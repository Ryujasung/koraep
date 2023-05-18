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
import egovframework.mapper.ce.ep.EPCE6186401Mapper;

/**
 * 회수대비초과반환현황 Service
 * @author 양성수
 *
 */
@Service("epce6186401Service")
public class EPCE6186401Service {  
	
	
	@Resource(name="epce6186401Mapper")
	private EPCE6186401Mapper epce6186401Mapper;  //회수대비초과반환현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 회수대비초과반환현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce6186401_select(ModelMap model, HttpServletRequest request) {
		  
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  	//도매업자구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");			//지역    E002
			List<?>	whsdlList		=commonceService.mfc_bizrnm_select4(request, map);	//도매업자			
			try {
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
		 * 회수대비초과반환현황 도매업자 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce6186401_select2(Map<String, String> inputMap, HttpServletRequest request) {
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
				}	  //빈용기
	      		return rtnMap;    	
	    }
		
		/**
		 * 회수대비초과반환현황  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce6186401_select3(Map<String, Object> inputMap, HttpServletRequest request) {
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	System.out.println("HI SERVICE");
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			//로그인자가 센터일경우
			System.out.println("vo"+vo);
			if(vo != null ){
				inputMap.put("T_USER_ID", vo.getUSER_ID());
			}
	    	
			List<?> list_w = JSONArray.fromObject(inputMap.get("WHSDL_LIST"));
			System.out.println("list_w"+list_w);
			inputMap.put("WHSDL_LIST", list_w); 
			List<?> list_a = JSONArray.fromObject(inputMap.get("AREA_LIST"));
			System.out.println("list_w"+list_a);
			inputMap.put("AREA_LIST", list_a); 
			
			System.out.println(inputMap +"sdasd");
    		try {
    		
    			if( inputMap.get("CHART_YN") !=null && inputMap.get("CHART_YN").equals("Y")  ){
	    	  		rtnMap.put("selList_chart", util.mapToJson(epce6186401Mapper.epce6186401_select2(inputMap)));	  
	    	  	}
				rtnMap.put("selList", util.mapToJson(epce6186401Mapper.epce6186401_select(inputMap)));
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
		 * 회수대비초과반환현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce6186401_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			//로그인자가 센터일경우
			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}
			
			try {
				//멀티selectbox 일경우
				List<?> list_w = JSONArray.fromObject(data.get("WHSDL_LIST"));
    			data.put("WHSDL_LIST", list_w); 
    			List<?> list_a = JSONArray.fromObject(data.get("AREA_LIST"));
    			data.put("AREA_LIST", list_a); 
				
				List<?> list = epce6186401Mapper.epce6186401_select(data);
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
