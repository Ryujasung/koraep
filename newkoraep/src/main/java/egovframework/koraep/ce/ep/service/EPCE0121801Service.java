package egovframework.koraep.ce.ep.service;

import java.sql.SQLIntegrityConstraintViolationException;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0121801Mapper;

/**
 * 직매장별거래처관리 서비스
 * @author Administrator
 *
 */
@Service("epce0121801Service")
public class EPCE0121801Service {

	@Resource(name="epce0121801Mapper")
	private EPCE0121801Mapper epce0121801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0121801_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("BIZR_TP_CD","W1");//도매업자
		List<?> bizrList = commonceService.bizr_select(map);
		
		List<?> areaList = commonceService.getCommonCdListNew("B010");//지역
		List<?> statList = commonceService.getCommonCdListNew("S011");//거래여부
		//List<?> bizrTpList = epce0121801Mapper.epce0121801_select();//거래처구분
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList)); //도매업자
			model.addAttribute("areaList", util.mapToJson(areaList));
			model.addAttribute("statList", util.mapToJson(statList));
			//model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}
	
	/**
	 * 소매거래처관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0121801_select2(Map<String, String> data) {
		
		String BIZRID_NO = data.get("WHSDL_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		System.out.println("data : "+data);
		List<?> list = epce0121801Mapper.epce0121801_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
			map.put("totalCnt", epce0121801Mapper.epce0121801_select2_cnt(data));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 등록화면 페이지 초기화
	 * @param model
	 * @param request
	 * @return 
	 * @
	 */
	public ModelMap epce0121831_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("BIZR_TP_CD","W1");//도매업자
		List<?> bizrList = commonceService.bizr_select(map);
		
		List<?> bizrTpList = epce0121801Mapper.epce0121801_select();//거래처구분
		
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList)); //도매업자
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		String title = commonceService.getMenuTitle("EPCE0121831");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}
	
	/**
	 * 거래처 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce0121831_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		Map<String, String> map;
		String ssUserId  = "";   //사용자ID
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0 ){
					for(int i=0; i<list.size(); i++) {
						map = (Map<String, String>) list.get(i);
						map.put("S_USER_ID", ssUserId);
						
						//존재하는지 체크
						Map<String, String> checkMap = (Map<String, String>) epce0121801Mapper.epce0121831_select(map);

						/*
						if(checkMap != null && !checkMap.get("BIZR_TP_CD").equals("R1") && !checkMap.get("BIZR_TP_CD").equals("R2")){ 
							//errCd = ""; // 이미 등록되어있는 사업자가 소매업자가 아닐경우는 거래처 데이터를 등록하지 않는다
							continue;
						}
						*/
						
						if(checkMap != null && !checkMap.get("BIZRID").equals("") && !checkMap.get("BRCH_ID").equals("N") ){ //사업자, 지점 둘다 등록상태
							
							//이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다.  즉  작성한 거래처명, 사업자유형은 무시함
							//errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
							map.put("BIZRID", checkMap.get("BIZRID"));
							map.put("BRCH_ID", checkMap.get("BRCH_ID"));
						}else{
						
							if(checkMap == null || (checkMap != null && checkMap.get("BIZRID").equals("")) ){ //사업자데이터가 없을경우
								
								String psnbSeq = commonceService.psnb_select("S0001"); //사업자ID 일련번호 채번
								//map.put("BIZRID", "D3H"+psnbSeq); //사업자ID = 소매거래처등록사업자(D3) - 수기(H)
								
								//String bizrTpCd = map.get("BIZR_TP_CD");
								String bizrTpCd = "D3"; //소매거래처등록사업자(D3)
								map.put("BIZR_TP_CD", bizrTpCd);
								map.put("BIZRID", bizrTpCd+"H"+psnbSeq); //사업자ID = R1 가정용;R2 영업용 - 수기(H)

								epce0121801Mapper.epce0121831_insert(map); //소매 사업자등록
								epce0121801Mapper.epce0121831_insert2(map); //소매 지점등록
								
							}else if(checkMap != null && checkMap.get("BRCH_ID").equals("N") ){ //지점데이터가 없을경우
								
								map.put("BIZRID", checkMap.get("BIZRID")); //조회된 사업자ID로 등록
								map.put("BIZR_TP_CD", checkMap.get("BIZR_TP_CD"));
								epce0121801Mapper.epce0121831_insert2(map); //소매 지점등록
							}
						}
						
						if(!map.containsKey("BRCH_ID")) map.put("BRCH_ID", "");
						
						if(data.containsKey("FRC_YN")){ 
							map.put("FRC_YN", data.get("FRC_YN"));
							epce0121801Mapper.epce0121831_update(map); //가맹점 인서트 및 업데이트
						}else{
							
							int cnt = epce0121801Mapper.epce0121831_select4(map);
							
							if(cnt > 0) {
								return "B008";
							}
							
							epce0121801Mapper.epce0121831_insert3(map); //소매거래처정보등록
						}
					}
				}
				else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}
				
		}catch(Exception e){
			/*e.printStackTrace();*/
			//취약점점검 6330 기원우
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}

	/**
	 * 소매거래처관리 데이터 체크
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce0121831_select2(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";
		Map<String, String> map;
		
		try {
			
			List<?> list = epce0121801Mapper.epce0121831_select2(data);
			
			if(list != null && list.size() > 0 ){
				map = (Map<String, String>) list.get(0); //하나만 보여줌..
				errCd = map.get("ERR_CD");
			}
			
		}catch(Exception e){
			return  "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 소매거래처관리 데이터 체크 (엑셀저장용)
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce0121831_select3(HashMap<String, String> data, HttpServletRequest request) {
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("selList", util.mapToJson(epce0121801Mapper.epce0121831_select3(data)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
    	return rtnMap;    	
	}
	
	/**
	 * 거래상태 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce0121801_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		Map<String, String> map;
		String ssUserId  = "";   //사용자ID
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				List<?> list = JSONArray.fromObject(data.get("list"));
				String execStatCd = data.get("exec_stat_cd");
				for(int i=0; i<list.size(); i++) {
					map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					map.put("EXEC_STAT_CD", execStatCd);
					
					epce0121801Mapper.epce0121801_update(map);	//수정 처리
					
				}
				
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 소매거래처 변경 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0121888_select(ModelMap model) {
		
		String title = commonceService.getMenuTitle("EPCE0121888");
		model.addAttribute("titleSub", title);

		List<?> bizrTpList = epce0121801Mapper.epce0121801_select();//거래처구분
		try {
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 소매거래처 정보 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce0121888_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				data.put("S_USER_ID", ssUserId);
				
				int rCnt = epce0121801Mapper.epce0121888_update(data); //사업자
				if(rCnt > 0){
					epce0121801Mapper.epce0121888_update2(data); //지점
					epce0121801Mapper.epce0121888_update3(data); //거래처
				}
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce0121801_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			String BIZRID_NO = data.get("WHSDL_BIZR_SEL");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("BIZRID", BIZRID_NO.split(";")[0]);
				data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}
			
			data.put("excelYn", "Y");
			List<?> list = epce0121801Mapper.epce0121801_select2(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}

	public ModelMap epce01218881_select(ModelMap model,HttpServletRequest request) {
		//파라메터 정보   
			String reqParams 			= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams 		= JSONObject.fromObject(reqParams);
			Map<String, String> map = new HashMap<String, String>();
			String title = commonceService.getMenuTitle("EPCE01218881");		//타이틀
			try {
				model.addAttribute("INQ_PARAMS",jParams);   
				model.addAttribute("titleSub", title);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
			return model;   
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
		public String epce01218881_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
	    	HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");

			String fileName = "";
			String tmpFileName = "";
			String errCd = "0000";
			inputMap.put("WHSDL_BIZRID" ,request.getParameter("WHSDL_BIZRID"));
			inputMap.put("WHSDL_BIZRNO"  ,request.getParameter("WHSDL_BIZRNO"));
			inputMap.put("RTL_CUST_BIZRID"  ,request.getParameter("RTL_CUST_BIZRID"));
			inputMap.put("RTL_CUST_BIZRNO"  ,request.getParameter("RTL_CUST_BIZRNO"));
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
							System.out.println("service inputMap3 : "+inputMap);
							epce0121801Mapper.epce01218881_insert(inputMap);	
						}
					}
					
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			return errCd;
	    }
	    /***********************************************************************************************************************************************
	     *	회수증빙자료다운로드
	     ************************************************************************************************************************************************/
	   	
	   	/**   
	   	 * 회수증빙자료다운로드	초기 화면
	   	 * @param inputMap
	   	 * @param request  
	   	 * @return   
	   	 * @          
	   	 */
	   	  public ModelMap epce01218882_select(@RequestParam Map<String, String> param, ModelMap model, HttpServletRequest request) {
	   		    
	   		  	//파라메터 정보
	   			String reqParams 		= util.null2void(request.getParameter("INQ_PARAMS"),"{}");  
	   			JSONObject jParams 	= JSONObject.fromObject(reqParams);	 
	   			
	  	    	HttpSession session = request.getSession();
	  			UserVO vo = (UserVO) session.getAttribute("userSession");

	  			if(vo != null ){
	  				param.put("T_USER_ID", vo.getUSER_ID());
	  			}
	  			param.put("excelYn", "Y");
	   			System.out.println("param"+param);
	   			List<?>	initList = epce0121801Mapper.epce0121801_select2 (param); 
	   			String  title = commonceService.getMenuTitle("EPCE01218882");		//타이틀
	   			try {
	   				model.addAttribute("initList", util.mapToJson(initList));	   
	   				model.addAttribute("INQ_PARAMS",jParams);  
	   				model.addAttribute("titleSub", title);
	   			} catch (Exception e) {
	   				// TODO Auto-generated catch block
	   				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
	   			}	
	   			return model;    	
	   	    }

	   	/**
			 * 증빙파일정보관리  삭제
			 * @param inputMap
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
			public String epce0121801_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
				String errCd = "0000";
				try {  
					epce0121801Mapper.epce0121801_delete(inputMap); //  삭제  
				} catch (Exception e) {
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}    
			return errCd;  
			}
	
}