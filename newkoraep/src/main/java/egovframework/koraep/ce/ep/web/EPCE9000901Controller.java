package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE9000901Service;
import egovframework.koraep.ce.ep.service.EPCE9000901Service;
import net.sf.json.JSONObject;

/**
 * 상계처리관리 Controller
 * @author Administrator
 *
 */

@Controller
public class EPCE9000901Controller {

	@Resource(name="epce9000901Service")
	private EPCE9000901Service epce9000901Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service

	/**
	 * 상계처리관리 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000901.do")
	public String epce9000901(ModelMap model, HttpServletRequest request) {
		model = epce9000901Service.epce9000901_select(model, request);
		
		return "/CE/EPCE9000901";
	}

	/**
	 * 상계처리관리 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000901_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0101801_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		return util.mapToJson(epce9000901Service.epce9000901_select2(data)).toString();
	}
	
	/**
	 * 상계처리관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000901_05.do")
	@ResponseBody
	public String epce2393001_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		
		try{
			errCd = epce9000901Service.epce9000901_excel(data, request);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}	
	
	/**
	 * 상계처리관리 상세페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000902.do")
	public String epce9000902(ModelMap model, HttpServletRequest request) {
		model = epce9000901Service.epce9000902_select(model, request);

		return "/CE/EPCE9000902";
	}
	
		
	/**
	 * 상계처리관리 상세 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000902_05.do")
	@ResponseBody
	public String epce9000902_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			//request.getAttribute("WHSDL_BIZRNO");
			errCd = epce9000901Service.epce9000902_excel(data, request);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
}
