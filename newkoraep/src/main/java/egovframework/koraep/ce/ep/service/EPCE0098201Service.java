package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE0098201Mapper;
import egovframework.mapper.ce.ep.EPCE8149093Mapper;
import egovframework.mapper.ce.ep.EPCE8169997Mapper;

/**  
 * 문의사항
 * @author Administrator
 *  
 */
@Service("epce0098201Service")   
public class EPCE0098201Service {   

	@Resource(name="epce0098201Mapper")
	private EPCE0098201Mapper epce0098201Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="epce8149093Mapper")
	private EPCE8149093Mapper epce8149093Mapper;

	@Resource(name="epce8169997Mapper")
	private EPCE8169997Mapper epce8169997Mapper;
	
	
	
	/**
	 * 문의하기 공지사항 초기값
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0098201_select(ModelMap model, HttpServletRequest request) {

	 	
		try {
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			Map<String, String> map= new HashMap<String, String>();
			/*	map.put("ROWS_PER_PAGE", "12");
				map.put("CURRENT_PAGE", "1");
				List<?> selList		= epce0098201Mapper.epce0098201_select(map);		//조회
				int totalCnt			= epce0098201Mapper.epce0098201_select_cnt(map);	//조회 카운트
				model.addAttribute("selList", util.mapToJson(selList));
				model.addAttribute("totalCnt", totalCnt);	*/
			
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
	}
	
	/**
	 * 문의하기 공지사항 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0098201_select2(Map<String, String> data,HttpServletRequest request) {
		
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			rtnMap.put("selList", util.mapToJson(epce0098201Mapper.epce0098201_select(data))); 
			rtnMap.put("totalCnt", epce0098201Mapper.epce0098201_select_cnt(data));
		
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return rtnMap;
	}
	
	/**
	 * 문의하기 공지사항 상세
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0098288_select(ModelMap model, HttpServletRequest request) {
	
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			
			Map<String, String> inputMap = util.jsonToMap(jParams.getJSONObject("PARAMS"));
			
			epce8149093Mapper.epce8149093_update(inputMap); //공지사항 조회수 증가
			model.addAttribute("notiInfo", util.mapToJson(epce8149093Mapper.epce8149093_select1(inputMap)));//공지사항 상세조회
			model.addAttribute("preNoti", util.mapToJson(epce8149093Mapper.epce8149093_select2(inputMap)));//이전글 제목 조회
			model.addAttribute("nextNoti", util.mapToJson(epce8149093Mapper.epce8149093_select3(inputMap)));//다음글 제목 조회
			model.addAttribute("fileList", util.mapToJson(epce8149093Mapper.epce8149093_select4(inputMap))); //공지사항 첨부파일 조회
			
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return model;
	}
	
	/**
	 * 문의하기 공지사항  상세 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce0098288_select2(Map<String, String> inputMap, HttpServletRequest request) {
					  
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			
			epce8149093Mapper.epce8149093_update(inputMap); //공지사항 조회수 증가
			rtnMap.put("notiInfo", util.mapToJson(epce8149093Mapper.epce8149093_select1(inputMap))); //공지사항 상세조회
			rtnMap.put("preNoti", util.mapToJson(epce8149093Mapper.epce8149093_select2(inputMap))); //이전글 제목 조회
			rtnMap.put("nextNoti", util.mapToJson(epce8149093Mapper.epce8149093_select3(inputMap))); //다음글 제목 조회
			rtnMap.put("fileList", util.mapToJson(epce8149093Mapper.epce8149093_select4(inputMap))); //공지사항 첨부파일 조회
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		return rtnMap;    	
    }
	  
  /***************************************************************************************************************************************************************************************
   * 		FAQ
   ****************************************************************************************************************************************************************************************/
	  
	  /**
		 * 문의하기 FAQ 초기값
		 * @param model
		 * @param request
		 * @return
		 * @
		 */
		public ModelMap epce00982882_select(ModelMap model, HttpServletRequest request) {

		 	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			
			try {
				Map<String, String> map= new HashMap<String, String>();
					/*map.put("ROWS_PER_PAGE", "12");
					map.put("CURRENT_PAGE", "1");
					List<?> selList		= epce0098201Mapper.epce0098201_select(map);		//조회
					int totalCnt			= epce0098201Mapper.epce0098201_select_cnt(map);	//조회 카운트
					model.addAttribute("selList", util.mapToJson(selList));
					model.addAttribute("totalCnt", totalCnt);	*/
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			return model;
		}
		
		/**
		 * 문의하기 FAQ 조회
		 * @param model
		 * @param request
		 * @return
		 * @
		 */
		public HashMap<String, Object> epce00982882_select2(Map<String, String> data,HttpServletRequest request) {
			
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			try {
				rtnMap.put("selList", util.mapToJson(epce0098201Mapper.epce00982882_select(data))); 
				rtnMap.put("totalCnt", epce0098201Mapper.epce00982882_select_cnt(data));
			
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			return rtnMap;
		}
		
		/**
		 * 문의하기 FAQ 상세
		 * @param model
		 * @param request
		 * @return
		 * @
		 */
		public ModelMap epce00982883_select(ModelMap model, HttpServletRequest request) {
		
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			try {
				//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				model.addAttribute("INQ_PARAMS",jParams);
				
				Map<String, String> inputMap = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				
				model.addAttribute("notiInfo", util.mapToJson(epce8169997Mapper.epce8169997_select1(inputMap)));//FAQ 상세조회
				model.addAttribute("preNoti", util.mapToJson(epce8169997Mapper.epce8169997_select2(inputMap)));//이전글 제목 조회
				model.addAttribute("nextNoti", util.mapToJson(epce8169997Mapper.epce8169997_select3(inputMap)));//다음글 제목 조회
				model.addAttribute("fileList", util.mapToJson(epce8169997Mapper.epce8169997_select4(inputMap))); //FAQ 첨부파일 조회
				
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			return model;
		}
		
		/**
		 * 문의하기 FAQ 상세 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public HashMap epce00982883_select2(Map<String, String> inputMap, HttpServletRequest request) {
						  
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			try {
				
				rtnMap.put("notiInfo", util.mapToJson(epce8169997Mapper.epce8169997_select1(inputMap))); //FAQ 상세조회
				rtnMap.put("preNoti", util.mapToJson(epce8169997Mapper.epce8169997_select2(inputMap))); //이전글 제목 조회
				rtnMap.put("nextNoti", util.mapToJson(epce8169997Mapper.epce8169997_select3(inputMap))); //다음글 제목 조회
				rtnMap.put("fileList", util.mapToJson(epce8169997Mapper.epce8169997_select4(inputMap))); //FAQ 첨부파일 조회
			}catch (IOException io) {
				io.getMessage();
			}catch (SQLException sq) {
				sq.getMessage();
			}catch (NullPointerException nu){
				nu.getMessage();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return rtnMap;    	
	    }
	

}
