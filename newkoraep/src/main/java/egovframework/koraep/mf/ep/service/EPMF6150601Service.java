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
import egovframework.mapper.mf.ep.EPMF6150601Mapper;

/**
 * 직접회수현황 Service
 * @author 이내희
 *
 */
@Service("epmf6150601Service")
public class EPMF6150601Service {  
	
	@Resource(name="epmf6150601Mapper")
	private EPMF6150601Mapper epmf6150601Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 직접회수현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf6150601_select(ModelMap model, HttpServletRequest request) {
		  
		  Map<String, String> map = new HashMap<String, String>();
		  
			try {
				List<?> statCdList	 = commonceService.getCommonCdListNew("D012"); //상태
				model.addAttribute("statCdList", util.mapToJson(statCdList));	
				
				List<?> mfcBizrList = commonceService.mfc_bizrnm_select(request); // 생산자
				model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	

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
	   * 직접회수현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epmf6150601_select2(Map<String, String> data, HttpServletRequest request) {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
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
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			try {
				List<?> list = epmf6150601Mapper.epmf6150601_select(data);
				map.put("searchList", util.mapToJson(list));
				
				if(data.get("CHART_YN") != null && data.get("CHART_YN").equals("Y")){
					List<?> list2 = epmf6150601Mapper.epmf6150601_select2(data);
					map.put("searchList2", util.mapToJson(list2));
				}
				map.put("totalList", epmf6150601Mapper.epmf6150601_select_cnt(data));
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
		 * 생산자변경시 생산자에맞는 빈용기명, 직매장 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf6150601_select3(Map<String, String> inputMap, HttpServletRequest request) {
			
	    		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		
	    		
	    		try {
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
		 * 직접회수현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf6150601_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
				
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
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
				
				data.put("excelYn", "Y");
				List<?> list = epmf6150601Mapper.epmf6150601_select(data);

				//엑셀파일 저장
				commonceService.excelSave(request, data, list);

			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}
}
