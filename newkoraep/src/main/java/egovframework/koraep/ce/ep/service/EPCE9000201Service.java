package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import egovframework.common.AES256Util;
import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0140101Mapper;
import egovframework.mapper.ce.ep.EPCE9000201Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("epce9000201Service")
public class EPCE9000201Service {

	@Resource(name="epce9000201Mapper")
	private EPCE9000201Mapper epce9000201Mapper;

	@Resource(name="epce0140101Mapper")
	private EPCE0140101Mapper epce0140101Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 사업자관리 기초데이터 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000201_select(ModelMap model, HttpServletRequest request)  {
		//세션정보 가져오기
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO)session.getAttribute("userSession");
		String ssBizrno = uvo.getBIZRNO();		//사업자번호

		List<?> lang_Se_CD = commonceService.getLangSeCdList();
		List<?> BizrTpCdList = commonceService.getCommonCdListNew("B001");
		List<?> AreaCdList = commonceService.getCommonCdListNew("B010");
		List<?> AffOgnCdList = commonceService.getCommonCdListNew("B004");
		List<?> AtlReqStatCdList = commonceService.getCommonCdListNew("B003");
		List<?> BizrStatCdList = commonceService.getCommonCdListNew("B007");
		List<?> ErpCdList = commonceService.getCommonCdListNew("S022");
		String title = commonceService.getMenuTitle("EPCE9000201");
		Map<String, String> map= new HashMap<String, String>();
		List<?>	rcs_list = rcs_select(request, map);    			//도매업자 업체명조회

		try {
//			model.addAttribute("initList", util.mapToJson(initList));
			model.addAttribute("langSeList", util.mapToJson(lang_Se_CD));
			model.addAttribute("BizrTpCdList", util.mapToJson(BizrTpCdList));
			model.addAttribute("AreaCdList", util.mapToJson(AreaCdList));
			model.addAttribute("AffOgnCdList", util.mapToJson(AffOgnCdList));
			model.addAttribute("AtlReqStatCdList", util.mapToJson(AtlReqStatCdList));
			model.addAttribute("BizrStatCdList", util.mapToJson(BizrStatCdList));
			model.addAttribute("ErpCdList", util.mapToJson(ErpCdList));
			model.addAttribute("rcs_list", util.mapToJson(rcs_list));
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
		model.addAttribute("titleSub", title);

		//로그인 사업자번호
		HashMap<String, String> mapBizno = new HashMap<String, String>();
		mapBizno.put("BIZRNO", ssBizrno);
		model.addAttribute("searchBizrno", util.mapToJson(mapBizno));

		//조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}

	 /**
	 *	 도매업자 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> rcs_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		List<?> selList=null;
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 도매업자 일경우
			selList = epce9000201Mapper.rcs_select((HashMap<String, String>) map);
		
		return selList;
	}
	/**
	 * 사업자관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce9000201_select2(Map<String, String> data, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null){
			data.put("T_USER_ID", vo.getUSER_ID());
		}

		List<?> list = epce9000201Mapper.epce9000201_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
			//map.put("totalCnt", epce9000201Mapper.epce9000201_select2_cnt(data));
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
	 * 사업자관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce9000201_excel(HashMap<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			
			data.put("excelYn", "Y");
			List<?> list = epce9000201Mapper.epce9000201_select4(data);

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
	 * 사업자등록화면 페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000231_select(ModelMap model, HttpServletRequest request)  {
		
//		List<?> BizrStatList = commonceService.getCommonCdListNew("B002");//사업자구분
//		List<?> BizrTpList = commonceService.getCommonCdListNew("B001");//사업자유형
		List<?> BankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
		Map<String, String> map= new HashMap<String, String>();
		//List<?>	whsdlList 		=mfc_bizrnm_select4(request, map);    			//도매업자 업체명조회
		List<?>	whsdlList = commonceService.whsdl_select(map);   
		
//		String title = commonceService.getMenuTitle("EPCE9000231");
		
		try {
//			model.addAttribute("titleSub", title);
//			model.addAttribute("BizrStatList", util.mapToJson(BizrStatList));
//			model.addAttribute("BizrTpList", util.mapToJson(BizrTpList));
			model.addAttribute("whsdlList", util.mapToJson(whsdlList));
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
		
		
		//조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
		
	}
	/**
	 *	 도매업자 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> mfc_bizrnm_select4(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		List<?> selList=null;
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 센터
		if(uvo.getBIZR_TP_CD().equals("T1") ){
			map.put("T_USER_ID", uvo.getUSER_ID());
		}
		//로그인자가 생산자일경우
		else if(uvo.getBIZR_TP_CD().equals("M1")||uvo.getBIZR_TP_CD().equals("M2")){
			map.put("MFC_BIZRID", uvo.getBIZRID());  					// 사업자ID
			map.put("MFC_BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
			//로그인자가 본사가 아닌경우 본사인경우 모든 직매장 보여야한다.
			if(!uvo.getBRCH_NO().equals("9999999999") ){
				map.put("S_BRCH_ID", uvo.getBRCH_ID());  			// 지점ID
				map.put("S_BRCH_NO", uvo.getBRCH_NO());  			// 지점번호
			}
		}
		
		//로그인자가 도매업자 일경우
		if(uvo.getBIZR_TP_CD().equals("W1")||uvo.getBIZR_TP_CD().equals("W2")){
			map.put("BIZRID", uvo.getBIZRID());  					// 사업자ID
			map.put("BIZRNO", uvo.getBIZRNO_ORI());  			// 사업자번호
			//selList = commonceMapper.whsdl_select((Map<String, String>) map);//도매업자일경우
		}
		else{
			selList = epce9000201Mapper.mfc_bizrnm_select4((HashMap<String, String>) map);
		}
		
		return selList;
	}
	
	/**
	 * 사업자등록화면 페이지
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000242_select(ModelMap model, HttpServletRequest request)  {
		
		//조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> BankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		List<?>	whsdl_cd_list 			= commonceService.whsdl_select(map);    				//도매업자 업체명조회
		try {
			model.addAttribute("BankCdList", util.mapToJson(BankCdList));
			model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	
			model.addAttribute("searchDtl", util.mapToJson(epce9000201Mapper.epce9000242_select(map)));
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
	 * @throws Exception 
	 * 반환수집소등록
	 * @param 
	 * @param 
	 * @throws 
	 */
	@SuppressWarnings("unused")
	@Transactional
	public String epce9000231_insert(HttpServletRequest request, String corpState) throws Exception  {
		
			String errCd = "0000";
		
			try {
					
				//세션정보 가져오기
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO)session.getAttribute("userSession");
				String ssUserId   = uvo.getUSER_ID();		//세션사용자ID
				
//				AES256Util aes = null;
//				try {
//					aes = new AES256Util();
//				} catch (UnsupportedEncodingException e) {
//					// TODO Auto-generated catch block
//					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
//				}
				//크로스 사이트 스크립트
//				MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
				MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
				
				Map<String, String> map = new HashMap<String, String>();
				
//				String BIZRNO = mptRequest.getParameter("BIZRNO1") + mptRequest.getParameter("BIZRNO2") + mptRequest.getParameter("BIZRNO3");
				
				
				
//				String CNTR_DT = util.getShortDateString();
				
//				String BIZR_ISSU_KEY = BIZRNO + "|" +CNTR_DT + "|" + mptRequest.getParameter("BIZR_TP_CD") + "|" + mptRequest.getParameter("USER_ID");	
//				try {
//					if(aes == null) throw new UnsupportedEncodingException();
//					map.put("BIZR_ISSU_KEY", aes.encrypt(BIZR_ISSU_KEY));
//				} catch (UnsupportedEncodingException | GeneralSecurityException e) {
//					// TODO Auto-generated catch block
//					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
//				}
//				map.put("BIZR_TP_CD", mptRequest.getParameter("BIZR_TP_CD"));
//				map.put("ADMIN_ID",mptRequest.getParameter("ADMIN_ID"));
				
				String sUserId   = uvo.getUSER_ID();
				
				//사업자 등록정보 셋팅
//				String psnbSeq = commonceService.psnb_select("S0001");
				String RCS_NM = util.null2void(mptRequest.getParameter("RCS_NM"));
				map.put("RCS_NM", util.null2void(mptRequest.getParameter("RCS_NM")));
				map.put("RCS_BIZR_CD", util.null2void(mptRequest.getParameter("RCS_BIZR_CD")));
				map.put("URM_YN", util.null2void(mptRequest.getParameter("URM_YN")));
				map.put("WHSDL_BIZRNM", util.null2void(mptRequest.getParameter("WHSDL_BIZRNM")));
				map.put("WHSDL_BIZRNO", util.null2void(mptRequest.getParameter("WHSDL_BIZRNO")).replaceAll("-", ""));
				map.put("ACP_BANK_CD", util.null2void(mptRequest.getParameter("AcpBankCdList_SEL")));
				map.put("ACP_ACCT_NO", util.null2void(mptRequest.getParameter("ACP_ACCT_NO")));
				map.put("AREA_CD", util.null2void(mptRequest.getParameter("AreaCdList_SEL")));
				map.put("PNO", util.null2void(mptRequest.getParameter("PNO")));
				map.put("ADDR1", util.null2void(mptRequest.getParameter("ADDR1")));
				map.put("ADDR2", util.null2void(mptRequest.getParameter("ADDR2")));
				map.put("START_DT", util.null2void(mptRequest.getParameter("from")).replaceAll("-", ""));
				map.put("END_DT", util.null2void(mptRequest.getParameter("to")).replaceAll("-", ""));
				
				map.put("MN_TEL", util.null2void(mptRequest.getParameter("MN_TEL")));
				map.put("MN_HTEL", util.null2void(mptRequest.getParameter("MN_HTEL")));
				map.put("LOC_GOV", util.null2void(mptRequest.getParameter("LOC_GOV")));
				map.put("LOC_NM", util.null2void(mptRequest.getParameter("LOC_NM")));
				map.put("LOC_TEL", util.null2void(mptRequest.getParameter("LOC_TEL")));
				map.put("LOC_HTEL", util.null2void(mptRequest.getParameter("LOC_HTEL")));
				map.put("LOC_EMAIL", util.null2void(mptRequest.getParameter("LOC_EMAIL")));
				map.put("REG_PRSN_ID", uvo.getUSER_ID());
				
				
				epce9000201Mapper.epce9000231_insert(map);		//반환수집소 정보 등록
				
				
				//계약서 등록
				String FILE_NM = "";
				String SAVE_FILE_NM = "";
				String FILE_PATH = "";
		    	Iterator fileIter = mptRequest.getFileNames();
		    	int nRow = 0;
				while (fileIter.hasNext()) {
					MultipartFile mFile = mptRequest.getFile((String)fileIter.next());
					
					if (mFile.getSize() > 0) {
				    	HashMap map2 = new HashMap();
						try {
							map2 = EgovFileMngUtil.uploadBizFile(mFile);
						}catch (IOException io) {
							System.out.println(io.toString());
						}catch (SQLException sq) {
							System.out.println(sq.toString());
						}catch (NullPointerException nu){
							System.out.println(nu.toString());
						} catch (Exception e) {
							// TODO Auto-generated catch block
							org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
						}	//파일저장
				    	SAVE_FILE_NM = (String)map2.get("uploadFileName");
				    	FILE_NM      = (String)map2.get("originalFileName");
				    	FILE_PATH    = (String)map2.get("filePath");
				    	
				    	HashMap<String, String> fileMap = new HashMap<String, String>(); 
				    	fileMap.put("RCS_NM", RCS_NM);
						fileMap.put("FILE_NM", FILE_NM);
						fileMap.put("SAVE_FILE_NM", SAVE_FILE_NM);
						fileMap.put("FILE_PATH", FILE_PATH);
						fileMap.put("REG_PRSN_ID", uvo.getUSER_ID());

							if(!FILE_NM.equals("")){
								epce9000201Mapper.epce9000231_insert3(fileMap);
							}
						
					}
					
					nRow++;
					
				}
				
				//메뉴권한 부여 필요..
				
				//메뉴권한그룹 등록
//				HashMap<String, String> map3 = new HashMap<String, String>();
//				map3.put("BIZRID", BIZRID);
//				map3.put("BIZRNO", BIZRNO);
//				map3.put("ATH_GRP_CD", mptRequest.getParameter("BIZR_SE_CD") + "01");	//관리자
//				map3.put("USER_ID", uvo.getUSER_ID());
//				map3.put("S_USER_ID", sUserId);
//				map3.put("REG_PRSN_ID", sUserId);
//				map3.put("S_USER_ID", "");
//				if(uvo != null){
//					map3.put("S_USER_ID", uvo.getUSER_ID());
//				}
//				epce0140101Mapper.epce0140188_update(map3);
				
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
	
	/**
	 * @throws Exception 
	 * 반환수집소수정
	 * @param 
	 * @throws 
	 */
	@SuppressWarnings("unused")
	@Transactional
	public String epce9000242_insert(HttpServletRequest request, String corpState) throws Exception  {
		
			String errCd = "0000";
		
			try {
					
				//세션정보 가져오기
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO)session.getAttribute("userSession");
				String ssUserId   = uvo.getUSER_ID();		//세션사용자ID
				
				
//				MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
				MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
				
				Map<String, String> map = new HashMap<String, String>();
				
				
				String sUserId   = uvo.getUSER_ID();
				
				// 등록정보 셋팅
				String RCS_NM = util.null2void(mptRequest.getParameter("RCS_NM"));
				String RCS_NO = util.null2void(mptRequest.getParameter("RCS_NO"));
				map.put("RCS_NO", util.null2void(mptRequest.getParameter("RCS_NO")));
				map.put("RCS_NM", util.null2void(mptRequest.getParameter("RCS_NM")));
				map.put("RCS_BIZR_CD", util.null2void(mptRequest.getParameter("RCS_BIZR_CD")));
				map.put("URM_YN", util.null2void(mptRequest.getParameter("URM_YN")));
				String str = util.null2void(mptRequest.getParameter("WHSDL_BIZRNM"));
				String result = str.substring(str.lastIndexOf(";")+1);
				map.put("WHSDL_BIZRNM", result);
				map.put("WHSDL_BIZRNO", util.null2void(mptRequest.getParameter("WHSDL_BIZRNO")));
				map.put("ACP_BANK_CD", util.null2void(mptRequest.getParameter("AcpBankCdList_SEL")));
				map.put("ACP_ACCT_NO", util.null2void(mptRequest.getParameter("ACP_ACCT_NO")));
				map.put("AREA_CD", util.null2void(mptRequest.getParameter("AreaCdList_SEL")));
				map.put("PNO", util.null2void(mptRequest.getParameter("PNO")));
				map.put("ADDR1", util.null2void(mptRequest.getParameter("ADDR1")));
				map.put("ADDR2", util.null2void(mptRequest.getParameter("ADDR2")));
				map.put("START_DT", util.null2void(mptRequest.getParameter("from")).replaceAll("-", ""));
				map.put("END_DT", util.null2void(mptRequest.getParameter("to")).replaceAll("-", ""));
				
				map.put("MN_TEL", util.null2void(mptRequest.getParameter("MN_TEL")));
				map.put("MN_HTEL", util.null2void(mptRequest.getParameter("MN_HTEL")));
				map.put("LOC_GOV", util.null2void(mptRequest.getParameter("LOC_GOV")));
				map.put("LOC_NM", util.null2void(mptRequest.getParameter("LOC_NM")));
				map.put("LOC_TEL", util.null2void(mptRequest.getParameter("LOC_TEL")));
				map.put("LOC_HTEL", util.null2void(mptRequest.getParameter("LOC_HTEL")));
				map.put("LOC_EMAIL", util.null2void(mptRequest.getParameter("LOC_EMAIL")));
				map.put("REG_PRSN_ID", uvo.getUSER_ID());
				map.put("selectCust", util.null2void(mptRequest.getParameter("selectCust")));
				System.out.println("###################"+util.null2void(mptRequest.getParameter("selectCust")));
				
				
				
				epce9000201Mapper.epce9000242_insert(map);		//반환수집소 정보 등록
				
				
				//계약서 등록
				String FILE_NM = "";
				String SAVE_FILE_NM = "";
				String FILE_PATH = "";
		    	Iterator fileIter = mptRequest.getFileNames();
		    	int nRow = 0;
		    	System.out.println("@@@@@@@@@@1");
				while (fileIter.hasNext()) {
					MultipartFile mFile = mptRequest.getFile((String)fileIter.next());
					System.out.println("@@@@@@@@@@2");
					if (mFile.getSize() > 0) {
						System.out.println("@@@@@@@@@@3");
				    	HashMap map2 = new HashMap();
						try {
							map2 = EgovFileMngUtil.uploadBizFile(mFile);
						}catch (IOException io) {
							System.out.println(io.toString());
						}catch (SQLException sq) {
							System.out.println(sq.toString());
						}catch (NullPointerException nu){
							System.out.println(nu.toString());
						} catch (Exception e) {
							// TODO Auto-generated catch block
							org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
						}	//파일저장
				    	SAVE_FILE_NM = (String)map2.get("uploadFileName");
				    	FILE_NM      = (String)map2.get("originalFileName");
				    	FILE_PATH    = (String)map2.get("filePath");
				    	
				    	HashMap<String, String> fileMap = new HashMap<String, String>(); 
				    	
				    	fileMap.put("RCS_NO", RCS_NO);
				    	fileMap.put("RCS_NM", RCS_NM);
						fileMap.put("FILE_NM", FILE_NM);
						fileMap.put("SAVE_FILE_NM", SAVE_FILE_NM);
						fileMap.put("FILE_PATH", FILE_PATH);
						fileMap.put("REG_PRSN_ID", uvo.getUSER_ID());

							if(!FILE_NM.equals("")){
								System.out.println("@@@@@@@@@@4");
								epce9000201Mapper.epce9000242_insert3(fileMap);
							}
						
					}
					
					nRow++;
					
				}
				
				//메뉴권한 부여 필요..
				
				//메뉴권한그룹 등록
//				HashMap<String, String> map3 = new HashMap<String, String>();
//				map3.put("BIZRID", BIZRID);
//				map3.put("BIZRNO", BIZRNO);
//				map3.put("ATH_GRP_CD", mptRequest.getParameter("BIZR_SE_CD") + "01");	//관리자
//				map3.put("USER_ID", uvo.getUSER_ID());
//				map3.put("S_USER_ID", sUserId);
//				map3.put("REG_PRSN_ID", sUserId);
//				map3.put("S_USER_ID", "");
//				if(uvo != null){
//					map3.put("S_USER_ID", uvo.getUSER_ID());
//				}
//				epce0140101Mapper.epce0140188_update(map3);
				
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
	
	/**
	 * 사업자관리 활동/비활동처리
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional
	public String epce9000201_updateData3(Map<String, String> data, HttpServletRequest request) throws Exception  {

		String errCd = "0000";
		String sUserId = "";


		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();
				//String ssBizrno = vo.getBIZRNO();
				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		map.put("S_USER_ID", sUserId);
			    		//map.put("BIZRNO", ssBizrno);
			    		map.put("BIZR_STAT_CD", data.get("gGubn").equals("A")?"Y":"N");

			    		epce9000201Mapper.epce9000201_update3(map);

			    		//사용자변경이력등록
			    		epce9000201Mapper.epce9000231_insert2(map);
//			    		epce0140101Mapper.epce0140101_insert(map);
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
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

	/**
	 * 사업자관리 휴폐업 상태 업데이트
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	@Transactional
	public String epce9000201_updateData4(Map<String, String> data, HttpServletRequest request) throws Exception  {

		String errCd = "0000";
		String sUserId = "";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				if(vo != null){
					sUserId = vo.getUSER_ID();
				}
				data.put("S_USER_ID", sUserId);

				epce9000201Mapper.epce9000201_update7(data);

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

	/**
	 * 사용자변경이력 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce900020118_select(ModelMap model) {

		String title = commonceService.getMenuTitle("EPCE9000201_1");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 사업자변경이력 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce900020118_select2(Map<String, String> data)  {

		List<?> menuList = epce9000201Mapper.epce9000201_select5(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
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
	 * 사업자상세 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000216_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE9000216");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		model.addAttribute("searchDtl", util.mapToJson(epce9000201Mapper.epce9000216_select(map)));

		return model;
	}

	/**
	 * 지급제외설정 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000217_select(ModelMap model, HttpServletRequest request) {
		try {
			String title = commonceService.getMenuTitle("EPCE9000217");//타이틀
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
	 * 지급제외설정 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce9000217_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		try {
			inputMap.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
			epce9000201Mapper.epce9000217_update(inputMap);//상태변경
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch (Exception e) {
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
    }

	/**
	 * 사업자상세조회2
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce9000216_select2(Map<String, String> data) {

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("searchDtl", util.mapToJson(epce9000201Mapper.epce9000216_select(data)));

		return map;
	}
	/**
	 * 관리자변경 팝업호출
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce90002018_1_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE90002018_1");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 단체 설정 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000288(ModelMap model, HttpServletRequest request) {
		try {
			List<?> aff_ogn_cd_list = commonceService.getCommonCdListNew("B004");//소속단체
			String title = commonceService.getMenuTitle("EPCE9000288");//타이틀
			model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));
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
	 * 단체 설정 저장
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce9000288_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if (list != null) {
			try {
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					map.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
					epce9000201Mapper.epce9000288_update(map);//상태변경
				}
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch (Exception e) {
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}

		return errCd;
    }

	/**
	 * 관리자등록
	 * @param map
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce90002018_1_update4(HashMap<String, String> data, HttpServletRequest request, ModelMap model) throws Exception{

		String errCd = "0000";

		try {
				//세션정보 가져오기
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO)session.getAttribute("userSession");
				String ssUserId   = uvo.getUSER_ID();		//세션사용자ID

				String idCheck = epce9000201Mapper.epce9000216_select6(data);

				if(idCheck != null && idCheck.equals("Y")){
					throw new Exception("B006"); //해당 사업자의 관리자 아이디가 활동 상태입니다. \n회원탈퇴 후 등록이 가능합니다.
				}

				if(uvo != null){
					data.put("REG_PRSN_ID", uvo.getUSER_ID());
					data.put("S_USER_ID", uvo.getUSER_ID());
				}

				//관리자 변경
				//data.put("USER_SE_CD", "D"); //사용자구분코드 관리자로 변경
				//epce0140101Mapper.epce0140101_update2(data); //사용자구분코드 관리자로 변경
				data.put("USER_PWD", util.encrypt("12345678"));
				data.put("USER_STAT_CD", "Y");
				data.put("CET_BRCH_CD", "");
				epce9000201Mapper.epce9000231_insert7(data);  //담당자 등록
				//사용자정보 변경이력등록
				epce0140101Mapper.epce0140101_insert(data);

				//사업자정보 관리자변경
				epce9000201Mapper.epce9000201_update4(data);
				//사업자정보 변경이력등록
				epce9000201Mapper.epce9000231_insert2(data);

				//메뉴권한 부여 필요..

		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			if(e.getMessage().equals("B006") ){
				 throw new Exception(e.getMessage());
			 }else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			 }
		}
		return errCd;

	}


}