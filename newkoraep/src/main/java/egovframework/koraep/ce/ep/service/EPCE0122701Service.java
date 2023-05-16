package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE0122701Mapper;



/**
 * 기준보증금관리 Service
 * @author 양성수
 *
 */
@Service("epce0122701Service")
public class EPCE0122701Service {
	
	@Resource(name="epce0122701Mapper")
	private EPCE0122701Mapper epce0122701Mapper;  //기준보증금관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	
	/**
	 * 기준보증금관리 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0122701_select(ModelMap model, HttpServletRequest request) {
		     
		  Map<String, String> map = new HashMap<String, String>();
		  
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			
			JSONObject jParams = JSONObject.fromObject(reqParams);
			JSONObject jParams2 =  (JSONObject)jParams.get("PARAMS");
			
		 	String ctnr_cd			=  jParams2.get("CTNR_CD").toString();
		 	String lang_se_cd		=  jParams2.get("LANG_SE_CD").toString();
		 	
		 	map.put("CTNR_CD", ctnr_cd);
		 	map.put("LANG_SE_CD", lang_se_cd);
			
		 	List<?> initList		=  epce0122701Mapper.epce0122701_select(map);
			String   title			=  commonceService.getMenuTitle("EPCE0122701");

			try {
				model.addAttribute("initList", util.mapToJson(initList));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}     //기준보증금관리  초기 리스트
			model.addAttribute("INQ_PARAMS",jParams);
			model.addAttribute("titleSub", title);
	    	
			return model;    	
	    }
	  
		/**
		 * 기준보증금관리 삭제
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0122701_delete(Map<String, String> inputMap, HttpServletRequest request) {
			String errCd = "0000";
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			try {
			
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
				
				int sel_rst = epce0122701Mapper.epce0122701_select2(inputMap); //기준보증금관리 삭제여부 가능한지 확인

				if(sel_rst>0){
					errCd = "A006";
					rtnMap.put("RSLT_CD",errCd);    // 오류코드 put
				}
				if(errCd == "0000"){
					epce0122701Mapper.epce0122701_delete(inputMap); //기준보증금 삭제
					epce0122701Mapper.epce0122731_insert2(inputMap); // 기준보증금이력 저장
					
			    	rtnMap.put("initList", util.mapToJson(epce0122701Mapper.epce0122701_select(inputMap)));    //기준보증금 다시 조회
			    	rtnMap.put("RSLT_CD",errCd);    // 오류코드 put
				}
				
				rtnMap.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd)); //오류 메세지 put
				
			} catch (Exception e) {
				rtnMap.put("RSLT_CD",  "A001"); // 오류코드 put
				return rtnMap; // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}	
			return rtnMap;    	
	    }
	  
	  
	  
	/**
	 * 기준보증금등록 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0122731_select(ModelMap model, HttpServletRequest request) {
		    Map<String, String> map = new HashMap<String, String>();
		    
			String   title            =  commonceService.getMenuTitle("EPCE0122731");
			String reqParams		= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
	   		JSONObject jParams	= JSONObject.fromObject(reqParams);
			JSONObject jParams2 =  (JSONObject)jParams.get("PARAMS");
			
		 	String ctnr_cd			=  jParams2.get("CTNR_CD").toString();
		 	String lang_se_cd		=  jParams2.get("LANG_SE_CD").toString();
		 	
		 	map.put("CTNR_CD", ctnr_cd);
		 	map.put("LANG_SE_CD", lang_se_cd);
			
		 	List<?> initList		=  epce0122701Mapper.epce0122731_select3(map);
		 	
		 	try {
				model.addAttribute("initList", util.mapToJson(initList));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}     //기준보증금관리  초기 리스트
	   		model.addAttribute("INQ_PARAMS", jParams);
			model.addAttribute("titleSub", title);
	    	
			return model;    	
	    }
	
	/**
	 * 기준보증금  저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
		public String epce0122731_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
	
			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				if (!"".equals(inputMap.get("START_DT"))) {
					inputMap.put("START_DT",inputMap.get("START_DT").replace("-", ""));
				}
	
				if (!"".equals(inputMap.get("END_DT"))) {
					inputMap.put("END_DT",inputMap.get("END_DT").replace("-", ""));
				}
				
				
				int sel_rst = epce0122701Mapper.epce0122731_select(inputMap); //적용기간 중복체크
	
				if (sel_rst > 0) {
					errCd = "A005";
				}
	
				if (errCd == "0000") {
	
					String reg_sn = epce0122701Mapper.epce0122731_select2(inputMap);   //등록순번
	
					inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
					inputMap.put("REG_SN", reg_sn);
	
					epce0122701Mapper.epce0122731_insert(inputMap); // 기준보증금 저장
					epce0122701Mapper.epce0122731_insert2(inputMap); // 기준보증금이력 저장
				}
			} catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
		}
		  
		/**
		 * 기준보증금변경 초기값
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce0122742_select(ModelMap model, HttpServletRequest request) {
			  
			  	String reqParams		= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		   		JSONObject jParams	= JSONObject.fromObject(reqParams);
			  
				String title = commonceService.getMenuTitle("EPCE0122742");
				
				model.addAttribute("titleSub", title);
				model.addAttribute("INQ_PARAMS", jParams);
				return model;    	
		    }
		/**
		* 기준보증금 수정
		* @param data
		* @param request
		* @return
		 * @throws Exception 
		* @
		*/
		public String epce0122742_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
		
		String errCd = "0000";
		try {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			
			if (!"".equals(inputMap.get("START_DT"))) {
				inputMap.put("START_DT",inputMap.get("START_DT").replace("-", ""));
			}
			if (!"".equals(inputMap.get("END_DT"))) {
				inputMap.put("END_DT",inputMap.get("END_DT").replace("-", ""));
			}
		
			int sel_rst = epce0122701Mapper.epce0122731_select(inputMap); //적용기간 중복체크
		
			if (sel_rst > 0) {
				errCd = "A005";
			}
		
			if (errCd == "0000") {
				inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
				epce0122701Mapper.epce0122742_update(inputMap);  //기준보증금 수정
				epce0122701Mapper.epce0122731_insert2(inputMap); // 기준보증금이력 저장
			}
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		return errCd;	
		}	  
		  
		  
	  
	  
	  
	  
	  
	  
	  
	  

}
