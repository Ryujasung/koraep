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
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE4707201Mapper;
import egovframework.mapper.ce.ep.EPCE4770701Mapper;
import egovframework.mapper.ce.ep.EPCE4792901Mapper;

/**
 * 교환정산  서비스
 * @author Administrator
 *
 */
@Service("epce4792901Service")
public class EPCE4792901Service {

	@Resource(name="epce4792901Mapper")
	private EPCE4792901Mapper epce4792901Mapper;
	
	@Resource(name="epce4707201Mapper")
	private EPCE4707201Mapper epce4707201Mapper;
		
	@Resource(name="epce4770701Service")
	private EPCE4770701Service epce4770701Service;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4792901_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> statList = commonceService.getCommonCdListNew("C004");
		List<?> mfcBizrList = commonceService.mfc_bizrnm_select(request); // 생산자
		HashMap<String, String> searchDtl = new HashMap<String, String>();
		searchDtl = (HashMap<String, String>)epce4792901Mapper.epce4792901_regPsblYn();
		
		try {
			model.addAttribute("statList", util.mapToJson(statList));
			model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));
			model.addAttribute("regPsblYn", searchDtl.get("REG_PSBL_YN").toString());
		} catch (Exception e) {
			
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 등록 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4792931_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		String title = commonceService.getMenuTitle("EPCE4792931");
		model.addAttribute("titleSub", title);
		
		List<?> mfcBizrList = commonceService.mfc_bizrnm_select(request); // 생산자
		try {
			model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	
		} catch (Exception e) {
			
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 내역조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4792964_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		String title = commonceService.getMenuTitle("EPCE4792964");
		model.addAttribute("titleSub", title);
		
		try {
			model.addAttribute("searchList", util.mapToJson(epce4792901Mapper.epce4792964_select(param)));
		} catch (Exception e) {
			
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce47929642_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		String title = commonceService.getMenuTitle("EPCE47929642");
		model.addAttribute("titleSub", title);
		
		try {
			model.addAttribute("searchList", util.mapToJson(epce4792901Mapper.epce4792964_select2(param)));
		} catch (Exception e) {
			
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce47929644_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		String title = commonceService.getMenuTitle("EPCE47929644");
		model.addAttribute("titleSub", title);
		
		try {
			model.addAttribute("searchList", util.mapToJson(epce4792901Mapper.epce4792964_select3(param)));
		} catch (Exception e) {
			
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 교환정산 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4792901_select2(Map<String, String> data) {
		
		String BIZRID_NO = data.get("MFC_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> menuList = epce4792901Mapper.epce4792901_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		} catch (Exception e) {
			
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 교환정산등록 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4792931_select(Map<String, String> data) {
		
		String BIZRID_NO = data.get("MFC_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> menuList = epce4792901Mapper.epce4792931_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		} catch (Exception e) {
			
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 교환정산 등록
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4792931_insert(Map<String, String> data, HttpServletRequest request) throws Exception  {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		String ssUserId  = "";   //사용자ID
		
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				data.put("S_USER_ID", ssUserId);
				
				String BIZRID_NO = data.get("MFC_BIZR_SEL");
				if(BIZRID_NO != null && !BIZRID_NO.equals("")){
					data.put("BIZRID", BIZRID_NO.split(";")[0]);
					data.put("BIZRNO", BIZRID_NO.split(";")[1]);
				}
				
				int startYear = Integer.parseInt(data.get("START_DT").substring(0, 4))-1; //이전년도를 체크함..
				int endYear = Integer.parseInt(data.get("END_DT").substring(0, 4));
				
				for(int year = startYear; year <= endYear; year++){
				
					Map<String, String> map = new HashMap<String, String>();
					map.putAll(data);
					map.put("STD_YEAR", String.valueOf(year)); //기준년도

					//master
			 		String doc_psnb_cd ="EX"; //교환정산
			 		String exch_exca_doc_no = commonceService.doc_psnb_select(doc_psnb_cd); //교환정산 문서번호 조회
			 		map.put("EXCH_EXCA_DOC_NO", exch_exca_doc_no); //문서채번

					epce4792901Mapper.epce4792931_insert(map); //교환정산 등록
					epce4792901Mapper.epce4792931_update(map); //교환관리 교환요청정보 수정
					epce4792901Mapper.epce4792931_update2(map); //교환관리 교환확인정보 수정
				
				}

			} catch (Exception e) {
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}

		return errCd;
		
	}
	
	/**
	 * 교환정산 상태변경
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4792901_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		String exch_exca_stat_cd = inputMap.get("EXCH_EXCA_STAT_CD").toString();

		String ssUserId  = "";   //사용자ID

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				for(int i=0; i<list.size(); i++){

					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					map.put("EXCH_EXCA_STAT_CD", exch_exca_stat_cd);
					
					epce4792901Mapper.epce4792901_update(map);

				}//end of for
				
			} catch (Exception e) {
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}//end of list
		return errCd;
		
	}
	
	/**
	 * 교환정산 요청취소
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4792901_update2(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));

		String ssUserId  = "";   //사용자ID

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				for(int i=0; i<list.size(); i++){

					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					int rCnt = epce4792901Mapper.epce4792901_delete(map);
					if(rCnt > 0){
						epce4792901Mapper.epce4792901_update2(map); //교환관리 교환요청정보 리셋
						epce4792901Mapper.epce4792901_update3(map); //교환관리 교환확인정보 리셋
					}
					
				}//end of for
				
			} catch (Exception e) {
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}//end of list
		return errCd;
		
	}
	
	/**
	 * 교환정산서등록 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce47929312_select(ModelMap model, HttpServletRequest request) {
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		String title = commonceService.getMenuTitle("EPCE47929312");
		model.addAttribute("titleSub", title);
		
		try {
			
			List<JSONObject> list = jParams.getJSONArray("list");
			HashMap<String, String> param = new HashMap<String, String>();
			HashMap<String, String> searchData = new HashMap<String, String>();
			
			HashMap<String, String> map = util.jsonToMap(list.get(0));
			param.put("EXCA_SE_YEAR", map.get("STD_YEAR"));
			param.put("BIZRID", map.get("EXCH_EXCA_REG_BIZRID"));
			param.put("BIZRNO", map.get("EXCH_EXCA_REG_BIZRNO"));
			param.put("D", "D"); //교환정산 구분값
			
			////정산금액 계산
			epce4770701Service.getExcaData(param, list, searchData);
			
			long nExcaAmt = Long.parseLong(searchData.get("EXCA_AMT"));
			
			//상세정보
			HashMap<String, String> searchDtl = new HashMap<String, String>();
			param.put("EXCA_ISSU_SE_CD", "C");											//정산서발급구분코드(G:보증금, F:취급수수료, W:반환정산, C:교환정산)
			param.put("EXCA_SE_CD", nExcaAmt>0 ? "C" : "A");						//정산처리구분(A:납부, C:환급)
			param.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt)));		//정산금액
			searchDtl = (HashMap<String, String>) epce4792901Mapper.epce47929312_select(param);
			
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("list", list);
			List<?> searchList = searchList = epce4792901Mapper.epce47929312_select2(data);
			
			model.addAttribute("searchData", util.mapToJson(searchData));
			model.addAttribute("searchDtl", util.mapToJson(searchDtl));
			model.addAttribute("searchList", util.mapToJson(searchList));
			
		} catch (Exception e) {
			
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 교환정산서발급
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce47929312_insert(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		//Map<String, String> map = new HashMap<String, String>();

		try {
			
			if(vo != null){
				ssUserId = vo.getUSER_ID();
			}
			
			List<JSONObject> list = JSONArray.fromObject(inputMap.get("list"));
			HashMap<String, String> param = new HashMap<String, String>();
			HashMap<String, String> searchData = new HashMap<String, String>();
			
			HashMap<String, String> map = util.jsonToMap(list.get(0));
			param.put("EXCA_SE_YEAR", map.get("STD_YEAR"));
			param.put("BIZRID", map.get("EXCH_EXCA_REG_BIZRID"));
			param.put("BIZRNO", map.get("EXCH_EXCA_REG_BIZRNO"));
			param.put("D", "D"); //교환정산 구분값
			
			////정산금액 계산
			epce4770701Service.getExcaData(param, list, searchData);
			
			
			//HashMap<String, String> amtMap = (HashMap<String, String>)epce4792901Mapper.epce47929312_select3(param); // 지급/수납 예정금액
			//searchData.putAll(amtMap);
			
			long nExcaAmt = Long.parseLong(searchData.get("EXCA_AMT"));
			searchData.put("EXCA_PROC_STAT_CD", "I");									//I:발급 (C024)
			searchData.put("EXCA_ISSU_SE_CD", "C");										//정산서발급구분코드(G:보증금, F:취급수수료, W:반환정산, C:교환정산)
			searchData.put("EXCA_SE_CD", nExcaAmt>0 ? "C" : "A");					//정산처리구분(A:납부, C:환급)
			searchData.put("EXCA_AMT", String.valueOf(Math.abs(nExcaAmt)));	//정산금액
			searchData.put("GTN", String.valueOf(Math.abs(nExcaAmt)));
			searchData.put("BIZRID", param.get("BIZRID"));
			searchData.put("BIZRNO", param.get("BIZRNO"));
			searchData.put("STD_YEAR", map.get("STD_YEAR"));
			searchData.put("S_USER_ID", ssUserId);
			param.put("S_USER_ID", ssUserId);
			
			String doc_psnb_cd ="CL"; //교환정산 문서번호 
	 		String stac_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
			searchData.put("STAC_DOC_NO", stac_doc_no); //문서채번
			param.put("STAC_DOC_NO", stac_doc_no); //문서채번
			
			//정산서발급 (보증금)
			epce4792901Mapper.epce47929312_insert(searchData);
			
			//정산서발급 상세 (보증금)
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("list", list);
			data.put("STAC_DOC_NO", stac_doc_no);
			data.put("S_USER_ID", ssUserId);
			epce4792901Mapper.epce47929312_insert2(data);
			
			//교환 상태 변경
			epce4792901Mapper.epce47929312_update(data);
			
			//생산자보증금잔액 인서트
			param.put("GTN_BAL_INDE_AMT", searchData.get("GTN_BAL_INDE_AMT"));
			param.put("AGTN_INDE_AMT", searchData.get("AGTN_INDE_AMT"));
			param.put("GTN_INDE", searchData.get("GTN_INDE"));
			epce4792901Mapper.epce47929312_insert3(param);
			
		} catch (Exception e) {
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
	
	/**
	 * 교환정산서 상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce47929643_select(ModelMap model, HttpServletRequest request) {

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
		model.addAttribute("INQ_PARAMS",jParams);
		
		String title = commonceService.getMenuTitle("EPCE47929643");
		model.addAttribute("titleSub", title);
		
		Map<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		HashMap<?, ?> searchDtl = epce4707201Mapper.epce4707264_select(param);
		List<?> searchList = new ArrayList<Object>();

		try {
			
			searchList = epce4792901Mapper.epce47929643_select(param);
			
			model.addAttribute("searchDtl", util.mapToJson(searchDtl));
			model.addAttribute("searchList", util.mapToJson(searchList));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 정산서발급취소
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce47929643_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		String ssBizrTpCd = ""; //사업자유형
		
		try {

			if(vo != null){
				ssUserId = vo.getUSER_ID();
				ssBizrTpCd = vo.getBIZR_TP_CD();
			}
			inputMap.put("S_USER_ID", ssUserId);

			//센터 사용자만 처리 가능
			if(!ssBizrTpCd.equals("T1")){
				throw new Exception("G001");
			}

			//정산서 상태가 '발급'이 아닌 경우 취소 불가
			int nChckCnt = epce4792901Mapper.epce47929643_select2(inputMap);
			if(nChckCnt > 0){
				throw new Exception("G002");
			}

			//정산서 관련문서 상태 변경
			epce4792901Mapper.epce47929643_update(inputMap);

			//정산서 삭제
			epce4792901Mapper.epce47929643_delete(inputMap);

		} catch (Exception e) {
			if(e.getMessage().equals("G001") || e.getMessage().equals("G002") ){
				throw new Exception(e.getMessage());
			}else{
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}

		return errCd;

	}
	
}


