package egovframework.koraep.ce.ep.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE8160601Service;
import net.sf.json.JSONObject;

/**
 * 설문조사 Controller
 * @author pc
 *
 */
@Controller
public class EPCE8160601Controller {

	private static final Logger log = LoggerFactory.getLogger(EPCE8160601Controller.class);

	@Resource(name="epce8160601Service")
	private EPCE8160601Service epce8160601Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 설문 마스터 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8160601.do", produces="application/text; charset=utf8")
	public String epce8160601(ModelMap model, HttpServletRequest request)  {
		List<?> svy_se_cd_list = commonceService.getCommonCdListNew("S100");
		List<?> svy_trgt_cd_list = commonceService.getCommonCdListNew("S110");
		List<?> rst_trgt_cd_list = commonceService.getCommonCdListNew("S111");

		try {
			model.addAttribute("svy_se_cd_list", util.mapToJson(svy_se_cd_list));
			model.addAttribute("svy_trgt_cd_list", util.mapToJson(svy_trgt_cd_list));
			model.addAttribute("rst_trgt_cd_list", util.mapToJson(rst_trgt_cd_list));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);	//설문조사 문항등록 후 돌아올때 파라메터

		return "CE/EPCE8160601";
	}
	
	/**
	 * 설문 마스터 참여자 리스트
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE81606012.do", produces="application/text; charset=utf8")
	public String epce81606012(ModelMap model, HttpServletRequest request)  {

		String title = commonceService.getMenuTitle("EPCE81606012");
		model.addAttribute("titleSub", title);
		
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS", jParams);
		
		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		try {
			
			List<?> list = epce8160601Service.epce81606012_select1(param);
			model.addAttribute("searchList", util.mapToJson(list).toString());
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return "CE/EPCE81606012";
	}
	
	/**
	 * 설문 마스터 참여자 리스트 정산서 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE81606012_05.do")
	@ResponseBody
	public String epce81606012_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
				
		try{
			errCd = epce8160601Service.epce81606012_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	

	/**
	 * 설문 마스터 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8160601_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8160601_select1(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		HashMap<String, Object> map = new HashMap<String, Object>();

		return util.mapToJson(epce8160601Service.epce8160601_select1(param)).toString();
	}


	/**
	 * 설문 마스터 등록/수정
	 * @param param
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE8160601_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce8160601_update(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		String errCd = "";
		String msg = "저장 되었습니다.";

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		param.put("UPD_PRSN_ID", vo.getUSER_ID());
		param.put("REG_PRSN_ID", vo.getUSER_ID());

		/*
		Iterator<String> it = param.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
			log.debug(key + "=====" + param.get(key));
		}
		*/
		try{
			epce8160601Service.epce8160601_update(param);
		}catch(Exception e){
			errCd = "A001";
			msg = commonceService.getErrorMsgNew(request, "A", errCd);
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", msg);
		return rtnObj.toString();
	}
}
