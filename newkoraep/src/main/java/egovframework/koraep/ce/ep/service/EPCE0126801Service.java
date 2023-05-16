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
import egovframework.mapper.ce.ep.EPCE0126801Mapper;

/**
 * 소매 직매장/공장관리 Service
 * @author 양성수
 *
 */
@Service("epce0126801Service")
public class EPCE0126801Service {
	
	
	@Resource(name="epce0126801Mapper")
	private EPCE0126801Mapper epce0126801Mapper;  //직매장/공장관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 소매 직매장/공장관리 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0126801_select(ModelMap model, HttpServletRequest request) {
		  
		  try {
			  
				  	//파라메터 정보
					String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
					JSONObject jParams = JSONObject.fromObject(reqParams);
					model.addAttribute("INQ_PARAMS",jParams);
				    
					Map<String, String> map	= new HashMap<String, String>();
					
					
					map.put("ETC_CD",  "RTL");//소매구분
					List<?> whsl_se_cdList			= commonceService.whsdl_se_select(request, map);  		 		//소매업자구분
					//List<?> whsdlList 				= commonceService.rtl_select(map);    						//소매업자 업체명조회
					//
					List<?> aff_ogn_cd_list			= commonceService.getCommonCdListNew("B004");		//소속단체
					List<?> stat_cd_list				= epce0126801Mapper.epce0126801_select3();			//상태 활동 비활동
					List<?> area_cd_list				= commonceService.getCommonCdListNew("B010");		//지역
					List<?> acp_mgnt_yn_list		= commonceService.getCommonCdListNew("S015");		//수납관리여부
					String   title							= commonceService.getMenuTitle("EPCE0126801");		//타이틀
					model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
	//				model.addAttribute("whsdlList", util.mapToJson(whsdlList));		
					model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));		
					model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));	
					model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
					model.addAttribute("acp_mgnt_yn_list", util.mapToJson(acp_mgnt_yn_list));	
					model.addAttribute("titleSub", title);
					
					Map<String, String> paramMap = new HashMap<String, String>();
					if(jParams.get("SEL_PARAMS") !=null){
						JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
						if(param2.get("BIZRNO") !=null){
							paramMap.put("BIZRNO", param2.get("BIZRNO").toString());					
							paramMap.put("BIZRID", param2.get("BIZRID").toString());						
							List<?> grp_brch_no_list = commonceService.grp_brch_no_select(paramMap);	//총괄지점
							model.addAttribute("grp_brch_no_list", util.mapToJson(grp_brch_no_list));	
						}
					}
			
			
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	

			return model;    	
	    }
	  
		  /**
			 *	소매업자 조회
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epce0126801_select4(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	try {
			      		rtnMap.put("whsdlList", util.mapToJson(commonceService.rtl_select(inputMap)));  
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	 	 //사업자 직매장/공장 조회	
				return rtnMap;    	
		    }
	  
		/**
		 *	총괄직매장 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0126801_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
		      		rtnMap.put("grp_brch_noList", util.mapToJson(commonceService.grp_brch_no_select(inputMap)));  
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	 //사업자 직매장/공장 조회	
			return rtnMap;    	
	    }
	
		/**
		 * 직매장/공장관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0126801_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
					rtnMap.put("selList", util.mapToJson(epce0126801Mapper.epce0126801_select  (inputMap)));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  
	    		rtnMap.put("totalCnt", epce0126801Mapper.epce0126801_select_cnt(inputMap));
	    	return rtnMap;    	
	    }
		
		/**
		 * 직매장/공장관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce0126801_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";
			try {
						
				List<?> list = epce0126801Mapper.epce0126801_select(data);
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
		}	
		
		/**
		 * 직매장/공장관리  활동/ 비활동
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce0126801_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						int stat = epce0126801Mapper.epce0126801_select2(map); //상태 체크
						 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 map.put("REG_PRSN_ID", vo.getUSER_ID());  				//등록자
						 epce0126801Mapper.epce0126801_update(map); 		//상태변경
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

/***************************************************************************************************************************************************************************************
 * 		직매장/공장관리 저장/ 수정
 ****************************************************************************************************************************************************************************************/
	
  /**
	 * 직매장/공장관리 등록 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0126831_select(ModelMap model, HttpServletRequest request) {

		  try {
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				model.addAttribute("INQ_PARAMS",jParams);
			    
				HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				Map<String, String> map	= new HashMap<String, String>();
				map.put("ETC_CD",  "RTL");//소매구분
				List<?> whsl_se_cdList			= commonceService.whsdl_se_select(request, map);  		 		//소매업자구분
				List<?> aff_ogn_cd_list			= commonceService.getCommonCdListNew("B004");		//소속단체
				List<?> area_cd_list				= commonceService.getCommonCdListNew("B010");		//지역
				List<?> acp_mgnt_yn_list		= commonceService.getCommonCdListNew("S015");		//수납관리여부
				String   title							= commonceService.getMenuTitle("EPCE0126831");		//타이틀
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
				model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));		
				model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
				model.addAttribute("acp_mgnt_yn_list", util.mapToJson(acp_mgnt_yn_list));	
				model.addAttribute("titleSub", title);
				
			//	List<?> whsdlList 				= commonceService.whsdl_select(map);    					//소매업자 업체명조회
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	

			return model;    	
	    }
	  
	  /**
		 * 직매장/공장관리 변경 초기화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce0126842_select(ModelMap model, HttpServletRequest request) {

			  try {
				  	//파라메터 정보
					String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
					JSONObject jParams = JSONObject.fromObject(reqParams);
					model.addAttribute("INQ_PARAMS",jParams);
				    
					HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("PARAMS"));
					
					if(jmap != null){
						model.addAttribute("searchDtl", util.mapToJson(epce0126801Mapper.epce0126831_select2(jmap)));	
					}else{
						model.addAttribute("searchDtl", "[]");	
					}
					
					Map<String, String> map	= new HashMap<String, String>();
					List<?> aff_ogn_cd_list		= commonceService.getCommonCdListNew("B004");		//소속단체
					List<?> area_cd_list			= commonceService.getCommonCdListNew("B010");		//지역
					List<?> acp_mgnt_yn_list	= commonceService.getCommonCdListNew("S015");		//수납관리여부
					String   title						= commonceService.getMenuTitle("EPCE0126842");		//타이틀	
					
					model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));	
					model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
					model.addAttribute("acp_mgnt_yn_list", util.mapToJson(acp_mgnt_yn_list));	
					model.addAttribute("titleSub", title);
					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	

				return model;    	
		    }
		
		/**
		 * 총괄지점 검색
		 * @param model
		 * @param request
		 * @return
		 * @
		 */
		public HashMap<String, Object> epce0126831_select(Map<String, String> data) {
			
			if(data.get("BIZRID_NO") != null && !data.get("BIZRID_NO").equals("")){
				String[] BIZR_CD = data.get("BIZRID_NO").split(";");
				data.put("BIZRID", BIZR_CD[0]);
				data.put("BIZRNO", BIZR_CD[1]);
			}else{
				data.put("BIZRID", "");
				data.put("BIZRNO", "");
			}

			HashMap<String, Object> map = new HashMap<String, Object>();
			try {
				map.put("grpList", util.mapToJson(epce0126801Mapper.epce0126831_select(data)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			
			return map;
		}
		
		/**
		 * 직매장 등록
		 * @param map
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce0126831_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
			
			String errCd = "0000";
			
			try {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO)session.getAttribute("userSession");
					
					data.put("S_USER_ID", "");
					if(vo != null){
						data.put("S_USER_ID", vo.getUSER_ID());
					}
					
					if(data.get("BIZRNM") != null && !data.get("BIZRNM").equals("")){
						String[] BIZR_CD = data.get("BIZRNM").split(";");
						data.put("BIZRID", BIZR_CD[0]);
						data.put("BIZRNO", BIZR_CD[1]);
					}else{
						data.put("BIZRID", "");
						data.put("BIZRNO", "");
					}
					
					int ck = epce0126801Mapper.epce0126831_select3(data);
					if(ck > 0){
						throw new Exception("B007"); //중복체크
					}
					
					String psnbSeq = commonceService.psnb_select("S0007"); //지점ID 일련번호 채번
					data.put("PSNB_SEQ", psnbSeq);
					
					if(data.get("GRP_YN").equals("Y")){
						data.put("GRP_BRCH_NO", "");
					}
					
					epce0126801Mapper.epce0126831_insert(data);	//등록 처리
					
			}catch(Exception e){
				if(e.getMessage().equals("B007") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
			
			return errCd;
		}
		
		/**
		 * 직매장 변경
		 * @param map
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce0126842_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
			
			String errCd = "0000";
			
			try {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO)session.getAttribute("userSession");
					
					data.put("S_USER_ID", "");
					if(vo != null){
						data.put("S_USER_ID", vo.getUSER_ID());
					}
					
					if(data.get("GRP_YN").equals("Y")){
						data.put("GRP_BRCH_NO", "");
					}
										
					epce0126801Mapper.epce0126842_update(data);	//수정
					
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}	
		
		
/***************************************************************************************************************************************************************************************
 * 					지역 일괄 설정
 ****************************************************************************************************************************************************************************************/
		
		/**
		 * 지역 일괄 설정 초기화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce0126888_select(ModelMap model, HttpServletRequest request) {
			  
			  try {
					List<?> area_cd_list			= commonceService.getCommonCdListNew("B010");		//지역
					String   title						= commonceService.getMenuTitle("EPCE0126888");		//타이틀
					model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
					model.addAttribute("titleSub", title);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	
				return model;    	
		    }
		
		  /**
			 * 지역 일괄 설정 저장
			 * @param inputMap
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
			public String epce0126888_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
				String errCd = "0000";
				Map<String, String> map;
				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				if (list != null) {
					try {
						for(int i=0; i<list.size(); i++){
							map = (Map<String, String>) list.get(i);
							map.put("REG_PRSN_ID", vo.getUSER_ID());  					//등록자
							epce0126801Mapper.epce0126888_update(map); 		//상태변경
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

			
/***************************************************************************************************************************************************************************************
 * 					단체 설정
 ****************************************************************************************************************************************************************************************/
	
	/**
	 * 단체 설정 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce01268882_select(ModelMap model, HttpServletRequest request) {
		  
		  try {
				List<?> aff_ogn_cd_list			= commonceService.getCommonCdListNew("B004");		//소속단체
				String   title						= commonceService.getMenuTitle("EPCE01268882");		//타이틀
				model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));	
				model.addAttribute("titleSub", title);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return model;    	
	    }
	
	  /**
		 * 단체 설정 저장
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce01268882_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						map.put("REG_PRSN_ID", vo.getUSER_ID());  					//등록자
						epce0126801Mapper.epce01268882_update(map); 		//상태변경
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
