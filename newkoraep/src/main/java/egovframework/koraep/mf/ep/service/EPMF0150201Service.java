package egovframework.koraep.mf.ep.service;

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
import egovframework.mapper.mf.ep.EPMF0150201Mapper;

/**
 * 직매장/공장관리 Service
 * @author 양성수
 *
 */
@Service("epmf0150201Service")
public class EPMF0150201Service {
	
	
	@Resource(name="epmf0150201Mapper")
	private EPMF0150201Mapper epmf0150201Mapper;  //직매장/공장관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 직매장/공장관리 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf0150201_select(ModelMap model, HttpServletRequest request) {
		  
		  try {
			  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map	= new HashMap<String, String>();
			List<?> mfc_bizrnmList 		= commonceService.mfc_bizrnm_select(request); 	 				//생산자
			List<?> stat_cd_list				= epmf0150201Mapper.epmf0150201_select3();			//활동 비활동
			List<?> area_cd_list				= commonceService.getCommonCdListNew("B010");		//지역
			List<?> pay_exec_yn			= commonceService.getCommonCdListNew("S014");		//지급실행여부
			String   title							= commonceService.getMenuTitle("EPMF0150201");		//타이틀
			model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
			model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));	
			model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
			model.addAttribute("pay_exec_yn_list", util.mapToJson(pay_exec_yn));	
			model.addAttribute("titleSub", title);
			
			
			Map<String, String> paramMap = new HashMap<String, String>();
			if(jParams.get("SEL_PARAMS") !=null){
				JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
				if(param2.get("BIZRNO") !=null){
					paramMap.put("BIZRNO", param2.get("BIZRNO").toString());					
					paramMap.put("BIZRID", param2.get("BIZRID").toString());						
					List<?> grp_brch_no_list = commonceService.grp_brch_no_select(paramMap);	//총괄직매장
					model.addAttribute("grp_brch_no_list", util.mapToJson(grp_brch_no_list));	
				}
			}
			
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
		 * 직매장/공장관리 등록 초기화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epmf0150231_select(ModelMap model, HttpServletRequest request) {

			  try {
				  	//파라메터 정보
					String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
					JSONObject jParams = JSONObject.fromObject(reqParams);
					model.addAttribute("INQ_PARAMS",jParams);
					
					HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("PARAMS"));

					Map<String, String> map	= new HashMap<String, String>();
					List<?> mfc_bizrnmList 	= commonceService.mfc_bizrnm_select(request); 	 				//생산자
					List<?> area_cd_list		= commonceService.getCommonCdListNew("B010");		//지역
					List<?> BankCdList 		= commonceService.getCommonCdListNew("S090");		//은행리스트
					String   title					= commonceService.getMenuTitle("EPMF0150231");		//타이틀
					model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
					model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
					model.addAttribute("BankCdList", util.mapToJson(BankCdList));
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
		  
		  /**
			 * 직매장/공장관리 변경 초기화면
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			  public ModelMap epmf0150242_select(ModelMap model, HttpServletRequest request) {

				  try {
					  	//파라메터 정보
						String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
						JSONObject jParams = JSONObject.fromObject(reqParams);
						model.addAttribute("INQ_PARAMS",jParams);
					    
						HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("PARAMS"));
						
						if(jmap != null){
							
							HashMap<String, String> map = (HashMap<String, String>)epmf0150201Mapper.epmf0150231_select2(jmap);
							
							if(map.get("ASTN_EMAIL") != null){
								map.put("EMAIL1", map.get("ASTN_EMAIL").split("@")[0]);
								map.put("EMAIL2", map.get("ASTN_EMAIL").split("@")[1]);
							}
							
							if(("M1").equals(map.get("BIZRID").substring(0,2))) {
								if(map.get("BRCH_BIZRNO") != null){
									map.put("BIZRNO1", map.get("BRCH_BIZRNO").substring(0, 3));
									map.put("BIZRNO2", map.get("BRCH_BIZRNO").substring(3, 5));
									map.put("BIZRNO3", map.get("BRCH_BIZRNO").substring(5));
								}
								else {
									map.put("BIZRNO1", "");
									map.put("BIZRNO2", "");
									map.put("BIZRNO3", "");
								}
							}
							else {
								map.put("BIZRNO1", "");
								map.put("BIZRNO2", "");
								map.put("BIZRNO3", "");
							}
							
							model.addAttribute("searchDtl", util.mapToJson(map));	
						}else{
							model.addAttribute("searchDtl", "[]");	
						}
						
						List<?> area_cd_list = commonceService.getCommonCdListNew("B010"); //지역
						String  title = commonceService.getMenuTitle("EPMF0150242"); //타이틀	
						model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
						model.addAttribute("titleSub", title);
						
						List<?> BankCdList = commonceService.getCommonCdListNew("S090"); //은행리스트
						model.addAttribute("BankCdList", util.mapToJson(BankCdList));
						
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
		 *	생산자명 변경시 총괄직매장
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf0150201_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      		rtnMap.put("grp_brch_noList", util.mapToJson(commonceService.grp_brch_no_select(inputMap)));  
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
		 * 직매장/공장관리  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epmf0150201_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			inputMap.put("BIZRID", vo.getBIZRID());  					
			inputMap.put("BIZRNO", vo.getBIZRNO_ORI());  
			if(!vo.getBRCH_NO().equals("9999999999")){
				inputMap.put("S_BRCH_ID", vo.getBRCH_ID());  					
				inputMap.put("S_BRCH_NO", vo.getBRCH_NO());  
			}
	    	
	    		try {
					rtnMap.put("selList", util.mapToJson(epmf0150201Mapper.epmf0150201_select(inputMap)));
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
	    		rtnMap.put("totalCnt", epmf0150201Mapper.epmf0150201_select_cnt(inputMap));
	    	return rtnMap;    	
	    }
		
		/**
		 * 직매장/공장관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf0150201_excel(HashMap<String, String> data, HttpServletRequest request) {
			
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
				
				List<?> list = epmf0150201Mapper.epmf0150201_select(data);
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
		 * 직매장/공장관리  활동/ 비활동
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epmf0150201_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						int stat = epmf0150201Mapper.epmf0150201_select2(map); //상태 체크
						 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 map.put("REG_PRSN_ID", vo.getUSER_ID());  				//등록자
						 epmf0150201Mapper.epmf0150201_update(map); 		//상태변경
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

/***************************************************************************************************************************************************************************************
 * 		직매장/공장관리 저장/ 수정
 ****************************************************************************************************************************************************************************************/
		/**
		 * 직매장구분 변경시
		 * @param model
		 * @param request
		 * @return
		 * @
		 */
		public HashMap<String, Object> epmf0150231_select(Map<String, String> data) {
			
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
				map.put("grpList", util.mapToJson(epmf0150201Mapper.epmf0150231_select(data)));
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
		 * 직매장 등록
		 * @param map
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epmf0150231_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
			
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
					
					int ck = epmf0150201Mapper.epmf0150231_select3(data);
					if(ck > 0){
						throw new Exception("B007"); //중복
					}
					
					if(data.get("PAY_EXEC_YN").equals("Y")){ //지급실행
						int ck2 = epmf0150201Mapper.epmf0150231_select4(data);
						if(ck2 > 0){
							throw new Exception("B008"); //중복
						}
						
						//ERP사업자코드 채번
						String erpBizrCd = "2" + commonceService.psnb_select("S0002"); 
						data.put("ERP_BIZR_CD", erpBizrCd); //ERP사업자코드
						
						epmf0150201Mapper.epmf0150231_insert2(data);	//사업자정보 등록 처리
					}
					
					String psnbSeq = commonceService.psnb_select("S0007"); //지점ID 일련번호 채번
					data.put("PSNB_SEQ", psnbSeq);
					
					if(data.get("GRP_YN").equals("Y")){
						data.put("GRP_BRCH_NO", "");
					}
					
					epmf0150201Mapper.epmf0150231_insert(data);	//등록 처리
					
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				if(e.getMessage().equals("B007") || e.getMessage().equals("B008") ){
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
		public String epmf0150242_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
			
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
										
					epmf0150201Mapper.epmf0150242_update(data);	//수정
					
					if(data.get("PAY_EXEC_YN").equals("Y")){ //지급실행
						
						if(data.get("BRCH_NM_CHANGE_YN").equals("Y")){
							//ERP사업자코드 채번
							String erpBizrCd = "2" + commonceService.psnb_select("S0002"); 
							data.put("ERP_BIZR_CD", erpBizrCd); //ERP사업자코드
						}
						
						epmf0150201Mapper.epmf0150242_update2(data);	//사업자정보 변경
					}else{
						epmf0150201Mapper.epmf0150242_update3(data);	//사업자정보 비활성화
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
		  public ModelMap epmf0150288_select(ModelMap model, HttpServletRequest request) {
			  
			  try {
					List<?> area_cd_list			= commonceService.getCommonCdListNew("B010");		//지역
					String   title						= commonceService.getMenuTitle("EPMF0150288");		//타이틀
					model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
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
		
		  /**
			 * 지역 일괄 설정 저장
			 * @param inputMap
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
			public String epmf0150288_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
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
							epmf0150201Mapper.epmf0150288_update(map); 		//상태변경
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

	/**
	 * 사업자번호 중복체크
	 * @param model
	 * @param request
	 * @
	 */

	public String epmf0150231_3_check(HashMap<String, String> data) {
		String rtn = "Y";
		
		if(data.get("BIZRID_NO") != null && !data.get("BIZRID_NO").equals("")){
			String[] BIZR_CD = data.get("BIZRID_NO").split(";");
			data.put("BIZRID", BIZR_CD[0]);
			data.put("BIZRNO", BIZR_CD[1]);
		}
		
		int cnt = epmf0150201Mapper.epmf0150231_select3(data);
		if(cnt > 0) rtn = "N";
		
		return rtn;
	}
}