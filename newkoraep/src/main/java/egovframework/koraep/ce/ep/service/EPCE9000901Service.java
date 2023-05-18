package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
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
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE9000901Mapper;
import egovframework.mapper.ce.ep.EPCE9000501Mapper;
import egovframework.mapper.ce.ep.EPCE9000801Mapper;

/**
 * 상계처리관리  서비스
 * @author Administrator
 *
 */
@Service("epce9000901Service")
public class EPCE9000901Service {

	@Resource(name="epce9000901Mapper")
	private EPCE9000901Mapper epce9000901Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000901_select(ModelMap model, HttpServletRequest request) {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> map = new HashMap<String, String>();

		List<?> stdMgntList = commonceService.std_mgnt_select(request, map); //정산기간
		List<?> excaSeList = commonceService.getCommonCdListNew("C023");
		List<?> excaProcStatList = epce9000901Mapper.epce9000901_select3();
		List<?> bizrTpList = epce9000901Mapper.epce9000901_select();
		
		try {
			//상세 들어갔다가 다시 관리 페이지로 올경우
			if(jParams.get("SEL_PARAMS") !=null){//상세 볼경우
				Map<String, String> paramMap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
				map.put("BIZR_TP_CD", paramMap.get("BIZR_TP_CD"));											//상세갔다올경우  구분 넣기
				if(paramMap.get("WHSDL_BIZRID") !=null && !paramMap.get("WHSDL_BIZRID").equals("") ){//도매업자 선택시
					paramMap.put("BIZRNO", paramMap.get("WHSDL_BIZRID"));					// 도매업자ID
					paramMap.put("BIZRID", paramMap.get("WHSDL_BIZRNO"));					// 도매업자사업자번호
				}  
			}  
						
			List<?> langSeList = commonceService.getLangSeCdList();  // 언어코드
			
			HashMap<String, String> map2 = new HashMap<String, String>();
			
			map2 = (HashMap<String, String>)langSeList.get(0);       // 표준인놈으로 기타코드 가져오기
			map2.put("GRP_CD", "E002");
			List<?> prpsCdList  = commonceService.getCommonCdListNew2(map2);   // 기타코드 용어코드
			
			model.addAttribute("stdMgntList", util.mapToJson(stdMgntList));
			model.addAttribute("excaSeList", util.mapToJson(excaSeList));
			model.addAttribute("excaProcStatList", util.mapToJson(excaProcStatList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));

		} catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 상계처리관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce9000901_select2(Map<String, String> data) {
		List<?> list = epce9000901Mapper.epce9000901_select2(data);
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
		} catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return map;
	}
	
	/**
	 * 상세페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000902_select(ModelMap model, HttpServletRequest request) {
		  
	  	//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		List<?>	initList 			= epce9000901Mapper.epce9000902_select(map);    	//상세 그리드 값
		String   title					= commonceService.getMenuTitle("EPCE9000902");		//타이틀
		try {
				model.addAttribute("initList", util.mapToJson(initList));	
				model.addAttribute("INQ_PARAMS",jParams);
				model.addAttribute("titleSub", title);
		} catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		return model;    	
    }
	
	/**
	 * 상계처리관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce9000901_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";
		try {
			data.put("excelYn", "Y");
			List<?> list = epce9000901Mapper.epce9000901_select2(data);
			HashMap<String, String> map = new HashMap();
						
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());
			
			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		return errCd;
	}
	
	/**
	 *  상계처리 상세조회 엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce9000902_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";
		try {
			data.put("excelYn", "Y");
			//data.put("WHSDL_BIZRNO", "4148100101");
			List<?> list = epce9000901Mapper.epce9000902_select2(data);
			HashMap<String, String> map = new HashMap();
			//map.put("WHSDL_BIZRNO", data.get("WHSDL_BIZRNO").toString());	
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());

			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
}
