package egovframework.koraep.wh.ep.service;

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
import egovframework.mapper.wh.ep.EPWH6172401Mapper;

/**
 * 신구병 통계현황 Service
 * @author 이내희
 *
 */
@Service("epwh6172401Service")
public class EPWH6172401Service {  
	
	
	@Resource(name="epwh6172401Mapper")
	private EPWH6172401Mapper epwh6172401Mapper;  //신구병 통계현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 신구병 통계현황 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh6172401_select(ModelMap model, HttpServletRequest request) {
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); //생산자
			List<?> whsl_se_cdList = commonceService.whsdl_se_select(request, map); //도매업자구분
			List<?> areaList = commonceService.getCommonCdListNew("B010"); //지역
			List<?> ctnrUseYn = commonceService.getCommonCdListNew("S140");
			List<?> ctnrSe = commonceService.getCommonCdListNew("E005"); //빈용기구분 구/신
			List<?> prpsCd = commonceService.getCommonCdListNew("E002"); //빈용기구분 가정/유흥/반환
			

			//List<?> whsdlList = commonceService.mfc_bizrnm_select4(request, map); // 생산자랑 거래중인 도매업자 업체명조회

			try {

				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
				model.addAttribute("areaList", util.mapToJson(areaList));
				model.addAttribute("ctnrUseYn", util.mapToJson(ctnrUseYn));
				model.addAttribute("ctnrSe", util.mapToJson(ctnrSe));
				model.addAttribute("prpsCd", util.mapToJson(prpsCd));
				
				//model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
				
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
		 * 신구병 통계현황 - 생산자 초기화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epwh61724012_select(ModelMap model, HttpServletRequest request) {
			  
				model.addAttribute("titleSub", commonceService.getMenuTitle("EPWH61724012")); //타이틀
			  
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				model.addAttribute("INQ_PARAMS",jParams);
			    
				List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); //생산자
				List<?> ctnrSe = commonceService.getCommonCdListNew("E005"); //빈용기구분 구/신
				List<?> prpsCd = commonceService.getCommonCdListNew("E002"); //빈용기구분 가정/유흥/반환

				try {

					model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
					model.addAttribute("ctnrSe", util.mapToJson(ctnrSe));
					model.addAttribute("prpsCd", util.mapToJson(prpsCd));

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
	 * 신구병 통계현황 - 상세정보 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh6172442_select(ModelMap model, HttpServletRequest request) {
		  
		  	Map<String, String> map = new HashMap<String, String>();
			model.addAttribute("titleSub", commonceService.getMenuTitle("EPWH6172442")); //타이틀
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		    
			List<?> ctnrUseYn = commonceService.getCommonCdListNew("S140");
			HashMap<?, ?> searchDtl = epwh6172401Mapper.epwh6172442_select(param);

			try {

				model.addAttribute("ctnrUseYn", util.mapToJson(ctnrUseYn));
				model.addAttribute("searchDtl", util.mapToJson(searchDtl));

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
		 * 상세정보 변경
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epwh6172442_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String errCd = "0000";
			String sUserId = "";
			if(vo != null){
				sUserId = vo.getUSER_ID();
			}
			
			JSONObject jparams = JSONObject.fromObject(inputMap.get("PARAMS"));
			HashMap<String, String> jmap = util.jsonToMap(jparams);
			
			jmap.put("APLC_GBN", String.valueOf(inputMap.get("APLC_GBN")));
			jmap.put("CAP_USE_YN", String.valueOf(inputMap.get("CAP_USE_YN")));
			jmap.put("S_USER_ID", sUserId);
			
			//수정처리
			epwh6172401Mapper.epwh6172442_update(jmap);
			
			return errCd;
		}
	  
	  /**
	   * 신구병 통계현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epwh6172401_select2(Map<String, String> data, HttpServletRequest request) {

			HashMap<String, Object> map = new HashMap<String, Object>();
			
			String BIZRID_NO = data.get("MFC_BIZRNM");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
				data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
			}
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			data.put("WHSDL_BIZRID", vo.getBIZRID());  					
			data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());  	
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("WHSDL_BRCH_ID", vo.getBRCH_ID());  				// 지점ID
				data.put("WHSDL_BRCH_NO", vo.getBRCH_NO());  			// 지점번호
			}
			
			try {
				map.put("searchList", util.mapToJson(epwh6172401Mapper.epwh6172401_select(data)));
				map.put("totalList", util.mapToJson(epwh6172401Mapper.epwh6172401_select_cnt(data)));
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
  	 * 엑셀
  	 * @param map
  	 * @param request
  	 * @return
  	 * @
  	 */
  	public String epwh6172401_excel(HashMap<String, String> data, HttpServletRequest request) {
  		
  		String errCd = "0000";

  		String BIZRID_NO = data.get("MFC_BIZRNM");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
			data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		data.put("WHSDL_BIZRID", vo.getBIZRID());  					
		data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());  	
		if(!vo.getBRCH_NO().equals("9999999999")){
			data.put("WHSDL_BRCH_ID", vo.getBRCH_ID());  				// 지점ID
			data.put("WHSDL_BRCH_NO", vo.getBRCH_NO());  			// 지점번호
		}
  		
  		try {
  			
  			data.put("excelYn", "Y");
  			List<?> list = epwh6172401Mapper.epwh6172401_select(data);

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
	  
  	
  	/**
	   * 신구병 통계현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
	  public HashMap<String, Object> epwh61724012_select2(Map<String, String> data, HttpServletRequest request) {

			HashMap<String, Object> map = new HashMap<String, Object>();
			
			String BIZRID_NO = data.get("MFC_BIZRNM");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
				data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
			}
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			data.put("WHSDL_BIZRID", vo.getBIZRID());  					
			data.put("WHSDL_BIZRNO", vo.getBIZRNO_ORI());  	
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("WHSDL_BRCH_ID", vo.getBRCH_ID());  				// 지점ID
				data.put("WHSDL_BRCH_NO", vo.getBRCH_NO());  			// 지점번호
			}
			
			try {
				map.put("searchList", util.mapToJson(epwh6172401Mapper.epwh61724012_select(data)));
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
	 * 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epwh61724012_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		String BIZRID_NO = data.get("MFC_BIZRNM");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
			data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		try {
			
			data.put("excelYn", "Y");
			List<?> list = epwh6172401Mapper.epwh61724012_select(data);

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
	
	/**
	 * 반환량조정 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh6172488_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPWH6172488");
		model.addAttribute("titleSub", title);

		return model;
	}
	
	/**
	 * 반환량조정 변경
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epwh6172488_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		String sUserId = "";
		if(vo != null){
			sUserId = vo.getUSER_ID();
		}
		
		JSONObject jparams = JSONObject.fromObject(inputMap.get("PARAMS"));
		HashMap<String, String> jmap = util.jsonToMap(jparams);
		
		jmap.put("RTN_REVI_QTY", String.valueOf(inputMap.get("RTN_REVI_QTY")));
		jmap.put("S_USER_ID", sUserId);
		
		//수정처리
		epwh6172401Mapper.epwh6172488_update(jmap);
		
		return errCd;
	}
}
