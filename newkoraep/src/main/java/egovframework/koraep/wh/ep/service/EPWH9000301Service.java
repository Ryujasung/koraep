package egovframework.koraep.wh.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
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
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH9000301Mapper;

/**
 * 반환관리 Service
 * @author 양성수
 *
 */
@Service("epwh9000301Service")
public class EPWH9000301Service {


	@Resource(name="epwh9000301Mapper")
	private EPWH9000301Mapper epwh9000301Mapper;  //반환관리 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 반환관리 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh9000301_select(ModelMap model, HttpServletRequest request) {

		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			Map<String, String> map= new HashMap<String, String>();
			List<?> ctnr_seList = commonceService.getCommonCdListNew("E002");
			List<?> dtList				= commonceService.getCommonCdListNew("D022");	//반환등록일자구분
			List<?> stat_cdList		= commonceService.getCommonCdListNew("D021");	//상태
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
			List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
			List<?> sys_seList		= commonceService.getCommonCdListNew("S004");		//등록구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역
			String   title					= commonceService.getMenuTitle("EPWH9000301");		//타이틀
			List<?>	whsdlList 		=commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
			List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPWH9000301",request);		//그리드컬럼 조회
			HashMap<String, String> map2 = new HashMap<String, String>();
			List<?> langSeList = commonceService.getLangSeCdList();  // 언어코드
			map2 = (HashMap<String, String>)langSeList.get(0);       // 표준인놈으로 기타코드 가져오기
			map2.put("GRP_CD", "E001");   
			List<?> cpctCdList  = commonceService.getCommonCdListNew2(map2);   // 기타코드 용량코드
			
			List<?> AreaCdList = commonceService.getCommonCdListNew("B010");
			
			List<?>	rcsList = rcs_nm_select(request, map);
			

			try {
				//반환내역상세 들어갔다가 다시 관리 페이지로 올경우
				Map<String, String> paramMap = new HashMap<String, String>();

				if(jParams.get("SEL_PARAMS") !=null){//반환상세 볼경우
					JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
					if(param2.get("MFC_BIZRID") !=null){//생산자사업자 선택시
						paramMap.put("BIZRNO", param2.get("MFC_BIZRNO").toString());					//생산자ID
						paramMap.put("BIZRID", param2.get("MFC_BIZRID").toString());					//생산자 사업자번호
						List<?> brch_nmList = commonceService.brch_nm_select(request, paramMap);	 	  	//사업자 직매장/공장 조회
						model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));
					}
				}
				model.addAttribute("grid_info", util.mapToJson(grid_info));
				model.addAttribute("dtList", util.mapToJson(dtList));
				model.addAttribute("sys_seList", util.mapToJson(sys_seList));
				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));
				model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));
				model.addAttribute("areaList", util.mapToJson(areaList));
				model.addAttribute("cpctCdList", util.mapToJson(cpctCdList));
				model.addAttribute("AreaCdList", util.mapToJson(AreaCdList));
				model.addAttribute("rcsList", util.mapToJson(rcsList));
				model.addAttribute("titleSub", title);
				model.addAttribute("ctnr_seList", util.mapToJson(ctnr_seList));
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
		 * 반환관리 초기화면 (20200402 추가)
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epwh9000301_select_1(ModelMap model, HttpServletRequest request) {

			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				model.addAttribute("INQ_PARAMS",jParams);

				Map<String, String> map= new HashMap<String, String>();
				List<?> dtList				= commonceService.getCommonCdListNew("D022");	//반환등록일자구분
				List<?> stat_cdList		= commonceService.getCommonCdListNew("D021");	//상태
				List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
				List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
				List<?> sys_seList		= commonceService.getCommonCdListNew("S004");		//등록구분
				List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역
				String   title					= commonceService.getMenuTitle("EPWH9000302");		//타이틀
				List<?>	whsdlList 		=commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
				List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPWH9000301",request);		//그리드컬럼 조회
				
				List<?> ctnrNmList = commonceService.ctnr_nm_select2(request, map); //빈용기명
				model.addAttribute("ctnrNmList", util.mapToJson(ctnrNmList));

				try {
					//반환내역상세 들어갔다가 다시 관리 페이지로 올경우
					Map<String, String> paramMap = new HashMap<String, String>();

					if(jParams.get("SEL_PARAMS") !=null){//반환상세 볼경우
						JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
						if(param2.get("MFC_BIZRID") !=null){//생산자사업자 선택시
							paramMap.put("BIZRNO", param2.get("MFC_BIZRNO").toString());					//생산자ID
							paramMap.put("BIZRID", param2.get("MFC_BIZRID").toString());					//생산자 사업자번호
							List<?> brch_nmList = commonceService.brch_nm_select(request, paramMap);	 	  	//사업자 직매장/공장 조회
							model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));
						}
					}
					model.addAttribute("grid_info", util.mapToJson(grid_info));
					model.addAttribute("dtList", util.mapToJson(dtList));
					model.addAttribute("sys_seList", util.mapToJson(sys_seList));
					model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));
					model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));
					model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));
					model.addAttribute("whsdlList", util.mapToJson(whsdlList));
					model.addAttribute("areaList", util.mapToJson(areaList));
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
		 * 반환관리 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh9000301_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	try {
		      	rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		    	inputMap.put("BIZR_TP_CD", "");
				rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); 		// 생산자 직매장
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
		 * 반환관리 생산자 직매장/공장 선택시  업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh9000301_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
				rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
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
		 * 반환관리 도매업자 구분 선택시 업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh9000301_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	try {
		      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
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
	 	 * 정보수정 초기 화면
	 	 * @param inputMap
	 	 * @param request   
	 	 * @return   
	 	 * @          
	 	 */  
	 	  public ModelMap epwh9000342_select(ModelMap model, HttpServletRequest request) {
	 		                      
	 		  	//파라메터 정보  
	 			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");      
	 			JSONObject jParams = JSONObject.fromObject(reqParams);    
	 			Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));   
	 			
	 			
	 			
				List<?> dtList				= commonceService.getCommonCdListNew("D022");	//반환등록일자구분
				List<?> stat_cdList		= commonceService.getCommonCdListNew("D021");	//상태
//				List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
				List<?> sys_seList		= commonceService.getCommonCdListNew("S004");		//등록구분
//				List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역
//				String   title					= commonceService.getMenuTitle("EPCE9000301");		//타이틀
//				List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPCE9000301",request);		//그리드컬럼 조회
				HashMap<String, String> map2 = new HashMap<String, String>();
				List<?> langSeList = commonceService.getLangSeCdList();  // 언어코드
				map2 = (HashMap<String, String>)langSeList.get(0);       // 표준인놈으로 기타코드 가져오기
				map2.put("GRP_CD", "E001");   
				List<?> cpctCdList  = commonceService.getCommonCdListNew2(map2);   // 기타코드 용량코드
				
				List<?> AreaCdList = commonceService.getCommonCdListNew("B010");
				List<?>	rcsList = rcs_nm_select(request, map);
	 			
	 			//String   title					= commonceService.getMenuTitle("EPCE2925842");		//타이틀   
	 			//List<?>	initList 			= epce9000301Mapper.epce9000342_select(map);    	//상세 그리드 값  
	 			//map.put("WORK_SE", "4"); 																			//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
				//HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);				//등록일자제한설정  
				
//				map.put("BIZRID", map.get("WHSDL_BIZRID"));
//	 			map.put("BIZRNO", map.get("WHSDL_BIZRNO"));
	 			//List<?>	brch_nmList 	= commonceService.brch_nm_select(request, map);    				//도매업자지점
	 			//model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	  
	 			try {  
//	 				model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));	     
//	 				model.addAttribute("initList", util.mapToJson(initList));	      
	 				model.addAttribute("INQ_PARAMS",util.mapToJson((HashMap<?, ?>) map));
	 				//model.addAttribute("titleSub", title);            
					model.addAttribute("dtList", util.mapToJson(dtList));
					model.addAttribute("rcsList", util.mapToJson(rcsList));
					model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));
					model.addAttribute("cpctCdList", util.mapToJson(cpctCdList));
					model.addAttribute("AreaCdList", util.mapToJson(AreaCdList));
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
		 * 반환관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh9000301_select5(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				inputMap.put("T_USER_ID", vo.getUSER_ID());
			}

	    		try {
	    			/*
	    			//멀티selectbox 일경우
	    			List<?> list = JSONArray.fromObject(inputMap.get("WHSDL_LIST"));
	    			inputMap.put("WHSDL_LIST", list);  */

					rtnMap.put("selList", util.mapToJson(epwh9000301Mapper.epwh9000301_select4(inputMap)));
					rtnMap.put("amt_tot_list", util.mapToJson(epwh9000301Mapper.epwh9000301_select4_1_1(inputMap)));
					//rtnMap.put("totalList", util.mapToJson(epce9000301Mapper.epce9000301_select4_cnt(inputMap)));
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
		 * 반환내역상제조회(20200402추가)
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh9000301_select5_1(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			

			if(vo != null ){
				inputMap.put("T_USER_ID", vo.getUSER_ID());
			}

	    		try {
	    			/*
	    			//멀티selectbox 일경우
	    			List<?> list = JSONArray.fromObject(inputMap.get("WHSDL_LIST"));
	    			inputMap.put("WHSDL_LIST", list);  */
	    			List<?> list_c = JSONArray.fromObject(inputMap.get("CTNR_LIST"));
	    			inputMap.put("CTNR_LIST", list_c); 
					rtnMap.put("selList", util.mapToJson(epwh9000301Mapper.epwh9000301_select4_1(inputMap)));
					rtnMap.put("totalList", util.mapToJson(epwh9000301Mapper.epwh9000301_select4_1_cnt(inputMap)));
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
		 * 반환관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh9000301_excel(HashMap<String, Object> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epwh9000301Mapper.epwh9000301_select4(data);
				
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
		
		/**
		 * 반환내역서상세 엑셀(20200402추가)
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh9000302_excel(HashMap<String, Object> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
			data.put("CTNR_LIST", list_c); 
			
			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epwh9000301Mapper.epwh9000301_select4_1(data);

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

		/**
		 * 반환관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh9000364_excel(HashMap<String, String> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epwh9000301Mapper.epwh9000364_select2(data);

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


		/**
		 * 반환관리  삭제
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epwh9000301_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));

			try {
				if (list != null) {
					for (int i = 0; i < list.size(); i++) {
						map = (Map<String, String>) list.get(i);
//						int stat = epce9000301Mapper.epce9000301_select6(map); // 상태 체크
//						if (stat > 0) {
//							throw new Exception("A009"); // 반환정보가 변경되었습니다. 다시 조회하시기 바랍니다.
//						}
						epwh9000301Mapper.epwh9000301_delete(map); // 반환내역서 삭제
					}
				}else{
					epwh9000301Mapper.epwh9000301_delete(inputMap);
				}

				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					if (e.getMessage().equals("A009")) {
						 throw new Exception(e.getMessage());
					} else {
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					}
				}
			
			return errCd;
		}
		
		/**
		 * 모바일반환관리  삭제
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epwh9000301_delete_2(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));

			try {

					epwh9000301Mapper.epwh9000301_delete(inputMap);


				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					if (e.getMessage().equals("A009")) {
						 throw new Exception(e.getMessage());
					} else {
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					}
				}
			
			return errCd;
		}

		/**
		 * 반환관리  실태조사
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epwh9000301_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String rsrc_doc_no ="";

			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);

						int stat = epwh9000301Mapper.epwh9000301_select5(map); //상태 체크
						 if(stat>0){
							throw new Exception("A010"); //실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다.
						 }

						String doc_psnb_cd ="RC"; 								   						//	RC 실태조사
						rsrc_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	//문서번호 가져오기
						map.put("RSRC_DOC_NO", rsrc_doc_no);					//	문서채번
						map.put("REQ_ID", vo.getUSER_ID());  						//요청자
						map.put("REQ_BIZRID", vo.getBIZRID());  					//요청사업자ID
						map.put("REQ_BIZRNO", vo.getBIZRNO_ORI());  		//요청사업자등록번호
						map.put("REQ_BRCH_ID", vo.getBRCH_ID());  			//요청지점ID
						map.put("REQ_BRCH_NO", vo.getBRCH_NO());  		//요청지점번호
						map.put("REQ_BIZR_TP_CD", vo.getBIZR_TP_CD());  	//요청회원구분코드
						map.put("RTN_STAT_CD", "RR");
						epwh9000301Mapper.epwh9000301_insert(map); 		//실태조사요청정보 테이블에 등록
						epwh9000301Mapper.epwh9000301_update(map); 	// 반환내역서 실태조사

					}
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch (Exception e) {
					 if(e.getMessage().equals("A010")){
						 throw new Exception(e.getMessage());
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
			}

			return errCd;
	    }
		
		
		/**
		 * 반환등록요청 일괄확인
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epwh9000301_update2(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);

						int stat = epwh9000301Mapper.epwh9000301_select7(map); //상태 체크
						
						if(stat>0){
							throw new Exception("A027"); //실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다.
						}

						map.put("REG_PRSN_ID", vo.getUSER_ID());  						//요청자

						epwh9000301Mapper.epwh9000301_insert2(map); //반환등록요청 일괄확인
					}
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch (Exception e) {
					 if(e.getMessage().equals("A010")){
						 throw new Exception(e.getMessage());
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
			}

			return errCd;
	    }		

		/**
		 * 반환관리 상세조회 초기 화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epwh9000364_select(ModelMap model, HttpServletRequest request) {
			  /*
			  	HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				String ssUserNm = "";   //사용자명
				String ssBizrNm = "";   //부서명

				if(vo != null){
					ssUserNm = vo.getUSER_NM();
					ssBizrNm = vo.getBIZRNM();
				}

				model.addAttribute("ssUserNm", ssUserNm);
				model.addAttribute("ssBizrNm", ssBizrNm);
				*/
			  
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				List<?> initList = epwh9000301Mapper.epwh9000364_select_7(map);		//상세내역 조회

				//model.addAttribute("searchDtl", util.mapToJson(epwh9000301Mapper.epwh9000364_select_7(map)));
				//String title = commonceService.getMenuTitle("EPWH9000364");		//타이틀
				//List<?> gridList = epwh9000301Mapper.epwh9000364_select2(map);		//그리드쪽 조회

				try {
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("initList", util.mapToJson(initList));
					//model.addAttribute("gridList", util.mapToJson(gridList));
					//model.addAttribute("titleSub", title);
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
			 * 반환내역서등록  저장
			 * @param data
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
		    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
			public String epwh9000301_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					String errCd = "0000";
					
					//Map<String, String> map;
					List<?> list = JSONArray.fromObject(inputMap.get("list"));
					List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
					
					List<?> qtyList;
					Map<String, String> data;
					Map<String, String> qtyMap;
					String strCtnrCd;
					
					boolean keyCheck = false;
					int sel = 0;
					
					if (list != null) {
						
						
						try {
							int cnt = 0;	
							for(int i=0; i<list.size(); i++){
								String rtn_doc_no ="";
								keyCheck = false;
								Map<String, String> map = (Map<String, String>) list.get(i);
								map.put("REG_PRSN_ID", vo.getUSER_ID());  						//등록자
//								map.put("SDT_DT", map.get("RTN_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
//								//map.put("WORK_SE", "5"); 						//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
//								sel =commonceService.rtc_dt_ck(map);	//등록일자제한설정
//								if(sel !=1){
//									throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
//								}
								int result = epwh9000301Mapper.epwh9000301_check(map);
								if(result == 1){
									cnt += 0;
								} else{
									cnt+=1;
								}								
							}//end of for
							
							for(int i=0; i<list.size(); i++){
								if(cnt == 0){
									Map<String, String> map = (Map<String, String>) list.get(i);
									map.put("REG_PRSN_ID", vo.getUSER_ID());
									epwh9000301Mapper.epwh9000301_insert2(map); 	
								}else{
									errCd = "1111";
								}
							}
							
						}catch (IOException io) {
							System.out.println(io.toString());
						}catch (SQLException sq) {
							System.out.println(sq.toString());
						}catch (NullPointerException nu){
							System.out.println(nu.toString());
						} catch (Exception e) {
							 if(e.getMessage().equals("A003")){
								 throw new Exception(e.getMessage()); 
							 }else  if(e.getMessage().equals("A021")){
								 throw new Exception(e.getMessage());
							 }else if(e.getMessage().charAt(0) == 'D' || e.getMessage().charAt(0) == 'R') {
								 throw new Exception(e.getMessage());
							 }else{
								 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
							 }
						}
					}//end of list
					return errCd;
		    }
		    
		    /**
			 * 수정
			 * @param data
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
		    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
			public String epwh9000342_update(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					String errCd = "0000";
					
					//Map<String, String> map;
					List<?> list = JSONArray.fromObject(inputMap.get("list"));
					List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
					
					List<?> qtyList;
					Map<String, String> data;
					Map<String, String> qtyMap;
					String strCtnrCd;
					
					boolean keyCheck = false;
					int sel = 0;
					
					if (list != null) {
						
						
						try {
								
							for(int i=0; i<list.size(); i++){
								String rtn_doc_no ="";
								keyCheck = false;
								Map<String, String> map = (Map<String, String>) list.get(i);
								map.put("REG_PRSN_ID", vo.getUSER_ID());  						//등록자
//								map.put("SDT_DT", map.get("RTN_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
//								//map.put("WORK_SE", "5"); 						//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
//								sel =commonceService.rtc_dt_ck(map);	//등록일자제한설정
//								if(sel !=1){
//									throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
//								}
								
								int result = epwh9000301Mapper.epwh9000301_check(map);
								if(result == 1){
							 	//detail
									epwh9000301Mapper.epwh9000342_update(map); 		// 반환상세
								}else{
									errCd = "1111";
								}
							}//end of for
							
						}catch (IOException io) {
							System.out.println(io.toString());
						}catch (SQLException sq) {
							System.out.println(sq.toString());
						}catch (NullPointerException nu){
							System.out.println(nu.toString());
						} catch (Exception e) {
							 if(e.getMessage().equals("A003")){
								 throw new Exception(e.getMessage()); 
							 }else  if(e.getMessage().equals("A021")){
								 throw new Exception(e.getMessage());
							 }else if(e.getMessage().charAt(0) == 'D' || e.getMessage().charAt(0) == 'R') {
								 throw new Exception(e.getMessage());
							 }else{
								 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
							 }
						}
					}//end of list
					return errCd;
		    }
		    
		    /**
			 *  엑셀 업로드 후처리
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epwh9000331_select8(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	try {
					rtnMap.put("selList", util.mapToJson(epwh9000301Mapper.epwh9000331_select4(inputMap)));
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
			 *	 도매업자 조회
			 * @param data
			 * @param request
			 * @return
			 * @
			 */ 
			public List<?> rcs_nm_select(HttpServletRequest request, Map<String, String> data)  {
				
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO) session.getAttribute("userSession");
				
				List<?> selList=null;
				Map<String, String> map =new HashMap<String, String>();
				map.putAll(data);
				
				//로그인자가 센터
				if(uvo.getBIZR_TP_CD().equals("T1") ){
					map.put("T_USER_ID", uvo.getUSER_ID());
				}
				//로그인자가 생산자일경우
				else if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){
					map.put("MFC_BIZRID", uvo.getBIZRID());  					// 사업자ID
					map.put("MFC_BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
					//로그인자가 본사가 아닌경우 본사인경우 모든 직매장 보여야한다.
					if(!uvo.getBRCH_NO().equals("9999999999") ){
						map.put("S_BRCH_ID", uvo.getBRCH_ID());  			// 지점ID
						map.put("S_BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
					}
				}
				
				//로그인자가 도매업자 일경우
				if(uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){
					map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
					map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
					selList = epwh9000301Mapper.rcs_nm_select((Map<String, String>) map);//도매업자일경우
				}
				else{
					selList = epwh9000301Mapper.rcs_nm_select_all((Map<String, String>) map);
				}
				
				return selList;
			}


}
