package egovframework.koraep.ce.ep.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.popbill.api.CloseDownService;
import com.popbill.api.CorpState;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE0160101Service;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/**
 * 사업자관리 Controller
 * @author 김창순
 *
 */
@Controller
public class EPCE0160101Controller {

	@Resource(name="epce0160101Service")
	private EPCE0160101Service epce0160101Service;

	@Resource(name = "commonceService")
	private CommonCeService commonceService; 	//공통  service

	/**
	 * 사업자관리 페이지 호출
	 * @param request
	 * @return
	 * @
	 */

	@RequestMapping(value="/CE/EPCE0160101.do", produces="application/text; charset=utf8")
	public String epce0160101_select(HttpServletRequest request, ModelMap model)  {

		model = epce0160101Service.epce0160101_select(model, request);

		return "/CE/EPCE0160101";

	}

	/**
	 * 사업자관리 조회
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE016010119.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0160101_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		return util.mapToJson(epce0160101Service.epce0160101_select2(data, request)).toString();

	}

	/**
	 * 사업자관리 엑셀저장
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160101_05.do")
	@ResponseBody
	public String epce0160101_excel(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			errCd = epce0160101Service.epce0160101_excel(data, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}


	@Value("#{LINKHUB_CONFIG.CorpNum}")
	private String corpNum;

	@Autowired
	private CloseDownService closedownService;

	/**
	 * 사업자관리 휴폐업조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160101422.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce016010142_update2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "0000";
		String errMsg = "";
		String sUserId = "";

		try{

			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			if(vo != null){
				sUserId = vo.getUSER_ID();
			}

			List<?> list = JSONArray.fromObject(data.get("list"));

			if(list != null && list.size() > 0){

				String[] corpNumList = new String[list.size()];
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = (Map<String, String>)list.get(i);
					corpNumList[i] = map.get("BIZRNO_DE");
		    	}

				// 조회할 사업자번호 배열, 최대 1000건
				CorpState[] corpStates = closedownService.CheckCorpNum(corpNum, corpNumList);

				for(int i=0; i<corpStates.length; i++){
					Map<String, String> map = new HashMap<String, String>();
					map.put("BIZRNO", corpStates[i].getCorpNum());
					map.put("RUN_STAT_CD", corpStates[i].getState()); // 0 : 미등록 (등록되지 않은 사업자번호 사업자번호 ), 1 : 사업중, 2 : 폐업, 3 : 휴업

					epce0160101Service.epce0160101_updateData4(map, request); //상태 업데이트
				}
			}

		}catch(Exception e){
			/*e.printStackTrace();*/
			errCd = "A001";
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		if(errMsg.equals("")){
			rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		}else{
			rtnObj.put("RSLT_MSG", errMsg);
		}

		return rtnObj.toString();
	}

	/**
	 * 사업자관리 활동/비활동처리
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE016010142.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce016010142_update(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {

		String errCd = "";

		try{
			if(data.get("gGubn").equals("A")){
				errCd = epce0160101Service.epce0160101_updateData3(data, request); //회원복원
			}else if(data.get("gGubn").equals("C")){
				errCd = epce0160101Service.epce0160101_updateData3(data, request); //비활동처리
			}

		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 사업자변경내역 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160101_1.do")
	public String epce016010118(ModelMap model, HttpServletRequest request)  {

		model = epce0160101Service.epce016010118_select(model);

		return "CE/EPCE0160101_1";

	}

	/**
	 * 사업자변경내역 목록조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160101_2.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce016010118_select2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request)  {
		return util.mapToJson(epce0160101Service.epce016010118_select2(data)).toString();
	}

	/**
	 * 사업자정보 상세조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160116.do", produces="text/plain;charset=UTF-8")
	public String epce0160116(ModelMap model, HttpServletRequest request) {
		model = epce0160101Service.epce0160116_select(model, request);
		return "/CE/EPCE0160116";
	}

	/**
	 * 지급제외설정 팝업
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160117.do", produces="text/plain;charset=UTF-8")
	public String epce0160117(ModelMap model, HttpServletRequest request) {
		model = epce0160101Service.epce0160117_select(model, request);
		return "/CE/EPCE0160117";
	}

	/**
	 * 지급제외설정 수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160117_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0160117_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0160101Service.epce0160117_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 사업자정보 상세조회2
	 * @param map
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160116_19.do", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String epce0160116_select(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request) {
		return util.mapToJson(epce0160101Service.epce0160116_select2(data)).toString();
	}

	/**
	 * 관리자등록 팝업호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE01601018_1.do", produces="text/plain;charset=UTF-8")
	public String epce01601018_1(ModelMap model, HttpServletRequest request)  {

		model = epce0160101Service.epce01601018_1_select(model, request);

		return "CE/EPCE01601018_1";
	}

	/**
	 * 소속단체설정 팝업호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160188.do", produces="text/plain;charset=UTF-8")
	public String epce0160188(ModelMap model, HttpServletRequest request)  {
		model = epce0160101Service.epce0160188(model, request);
		return "CE/EPCE0160188";
	}

	/**
	 * 단체 설정 저장/수정
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE0160188_21.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce0160188_insert(@RequestParam Map<String, String> inputMap, HttpServletRequest request)  {
		String errCd = "";
		try{
			errCd = epce0160101Service.epce0160188_update(inputMap, request);
		}catch(Exception e){
			errCd = e.getMessage();
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();
	}

	/**
	 * 관리자등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/CE/EPCE01601018_2.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epce01601018_2(@RequestParam HashMap<String, String> data, ModelMap model, HttpServletRequest request)  {

		String errCd = "";

		try{
			errCd = epce0160101Service.epce01601018_1_update4(data, request, model); //관리자변경
		}catch(Exception e){
			errCd = e.getMessage();
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));

		return rtnObj.toString();

	}


}

