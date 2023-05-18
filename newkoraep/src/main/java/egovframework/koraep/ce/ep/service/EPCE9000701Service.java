package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE9000701Mapper;
import net.sf.json.JSONObject;

/**
 * 지역별출고회수현황 Service
 * @author 양성수
 *
 */
@Service("epce9000701Service")
public class EPCE9000701Service {


	@Resource(name="epce9000701Mapper")
	private EPCE9000701Mapper epce9000701Mapper;  //지역별출고회수현황 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 지역별출고회수현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce9000701_select(ModelMap model, HttpServletRequest request) {
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			Map<String, String> map= new HashMap<String, String>();
			//List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);//도매업자구분
			List<?> areaList = commonceService.getCommonCdListNew("B010");//지역    E002
			try {
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
		 * 지역별출고회수현황  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce9000701_select2(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	List<?> searchList = new ArrayList<Object>();
	    	
    		try {
    			if(inputMap.containsKey("AREA_CD")) {
    				searchList = epce9000701Mapper.epce9000701_select2(inputMap);
    			}
    			else {
    				searchList = epce9000701Mapper.epce9000701_select(inputMap);
    			}
    			
				rtnMap.put("selList", util.mapToJson(searchList));
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
		 * 월별 회수량  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public ModelMap epce9000761_select(ModelMap model, HttpServletRequest request) {
			
			
try {
	String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
	JSONObject jParams = JSONObject.fromObject(reqParams);
	model.addAttribute("INQ_PARAMS", jParams);
	
	
	List<Map<String, Object>> list = epce9000701Mapper.epce9000761_select();
	model.addAttribute("obj", list);
//	Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
//	model.addAttribute("titleSub", commonceService.getMenuTitle("EPCE6187261"));
//	model.addAttribute("obj", util.mapToJson(epce9000701Mapper.epce9000761_select(map)));
}catch (IOException io) {
	System.out.println(io.toString());
}catch (SQLException sq) {
	System.out.println(sq.toString());
}catch (NullPointerException nu){
	System.out.println(nu.toString());
} catch (Exception e) {
	/*e.printStackTrace();*/
	//취약점점검 6334 기원우
}
			

			return model;
		}
}
