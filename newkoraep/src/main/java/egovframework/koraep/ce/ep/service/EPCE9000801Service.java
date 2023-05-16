package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE9000501Mapper;
import egovframework.mapper.ce.ep.EPCE9000801Mapper;

/**
 * 반환관리 Service
 * @author 양성수
 *
 */
@Service("epce9000801Service")
public class EPCE9000801Service {

	@Resource(name="epce9000501Mapper")
	private EPCE9000501Mapper epce9000501Mapper;
	
	@Resource(name="epce9000801Mapper")
	private EPCE9000801Mapper epce9000801Mapper;  //반환관리 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 반환관리 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce9000801_select(ModelMap model, HttpServletRequest request) {

		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			Map<String, String> map= new HashMap<String, String>();
			String   title					= commonceService.getMenuTitle("EPCE9000801");		//타이틀
			List<?>	urm_fix_list = urm_fix_select(request, map);
			

			try {
				
				model.addAttribute("titleSub", title);
				model.addAttribute("urm_fix_list", util.mapToJson(urm_fix_list));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}


			return model;
	    }
	  
	  public List<?> urm_select2(HttpServletRequest request, Map<String, String> data)  {
			
			HttpSession session = request.getSession();
			UserVO uvo = (UserVO) session.getAttribute("userSession");
			
			List<?> selList=null;
			Map<String, String> map =new HashMap<String, String>();
			map.putAll(data);
			
			//로그인자가 도매업자 일경우
				selList = epce9000501Mapper.urm_select2((HashMap<String, String>) map);
			
			return selList;
		}
	  
	  /**
		 * 반환관리 초기화면 (20200402 추가)
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce9000801_select_1(ModelMap model, HttpServletRequest request) {

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
				String   title					= commonceService.getMenuTitle("EPCE9000802");		//타이틀
				List<?>	whsdlList 		=commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
				List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPCE9000801",request);		//그리드컬럼 조회
				
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
		 * 반환관리 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce9000801_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	try {
		      	rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		    	inputMap.put("BIZR_TP_CD", "");
				rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); 		// 생산자 직매장
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
		public HashMap epce9000801_select3(Map<String, String> inputMap, HttpServletRequest request) {
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
		public HashMap epce9000801_select4(Map<String, String> inputMap, HttpServletRequest request) {
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
		public HashMap epce9000801_select5(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				inputMap.put("T_USER_ID", vo.getUSER_ID());
			}

	    		try {

					rtnMap.put("selList", util.mapToJson(epce9000801Mapper.epce9000801_select4(inputMap)));
					rtnMap.put("totalCnt", util.mapToJson(epce9000801Mapper.epce9000801_select4_cnt(inputMap)));
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
		public HashMap epce9000801_select5_1(Map<String, Object> inputMap, HttpServletRequest request) {
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
					rtnMap.put("selList", util.mapToJson(epce9000801Mapper.epce9000801_select4_1(inputMap)));
					rtnMap.put("totalList", util.mapToJson(epce9000801Mapper.epce9000801_select4_1_cnt(inputMap)));
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
		public String epce9000801_excel(HashMap<String, Object> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epce9000801Mapper.epce9000801_select4(data);
				
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
		public String epce9000802_excel(HashMap<String, Object> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
			data.put("CTNR_LIST", list_c); 
			
			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epce9000801Mapper.epce9000801_select4_1(data);

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
		public String epce9000864_excel(HashMap<String, String> data, HttpServletRequest request) {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			String errCd = "0000";
			try {
				List<?> list = epce9000801Mapper.epce9000864_select2(data);

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
		public String epce9000801_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			if (list != null) {
				try {
					for (int i = 0; i < list.size(); i++) {
						map = (Map<String, String>) list.get(i);
						//int stat = epce9000801Mapper.epce9000801_select6(map); // 상태 체크
						/*if (stat > 0) {
							throw new Exception("A009"); // 반환정보가 변경되었습니다. 다시 조회하시기 바랍니다.
						}*/
						//epce9000801Mapper.epce9000801_delete2(map); 
						epce9000801Mapper.epce9000801_delete(map); 
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
		public HashMap epce9000831_select8(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
				rtnMap.put("selList", util.mapToJson(epce9000801Mapper.epce9000831_select4(inputMap)));
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
		public String epce9000801_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
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

						int stat = epce9000801Mapper.epce9000801_select5(map); //상태 체크
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
						epce9000801Mapper.epce9000801_insert(map); 		//실태조사요청정보 테이블에 등록
						epce9000801Mapper.epce9000801_update(map); 	// 반환내역서 실태조사

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
		public String epce9000801_update2(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);

						/*int stat = epce9000801Mapper.epce9000801_select7(map); //상태 체크
						
						if(stat>0){
							throw new Exception("A027"); //실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다.
						}*/

						map.put("REG_PRSN_ID", vo.getUSER_ID());  						//요청자

						epce9000801Mapper.epce9000801_update2(map); //반환등록요청 일괄확인
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
		 * 반환관리 상세조회 초기 화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce9000864_select(ModelMap model, HttpServletRequest request) {
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

			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));

				String title = commonceService.getMenuTitle("EPCE9000864");		//타이틀
				List<?> iniList = epce9000801Mapper.epce9000864_select(map);		//상세내역 조회
				List<?> gridList = epce9000801Mapper.epce9000864_select2(map);		//그리드쪽 조회

				try {
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("iniList", util.mapToJson(iniList));
					model.addAttribute("gridList", util.mapToJson(gridList));
					model.addAttribute("titleSub", title);
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
			public String epce9000801_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
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
								//epce9000801Mapper.epce9000801_insert3(map); 		// 무인회수기 정보에서 사용량 업데이트
							 	//detail
								epce9000801Mapper.epce9000801_insert2(map); 		// 반환상세
							}//end of for
							
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
		    
		    public List<?> urm_fix_select(HttpServletRequest request, Map<String, String> data)  {
				
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO) session.getAttribute("userSession");
				
				List<?> selList=null;
				Map<String, String> map =new HashMap<String, String>();
				map.putAll(data);
				
				//로그인자가 도매업자 일경우
					selList = epce9000501Mapper.urm_fix_select((HashMap<String, String>) map);
				
				return selList;
			}
		    
		    public List<?> period_list(HttpServletRequest request, Map<String, String> data)  {
				
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO) session.getAttribute("userSession");
				
				List<?> selList=null;
				Map<String, String> map =new HashMap<String, String>();
				map.putAll(data);
				
				//로그인자가 도매업자 일경우
					selList = epce9000801Mapper.period_list((HashMap<String, String>) map);
				
				return selList;
			}

		    /**
			 * 변경 초기화면
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			  public ModelMap epce9000842_select(ModelMap model, HttpServletRequest request) {

				  try {
					  	//파라메터 정보
						String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
						JSONObject jParams = JSONObject.fromObject(reqParams);
						model.addAttribute("INQ_PARAMS",jParams);

//						HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("PARAMS"));
						HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
						model.addAttribute("searchDtl", util.mapToJson(epce9000801Mapper.epce9000842_select(map)));

//						HashMap<String, String> map = (HashMap<String, String>)epce9000801Mapper.epce9000542_select(jmap);


						String title = commonceService.getMenuTitle("EPCE9000842");		//타이틀

						model.addAttribute("titleSub", title);


					} catch (Exception e) {
						// TODO Auto-generated catch block
						org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
					}

					return model;
			    }
			  
			  
			//소모품정보수정
				public String epce9000831_update(HashMap<String, String> data,
						HttpServletRequest request) throws Exception {
					String errCd = "0000";
					
					try {
							HttpSession session = request.getSession();
							UserVO vo = (UserVO)session.getAttribute("userSession");
							
							data.put("S_USER_ID", "");
							if(vo != null){
								data.put("S_USER_ID", vo.getUSER_ID());
							}
								
							epce9000801Mapper.epce9000831_update(data);	//등록 처리
							
					}catch(Exception e){
						if(e.getMessage().equals("B007") || e.getMessage().equals("B008") ){
							 throw new Exception(e.getMessage());
						 }else{
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
					}
					
					return errCd;
				}

				/**
	 * 소모품 단가관리 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce90008011_select(ModelMap model, HttpServletRequest request) {
		     
		  Map<String, String> map = new HashMap<String, String>();
		  
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			
			JSONObject jParams = JSONObject.fromObject(reqParams);
			JSONObject jParams2 =  (JSONObject)jParams.get("PARAMS");
			
		 	String urm_fix_cd			=  jParams2.get("URM_FIX_CD").toString();
		 	
		 	map.put("URM_FIX_CD", urm_fix_cd);
			
		 	List<?> initList		=  epce9000801Mapper.epce90008011_select(map);
			String   title			=  commonceService.getMenuTitle("EPCE90008011");

			try {
				model.addAttribute("initList", util.mapToJson(initList));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}     //기준취급수수료관리  초기 리스트
			model.addAttribute("INQ_PARAMS",jParams);
			model.addAttribute("titleSub", title);
	    	
			return model;    	
	    }
			  
	  
	  /**
	 * 소모품 단가관리등록 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce900080131_select(ModelMap model, HttpServletRequest request) {
		    Map<String, String> map = new HashMap<String, String>();
		    
			String   title            =  commonceService.getMenuTitle("EPCE900080131");
			String reqParams		= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
	   		JSONObject jParams	= JSONObject.fromObject(reqParams);
			JSONObject jParams2 =  (JSONObject)jParams.get("PARAMS");
			
			String urm_fix_cd			=  jParams2.get("URM_FIX_CD").toString();
		 	
		 	map.put("URM_FIX_CD", urm_fix_cd);
			
		 	List<?> initList		=  epce9000801Mapper.epce900080131_select3(map);
		 	
		 	try {
				model.addAttribute("initList", util.mapToJson(initList));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}     //기준취급수수료관리  초기 리스트
	   		model.addAttribute("INQ_PARAMS", jParams);
			model.addAttribute("titleSub", title);
	    	
			return model;    	
	    }
	  
	  
	  /**
		 * 기준취급수수료  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
			public String epce900080131_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
		
				String errCd = "0000";
				try {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					if (!"".equals(inputMap.get("START_DT"))) {
						inputMap.put("START_DT",inputMap.get("START_DT").replace("-", ""));
					}
		
					if (!"".equals(inputMap.get("END_DT"))) {
						inputMap.put("END_DT",inputMap.get("END_DT").replace("-", ""));
					}
					
					
					int sel_rst = epce9000801Mapper.epce900080131_select(inputMap); //적용기간 중복체크
		
					if (sel_rst > 0) {
						errCd = "A005";
					}
		
					if (errCd == "0000") {
		
						String reg_sn = epce9000801Mapper.epce900080131_select2(inputMap);   //등록순번
		
						inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
						inputMap.put("BTN_SE_CD", "IS"); // 기타코드 M004
						inputMap.put("REG_SN", reg_sn);
		
						epce9000801Mapper.epce900080131_insert(inputMap); // 기준취급수수료 저장
						//epce0191801Mapper.epce0191831_insert2(inputMap); // 기준취급수수료 이력 저장
					}
				} catch (Exception e) {
					/*e.printStackTrace();*/
					//취약점점검 6294 기원우
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
				return errCd;
			}
			
			
			
			
			/**
			 * 기준취급수수료변경 초기값
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			  public ModelMap epce900080142_select(ModelMap model, HttpServletRequest request) {
				  
				  	String reqParams		= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			   		JSONObject jParams	= JSONObject.fromObject(reqParams);
				  
					String title = commonceService.getMenuTitle("EPCE900080142");
					
					model.addAttribute("titleSub", title);
					model.addAttribute("INQ_PARAMS", jParams);
					return model;    	
			    }
			  
			
			/**
			* 기준취급수수료 수정
			* @param data
			* @param request
			* @return
			 * @throws Exception 
			* @
			*/
			public String epce900080142_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
			
			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if (!"".equals(inputMap.get("START_DT"))) {
					inputMap.put("START_DT",inputMap.get("START_DT").replace("-", ""));
				}
				if (!"".equals(inputMap.get("END_DT"))) {
					inputMap.put("END_DT",inputMap.get("END_DT").replace("-", ""));
				}
			
				int sel_rst = epce9000801Mapper.epce900080131_select(inputMap); //적용기간 중복체크
				if (sel_rst > 0) {
					throw new Exception("A005"); //적용기간은 중복될 수 없습니다. 다시 한 번 확인해주시기 바랍니다.
				}
					inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
					epce9000801Mapper.epce900080142_update(inputMap);  //기준취급수수료 수정
			}catch(Exception e){
				/*e.printStackTrace();*/
				//취약점점검 6288 기원우
				 if(e.getMessage().equals("A005")){
					throw new Exception(e.getMessage()); 
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
			return errCd;	
			}	  
				
			
			/**
			 * 기준취급수수료관리 삭제
			 * 
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap EPCE90008011_delete(Map<String, String> inputMap,	HttpServletRequest request)  {

				String errCd = "0000";
				HashMap<String, Object> rtnMap = new HashMap<String, Object>();
				try {
					System.out.println("2");
					HttpSession session = request.getSession();
					UserVO vo = (UserVO) session.getAttribute("userSession");
					inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());

					int sel_rst = epce9000801Mapper.epce90008011_select2(inputMap); // 공급단가관리 삭제여부 가능한지 확인
					
					if (sel_rst > 0) {
						errCd = "A006";
						rtnMap.put("RSLT_CD", errCd); // 오류코드 put
					}
					if (errCd == "0000") {
						epce9000801Mapper.epce90008011_delete(inputMap); // 공급단가관리 삭제

						rtnMap.put("initList", util.mapToJson(epce9000801Mapper.epce90008011_select(inputMap))); // 기준취급수수료관리 다시 조회
						rtnMap.put("RSLT_CD", errCd); // 오류코드 put
					}
					rtnMap.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd)); // 오류 메세지 put

				} catch (Exception e) {
					rtnMap.put("RSLT_CD", "A001"); // 오류코드 put
					return rtnMap; // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}

				return rtnMap;
			}  
			  
			  
}
