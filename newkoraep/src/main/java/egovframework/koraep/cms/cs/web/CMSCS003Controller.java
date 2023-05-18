package egovframework.koraep.cms.cs.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.cms.cs.service.CMSCS003Service;
import net.sf.json.JSONObject;

/**
 * 계좌거래내역조회 Controller
 * @author Administrator
 *
 */

@Controller
public class CMSCS003Controller {

	@Resource(name="cmscs003Service")
	private CMSCS003Service cmscs003Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service

	private static final Logger log = LoggerFactory.getLogger(CMSCS003Controller.class);

	/**
	 * 계좌거래내역조회 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS003.do")
	public String cmscs003(ModelMap model, HttpServletRequest request) {
		model = cmscs003Service.cmscs003_select(model, request);

		return "/CMS/CMS_CS_003";
	}
	
	/**
	 * 계좌거래내역조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS003_01.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String cmscs003_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(cmscs003Service.cmscs003_select2(data)).toString();
	}
	
	/**
	 * 계좌잔액조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS003_02.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String cmscs003_select3(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(cmscs003Service.cmscs003_select3(data)).toString();
	}
	
	/**
	 * 계좌거래내역조회 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS003_03.do")
	@ResponseBody
	public String cmscs003_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = cmscs003Service.cmscs003_excel(data, request);
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
