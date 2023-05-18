package egovframework.koraep.mf.ep.service;

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
import egovframework.mapper.mf.ep.EPMF0130001Mapper;
import net.sf.json.JSONObject;

/**
 * 입고정보생산자ERP대조 Service
 * @author 이근표
 *
 */
@Service("epmf0130001Service")
public class EPMF0130001Service {


	@Resource(name="epmf0130001Mapper")
	private EPMF0130001Mapper epmf0130001Mapper;//입고정보생산자ERP대조 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;//공통

	/**
	 * 입고정보생산자ERP대조 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf0130001_select(ModelMap model, HttpServletRequest request) {

	  	//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		Map<String, String> map= new HashMap<String, String>();

		List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request);//생산자
		List<?> whsl_se_cdList = commonceService.whsdl_se_select(request, map); //도매업자구분

		try {
			model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));
			model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));

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
	 * 입고정보생산자ERP대조 리스트 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf0130001_select2(Map<String, String> data, HttpServletRequest request) {

		HashMap<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		data.put("MFC_BIZRID", vo.getBIZRID());
		data.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
		

		String BRCH_ID_NO = data.get("MFC_BRCH_SEL");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}

		String BIZRID_NO2 = data.get("WHSDL_BIZR_SEL");
		if(BIZRID_NO2 != null && !BIZRID_NO2.equals("")){
			data.put("WHSDL_BIZRID", BIZRID_NO2.split(";")[0]);
			data.put("WHSDL_BIZRNO", BIZRID_NO2.split(";")[1]);
		}

		try {
			map.put("searchList", util.mapToJson(epmf0130001Mapper.epmf0130001_select(data)));
			map.put("totalList", util.mapToJson(epmf0130001Mapper.epmf0130001_select_cnt(data)));
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
  	 * 엑셀
  	 * @param map
  	 * @param request
  	 * @return
  	 * @
  	 */
	public String epmf0130001_excel(HashMap<String, String> data, HttpServletRequest request) {

  		String errCd = "0000";

  		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		data.put("MFC_BIZRID", vo.getBIZRID());
		data.put("MFC_BIZRNO", vo.getBIZRNO_ORI());
		

		String BRCH_ID_NO = data.get("MFC_BRCH_SEL");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}

		String BIZRID_NO2 = data.get("WHSDL_BIZR_SEL");
		if(BIZRID_NO2 != null && !BIZRID_NO2.equals("")){
			data.put("WHSDL_BIZRID", BIZRID_NO2.split(";")[0]);
			data.put("WHSDL_BIZRNO", BIZRID_NO2.split(";")[1]);
		}

  		try {

  			data.put("excelYn", "Y");
  			List<?> list = epmf0130001Mapper.epmf0130001_select(data);

  			//엑셀파일 저장
  			commonceService.excelSave(request, data, list);

  		}catch (IOException io) {
  			System.out.println(io.toString());
  		}catch (SQLException sq) {
  			System.out.println(sq.toString());
  		}catch (NullPointerException nu){
  			System.out.println(nu.toString());
  		}catch(Exception e){
  			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
  		}

  		return errCd;
  	}
}
