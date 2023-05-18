package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.mapper.ce.ep.EPCE4729401Mapper;

/**
 * 생산자정산 수납확인 서비스
 * @author Administrator
 *
 */
@Service("epce4729401Service")
public class EPCE4729401Service {

	@Resource(name="epce4729401Mapper")
	private EPCE4729401Mapper epce4729401Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4729401_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		Map<String, String> map = new HashMap<String, String>();
		
		try {
			
			List<?> stdMgntList = commonceService.std_mgnt_select(request, map); //정산기간
			model.addAttribute("stdMgntList", util.mapToJson(stdMgntList));
			
			List<?> bizrList 	= commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
			model.addAttribute("bizrList", util.mapToJson(bizrList));	//생산자 리스트
			
			List<?> acctNoList = epce4729401Mapper.epce4729401_select3(null);
			model.addAttribute("acctNoList", util.mapToJson(acctNoList)); //가상계좌번호 리스트
			
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
	public HashMap<String, Object> epce4729401_select2(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> list = epce4729401Mapper.epce4729401_select(data);

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
	public HashMap<String, Object> epce4729401_select3(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> list = epce4729401Mapper.epce4729401_select2(data);

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
	public HashMap<String, Object> epce4729401_select4(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> vacctNoList = epce4729401Mapper.epce4729401_select3(data);

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
	 * 생산자정산 수납확인 저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4729401_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserId  = "";   //사용자ID
		if(vo != null){
			ssUserId = vo.getUSER_ID();
		}
		
		String errCd = "0000";
		int procCnt = 0;
		
		List<?> jsonHand = JSONArray.fromObject(inputMap.get("jsonHand"));

		if (jsonHand != null ) {
			
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
							
							//생산자정산 수납확인 일련번호 채번
							String acpCfmSeq = commonceService.psnb_select("S0004");

							//고지내역 처리
							for(int j=0; j<arrBill.size(); j++){
								Map<String, String> billMap = (Map<String, String>) arrBill.get(j);
								
								billMap.put("EXCA_ACP_CFM_SEQ", acpCfmSeq); //생산자정산 수납확인일련번호
								billMap.put("S_USER_ID", ssUserId);
								
								//중복처리대상 조회
								procCnt = epce4729401Mapper.epce4729401_select4(billMap);
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
								
								acpMap.put("EXCA_ACP_CFM_SEQ", acpCfmSeq); //생산자정산 수납확인일련번호
								acpMap.put("S_USER_ID", ssUserId);
								
								//수납내역 처리
								epce4729401Mapper.epce4729401_update2(acpMap);
							}
							
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
		
		//생산자정산 수납확인 처리
		epce4729401Mapper.epce4729401_update(map);

		if(map.get("EXCA_ISSU_SE_CD").equals("G") || map.get("EXCA_ISSU_SE_CD").equals("C")){ //정산서발급구분 '보증금'  & 교환정산
			epce4729401Mapper.epce4729401_insert(map); //생산자보증금잔액 인서트
		}

		// ERP 연계테이블 인서트
		HashMap<String, String> taMap = new HashMap<String, String>();
		taMap.putAll(map);
		
		String lkExcaSeCd = "";
		if(map.get("EXCA_SE_CD").equals("A")){ // A: 납부(수납)   C: 환급(지급)
			if(map.get("EXCA_ISSU_SE_CD").equals("W")){//도매업자 정산
				lkExcaSeCd = "5";
			}
			else if(map.get("EXCA_ISSU_SE_CD").equals("C")){//도매업자 정산
				lkExcaSeCd = "A"; // A 교환, B 교환수납, C 교환지급
			}
			else{
				lkExcaSeCd = "6";
			}
		}else if(map.get("EXCA_SE_CD").equals("C")){ // A: 납부(수납)   C: 환급(지급)
			if(map.get("EXCA_ISSU_SE_CD").equals("W")){//도매업자 정산
				lkExcaSeCd = "2";
			}else{
				lkExcaSeCd = "7";
			}
		}
		
		taMap.put("LK_EXCA_SE_CD", lkExcaSeCd); 					//연계구분
		taMap.put("EXCA_ISSU_DT", util.getShortDateString()); 		//생산자정산 수납확인일자
		taMap.put("EXCA_ISSU_TM", util.getShortTimeString()); 		//생산자정산 수납확인시간

		if(map.get("EXCA_ISSU_SE_CD").equals("W")){ 
			epce4729401Mapper.INSERT_FI_Z_KORA_ECDOCU_W(taMap); //반환정산
		}else if(taMap.get("EXCA_ISSU_SE_CD").equals("F")){
			epce4729401Mapper.INSERT_FI_Z_KORA_ECDOCU_F(taMap); //취급수수료
		}else if(taMap.get("EXCA_ISSU_SE_CD").equals("G")){
			epce4729401Mapper.INSERT_FI_Z_KORA_ECDOCU_G(taMap); //보증금,  교환정산
		}else if(taMap.get("EXCA_ISSU_SE_CD").equals("C")){ 
			epce4729401Mapper.INSERT_FI_Z_KORA_ECDOCU_C(taMap); // 교환정산
			
			long lnExAmt = 0;
			lnExAmt = Long.parseLong(String.valueOf((taMap.get("EXCA_AMT"))));
			
			if(lnExAmt > 0) {
				taMap.put("GTN"          , String.valueOf(taMap.get("EXCA_AMT"))); 		//정산금액
				taMap.put("LK_EXCA_SE_CD", "B"); 						//연계구분 (A 교환, B 교환수납, C 교환지급)
				epce4729401Mapper.INSERT_FI_Z_KORA_ECDOCU_G(taMap); //보증금,  교환정산
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
	public String epce4729401_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {

				List<?> list = JSONArray.fromObject(data.get("list"));
				
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = (Map<String, String>)list.get(i);

					epce4729401Mapper.epce4729401_update3(map); //착오수납처리    
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
