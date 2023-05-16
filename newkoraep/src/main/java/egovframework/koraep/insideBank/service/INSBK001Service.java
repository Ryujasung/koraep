package egovframework.koraep.insideBank.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.cms.cs.service.CMSCS002Service;
import net.sf.json.JSONArray;

/**
 * 휴폐업조회 InsideBank Controller
 * @author Administrator
 *
 */

@Service("insbk0001Service")
public class INSBK001Service {

	@Resource(name="cmscs002Service")
	private CMSCS002Service cmscs002Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통 service

	private static final Logger log = LoggerFactory.getLogger(INSBK001Service.class);
	
	/**
	 * 휴폐업조회 단건
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public static Map<String, String> coRegNbChk(Map<String, String> map, HttpServletRequest request) {
	
		String jsonValue = "";
		JSONArray list = JSONArray.fromObject(map.get("list"));
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserId = vo.getUSER_ID();

//		jsonValue = "{\"cmsFunc\":\"acctNmListSearch\", \"reqId\":\"" + ssUserId + "\", \"menuCd\":\"" + map.get("PARAM_MENU_CD") + "\", \"cmsReq\":" + map.get("list") + "}";

		log.debug("============= InsideBank 휴폐업조회 api : coRegNb " + map.size() + "건 ============");
		log.debug(jsonValue);
		
		return callInsideBankApi(jsonValue, request);
	}

	/**
	 * CMS api 호출
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public static Map<String, String> callInsideBankApi(String jsonValue, HttpServletRequest request) {
		String domain = request.getServerName();
		String apiUrl = "http://175.115.52.210:80/IFX1002";	//운영
//		String apiUrl = "http://127.0.0.1:8080/IFX1003";	//로컬개발
		
		String inputLine = null;
		Map<String, String> resultMap = new HashMap<String, String>();
		
		try {
			String query = "?co_reg_nb="+jsonValue;
			URL url = new URL(apiUrl+query);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept-Charset", "UTF-8"); 
            conn.setRequestProperty("Content-Type", "application/json;charset=utf-8");
            conn.setConnectTimeout(10000);
            
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            
            String xmlStr= "";
            while((inputLine = in.readLine()) != null) {
            	xmlStr += inputLine.toString();
            }
            conn.disconnect();
            
            log.debug("=====================InsideBank 휴폐업조회 결과 ====================");
            log.debug(xmlStr);
            xmlStr = xmlStr.replaceAll("'", "\"").replaceAll("   ", "");

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(xmlStr)));
            
            String rCode = "";
            String rMsg = "";
            String rTaxGbn = "";
            String rUpdateDate = "";
            String rCloseData = "";

            NodeList nodeList = doc.getElementsByTagName("IFX1002");
            for (int i = 0 ; i < nodeList.getLength() ; i++ ) {
            	for (Node node = nodeList.item(i).getFirstChild(); node!=null; node = node.getNextSibling()) {
            		System.out.println(">>>>> : node :::: " + node.getNodeName());
            		Element element = (Element) node;
            		switch (node.getNodeName()) {
	            		case "RCODE":
	            				// 1 성공, 2 오류
	            				rCode = element.getAttribute("value");
	        				break;
//	            		case "RMSG":
//	            				rMsg = element.getAttribute("value");
//	        				break;
	            		case "RTAX_GBN":
	            				//00 미확인, 11 일반, 12 간이, 21 면세, 22 비영리, 31 휴업, 32 폐업, 99 기타
	            				rTaxGbn = element.getAttribute("value");
	        				break;
//	            		case "RUPDATE_DATE":
//	            				rUpdateDate = element.getAttribute("value");
//	        				break;
//	            		case "RCLOSE_DATA":
//	            				rCloseData = element.getAttribute("value");
//	        				break;
            		}
            	}
            }
                        
            switch ( rTaxGbn ) {
	            case "00": //InsideBank 미등록
	            case "99": //InsideBank 기타
            		rTaxGbn = "0";
            		break;
            	case "11": //InsideBank 일반
            	case "12": //InsideBank 간이
            	case "21": //InsideBank 면세
            	case "22": //InsideBank 비영리
            		rTaxGbn = "1";
            		break;
            	case "31": //InsideBank 휴업
            		rTaxGbn = "3";
            		break;
            	case "32": //InsideBank 폐업
            		rTaxGbn = "2";
            }
            resultMap.put("RESULT_CODE" , rCode );
            resultMap.put("RUN_STAT_CD" , rTaxGbn );
		} catch (Exception e) {
			/*System.out.println(e.getMessage());*/
			/*e.printStackTrace();*/
		}
		
		return resultMap;
	}	
}