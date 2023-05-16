package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0140101Mapper;
import egovframework.mapper.ce.ep.EPCE0160101Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("epce0160101Service")
public class EPCE0160101Service {

	@Resource(name="epce0160101Mapper")
	private EPCE0160101Mapper epce0160101Mapper;

	@Resource(name="epce0140101Mapper")
	private EPCE0140101Mapper epce0140101Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 사업자관리 기초데이터 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0160101_select(ModelMap model, HttpServletRequest request)  {
		//세션정보 가져오기
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO)session.getAttribute("userSession");
		String ssBizrno = uvo.getBIZRNO();		//사업자번호

		List<?> lang_Se_CD = commonceService.getLangSeCdList();
		List<?> BizrTpCdList = commonceService.getCommonCdListNew("B001");
		List<?> AreaCdList = commonceService.getCommonCdListNew("B010");
		List<?> AffOgnCdList = commonceService.getCommonCdListNew("B004");
		List<?> AtlReqStatCdList = commonceService.getCommonCdListNew("B003");
		List<?> BizrStatCdList = commonceService.getCommonCdListNew("B007");
		List<?> ErpCdList = commonceService.getCommonCdListNew("S022");
		String title = commonceService.getMenuTitle("EPCE0160101");

		try {
//			model.addAttribute("initList", util.mapToJson(initList));
			model.addAttribute("langSeList", util.mapToJson(lang_Se_CD));
			model.addAttribute("BizrTpCdList", util.mapToJson(BizrTpCdList));
			model.addAttribute("AreaCdList", util.mapToJson(AreaCdList));
			model.addAttribute("AffOgnCdList", util.mapToJson(AffOgnCdList));
			model.addAttribute("AtlReqStatCdList", util.mapToJson(AtlReqStatCdList));
			model.addAttribute("BizrStatCdList", util.mapToJson(BizrStatCdList));
			model.addAttribute("ErpCdList", util.mapToJson(ErpCdList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		model.addAttribute("titleSub", title);

		//로그인 사업자번호
		HashMap<String, String> mapBizno = new HashMap<String, String>();
		mapBizno.put("BIZRNO", ssBizrno);
		model.addAttribute("searchBizrno", util.mapToJson(mapBizno));

		//조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}


	/**
	 * 사업자관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0160101_select2(Map<String, String> data, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null){
			data.put("T_USER_ID", vo.getUSER_ID());
		}

		List<?> list = epce0160101Mapper.epce0160101_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
			map.put("totalCnt", epce0160101Mapper.epce0160101_select2_cnt(data));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 사업자관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce0160101_excel(HashMap<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			
			data.put("excelYn", "Y");
			List<?> list = epce0160101Mapper.epce0160101_select2(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
	}

	/**
	 * 사업자관리 활동/비활동처리
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional
	public String epce0160101_updateData3(Map<String, String> data, HttpServletRequest request) throws Exception  {

		String errCd = "0000";
		String sUserId = "";


		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();
				//String ssBizrno = vo.getBIZRNO();
				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		map.put("S_USER_ID", sUserId);
			    		//map.put("BIZRNO", ssBizrno);
			    		map.put("BIZR_STAT_CD", data.get("gGubn").equals("A")?"Y":"N");

			    		epce0160101Mapper.epce0160101_update3(map);

			    		//사용자변경이력등록
			    		epce0160101Mapper.epce0160131_insert2(map);
//			    		epce0140101Mapper.epce0140101_insert(map);
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}

		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

	/**
	 * 사업자관리 휴폐업 상태 업데이트
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional
	public String epce0160101_updateData4(Map<String, String> data, HttpServletRequest request) throws Exception  {

		String errCd = "0000";
		String sUserId = "";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				if(vo != null){
					sUserId = vo.getUSER_ID();
				}
				data.put("S_USER_ID", sUserId);

				epce0160101Mapper.epce0160101_update7(data);

		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

	/**
	 * 사용자변경이력 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce016010118_select(ModelMap model) {

		String title = commonceService.getMenuTitle("EPCE0160101_1");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 사업자변경이력 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce016010118_select2(Map<String, String> data)  {

		List<?> menuList = epce0160101Mapper.epce0160101_select5(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;

	}

	/**
	 * 사업자상세 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0160116_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE0160116");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		model.addAttribute("searchDtl", util.mapToJson(epce0160101Mapper.epce0160116_select(map)));

		return model;
	}

	/**
	 * 지급제외설정 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0160117_select(ModelMap model, HttpServletRequest request) {
		try {
			String title = commonceService.getMenuTitle("EPCE0160117");//타이틀
			model.addAttribute("titleSub", title);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
	}

	/**
	 * 지급제외설정 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0160117_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		try {
			inputMap.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
			epce0160101Mapper.epce0160117_update(inputMap);//상태변경
		}catch (Exception e) {
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
    }

	/**
	 * 사업자상세조회2
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0160116_select2(Map<String, String> data) {

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("searchDtl", util.mapToJson(epce0160101Mapper.epce0160116_select(data)));

		return map;
	}
	/**
	 * 관리자변경 팝업호출
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce01601018_1_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE01601018_1");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 단체 설정 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0160188(ModelMap model, HttpServletRequest request) {
		try {
			List<?> aff_ogn_cd_list = commonceService.getCommonCdListNew("B004");//소속단체
			String title = commonceService.getMenuTitle("EPCE0160188");//타이틀
			model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));
			model.addAttribute("titleSub", title);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
	}

	/**
	 * 단체 설정 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0160188_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if (list != null) {
			try {
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					map.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
					epce0160101Mapper.epce0160188_update(map);//상태변경
				}
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}

		return errCd;
    }

	/**
	 * 관리자등록
	 * @param map
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce01601018_1_update4(HashMap<String, String> data, HttpServletRequest request, ModelMap model) throws Exception{

		String errCd = "0000";

		try {
				//세션정보 가져오기
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO)session.getAttribute("userSession");
				String ssUserId   = uvo.getUSER_ID();		//세션사용자ID

				String idCheck = epce0160101Mapper.epce0160116_select6(data);

				if(idCheck != null && idCheck.equals("Y")){
					throw new Exception("B006"); //해당 사업자의 관리자 아이디가 활동 상태입니다. \n회원탈퇴 후 등록이 가능합니다.
				}

				if(uvo != null){
					data.put("REG_PRSN_ID", uvo.getUSER_ID());
					data.put("S_USER_ID", uvo.getUSER_ID());
				}

				//관리자 변경
				//data.put("USER_SE_CD", "D"); //사용자구분코드 관리자로 변경
				//epce0140101Mapper.epce0140101_update2(data); //사용자구분코드 관리자로 변경
				data.put("USER_PWD", util.encrypt("12345678"));
				data.put("USER_STAT_CD", "Y");
				data.put("CET_BRCH_CD", "");
				epce0160101Mapper.epce0160131_insert7(data);  //담당자 등록
				//사용자정보 변경이력등록
				epce0140101Mapper.epce0140101_insert(data);

				//사업자정보 관리자변경
				epce0160101Mapper.epce0160101_update4(data);
				//사업자정보 변경이력등록
				epce0160101Mapper.epce0160131_insert2(data);

				//메뉴권한 부여 필요..

		}catch(Exception e){
			if(e.getMessage().equals("B006") ){
				 throw new Exception(e.getMessage());
			 }else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			 }
		}
		return errCd;

	}


}