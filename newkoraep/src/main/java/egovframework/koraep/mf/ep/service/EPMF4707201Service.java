package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF4707201Mapper;
import net.sf.json.JSONObject;

/**
 * 정산서조회  서비스
 * @author Administrator
 *
 */
@Service("epmf4707201Service")
public class EPMF4707201Service {

	@Resource(name="epmf4707201Mapper")
	private EPMF4707201Mapper epmf4707201Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf4707201_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		Map<String, String> map = new HashMap<String, String>();

		List<?> stdMgntList = commonceService.std_mgnt_select(request, map); //정산기간
		List<?> excaSeList = commonceService.getCommonCdListNew("C023");
		List<?> excaProcStatList = commonceService.getCommonCdListNew("C024");
		List<?> bizrTpList = epmf4707201Mapper.epmf4707201_select();

		try {

			model.addAttribute("stdMgntList", util.mapToJson(stdMgntList));
			model.addAttribute("excaSeList", util.mapToJson(excaSeList));
			model.addAttribute("excaProcStatList", util.mapToJson(excaProcStatList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}

	/**
	 * 상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf4707264_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		String title = commonceService.getMenuTitle("EPMF4707264");
		model.addAttribute("titleSub", title);

		Map<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		param.put("BIZRID", vo.getBIZRID());
		param.put("BIZRNO", vo.getBIZRNO_ORI());

		HashMap<?, ?> searchDtl = epmf4707201Mapper.epmf4707264_select(param);
		List<?> searchList = new ArrayList<Object>();
		List<?> searchList2 = new ArrayList<Object>();
		List<?> searchList3 = new ArrayList<Object>();
		List<?> searchList4 = new ArrayList<Object>();
		List<?> searchList5 = new ArrayList<Object>();
		List<?> searchList6 = new ArrayList<Object>();
		List<?> searchList7 = new ArrayList<Object>();
		List<?> searchList8 = new ArrayList<Object>();
		List<?> searchList9 = new ArrayList<Object>();

		if(param.get("EXCA_ISSU_SE_CD").equals("G")){ //보증금
			searchList7 = epmf4707201Mapper.epmf4707264_select2(param);
		}else if(param.get("EXCA_ISSU_SE_CD").equals("F")){ //취급수수료
			searchList7 = epmf4707201Mapper.epmf4707264_select8(param);
		}else if(param.get("EXCA_ISSU_SE_CD").equals("W")){ //반환정산
			param.put("B", "B");
		}

		for(int i=0; i<searchList7.size(); i++){
			Map<String, String> map = (Map<String, String>)searchList7.get(i);
			param.put(map.get("ETC_CD"), map.get("ETC_CD"));
		}

		try {

			if(param.containsKey("A")) searchList = epmf4707201Mapper.epmf4707264_select3(param);
			if(param.containsKey("B")) searchList2 = epmf4707201Mapper.epmf4707264_select4(param);
			if(param.containsKey("C")) searchList3 = epmf4707201Mapper.epmf4707264_select5(param);
			if(param.containsKey("D")) searchList4 = epmf4707201Mapper.epmf4707264_select9(param); //교환정산 과거데이터
			if(param.containsKey("E")) searchList5 = epmf4707201Mapper.epmf4707264_select6(param);
			if(param.containsKey("F")) searchList6 = epmf4707201Mapper.epmf4707264_select7(param);
			if(param.containsKey("I")) searchList8 = epmf4707201Mapper.epmf4707264_select10(param); //연간입고량조정
			if(param.containsKey("J")) searchList9 = epmf4707201Mapper.epmf4707264_select11(param); //연간교환량조정

			model.addAttribute("searchDtl", util.mapToJson(searchDtl));
			model.addAttribute("searchList", util.mapToJson(searchList));
			model.addAttribute("searchList2", util.mapToJson(searchList2));
			model.addAttribute("searchList3", util.mapToJson(searchList3));
			model.addAttribute("searchList4", util.mapToJson(searchList4));
			model.addAttribute("searchList5", util.mapToJson(searchList5));
			model.addAttribute("searchList6", util.mapToJson(searchList6));
			model.addAttribute("searchList7", util.mapToJson(searchList7));
			model.addAttribute("searchList8", util.mapToJson(searchList8));
			model.addAttribute("searchList9", util.mapToJson(searchList9));

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}

	/**
	 * 정산서조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf4707201_select2(Map<String, String> data, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		data.put("BIZRID", vo.getBIZRID());
		data.put("BIZRNO", vo.getBIZRNO_ORI());

		List<?> list = epmf4707201Mapper.epmf4707201_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 정산서발급취소
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epmf4707201_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		String ssBizrTpCd = ""; //사업자유형

		try {

			if(vo != null){
				ssUserId = vo.getUSER_ID();
				ssBizrTpCd = vo.getBIZR_TP_CD();
			}
			inputMap.put("S_USER_ID", ssUserId);

			//센터 사용자만 처리 가능
			if(!ssBizrTpCd.equals("T1")){
				throw new Exception("G001");
			}

			//정산서 상태가 '발급'이 아닌 경우 취소 불가
			int nChckCnt = epmf4707201Mapper.epmf4707201_select3(inputMap);
			if(nChckCnt > 0){
				throw new Exception("G002");
			}

			//정산서 관련문서 상태 변경
			epmf4707201Mapper.epmf4707201_update(inputMap);

			//정산서 삭제
			epmf4707201Mapper.epmf4707201_delete(inputMap);

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			if(e.getMessage().equals("G001") || e.getMessage().equals("G002") ){
				throw new Exception(e.getMessage());
			}else{
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}

		return errCd;

	}

	/**
	 * 수납확인 상세조회 (고지서)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4707288_select(Map<String, String> data) {

		List<?> menuList = epmf4707201Mapper.epmf4707288_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 수납확인 상세조회 (수납내역)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4707288_select2(Map<String, String> data) {

		List<?> menuList = epmf4707201Mapper.epmf4707288_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

}
