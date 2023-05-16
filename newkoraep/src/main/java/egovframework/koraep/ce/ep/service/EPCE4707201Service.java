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
import egovframework.mapper.ce.ep.EPCE4707201Mapper;
import egovframework.mapper.ce.ep.EPCE4770701Mapper;
import net.sf.json.JSONObject;

/**
 * 정산서조회  서비스
 * @author Administrator
 *
 */
@Service("epce4707201Service")
public class EPCE4707201Service {

	@Resource(name="epce4707201Mapper")
	private EPCE4707201Mapper epce4707201Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4707201_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		Map<String, String> map = new HashMap<String, String>();

		List<?> stdMgntList = commonceService.std_mgnt_select(request, map); //정산기간
		List<?> excaSeList = commonceService.getCommonCdListNew("C023");
		List<?> excaProcStatList = commonceService.getCommonCdListNew("C024");
		List<?> bizrTpList = epce4707201Mapper.epce4707201_select();

		try {

			model.addAttribute("stdMgntList", util.mapToJson(stdMgntList));
			model.addAttribute("excaSeList", util.mapToJson(excaSeList));
			model.addAttribute("excaProcStatList", util.mapToJson(excaProcStatList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));

		} catch (Exception e) {
			// TODO Auto-generated catch block
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
	public ModelMap epce4707264_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		String title = commonceService.getMenuTitle("EPCE4707264");
		model.addAttribute("titleSub", title);

		Map<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));

		HashMap<?, ?> searchDtl = epce4707201Mapper.epce4707264_select(param);
		List<?> searchList = new ArrayList<Object>();
		List<?> searchList2 = new ArrayList<Object>();
		List<?> searchList3 = new ArrayList<Object>();
		List<?> searchList4 = new ArrayList<Object>();
		List<?> searchList5 = new ArrayList<Object>();
		List<?> searchList6 = new ArrayList<Object>();
		List<?> searchList7 = new ArrayList<Object>();
		List<?> searchList8 = new ArrayList<Object>();
		List<?> searchList9 = new ArrayList<Object>();

		if(param.get("EXCA_ISSU_SE_CD").equals("G")){ //보증금
			searchList7 = epce4707201Mapper.epce4707264_select2(param);
		}else if(param.get("EXCA_ISSU_SE_CD").equals("F")){ //취급수수료
			searchList7 = epce4707201Mapper.epce4707264_select8(param);
		}else if(param.get("EXCA_ISSU_SE_CD").equals("W")){ //반환정산
			param.put("B", "B");
		}

		for(int i=0; i<searchList7.size(); i++){
			Map<String, String> map = (Map<String, String>)searchList7.get(i);
			param.put(map.get("ETC_CD"), map.get("ETC_CD"));
		}

		try {

			if(param.containsKey("A")) searchList = epce4707201Mapper.epce4707264_select3(param);
			if(param.containsKey("B")) searchList2 = epce4707201Mapper.epce4707264_select4(param);
			if(param.containsKey("C")) searchList3 = epce4707201Mapper.epce4707264_select5(param);
			if(param.containsKey("D")) searchList4 = epce4707201Mapper.epce4707264_select9(param); //교환정산 과거데이터
			if(param.containsKey("E")) searchList5 = epce4707201Mapper.epce4707264_select6(param);
			if(param.containsKey("F")) searchList6 = epce4707201Mapper.epce4707264_select7(param);
			if(param.containsKey("I")) searchList8 = epce4707201Mapper.epce4707264_select10(param); //연간입고량조정
			if(param.containsKey("J")) searchList9 = epce4707201Mapper.epce4707264_select11(param); //연간교환량조정

			model.addAttribute("searchDtl", util.mapToJson(searchDtl));
			model.addAttribute("searchList", util.mapToJson(searchList));
			model.addAttribute("searchList2", util.mapToJson(searchList2));
			model.addAttribute("searchList3", util.mapToJson(searchList3));
			model.addAttribute("searchList4", util.mapToJson(searchList4));
			model.addAttribute("searchList5", util.mapToJson(searchList5));
			model.addAttribute("searchList6", util.mapToJson(searchList6));
			model.addAttribute("searchList7", util.mapToJson(searchList7));
			model.addAttribute("searchList8", util.mapToJson(searchList8));
			model.addAttribute("searchList9", util.mapToJson(searchList9));

		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}

	/**
	 * 정산서조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4707201_select2(Map<String, String> data) {

		List<?> list = epce4707201Mapper.epce4707201_select2(data);
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}
	
	
	/**
	 * 정산서 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce4707201_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			data.put("excelYn", "Y");
			List<?> list = epce4707201Mapper.epce4707201_select2(data);

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
	 * 정산서발급취소
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4707201_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		String ssBizrTpCd = ""; //사업자유형

		String BIZRID_NO = inputMap.get("MFC_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			inputMap.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
			inputMap.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
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
			int nChckCnt = epce4707201Mapper.epce4707201_select3(inputMap);
			if(nChckCnt > 0){
				throw new Exception("G002");
			}

			//정산서 관련문서 상태 변경
			epce4707201Mapper.epce4707201_update(inputMap);

			//정산서 삭제
			epce4707201Mapper.epce4707201_delete(inputMap);

		} catch (Exception e) {
			if(e.getMessage().equals("G001") || e.getMessage().equals("G002") ){
				throw new Exception(e.getMessage());
			}else{
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}

		return errCd;

	}
	
	
	/**
	 * 수기정산서발급취소
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4707201_update2(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {

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
			int nChckCnt = epce4707201Mapper.epce4707201_select3_m(inputMap);
			if(nChckCnt > 0){
				throw new Exception("G002");
			}

			//정산서 관련문서 상태 변경
			epce4707201Mapper.epce4707201_update_m(inputMap);

			//정산서 삭제
			epce4707201Mapper.epce4707201_delete_m(inputMap);

		} catch (Exception e) {
			if(e.getMessage().equals("G001") || e.getMessage().equals("G002") ){
				throw new Exception(e.getMessage());
			}else{
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}

		return errCd;
	}	

	/**
	 * 수납확인 상세조회 (정산서)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4707288_select(Map<String, String> data) {

		List<?> menuList = epce4707201Mapper.epce4707288_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 수납확인 상세조회 (수납내역)
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4707288_select2(Map<String, String> data) {

		List<?> menuList = epce4707201Mapper.epce4707288_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}
	
	/**
	 * 재고지 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce47072882_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPCE47072882");
		model.addAttribute("titleSub", title);
		
		return model;
	}
	
	/**
	 * 정산서발급취소 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce47072883_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPCE47072883");
		model.addAttribute("titleSub", title);
		
		return model;
	}
	
	/**
	 * 재고지 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce47072882_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
					sUserId = vo.getUSER_ID();
				}

				int rcnt = epce4707201Mapper.epce47072882_update(data); //등록
				if(rcnt < 1){
					throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
				}
				
		}catch(Exception e){
			if(e.getMessage().equals("A012") ){
				 throw new Exception(e.getMessage()); 
			}else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}
		
		return errCd;
	}

	/**
	 * 정산서발급취소 생산자 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce47072883_select2(Map<String, String> data) {

		List<?> list = epce4707201Mapper.epce47072883_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}
	
	/**
	 * 정산서 재고지 취소
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4707264_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";

		try {
			
			if(vo != null){
				inputMap.put("S_USER_ID", vo.getUSER_ID());
			}
			
			//재고지 취소
			epce4707201Mapper.epce4707264_update(inputMap);

		} catch (Exception e) {
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
}
