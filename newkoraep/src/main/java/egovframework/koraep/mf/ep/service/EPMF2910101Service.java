package egovframework.koraep.mf.ep.service;

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
import egovframework.mapper.mf.ep.EPMF2910101Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 반환관리 Service
 * @author 양성수
 *
 */
@Service("epmf2910101Service")
public class EPMF2910101Service {


	@Resource(name="epmf2910101Mapper")
	private EPMF2910101Mapper epmf2910101Mapper;  //반환관리 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 반환관리 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf2910101_select(ModelMap model, HttpServletRequest request) {

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
			String   title					= commonceService.getMenuTitle("EPMF2910101");		//타이틀
			List<?> whsdlList			= commonceService.mfc_bizrnm_select4(request, map);   			//생산자랑 거래중인 도매업자 업체명조회
			List<?> brch_nmList 	= commonceService.brch_nm_select(request, map);	 	  			//사업자 직매장/공장 조회
			String   detail 				= "F";

			//반환내역상세 들어갔다가 다시 관리 페이지로 올경우
			if(jParams.get("SEL_PARAMS") !=null){//반환상세 볼경우
					detail = "T";
			}

			try {
				model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));
				model.addAttribute("dtList", util.mapToJson(dtList));
				model.addAttribute("sys_seList", util.mapToJson(sys_seList));
				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));
				model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));

				model.addAttribute("areaList", util.mapToJson(areaList));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			model.addAttribute("titleSub", title);
			model.addAttribute("detail", detail);
			return model;
	    }

		/**
		 * 반환관리 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf2910101_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();


	    	try {
	    		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		      	inputMap.put("BIZR_TP_CD", "");
				rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));
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
		public HashMap epmf2910101_select3(Map<String, String> inputMap, HttpServletRequest request) {
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
		public HashMap epmf2910101_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	      		try {
					rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}    	 // 생산자랑 거래중인 도매업자 업체명조회
	    	return rtnMap;
	    }

		/**
		 * 반환관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf2910101_select5(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

	    		try {
	    			rtnMap.put("selList", util.mapToJson(epmf2910101Mapper.epmf2910101_select4  (inputMap)));
					rtnMap.put("totalCnt", epmf2910101Mapper.epmf2910101_select4_cnt(inputMap));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}
	    	return rtnMap;
	    }
		/**
		 * 입고관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf2910101_excel(HashMap<String, String> data, HttpServletRequest request) {

			String errCd = "0000";
			try {

				List<?> list = epmf2910101Mapper.epmf2910101_select4(data);
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
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
		public String epmf2910101_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));

			if (list != null) {
				try {
					for (int i = 0; i < list.size(); i++) {
						map = (Map<String, String>) list.get(i);
						int stat = epmf2910101Mapper.epmf2910101_select6(map); // 상태 체크
						if (stat > 0) {
							throw new Exception("A009"); // 반환정보가 변경되었습니다. 다시 조회하시기 바랍니다.
						}
						epmf2910101Mapper.epmf2910101_delete(map); // 반환내역서 삭제
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
		 * 반환관리  실태조사
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epmf2910101_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
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

						int stat = epmf2910101Mapper.epmf2910101_select5(map); //상태 체크
						 if(stat>0){
							throw new Exception("A010"); //실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다.
						 }

						String doc_psnb_cd ="RC"; 								   						//	RC 실태조사
						rsrc_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	//문서번호 가져오기
						map.put("RSRC_DOC_NO", rsrc_doc_no);					//	문서채번
						map.put("REQ_ID", vo.getUSER_ID());  						//요청자
						map.put("REQ_BIZRID", vo.getBIZRID());  					//요청지점ID
						map.put("REQ_BIZRNO", vo.getBIZRNO_ORI());  				//요청지점번호
						map.put("REQ_BRCH_ID", vo.getBRCH_ID());  			//요청사업자ID
						map.put("REQ_BRCH_NO", vo.getBRCH_NO());  		//요청사업자등록번호
						map.put("REQ_BIZR_TP_CD", vo.getBIZR_TP_CD());  	//요청회원구분코드
						map.put("RTN_STAT_CD", "RR");
						epmf2910101Mapper.epmf2910101_insert(map); 		//실태조사요청정보 테이블에 등록
						epmf2910101Mapper.epmf2910101_update(map); 	// 반환내역서 실태조사

					}
				}catch (Exception e) {
					 if(e.getMessage().equals("A010")){
						 throw new Exception(e.getMessage());
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
			}return errCd;
	    }

		/**
		 * 반환관리 상세조회 초기 화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epmf2910164_select(ModelMap model, HttpServletRequest request) {
			 	Map<String, String> map = new HashMap<String, String>();

			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				JSONObject jParams2 =(JSONObject)jParams.get("PARAMS");

				map.put("MFC_BIZRID", jParams2.get("MFC_BIZRID").toString());				//생산자ID
				map.put("MFC_BIZRNO", jParams2.get("MFC_BIZRNO").toString());			//생산자 사업자번호
				map.put("MFC_BRCH_ID", jParams2.get("MFC_BRCH_ID").toString());			//생산자 지사 ID
				map.put("MFC_BRCH_NO", jParams2.get("MFC_BRCH_NO").toString());		//생산자 지사 번호
				map.put("WHSDL_BIZRID", jParams2.get("WHSDL_BIZRID").toString());	 	//도매업자 ID
				map.put("WHSDL_BIZRNO", jParams2.get("WHSDL_BIZRNO").toString());	//도매업자 사업자번호
				map.put("RTN_DOC_NO", jParams2.get("RTN_DOC_NO").toString());		 	// 반환문서번호


				try {
					String title = commonceService.getMenuTitle("EPMF2910164");		//타이틀
					List<?> iniList = epmf2910101Mapper.epmf2910164_select(map);		//상세내역 조회
					List<?> gridList = epmf2910101Mapper.epmf2910164_select2(map);		//그리드쪽 조회

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
			 * 반환관리 엑셀
			 * @param map
			 * @param request
			 * @return
			 * @
			 */
			public String epmf2910164_excel(HashMap<String, String> data, HttpServletRequest request) {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");

				if(vo != null ){
					data.put("T_USER_ID", vo.getUSER_ID());
				}

				String errCd = "0000";
				try {
					List<?> list = epmf2910101Mapper.epmf2910164_select2(data);

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


}
