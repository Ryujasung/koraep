package egovframework.koraep.cms.cs.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
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

import com.google.gson.Gson;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.cms.cs.service.CMSCS002Service;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 지급내역조회 Controller
 * @author Administrator
 *
 */

@Controller
public class CMSCS002Controller {

	@Resource(name="cmscs002Service")
	private CMSCS002Service cmscs002Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service

	private static final Logger log = LoggerFactory.getLogger(CMSCS002Controller.class);
	
	/**
	 * 예금주조회결과상세 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS002.do")
	public String cmscs002(ModelMap model, HttpServletRequest request) {
		model = cmscs002Service.cmscs002_select(model, request);
		return "/CMS/CMS_CS_002";
	}

	/**
	 * 예금주조회결과상세 조회
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS002_01.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String cmscs002_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(cmscs002Service.cmscs002_select2(data)).toString();
	}
	
	/**
	 * 예금주조회결과상세 실행여부 변경
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS002_03.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String cmscs002_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		String errCd = "";

		try{
			errCd = cmscs002Service.cmscs002_update(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	/**
	 * 예금주조회 api
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CMS/CMSCS002_02.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String CMSCS002_check(@RequestParam Map<String, String> map, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		
		try{
			errCd = cmscs002Service.cmscs002_update4(map, request);

			// CMS 예금주 조회 api 호출
			Map<String, String> data = acctNmUpdate(map, request);

		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 예금주조회 api (단건)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public static Map<String, String> acctNmCheck(Map<String, String> map, HttpServletRequest request) {
	
		String jsonValue = "";
		
		jsonValue = "{\"cmsFunc\":\"acctNmSearch\", \"cmsReq\":" + map.get("list") + "}";

		log.debug("=============== CMS 예금주조회 api : acctNmSearch  ==============");
		log.debug(jsonValue);
		
		return callCmsApi(jsonValue, request);
	}
	
	/**
	 * 예금주조회 api (다건)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public static Map<String, String> acctNmUpdate(Map<String, String> map, HttpServletRequest request) {
	
		String jsonValue = "";
		JSONArray list = JSONArray.fromObject(map.get("list"));
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserId = vo.getUSER_ID();

		jsonValue = "{\"cmsFunc\":\"acctNmListSearch\", \"reqId\":\"" + ssUserId + "\", \"menuCd\":\"" + map.get("PARAM_MENU_CD") + "\", \"cmsReq\":" + map.get("list") + "}";

		log.debug("============= CMS 예금주조회 api : acctNmListSearch " + list.size() + "건 ============");
		log.debug(jsonValue);
		
		return callCmsApi(jsonValue, request);
	}

	/**
	 * CMS api 호출
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public static Map<String, String> callCmsApi(String jsonValue, HttpServletRequest request) {

		String domain = request.getServerName();
		String apiUrl = "http://192.168.10.23:8180/cosmoCms";	//운영
		
//		if(domain.indexOf("175.115.52.202") > -1 || domain.indexOf("devreuse2.kora.or.kr") > -1 || domain.indexOf("devreuse2.cosmo.or.kr") > -1 || domain.indexOf("127.0.0.1") > -1){
//			apiUrl = "http://192.168.10.22:9180/cosmoCms";		//개발
//		} else if(domain.indexOf("localhost") > -1) {
//			apiUrl = "http://10.168.63.102:9180/cosmoCms";		//은행로컬
//		}
		
		String inputLine = null;
		StringBuffer outResult = new StringBuffer();
		HttpURLConnection conn = null;
		Map<String, String> data = new HashMap<String, String>();
		
		try {
			URL url = new URL(apiUrl);
            conn = (HttpURLConnection)url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json;charset=utf-8");
            conn.setConnectTimeout(100000);
            
            OutputStream os = conn.getOutputStream();
            os.write(jsonValue.getBytes("UTF-8"));
            
            os.flush();
            os.close();
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            
            while((inputLine = in.readLine()) != null) {
            	outResult.append(inputLine);
            }
            
            
            
            String responseStr = outResult.toString();
            log.debug("===================== CMS Api 결과 ====================");
            log.debug(responseStr);
            
            Gson gson = new Gson();
			data = (Map<String, String>)gson.fromJson(responseStr, Map.class);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		} finally {
			if(conn != null) {
				conn.disconnect();
			}
		}
		return data;
	}
	
}
