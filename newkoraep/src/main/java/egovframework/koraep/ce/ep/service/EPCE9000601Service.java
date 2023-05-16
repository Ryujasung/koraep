package egovframework.koraep.ce.ep.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE9000501Mapper;
import egovframework.mapper.ce.ep.EPCE9000601Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 반환관리 Service
 * @author 양성수
 *
 */
@Service("epce9000601Service")
public class EPCE9000601Service {

	@Resource(name="epce9000501Mapper")
	private EPCE9000501Mapper epce9000501Mapper;
	
	@Resource(name="epce9000601Mapper")
	private EPCE9000601Mapper epce9000601Mapper;  //반환관리 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통


	@Resource(name="epce9000501Service")
	private EPCE9000501Service epce9000501Service;
	/**
	 * 무인회수기 내역 관리 초기화면(상휘)
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce9000601_select(ModelMap model, HttpServletRequest request) {

		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			Map<String, String> map= new HashMap<String, String>();
			String   title					= commonceService.getMenuTitle("EPCE9000601");		//타이틀
			HashMap<String, String> map2 = new HashMap<String, String>();
			List<?> langSeList = commonceService.getLangSeCdList();  // 언어코드
			map2 = (HashMap<String, String>)langSeList.get(0);       // 표준인놈으로 기타코드 가져오기
			List<?> AreaCdList = commonceService.getCommonCdListNew("B010");
			List<?>	urm_list = epce9000501Service.urm_list_select(request, map);    
			List<?>	urm_list2 = epce9000501Service.urm_select2(request, map);    
			List<?> rtrvl_cd_list = rtrvl_cd_list(request, map);    

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
//				model.addAttribute("dtList", util.mapToJson(dtList));
//				model.addAttribute("sys_seList", util.mapToJson(sys_seList));
//				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));
//				model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));
//				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));
//				model.addAttribute("whsdlList", util.mapToJson(whsdlList));
				model.addAttribute("rtrvl_cd_list", util.mapToJson(rtrvl_cd_list));
				model.addAttribute("AreaCdList", util.mapToJson(AreaCdList));
				model.addAttribute("urm_list2", util.mapToJson(urm_list2));
				model.addAttribute("urm_list", util.mapToJson(urm_list));
				model.addAttribute("titleSub", title);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}


			return model;
	    }
	  
	  
	  public List<?> rtrvl_cd_list(HttpServletRequest request, Map<String, String> data)  {
			
			HttpSession session = request.getSession();
			UserVO uvo = (UserVO) session.getAttribute("userSession");
			
			List<?> selList=null;
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(data);
			
			//로그인자가 도매업자 일경우
				selList = epce9000601Mapper.rtrvl_cd_list((HashMap<String, String>) map);
			
			return selList;
		}
	  
	  /**
		 * 반환관리 초기화면 (20200402 추가)
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce9000601_select_1(ModelMap model, HttpServletRequest request) {

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
				String   title					= commonceService.getMenuTitle("EPCE9000602");		//타이틀
				List<?>	whsdlList 		=commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
				List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPCE9000601",request);		//그리드컬럼 조회
				
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
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}


				return model;
		    }

		/**
		 * 소매점 선택시 시리얼번호 가져오기
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce9000601_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	try {
	    		inputMap.put("USE_YN", "Y");
	    		List<?>	serialList = serialList(request, inputMap);   
		      	rtnMap.put("serialList", util.mapToJson(serialList));    	 // 생산자랑 거래중인 도매업자 업체명조회
		      	List<?>	dps_fee_list = dps_fee_list(request, inputMap);
		      	rtnMap.put("dps_fee_list", util.mapToJson(dps_fee_list)); 	//회수용기 보증금 취급수수료
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 //사업자 직매장/공장 조회
			return rtnMap;
	    }
		 public List<?> serialList(HttpServletRequest request, Map<String, String> data)  {
				
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO) session.getAttribute("userSession");
				
				List<?> selList=null;
				Map<String, String> map =new HashMap<String, String>();
				map.putAll(data);
				
				//로그인자가 도매업자 일경우
					selList = epce9000501Mapper.serial_list_select((HashMap<String, String>) map);
				
				return selList;
			}
		
		 public List<?> dps_fee_list(HttpServletRequest request, Map<String, String> data)  {
				
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO) session.getAttribute("userSession");
				
				List<?> selList=null;
				Map<String, String> map =new HashMap<String, String>();
				map.putAll(data);
				
				//로그인자가 도매업자 일경우
					selList = epce9000601Mapper.dps_fee_list((HashMap<String, String>) map);
				
				return selList;
			}

		
		/**
		 * 반환관리 생산자 직매장/공장 선택시  업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce9000601_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
				rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
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
		public HashMap epce9000601_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	try {
		      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
	    	} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}

	    	return rtnMap;
	    }

		/**
		 * 반환관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce9000601_select5(Map<String, Object> inputMap, HttpServletRequest request) {
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

					rtnMap.put("selList", util.mapToJson(epce9000601Mapper.epce9000601_select4(inputMap)));
					rtnMap.put("totalList", util.mapToJson(epce9000601Mapper.epce9000601_select4_cnt(inputMap)));
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
		public HashMap epce9000601_select5_1(Map<String, Object> inputMap, HttpServletRequest request) {
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
					rtnMap.put("selList", util.mapToJson(epce9000601Mapper.epce9000601_select4_1(inputMap)));
					rtnMap.put("totalList", util.mapToJson(epce9000601Mapper.epce9000601_select4_1_cnt(inputMap)));
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
		public String epce9000601_excel(HashMap<String, Object> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epce9000601Mapper.epce9000601_select4(data);
				
				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("fileName", data.get("fileName").toString());
				map.put("columns", data.get("columns").toString());

				//엑셀파일 저장
				commonceService.excelSave(request, map, list);
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
		public String epce9000602_excel(HashMap<String, Object> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
			data.put("CTNR_LIST", list_c); 
			
			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epce9000601Mapper.epce9000601_select4_1(data);

				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("fileName", data.get("fileName").toString());
				map.put("columns", data.get("columns").toString());

				//엑셀파일 저장
				commonceService.excelSave(request, map, list);
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
		public String epce9000664_excel(HashMap<String, String> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epce9000601Mapper.epce9000664_select2(data);

				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("fileName", data.get("fileName").toString());
				map.put("columns", data.get("columns").toString());

				//엑셀파일 저장
				commonceService.excelSave(request, map, list);
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
		public String epce9000601_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			if (list != null) {
				try {
					for (int i = 0; i < list.size(); i++) {
						map = (Map<String, String>) list.get(i);
						//int stat = epce9000601Mapper.epce9000601_select6(map); // 상태 체크
						/*if (stat > 0) {
							throw new Exception("A009"); // 반환정보가 변경되었습니다. 다시 조회하시기 바랍니다.
						}*/
//						epce9000601Mapper.epce9000601_delete2(map); 
						epce9000601Mapper.epce9000601_delete(map); 
					}

				} catch (Exception e) {
					if (e.getMessage().equals("A009")) {
						 throw new Exception(e.getMessage());
					} else {
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					}
				}
			}
			return errCd;
		}

		/**
		 *  엑셀 업로드 후처리
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce9000631_select8(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
	    		System.out.println("INPUT_MAP : "+inputMap);
				rtnMap.put("selList", util.mapToJson(epce9000601Mapper.epce9000631_select4(inputMap)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    	 
	    	return rtnMap;    	
	    }
		
		/**
		 * 반환관리  실태조사
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epce9000601_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
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

						int stat = epce9000601Mapper.epce9000601_select5(map); //상태 체크
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
						epce9000601Mapper.epce9000601_insert(map); 		//실태조사요청정보 테이블에 등록
						epce9000601Mapper.epce9000601_update(map); 	// 반환내역서 실태조사

					}
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
		public String epce9000601_update2(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);

						/*int stat = epce9000601Mapper.epce9000601_select7(map); //상태 체크
						
						if(stat>0){
							throw new Exception("A027"); //실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다.
						}*/

						map.put("REG_PRSN_ID", vo.getUSER_ID());  						//요청자

						epce9000601Mapper.epce9000601_update2(map); //반환등록요청 일괄확인
					}
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
		 * 내역 상세조회 초기 화면(상휘)
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce9000664_select(ModelMap model, HttpServletRequest request) {
			  
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				String title = commonceService.getMenuTitle("EPCE9000664");		//타이틀
				List<?> initList = epce9000601Mapper.epce9000664_select(map);		//상세내역 조회
//				List<?> gridList = epce9000601Mapper.epce9000664_select2(map);		//그리드쪽 조회

				try {
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("initList", util.mapToJson(initList));
//					model.addAttribute("gridList", util.mapToJson(gridList));
					model.addAttribute("titleSub", title);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}

				return model;
		    }

		  /**
			 * 무인회수기 저장(상휘)
			 * @param data
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
		    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
			public String epce9000601_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					String errCd = "0000";
					
					//Map<String, String> map;
					List<?> list = JSONArray.fromObject(inputMap.get("list"));
					boolean keyCheck = false;
					
					if (list != null) {
						try {
							List<Map<String, String>>chkList = new ArrayList<Map<String,String>>();
							for(int i=0; i<list.size(); i++){
								keyCheck = false;
								Map<String, String> map = (Map<String, String>) list.get(i);
								System.out.println("map"+i+" : "+map);
//								int receiptNo  = i+1;
//								String receiptsn = String.valueOf(receiptNo);
//								map.put("RECEIPT_SN",receiptsn);
								map.put("REG_PRSN_ID", vo.getUSER_ID());  						//등록자
								int sel = epce9000601Mapper.epce9000631_chk(map); //중복체크
								if(sel>0){  
									inputMap.put("ERR_CTNR_NM", map.get("SERIAL_NO"));
									
									throw new Exception("A003"); 		//중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
								}    
								int rtn = epce9000601Mapper.SELECT_EPCN_RTRVL_CTNR_CD(map);
								if (rtn == 0) {
									// errCd = "B999";
									inputMap.put("ERR_CTNR_NM", map.get("RTRVL_CTNR_CD"));
									throw new Exception("B023"); // 미등록된 회수용기코드입니다.
								}
								for(int j=0 ;j<chkList.size(); j++){
									Map<String, String> map2 = (Map<String, String>) chkList.get(j);
							 		
							 		if( map.get("SERIAL_NO").equals(map2.get("SERIAL_NO")) 
							 				&& map.get("RTRVL_DT").equals(map2.get("RTRVL_DT"))
							 				 && map.get("URM_RECEIPT_NO").equals(map2.get("URM_RECEIPT_NO")))  
								 	    {
							 			
							 			map.put("URM_DOC_NO",map2.get("URM_DOC_NO"));
								 			keyCheck = true;
								 			break;
								 		 } 
								}
								if(!keyCheck){
									String urmrtrvldt = map.get("RTRVL_DT");
									urmrtrvldt = urmrtrvldt.replaceAll("-", "");
									String urm_doc_no = urmrtrvldt + map.get("SERIAL_NO") +map.get("URM_RECEIPT_NO");
									map.put("URM_DOC_NO", urm_doc_no);
									epce9000601Mapper.INSERT_EPCM_URM_MST(map);
									 chkList.add(map);
								}
								epce9000601Mapper.INSERT_EPCM_URM_LST(map);
								
								
								
							}//end of for
							for(int j=0 ;j<chkList.size(); j++){//마스터 합계 업데이트
								epce9000601Mapper.EPCM_URM_SUM_UPDATE((Map<String, String>) chkList.get(j));
						 	}
						} catch (Exception e) {
							e.printStackTrace();
							 if(e.getMessage().equals("A003")){
								 throw new Exception(e.getMessage()); 
							 }else  if(e.getMessage().equals("A021")){
								 throw new Exception(e.getMessage());
							 }else  if(e.getMessage().equals("A030")){
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

		public HashMap epce9000631_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
  		try {
  			List<?>	dps_fee_list = dps_fee_list(request, inputMap);
	      	rtnMap.put("dps_fee_list", util.mapToJson(dps_fee_list));
  		} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  //업체명 조회	
			return rtnMap;    	
	    }
		
		/**
	 	 * 회수정보수정 초기 화면(상휘)
	 	 * @param inputMap
	 	 * @param request   
	 	 * @return   
	 	 * @          
	 	 */  
	 	  public ModelMap epce9000642_select(ModelMap model, HttpServletRequest request) {
	 		                      
	 		  	//파라메터 정보  
	 			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");      
	 			JSONObject jParams = JSONObject.fromObject(reqParams);    
	 			Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));   
	 			String   title					= commonceService.getMenuTitle("EPCE9000642");		//타이틀   
	 			List<?>	initList 			= epce9000601Mapper.epce9000664_select(map);    	//상세 그리드 값  
	 			map.put("WORK_SE", "4"); 																			//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
				HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);//등록일자제한설정 
				List<?>	serialList = serialList(request, map);   
	 			model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	  
	 			try {  
	 				model.addAttribute("initList", util.mapToJson(initList));	      
	 				model.addAttribute("serialList", util.mapToJson(serialList));	      
	 				model.addAttribute("INQ_PARAMS",jParams);
	 				model.addAttribute("titleSub", title);                         
	 			} catch (Exception e) {
	 				// TODO Auto-generated catch block
	 				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
	 			}	               
	 			return model;    	  
	 	    }        
	 	 /**
			 *  회수정보수정  저장(상휘)
			 * @param data
			 * @param request
			 * @return
			 * @throws Exception 
			 * @   
			 */       
		    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
			public String epce9000642_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					String errCd = "0000";
					String ssUserId  = "";   //사용자ID     

					//Map<String, String> map;    
					List<?> list = JSONArray.fromObject(inputMap.get("list"));
					List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();       
					boolean keyCheck = false;
					
					if (list != null) {                      
						try {
							
							for(int i=0; i<list.size(); i++){
									Map<String, String> map = (Map<String, String>) list.get(i);
									int receiptNo  = i+1;
									String receiptsn = String.valueOf(receiptNo);
									map.put("RECEIPT_SN",receiptsn);
									map.put("REG_PRSN_ID", vo.getUSER_ID());  
									int sel = epce9000601Mapper.epce9000631_chk(map); //중복체크
									
									if(sel>0){
										throw new Exception("A003"); //중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
									}
									
									map.put("SDT_DT", map.get("RTRVL_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
									map.put("WORK_SE", "4"); 						//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
									sel = commonceService.rtc_dt_ck(map);		//등록일자제한설정
									if(sel !=1){
										throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
									}          
//									epce9000601Mapper.epce9000642_update(map);
								 	if(!keyCheck){   
								 			epce9000601Mapper.epce9000642_delete(map); 	// info삭제
									 		list2.add(map);
									 		keyCheck = true;   
									 		//end of if(map.get("ADJ").equals("T"))
								 	}//end of if(!keyCheck)
								 	//detail
								 	epce9000601Mapper.INSERT_EPCM_URM_LST(map); // 회수상세
							}//end of for  
							
							//마스터 등록 length 길이만큼   회수량, 수수료 SUM update
						 	for(int j=0 ;j<list2.size(); j++){
						 		Map<String, String> map3 = (Map<String, String>) list2.get(j);
						 		epce9000601Mapper.EPCM_URM_SUM_UPDATE(map3);
						 	}
							   
						} catch (Exception e) {
							 if(e.getMessage().equals("A003")){
								 throw new Exception(e.getMessage()); 
							 }else if(e.getMessage().equals("A021")){
								 throw new Exception(e.getMessage()); 
							 }else{
								 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
							 }
						}
					}//end of list
					return errCd;
		    }

}
