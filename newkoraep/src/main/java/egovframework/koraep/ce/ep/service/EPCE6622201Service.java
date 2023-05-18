package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE6622201Mapper;


/**
 * 입고확인취소요청조회 Service
 * @author 양성수
 *
 */
@Service("epce6622201Service")
public class EPCE6622201Service {

	@Resource(name="epce6622201Mapper")
	private EPCE6622201Mapper epce6622201Mapper;  //실행이력조회 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  // 공통 Mapper

	/**
	 * 실행이력 초기값 셋팅
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce6622201_select(ModelMap model, HttpServletRequest request) {
		
		String  GRP_CD ="M002";
		Map<String, String> bizrMap = new HashMap<String, String>();
		//bizrMap.put("BIZR_TP_CD", "M2"); //음료생산자
		
		List<?> mfc_bizrnm_sel = commonceService.mfc_bizrnm_select(request, bizrMap); 	// 생산자 콤보박스
		List<?> stat_cdList = commonceService.getCommonCdListNew("D055");	//상태
		
		try {
			model.addAttribute("mfc_bizrnm_sel", util.mapToJson(mfc_bizrnm_sel));	//생산자구분 리스트
			model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));
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
	 * EPCE6622201_19
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce6622201_select2(Map<String, String> inputMap, HttpServletRequest request) {
		  	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		  	String BIZRID_NO = inputMap.get("MFC_BIZRNM_SEL");
		  
		  	if(BIZRID_NO != null && !BIZRID_NO.equals("")){
		  		inputMap.put("REQ_BIZRID", BIZRID_NO.split(";")[0]);
		  		inputMap.put("REQ_BIZRNO", BIZRID_NO.split(";")[1]);
		  	}else{
		  		inputMap.put("REQ_BIZRID", "");
		  		inputMap.put("REQ_BIZRNO", "");
		  	}
			
			if(!"".equals(inputMap.get("START_DT"))){
				inputMap.put("START_DT", inputMap.get("START_DT").replace("-", ""));
			}
			
			if(!"".equals(inputMap.get("END_DT"))){
				inputMap.put("END_DT", inputMap.get("END_DT").replace("-", ""));
			}
			
			try {
				rtnMap.put("execHistList", util.mapToJson(epce6622201Mapper.epce6622201_select2(inputMap)));
				rtnMap.put("totalCnt", epce6622201Mapper.epce6622201_select2_cnt(inputMap));
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
	 * EPCE6622201_191
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce6622201_select3(Map<String, String> inputMap, HttpServletRequest request) {
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	rtnMap.put("reqRsn", epce6622201Mapper.epce6622201_select3(inputMap));    
	    	return rtnMap;
	  }
	
}
