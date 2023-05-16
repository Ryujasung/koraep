package egovframework.koraep.ce.ep.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE2916401Mapper;
  
/**
 * 실태조사 Service
 * @author 양성수
 *
 */
@Service("epce2916401Service")
public class EPCE2916401Service {
	
	
	@Resource(name="epce2916401Mapper")
	private EPCE2916401Mapper epce2916401Mapper;  //실태조사 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	 * 실태조사 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2916401_select(ModelMap model, HttpServletRequest request) {
		  
		  
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();
			List<?> dtList				= commonceService.getCommonCdListNew("D022");	//반환등록일자구분
			List<?> stat_cdList		= epce2916401Mapper.epce2916401_select7();			//상태
			List<?> mfc_bizrnmList = commonceService.mfc_bizrnm_select(request); 	 				//생산자
			List<?> whsl_se_cdList	= commonceService.whsdl_se_select(request, map);  		 		//도매업자구분
			List<?> sys_seList		= epce2916401Mapper.epce2916401_select8();			//실태조사구분
			List<?> areaList			= commonceService.getCommonCdListNew("B010");		//지역
			String   title					= commonceService.getMenuTitle("EPCE2916401");		//타이틀
			List<?>	whsdlList		= commonceService.mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
			String   detail 				= "F";
			List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPCE2916401",request);		//그리드 컬럼 정보
			
			//반환내역상세 들어갔다가 다시 관리 페이지로 올경우
			Map<String, String> paramMap = new HashMap<String, String>();
	
			try {
				if(jParams.get("SEL_PARAMS") !=null){//반환상세 볼경우
					JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
					if(param2.get("MFC_BIZRID") !=null){	//생산자사업자 선택시
						paramMap.put("BIZRNO", param2.get("MFC_BIZRNO").toString());					//생산자ID
						paramMap.put("BIZRID", param2.get("MFC_BIZRID").toString());					//생산자 사업자번호
						List<?> brch_nmList = commonceService.brch_nm_select(request, paramMap);	 	  	//사업자 직매장/공장 조회	
						model.addAttribute("brch_nmList", util.mapToJson(brch_nmList));	
					}
						detail = "T"; 
				}
				model.addAttribute("grid_info", util.mapToJson(grid_info));
				model.addAttribute("dtList", util.mapToJson(dtList));	
				model.addAttribute("sys_seList", util.mapToJson(sys_seList));	
				model.addAttribute("mfc_bizrnmList", util.mapToJson(mfc_bizrnmList));		
				model.addAttribute("stat_cdList", util.mapToJson(stat_cdList));	
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));	
				model.addAttribute("whsdlList", util.mapToJson(whsdlList));	
				model.addAttribute("areaList", util.mapToJson(areaList));
				model.addAttribute("titleSub", title);
				model.addAttribute("detail", detail);
			
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	

			return model;    	
	    }
	  
		/**
		 * 실태조사 생산자변경시  생산자에맞는 직매장 조회  ,업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2916401_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
		      		inputMap.put("BIZR_TP_CD", "");
		      		rtnMap.put("brch_nmList", util.mapToJson(commonceService.brch_nm_select(request, inputMap))); //사업자 직매장/공장 조회	
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 	
	    	
			return rtnMap;    	
	    }
	  
		/**
		 * 실태조사 생산자 직매장/공장 선택시  업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2916401_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
					rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap))); //업체명 조회	
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	 
			return rtnMap;    	
	    }
		
		/**
		 * 실태조사 도매업자 구분 선택시 업체명 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2916401_select4(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	try {
		      		rtnMap.put("whsdlList", util.mapToJson(commonceService.mfc_bizrnm_select4(request, inputMap)));    	 // 생산자랑 거래중인 도매업자 업체명조회
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	 
	    	return rtnMap;    	
	    }
	
		/**
		 * 실태조사  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2916401_select5(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				inputMap.put("T_USER_ID", vo.getUSER_ID());
			}
	    	
	    		try {
					rtnMap.put("selList", util.mapToJson(epce2916401Mapper.epce2916401_select4(inputMap)));
					rtnMap.put("totalList", util.mapToJson(epce2916401Mapper.epce2916401_select4_cnt(inputMap)));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	  
	    	return rtnMap;    	
	    }
		
		/**
		 * 실태조사 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce2916401_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null ){
				data.put("T_USER_ID", vo.getUSER_ID());
			}
			
			String errCd = "0000";
			try {
						
				List<?> list = epce2916401Mapper.epce2916401_select4(data);
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
		}	
		
		/**
		 * 실태조사  조사요청취소   이전 상태로 변경
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce2916401_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
	
			
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						int stat = epce2916401Mapper.epce2916401_select5(map); //상태 체크
						 if(stat>0){
							throw new Exception("A010");  //실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 	map.put("UPD_PRSN_ID", vo.getUSER_ID());  				//등록자
							epce2916401Mapper.epce2916401_update(map); 		// 반환내역서  실태조사이전 상태로 변화
							if(map.get("WRHS_DOC_NO") !=null){
								epce2916401Mapper.epce2916401_update2(map); 	// 입고내역서 실태조사이전 상태로 변화
							}
							epce2916401Mapper.epce2916401_delete(map); 			// 실태조사파일테이블 삭제
							epce2916401Mapper.epce2916401_delete2(map); 		// 실태조사정보테이블 삭제
					}
				}catch (Exception e) {
					if(e.getMessage().equals("A010") ){
						throw new Exception(e.getMessage()); 
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
			}
			
			return errCd;    	
	    }
		
	//---------------------------------------------------------------------------------------------------------------------
	// 증빙파일등록
	//---------------------------------------------------------------------------------------------------------------------
	
		/**
		 * 증빙파일등록  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce2916488_select(Map<String, String> inputMap, HttpServletRequest request) {
				HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			  	//파라메터 정보
				String   title = commonceService.getMenuTitle("EPCE2916488");		//타이틀
				
				try {
					rtnMap.put("initList", util.mapToJson(epce2916401Mapper.epce2916488_select(inputMap)));  //입고조정인 애들 증빙파일  기초정보조회
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}   
	    		rtnMap.put("titleSub", title);	  
	    		return rtnMap;    	
	    }
		
		/**
		 * 증빙파일등록  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epce2916488_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");

			String fileName = "";
			String tmpFileName = "";
			String errCd = "0000";

			inputMap.put("RSRC_DOC_NO" ,request.getParameter("RSRC_DOC_NO"));
			inputMap.put("RTN_DOC_NO"  ,request.getParameter("RTN_DOC_NO"));
			//크로스 사이트 스크립트 수정 후 변경
//			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
			MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
			Iterator fileIter = mptRequest.getFileNames();
			try {	
					while (fileIter.hasNext()) {
						MultipartFile mFile = mptRequest.getFile((String)fileIter.next());

						fileName = mFile.getOriginalFilename();
						if(fileName != null && !fileName.equals("")){
							tmpFileName = fileName.toLowerCase();
							HashMap map = EgovFileMngUtil.uploadFile(mFile, vo.getBIZRNO());	//파일저장
							fileName = (String)map.get("uploadFileName");
							inputMap.put("FILE_NM"      ,(String)map.get("originalFileName"));
							inputMap.put("SAVE_FILE_NM" ,(String)map.get("uploadFileName"));
							inputMap.put("FILE_PATH"    ,(String)map.get("filePath"));
							inputMap.put("REG_PRSN_ID" ,vo.getUSER_ID());
							epce2916401Mapper.epce2916488_insert(inputMap);	
						}
					}
					
					String delSeq = (null == request.getParameter("RSRC_DTL_SN")) ? "" : request.getParameter("RSRC_DTL_SN");
					String[] delSeqList = delSeq.split(",");
					
					for(int i=0; i<delSeqList.length; i++) {
						inputMap.put("RSRC_DTL_SN", delSeqList[i]);
						epce2916401Mapper.epce2916488_delete(inputMap);
					}
					
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
	    }
	    
	   	
		/**
		 * 증빙파일등록  삭제
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epce2916488_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				
				String errCd = "0000";
		
				try {
					epce2916401Mapper.epce2916488_delete(inputMap);		
					
				} catch (Exception e) {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
				return errCd;	
	    }
		
	//---------------------------------------------------------------------------------------------------------------------
	// 증빙파일조회
	//---------------------------------------------------------------------------------------------------------------------
	
		/**
		 * 증빙파일조회  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce29164882_select(Map<String, String> inputMap, HttpServletRequest request) {
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		  	//파라메터 정보
			String   title					= commonceService.getMenuTitle("EPCE29164882");		//타이틀
			
			try {
				rtnMap.put("initList", util.mapToJson(epce2916401Mapper.epce29164882_select(inputMap))); //입고조정인 애들 증빙파일  기초정보조회
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}    
    		rtnMap.put("titleSub", title);	  
    		return rtnMap;     	
	    }
		
		
	//---------------------------------------------------------------------------------------------------------------------
	// 실태조사요청정보
	//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 실태조사요청정보  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce29164883_select(Map<String, String> inputMap, HttpServletRequest request) {
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		  	//파라메터 정보
			String   title					= commonceService.getMenuTitle("EPCE29164883");		//타이틀
			
			try {
				rtnMap.put("initList", util.mapToJson(epce2916401Mapper.epce29164883_select(inputMap))); //입고조정인 애들 증빙파일  기초정보조회
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}     
    		rtnMap.put("titleSub", title);	  									   
    		return rtnMap;    	
	    }
		
		/**
		 * 실태조사요청정보  등록
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epce29164883_update(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				
				String errCd = "0000";
		
				try {
					inputMap.put("REG_PRSN_ID", vo.getUSER_ID());  		
					epce2916401Mapper.epce29164883_update(inputMap);		
					
				} catch (Exception e) {
					 if(e.getMessage().equals("A008")){
						 throw new Exception(e.getMessage()); 
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
				return errCd;	
	    }
	    
	    
	    
	/**
	 * 실태조사표 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce29164312_select(ModelMap model, HttpServletRequest request) {
		  
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		    
		String title         = commonceService.getMenuTitle("EPCE29164312");		//타이틀
		List<?> rsrc_seList  = commonceService.getCommonCdListNew("B013"); //실태조사구분
		List<?> rsrc_rstList = commonceService.getCommonCdListNew("B014"); //실태조사결과
		
		List<?> rsrcList = null;

		
		Map<String, String> map= new HashMap<String, String>();
		
		if(jParams.get("PARAMS") !=null){//반환상세 볼경우
			
			JSONObject param2 =(JSONObject)jParams.get("PARAMS");

			map.put("RSRC_DOC_NO" , param2.get("RSRC_DOC_NO").toString()); //실태조사 문서번호
			map.put("RSRC_DOC_KND", param2.get("RSRC_DOC_KND").toString()); //실재토사 구분

			rsrcList = epce2916401Mapper.epce29164312_select(map);
		}
		
		//반환내역상세 들어갔다가 다시 관리 페이지로 올경우
		Map<String, String> paramMap = new HashMap<String, String>();
	
		try {
			
			if("W".equals(map.get("RSRC_DOC_KND").toString())) {
				title = title + " (도매업자용)";
			}
			else if("M".equals(map.get("RSRC_DOC_KND").toString())) {
				title = title + " (빈용기재사용생산자용)";
			}
			
			model.addAttribute("rsrc_list", util.mapToJson(rsrcList));
			model.addAttribute("rsrc_seList", util.mapToJson(rsrc_seList));	
			model.addAttribute("rsrc_rstList", util.mapToJson(rsrc_rstList));	
			model.addAttribute("titleSub", title);
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	

		return model;    	
    }
	
	/**
	 * 실태조사표 저장
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String EPCE29164312_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID     

		try {

			if(vo != null){
				ssUserId = vo.getUSER_ID();   
				inputMap.put("RH_CFM_PRSN_ID", ssUserId);
				inputMap.put("REG_PRSN_ID", ssUserId);
				inputMap.put("UPD_PRSN_ID", ssUserId);
			}

			epce2916401Mapper.epce29164312_insert(inputMap); // 실태조사표
			   
		} catch (Exception e) {
			 if(e.getMessage().equals("A003")){
				 throw new Exception(e.getMessage()); 
			 }else if(e.getMessage().equals("A021")){
				 throw new Exception(e.getMessage()); 
			 }else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			 }
		}

		return errCd;
    }
}
