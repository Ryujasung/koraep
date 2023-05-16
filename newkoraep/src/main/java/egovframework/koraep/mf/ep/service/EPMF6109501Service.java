package egovframework.koraep.mf.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF6109501Mapper;

/**
 * 교환현황 Service
 * @author 이내희
 *
 */
@Service("epmf6109501Service")
public class EPMF6109501Service {

	@Resource(name="epmf6109501Mapper")
	private EPMF6109501Mapper epmf6109501Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 교환현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf6109501_select(ModelMap model, HttpServletRequest request) {

		  Map<String, String> map = new HashMap<String, String>();

			try {
				List<?> ctnrSe = commonceService.getCommonCdListNew("E005"); //빈용기구분 구/신
				model.addAttribute("ctnrSe", util.mapToJson(ctnrSe));
				
				List<?> prpsCdList	 = commonceService.getCommonCdListNew("E002"); //용도
				model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));	
				
				List<?> alkndCdList	 = commonceService.getCommonCdListNew("E004"); //주종
				model.addAttribute("alkndCdList", util.mapToJson(alkndCdList));	

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
	   * 교환현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epmf6109501_select2(Map<String, Object> data, HttpServletRequest request) {

			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
			data.put("CTNR_LIST", list_c);

  		    HashMap<String, Object> map = new HashMap<String, Object>();
			
			HttpSession session = request.getSession();
			UserVO uvo = (UserVO) session.getAttribute("userSession");
			
			try {

				data.put("BIZRID", uvo.getBIZRID());  			
				data.put("BIZRNO", uvo.getBIZRNO_ORI());
				
				List<?> list = epmf6109501Mapper.epmf6109501_select(data);
				map.put("searchList", util.mapToJson(list));

				if(data.get("CHART_YN") != null && data.get("CHART_YN").equals("Y")){
					List<?> list2 = epmf6109501Mapper.epmf6109501_select2(data);
					map.put("searchList2", util.mapToJson(list2));
				}

				map.put("totalList", epmf6109501Mapper.epmf6109501_select_cnt(data));

			} catch (Exception e) {
				// TODO Auto-generated catch block
				/*e.printStackTrace();*/
				//취약점점검 6279 기원우 
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
		public HashMap epmf6109501_select3(Map<String, String> inputMap, HttpServletRequest request) {

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
		 * 교환현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf6109501_excel(HashMap<String, Object> data, HttpServletRequest request) {

			String errCd = "0000";

			HttpSession session = request.getSession();
			UserVO uvo = (UserVO) session.getAttribute("userSession");

			try {

				data.put("BIZRID", uvo.getBIZRID());  			
				data.put("BIZRNO", uvo.getBIZRNO_ORI());

				//멀티selectbox 일경우
    			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
    			data.put("CTNR_LIST", list_c);

				data.put("excelYn", "Y");
				List<?> list = epmf6109501Mapper.epmf6109501_select(data);
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
