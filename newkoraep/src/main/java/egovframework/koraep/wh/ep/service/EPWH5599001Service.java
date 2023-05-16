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
import egovframework.mapper.wh.ep.EPWH0160101Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 마이페이지 정보조회
 * @author Administrator
 *
 */
@Service("epwh5599001Service")
public class EPWH5599001Service {

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	@Resource(name="epwh0160101Mapper")
	private EPWH0160101Mapper epwh0160101Mapper;

	/**
	 * 사업자상세 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh55990012_select(ModelMap model, HttpServletRequest request) {

		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS", jParams);


		String title = commonceService.getMenuTitle("EPWH55990012");
		model.addAttribute("titleSub", title);

		HashMap<String, String> map = new HashMap<String, String>();

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if(vo != null){
			map.put("BIZRID", vo.getBIZRID());
			map.put("BIZRNO", vo.getBIZRNO_ORI());
		}

		model.addAttribute("searchDtl", util.mapToJson(epwh0160101Mapper.epwh0160116_select(map)));

		return model;
	}

	/**
	 * 지역 일괄 설정 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh55990088(ModelMap model, HttpServletRequest request) {
		  try {
				List<?> area_cd_list = commonceService.getCommonCdListNew("B010");//지역
				String   title = commonceService.getMenuTitle("EPWH55990088");//타이틀
				model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));
				model.addAttribute("titleSub", title);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			return model;
	  }

	  /**
		 * 지역 일괄 설정 저장
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epwh0181088_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						map.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
						epwh0160101Mapper.epwh0181088_update(map);//상태변경
					}
				}catch (Exception e) {
					if(e.getMessage().equals("A012") ){
						 throw new Exception(e.getMessage());
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
			}

			return errCd;
	    }

	/**
	 * 사업자정보관리 사업자정보 변경
	 * @param data
	 * @param request
	 * @return
	 * @
	 */

	public ModelMap epwh55990422_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPWH55990422");
		model.addAttribute("titleSub", title);

		List<?> BankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
		model.addAttribute("BankCdList", util.mapToJson(BankCdList));
		
		List<?> ErpCdList = commonceService.getCommonCdListNew("S022");//ERP코드리스트
		model.addAttribute("ErpCdList", util.mapToJson(ErpCdList));

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> map = new HashMap<String, String>();
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if(vo != null){
			map.put("BIZRID", vo.getBIZRID());
			map.put("BIZRNO", vo.getBIZRNO_ORI());
		}

		HashMap<String, String> smap = (HashMap<String, String>)epwh0160101Mapper.epwh0160116_select(map);

		model.addAttribute("searchDtl", util.mapToJson(smap));

		return model;
	}

	/**
	 * 단체 설정 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce55990013(ModelMap model, HttpServletRequest request) {
		try {
			List<?> aff_ogn_cd_list = commonceService.getCommonCdListNew("B004");//소속단체
			String title = commonceService.getMenuTitle("EPWH55990013");//타이틀
			model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));
			model.addAttribute("titleSub", title);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
	}

	/**
	 * 단체 설정 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce55990013_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if (list != null) {
			try {
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					map.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
					epwh0160101Mapper.epce55990013_update(map);//상태변경
				}
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}

		return errCd;
    }

}
