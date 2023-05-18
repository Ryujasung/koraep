
package egovframework.koraep.wh.ep.service;

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
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH4704201Mapper;

/**
 * 입고정정확인 Service
 * @author 양성수
 *
 */
@Service("epwh4704201Service")
public class EPWH4704201Service {
	
	
	@Resource(name="epwh4704201Mapper")
	private EPWH4704201Mapper epwh4704201Mapper;  //입고정정 확인 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 입고정정 확인 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epwh4704201_select(ModelMap model, HttpServletRequest request) {
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			Map<String, String> map= new HashMap<String, String>();
			//상세 들어갔다가 다시 관리 페이지로 올 경우
			Map<String, String> paramMap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
			try {
					if(jParams.get("SEL_PARAMS") !=null){//상세 볼경우
							if(paramMap.get("EXCA_STD_CD") !=null){//정산기준일자 선택시 생산자 리스트
									if(paramMap.get("EXCA_TRGT_SE").equals("W")	){
										List<?>	mfc_bizrnmList =commonceService.mfc_bizrnm_select(request);//모든생산자
										model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));	
									}else{
										List<?>	mfc_bizrnmList =commonceService.std_mgnt_mfc_select(request, paramMap);	//정산기간중인 생산자
										model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));	
									}
							}
							if(paramMap.get("MFC_BIZRID") !=null){//생산자사업자 선택시
									paramMap.put("BIZRNO", paramMap.get("MFC_BIZRNO"));					//생산자ID
									paramMap.put("BIZRID", paramMap.get("MFC_BIZRID"));						//생산자 사업자번호
									model.addAttribute("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, paramMap)));	
							}
					}//end of if(jParams.get("SEL_PARAMS") !=null)
					model.addAttribute("std_mgnt_list", util.mapToJson(commonceService.std_mgnt_select(request, map)));  			//정산기준관리 조회
					model.addAttribute("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, map)));    			// 도매업자 업체명조회
					model.addAttribute("stat_cdList", util.mapToJson(commonceService.getCommonCdListNew("C002")));	//상태
					model.addAttribute("titleSub", commonceService.getMenuTitle("EPWH4704201"));								//타이틀
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
		 * 입고정정 확인 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh4704201_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		      		inputMap.put("BIZR_TP_CD", "");
		      		rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 //사업자 직매장/공장 조회	
			return rtnMap;    	
	    }
	  
		/**
		 * 입고정정 확인 생산자 직매장/공장 선택시  업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh4704201_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
						rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  //업체명 조회	
			return rtnMap;    	
	    }
	
		/**
		 * 입고정정 확인  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epwh4704201_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
		    			List<?> list = JSONArray.fromObject(inputMap.get("MFC_BIZRNM_RETURN"));
		    			inputMap.put("MFC_BIZRNM_RETURN", list);  
						rtnMap.put("selList", util.mapToJson(epwh4704201Mapper.epwh4704201_select4(inputMap)));
						
						rtnMap.put("totalList", epwh4704201Mapper.epwh4704201_select4_cnt(inputMap));
						
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
	    		
	    	return rtnMap;    	
	    }
		
		/**
		 * 입고정정 확인 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epwh4704201_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
						
				List<?> select_list = JSONArray.fromObject(data.get("MFC_BIZRNM_RETURN"));
				data.put("MFC_BIZRNM_RETURN", select_list);  
				List<?> list = epwh4704201Mapper.epwh4704201_select4(data);
				
				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>(); 
				map.put("fileName", data.get("fileName").toString());
				map.put("columns", data.get("columns").toString());
				//엑셀파일 저장
				commonceService.excelSave(request, map, list);
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
		 * 입고정정 확인  상호확인 
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epwh4704201_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
	
			
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						int stat = epwh4704201Mapper.epwh4704201_select5(map); //상태 체크
						 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 map.put("REG_PRSN_ID", vo.getUSER_ID());  					//등록자
						 epwh4704201Mapper.epwh4704201_update(map); 		// 반환내역서  입고정정 확인이전 상태로 변화
					}
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch (Exception e) {
					if(e.getMessage().equals("A012") ){
						 throw new Exception(e.getMessage()); 
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
			}
			
			return errCd;    	
	    }
		
		//---------------------------------------------------------------------------------------------------------------------
		//	수기입고정정 내역조회
		//---------------------------------------------------------------------------------------------------------------------
					
		/**
		 * 입고관리 상세조회 초기 화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epwh4705664_select(ModelMap model, HttpServletRequest request) {
			  
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				
				String   title		 = commonceService.getMenuTitle("EPWH4705664");		//타이틀
				List<?> iniList		 = epwh4704201Mapper.epwh4705664_select(map);		//상세내역 조회
				List<?> cfm_gridList = null;
				if(map.containsKey("WRHS_CRCT_DOC_NO")){
					cfm_gridList = epwh4704201Mapper.epwh4705664_select2(map);		//입고 그리드쪽 조회
				}
				List<?> crct_gridList = epwh4704201Mapper.epwh4705664_select3(map);		//수기입고정정 그리드쪽 조회
				
				try {
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("iniList", util.mapToJson(iniList));	
					model.addAttribute("cfm_gridList", util.mapToJson(cfm_gridList));	
					model.addAttribute("crct_gridList", util.mapToJson(crct_gridList));
					model.addAttribute("titleSub", title);
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
		
}
