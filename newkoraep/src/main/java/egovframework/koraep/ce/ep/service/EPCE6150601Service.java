package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE6150601Mapper;

/**
 * 직접회수현황 Service
 * @author 이내희
 *
 */
@Service("epce6150601Service")
public class EPCE6150601Service {  
	
	@Resource(name="epce6150601Mapper")
	private EPCE6150601Mapper epce6150601Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 직접회수현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce6150601_select(ModelMap model, HttpServletRequest request) {
		  
		  Map<String, String> map = new HashMap<String, String>();
		  
			
			try {
				List<?> ctnrSe = commonceService.getCommonCdListNew("E005"); //빈용기구분 구/신
				model.addAttribute("ctnrSe", util.mapToJson(ctnrSe));
				
				List<?> prpsCdList	 = commonceService.getCommonCdListNew("E002"); //용도
				model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));	
				
				List<?> alkndCdList	 = commonceService.getCommonCdListNew("E004"); //주종
				model.addAttribute("alkndCdList", util.mapToJson(alkndCdList));	
				
				List<?> statCdList	 = commonceService.getCommonCdListNew("D012"); //상태
				model.addAttribute("statCdList", util.mapToJson(statCdList));	
				
				List<?> mfcBizrList = commonceService.mfc_bizrnm_select(request); // 생산자
				model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	
				
				List<?> ctnrNmList = commonceService.ctnr_nm_select2(request, map); //빈용기명
				model.addAttribute("ctnrNmList", util.mapToJson(ctnrNmList));	
								
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
						
			return model;    	
	    }

	  /**
	   * 직접회수현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epce6150601_select2(Map<String, Object> data) {

			
			String BRCH_ID_NO = data.get("MFC_BRCH_NM").toString();
			if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
				data.put("BRCH_ID", BRCH_ID_NO.split(";")[0]);
				data.put("BRCH_NO", BRCH_ID_NO.split(";")[1]);
			}
			//멀티selectbox 일경우
			List<?> list_m = JSONArray.fromObject(data.get("MFC_LIST"));
			data.put("MFC_LIST", list_m); 
			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
			data.put("CTNR_LIST", list_c); 
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			List<?> list = epce6150601Mapper.epce6150601_select(data);
			try {
				map.put("searchList", util.mapToJson(list));
				if(data.get("CHART_YN") != null && data.get("CHART_YN").equals("Y")){
					List<?> list2 = epce6150601Mapper.epce6150601_select2(data);
					map.put("searchList2", util.mapToJson(list2));
				}
				
				map.put("totalList", epce6150601Mapper.epce6150601_select_cnt(data));
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
						
			return map;
  	  }
	  
	  /**
		 * 생산자변경시 직매장 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce6150601_select3(Map<String, String> inputMap, HttpServletRequest request) {
			
	    		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		
	    		
	    		try {
					rtnMap.put("mfcBrchList", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); //직매장
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	 
	    		
	      		return rtnMap;    	
	    }
		
		/**
		 * 직접회수현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce6150601_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
				
				//멀티selectbox 일경우
				List<?> list_m = JSONArray.fromObject(data.get("MFC_LIST"));
				data.put("MFC_LIST", list_m); 
				List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
				data.put("CTNR_LIST", list_c); 
				
				String BRCH_ID_NO = data.get("MFC_BRCH_NM").toString();
				if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
					data.put("BRCH_ID", BRCH_ID_NO.split(";")[0]);
					data.put("BRCH_NO", BRCH_ID_NO.split(";")[1]);
				}
				
				
				data.put("excelYn", "Y");
				List<?> list = epce6150601Mapper.epce6150601_select(data);
				
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
