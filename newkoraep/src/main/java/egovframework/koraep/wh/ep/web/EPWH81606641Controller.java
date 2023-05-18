package egovframework.koraep.wh.ep.web;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.koraep.wh.ep.service.EPWH81606641Service;

/**
 * 설문 문항 및 선택 옵션 관리 Controller
 * @author kwon
 *
 */
@Controller
@RequestMapping("/WH/")
public class EPWH81606641Controller {
	
	private static final Logger log = LoggerFactory.getLogger(EPWH81606641Controller.class);
	
	@Resource(name="epwh81606641Service")
	private EPWH81606641Service epwh81606641Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 설문 문항 및 선택 옵션관리 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="EPWH81606641.do", produces="application/text; charset=utf8")
	public String epwh81606641(ModelMap model, HttpServletRequest request)  {

		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		String title = commonceService.getMenuTitle("EPWH81606641");
		model.addAttribute("titleSub", title);
		
		
		List<?> ansr_list = commonceService.getCommonCdListNew("S120");	//설문답변형식
		try {
			model.addAttribute("ansr_list", util.mapToJson(ansr_list));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		
		return "/WH/EPWH81606641";
	}
	
	/**
	 * 선택 설문문항 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="EPWH81606641_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh81606641_select1(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		List<?> list = epwh81606641Service.epwh81606641_select1(param);
		map.put("searchList", list);
		
		return util.mapToJson(map).toString();
	}
	
	
	/**
	 * 조사문항 저장
	 * @param param
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="EPWH81606641_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh81606641_update1(@RequestParam Map<String, String> param, HttpServletRequest request)  {
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
			epwh81606641Service.epwh81606641_update1(param);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
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
	 * 선택문항 옵션조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="EPWH81606641_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh81606641_select2(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		List<?> list = epwh81606641Service.epwh81606641_select2(param);
		map.put("searchList", list);
		
		return util.mapToJson(map).toString();
	}
	
	
	
	/**
	 * 선택문항 옵션 저장
	 * @param param
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="EPWH81606641_092.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh81606641_update2(@RequestParam Map<String, String> param, HttpServletRequest request)  {
		String errCd = "";
		String msg = "저장 되었습니다.";
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		param.put("UPD_PRSN_ID", vo.getUSER_ID());
		param.put("REG_PRSN_ID", vo.getUSER_ID());
		
		try{
			epwh81606641Service.epwh81606641_update2(param);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
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
	 * 이미지 미리보기 팝업
	 * @param model
	 * @param param
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="EPWH81606642.do", produces="application/text; charset=utf8")
	public String epwh81606642(ModelMap model, @RequestParam Map<String, String> param, HttpServletRequest request)  {
		Iterator<String> it = param.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
			model.addAttribute(key, param.get(key));
		}
		return "/WH/EPWH81606642";
	}
	
}
