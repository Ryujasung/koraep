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
import egovframework.mapper.ce.ep.EPCE6186201Mapper;
  
/**
 * 주간누계 Service  
 * @author 이내희
 *  
 */
@Service("epce6186201Service")  
public class EPCE6186201Service {  
	
	   
	@Resource(name="epce6186201Mapper")
	private EPCE6186201Mapper epce6186201Mapper;  //주간누계 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 주간누계 초기화면
	 * @param inputMap  
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce6186201_select(ModelMap model, HttpServletRequest request) {

			Map<String, String> map= new HashMap<String, String>();		
			
			try {
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
			}	
			return model;    	
	    }
	  		
		/**   
		 * 주간누계현황 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @   
		 */   
		public HashMap epce6186201_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    		try {    

    			List<?> list = null;
    			list = epce6186201Mapper.epce6186201_select(inputMap);

				rtnMap.put("selList", util.mapToJson(list));
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
			}	  

	    	return rtnMap;    	
	    }
		
		/**
		 * 주간누계현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce6186201_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
					
				List<?> list = epce6186201Mapper.epce6186201_select(data);

				//엑셀파일 저장
				commonceService.excelSave(request, data, list);

			}catch(Exception e){
				return  "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}
}
