package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE0105901Mapper;





/**
 * 빈용기기준금액관리 Service
 * @author 양성수
 *
 */
@Service("epce0105901Service")
public class EPCE0105901Service {
	
	@Resource(name="epce0105901Mapper")
	private EPCE0105901Mapper epce0105901Mapper;  //빈용기기준금액관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 빈용기기준금액관리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0105901_select(ModelMap model, HttpServletRequest request) {
		  
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			
			List<?> mfcSeCdList= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
			List<?> ctnrNmList=null;
			if(jParams.get("SEL_PARAMS") !=null){//반환상세 볼경우
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
				ctnrNmList = commonceService.ctnr_nm_select(request, map);
			}
			
			try {
				model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));	//생산자구분 리스트
				model.addAttribute("ctnrNmList", util.mapToJson(ctnrNmList));		//빈용기명
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
			
			return model;    	
	    }
	
		
	  
		/**
		 * 빈용기기준금액관리 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0105901_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
				rtnMap.put("initList", util.mapToJson(epce0105901Mapper.epce0105901_select(inputMap)));
				rtnMap.put("totalCnt", epce0105901Mapper.epce0105901_select_cnt(inputMap));
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
		 * 빈용기기준금액관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce0105901_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
				
				data.put("excelYn", "Y");
				List<?> list = epce0105901Mapper.epce0105901_select(data);
				
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);

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
		 * 빈용기기준금액관리 빈용기명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0105901_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	List<?> ctnrNmList = commonceService.ctnr_nm_select(request, inputMap);
	    	try {
				rtnMap.put("ctnrNmList", util.mapToJson(ctnrNmList));
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
	

}
