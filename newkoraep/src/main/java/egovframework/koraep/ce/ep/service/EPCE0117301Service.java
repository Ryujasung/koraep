package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0117301Mapper;
import egovframework.mapper.ce.ep.EPCE0121801Mapper;

/**
 * 가맹점관리 서비스
 * @author Administrator
 *
 */
@Service("EPCE0117301Service")
public class EPCE0117301Service {

	@Resource(name="EPCE0117301Mapper")
	private EPCE0117301Mapper epce0117301Mapper;
	
	@Resource(name="epce0121801Mapper")
	private EPCE0121801Mapper epce0121801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap EPCE0117301_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("BIZR_TP_CD","W1");//도매업자
		List<?> bizrList = commonceService.bizr_select(map);
		
		List<?> areaList = commonceService.getCommonCdListNew("B010");//지역
		List<?> statList = commonceService.getCommonCdListNew("S011");//거래여부
		List<?> bizrTpList = epce0121801Mapper.epce0121801_select();//거래처구분
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList)); //도매업자
			model.addAttribute("areaList", util.mapToJson(areaList));
			model.addAttribute("statList", util.mapToJson(statList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
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
	 * 등록화면 페이지 초기화
	 * @param model
	 * @param request
	 * @return 
	 * @
	 */
	public ModelMap EPCE0117331_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("BIZR_TP_CD","W1");//도매업자
		List<?> bizrList = commonceService.bizr_select(map);
		
		List<?> bizrTpList = epce0121801Mapper.epce0121801_select();//거래처구분
		
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList)); //도매업자
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		String title = commonceService.getMenuTitle("EPCE0117331");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}
	
	/**
	 * 소매업무설정 페이지 초기화
	 * @param model
	 * @param request
	 * @return 
	 * @
	 */
	public ModelMap EPCE0117342_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("BIZR_TP_CD","W1");//도매업자
		List<?> bizrList = commonceService.bizr_select(map);
		
		List<?> bizrTpList = epce0121801Mapper.epce0121801_select();//거래처구분
		
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList)); //도매업자
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
			
			model.addAttribute("rtrvlRegSeList", util.mapToJson(commonceService.getCommonCdListNew("D051"))); //회수등록구분
			model.addAttribute("drctPaySeList", util.mapToJson(commonceService.getCommonCdListNew("D052"))); //직접지급구분
			model.addAttribute("btchAplcYnList", util.mapToJson(commonceService.getCommonCdListNew("D054"))); //일괄적용여부
			
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		String title = commonceService.getMenuTitle("EPCE0117342");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}
	
	/**
	 * 소매업무설정 도매업자 선택시
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce0117342_select(HashMap<String, String> data, HttpServletRequest request) {
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		
		String BIZRID_NO = data.get("BIZRID_NO");
		if (BIZRID_NO != null && !BIZRID_NO.equals("")) {
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
    	try {
    		rtnMap.put("selList", util.mapToJson(commonceService.brch_nm_select(request, data)));
			rtnMap.put("bizrno", epce0117301Mapper.epce0117342_select(data));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    	 
    	return rtnMap;    	
	}
	
	/**
	 * 적용대상 조회
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce0117342_select2(HashMap<String, String> data, HttpServletRequest request) {
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		
		String BIZRID_NO = data.get("WHSDL_BIZR");
		if (BIZRID_NO != null && !BIZRID_NO.equals("")) {
			data.put("WHSDL_BIZRID", BIZRID_NO.split(";")[0]);
			data.put("WHSDL_BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		if(data.containsKey("WHSDL_BRCH")){
			String BRCH_ID_NO = data.get("WHSDL_BRCH");
			if (BRCH_ID_NO != null && !BRCH_ID_NO.equals("")) {
				data.put("WHSDL_BRCH_ID", BRCH_ID_NO.split(";")[0]);
				data.put("WHSDL_BRCH_NO", BRCH_ID_NO.split(";")[1]);
			}
		}
		
    	try {
    		rtnMap.put("searchList", util.mapToJson(epce0117301Mapper.epce0117342_select2(data)));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}    	 
    	return rtnMap;    	
	}
	
	/**
	 * 업무설정 일괄적용
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce0117342_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				data.put("S_USER_ID", ssUserId);
				
				String BIZRID_NO = data.get("WHSDL_BIZR");
				if (BIZRID_NO != null && !BIZRID_NO.equals("")) {
					data.put("WHSDL_BIZRID", BIZRID_NO.split(";")[0]);
					data.put("WHSDL_BIZRNO", BIZRID_NO.split(";")[1]);
				}

				if(data.get("BTCH_APLC_YN").equals("N")){
					if(data.get("list") != null){ //개별적용
						List<?> list = JSONArray.fromObject(data.get("list"));
						for(int i=0; i<list.size(); i++){
							Map<String, String> map = (Map<String, String>)list.get(i);
							data.put("RTL_CUST_BIZRID", map.get("RTL_CUST_BIZRID"));
							data.put("RTL_CUST_BIZRNO", map.get("RTL_CUST_BIZRNO"));
							epce0117301Mapper.epce0117342_update(data);
						}
					}
				}else{ //일괄적용
					epce0117301Mapper.epce0117342_update(data);
				}
				
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
}