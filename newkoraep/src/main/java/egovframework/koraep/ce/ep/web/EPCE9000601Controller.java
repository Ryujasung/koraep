package egovframework.koraep.ce.ep.web;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE2924601Service;
import egovframework.koraep.ce.ep.service.EPCE9000601Service;
import egovframework.mapper.ce.ep.EPCE9000601Mapper;
import net.sf.json.JSONObject;








import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import com.orsoncharts.util.json.JSONArray;
import com.orsoncharts.util.json.parser.JSONParser;
import com.orsoncharts.util.json.parser.ParseException;

/**
 * 반환관리
 * @author 양성수
 *
 */
@Controller
public class EPCE9000601Controller {

	@Resource(name = "epce9000601Service")
	private  EPCE9000601Service epce9000601Service; 	

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	@Resource(name="epce9000601Mapper")
	private EPCE9000601Mapper epce9000601Mapper;  //반환관리 Mapper

	/**
	 * 반환관리 페이지 호출
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000601.do", produces = "application/text; charset=utf8")
	public String epce9000601(HttpServletRequest request, ModelMap model) {
		
		model =epce9000601Service.epce9000601_select(model, request);
		//model = epce2924601Service.epce2924601_select(model, request);
		return "/CE/EPCE9000601";
	}
	
	/**
	 * 반환관리상세 페이지 호출(20200402)
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000602.do", produces = "application/text; charset=utf8")
	public String epce9000602(HttpServletRequest request, ModelMap model) {

		model =epce9000601Service.epce9000601_select_1(model, request);
		return "/CE/EPCE9000602";
	}

	/**
	 *  반환관리  생산자에 따른 직매장 조회  ,업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000601Service.epce9000601_select2(inputMap, request)).toString();
	}

	/**
	 * 반환관리 생산자 직매장/공장 선택시  업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_192.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_select2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000601Service.epce9000601_select3(inputMap, request)).toString();
	}

	/**
	 * 반환관리 도매업자 구분 선택시 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_193.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_select3(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000601Service.epce9000601_select4(inputMap, request)).toString();
	}

	/**
	 * 무인회수기내역  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_194.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_select4(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000601Service.epce9000601_select5(inputMap, request)).toString();
	}
	
	/**
	 * 반환내역상제조회(20200402추가)
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_195.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_select5_1(@RequestParam Map<String, Object> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000601Service.epce9000601_select5_1(inputMap, request)).toString();
	}

	/**
	 * 반환관리  엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce6624501_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000601Service.epce9000601_excel(data, request);
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
	@RequestMapping(value="/CE/EPCE9000602_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000602_excel(@RequestParam HashMap<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000601Service.epce9000602_excel(data, request);
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
	@RequestMapping(value="/CE/EPCE9000664_05.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000664_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";
		try{
			errCd = epce9000601Service.epce9000664_excel(data, request);
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
	 * 무인회수기 내역 삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_04.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_delete(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce9000601Service.epce9000601_delete(inputMap, request);
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
	 * 반환관리  실태조사
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_update(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce9000601Service.epce9000601_update(inputMap, request);
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
	 * 반환등록요청 일괄확인
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000601_212.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000601_update2(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";

		try{
			errCd = epce9000601Service.epce9000601_update2(inputMap, request);
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
	 * 무인회수기 상세 페이지 호출(상휘)
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000664.do", produces = "application/text; charset=utf8")
	public String epce9000664(HttpServletRequest request, ModelMap model) {
		model =epce9000601Service.epce9000664_select(model, request);
		return "/CE/EPCE9000664";
	}

	/**
	 * 무인회수기 등록 페이지(상휘) 
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000631.do", produces = "application/text; charset=utf8")
	public String epce9000631(HttpServletRequest request, ModelMap model) {

		model =epce9000601Service.epce9000601_select(model, request);
		return "/CE/EPCE9000631";
	}
	
	/**
	 *  회수정보등록도매업자 변경시    지점 & 보증금,수수료 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000631_19.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce2925831_select(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		return util.mapToJson(epce9000601Service.epce9000631_select2(inputMap, request)).toString();
	}
	
	
	/**
	 * 무인회수기등록  저장(상휘)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000631_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000631_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";

		try{
			errCd = epce9000601Service.epce9000601_insert(data, request);

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			/*e.printStackTrace();*/
			//취약점점검 6307 기원우
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		System.out.println("rtnObj"+rtnObj);
		if(errCd.charAt(0) == 'D' || errCd.charAt(0) == 'R') {
			String[] rtnArr = errCd.split("_");
			String rtnMsg = "";
			System.out.println("rtnObj"+rtnObj);
			
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
	 * 회수정보 변경(상휘)
	 * @param request
	 * @param model
	 * @return
	 * @
	 */
	@RequestMapping(value = "/CE/EPCE9000642.do", produces = "application/text; charset=utf8")
	public String epce9000642(HttpServletRequest request, ModelMap model) {
		model = epce9000601Service.epce9000642_select(model, request);
		return "/CE/EPCE9000642";
	}
	
	/**
	 * 회수정보수정  저장(상휘)
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000642_09.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce9000642_insert(@RequestParam Map<String, Object> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce9000601Service.epce9000642_insert(data, request);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
			/*e.printStackTrace();*/
			//취약점점검 6303 기원우
			if(data.get("ERR_CTNR_NM") !=null){
				System.out.println(data.get("ERR_CTNR_NM").toString());
			}
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}
	
	/**
	 * 엑셀 업로드 후처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE9000631_197.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce9000631_select7(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		System.out.println("1");
		return util.mapToJson(epce9000601Service.epce9000631_select8(inputMap, request)).toString();
	}	

	
	
	@RequestMapping(value="/CE/EPCE9000631_test.do")
	public void epce9000631_test(HttpServletRequest request, HttpServletResponse response) throws Exception  {
	/*RestTemplate restTemplate = new RestTemplate(); 

	HttpHeaders headers = new HttpHeaders(); 
	headers.setContentType(MediaType.APPLICATION_JSON);//JSON 변환 
//	headers.set("Authorization", appKey); //appKey 설정 ,KakaoAK kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk 이 형식 준수

	HttpEntity entity = new HttpEntity("parameters", headers); 
//	URI url=URI.create(apiURL); 
	//x -> x좌표, y -> y좌표 
	System.out.println("########3@@@@@@");
	ResponseEntity response= restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
	//String 타입으로 받아오면 JSON 객체 형식으로 넘어옴
	System.out.println("########4@@@@@@");
	JSONParser jsonParser = new JSONParser(); 
	JSONObject jsonObject = (JSONObject) jsonParser.parse(response.getBody().toString());
	//저는 Body 부분만 사용할거라 getBody 후 JSON 타입을 인자로 넘겨주었습니다
	//헤더도 필요하면 getBody()는 사용할 필요가 없음
	
	//JSONParser jsonParser = new JSONParser();
	JSONArray docuArray = (JSONArray) jsonObject.get("documents");
	//documents만 뽑아오고  
	System.out.println("########5@@@@@@"+docuArray.size());
	for(int i = 0 ; docuArray.size() > i ; i++){
		JSONObject docuObject = (JSONObject) docuArray.get(i); 
		//배열 i번째 요소 불러오고
		         
//		logger.info(docuObject.get("contents").toString());
		//뽑아오기 원하는 Key 이름을 넣어주면 그 value가 반환된다.
		System.out.println("########6@@@@@@"+docuObject.get("contents").toString().substring(1, 10));
		String tmp = docuObject.get("contents").toString().substring(1, 10);
		
		
		//회수량보증금 단가로 회수용기코드 추출
		int rtn_gtn = 10000;
		int rtn_qty = 100;
		int result = rtn_gtn/rtn_qty;
		String cpct_cd = "";
		if(result == 70){
			cpct_cd = "13";
		}else if(result == 100){
			cpct_cd = "23";
		}else if(result == 130){
			cpct_cd = "33";
		}else if(result == 350){
			cpct_cd = "43";
		}
		
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("SERIAL_NO", tmp);
		//톰라api로 받아온 데이터입력
		epce9000601Mapper.tomra_data_insert(map);
	}*/
	//=========================================
	
	//==================json 데이터로 테스트start=======================
	System.out.println("########json 데이터로 테스트start@@@@@@");
	JSONParser parser = new JSONParser();
	try {
		Object obj;
		System.out.println("########1@@@@@@");
		obj = parser.parse(new FileReader("C:/Temp/TOMRA-Testdata.json"));
		System.out.println(obj);
		JSONObject jo = (JSONObject) obj;
		System.out.println(jo);
		JSONArray docuArray = (JSONArray) jo.get("data");
		System.out.println(docuArray);
		//System.out.println(jo.get("JDBCDriver"));
		
		System.out.println("########5@@@@@@"+ docuArray.size());
		for(int i = 0 ; docuArray.size() > i ; i++){
			Map<String, String> map = new HashMap<String, String>();
			
			JSONObject docuObject = (JSONObject) docuArray.get(i); 
			//배열 i번째 요소 불러오고
			System.out.println("########44@@@@@@"+ docuObject.get("machine"));
			//JSONArray docuArray3 = (JSONArray) docuObject.get("machine");
			//JSONObject docuObject3 = (JSONObject) docuArray3.get(0); 
			System.out.println("########444serial@@@@@@"+ ((Map) docuObject.get("machine")).get("serial"));
			map.put("SERIAL_NO", (String) ((Map) docuObject.get("machine")).get("serial"));
			JSONArray docuArray2 = (JSONArray) docuObject.get("items");
			System.out.println("########55@@@@@@"+ docuArray2.size());
			if(docuArray2.size() > 1){
				for(int x = 0 ; docuArray2.size() > x ; x++){
					JSONObject docuObject2 = (JSONObject) docuArray2.get(i); 
					System.out.println("########77@@@@@@"+ docuObject2.get("barcode"));
					System.out.println("########88@@@@@@"+ docuObject2.get("reject"));
					map.put("BARCODE_NO", (String) docuObject2.get("barcode"));
					map.put("RTN_GTN", (String) docuObject2.get("reject"));
					epce9000601Mapper.tomra_data_insert(map);
				}
			}else{
				System.out.println("########99@@@@@@"+docuArray2.get(0));
				JSONObject docuObject3 = (JSONObject) docuArray2.get(0); 
				System.out.println("########10@@@@@@"+ docuObject3.get("barcode"));
				map.put("BARCODE_NO", (String) docuObject3.get("barcode"));
				map.put("RTN_GTN", (String)  docuObject3.get("reject"));
				epce9000601Mapper.tomra_data_insert(map);
			}
			//logger.info(docuObject.get("serial").toString());
			//뽑아오기 원하는 Key 이름을 넣어주면 그 value가 반환된다.
			//System.out.println("########6@@@@@@"+docuObject.get("serial"));
		}
		
		
	} catch (FileNotFoundException e1) {
		// TODO Auto-generated catch block
		/*e1.printStackTrace();*/
		//취약점점검 6322 기원우 
	} catch (IOException e1) {
		// TODO Auto-generated catch block
		/*e1.printStackTrace();*/
		//취약점점검 6319 기원우
	}finally {
		if(obj!=null) {
			obj.close();
			//취약점점검 3172 기원우 
		}
	}
	}

}
