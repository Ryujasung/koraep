package egovframework.koraep.wh.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH6186401Mapper;
import net.sf.json.JSONObject;

/**
 * 회수대비초과반환현황 Service
 * @author 양성수
 *
 */
@Service("epwh6186401Service")
public class EPWH6186401Service {


	@Resource(name="epwh6186401Mapper")
	private EPWH6186401Mapper epwh6186401Mapper;  //회수대비초과반환현황 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 회수대비초과반환현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh6186401_select(ModelMap model, HttpServletRequest request) {

		  	String title = commonceService.getMenuTitle("EPWH6186401"); //화면 타이틀
			model.addAttribute("titleSub", title);

		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			Map<String, String> map= new HashMap<String, String>();
			List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역    E002
			List<?>	whsdlList		=commonceService.mfc_bizrnm_select4(request, map);				//도매업
			try {
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));
				model.addAttribute("areaList", util.mapToJson(areaList));
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
		public HashMap epwh6186401_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
	    			rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
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
		public HashMap epwh6186401_select3(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			inputMap.put("WHSDL_BIZRID", vo.getBIZRID());
			inputMap.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				inputMap.put("WHSDL_BRCH_ID", vo.getBRCH_ID());// 지점ID
				inputMap.put("WHSDL_BRCH_NO", vo.getBRCH_NO());// 지점번호
			}

    		try {
    			if( inputMap.get("CHART_YN") !=null && inputMap.get("CHART_YN").equals("Y") ){
	    	  		rtnMap.put("selList_chart", util.mapToJson(epwh6186401Mapper.epwh6186401_select2(inputMap)));
	    	  	}
				rtnMap.put("selList", util.mapToJson(epwh6186401Mapper.epwh6186401_select(inputMap)));
				rtnMap.put("totalList", util.mapToJson(epwh6186401Mapper.epwh6186401_select3(inputMap)));
				System.out.println("rtnMap"+rtnMap);
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
		public String epwh6186401_excel(HashMap<String, Object> data, HttpServletRequest request) {

			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				data.put("WHSDL_BIZRID", vo.getBIZRID());
				data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
				if(!vo.getBRCH_NO().equals("9999999999")){
					data.put("WHSDL_BRCH_ID", vo.getBRCH_ID());  				// 지점ID
					data.put("WHSDL_BRCH_NO", vo.getBRCH_NO());  			// 지점번호
				}

				List<?> list = epwh6186401Mapper.epwh6186401_select(data);
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
