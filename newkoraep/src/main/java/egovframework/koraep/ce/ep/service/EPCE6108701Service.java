package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE6108701Mapper;
import net.sf.json.JSONArray;

/**
 * 상세교환현황 Service
 * @author 이내희
 *
 */
@Service("epce6108701Service")
public class EPCE6108701Service {

	@Resource(name="epce6108701Mapper")
	private EPCE6108701Mapper epce6108701Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 상세교환현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce6108701_select(ModelMap model, HttpServletRequest request) {

		  Map<String, String> map = new HashMap<String, String>();

			try {
				List<?> ctnrSe = commonceService.getCommonCdListNew("E005"); //빈용기구분 구/신
				model.addAttribute("ctnrSe", util.mapToJson(ctnrSe));
				
				List<?> prpsCdList	 = commonceService.getCommonCdListNew("E002"); //용도
				model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));	
				
				List<?> alkndCdList	 = commonceService.getCommonCdListNew("E004"); //주종
				model.addAttribute("alkndCdList", util.mapToJson(alkndCdList));	

				List<?> mfcBizrList = commonceService.mfc_bizrnm_select(request); // 생산자
				model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));

				List<?> ctnrNmList = commonceService.ctnr_nm_select2(request, map); //빈용기명
				model.addAttribute("ctnrNmList", util.mapToJson(ctnrNmList));

				List<?> dtList = commonceService.getCommonCdListNew("D026"); //날짜
				model.addAttribute("dtList", util.mapToJson(dtList));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}

			return model;
	    }

	  /**
	   * 상세교환현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epce6108701_select2(Map<String, Object> data, HttpServletRequest request) {

  		  	//멀티selectbox 일경우
			List<?> list_m = JSONArray.fromObject(data.get("MFC_LIST"));
			data.put("MFC_LIST", list_m);
			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
			data.put("CTNR_LIST", list_c);

			HashMap<String, Object> map = new HashMap<String, Object>();

			try {
				List<?> list = epce6108701Mapper.epce6108701_select(data);
				map.put("searchList", util.mapToJson(list));

				if(data.get("CHART_YN") != null && data.get("CHART_YN").equals("Y")){
					List<?> list2 = epce6108701Mapper.epce6108701_select2(data);
					map.put("searchList2", util.mapToJson(list2));
				}

				map.put("totalList", epce6108701Mapper.epce6108701_select_cnt(data));

			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}

			return map;
  	  }

	  /**
		 * 생산자변경시 빈용기명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce6108701_select3(Map<String, String> inputMap, HttpServletRequest request) {

	    		HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    		try {
					rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap)));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  //빈용기

	      		return rtnMap;
	    }

		/**
		 * 상세교환현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce6108701_excel(HashMap<String, Object> data, HttpServletRequest request) {

			String errCd = "0000";

			try {

				//멀티selectbox 일경우
				List<?> list_m = JSONArray.fromObject(data.get("MFC_LIST"));
				data.put("MFC_LIST", list_m);
    			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
    			data.put("CTNR_LIST", list_c);

				data.put("excelYn", "Y");
				List<?> list = epce6108701Mapper.epce6108701_select(data);
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
