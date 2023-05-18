package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE8149301Mapper;

/**
 * 팝업관리 서비스
 * @author Administrator
 *
 */
@Service("epce8149301Service")
public class EPCE8149301Service {

	@Resource(name="epce8149301Mapper")
	private EPCE8149301Mapper epce8149301Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 팝업조회 리스트
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public String epce8149301_select1(HashMap<String, String> map) {

		List<?> list = epce8149301Mapper.epce8149301_select1(map);
		if(list == null || list.size() == 0) return "[]";
			
		//for(int i=0;i<list.size();i++){
		//	Map<String, String> rtn = (Map<String, String>) list.get(i);
			//rtn.put("SBJ", XSSFilter.getFilter(rtn.get("SBJ")));
		//}
		
		String rtn = "";
		
		try {
			rtn = util.mapToJson(list).toString();
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
		
		return rtn;
	}
	
	
	/**
	 * 팝업 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce8149301_select2(ModelMap model, HttpServletRequest request) {
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		HashMap<String, String> params = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		String title = commonceService.getMenuTitle("EPCE8149331");	//타이틀
		model.addAttribute("titleSub", title);
		
		//String POP_SEQ = request.getParameter("POP_SEQ");
		String POP_SEQ = "";
		if(params != null && !params.get("POP_SEQ").equals("")){
			POP_SEQ = params.get("POP_SEQ");
		}
		
		if(POP_SEQ == null || POP_SEQ.equals("")) return model;
		
		HashMap<String, String> map = epce8149301Mapper.epce8149301_select2(POP_SEQ);
		if(map == null) return model;
		
		Iterator<String> it = map.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
			String val = map.get(key);
			//if(key.equals("SBJ") || key.equals("CNTN")) val = XSSFilter.getFilter(val);
			model.addAttribute(key, val);
		}
		
		return model;
	}
	
	
	/**
	 * 팝업 상세(미리)보기
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public String epce8149301_select3(HashMap<String, String> paramMap) {
		String POP_SEQ = paramMap.get("POP_SEQ");
		if(POP_SEQ == null || POP_SEQ.equals("")) return "";
		
		HashMap<String, String> map = epce8149301Mapper.epce8149301_select2(POP_SEQ);
		
		return util.mapToJson(map).toString();
	}
	
	
	/**
	 * 팝업 등록/수정
	 * @param request
	 * @return
	 * @
	 */
	public String epce8149301_update(HashMap<String, String> map, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		if(vo == null) return "1";
		
		map.put("REG_PRSN_ID", vo.getUSER_ID());
		map.put("UPD_PRSN_ID", vo.getUSER_ID());
		
		/*
		Map<String, String> map = new HashMap<String, String>();
		map.put("REG_PRSN_ID", vo.getUSER_ID());
		map.put("UPD_PRSN_ID", vo.getUSER_ID());
		
		Enumeration<String> keys = request.getParameterNames();
		while(keys.hasMoreElements()){
			String key = keys.nextElement();
			map.put(key, request.getParameter(key));
		}
		*/
				
		if(map.get("POP_SEQ") == null || map.get("POP_SEQ").equals("")){
			epce8149301Mapper.epce8149301_update1(map);
		}else{
			epce8149301Mapper.epce8149301_update2(map);
		}
		
		return "0";
	}
	

	/**
	 * 팝업 삭제
	 * @param request
	 * @return
	 * @
	 */
	public String epce8149301_delete(HttpServletRequest request) {
		String POP_SEQ = request.getParameter("POP_SEQ");
		if(POP_SEQ == null || POP_SEQ.equals("")) return "1";
		
		epce8149301Mapper.epce8149301_delete(POP_SEQ);
		
		return "0";
	}

	/**사용여부 변경*/
	public String epce8149301_update3(HttpServletRequest request) {
		String POP_SEQ = request.getParameter("POP_SEQ");
		if(POP_SEQ == null || POP_SEQ.equals("")) return "1";
		
		epce8149301Mapper.epce8149301_update3(POP_SEQ);
		
		return "0";
	}


	public Map<String, Object> popRegId(HashMap<String, String> data) {
		// TODO Auto-generated method stub
		return epce8149301Mapper.popRegId(data);
	}
	
}
