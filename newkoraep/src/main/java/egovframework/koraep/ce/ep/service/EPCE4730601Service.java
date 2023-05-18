package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE4730601Mapper;
import egovframework.mapper.ce.ep.EPCE6652931Mapper;

/**
 * 도매업자정산지급내역  서비스
 * @author Administrator
 *
 */
@Service("epce4730601Service")
public class EPCE4730601Service {

	@Resource(name="epce4730601Mapper")
	private EPCE4730601Mapper epce4730601Mapper;
	
	@Resource(name="epce6652931Mapper")
	private EPCE6652931Mapper epce6652931Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4730601_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		Map<String, String> map = new HashMap<String, String>();
		
		List<?> stdMgntList = commonceService.std_mgnt_select(request, map); //정산기간
		List<?> excaProcStatList = commonceService.getCommonCdListNew("C024");
		List<?> txExecNmList = commonceService.getCommonCdListNew("D062");	// 이체실행상태
		
		try {

			model.addAttribute("stdMgntList", util.mapToJson(stdMgntList));
			model.addAttribute("excaProcStatList", util.mapToJson(excaProcStatList));
			model.addAttribute("txExecNmList", util.mapToJson(txExecNmList));
			
			List<?> whslSeCdList = commonceService.whsdl_se_select(request, map); //도매업자구분
			List<?>	whsdlList =commonceService.mfc_bizrnm_select4(request, map); //도매업자 업체명조회
			model.addAttribute("whslSeCdList", util.mapToJson(whslSeCdList));
			model.addAttribute("whsdlList", util.mapToJson(whsdlList));
			
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
	 * 연계전송 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4730631_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE4730631");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);

		return model;
	}
	
	/**
	 * 도매업자정산지급내역 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4730601_select2(Map<String, String> data) {
		
		String WHSDL_BIZR = data.get("WHSDL_BIZRNM");

		if(WHSDL_BIZR != null && !WHSDL_BIZR.equals("")){
			data.put("BIZRID", WHSDL_BIZR.split(";")[0]);
			data.put("BIZRNO", WHSDL_BIZR.split(";")[1]);
		}
		
		List<?> list = epce4730601Mapper.epce4730601_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
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
		
		return map;
	}
	
	/**
	 * 연계전송
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4730601_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
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
					
					//연계전송처리중 상태로 변경 C (C024)
					map.put("BF_EXCA_PROC_STAT_CD", "I"); //발급
					map.put("EXCA_PROC_STAT_CD", "C");
					map.put("LK_SITE_NO", ssBizrno);
					map.put("LK_REG_DATE", strDate);
					map.put("LK_REG_TIME", strTime);
					map.put("LK_REG_SEQ", String.valueOf(regSeq));

					int cnt = epce4730601Mapper.epce4730601_update(map);
					
					if(cnt == 0){
						throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					}
				}
				
				Map<String, String> iMap = new HashMap<String, String>();
				iMap.put("LK_REG_DATE" , strDate);
				iMap.put("LK_REG_TIME" , strTime);
				iMap.put("S_USER_ID" , ssUserId);
				iMap.put("YN_RE" , "N"); //재전송여부
				
				//연계처리
				//if(iMap.get("EXCA_ISSU_SE_CD").equals("W")){//반환정산 (도매업자)
					epce4730601Mapper.INSERT_FI_Z_KORA_ECDOCU_W(iMap);
				//}else{
					//epce4730601Mapper.INSERT_FI_Z_KORA_ECDOCU(iMap);
				//}
				
				//연계전송완료 상태로 변경 S (C024)
				iMap.put("EXCA_PROC_STAT_CD", "L");
				totCnt = epce4730601Mapper.epce4730601_update2(iMap);
				
				//최종 상태변경 데이터카운트가 맞지않을때..
				if(totCnt != list.size()){
					throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
				}
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
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
	public String epce4730601_update2(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
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
					
					//연계전송처리중 상태로 변경 C (C024)
					map.put("BF_EXCA_PROC_STAT_CD", "R"); //지급오류
					map.put("EXCA_PROC_STAT_CD", "C");
					map.put("LK_SITE_NO", ssBizrno);
					map.put("LK_REG_DATE", strDate);
					map.put("LK_REG_TIME", strTime);
					map.put("LK_REG_SEQ", String.valueOf(regSeq));

					int cnt = epce4730601Mapper.epce4730601_update(map);
					
					if(cnt == 0){
						throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					}
				}
				
				Map<String, String> iMap = new HashMap<String, String>();
				iMap.put("LK_REG_DATE" , strDate);
				iMap.put("LK_REG_TIME" , strTime);
				iMap.put("S_USER_ID" , ssUserId);
				iMap.put("YN_RE" , "Y"); //재전송여부
				
				//연계처리
				//if(iMap.get("EXCA_ISSU_SE_CD").equals("W")){//반환정산 (도매업자)
					epce4730601Mapper.INSERT_FI_Z_KORA_ECDOCU_W(iMap);
				//}else{
					//epce4730601Mapper.INSERT_FI_Z_KORA_ECDOCU(iMap);
				//}
				
				//연계전송완료 상태로 변경 S (C024)
				iMap.put("EXCA_PROC_STAT_CD", "L");
				totCnt = epce4730601Mapper.epce4730601_update2(iMap);
				
				//최종 상태변경 데이터카운트가 맞지않을때..
				if(totCnt != list.size()){
					throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
				}
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
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
	
}
