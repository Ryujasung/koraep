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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH0121801Mapper;
import egovframework.mapper.wh.ep.EPWH2924601Mapper;
    
/**
 * 회수정보조회 Service     
 * @author 양성수  
 *
 */  
@Service("epwh2924601Service")   
public class EPWH2924601Service {   
	
	@Resource(name="epwh2924601Mapper")
	private EPWH2924601Mapper epwh2924601Mapper; //회수정보조회 Mapper

	@Resource(name="epwh0121801Mapper")
	private EPWH0121801Mapper epwh0121801Mapper; //소매거래처등록

	  
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 회수정보조회 초기화면
	 * @param inputMap  
	 * @param request   
	 * @return  
	 * @  
	 */
	  public ModelMap epwh2924601_select(ModelMap model, HttpServletRequest request) {
			
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			
			Map<String, String> map= new HashMap<String, String>();
			List<?> bizr_tp_cd_list	= commonceService.whsdl_se_select(request, map);  		 			//도매업자구분
			List<?> stat_cd_list		= commonceService.getCommonCdListNew("D020");						//상태
			String   title					= commonceService.getMenuTitle("EPWH2924601");						//타이틀

			
			HashMap<String, String> map2 = new HashMap<String, String>();

			List<?> langSeList = commonceService.getLangSeCdList();  // 언어코드
			map2 = (HashMap<String, String>)langSeList.get(0);       // 표준인놈으로 기타코드 가져오기

			map2.put("GRP_CD", "E001");   
			List<?> cpctCdList  = commonceService.getCommonCdListNew2(map2);   // 기타코드 용량코드

			map2.put("GRP_CD", "E002");
			List<?> prpsCdList  = commonceService.getCommonCdListNew2(map2);   // 기타코드 용어코드
			  
			try {
					/*
					//상세 들어갔다가 다시 관리 페이지로 올경우
					if(jParams.get("SEL_PARAMS") !=null){//상세 볼경우
						Map<String, String> paramMap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
						map.put("BIZR_TP_CD", paramMap.get("BIZR_TP_CD"));											//상세갔다올경우  구분 넣기
						if(paramMap.get("WHSDL_BIZRID") !=null && !paramMap.get("WHSDL_BIZRID").equals("") ){//도매업자 선택시
							paramMap.put("BIZRNO", paramMap.get("WHSDL_BIZRID"));					// 도매업자ID
							paramMap.put("BIZRID", paramMap.get("WHSDL_BIZRNO"));					// 도매업자사업자번호
							List<?> brch_cd_List = commonceService.brch_nm_select(request, paramMap);	 	// 도매업자 지점 조회	
							model.addAttribute("brch_cd_List", util.mapToJson(brch_cd_List));	
						}  
					} 
					*/
				
					List<?>	whsdl_cd_list = commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
					model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));	
					model.addAttribute("bizr_tp_cd_list", util.mapToJson(bizr_tp_cd_list));	
					model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));
					model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));
					model.addAttribute("cpctCdList", util.mapToJson(cpctCdList));
					model.addAttribute("titleSub", title);
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
		 * 회수정보조회 업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2924601_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      	rtnMap.put("whsdl_cd_list", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 도매업자 업체명조회
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 //사업자 직매장/공장 조회	
			return rtnMap;    	
	    }
	  
		/**
		 * 회수정보조회 지점조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2924601_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
    			
    			HttpSession session = request.getSession();
    			UserVO vo = (UserVO) session.getAttribute("userSession");
    			if(vo != null){
    				inputMap.put("BIZRID", vo.getBIZRID());
    				inputMap.put("BIZRNO", vo.getBIZRNO_ORI());
    				if(!vo.getBRCH_NO().equals("9999999999")){
    					inputMap.put("BRCH_ID", vo.getBRCH_ID());
    					inputMap.put("BRCH_NO", vo.getBRCH_NO());
    				}
    			}
    			
    			rtnMap.put("brch_cd_List", util.mapToJson(commonceService.brch_nm_select_all(inputMap))); // 도매업자 지점
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  //업체명 조회	
			return rtnMap;    	
	    }
	
		/**
		 * 회수정보조회  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2924601_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    		try {
	    			
	    			HttpSession session = request.getSession();
	    			UserVO vo = (UserVO) session.getAttribute("userSession");
	    			if(vo != null){
	    				inputMap.put("WHSDL_BIZRID", vo.getBIZRID());
	    				inputMap.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
	    				if(!vo.getBRCH_NO().equals("9999999999")){
	    					inputMap.put("S_BRCH_ID", vo.getBRCH_ID());
	    					inputMap.put("S_BRCH_NO", vo.getBRCH_NO());
	    				}
	    			}
	    			System.out.println("inputMap"+inputMap);
					rtnMap.put("selList", util.mapToJson(epwh2924601Mapper.epwh2924601_select(inputMap))); 
					rtnMap.put("totalList", util.mapToJson(epwh2924601Mapper.epwh2924601_select_cnt(inputMap)));
					//rtnMap.put("amt_tot_list", util.mapToJson(epwh2924601Mapper.epwh2924601_select2(inputMap))); 
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
		 * 회수정보조회 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh2924601_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
				
				HttpSession session = request.getSession();
    			UserVO vo = (UserVO) session.getAttribute("userSession");
    			if(vo != null){
    				data.put("WHSDL_BIZRID", vo.getBIZRID());
    				data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
    				if(!vo.getBRCH_NO().equals("9999999999")){
    					data.put("S_BRCH_ID", vo.getBRCH_ID());
    					data.put("S_BRCH_NO", vo.getBRCH_NO());
    				}
    			}
				
				List<?> list = epwh2924601Mapper.epwh2924601_select(data);
				
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
