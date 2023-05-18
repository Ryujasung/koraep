package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.GregorianCalendar;
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
import egovframework.mapper.ce.ep.EPCE2346301Mapper;

/**
 * 수납확인 서비스
 * @author Administrator
 *
 */
@Service("epce2346301Service")
public class EPCE2346301Service {

	@Resource(name="epce2346301Mapper")
	private EPCE2346301Mapper epce2346301Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2346301_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		try {
			List<?> bizrList 	= commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
			model.addAttribute("bizrList", util.mapToJson(bizrList));	//생산자 리스트
			
			List<?> vacctNoList = epce2346301Mapper.epce2346301_select3(null);
			model.addAttribute("vacctNoList", util.mapToJson(vacctNoList)); //가상계좌번호 리스트
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
	 * 고지서 리스트 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2346301_select2(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> list = epce2346301Mapper.epce2346301_select(data);

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
	 * 가상계좌수납 리스트 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2346301_select3(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> list = epce2346301Mapper.epce2346301_select2(data);

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
	 * 가상계좌번호 리스트 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2346301_select4(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> vacctNoList = epce2346301Mapper.epce2346301_select3(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(vacctNoList));
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
	 * 수납확인 저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce2346301_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserId  = "";   //사용자ID
		if(vo != null){
			ssUserId = vo.getUSER_ID();
		}
		
		String errCd = "0000";
		int procCnt = 0;
		
		List<?> jsonHand = JSONArray.fromObject(inputMap.get("jsonHand"));
		List<?> jsonAuto = JSONArray.fromObject(inputMap.get("jsonAuto"));

		if (jsonHand != null || jsonAuto != null) {
			
			try {
				
				//erp 부서정보 연계
				commonceService.updateErpSendBsnmInfo(ssUserId); 
				
				if (jsonHand != null ){
					//수기확인 처리
					for(int i=0; i<jsonHand.size(); i++){
						Map<String, String> map = (Map<String, String>) jsonHand.get(i);
						
						List<?> arrBill = JSONArray.fromObject(map.get("arrBill"));
						List<?> arrAcp  = JSONArray.fromObject(map.get("arrAcp"));
						
						if(arrBill == null){
							throw new Exception("A007"); //저장할 데이타가 없습니다.
						}else{
							
							//수납확인 일련번호 채번
							String acpCfmSeq = commonceService.psnb_select("S0008"); 
	
							//고지내역 처리
							for(int j=0; j<arrBill.size(); j++){
								Map<String, String> billMap = (Map<String, String>) arrBill.get(j);
								
								billMap.put("ACP_CFM_SEQ", acpCfmSeq); //수납확인일련번호
								billMap.put("ACP_CFM_MNUL_YN", "Y"); //수납확인 수기여부
								billMap.put("S_USER_ID", ssUserId);
								
								//중복처리대상 조회
								procCnt = epce2346301Mapper.epce2346301_select4(billMap);
								if(procCnt > 0){
									throw new Exception("A004"); //이미 처리된 데이터 입니다. 
								}else{
									//고지내역 처리
									updateBillInfo(billMap);
								}
							}
							
							//수납내역 처리
							for(int j=0; j<arrAcp.size(); j++){
								Map<String, String> acpMap = (Map<String, String>) arrAcp.get(j);
								
								acpMap.put("ACP_CFM_SEQ", acpCfmSeq); //수납확인일련번호
								acpMap.put("S_USER_ID", ssUserId);
								
								//수납내역 처리
								epce2346301Mapper.epce2346301_update2(acpMap);
							}
							
						}
					}
				}

				if (jsonAuto != null ){
					//자동확인 처리
					for(int i=0; i<jsonAuto.size(); i++){
						Map<String, String> map = (Map<String, String>) jsonAuto.get(i);
	
						//중복처리대상 조회
						procCnt = epce2346301Mapper.epce2346301_select4(map);
						if(procCnt > 0){
							throw new Exception("A004"); //이미 처리된 데이터 입니다. 
						}else{
							
							//수납확인 일련번호 채번
							String acpCfmSeq = commonceService.psnb_select("S0008");
	
							map.put("ACP_CFM_SEQ", acpCfmSeq); //수납확인일련번호
							map.put("ACP_CFM_MNUL_YN", "N"); //수납확인 수기여부
							map.put("S_USER_ID", ssUserId);
	
							//고지내역 처리
							updateBillInfo(map);
							
							//수납내역 처리
							epce2346301Mapper.epce2346301_update2(map);
						}
						
					}
				}
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch (Exception e) {
				if(e.getMessage().equals("A004") || e.getMessage().equals("A007") ){
					 throw new Exception(e.getMessage()); 
				}else{
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}
			
		}else{
			errCd = "A007"; //저장할 데이타가 없습니다.
		}
		
		return errCd;
	}
	
	/**
	 * 고지내역 처리
	 * @param map
	 * @param nextSeq
	 * @param request
	 * @
	 */
	@Transactional
	public void updateBillInfo(Map<String, String> map)  {
		
		map.put("ISSU_STAT_CD", "A"); //고지서 발급상태 - 수납확인
		map.put("STAT_CD", "AC"); //출고 및 입고상태 - 수납확인          PA - 지급요청   입고반환은 지급요청 상태로 변경?
		
		//수납확인 처리
		epce2346301Mapper.epce2346301_update(map);

		if(Long.parseLong(util.null2void(String.valueOf(map.get("NOTY_AMT")), "0")) > 0){
			
			//생산자보증금잔액 인서트
			epce2346301Mapper.epce2346301_insert(map);

			// ERP 연계테이블 인서트
			HashMap<String, String> taMap = new HashMap<String, String>();
			taMap.put("BILL_ISSU_DT", util.getShortDateString()); 		//수납확인일자
			taMap.put("BILL_ISSU_TM", util.getShortTimeString()); 		//수납확인시간
			taMap.put("BILL_DOC_NO", map.get("BILL_DOC_NO"));
			taMap.put("TP_EC", map.get("BILL_SE_CD").equals("F")?"4":"3");  //  3 보증금수납, 4 취급수수료수납
			taMap.put("TR_IL", map.get("TR_IL"));

			if(map.get("BILL_SE_CD").equals("F")){ //취급수수료
				epce2346301Mapper.INSERT_FI_Z_KORA_ECDOCU_F(taMap);   //연계처리 new
			}else{
				epce2346301Mapper.INSERT_FI_Z_KORA_ECDOCU(taMap);   //연계처리 new
			}
		}
	}
	
	
	/**
	 * 수정
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce2346301_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {

				List<?> list = JSONArray.fromObject(data.get("list"));
				
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = (Map<String, String>)list.get(i);

					epce2346301Mapper.epce2346301_update3(map); //착오수납처리    
		    	}
				
				
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}
