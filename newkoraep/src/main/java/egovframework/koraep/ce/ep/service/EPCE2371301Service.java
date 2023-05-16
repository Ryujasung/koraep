package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE2371301Mapper;

/**
 * 지급내역조회 서비스
 * @author Administrator
 *
 */
@Service("epce2371301Service")
public class EPCE2371301Service {

	@Resource(name="epce2371301Mapper")
	private EPCE2371301Mapper epce2371301Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2371301_select(ModelMap model, HttpServletRequest request) {

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

		HashMap<String, String> map = new HashMap<String, String>();
		//map.put("BIZR_TP_CD","W1");//도매업자
		//List<?> bizrListW = commonceService.bizr_select(map);
		List<?> whsdlSeCdList = commonceService.whsdl_se_select(request, map); //도매업자구분
		List<?> mfc_bizrnm_sel 	= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
		List<?> statList = commonceService.getCommonCdListNew("D034");
		List<?> txExecNmList = commonceService.getCommonCdListNew("D062");	// 이체실행상태
		
		try {
			//model.addAttribute("bizrListW", util.mapToJson(bizrListW));
			model.addAttribute("whsdlSeCdList", util.mapToJson(whsdlSeCdList));
			model.addAttribute("mfc_bizrnm_sel", util.mapToJson(mfc_bizrnm_sel));	//생산자구분 리스트
			model.addAttribute("statList", util.mapToJson(statList));
			model.addAttribute("txExecNmList", util.mapToJson(txExecNmList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));

		if(jmap != null && jmap.get("WHSDL_BIZR_SEL") != null && !jmap.get("WHSDL_BIZR_SEL").equals("")){
			jmap.put("BIZR_TP_CD", jmap.get("WHSDL_SE_CD_SEL"));
			model.addAttribute("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, jmap)));
		}else{
			model.addAttribute("whsdlList", "{}");
		}
		
		return model;
	}

	/**
	 * 연계전송 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2371331_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE2371331");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);

		return model;
	}

	/**
	 * 지급내역상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2371364_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE2371364");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));

		List<?> searchDtl = epce2371301Mapper.epce2371364_select(map);
		List<?> searchList = epce2371301Mapper.epce2371364_select2(map);

		try {
			model.addAttribute("searchDtl", util.mapToJson(searchDtl));
			model.addAttribute("searchList", util.mapToJson(searchList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return model;
	}

	/**
	 * 지급내역조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2371301_select2(Map<String, String> data) {

		String BIZRID_NO2 = data.get("WHSDL_BIZR_SEL");
		String MFC_BIZRNM = data.get("MFC_BIZRNM_SEL");

		if(BIZRID_NO2 != null && !BIZRID_NO2.equals("")){
			data.put("WHSDL_BIZRID", BIZRID_NO2.split(";")[0]);
			data.put("WHSDL_BIZRNO", BIZRID_NO2.split(";")[1]);
		}
		
		if(MFC_BIZRNM != null && !MFC_BIZRNM.equals("")){
			data.put("MFC_BIZRID", MFC_BIZRNM.split(";")[0]);
			data.put("MFC_BIZRNO", MFC_BIZRNM.split(";")[1]);
		}else{
			data.put("MFC_BIZRID", "");
			data.put("MFC_BIZRNO", "");
		}
		System.out.println("data"+data);
		List<?> list = epce2371301Mapper.epce2371301_select(data);

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
	 * 연계자료생성
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce2371331_insert(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		List<?> list = JSONArray.fromObject(inputMap.get("list"));

		String ssUserId  = "";   //사용자ID
		String ssBizrno  = "";   //사용자 사업자번호
		String strDate = util.getShortDateString();
		String strTime = util.getShortTimeString();
		int regSeq = 0;

		int totCnt = 0;

		if (list != null) {
			try {

				if(vo != null){
					ssUserId = vo.getUSER_ID();
					ssBizrno = vo.getBIZRNO();
				}

				//erp 부서정보 연계
				commonceService.updateErpSendBsnmInfo(ssUserId);

				for(int i=0; i<list.size(); i++){

					regSeq++;
					Map<String, String> map = (Map<String, String>) list.get(i);
					
					//지급금액0원 데이터는 바로 처리
					if(String.valueOf(map.get("PAY_AMT")).equals("0")){
						
						map.put("S_USER_ID" , ssUserId);
						//지급확인 처리
						epce2371301Mapper.epce2371331_update4(map);
						
					}else{
						
						//연계전송처리중 상태로 변경 C (D034)
						map.put("BF_PAY_STAT_CD", "L"); /* 지급예정 */
						map.put("PAY_STAT_CD", "C");
						map.put("LK_BIZRNO", ssBizrno);
						map.put("LK_REG_DATE", strDate);
						map.put("LK_REG_TIME", strTime);
						map.put("LK_REG_SEQ", String.valueOf(regSeq));

						int cnt = epce2371301Mapper.epce2371331_update(map);

						if(cnt == 0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						}
						
					}
				}

				Map<String, String> iMap = new HashMap<String, String>();
				iMap.put("LK_REG_DATE" , strDate);
				iMap.put("LK_REG_TIME" , strTime);
				iMap.put("S_USER_ID" , ssUserId);
				iMap.put("YN_RE" , "N"); /* 재전송 N */

				//연계처리
				epce2371301Mapper.epce2371331_update2(iMap);

				//연계전송완료 상태로 변경 S (D034)
				iMap.put("PAY_STAT_CD", "S");
				totCnt = epce2371301Mapper.epce2371331_update3(iMap);

				//최종 상태변경 데이터카운트가 맞지않을때..
				if(totCnt != list.size()){
					throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
				}

			} catch (Exception e) {
				if(e.getMessage().equals("A012") ){
					 throw new Exception(e.getMessage());
				}else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}
		}//end of list

		return errCd;
	}

	/**
	 * 오류건 재전송
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce2371331_insert2(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		List<?> list = JSONArray.fromObject(inputMap.get("list"));

		String ssUserId  = "";   //사용자ID
		String ssBizrno  = "";   //사용자 사업자번호
		String strDate = util.getShortDateString();
		String strTime = util.getShortTimeString();
		int regSeq = 0;

		int totCnt = 0;

		if (list != null) {
			try {

				if(vo != null){
					ssUserId = vo.getUSER_ID();
					ssBizrno = vo.getBIZRNO();
				}

				//erp 부서정보 연계
				commonceService.updateErpSendBsnmInfo(ssUserId);

				for(int i=0; i<list.size(); i++){

					regSeq++;
					Map<String, String> map = (Map<String, String>) list.get(i);

					//연계전송처리중 상태로 변경 C (D034)
					map.put("BF_PAY_STAT_CD", "R"); /* 지급오류 */
					map.put("PAY_STAT_CD", "C");
					map.put("LK_BIZRNO", ssBizrno);
					map.put("LK_REG_DATE", strDate);
					map.put("LK_REG_TIME", strTime);
					map.put("LK_REG_SEQ", String.valueOf(regSeq));

					int cnt = epce2371301Mapper.epce2371331_update(map);

					if(cnt == 0){
						throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					}

				}

				Map<String, String> iMap = new HashMap<String, String>();
				iMap.put("LK_REG_DATE" , strDate);
				iMap.put("LK_REG_TIME" , strTime);
				iMap.put("S_USER_ID" , ssUserId);
				iMap.put("YN_RE" , "Y"); /* 재전송 Y */

				//연계처리
				epce2371301Mapper.epce2371331_update2(iMap);

				//연계전송완료 상태로 변경 S (D034)
				iMap.put("PAY_STAT_CD", "S");
				totCnt = epce2371301Mapper.epce2371331_update3(iMap);

				//최종 상태변경 데이터카운트가 맞지않을때..
				if(totCnt != list.size()){
					throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
				}

			} catch (Exception e) {
				if(e.getMessage().equals("A012") ){
					 throw new Exception(e.getMessage());
				}else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}
		}//end of list

		return errCd;
	}

	/**
	 *  엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce2371301_excel(HashMap<String, String> data, HttpServletRequest request) {
		String errCd = "0000";

		try {
			String BIZRID_NO2 = data.get("WHSDL_BIZR_SEL");
			String MFC_BIZRNM = data.get("MFC_BIZRNM_SEL");
			
			if(BIZRID_NO2 != null && !BIZRID_NO2.equals("")){
				data.put("WHSDL_BIZRID", BIZRID_NO2.split(";")[0]);
				data.put("WHSDL_BIZRNO", BIZRID_NO2.split(";")[1]);
			}

			if(MFC_BIZRNM != null && !MFC_BIZRNM.equals("")){
				data.put("MFC_BIZRID", MFC_BIZRNM.split(";")[0]);
				data.put("MFC_BIZRNO", MFC_BIZRNM.split(";")[1]);
			}else{
				data.put("MFC_BIZRID", "");
				data.put("MFC_BIZRNO", "");
			}
			
			data.put("excelYn", "Y");
			List<?> list = epce2371301Mapper.epce2371301_select(data);

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
	public String epce2371364_excel(HashMap<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {

			data.put("excelYn", "Y");
			List<?> list = epce2371301Mapper.epce2371364_select2(data);

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
