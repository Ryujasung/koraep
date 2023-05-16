/**
 *
 */
package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.CommonCeMapper;
import egovframework.mapper.ce.ep.EPCE0140101Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 회원관리 서비스
 * @author Administrator
 *
 */
@Service("epce0140101Service")
public class EPCE0140101Service {

	@Resource(name="epce0140101Mapper")
	private EPCE0140101Mapper epce0140101Mapper;

	@Resource(name="commonceMapper")
	private CommonCeMapper commonceMapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	
	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0140101_select(ModelMap model, HttpServletRequest request) {

		List<?> bizrTpList = commonceService.getCommonCdListNew("B001");// 사업자유형
		List<?> areaList = commonceService.getCommonCdListNew("B010");// 지역구분
		List<?> userSeList = commonceService.getCommonCdListNew("B006");// 사용자구분
		List<?> pwdAltReqList = commonceService.getCommonCdListNew("S013");// 비밀번호변경요청
		List<?> userStatList = commonceService.getCommonCdListNew("B007");// 사용자상태

		try {
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
			model.addAttribute("areaList", util.mapToJson(areaList));
			model.addAttribute("userSeList", util.mapToJson(userSeList));
			model.addAttribute("pwdAltReqList", util.mapToJson(pwdAltReqList));
			model.addAttribute("userStatList", util.mapToJson(userStatList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}

	/**
	 * 회원관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0140101_select2(Map<String, String> data, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null){
			if(vo.getATH_SE_CD().equals("B")){ //센터지사
				data.put("T_USER_ID", vo.getUSER_ID());
			}
		}

//		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
//		JSONObject jParams = JSONObject.fromObject(reqParams);
		List<?> menuList = epce0140101Mapper.epce0140101_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();

		try {
			
			map.put("searchList", util.mapToJson(menuList));
			map.put("totalCnt", epce0140101Mapper.epce0140101_select_cnt(data));
			
//			HashMap<String, String> privacyMap = util.jsonToMap(jParams.getJSONObject("menuList"));
			HashMap<String, Object> privacyMap = new HashMap<String, Object>();
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
			System.out.println(menuList);
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
			
			for (int i = 0; i < menuList.size(); i++) {
				Map<String, String> menuListMap = (Map<String, String>)menuList.get(i);	
				System.out.println(menuListMap.get("BIZR_TP_CD"));
				Long PRIVACY = commonceMapper.privacycnt();
				Long PRIVACYNO =  PRIVACY+1 ;
				String ACSS_IP = request.getRemoteAddr();
			
				if (vo != null) {
					privacyMap.put("PRIVACYNO", PRIVACYNO);
					privacyMap.put("USER_ID", vo.getUSER_ID());
					privacyMap.put("USER_NM", vo.getUSER_NM());
					privacyMap.put("REG_PRSN_ID", vo.getUSER_ID());
					privacyMap.put("REG_PRSN_NAME", vo.getUSER_NM());
					privacyMap.put("MENU_CD", "EPCE0140101");
					privacyMap.put("TARGET_ID", menuListMap.get("USER_ID"));
					privacyMap.put("TARGET_NM", menuListMap.get("USER_NM"));
					privacyMap.put("EMAIL",menuListMap.get("EMAIL") );				
					privacyMap.put("TEL_NO", menuListMap.get("TEL_NO"));
					privacyMap.put("MBIL_NO", menuListMap.get("MBIL_NO"));
					privacyMap.put("ACSS_IP", ACSS_IP);
					privacyMap.put("PARAMSTR",data.toString());
				}
				
				commonceService.insertListPrivacy(request,privacyMap);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 회원관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce0140101_excel(HashMap<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null){
				if(vo.getATH_SE_CD().equals("B")){ //센터지사
					data.put("T_USER_ID", vo.getUSER_ID());
				}
			}

			data.put("excelYn", "Y");
			List<?> list = epce0140101Mapper.epce0140101_select(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
	}

	/**
	 * 회원복원
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140101_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		String sUserId = "";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();

				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);

			    		map.put("S_USER_ID", sUserId);
			    		map.put("USER_STAT_CD", data.get("gGubn").equals("A")?"Y":"N");

			    		epce0140101Mapper.epce0140101_update(map);

			    		//사용자변경이력등록
			    		epce0140101Mapper.epce0140101_insert(map);
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
	 * 관리자변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140101_update2(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {

				//세션정보 가져오기
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO)session.getAttribute("userSession");
				String ssUserId   = uvo.getUSER_ID();		//세션사용자ID
				String ssBizrno   = uvo.getBIZRNO_ORI();		//세션사업자번호
				String ssUserSeCd = uvo.getUSER_SE_CD();	//세션사용자구분(D:관리자, S:업무담당자)
				String ssGrpCd    = uvo.getGRP_CD();		//세션권한그룹코드

				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);

			    		map.put("S_USER_ID", ssUserId);

			    		/*
						if(!ssBizrno.equals(data.get("BIZRNO"))){
							//rtnMsg = "사업장 권한이 없습니다.";
							return "B001";
						}else
						*/
						if(map.get("USER_SE_CD").equals("D")){
							//rtnMsg = "관리자는 선택하실 수 없습니다.";
							return "B002";
						}
						/*
						else if(ssUserId.equals(data.get("USER_ID"))){
							//rtnMsg = "관리자는 선택하실 수 없습니다.";
							return "B002";
						}

						else if(!ssUserSeCd.equals("S")){
							//rtnMsg = "처리권한이 없습니다.";
							return "B003";
						}
						*/


			    		//사용자구분코드 변경, 권한변경, 이력등록

			    		//업무담당자 => 관리자 변경
			    		map.put("USER_SE_CD", "D"); //사용자구분코드 관리자로 변경

			    		epce0140101Mapper.epce0140101_update2(map); //사용자구분코드 관리자로 변경 //기존 관리자 => 업무담당자 변경

			    		//사업자정보 관리자변경
			    		epce0140101Mapper.epce0140101_update3(map);

			    		//사용자정보 변경이력등록
			    		epce0140101Mapper.epce0140101_insert(map);

			    		//사업자정보 변경이력등록
			    		epce0140101Mapper.epce0140101_insert2(map);
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
	 * 비밀번호변경승인
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140101_update3(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		String sUserId = "";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();

				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);

			    		map.put("S_USER_ID", sUserId);

			    		epce0140101Mapper.epce0140101_update4(map);

			    		//사용자변경이력등록
			    		epce0140101Mapper.epce0140101_insert(map);
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
	 * 비밀번호오류초기화
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140101_update4(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		String sUserId = "";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();

				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);

			    		map.put("S_USER_ID", sUserId);

			    		epce0140101Mapper.epce0140101_update5(map);

			    		//사용자변경이력등록
			    		epce0140101Mapper.epce0140101_insert(map);
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
	 * 권한설정 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0140188_select(ModelMap model) {

		String title = commonceService.getMenuTitle("EPCE0140188");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 권한그룹 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0140188_select2(Map<String, String> data) {

		List<?> menuList = epce0140101Mapper.epce0140188_select(data);

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
	 * 메뉴 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0140188_select3(Map<String, String> data) {

		List<?> menuList = epce0140101Mapper.epce0140188_select2(data);

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
	 * 권한그룹 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140188_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}

				epce0140101Mapper.epce0140188_update(data);

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
	public ModelMap epce01401882_select(ModelMap model) {

		String title = commonceService.getMenuTitle("EPCE01401882");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 사용자변경이력 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce01401882_select2(Map<String, String> data) {

		List<?> menuList = epce0140101Mapper.epce01401882_select(data);

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
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0140164_select(ModelMap model, HttpServletRequest request, HashMap<String, String> map) {

		model.addAttribute("searchDtl", util.mapToJson(epce0140101Mapper.epce0140164_select(map)));

		return model;
	}

	/**
	 * 회원상세조회2
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0140164_select2(Map<String, String> data) {

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("searchDtl", util.mapToJson(epce0140101Mapper.epce0140164_select(data)));

		return map;
	}

	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0140142_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE0140142");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));

		/* 마이페이지 본인조회용 */
		if(map == null ){
			map = new HashMap<String, String>();

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				map.put("USER_ID", vo.getUSER_ID());
			}
		}

		HashMap<String, String> smap = (HashMap<String, String>)epce0140101Mapper.epce0140164_select(map);
		HashMap<String, String> bdMap = new HashMap<String, String>();
		bdMap.put("BIZRID", smap.get("BIZRID"));
		bdMap.put("BIZRNO", smap.get("BIZRNO"));

		try {
			if(smap.get("BIZR_TP_CD").equals("T1")){//사업자유형 센터
				model.addAttribute("brchList", util.mapToJson(commonceService.getCommonCdListNew("B009"))); //센터지부
			}else{
				model.addAttribute("brchList", util.mapToJson(commonceService.brch_nm_select_all(bdMap))); //모두조회..
			}
			model.addAttribute("deptList", util.mapToJson(commonceService.dept_nm_select(bdMap)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		model.addAttribute("searchDtl", util.mapToJson(smap));

		return model;
	}

	/**
	 * 회원 정보 변경 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140142_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}

				if(data.containsKey("BRCH_CD")){
					if(data.get("BIZR_TP_CD").equals("T1")){
						data.put("CET_BRCH_CD", data.get("BRCH_CD"));
						//data.put("BRCH_ID", "");
						//data.put("BRCH_NO", "");
					}else{
						String[] brchIdNo = data.get("BRCH_CD").split(";");
						data.put("BRCH_ID", brchIdNo[0]);
						data.put("BRCH_NO", brchIdNo[1]);
						data.put("CET_BRCH_CD", "");
					}
				}else{
					data.put("GBN", "M"); //마이페이지에서 수정

					String pwd = epce0140101Mapper.epce0140142_select(data); //USER_ID

					//기존비밀번호 체크, 센터메뉴에선 체크 안함
					String sBfPwd = data.get("PRE_PWD");
					sBfPwd = util.encrypt(sBfPwd);
					
					String sAfPwd = data.get("ALT_PWD");
					sAfPwd = util.encrypt(sAfPwd);

					if(!sBfPwd.equals(pwd)){
						throw new Exception("B017"); //"비밀번호가 맞지 않습니다.\n다시한번 확인 하시기 바랍니다.";
					}
					
					if(sAfPwd.equals(pwd)){
						throw new Exception("A028"); //"이전과 동일한 비밀번호를 사용할 수 없습니다.";
					}

				}

				//비번 암호화
				if(!data.get("ALT_PWD").equals("")){
					String sAfPwd = data.get("ALT_PWD");
					data.put("ALT_PWD", util.encrypt(sAfPwd));
				}

				if(!data.containsKey("DEPT_CD")){
					data.put("DEPT_CD", "");
				}

				epce0140101Mapper.epce0140142_update(data);

				//사용자변경이력등록
	    		epce0140101Mapper.epce0140101_insert(data);

		}catch(Exception e){
			if(e.getMessage().equals("B017") ){
				 throw new Exception(e.getMessage());
			 }else if(e.getMessage().equals("A028") ){
				 throw new Exception(e.getMessage());
			 }else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			 }
		}

		return errCd;

	}

	/**
	 * 회원 정보 삭제
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140142_delete(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {
				//권한 삭제
				epce0140101Mapper.epce0140142_delete(data);

				//사용자정보 삭제
				epce0140101Mapper.epce0140142_delete2(data);

		}catch(Exception e){
			throw new Exception("B020"); // 해당 사용자정보 사용데이터가 존재합니다.
		}

		return errCd;

	}

	/**
	 * 회원가입승인
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140164_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		String errCd = "0000";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}

				if(!data.get("USER_STAT_CD").equals("W")){
					//"승인대상이 아닙니다.";
					return "B005";
				}

				epce0140101Mapper.epce0140164_update(data);

		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

	/**
	 * 회원탈퇴
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140164_update2(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		String errCd = "0000";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				String ssUserId = "";

				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				data.put("S_USER_ID", ssUserId);
				String id = (data.get("USER_ID") == null) ? "" : data.get("USER_ID");
				String voId = (ssUserId == null) ? "" : ssUserId;

				if(!id.equals(voId)){
					//"회원탈퇴 권한이 없습니다.";
					//return "B004";
				}
				
				//템프테이블에 탈퇴정보 추가
				 epce0140101Mapper.epce0140164_insert2(data);
				
				 epce0140101Mapper.epce0140164_update2(data);
				 epce0140101Mapper.epce0140164_update3(data);

		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

}
