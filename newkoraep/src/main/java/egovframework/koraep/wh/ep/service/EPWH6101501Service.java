package egovframework.koraep.wh.ep.service;

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
import egovframework.mapper.wh.ep.EPWH6101501Mapper;

/**
 * 출고현황 Service
 * @author 이내희
 *
 */
@Service("epwh6101501Service")
public class EPWH6101501Service {  
	
	@Resource(name="epwh6101501Mapper")
	private EPWH6101501Mapper epwh6101501Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 출고현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh6101501_select(ModelMap model, HttpServletRequest request) {

		    Map<String, String> map = new HashMap<String, String>();
		  
			
			try {
				List<?> prpsCdList	 = commonceService.getCommonCdListNew("E002"); //용도
				model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));	
				
				List<?> mfcBizrList = commonceService.mfc_bizrnm_select(request); // 생산자
				model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	
				
				List<?> whsdlBizrList = commonceService.mfc_bizrnm_select4(request, map); // 도매업자
				model.addAttribute("whsdlBizrList", util.mapToJson(whsdlBizrList));	
				
				List<?> ctnrNmList = commonceService.ctnr_nm_select2(request, map); //빈용기명
				model.addAttribute("ctnrNmList", util.mapToJson(ctnrNmList));
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
	   * 출고현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epwh6101501_select2(Map<String, String> data,HttpServletRequest request) {

  		  	String BIZRID_NO = data.get("MFC_BIZRNM");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("BIZRID", BIZRID_NO.split(";")[0]);
				data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			data.put("CUST_BIZRID", vo.getBIZRID());  					
			data.put("CUST_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("CUST_BRCH_ID", vo.getBRCH_ID());  					
				data.put("CUST_BRCH_NO", vo.getBRCH_NO());
			}
			
			HashMap<String, Object> map = new HashMap<String, Object>();

			try {
				List<?> list = epwh6101501Mapper.epwh6101501_select(data);
				map.put("searchList", util.mapToJson(list));
				
				if(data.get("CHART_YN") != null && data.get("CHART_YN").equals("Y")){
					List<?> list2 = epwh6101501Mapper.epwh6101501_select2(data);
					map.put("searchList2", util.mapToJson(list2));
				}
				map.put("totalList", epwh6101501Mapper.epwh6101501_select_cnt(data));
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
	 * 생산자변경시  생산자에맞는 빈용기명, 업체명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epwh6101501_select3(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
      		
    		try {
    			rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));   // 도매업자 업체명조회
				rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap)));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  //빈용기
      		return rtnMap;    	
    }
	
	/**
	 * 용도 변경시  빈용기명 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epwh6101501_select4(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    		try {
				rtnMap.put("ctnr_cd", util.mapToJson(commonceService.ctnr_nm_select2(request, inputMap)));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	  //빈용기
      		return rtnMap;    	
    }
	
	/**
	 * 출고현황 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epwh6101501_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";
		
		try {
			
			String BIZRID_NO = data.get("MFC_BIZRNM");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("BIZRID", BIZRID_NO.split(";")[0]);
				data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			data.put("CUST_BIZRID", vo.getBIZRID());  					
			data.put("CUST_BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("CUST_BRCH_ID", vo.getBRCH_ID());  					
				data.put("CUST_BRCH_NO", vo.getBRCH_NO());
			}
			
			data.put("excelYn", "Y");
			List<?> list = epwh6101501Mapper.epwh6101501_select(data);

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
