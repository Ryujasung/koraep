package egovframework.koraep.rt.ep.web;

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
import egovframework.koraep.rt.ep.service.EPRT8160653Service;
import net.sf.json.JSONObject;

/**
 * 설문조사 Controller
 * @author pc
 *
 */
@Controller
public class EPRT8160653Controller {

	private static final Logger log = LoggerFactory.getLogger(EPRT8160653Controller.class);

	@Resource(name="eprt8160653Service")
	private EPRT8160653Service eprt8160653Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 등록설문 조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT8160653.do", produces="application/text; charset=utf8")
	public String eprt8160653(ModelMap model, HttpServletRequest request)  {
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

		return "RT/EPRT8160653";
	}


	/**
	 * 등록설문 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT8160653_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt8160653_select1(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		HashMap<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		param.put("USER_ID", vo.getUSER_ID());
		param.put("SVY_TRGT_CD", vo.getBIZR_TP_CD());

		List<?> list = eprt8160653Service.eprt8160653_select1(param);
		map.put("searchList", list);

		return util.mapToJson(map).toString();
	}




	/**
	 * 선택설문 문항페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT81606531.do", produces="application/text; charset=utf8")
	public String eprt81606531(ModelMap model, HttpServletRequest request)  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");

		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);	//설문조사 문항등록 후 돌아올때 파라메터
		model.addAttribute("BIZR_TP_CD", vo.getBIZR_TP_CD());

		String title = commonceService.getMenuTitle("EPRT81606531");
		model.addAttribute("titleSub", title);

		return "RT/EPRT81606531";
	}


	/**
	 * 선택설문 문항(문항별선택옵션)조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT81606531_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt8160653_select2(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		HashMap<String, Object> map = new HashMap<String, Object>();

		List<?> list = eprt8160653Service.eprt8160653_select2(param);
		map.put("searchList", list);

		List<?> cntn = eprt8160653Service.eprt8160653_select5(param);
		map.put("searchCntn", cntn);
		
		/*
		for(int i=0; i<list.size(); i++){
			HashMap<String, Object> item = (HashMap<String, Object>)list.get(i);
			log.debug("SVY_ITEM_NO : " + item.get("SVY_ITEM_NO") + "=====" + item.get("ASK_CNTN") + "====" + item.get("ANSR_SE_CD"));

			List<?> optList = (List<?>)item.get("OPT_LIST");
			for(int x=0; x<optList.size(); x++){
				HashMap<String, Object> opt = (HashMap<String, Object>)optList.get(x);
				log.debug("OPT_NO : " + opt.get("OPT_NO") + "=====" + opt.get("OPT_CNTN"));
			}
		}
		*/

		return util.mapToJson(map).toString();
	}





	/**
	 * 선택설문 참여결과저장
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT81606531_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt8160653_insert(@RequestParam Map<String, Object> param, HttpServletRequest request)  {
		HashMap<String, Object> map = new HashMap<String, Object>();

		String errCd = "";
		String msg = "저장 되었습니다.";

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		param.put("USER_ID", vo.getUSER_ID());

		/*
		Iterator<String> it = param.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
			log.debug(key + "=====" + param.get(key));
		}
		*/
		try{
			eprt8160653Service.eprt8160653_insert(param);
		}catch(Exception e){
			errCd = "A001";
			msg = commonceService.getErrorMsgNew(request, "A", errCd);
		}
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", msg);
		return rtnObj.toString();
	}



	/**
	 * 선택설문 결과페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT81606532.do", produces="application/text; charset=utf8")
	public String eprt81606532(ModelMap model, HttpServletRequest request)  {
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);	//설문조사 문항등록 후 돌아올때 파라메터

		String title = commonceService.getMenuTitle("EPRT81606532");
		model.addAttribute("titleSub", title);

		return "RT/EPRT81606532";
	}

	/**
	 * 선택설문 문항(문항별선택옵션) 결과조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/RT/EPRT81606532_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String eprt8160653_select3(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		HashMap<String, Object> map = new HashMap<String, Object>();

		String cnt = eprt8160653Service.eprt8160653_select3(param);
		map.put("totVoteCnt", cnt);

		if(cnt == null || cnt.equals("0")) cnt = "1";
		param.put("VOTE_CNT", cnt);

		List<?> list = eprt8160653Service.eprt8160653_select4(param);
		map.put("searchList", list);

		return util.mapToJson(map).toString();
	}

}
