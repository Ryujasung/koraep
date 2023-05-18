package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0198201Mapper;

/**
 * 회수보증금관리 Service
 * @author 양성수
 *
 */
@Service("epce0198201Service")
public class EPCE0198201Service {
	
	@Resource(name="epce0198201Mapper")
	private EPCE0198201Mapper epce0198201Mapper;  //회수보증금관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	
	/**
	 * 회수보증금관리 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0198201_select(ModelMap model, HttpServletRequest request) {
		     
		  
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		 	List<?> initList		=  epce0198201Mapper.epce0198201_select(map);
			String   title			=  commonceService.getMenuTitle("EPCE0198201");

			try {
				model.addAttribute("initList", util.mapToJson(initList));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}     //회수보증금관리  초기 리스트
			model.addAttribute("INQ_PARAMS",jParams);
			model.addAttribute("titleSub", title);
	    	
			return model;    	
	    }
	  
	  /**
		 * 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0198201_select2(Map<String,String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
					rtnMap.put("selList", util.mapToJson(epce0198201Mapper.epce0198201_select  (inputMap))); 
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
		 * 회수보증금관리 삭제
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public String epce0198201_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
			String errCd = "0000";
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			try {
				int sel_rst = epce0198201Mapper.epce0198201_select2(inputMap); //회수보증금관리 삭제여부 가능한지 확인
				if(sel_rst>0){
					throw new Exception("A006"); // 이미 적용 중인 내역은 삭제할 수 없습니다.
				}
				epce0198201Mapper.epce0198201_delete(inputMap); //회수보증금 삭제
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if (e.getMessage().equals("A006")) {
					 throw new Exception(e.getMessage()); 
				} else {
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}	
			return errCd;    	
	    }
		
//*****************************************************************************************************************************************************************
//		회수보증금등록
//*****************************************************************************************************************************************************************
	  
	/**
	 * 회수보증금등록 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0198231_select(ModelMap model, HttpServletRequest request) {
		    
			String reqParams				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
	   		JSONObject jParams			= JSONObject.fromObject(reqParams);
		 	Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		 	List<?> initList					=  epce0198201Mapper.epce0198231_select3(map);
		 	String   title            			=  commonceService.getMenuTitle("EPCE0198231");
		 	
		 	try {
				model.addAttribute("initList", util.mapToJson(initList));
		 		model.addAttribute("INQ_PARAMS", jParams);
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
	 * 회수보증금  저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
		public String epce0198231_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
	
			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				
				int sel_rst = epce0198201Mapper.epce0198231_select(inputMap); //적용기간 중복체크
	
				if(sel_rst>0){
					throw new Exception("A005"); // 적용기간은 중복될 수 없습니다. 다시 한 번 확인해주시기 바랍니다.
				}
				String reg_sn = epce0198201Mapper.epce0198231_select2(inputMap);   //등록순번
				inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
				inputMap.put("REG_SN", reg_sn);
				epce0198201Mapper.epce0198231_insert(inputMap); // 회수보증금 저장
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if (e.getMessage().equals("A005")) {
					 throw new Exception(e.getMessage()); 
				} else {
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}
			return errCd;
		}
		
		
//*****************************************************************************************************************************************************************
//		회수보증금등록
//*****************************************************************************************************************************************************************
		  
		/**
		 * 회수보증금변경 초기값
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce0198242_select(ModelMap model, HttpServletRequest request) {
			  
			  	String reqParams				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		   		JSONObject jParams			= JSONObject.fromObject(reqParams);
		   		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				List<?> initList					=  epce0198201Mapper.epce0198242_select(map);
				String title 						= commonceService.getMenuTitle("EPCE0198242");
				
				try {
						model.addAttribute("initList", util.mapToJson(initList));
						model.addAttribute("titleSub", title);
						model.addAttribute("INQ_PARAMS", jParams);
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
		* 회수보증금 수정
		* @param data
		* @param request
		* @return
		 * @throws Exception 
		* @
		*/
		public String epce0198242_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
		
				String errCd = "0000";
				try {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO)session.getAttribute("userSession");
				
					int sel_rst = epce0198201Mapper.epce0198231_select(inputMap); //적용기간 중복체크
				
					if(sel_rst>0){
						throw new Exception("A005"); // 적용기간은 중복될 수 없습니다. 다시 한 번 확인해주시기 바랍니다.
					}
					inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
					epce0198201Mapper.epce0198242_update(inputMap);  //회수보증금 수정
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch(Exception e){
					if (e.getMessage().equals("A005")) {
						 throw new Exception(e.getMessage()); 
					} else {
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					}
				}
				return errCd;	
		}	  
}
