package egovframework.koraep.mf.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.mf.ep.EPMF2393001Mapper;

/**
 * 고지서조회 서비스
 * @author Administrator
 *
 */
@Service("epmf2393001Service")
public class EPMF2393001Service {

	@Resource(name="epmf2393001Mapper")
	private EPMF2393001Mapper epmf2393001Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf2393001_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		try {
			List<?> bizrList 	= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
			model.addAttribute("bizrList", util.mapToJson(bizrList));	//생산자 리스트
			
			List<?> billSeCdList = commonceService.getCommonCdListNew("D031");// 고지서구분
			List<?> issuStatCdList = commonceService.getCommonCdListNew("D032");// 고지서상태
			model.addAttribute("billSeCdList", util.mapToJson(billSeCdList));
			model.addAttribute("issuStatCdList", util.mapToJson(issuStatCdList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 고지서 리스트 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf2393001_select2(Map<String, Object> data, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(vo != null){ //로그인 생산자
			data.put("BIZRID", vo.getBIZRID());
			data.put("BIZRNO", vo.getBIZRNO_ORI());
		}
		
		data.put("BILL_SE_CD_SEL", JSONArray.fromObject(data.get("BILL_SE_CD_SEL")));
		data.put("ISSU_STAT_CD_SEL", JSONArray.fromObject(data.get("ISSU_STAT_CD_SEL")));
		
		List<?> list = epmf2393001Mapper.epmf2393001_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 보증금고지서 상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf2393064_select(ModelMap model, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserNm = "";   //사용자명
		String ssBizrNm = "";   //부서명
		if(vo != null){
			ssUserNm = vo.getUSER_NM();
			ssBizrNm = vo.getBIZRNM();
		}
		model.addAttribute("ssUserNm", ssUserNm);
		model.addAttribute("ssBizrNm", ssBizrNm);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		
		model.addAttribute("titleSub", commonceService.getMenuTitle("EPMF2393064"));
		
		//상세조회
		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		model.addAttribute("searchDtl", util.mapToJson(epmf2393001Mapper.epmf2393064_select(map)));
		
		//출고보증금 그리드 조회
		try {
			model.addAttribute("searchList", util.mapToJson(epmf2393001Mapper.epmf2393064_select2(map)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}
	
	/**
	 * 취급수수료고지서 상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf2393064_select2(ModelMap model, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserNm = "";   //사용자명
		String ssBizrNm = "";   //부서명
		if(vo != null){
			ssUserNm = vo.getUSER_NM();
			ssBizrNm = vo.getBIZRNM();
		}
		model.addAttribute("ssUserNm", ssUserNm);
		model.addAttribute("ssBizrNm", ssBizrNm);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		
		model.addAttribute("titleSub", commonceService.getMenuTitle("EPMF23930642"));
		
		//상세조회
		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		model.addAttribute("searchDtl", util.mapToJson(epmf2393001Mapper.epmf2393064_select(map)));
		
		//그리드 조회
		try {
			model.addAttribute("searchList", util.mapToJson(epmf2393001Mapper.epmf2393064_select3(map)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}
	
	/**
	 * 보증금(조정)고지서 상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf2393064_select3(ModelMap model, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserNm = "";   //사용자명
		String ssBizrNm = "";   //부서명
		if(vo != null){
			ssUserNm = vo.getUSER_NM();
			ssBizrNm = vo.getBIZRNM();
		}
		model.addAttribute("ssUserNm", ssUserNm);
		model.addAttribute("ssBizrNm", ssBizrNm);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		
		model.addAttribute("titleSub", commonceService.getMenuTitle("EPMF23930643"));
		
		//상세조회
		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		model.addAttribute("searchDtl", util.mapToJson(epmf2393001Mapper.epmf2393064_select(map)));
		
		
		try {
			//출고보증금 그리드 조회
			model.addAttribute("searchList", util.mapToJson(epmf2393001Mapper.epmf2393064_select2(map)));
			
			//취급수수료 그리드 조회
			model.addAttribute("searchList2", util.mapToJson(epmf2393001Mapper.epmf2393064_select4(map)));
			
			//직접회수 그리드 조회
			model.addAttribute("searchList3", util.mapToJson(epmf2393001Mapper.epmf2393064_select5(map)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}
	
	/**
	 * 고지서 발급취소요청
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf2339088_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserId  = "";   //사용자ID
		if(vo != null){
			ssUserId = vo.getUSER_ID();
		}
		
		String errCd = "0000";
		
		try {
			
			//고지서 상태 확인
			Map<String, String> billMap = (Map<String, String>) epmf2393001Mapper.epmf2393064_select6(inputMap);
			
			if(billMap == null){
				throw new Exception("A007"); // 저장할 데이타가 없습니다.
			}else if(billMap.get("ISSU_STAT_CD").equals("A")){
				throw new Exception("A012"); // 상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
			}else if(billMap.get("ADD_ISSU_YN").equals("Y")){
				throw new Exception("A012"); // 상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
			}
			
			inputMap.put("S_USER_ID", ssUserId);
			
			//취소요청 상태로 변경
			int cnt = epmf2393001Mapper.epmf2393088_update(inputMap);
			if(cnt < 1){
				throw new Exception("A012"); // 상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
			}
			
			//R: 취소요청, C: 취소처리, L: 요청취소
			inputMap.put("REQ_STAT_CD", "R");
			inputMap.put("BILL_SE_CD", billMap.get("BILL_SE_CD"));
			
			//사유저장
			epmf2393001Mapper.epmf2393088_insert(inputMap);
			
			//알림 필요여부 확인
			commonceService.send_anc("B6000001"); //센터 업무담당자에게 알림 보내기
			
			
		}catch (Exception e) {
			if(e.getMessage().equals("A012") || e.getMessage().equals("A007") || e.getMessage().equals("A004") ){
				throw new Exception(e.getMessage());
			}else{
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}
		
		return errCd;
	}
	
	/**
	 * 고지서 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epmf2393001_excel(HashMap<String, Object> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			if(vo != null){ //로그인 생산자
				data.put("BIZRID", vo.getBIZRID());
				data.put("BIZRNO", vo.getBIZRNO_ORI());
			}
			
			/*
			String BIZRID_NO = data.get("MFC_BIZR_SEL").toString();
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("BIZRID", BIZRID_NO.split(";")[0]);
				data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}
			*/
			
			data.put("BILL_SE_CD_SEL", JSONArray.fromObject(data.get("BILL_SE_CD_SEL")));
			data.put("ISSU_STAT_CD_SEL", JSONArray.fromObject(data.get("ISSU_STAT_CD_SEL")));
								
			data.put("excelYn", "Y");
			List<?> list = epmf2393001Mapper.epmf2393001_select(data);

			HashMap<String, String> map = new HashMap();
						
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());
			
			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 보증금고지서 상세조회 - 엑셀저장용
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public String epmf2393064_excel(Map<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {
				
			List<?> list = epmf2393001Mapper.epmf2393064_select2(data);

			HashMap<String, String> map = new HashMap();
						
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());
			
			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 취급수수료 상세조회 - 엑셀저장용
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public String epmf23930642_excel(Map<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {

			List<?> list = epmf2393001Mapper.epmf2393064_select3(data);

			HashMap<String, String> map = new HashMap();
						
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());
			
			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}
