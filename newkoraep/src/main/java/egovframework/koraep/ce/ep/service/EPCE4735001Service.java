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
import egovframework.mapper.ce.ep.EPCE4735001Mapper;

/**
 * 도매업자정산 수납확인 서비스
 * @author Administrator
 *
 */
@Service("epce4735001Service")
public class EPCE4735001Service {

	@Resource(name="epce4735001Mapper")
	private EPCE4735001Mapper epce4735001Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4735001_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		Map<String, String> map = new HashMap<String, String>();
		
		try {
			
			List<?> stdMgntList = commonceService.std_mgnt_select(request, map); //정산기간
			model.addAttribute("stdMgntList", util.mapToJson(stdMgntList));
			
			List<?> whslSeCdList = commonceService.whsdl_se_select(request, map); //도매업자구분
			List<?>	whsdlList =commonceService.mfc_bizrnm_select4(request, map); //도매업자 업체명조회
			model.addAttribute("whslSeCdList", util.mapToJson(whslSeCdList));
			model.addAttribute("whsdlList", util.mapToJson(whsdlList));
			
			List<?> acctNoList = epce4735001Mapper.epce4735001_select3(null);
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
	public HashMap<String, Object> epce4735001_select2(Map<String, String> data) {

		String BIZRID_NO = data.get("WHSDL_BIZRNM");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> list = epce4735001Mapper.epce4735001_select(data);

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
	public HashMap<String, Object> epce4735001_select3(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> list = epce4735001Mapper.epce4735001_select2(data);

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
	public HashMap<String, Object> epce4735001_select4(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> vacctNoList = epce4735001Mapper.epce4735001_select3(data);

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
	 * 도매업자정산 수납확인 저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4735001_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
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
							
							//도매업자정산 수납확인 일련번호 채번
							String acpCfmSeq = commonceService.psnb_select("S0004");
	
							//고지내역 처리
							for(int j=0; j<arrBill.size(); j++){
								Map<String, String> billMap = (Map<String, String>) arrBill.get(j);
								
								billMap.put("EXCA_ACP_CFM_SEQ", acpCfmSeq); //도매업자정산 수납확인일련번호
								billMap.put("S_USER_ID", ssUserId);
								
								//중복처리대상 조회
								procCnt = epce4735001Mapper.epce4735001_select4(billMap);
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
								
								acpMap.put("EXCA_ACP_CFM_SEQ", acpCfmSeq); //도매업자정산 수납확인일련번호
								acpMap.put("S_USER_ID", ssUserId);
								
								//수납내역 처리
								epce4735001Mapper.epce4735001_update2(acpMap);
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
		
		//도매업자정산 수납확인 처리
		epce4735001Mapper.epce4735001_update(map);

		if(map.get("EXCA_ISSU_SE_CD").equals("G") || map.get("EXCA_ISSU_SE_CD").equals("W")){ //정산서발급구분 '보증금', '반환정산'
			epce4735001Mapper.epce4735001_insert(map); //생산자보증금잔액 인서트
		}

		// ERP 연계테이블 인서트
		HashMap<String, String> taMap = new HashMap<String, String>();
		taMap.putAll(map);
		
		String lkExcaSeCd = "";
		if(map.get("EXCA_SE_CD").equals("A")){ // A: 납부   C: 환급
			if(map.get("EXCA_ISSU_SE_CD").equals("W")){//도매업자 정산
				lkExcaSeCd = "5";
			}else{
				lkExcaSeCd = "6";
			}
		}else if(map.get("EXCA_SE_CD").equals("C")){ // A: 납부   C: 환급
			if(map.get("EXCA_ISSU_SE_CD").equals("W")){//도매업자 정산
				lkExcaSeCd = "2";
			}else{
				lkExcaSeCd = "7";
			}
		}
		
		taMap.put("LK_EXCA_SE_CD", lkExcaSeCd); 						//연계구분
		taMap.put("EXCA_ISSU_DT", util.getShortDateString()); 		//도매업자정산 수납확인일자
		taMap.put("EXCA_ISSU_TM", util.getShortTimeString()); 		//도매업자정산 수납확인시간

		if(map.get("EXCA_ISSU_SE_CD").equals("W")){ 
			epce4735001Mapper.INSERT_FI_Z_KORA_ECDOCU_W(taMap); //반환정산
		}else if(taMap.get("EXCA_ISSU_SE_CD").equals("F")){
			epce4735001Mapper.INSERT_FI_Z_KORA_ECDOCU_F(taMap); //취급수수료
		}else if(taMap.get("EXCA_ISSU_SE_CD").equals("G")){
			epce4735001Mapper.INSERT_FI_Z_KORA_ECDOCU_G(taMap); //보증금
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
	public String epce4735001_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {

				List<?> list = JSONArray.fromObject(data.get("list"));
				
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = (Map<String, String>)list.get(i);

					epce4735001Mapper.epce4735001_update3(map); //착오수납처리    
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
