/**"
 *
 */
package egovframework.koraep.wh.ep.service;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH0120601Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 직매장별거래처관리 서비스
 * @author Administrator
 *
 */
@Service("epwh0120601Service")
public class EPWH0120601Service {

	@Resource(name="epwh0120601Mapper")
	private EPWH0120601Mapper epwh0120601Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;


	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh0120601_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));

		Map<String, String> map = new HashMap<String, String>();

		//List<?> searchList 		 	= epwh0120601Mapper.epwh0120601_select(map); //
		List<?> mfc_bizrnm_sel 		= commonceService.mfc_bizrnm_select_all(request); // 생산자 콤보박스


		try {
			if(jmap != null){

				String BIZRID_NO = jmap.get("MFC_BIZRNM_SEL");
				if(BIZRID_NO != null && !BIZRID_NO.equals("")){
					map.put("BIZRID", BIZRID_NO.split(";")[0]);
					map.put("BIZRNO", BIZRID_NO.split(";")[1]);
				}else{
					map.put("BIZRID", "");
					map.put("BIZRNO", "");
				}

				List<?> mfc_brch_nm_sel	= commonceService.brch_nm_select(request, map);
				model.addAttribute("mfc_brch_nm_sel", util.mapToJson(mfc_brch_nm_sel)); //직매장

			}else{
				model.addAttribute("mfc_brch_nm_sel", "{}");	//직매장
			}

			//model.addAttribute("searchList", util.mapToJson(searchList));
			model.addAttribute("mfc_bizrnm_sel", util.mapToJson(mfc_bizrnm_sel));	//생산자구분 리스트


			List<?> stat_cd_sel = commonceService.getCommonCdListNew("S011");//거래여부
			List<?> std_fee_reg_yn = commonceService.getCommonCdListNew("S012");//기준수수료등록여부
			List<?> bizr_tp_cd_sel = epwh0120601Mapper.epwh0120601_select2();//거래처구분

			model.addAttribute("stat_cd_sel", util.mapToJson(stat_cd_sel));
			model.addAttribute("std_fee_reg_yn", util.mapToJson(std_fee_reg_yn));
			model.addAttribute("bizr_tp_cd_sel", util.mapToJson(bizr_tp_cd_sel));
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
	 * 등록화면 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh0120631_select(ModelMap model, HttpServletRequest request) {

		Map<String, String> map = new HashMap<String, String>();
		map.put("BIZRNO", "");


		try {
			List<?> mfc_bizrnm_sel 		= commonceService.mfc_bizrnm_select_all_y(request); // 생산자 콤보박스
			//List<?> mfc_brch_nm_sel		= commonceService.brch_nm_select(request, map);
			List<?> bizr_tp_cd_sel = epwh0120601Mapper.epwh0120601_select2();//거래처구분
			List<?> area_cd_sel = commonceService.getCommonCdListNew("B010");//지역

			model.addAttribute("mfc_bizrnm_sel", util.mapToJson(mfc_bizrnm_sel));	//생산자구분 리스트
			model.addAttribute("mfc_brch_nm_sel", "{}");	//직매장
			model.addAttribute("bizr_tp_cd_sel", util.mapToJson(bizr_tp_cd_sel));	//거래처구분
			model.addAttribute("area_cd_sel", util.mapToJson(area_cd_sel));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}


		String title = commonceService.getMenuTitle("EPWH0120631");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}


	/**
	 * 직매장별거래처관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epwh0120601_select2(Map<String, String> data, HttpServletRequest request) {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");

		String BIZRID_NO = data.get("MFC_BIZRNM_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}

		String BRCH_ID_NO = data.get("MFC_BRCH_NM_SEL");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}

		data.put("BIZRNO", vo.getBIZRNO_ORI());
		data.put("BIZRID", vo.getBIZRID());

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			List<?> menuList = epwh0120601Mapper.epwh0120601_select(data);
			map.put("searchList", util.mapToJson(menuList));
			map.put("totalCnt", epwh0120601Mapper.epwh0120601_select_cnt(data));
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
	 * 직매장별거래처관리 직매장/공장 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epwh0120601_select3(Map<String, String> data) {

		String BIZRID_NO = data.get("BIZRID_NO");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}else{
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
		}

		List<?> menuList = commonceService.brch_nm_select_all(data);

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
	 * 직매장별거래처관리 직매장/공장 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epwh0120601_select4(Map<String, String> data) {

		String BIZRID_NO = data.get("BIZRID_NO");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}else{
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
		}

		List<?> menuList = commonceService.brch_nm_select_all_y(data);

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
	 * 직매장별거래처관리 등록 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epwh0120631_select2(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZRNM_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}

		String BRCH_ID_NO = data.get("MFC_BRCH_NM_SEL");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}



		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			List<?> menuList = epwh0120601Mapper.epwh0120631_select(data);
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
	 * 거래상태 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epwh0120601_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		Map<String, String> map;
		String ssUserId  = "";   //사용자ID

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				List<?> list = JSONArray.fromObject(data.get("list"));
				String execStatCd = data.get("exec_stat_cd");
				for(int i=0; i<list.size(); i++) {
					map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					map.put("EXEC_STAT_CD", execStatCd);

					epwh0120601Mapper.epwh0120601_update(map);	//수정 처리

				}

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
	}

	/**
	 * 기준수수료생성
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epwh0120601_update2(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		Map<String, String> map;
		Map<String, String> map2;
		String ssUserId  = "";   //사용자ID

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				List<?> list = JSONArray.fromObject(data.get("list"));
				for(int i=0; i<list.size(); i++) {
					map = (Map<String, String>) list.get(i);
					map.put("REG_PRSN_ID", vo.getUSER_ID());

					epwh0120601Mapper.epwh0120601_delete(map); //미등록 상태인 경우 기준수수료정보 insert. 등록 상태인 경우 delete 후 insert
					List<?> ctnr_cd_list = epwh0120601Mapper.epwh0120601_select3(map); //생산자별 용기코드 및 기준수수료 리스트
					for(int k=0; k<ctnr_cd_list.size(); k++) {

						map2 = (Map<String, String>) ctnr_cd_list.get(k);

						map2.put("MFC_BRCH_ID", map.get("MFC_BRCH_ID"));
						map2.put("MFC_BRCH_NO", map.get("MFC_BRCH_NO"));
						map2.put("MFC_BIZRID", map.get("MFC_BIZRID"));
						map2.put("MFC_BIZRNO", map.get("MFC_BIZRNO"));
						map2.put("CUST_BRCH_ID", map.get("CUST_BRCH_ID"));
						map2.put("CUST_BRCH_NO", map.get("CUST_BRCH_NO"));
						map2.put("CUST_BIZRID", map.get("CUST_BIZRID"));
						map2.put("CUST_BIZRNO", map.get("CUST_BIZRNO"));

						map2.put("PSNB_CD", "S0003");
						String reg_sn 	= commonceService.psnb_select("S0003"); // 등록순번
						map2.put("PSNB_SEQ", reg_sn);
						String aplc_no = epwh0120601Mapper.epwh0120601_select4(map2); // 적용번호
						map2.put("REG_PRSN_ID", vo.getUSER_ID());
						map2.put("INDV_SN", reg_sn);
						map2.put("APLC_NO", aplc_no);
						map2.put("BTN_SE_CD", "IS");		//버튼 코드 저장
						epwh0120601Mapper.epwh0120601_insert(map2);  // 개별취급수수료 저장
						epwh0120601Mapper.epwh0120601_insert2(map2); // 개별취급수수료이력	저장
					}
					epwh0120601Mapper.epwh0120601_update2(map);  // 개별취급수수료 저장
				}

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
	}


	/**
	 * 등록확인화면 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh0120675_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPWH0120675");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 거래처 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epwh0120631_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		Map<String, String> map;
		String ssUserId  = "";   //사용자ID

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				List<?> list = JSONArray.fromObject(data.get("list"));

				for(int i=0; i<list.size(); i++) {
					map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);

					epwh0120601Mapper.epwh0120631_insert(map);

				}

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
	}

	/**
	 * 직매장거래처 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epwh0120601_excel(HashMap<String, Object> data, HttpServletRequest request) {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");

		String BIZRID_NO = (String) data.get("MFC_BIZRNM_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}

		String BRCH_ID_NO = (String) data.get("MFC_BRCH_NM_SEL");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}

		data.put("BIZRNO", vo.getBIZRNO_ORI());
		data.put("BIZRID", vo.getBIZRID());

		String errCd = "0000";
		try {
			List<?> list = epwh0120601Mapper.epwh0120601_excel(data);

			//object라 String으로 담아서 보내기
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());

			//엑셀파일 저장
			commonceService.excelSave(request, map, list);
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			return  "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		return errCd;
	}

}


