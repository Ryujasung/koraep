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
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE4704201Mapper;

/**
 * 입고정정확인 Service
 * @author 양성수
 *
 */
@Service("epce4704201Service")
public class EPCE4704201Service {
	
	
	@Resource(name="epce4704201Mapper")
	private EPCE4704201Mapper epce4704201Mapper;  //입고정정 확인 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 입고정정 확인 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce4704201_select(ModelMap model, HttpServletRequest request) {
		  
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
					model.addAttribute("titleSub", commonceService.getMenuTitle("EPCE4704201"));								//타이틀
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
		public HashMap epce4704201_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		      		inputMap.put("BIZR_TP_CD", "");
		      		rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));
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
		public HashMap epce4704201_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
						rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));
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
		public HashMap epce4704201_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
		    			List<?> list = JSONArray.fromObject(inputMap.get("MFC_BIZRNM_RETURN"));
		    			System.out.println("hahaha");
		    			inputMap.put("MFC_BIZRNM_RETURN", list);  
		    			System.out.println(inputMap);
						rtnMap.put("selList", util.mapToJson(epce4704201Mapper.epce4704201_select4  (inputMap)));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  
	    		rtnMap.put("totalList", epce4704201Mapper.epce4704201_select4_cnt(inputMap));
	    	return rtnMap;    	
	    }
		
		/**
		 * 입고정정 확인 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce4704201_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
						
				List<?> select_list = JSONArray.fromObject(data.get("MFC_BIZRNM_RETURN"));
				data.put("MFC_BIZRNM_RETURN", select_list);  
				List<?> list = epce4704201Mapper.epce4704201_select4(data);
				
				//object라 String으로 담아서 보내기
				HashMap<String, String> map = new HashMap<String, String>(); 
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
		 * 입고정정 확인  상호확인 
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce4704201_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
	
			
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						int stat = epce4704201Mapper.epce4704201_select5(map); //상태 체크
						 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 map.put("REG_PRSN_ID", vo.getUSER_ID());  					//등록자
						 epce4704201Mapper.epce4704201_update(map); 		// 반환내역서  입고정정 확인이전 상태로 변화
					}
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
}
