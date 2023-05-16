package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0182901Mapper;

/**
 * 회수수수료관리 Service
 * @author 양성수
 *
 */
@Service("epce0182901Service")
public class EPCE0182901Service {
	
	
	@Resource(name="epce0182901Mapper")
	private EPCE0182901Mapper epce0182901Mapper;  //회수수수료관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	
	/**
	 * 회수수수료관리 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0182901_select(ModelMap model, HttpServletRequest request) {
		     
		  
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		 	List<?> initList		=  epce0182901Mapper.epce0182901_select(map);
			String   title			=  commonceService.getMenuTitle("EPCE0182901");
			
			try {
				model.addAttribute("initList", util.mapToJson(initList));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}     //회수수수료관리  초기 리스트
			model.addAttribute("INQ_PARAMS",jParams);
			model.addAttribute("titleSub", title);
	    	
			return model;    	
	    }
	  
  /**
	 * 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce0182901_select2(Map<String,String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
				rtnMap.put("selList", util.mapToJson(epce0182901Mapper.epce0182901_select(inputMap))); 
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  
    	return rtnMap;    	
    } 
	  
	  
	/**
	 * 회수수수료관리 삭제
	 * 
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public String epce0182901_delete(Map<String, String> inputMap,	HttpServletRequest request) throws Exception  {

		String errCd = "0000";
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			int sel_rst = epce0182901Mapper.epce0182901_select2(inputMap); // 회수수수료관리 삭제여부 가능한지 확인
			if(sel_rst>0){
				throw new Exception("A006"); // 이미 적용 중인 내역은 삭제할 수 없습니다.
			}
			epce0182901Mapper.epce0182901_delete(inputMap); // 회수수수료관리 삭제

		} catch (Exception e) {
			if (e.getMessage().equals("A006")) {
				 throw new Exception(e.getMessage()); 
			} else {
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}

		return errCd;
	}  
	
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//	회수수수료 등록
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
	  
	  
	/**
	 * 회수수수료등록 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0182931_select(ModelMap model, HttpServletRequest request) {
		    
			String reqParams		= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
	   		JSONObject jParams	= JSONObject.fromObject(reqParams);
	   		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));	
		 	List<?> initList		=  epce0182901Mapper.epce0182931_select3(map);
		 	String   title            =  commonceService.getMenuTitle("EPCE0182931");
		 	
		 	try {
				model.addAttribute("initList", util.mapToJson(initList));
		   		model.addAttribute("INQ_PARAMS", jParams);
				model.addAttribute("titleSub", title);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}  
			return model;    	
	    }
	/**
	 * 회수수수료  저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
		public String epce0182931_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
	
			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				
				int sel_rst = epce0182901Mapper.epce0182931_select(inputMap); //적용기간 중복체크
	
				if(sel_rst>0){
					throw new Exception("A005"); // 적용기간은 중복될 수 없습니다. 다시 한 번 확인해주시기 바랍니다.
				}
	
				String reg_sn = epce0182901Mapper.epce0182931_select2(inputMap);   //등록순번
				inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
				inputMap.put("REG_SN", reg_sn);
				epce0182901Mapper.epce0182931_insert(inputMap); // 회수수수료 저장
				
			} catch (Exception e) {
				if (e.getMessage().equals("A005")) {
					 throw new Exception(e.getMessage()); 
				} else {
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}
			return errCd;
		}
		
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//	회수수수료 수정
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
		
	/**
	 * 회수수수료변경 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0182942_select(ModelMap model, HttpServletRequest request) {
		  
		  	String reqParams				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
	   		JSONObject jParams			= JSONObject.fromObject(reqParams);
	   		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
	   		List<?> initList					=  epce0182901Mapper.epce0182942_select(map);
			String title 						= commonceService.getMenuTitle("EPCE0182942");
			
			try {
					model.addAttribute("initList", util.mapToJson(initList));
					model.addAttribute("titleSub", title);
					model.addAttribute("INQ_PARAMS", jParams);
			} catch (Exception e) {
				// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}   
			return model;    	
	    }
	  
	
	/**
	* 회수수수료 수정
	* @param data
	* @param request
	* @return
	 * @throws Exception 
	* @
	*/
	public String epce0182942_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
	
	String errCd = "0000";
	try {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
	
		int sel_rst = epce0182901Mapper.epce0182931_select(inputMap); //적용기간 중복체크
		if (sel_rst > 0) {
			throw new Exception("A005"); //적용기간은 중복될 수 없습니다. 다시 한 번 확인해주시기 바랍니다.
		}
		inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
		epce0182901Mapper.epce0182942_update(inputMap);  //회수수수료 수정
	}catch(Exception e){
		 if(e.getMessage().equals("A005")){
			throw new Exception(e.getMessage()); 
		 }else{
			 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		 }
	}
	return errCd;	
	}	  
		  
		  
	  
	  
	  
	  
	  
	  
	  
	  

}
