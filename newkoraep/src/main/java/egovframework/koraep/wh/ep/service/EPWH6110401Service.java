package egovframework.koraep.wh.ep.service;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH6110401Mapper;
import egovframework.mapper.wh.ep.EPWH2983931Mapper;

/**
 * 입고현황 Service
 * @author 양성수
 *
 */
@Service("epwh6110401Service")
public class EPWH6110401Service {  
	
	
	@Resource(name="epwh6110401Mapper")
	private EPWH6110401Mapper epwh6110401Mapper;  //입고현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 입고현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh6110401_select(ModelMap model, HttpServletRequest request) {
		  
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			List<?> ctnr_cd			= commonceService.ctnr_nm_select2(request, map);					//빈용기명 조회
			List<?> prps_cd			= commonceService.getCommonCdListNew("E002");		//빈용기구분 유흥/가정/직접 조회
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
			List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역    E002
			String   title					= commonceService.getMenuTitle("EPWH6110401");		//타이틀
			List<?>	whsdlList		=commonceService.mfc_bizrnm_select4(request, map);				//도매업자
			
			
			try {
				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
				model.addAttribute("areaList", util.mapToJson(areaList));	
				model.addAttribute("prps_cd", util.mapToJson(prps_cd));	
				model.addAttribute("ctnr_cd", util.mapToJson(ctnr_cd));
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
			model.addAttribute("titleSub", title);
			return model;    	
	    }
	  
		/**
		 * 입고현황 생산자변경시  생산자에맞는 빈용기명  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh6110401_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	      		
	    		try {
	    			rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 도매업자 업체명조회
					rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  //빈용기
	      		return rtnMap;    	
	    }
		/**
		 * 입고현황 생산자변경시  생산자에맞는 빈용기명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh6110401_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
					rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  //빈용기
	      		return rtnMap;    	
	    }
		
		/**
		 * 입고현황  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh6110401_select4(Map<String, String> inputMap, HttpServletRequest request) {
		
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	
		    	HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				inputMap.put("WHSDL_BIZRID", vo.getBIZRID());  					
				inputMap.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());  	
				if(!vo.getBRCH_NO().equals("9999999999")){
					inputMap.put("WHSDL_BRCH_ID", vo.getBRCH_ID());  				// 지점ID
					inputMap.put("WHSDL_BRCH_NO", vo.getBRCH_NO());  			// 지점번호
				}
	    	  	
	    		try {
	    			if( inputMap.get("CHART_YN") !=null && inputMap.get("CHART_YN").equals("Y")  ){
		    	  		rtnMap.put("selList_chart", util.mapToJson(epwh6110401Mapper.epwh6110401_select2(inputMap)));	  
		    	  	}
		    	
		    		rtnMap.put("selList", util.mapToJson(epwh6110401Mapper.epwh6110401_select(inputMap)));	  
					rtnMap.put("totalList", epwh6110401Mapper.epwh6110401_select_cnt(inputMap));
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
	    	return rtnMap;    	
	    }
		
		/**
		 * 입고현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh6110401_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
				
				HashMap<String, Object> rtnMap = new HashMap<String, Object>();
				
		    	HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				data.put("WHSDL_BIZRID", vo.getBIZRID());  					
				data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());  	
				if(!vo.getBRCH_NO().equals("9999999999")){
					data.put("WHSDL_BRCH_ID", vo.getBRCH_ID());  				// 지점ID
					data.put("WHSDL_BRCH_NO", vo.getBRCH_NO());  			// 지점번호
				}
				
				List<?> list = epwh6110401Mapper.epwh6110401_select(data);
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
