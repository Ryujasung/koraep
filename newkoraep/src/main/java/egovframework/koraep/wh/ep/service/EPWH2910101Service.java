package egovframework.koraep.wh.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH2910101Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 반환관리 Service
 * @author 양성수
 *
 */
@Service("epwh2910101Service")
public class EPWH2910101Service {


	@Resource(name="epwh2910101Mapper")
	private EPWH2910101Mapper epwh2910101Mapper;  //반환관리 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 반환관리 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh2910101_select(ModelMap model, HttpServletRequest request) {

		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			Map<String, String> map= new HashMap<String, String>();
			List<?> dtList				= commonceService.getCommonCdListNew("D022");	//반환등록일자구분
			List<?> stat_cdList		= commonceService.getCommonCdListNew("D021");	//상태
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
			List<?> whsl_se_cdList = commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
			List<?> sys_seList		= commonceService.getCommonCdListNew("S004");			//등록구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");			//지역
			String   title				= commonceService.getMenuTitle("EPWH2910101");			//타이틀
			List<?>	whsdlList 		=commonceService.mfc_bizrnm_select4(request, map);    				//도매업자 업체명조회
			List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPWH2910101",request);	//그리드컬럼 조회

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
		 * 반환내역서상세조회 (20200402 추가)
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epwh2910101_select_1(ModelMap model, HttpServletRequest request) {

			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				model.addAttribute("INQ_PARAMS",jParams);

				Map<String, String> map= new HashMap<String, String>();
				List<?> dtList				= commonceService.getCommonCdListNew("D022");	//반환등록일자구분
				List<?> stat_cdList		= commonceService.getCommonCdListNew("D021");	//상태
				List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
				List<?> whsl_se_cdList = commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
				List<?> sys_seList		= commonceService.getCommonCdListNew("S004");			//등록구분
				List<?> areaList			= commonceService.getCommonCdListNew("B010");			//지역
				String   title				= commonceService.getMenuTitle("EPWH2910102");			//타이틀
				List<?>	whsdlList 		=commonceService.mfc_bizrnm_select4(request, map);    				//도매업자 업체명조회
				List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPWH2910101",request);	//그리드컬럼 조회
				
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
		public HashMap epwh2910101_select2(Map<String, String> inputMap, HttpServletRequest request) {
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
		public HashMap epwh2910101_select3(Map<String, String> inputMap, HttpServletRequest request) {
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
		public HashMap epwh2910101_select4(Map<String, String> inputMap, HttpServletRequest request) {
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
		 * 반환관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh2910101_select5(Map<String, Object> inputMap, HttpServletRequest request) {
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
	    		/*
	    			//멀티selectbox 일경우
	    			List<?> list = JSONArray.fromObject(inputMap.get("WHSDL_LIST"));
	    			inputMap.put("WHSDL_LIST", list);  */

					rtnMap.put("selList", util.mapToJson(epwh2910101Mapper.epwh2910101_select4(inputMap)));
					rtnMap.put("totalList", util.mapToJson(epwh2910101Mapper.epwh2910101_select4_cnt(inputMap)));
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
		public HashMap epwh2910101_select5_1(Map<String, Object> inputMap, HttpServletRequest request) {
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
	    		/*
	    			//멀티selectbox 일경우
	    			List<?> list = JSONArray.fromObject(inputMap.get("WHSDL_LIST"));
	    			inputMap.put("WHSDL_LIST", list);  */
	    			List<?> list_c = JSONArray.fromObject(inputMap.get("CTNR_LIST"));
	    			inputMap.put("CTNR_LIST", list_c); 
					rtnMap.put("selList", util.mapToJson(epwh2910101Mapper.epwh2910101_select4_1(inputMap)));
					rtnMap.put("totalList", util.mapToJson(epwh2910101Mapper.epwh2910101_select4_1_cnt(inputMap)));
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
		public String epwh2910101_excel(HashMap<String, Object> data, HttpServletRequest request) {

			String errCd = "0000";

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			data.put("WHSDL_BIZRID", vo.getBIZRID());
			data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("WHSDL_BRCH_ID", vo.getBRCH_ID());  				// 지점ID
				data.put("WHSDL_BRCH_NO", vo.getBRCH_NO());  			// 지점번호
			}

			try {
				List<?> list = epwh2910101Mapper.epwh2910101_select4(data);

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
		 * 반환내역상세 엑셀(20200402추가)
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh2910102_excel(HashMap<String, Object> data, HttpServletRequest request) {

			String errCd = "0000";

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			List<?> list_c = JSONArray.fromObject(data.get("CTNR_LIST"));
			data.put("CTNR_LIST", list_c); 
			
			data.put("WHSDL_BIZRID", vo.getBIZRID());
			data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("WHSDL_BRCH_ID", vo.getBRCH_ID());  				// 지점ID
				data.put("WHSDL_BRCH_NO", vo.getBRCH_NO());  			// 지점번호
			}

			try {
				
				
				List<?> list = epwh2910101Mapper.epwh2910101_select4_1(data);
				
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
		public String epwh2910101_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));

			if (list != null) {
				try {
					for (int i = 0; i < list.size(); i++) {
						map = (Map<String, String>) list.get(i);
						int stat = epwh2910101Mapper.epwh2910101_select6(map); // 상태 체크
						if (stat > 0) {
							throw new Exception("A009"); // 반환정보가 변경되었습니다. 다시 조회하시기 바랍니다.
						}
						epwh2910101Mapper.epwh2910101_delete(map); // 반환내역서 삭제
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
		public String epwh2910101_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
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

						int stat = epwh2910101Mapper.epwh2910101_select5(map); //상태 체크
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
						epwh2910101Mapper.epwh2910101_insert(map); 		//실태조사요청정보 테이블에 등록
						epwh2910101Mapper.epwh2910101_update(map); 	// 반환내역서 실태조사

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
		public String epwh2910101_update2(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);

						int stat = epwh2910101Mapper.epwh2910101_select7(map); //상태 체크
						
						if(stat>0){
							throw new Exception("A027"); //실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다.
						}

						map.put("REG_PRSN_ID", vo.getUSER_ID());  						//요청자

						epwh2910101Mapper.epwh2910101_insert2(map); //반환등록요청 일괄확인
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
		  public ModelMap epwh2910164_select(ModelMap model, HttpServletRequest request) {

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

				String   title		= commonceService.getMenuTitle("EPWH2910164");		//타이틀
				List<?> iniList	= epwh2910101Mapper.epwh2910164_select(map);		//상세내역 조회
				List<?> gridList	= epwh2910101Mapper.epwh2910164_select2(map);	//그리드쪽 조회

				try {
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("iniList", util.mapToJson(iniList));
					model.addAttribute("gridList", util.mapToJson(gridList));
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
		 * 반환관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh2910164_excel(HashMap<String, String> data, HttpServletRequest request) {
			String errCd = "0000";

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			data.put("WHSDL_BIZRID", vo.getBIZRID());
			data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("WHSDL_BRCH_ID", vo.getBRCH_ID());// 지점ID
				data.put("WHSDL_BRCH_NO", vo.getBRCH_NO());// 지점번호
			}

			try {
				List<?> list = epwh2910101Mapper.epwh2910164_select2(data);

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
