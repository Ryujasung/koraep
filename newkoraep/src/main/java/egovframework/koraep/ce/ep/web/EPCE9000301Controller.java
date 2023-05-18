package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE9000301Service;
import net.sf.json.JSONObject;

/*import java.io.*;
import java.net.*;
import java.util.*;
import javax.net.ssl.HttpsURLConnection;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;*/


/**
 * 수집소회수내역관리
 * @author 양성수
 *
 */
@Controller
public class EPCE9000301Controller {

	@Resource(name = "epce9000301Service")
	private  EPCE9000301Service epce9000301Service; 	//반환관리 service

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	//--------------------------------------------------------------
	/*static String subscriptionKey = "bd6c4d82-5751-4872-b05f-8638e5877bfe/2018-08-17T04:07:20.916Z";
	//https://api.eu.prod.tomra.cloud/consumer-sessions/v1.0/sessions/bd6c4d82-5751-4872-b05f-8638e5877bfe/2018-08-17T04:07:20.916Z
    static String host = "https://api.eu.prod.tomra.cloud";
    static String path = "/consumer-sessions/v1.0/sessions";

    static String mkt = "en-US";
    static String query = "italian restaurant near me";*/
    
    

    /*public static String search () throws Exception {
        String encoded_query = URLEncoder.encode (query, "UTF-8");
        String params = "?mkt=" + mkt + "&q=" + encoded_query;
        URL url = new URL ("https://api.eu.prod.tomra.cloud/consumer-sessions/v1.0/sessions");
        HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        System.out.println("##########5");
        connection.setRequestProperty("Ocp-Apim-Subscription-Key", subscriptionKey);
        System.out.println("##########6");
        connection.setDoOutput(true);
        System.out.println("##########7");
        
        StringBuilder response = new StringBuilder ();
        System.out.println("##########8");
        BufferedReader in = new BufferedReader( new InputStreamReader(connection.getInputStream()));
        System.out.println("##########9");
        String line;
        System.out.println("##########10");
        while ((line = in.readLine()) != null) {
        	System.out.println("##########11");
          response.append(line);
        }
        System.out.println("##########12");
        in.close();

        System.out.println("##########13");
        return response.toString();
    }
    
    public static String prettify (String json_text) {
    	 JsonParser parser = new JsonParser();
    	 JsonObject json = parser.parse(json_text).getAsJsonObject();
    	 Gson gson = new GsonBuilder().setPrettyPrinting().create();
    	 return gson.toJson(json);
    	}*/
    

	/**
	 * 반환관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000301.do", produces = "application/text; charset=utf8")
	public String epce9000301(HttpServletRequest request, ModelMap model) {
		
		 /*try {
	            String response = search ();
	            System.out.println (prettify (response));
	        }
	        catch (Exception e) {
	            System.out.println (e);
	        }*/
		
		model =epce9000301Service.epce9000301_select(model, request);
		return "/CE/EPCE9000301";
	}
	
	/**
	 * 반환관리상세 페이지 호출(20200402)
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000302.do", produces = "application/text; charset=utf8")
	public String epce9000302(HttpServletRequest request, ModelMap model) {

		model =epce9000301Service.epce9000301_select_1(model, request);
		return "/CE/EPCE9000302";
	}

	/**
	 *  반환관리  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000301_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000301Service.epce9000301_select2(inputMap, request)).toString();
	}

	/**
	 * 반환관리 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000301_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000301Service.epce9000301_select3(inputMap, request)).toString();
	}

	/**
	 * 반환관리 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000301_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000301Service.epce9000301_select4(inputMap, request)).toString();
	}

	/**
	 * 반환관리  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000301_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000301Service.epce9000301_select5(inputMap, request)).toString();
	}
	
	/**
	 * 반환내역상제조회(20200402추가)
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000301_select5_1(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000301Service.epce9000301_select5_1(inputMap, request)).toString();
	}

	/**
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000301Service.epce9000301_excel(data, request);
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
	 * 반환내역상세  엑셀저장(20200402 추가)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000302_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000302_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000301Service.epce9000302_excel(data, request);
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
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000364_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000364_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000301Service.epce9000364_excel(data, request);
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
	 * 반환관리  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000301_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce9000301Service.epce9000301_delete(inputMap, request);
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
	 * 회수정보 변경
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000342.do", produces = "application/text; charset=utf8")
	public String epce2925842(HttpServletRequest request, ModelMap model) {
		model = epce9000301Service.epce9000342_select(model, request);
		return "/CE/EPCE9000342";
	}
	
	
	/**
	 * 반환관리  실태조사
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000301_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce9000301Service.epce9000301_update(inputMap, request);
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
	 * 반환내역서등록  저장
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000331_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000331_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";

		try{
			errCd = epce9000301Service.epce9000301_insert(data, request);

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			if(data.get("ERR_CTNR_NM") !=null){
				//System.out.println(data.get("ERR_CTNR_NM").toString());
			}
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		
		if(errCd.charAt(0) == 'D' || errCd.charAt(0) == 'R') {
			String[] rtnArr = errCd.split("_");
			String rtnMsg = "";
			
			
			rtnObj.put("RSLT_CD", "E099");
			rtnObj.put("RSLT_MSG", rtnMsg);
			rtnObj.put("ERR_CTNR_NM", rtnMsg);
		}
		else {
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

			if(data.get("ERR_CTNR_NM") !=null){
				rtnObj.put("ERR_CTNR_NM", data.get("ERR_CTNR_NM").toString());
			}
		}
		
		return rtnObj.toString();
	}
	
	/**
	 * 수정
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000342_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000342_update(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";

		try{
			errCd = epce9000301Service.epce9000342_update(data, request);

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			if(data.get("ERR_CTNR_NM") !=null){
				//System.out.println(data.get("ERR_CTNR_NM").toString());
			}
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		
		if(errCd.charAt(0) == 'D' || errCd.charAt(0) == 'R') {
			String[] rtnArr = errCd.split("_");
			String rtnMsg = "";
			
			
			rtnObj.put("RSLT_CD", "E099");
			rtnObj.put("RSLT_MSG", rtnMsg);
			rtnObj.put("ERR_CTNR_NM", rtnMsg);
		}
		else {
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

			if(data.get("ERR_CTNR_NM") !=null){
				rtnObj.put("ERR_CTNR_NM", data.get("ERR_CTNR_NM").toString());
			}
		}
		
		return rtnObj.toString();
	}

	/**
	 * 반환등록요청 일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000301_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000301_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce9000301Service.epce9000301_update2(inputMap, request);
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
	 * 반환관리 상세 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000364.do", produces = "application/text; charset=utf8")
	public String epce9000364(HttpServletRequest request, ModelMap model) {

		model =epce9000301Service.epce9000364_select(model, request);
		return "/CE/EPCE9000364";
	}

	/**
	 * 반환정보등록 
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000331.do", produces = "application/text; charset=utf8")
	public String epce9000331(HttpServletRequest request, ModelMap model) {

		model =epce9000301Service.epce9000301_select(model, request);
		return "/CE/EPCE9000331";
	}
	
	/**
	 * 엑셀 업로드 후처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000331_197.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000631_select7(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000301Service.epce9000331_select8(inputMap, request)).toString();
	}	
	
	
	


}
