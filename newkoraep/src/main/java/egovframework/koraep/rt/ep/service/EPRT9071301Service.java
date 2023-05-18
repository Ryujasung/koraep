package egovframework.koraep.rt.ep.service;
  
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE0121801Mapper;
import egovframework.mapper.rt.ep.EPRT9071301Mapper;
    
/**
 * 지급내역조회 Service     
 * @author 양성수  
 *
 */  
@Service("eprt9071301Service")   
public class EPRT9071301Service {   
	
	@Resource(name="eprt9071301Mapper")
	private EPRT9071301Mapper eprt9071301Mapper;  //지급내역조회 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 지급내역조회 초기화면
	 * @param inputMap  
	 * @param request   
	 * @return  
	 * @  
	 */
	  public ModelMap eprt9071301_select(ModelMap model, HttpServletRequest request) {
			
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			try {
				model.addAttribute("INQ_PARAMS",jParams);
				
				List<?> statList = commonceService.getCommonCdListNew("D034");
				model.addAttribute("statList", util.mapToJson(statList));
				
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
		 * 지급내역조회 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap eprt9071301_select2(Map<String, String> inputMap, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				inputMap.put("BIZRID", vo.getBIZRID());  					
				inputMap.put("BIZRNO", vo.getBIZRNO_ORI());
				/////////////////
				if(!vo.getBRCH_NO().equals("9999999999")){
					inputMap.put("S_BRCH_ID", vo.getBRCH_ID());
					inputMap.put("S_BRCH_NO", vo.getBRCH_NO());
				}
			}
			
			List<?> list = eprt9071301Mapper.eprt9071301_select(inputMap);

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
		 * 지급내역상세조회 페이지 초기화
		 * @param model
		 * @param request
		 * @return
		 * @
		 */
		public ModelMap eprt9071364_select(ModelMap model, HttpServletRequest request) {

			String title = commonceService.getMenuTitle("EPRT9071364");
			model.addAttribute("titleSub", title);
			
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS", jParams);
			HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
			
			List<?> searchDtl = eprt9071301Mapper.eprt9071364_select(map);
			List<?> searchList = eprt9071301Mapper.eprt9071364_select2(map);
			
			try {
				model.addAttribute("searchDtl", util.mapToJson(searchDtl));
				model.addAttribute("searchList", util.mapToJson(searchList));
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
		 *  엑셀저장
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String eprt9071301_excel(HashMap<String, String> data, HttpServletRequest request) {
			String errCd = "0000";

			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				if(vo != null){
					data.put("BIZRID", vo.getBIZRID());  					
					data.put("BIZRNO", vo.getBIZRNO_ORI());
					/////////////////
					if(!vo.getBRCH_NO().equals("9999999999")){
						data.put("S_BRCH_ID", vo.getBRCH_ID());
						data.put("S_BRCH_NO", vo.getBRCH_NO());
					}
				}

				data.put("excelYn", "Y");
				List<?> list = eprt9071301Mapper.eprt9071301_select(data);

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
		 *  엑셀저장 - 상세조회
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String eprt9071364_excel(HashMap<String, String> data, HttpServletRequest request) {

			String errCd = "0000";

			try {

				data.put("excelYn", "Y");
				List<?> list = eprt9071301Mapper.eprt9071364_select2(data);

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
