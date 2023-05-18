package egovframework.koraep.mf.ep.service;

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
import egovframework.mapper.mf.ep.EPMF6104901Mapper;

/**
 * 상세출고현황 Service
 * @author 이내희
 *
 */
@Service("epmf6104901Service")
public class EPMF6104901Service {  
	
	@Resource(name="epmf6104901Mapper")
	private EPMF6104901Mapper epmf6104901Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 상세출고현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf6104901_select(ModelMap model, HttpServletRequest request) {
		  
		  Map<String, String> map = new HashMap<String, String>();
		  
			
			try {
				List<?> statCdList	 = commonceService.getCommonCdListNew("D011"); //상태
				model.addAttribute("statCdList", util.mapToJson(statCdList));	
				
				List<?> mfcBizrList = commonceService.mfc_bizrnm_select(request); // 생산자
				model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	
				
				List<?> whsdlBizrList = commonceService.mfc_bizrnm_select4(request, map); // 도매업자
				model.addAttribute("whsdlBizrList", util.mapToJson(whsdlBizrList));	
				
				List<?> ctnrNmList = commonceService.ctnr_nm_select2(request, map); //빈용기명
				model.addAttribute("ctnrNmList", util.mapToJson(ctnrNmList));	
				
				List<?> mfcBrchList = commonceService.brch_nm_select(request, map); //직매장
				model.addAttribute("mfcBrchList", util.mapToJson(mfcBrchList));
			} catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
						
			return model;    	
	    }

	  /**
	   * 상세출고현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epmf6104901_select2(Map<String, String> data,HttpServletRequest request) {

	  		HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			data.put("BIZRID", vo.getBIZRID());  					
			data.put("BIZRNO", vo.getBIZRNO_ORI());  
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("S_BRCH_ID", vo.getBRCH_ID());  					
				data.put("S_BRCH_NO", vo.getBRCH_NO()); 
			}
			
			String BRCH_ID_NO = data.get("MFC_BRCH_NM");
			if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
				data.put("BRCH_ID", BRCH_ID_NO.split(";")[0]);
				data.put("BRCH_NO", BRCH_ID_NO.split(";")[1]);
			}
			
			String CUST_BIZRID_NO = data.get("WHSDL_BIZRNM");
			if(CUST_BIZRID_NO != null && !CUST_BIZRID_NO.equals("")){
				data.put("CUST_BIZRID", CUST_BIZRID_NO.split(";")[0]);
				data.put("CUST_BIZRNO", CUST_BIZRID_NO.split(";")[1]);
			}
			
			HashMap<String, Object> map = new HashMap<String, Object>();

			try {
				List<?> list = epmf6104901Mapper.epmf6104901_select(data);
				map.put("searchList", util.mapToJson(list));
				
				if(data.get("CHART_YN") != null && data.get("CHART_YN").equals("Y")){
					List<?> list2 = epmf6104901Mapper.epmf6104901_select2(data);
					map.put("searchList2", util.mapToJson(list2));
				}
				map.put("totalList", epmf6104901Mapper.epmf6104901_select_cnt(data));
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
		 * 생산자변경시 생산자에맞는 빈용기명, 직매장, 업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf6104901_select3(Map<String, String> inputMap, HttpServletRequest request) {
			
	    		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		
	      		
	    		try {
	    			rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));   // 도매업자 업체명조회
		    		rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap)));	  //빈용기
					rtnMap.put("mfcBrchList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  //직매장
	    		
	      		return rtnMap;    	
	    }
		
		/**
		 * 상세출고현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epmf6104901_excel(HashMap<String, String> data, HttpServletRequest request) throws Exception {
			
			String errCd = "0000";

			try {
				
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				data.put("BIZRID", vo.getBIZRID());  					
				data.put("BIZRNO", vo.getBIZRNO_ORI());  
				if(!vo.getBRCH_NO().equals("9999999999")){
					data.put("S_BRCH_ID", vo.getBRCH_ID());  					
					data.put("S_BRCH_NO", vo.getBRCH_NO()); 
				}
				
				String BRCH_ID_NO = data.get("MFC_BRCH_NM");
				if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
					data.put("BRCH_ID", BRCH_ID_NO.split(";")[0]);
					data.put("BRCH_NO", BRCH_ID_NO.split(";")[1]);
				}
				
				String CUST_BIZRID_NO = data.get("WHSDL_BIZRNM");
				if(CUST_BIZRID_NO != null && !CUST_BIZRID_NO.equals("")){
					data.put("CUST_BIZRID", CUST_BIZRID_NO.split(";")[0]);
					data.put("CUST_BIZRNO", CUST_BIZRID_NO.split(";")[1]);
				}
				
				data.put("excelYn", "Y");
				List<?> list = epmf6104901Mapper.epmf6104901_select(data);

				//엑셀파일 저장
				commonceService.excelSave(request, data, list);

			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}
}
