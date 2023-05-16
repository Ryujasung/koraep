package egovframework.koraep.ce.ep.service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE8149001Mapper;
import egovframework.mapper.ce.ep.EPCE8149093Mapper;

/**
 * 공지사항 Service
 * @author pc
 *
 */
@Service("epce8149001Service")
public class EPCE8149001Service {
	
	@Resource(name="epce8149001Mapper")
	private EPCE8149001Mapper epce8149001Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	@Resource(name="epce8149093Mapper")
	private EPCE8149093Mapper epce8149093Mapper;
	
	/**
	 * 공지사항 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce8149001(ModelMap model, HttpServletRequest request)  {
		
		Map<String, String> map = new HashMap<String, String>();
				
		map.put("CONDITION", "");
		map.put("WORD", "");
		
		//공지사항 총 게시글 수 조회
		List<?> totalCnt = epce8149001Mapper.epce8149001(map);
		
		if(null == totalCnt) {
			model.addAttribute("totalCnt", "{}");
			
		} else {
			try {
				model.addAttribute("totalCnt", util.mapToJson(totalCnt));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
		}
		
		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}
	
	/**
	 * 공지사항 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce8149001_select(Map<String, String> data, HttpServletRequest request)  {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		//검색범위 계산
		int startRnum = 0;	//검색 시작번호
		int endRnum = 0;	//검색 끝번호
		int page = Integer.parseInt(data.get("PAGE"));	//현재 페이지 번호
		int cntRow = Integer.parseInt(data.get("CNTROW"));	//페이지당 게시글 수
		
		if(page<=0 || page>=10000){
			page = 1;
		}
		
		if(cntRow<=0 || cntRow>=100){
			page = 12;
		}
		
		startRnum = (page - 1) * cntRow + 1;
		endRnum = page * cntRow;
		
		data.put("STARTROW", String.valueOf(startRnum));
		data.put("ENDROW", String.valueOf(endRnum));
		
		//공지사항 검색 게시글 수 조회
		List<?> totalCnt = epce8149001Mapper.epce8149001(data);
		
		//공지사항 조회
		List<?> list = epce8149001Mapper.epce8149001_select1(data);
		
		//첨부파일 있는지 조회
		List<?> fileList = epce8149001Mapper.epce8149001_select2(data);
		
		int k = 0;
		String sTmpSbj = "";
		
		for(int i=0;i<list.size();i++){
			
			Map<String, String> rtn = (Map<String, String>)list.get(i);
		
			sTmpSbj = "<a class='link' href='javascript:fn_dtl_sel_lk("+ String.valueOf(rtn.get("NOTI_SEQ")) +");' target='_self'>" + rtn.get("SBJ") + "</a>";

			if(0 < fileList.size()){
				
				for(int j=k;j<fileList.size();j++){
					
					Map<String, String> rtnFile = (Map<String, String>)fileList.get(j);
					
					if(String.valueOf(rtn.get("NOTI_SEQ")).equals(String.valueOf(rtnFile.get("NOTI_SEQ")))){
						sTmpSbj += "&nbsp&nbsp<img src='/images/util/attach_ico.png'>" ;
						k++;
						break;
					}
				}
			}
			
			rtn.put("SBJ", sTmpSbj);
		}

		try {
			map.put("searchList", util.mapToJson(list));
			map.put("totalCnt", util.mapToJson(totalCnt));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
		
	}
	
	
/***************************************************************************************************************************************************************************************
* 			문의하기
****************************************************************************************************************************************************************************************/
	
	
	/**
	 * 문의하기 공지사항 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	/*  public HashMap epce8149088_select(Map<String, String> inputMap, HttpServletRequest request) {
		 	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
		
			try {
				rtnMap.put("INQ_PARAMS", jParams); 
				rtnMap.put("selList", util.mapToJson(epce8149001Mapper.epce8149088_select(inputMap))); 
				rtnMap.put("totalCnt", epce8149001Mapper.epce8149088_select_cnt(inputMap));
			
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return rtnMap;    	
	    }*/
	
	  public ModelMap epce8149088_select(ModelMap model, HttpServletRequest request) {
			
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		try {
			Map<String, String> map= new HashMap<String, String>();
			List<?> selList		= epce8149001Mapper.epce8149088_select(map);		//조회
			int totalCnt			= epce8149001Mapper.epce8149088_select_cnt(map);	//조회 카운트
			
			model.addAttribute("selList", util.mapToJson(selList));
			model.addAttribute("totalCnt", totalCnt);	
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		return model;    	
    }
	  
	/**
	 * 문의하기 공지사항  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce8149088_select2(Map<String, String> inputMap, HttpServletRequest request) {
		 	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		
			try {
				rtnMap.put("selList", util.mapToJson(epce8149001Mapper.epce8149088_select(inputMap))); 
				rtnMap.put("totalCnt", epce8149001Mapper.epce8149088_select_cnt(inputMap));
			
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	

			return rtnMap;    	
	    }

  /**
	 * 문의하기 공지사항  상세 조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public HashMap epce81490882_select(Map<String, String> inputMap, HttpServletRequest request) {
					  
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		try {
			inputMap.put("NOTI_SEQ", inputMap.get("NOTI_SEQ"));
			epce8149093Mapper.epce8149093_update(inputMap); //공지사항 조회수 증가
			rtnMap.put("notiInfo", util.mapToJson(epce8149093Mapper.epce8149093_select1(inputMap))); //공지사항 상세조회
			rtnMap.put("preNoti", util.mapToJson(epce8149093Mapper.epce8149093_select2(inputMap))); //이전글 제목 조회
			rtnMap.put("nextNoti", util.mapToJson(epce8149093Mapper.epce8149093_select3(inputMap))); //다음글 제목 조회
			rtnMap.put("fileList", util.mapToJson(epce8149093Mapper.epce8149093_select4(inputMap))); //공지사항 첨부파일 조회
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		return rtnMap;    	
    }




}
