package egovframework.koraep.ce.ep.service;

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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE4763601Mapper;
import egovframework.mapper.ce.ep.EPCE6645231Mapper;

/**
 * 직접회수정정  서비스
 * @author Administrator
 *
 */
@Service("epce4763601Service")
public class EPCE4763601Service {

	@Resource(name="epce4763601Mapper")
	private EPCE4763601Mapper epce4763601Mapper;

	@Resource(name="epce6645231Mapper")
	private EPCE6645231Mapper epce6645231Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4763601_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		
		Map<String, String> map = new HashMap<String, String>();
		
		List<?> stdMgntList = commonceService.std_mgnt_select(request, map); //정산기간
		List<?> statList = commonceService.getCommonCdListNew("C003");
		List<?> mfcSeCdList = commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
		
		try {
			model.addAttribute("stdMgntList", util.mapToJson(stdMgntList));
			model.addAttribute("statList", util.mapToJson(statList));
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
			
			if(jmap != null){

				String BIZRID_NO = jmap.get("MFC_BIZR_SEL");
				if(BIZRID_NO != null && !BIZRID_NO.equals("")){
					map.put("BIZRID", BIZRID_NO.split(";")[0]);
					map.put("BIZRNO", BIZRID_NO.split(";")[1]);
					map.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
					map.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
				}else{
					map.put("BIZRID", "");
					map.put("BIZRNO", "");
					map.put("MFC_BIZRID", "");
					map.put("MFC_BIZRNO", "");
				}

				List<?> brchList = commonceService.brch_nm_select(request, map);
				List<?> ctnrList = commonceService.ctnr_nm_select(request, map);

				model.addAttribute("brchList", util.mapToJson(brchList));
				model.addAttribute("ctnrList", util.mapToJson(ctnrList));

			}else{
				model.addAttribute("brchList", "{}");	
				model.addAttribute("ctnrList", "{}");	
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
	 * 정정등록 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4763631_select(ModelMap model, HttpServletRequest request) {
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		HashMap<String, String> excaStdMap = commonceService.exca_std_mgnt_select(param); // 정산기간 조회

		String   title		= commonceService.getMenuTitle("EPCE4763631"); //타이틀
		List<?> mfcSeCdList = commonceService.mfc_bizrnm_select_y(request); // 생산자 콤보박스
		
		model.addAttribute("titleSub", title);
		try {
			model.addAttribute("excaStdMap", util.mapToJson(excaStdMap));
			model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	//생산자 리스트
		
		return model;
	}
	
	/**
	 * 정정수정 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4763642_select(ModelMap model, HttpServletRequest request) {
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		HashMap<String, String> excaStdMap = commonceService.exca_std_mgnt_select(param); // 정산기간 조회

		String   title		= commonceService.getMenuTitle("EPCE4763642"); //타이틀
		model.addAttribute("titleSub", title);
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("BIZRID", param.get("MFC_BIZRID"));
		map.put("BIZRNO", param.get("MFC_BIZRNO"));
		List<?> brchList = commonceService.brch_nm_select(request, map);
		
		map.put("BIZR_TP_CD", param.get("BIZR_TP_CD"));
		map.put("DRCT_RTRVL_DT", param.get("DRCT_RTRVL_DT"));
		List<?> ctnrList = epce6645231Mapper.epce6645231_select5(map);
				
		try {

			model.addAttribute("excaStdMap", util.mapToJson(excaStdMap));
			model.addAttribute("brchList", util.mapToJson(brchList));
			model.addAttribute("ctnrList", util.mapToJson(ctnrList));
			model.addAttribute("searchDtl", util.mapToJson(epce4763601Mapper.epce4763642_select(param)));
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 직접회수정정 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4763601_select2(Map<String, String> data) {
		
		String MFC_BIZR = data.get("MFC_BIZR_SEL");
		String MFC_BRCH = data.get("MFC_BRCH_SEL");

		if(MFC_BIZR != null && !MFC_BIZR.equals("")){
			data.put("MFC_BIZRID", MFC_BIZR.split(";")[0]);
			data.put("MFC_BIZRNO", MFC_BIZR.split(";")[1]);
		}else{
			data.put("MFC_BIZRID", "");
			data.put("MFC_BIZRNO", "");
		}
		if(MFC_BRCH != null && !MFC_BRCH.equals("")){
			data.put("MFC_BRCH_ID", MFC_BRCH.split(";")[0]);
			data.put("MFC_BRCH_NO", MFC_BRCH.split(";")[1]);
		}else{
			data.put("MFC_BRCH_ID", "");
			data.put("MFC_BRCH_NO", "");
		}
		
		List<?> menuList = epce4763601Mapper.epce4763601_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
			//map.put("totalCnt", epce4763601Mapper.epce4763601_select_cnt(data));
			map.put("totalList", epce4763601Mapper.epce4763601_select_cnt(data));
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
	 * 직접회수정정 생산자선택시 
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4763601_select3(Map<String, String> data, HttpServletRequest request) {
		
		String BIZRID_NO = data.get("BIZRID_NO");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
			data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
		}else{
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
			data.put("MFC_BIZRID", "");
			data.put("MFC_BIZRNO", "");
		}
		
		List<?> brchList = commonceService.brch_nm_select(request, data);
		List<?> ctnrList = commonceService.ctnr_nm_select(request, data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("brchList", util.mapToJson(brchList));
			map.put("ctnrList", util.mapToJson(ctnrList));
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
	 * 직접회수정보 등록
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4763631_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		String ssUserId  = "";   //사용자ID
		
		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
		 		String doc_psnb_cd = "DC"; 				   								
		 		String doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 직접회수문서번호 조회
					
				for(int i=0; i<list.size(); i++){
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					//존재하는지 체크
					Map<String, String> checkMap = (Map<String, String>) epce6645231Mapper.epce6645231_select7(map);
					//확인필요
	
					if(checkMap != null && !checkMap.get("CUST_BIZRID").equals("") && !checkMap.get("CUST_BRCH_ID").equals("N") 
							&& !checkMap.get("CUST_BIZRNO").equals("")){ //사업자, 지점 둘다 등록상태
						
						//이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다.  즉  작성한 거래처명, 사업자유형은 무시함
						//errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
						map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID"));

					}else{

						//사업자데이터가 없을경우
						if(checkMap == null || (checkMap != null && checkMap.get("CUST_BIZRID").equals("")) ){ 
							
							String psnbSeq = commonceService.psnb_select("S0001"); //사업자ID 일련번호 채번
							map.put("CUST_BIZRID", "D2H"+psnbSeq); //사업자ID = 직접회수등록사업자(D2) - 수기(H)

							epce6645231Mapper.epce6645231_insert(map); //소매 사업자등록
							epce6645231Mapper.epce6645231_insert2(map); //소매 지점등록
						
						//지점데이터가 없을경우
						}else if(checkMap != null && checkMap.get("CUST_BRCH_ID").equals("N") ){ 
							
							map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID")); //조회된 사업자ID로 등록
							epce6645231Mapper.epce6645231_insert2(map); //소매 지점등록
						}
					}
					
					map.put("DRCT_RTRVL_CRCT_DOC_NO", doc_no);						//문서채번
					 
					map.put("EXCA_STD_CD", inputMap.get("EXCA_STD_CD").toString());
					
					/*정산기간 진행 체크*/
					int sel2 = epce4763601Mapper.epce4763631_select(map);
					if(sel2 < 1){
						 throw new Exception("A017");
					}
				 	
				 	/*중복체크*/
				 	int sel = epce4763601Mapper.epce4763631_select2(map);
					if(sel>0){
						throw new Exception("A014"); 
					}
					/*중복체크*/
				 	
					if(!map.containsKey("RMK")){
						map.put("RMK", "");
					}
					
				 	//detail
					epce4763601Mapper.epce4763631_insert(map); 	// 직접회수정정 등록
					 
				}//end of for
								
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				 if(e.getMessage().equals("A014") || e.getMessage().equals("A017") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		
		return errCd;
		
	}
	
	/**
	 * 직접회수정정 수정
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4763642_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception  {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		String ssUserId  = "";   //사용자ID
		
		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
		 		String doc_no = inputMap.get("DRCT_RTRVL_CRCT_DOC_NO").toString();
					
				for(int i=0; i<list.size(); i++){
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					//존재하는지 체크
					Map<String, String> checkMap = (Map<String, String>) epce6645231Mapper.epce6645231_select7(map);
					//확인필요

					if(checkMap != null && !checkMap.get("CUST_BIZRID").equals("") && !checkMap.get("CUST_BRCH_ID").equals("N") 
							&& !checkMap.get("CUST_BIZRNO").equals("")){ //사업자, 지점 둘다 등록상태
						
						//이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다.  즉  작성한 거래처명, 사업자유형은 무시함
						//errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
						map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID"));

					}else{

						//사업자데이터가 없을경우
						if(checkMap == null || (checkMap != null && checkMap.get("CUST_BIZRID").equals("")) ){ 
							
							String psnbSeq = commonceService.psnb_select("S0001"); //사업자ID 일련번호 채번
							map.put("CUST_BIZRID", "D2H"+psnbSeq); //사업자ID = 직접회수등록사업자(D2) - 수기(H)

							epce6645231Mapper.epce6645231_insert(map); //소매 사업자등록
							epce6645231Mapper.epce6645231_insert2(map); //소매 지점등록
						
						//지점데이터가 없을경우
						}else if(checkMap != null && checkMap.get("CUST_BRCH_ID").equals("N") ){ 
							
							map.put("CUST_BIZRID", checkMap.get("CUST_BIZRID")); //조회된 사업자ID로 등록
							epce6645231Mapper.epce6645231_insert2(map); //소매 지점등록
						}
					}
					
					map.put("DRCT_RTRVL_CRCT_DOC_NO", doc_no);						//문서채번
					 
					map.put("EXCA_STD_CD", inputMap.get("EXCA_STD_CD").toString());
					
					map.put("MFC_BIZRNO_KEY", inputMap.get("MFC_BIZRNO_KEY").toString()); //문서채번
					map.put("MFC_BRCH_NO_KEY", inputMap.get("MFC_BRCH_NO_KEY").toString()); //문서채번
					map.put("CUST_BIZRNO_KEY", inputMap.get("CUST_BIZRNO_KEY").toString()); //문서채번
					map.put("DRCT_RTRVL_DT_KEY", inputMap.get("DRCT_RTRVL_DT_KEY").toString()); //문서채번
					map.put("CTNR_CD_KEY", inputMap.get("CTNR_CD_KEY").toString()); //문서채번
					
					/*정산기간 진행 체크*/
					int sel2 = epce4763601Mapper.epce4763631_select(map);
					if(sel2 < 1){
						 throw new Exception("A017");
					}
				 	
					if(map.get("MFC_BIZRNO_KEY").equals(map.get("MFC_BIZRNO")) && map.get("MFC_BRCH_NO_KEY").equals(map.get("MFC_BRCH_NO"))
							&& map.get("CUST_BIZRNO_KEY").equals(map.get("CUST_BIZRNO")) && map.get("DRCT_RTRVL_DT_KEY").equals(map.get("DRCT_RTRVL_DT").replace("-",""))	
							&& map.get("CTNR_CD_KEY").equals(map.get("CTNR_CD"))	
						  )
						{//키값에 변동없으면 중복체크 안함
						}else{
						 	/*중복체크*/
						 	int sel = epce4763601Mapper.epce4763631_select2(map);
							if(sel>0){
								throw new Exception("A014"); 
							}
							/*중복체크*/
						}
					
					if(!map.containsKey("RMK")){
						map.put("RMK", "");
					}
					
				 	//detail
					epce4763601Mapper.epce4763642_update(map); 	// 직접회수정정 수정
					 
				}//end of for
								
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				 if(e.getMessage().equals("A014") || e.getMessage().equals("A017") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
		}//end of list
		
		return errCd;
		
	}
	
	/**
	 * 직접회수정정 삭제
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4763601_delete(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));

		String ssUserId  = "";   //사용자ID

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				for(int i=0; i<list.size(); i++){

					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					epce4763601Mapper.epce4763601_delete(map); //출고정정 삭제

				}//end of for
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}//end of list
		return errCd;
		
	}
	
	/**
	 * 직접회수정정 상태변경
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4763601_update(Map<String, Object> inputMap, HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		String stat_cd = inputMap.get("DRCT_RTRVL_CRCT_STAT_CD").toString();

		String ssUserId  = "";   //사용자ID

		if (list != null) {
			try {
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				for(int i=0; i<list.size(); i++){

					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					map.put("DRCT_RTRVL_CRCT_STAT_CD", stat_cd);
					
					epce4763601Mapper.epce4763601_update(map); //출고정정 수정

				}//end of for
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}//end of list
		return errCd;
		
	}
	
	/**
	 * 엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce4763601_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
				
			String MFC_BIZR = data.get("MFC_BIZR_SEL");
			String MFC_BRCH = data.get("MFC_BRCH_SEL");

			if(MFC_BIZR != null && !MFC_BIZR.equals("")){
				data.put("MFC_BIZRID", MFC_BIZR.split(";")[0]);
				data.put("MFC_BIZRNO", MFC_BIZR.split(";")[1]);
			}else{
				data.put("MFC_BIZRID", "");
				data.put("MFC_BIZRNO", "");
			}
			if(MFC_BRCH != null && !MFC_BRCH.equals("")){
				data.put("MFC_BRCH_ID", MFC_BRCH.split(";")[0]);
				data.put("MFC_BRCH_NO", MFC_BRCH.split(";")[1]);
			}else{
				data.put("MFC_BRCH_ID", "");
				data.put("MFC_BRCH_NO", "");
			}
			
			data.put("excelYn", "Y");
			List<?> list = epce4763601Mapper.epce4763601_select(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			return  "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}
