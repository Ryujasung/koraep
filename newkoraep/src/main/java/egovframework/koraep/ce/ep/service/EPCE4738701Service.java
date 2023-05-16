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
import egovframework.mapper.ce.ep.EPCE4738701Mapper;

/**
 * 입고정정 Service
 * @author 양성수
 *
 */
@Service("epce4738701Service")
public class EPCE4738701Service {
	
	@Resource(name="epce4738701Mapper")
	private EPCE4738701Mapper epce4738701Mapper;  //입고정정  Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 입고정정  초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	 public ModelMap epce4738701_select(ModelMap model, HttpServletRequest request) {
		  
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
						}
						
						model.addAttribute("std_mgnt_list", util.mapToJson(commonceService.std_mgnt_select(request, map)));  		//정산기준관리 조회
						model.addAttribute("stat_cdList", util.mapToJson(commonceService.getCommonCdListNew("C002")));//상태
						model.addAttribute("whsl_se_cdList", util.mapToJson(commonceService.whsdl_se_select(request, map)));  		//도매업자 구분
						model.addAttribute("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, map)));			//도매업자 업체명조회	
						model.addAttribute("titleSub", commonceService.getMenuTitle("EPCE4738701"));							//타이틀;
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	
				return model;    	
	    }
	  
	  /**
		 * 입고정정 정산기준날짜 변경시 생산자 리스트
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce4738701_select5(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
	    		
	    		if(inputMap.get("EXCA_TRGT_SE").equals("W")	){
					rtnMap.put("mfc_bizrnmList", util.mapToJson(commonceService.mfc_bizrnm_select(request))); //모든 생산자
	    		}else{	
	    			rtnMap.put("mfc_bizrnmList", util.mapToJson(commonceService.std_mgnt_mfc_select(request, inputMap))); 
	    		}
					
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 
			return rtnMap;    	
	    }
	  
		/**
		 * 입고정정 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce4738701_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
			      	rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));   //도매업자 업체명조회
			      	inputMap.put("BIZR_TP_CD", "");
			      	rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 //사업자 직매장/공장 조회	
			return rtnMap;    	
	    }
	  
		/**
		 * 입고정정  생산자 직매장/공장 선택시  업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce4738701_select3(Map<String, String> inputMap, HttpServletRequest request) {
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
		 * 입고정정 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce4738701_select4(Map<String, Object> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
	    			System.out.println("GKGKGK"+inputMap);
	    			List<?> list = JSONArray.fromObject(inputMap.get("MFC_BIZRNM_RETURN"));
	    			inputMap.put("MFC_BIZRNM_RETURN", list);  
					rtnMap.put("selList", util.mapToJson(epce4738701Mapper.epce4738701_select4(inputMap)));
					rtnMap.put("totalList", epce4738701Mapper.epce4738701_select4_cnt(inputMap));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  
	    	return rtnMap;    	
	    }
		
		/**
		 * 입고정정 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce4738701_excel(HashMap<String, Object> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
						
				List<?> list2 = JSONArray.fromObject(data.get("MFC_BIZRNM_RETURN"));
    			data.put("MFC_BIZRNM_RETURN", list2);  
    			
				List<?> list = epce4738701Mapper.epce4738701_select4(data);
				
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
		 * 입고정정  입고정정  정정확인,정정반려,확인취소 상태 변경
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce4738701_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						int stat = epce4738701Mapper.epce4738701_select5(map); //상태 체크
						 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 map.put("REG_PRSN_ID", vo.getUSER_ID());  		//등록자
						 epce4738701Mapper.epce4738701_update(map);//입고정정  정정확인,정정반려,확인취소 상태 변경
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
	
		//---------------------------------------------------------------------------------------------------------------------
		//	입고정정 내역조회
		//---------------------------------------------------------------------------------------------------------------------
					
		/**
		 * 입고관리 상세조회 초기 화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce4738764_select(ModelMap model, HttpServletRequest request) {

			  	HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				String ssUserNm = "";   //사용자명
				String ssBizrNm = "";   //부서명

				if(vo != null){
					ssUserNm = vo.getUSER_NM();
					ssBizrNm = vo.getBIZRNM();
				}

				model.addAttribute("ssUserNm", ssUserNm);
				model.addAttribute("ssBizrNm", ssBizrNm);

			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				
				String   title					= commonceService.getMenuTitle("EPCE4738764");		//타이틀
				List<?> iniList				= epce4738701Mapper.epce4738764_select(map);		//상세내역 조회
				List<?> cfm_gridList		= epce4738701Mapper.epce4738764_select2(map);		//입고 그리드쪽 조회
				List<?> crct_gridList		= epce4738701Mapper.epce4738764_select3(map);		//입고정정 그리드쪽 조회
				
				try {
					model.addAttribute("INQ_PARAMS",jParams);
					model.addAttribute("iniList", util.mapToJson(iniList));	
					model.addAttribute("cfm_gridList", util.mapToJson(cfm_gridList));	
					model.addAttribute("crct_gridList", util.mapToJson(crct_gridList));
					model.addAttribute("titleSub", title);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	
				return model;    	
		    }
		  
		  /**
			 * 입고정정내역조회 삭제
			 * @param inputMap
			 * @param request
			 * @return
		 * @throws Exception 
			 * @
			 */
			public String epce4738764_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
				
				String errCd = "0000";
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
		
				try {
					 int stat = epce4738701Mapper.epce4738701_select5(inputMap); //상태 체크
					 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					 }
					 
					 inputMap.put("UPD_PRSN_ID", vo.getUSER_ID());
					epce4738701Mapper.epce4738764_delete(inputMap); 	// 입고정정테이블 삭제
					epce4738701Mapper.epce4738764_update(inputMap); 	// 입고관리마스터 정정문서번호 삭제
				}catch(Exception e){
					if(e.getMessage().equals("A012") ){
						 throw new Exception(e.getMessage()); 
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
				return errCd;
				
		    }
			
			
	/**
	 * 입고정정 정산기준날짜 변경시 생산자 리스트
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce4738701_select6(Map<String, String> inputMap, HttpServletRequest request) throws Exception {

		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		
		if (list != null) {
			try {
				map = (Map<String, String>) list.get(0);
				
				int stat = epce4738701Mapper.epce4738701_select6(map); //상태 체크
				
				if(stat>0){
					throw new Exception("A025"); // 종료상태의 정산기간에서만 이월처리 가능합니다.
				}
				
				List<?> excalist = epce4738701Mapper.epce4738701_select7(map);
				
				if(null == excalist || excalist.size() == 0) {
					throw new Exception("A026"); // 이월가능한 정산기간이 없습니다. 진행상태의 정산기간으로만 이월처리 가능합니다.
				}
				
				Map<String, String> excaMap = (Map<String, String>) excalist.get(0);
				
				rtnMap.put("EXCA_STD_NM",excaMap.get("EXCA_STD_NM"));
				rtnMap.put("EXCA_STD_CD",excaMap.get("EXCA_STD_CD"));
				
			}catch (Exception e) {
				if(("A025").equals(e.getMessage()) || ("A026").equals(e.getMessage())){
					 throw new Exception(e.getMessage()); 
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}

		return rtnMap;    	
    }
	
	/**
	 * 입고정정이월처리
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce4738701_update2(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		
		if (list != null) {
			try {
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					map.put("REG_PRSN_ID", vo.getUSER_ID());  		//등록자
					epce4738701Mapper.epce4738701_update2(map);//입고정정  정정확인,정정반려,확인취소 상태 변경
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
