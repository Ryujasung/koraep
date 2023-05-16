package egovframework.koraep.mf.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF0160101Mapper;

/**
 * 마이페이지 정보조회
 * @author Administrator
 *
 */
@Service("epmf5599001Service")
public class EPMF5599001Service {

	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="epmf0160101Mapper")
	private EPMF0160101Mapper epmf0160101Mapper;
	
	/**
	 * 사업자상세 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf55990012_select(ModelMap model, HttpServletRequest request) {
		
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS", jParams);
		
		
		String title = commonceService.getMenuTitle("EPMF55990012");
		model.addAttribute("titleSub", title);
		
		HashMap<String, String> map = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if(vo != null){
			map.put("BIZRID", vo.getBIZRID());
			map.put("BIZRNO", vo.getBIZRNO_ORI());
		}
		
		model.addAttribute("searchDtl", util.mapToJson(epmf0160101Mapper.epmf0160116_select(map)));

		return model;
	}
	
	/**
	 * 사업자정보관리 사업자정보 변경
	 * @param data
	 * @param request
	 * @return
	 * @
	 */

	public ModelMap epmf55990422_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPMF55990422");
		model.addAttribute("titleSub", title);

		List<?> BankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
		model.addAttribute("BankCdList", util.mapToJson(BankCdList));
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> map = new HashMap<String, String>();
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if(vo != null){
			map.put("BIZRID", vo.getBIZRID());
			map.put("BIZRNO", vo.getBIZRNO_ORI());
		}
		
		HashMap<String, String> smap = (HashMap<String, String>)epmf0160101Mapper.epmf0160116_select(map);
		
		model.addAttribute("searchDtl", util.mapToJson(smap));

		return model;
	}
	
}
