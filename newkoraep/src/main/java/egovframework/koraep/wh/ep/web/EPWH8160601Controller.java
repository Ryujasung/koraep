package egovframework.koraep.wh.ep.web;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

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
import egovframework.koraep.wh.ep.service.EPWH8160601Service;

/**
 * 설문조사 Controller
 * @author pc
 *
 */
@Controller
public class EPWH8160601Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPWH8160601Controller.class);
	
	@Resource(name="epwh8160601Service")
	private EPWH8160601Service epwh8160601Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 설문 마스터 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8160601.do", produces="application/text; charset=utf8")
	public String epwh8160601(ModelMap model, HttpServletRequest request)  {
		
		List<?> svy_se_cd_list = commonceService.getCommonCdListNew("S100");
		List<?> svy_trgt_cd_list = commonceService.getCommonCdListNew("S110");
		
		
		try {
			model.addAttribute("svy_se_cd_list", util.mapToJson(svy_se_cd_list));
			model.addAttribute("svy_trgt_cd_list", util.mapToJson(svy_trgt_cd_list));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);	//설문조사 문항등록 후 돌아올때 파라메터
		
		return "/WH/EPWH8160601";
	}
	
	/**
	 * 설문 마스터 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8160601_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh8160601_select1(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		List<?> list = epwh8160601Service.epwh8160601_select1(param);
		map.put("searchList", list);
		
		return util.mapToJson(map).toString();
	}

	
	/**
	 * 설문 마스터 등록/수정
	 * @param param
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8160601_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh8160601_update(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		
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
			epwh8160601Service.epwh8160601_update(param);
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
