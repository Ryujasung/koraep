package egovframework.koraep.ce.ep.web;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import com.popbill.api.CloseDownService;
import com.popbill.api.CorpState;

import egovframework.common.CommonProperties;
import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0160101Service;
import egovframework.koraep.ce.ep.service.EPCE0160131Service;
import egovframework.koraep.cms.cs.web.CMSCS002Controller;

/**
 * 사업자등록 Controller
 * @author 김창순
 *
 */


@Controller
public class EPCE0160131Controller {
	
	@Resource(name="epce0160101Service")
	private EPCE0160101Service epce0160101Service;
	
	@Resource(name="epce0160131Service")
	private EPCE0160131Service epce0160131Service;
	
	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service
	
	/**
	 * 사업자 등록 페이지호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160131.do", produces="application/text; charset=utf8")
	public String epce0160131_select(ModelMap model, HttpServletRequest request) {
		
		model = epce0160131Service.epce0160131_select(model, request);
		//페이지이동 조회조건 파라메터 정보
//		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
//		JSONObject jParams = JSONObject.fromObject(reqParams);
//		model.addAttribute("INQ_PARAMS",jParams);
		
		return "/CE/EPCE0160131";
	}
		
	
	@Value("#{LINKHUB_CONFIG.CorpNum}")
	private String corpNum;
	
	@Autowired
	private CloseDownService closedownService;
	
	/**
	 * 사업장 정보 및 관리자 정보 등록
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160131_1.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0160131_insert(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		
		String errCd = "";
		String state = "";
		
		try{
			//크로스 추가
//			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
			MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
			String BIZRNO = mptRequest.getParameter("BIZRNO1") + mptRequest.getParameter("BIZRNO2") + mptRequest.getParameter("BIZRNO3");

			try{
				CorpState corpState = closedownService.CheckCorpNum(corpNum, BIZRNO);
				if(corpState != null){
					state = corpState.getState();
				}
			}catch(Exception e){
				//errMsg = e.getMessage();
				state = "";
			}
			
			errCd = epce0160131Service.epce0160131_insert(request, state);
			
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}
	
	/**
	 * 아이디 중복체크
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160131_2.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0160131_2_check(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) {
		String ableYn = epce0160131Service.epce0160131_2_check(param);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("USE_ABLE_YN", ableYn);
		
		return util.mapToJson(map).toString();
	}
	
	/**
	 * 사업자번호 중복체크
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160131_3.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0160131_3_check(@RequestParam HashMap<String, String> param, ModelMap model, HttpServletRequest request) {
		String ableYn = epce0160131Service.epce0160131_3_check(param);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("USE_ABLE_YN", ableYn);
		
		return util.mapToJson(map).toString();
	}
	
	/**
	 * 예금주명 확인API
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/ACCT_NM_CHECK_asis.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String acctNmCheck_asis(@RequestParam HashMap<String, String> map, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String domain = request.getServerName();
		//String msg = "";
		//String errCd = "0000";

		String BANK_CD = map.get("BANK_CD");
		String SEARCH_ACCT_NO = map.get("SEARCH_ACCT_NO");
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		
		if(BANK_CD == null || BANK_CD.equals("")){
			rtnMap.put("RSLT_CD", "0001");
			rtnMap.put("RSLT_MSG", "은행코드가 입력되지 않았습니다.");
			return util.mapToJson(rtnMap).toString();
		}
		
		if(SEARCH_ACCT_NO == null || SEARCH_ACCT_NO.equals("")){
			rtnMap.put("RSLT_CD", "0001");
			rtnMap.put("RSLT_MSG", "계좌번호가 입력되지 않았습니다.");
			return util.mapToJson(rtnMap).toString();
		}
		
		String SEND_ID = CommonProperties.CENTER_BIZNO;	//순환자원센터 사업자번호
		
		String str = "\"SEND_ID\":\"" + SEND_ID + "\",\"RECEIVE_ID\":\"" + SEND_ID + "\",\"MO_ACCT_NO\":\"\",\"ICHE_AMT\":\"\"";
		str = str + "\"BANK_CD\":\"" + BANK_CD + "\",\"SEARCH_ACCT_NO\":\"" + SEARCH_ACCT_NO + "\"";
		
		String sData = "{\"SECR_KEY\":\"gYiCj6DUbYg0kvG4ucA1\",\"KEY\":\"ACCTNM_WAPI\", \"REQ_DATA\":[{" + str + "}]}";
		
		//주의사항 : json 형태지만 json으로 던지면 인식못함. 문자열로 만들어서 보내야함. json을 치환한 문자열 안됨.
		String apiUrl = "https://gw.coocon.co.kr/sol/gateway/acctnm_wapi.jsp";	//운영
		
		if(domain.indexOf("localhost") > -1 || domain.indexOf("175.115.52.202") > -1 || domain.indexOf("devreuse2.cosmo.or.kr") > -1 || domain.indexOf("127.0.0.1") > -1){
			//apiUrl = "http://dev.coocon.co.kr/sol/gateway/acctnm_wapi.jsp";	//개발
			
			apiUrl = "https://dev2.coocon.co.kr:8443/sol/gateway/acctnm_wapi.jsp";	//root인증서 변경 테스트
		}
		
		Document document = null;
		try {
			apiUrl = apiUrl + "?JSONData="+URLEncoder.encode(sData, "utf-8");
			document = (Document) Jsoup.connect(apiUrl).get();
		} catch (IOException e1) {
			/*System.out.println(e1.getMessage());*/
			/*e1.printStackTrace();*/
		} catch(Exception e){
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
		Elements e = document.select("body");

		return util.toHalfChar(e.get(0).text());	//전각을 반각처리후 리턴
	}
	
	/**
	 * 예금주명 확인API
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/ACCT_NM_CHECK.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String acctNmCheck(@RequestParam HashMap<String, String> map, ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String domain = request.getServerName();

		String BANK_CD = map.get("BANK_CD");
		String ACCT_NO = map.get("SEARCH_ACCT_NO");
		map.put("ACCT_NO", map.get("SEARCH_ACCT_NO"));
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		
		if(BANK_CD == null || BANK_CD.equals("")){
			rtnMap.put("RSLT_CD", "0001");
			rtnMap.put("RSLT_MSG", "은행코드가 입력되지 않았습니다.");
			return util.mapToJson(rtnMap).toString();
		}
		
		if(ACCT_NO == null || ACCT_NO.equals("")){
			rtnMap.put("RSLT_CD", "0001");
			rtnMap.put("RSLT_MSG", "계좌번호가 입력되지 않았습니다.");
			return util.mapToJson(rtnMap).toString();
		}

		// CMS 예금주 조회 api 호출
		HashMap<String, String> param = new HashMap<String, String>();
		List<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		list.add(map);
		
		param.put("list", util.mapToJson(list).toString());
		
		Map<String, String> data = CMSCS002Controller.acctNmCheck(param, request);
		Map<String, String> result = (Map<String, String>) JSONArray.fromObject(data.get("RESULT_OBJECT")).get(0);
		
		// 기존 포맷에 맞게 변경
		JSONObject acctNm = new JSONObject();
		acctNm.put("ACCT_NM", result.get("ACCT_DPSTR_NM"));

		JSONArray array = new JSONArray();
		array.add(acctNm);
		
		JSONObject obj = new JSONObject();
		obj.put("RESP_DATA", array);
		obj.put("RSLT_CD", result.get("RESULT_CODE"));
		obj.put("RSLT_MSG", result.get("RESULT_MSG"));
		
		return obj.toString();
	}
	
	
}