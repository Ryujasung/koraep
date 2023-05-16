package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0160101Mapper;

@Service("epce0160116Service")
public class EPCE0160116Service {
	
	@Resource(name="epce0160101Mapper")
	private EPCE0160101Mapper epce0160101Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil EgovFileMngUtil;
	
	/**
	 * 사업자상세 기초데이터 조회
	 * @param model
	 * @param request 
	 * @return
	 * @
	 */
//	@SuppressWarnings("unchecked")
//	public ModelMap epce0160116_select(ModelMap model, HttpServletRequest request)  {
//			
//		//세션정보 가져오기
//		HttpSession session = request.getSession();
//		UserVO uvo = (UserVO)session.getAttribute("userSession");
//		String ssBizrno = uvo.getBIZRNO();
//	
//		Map<String, String> map = new HashMap<String, String>();
//		
//		String sBizrno = util.null2void(request.getParameter("BIZRNO"), ssBizrno);
//		String sCallPg = util.null2void(request.getParameter("CALL_PG"));
		
//		map.put("BIZRNO", sBizrno);
		
		//상세조회 정보
//		HashMap<String, String> rsltMap = (HashMap<String, String>) epce0160101Mapper.epce0160116_select(map);
//		rsltMap.put("CALL_PG", sCallPg);
		
//		model.addAttribute("dtlSearch", util.mapToJson(rsltMap));

		//페이지이동 조회조건 파라메터 정보
//		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"), "{}");
//		JSONObject jParams = JSONObject.fromObject(reqParams);
//
//		model.addAttribute("INQ_PARAMS",jParams);
//		
//		return model;
//	}
	
	/**
	 * 사업자정보관리 가입/변경요청 승인
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@SuppressWarnings("unchecked")
	@Transactional
	public String epce0160116_update(Map<String, String> data, HttpServletRequest request)  {

		//세션정보 가져오기
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO)session.getAttribute("userSession");
		
		String rtnMsg = "";
		String rtnCd  = "9999";
		
		data.put("UPD_PRSN_ID", uvo.getUSER_ID());

		if(data.get("ALT_REQ_STAT_CD").equals("5")){ //반송
			epce0160101Mapper.epce0160116_update2(data);
		}else{
			epce0160101Mapper.epce0160116_update(data);
		}

		//사업장 변경정보 이력등록
		epce0160101Mapper.epce0160131_insert2(data);	

		rtnCd  = "0000";

		return rtnCd;
	}
	
	/**
	 * 사업자정보관리 가입요청 반송
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@SuppressWarnings("unchecked")
	@Transactional
	public String epce0160116_delete(Map<String, String> data, HttpServletRequest request)  {
		
		String rtnMsg = "";
		String rtnCd  = "0000";
		
		HashMap<String, String> dtlMap = (HashMap<String, String>) epce0160101Mapper.epce0160116_select(data);
		if(!(dtlMap.get("ALT_REQ_STAT_CD")).equals("1")){
			rtnMsg = "가입요청 반송 대상이 아닙니다.";
			rtnCd  = "9999";
		}
		
		if(rtnCd.equals("0000")){
//			epce0160101Mapper.DELETE_EPCN_GRP_USER(data);			//사업자 권한그룹 삭제
//			epce0160101Mapper.DELETE_EPCN_BSNM_INFO_FILE(data);	//사업자 첨부파일 삭제
//			epce0160101Mapper.DELETE_EPCN_BSNM_CTRT_FILE(data);	//생산자계약서 첨부파일 삭제
//			epce0160101Mapper.DELETE_EPCN_USER_ALT_HIST(data);		//사용자변경이력 삭제
//			epce0160101Mapper.DELETE_EPCN_USER_INFO(data);			//사용자정보 삭제
//			epce0160101Mapper.DELETE_EPCN_WHSLD_DTSS_INFO(data);	//직매장정보 삭제
//			epce0160101Mapper.DELETE_EPCN_BSNM_ALT_HIST(data);		//사업자변경이력 삭제
//			epce0160101Mapper.DELETE_EPCN_BSNM_INFO(data);			//사업자정보 삭제
			
			try {
				//기존파일 삭제
				String sFileNm = data.get("FILE_NM");
				if(!sFileNm.equals("")){
					EgovFileMngUtil efmu = new EgovFileMngUtil();
					efmu.deleteBizFile(sFileNm);
				}
				String sCtrtFileNm = data.get("CTRT_FILE_NM");
				if(!sCtrtFileNm.equals("")){
					EgovFileMngUtil efmu = new EgovFileMngUtil();
					efmu.deleteBizFile(sCtrtFileNm);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}

			rtnMsg = "정상적으로 처리되었습니다.";
			rtnCd  = "0000";
		}
		
		HashMap<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("rtnMsg",rtnMsg);
		rtnMap.put("rtnCd", rtnCd);
		
		return util.mapToJson(rtnMap).toString();
	}
	
	/**
	 * 사업자정보 삭제
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@SuppressWarnings("unchecked")
	@Transactional
	public String epce0160116_delete2(Map<String, String> data, HttpServletRequest request) throws Exception  {
		
		String rtnCd  = "0000";
		
		//사용자 데이터 여부 체크
		int chk = epce0160101Mapper.epce0160116_select2(data);
		if(chk > 0){
			return "B019"; // 해당 사업자 사용자가 존재합니다.
		}
		
		//첨부파일 DB 삭제
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("BIZRID", data.get("BIZRID"));
		map.put("BIZRNO", data.get("BIZRNO_DE"));
		
		if(data.get("FILE_NM") != null && !data.get("FILE_NM").equals("")){
			epce0160101Mapper.epce0160116_delete2(map);
		}
		
		if(data.get("CTRT_FILE_NM") != null && !data.get("CTRT_FILE_NM").equals("")){
			epce0160101Mapper.epce0160116_delete(map);
		}
		
		try {	

			//지점 삭제
			epce0160101Mapper.epce0160116_delete3(data);
			
			//사업자 삭제
			epce0160101Mapper.epce0160116_delete4(data);
		} catch (Exception e) {
			rtnCd = "B018";
			/*e.printStackTrace();*/
			throw new Exception("B018"); // 해당 사업자정보의 업무데이터가 존재합니다.
		}
		
		//첨부파일 삭제
		String sFileNm = util.null2void(data.get("FILE_NM"));
		if(!("").equals(sFileNm)){
			EgovFileMngUtil efmu = new EgovFileMngUtil();
			efmu.deleteBizFile(sFileNm);
		}
		
		String sCtrtFileNm = util.null2void(data.get("CTRT_FILE_NM"));
		if(!("").equals(sCtrtFileNm)){
			EgovFileMngUtil efmu = new EgovFileMngUtil();
			efmu.deleteBizFile(sCtrtFileNm);
		}
		
		return rtnCd;
	}
	
	/**
	 * 사업자정보관리 사업자정보 변경
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
//	@SuppressWarnings("unchecked")
	public ModelMap epce0160142_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPCE0160142");
		model.addAttribute("titleSub", title);

		List<?> BankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
		model.addAttribute("BankCdList", util.mapToJson(BankCdList));
		
		List<?> ErpCdList = commonceService.getCommonCdListNew("S022");//ERP코드리스트
		model.addAttribute("ErpCdList", util.mapToJson(ErpCdList));
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		HashMap<String, String> smap = (HashMap<String, String>)epce0160101Mapper.epce0160116_select(map);
		
		model.addAttribute("searchDtl", util.mapToJson(smap));

		return model;
	}
	
	
	/**
	 * 사업자 정보 변경 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce0160142_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				//크로스 사이트 스크립트 수정 후 변경
//				MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
				MultipartHttpServletRequest mptRequest = WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
				String ssUserId = "";
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				data.put("S_USER_ID", ssUserId);
				
				if(data.containsKey("BIZRNM_CHANGE_YN") && data.get("BIZRNM_CHANGE_YN").equals("Y")){ //사업자명 변경시 ERP사업자코드 변경
					//ERP사업자코드 채번
					String erpBizrCd = "2" + commonceService.psnb_select("S0002"); 
					data.put("ERP_BIZR_CD", erpBizrCd); //ERP사업자코드
					
					//지점테이블 사업자명 변경
					epce0160101Mapper.epce0160142_update2(data);
					
					//직매장별거래처정보 사업자명 변경
					epce0160101Mapper.epce0160142_update3(data);
					
					data.put("ALT_REQ_STAT_CD", "2"); //사업자정보변경
				}else{
					if(data.containsKey("RPST_NM_CHANGE_YN") && data.get("RPST_NM_CHANGE_YN").equals("Y")){ //대표자명 변경시
						if(data.get("SIGN_GUBN").equals("1")){ //인증서
							data.put("ALT_REQ_STAT_CD", "3"); //대표자명변경(인증서 검증)
						}else if(data.get("SIGN_GUBN").equals("2")){ //휴대폰인증
							data.put("ALT_REQ_STAT_CD", "4"); //대표자명변경(휴대폰 인증)
						}
					}else if(data.containsKey("SIGN_GUBN") && data.get("SIGN_GUBN").equals("2")){ //휴대폰인증
						data.put("ALT_REQ_STAT_CD", "2"); //사업자정보변경
					}
				}
								
				//사업자정보 변경
				epce0160101Mapper.epce0160142_update(data);
				
				HashMap<String, String> hmap = new HashMap<String, String>(); 
				hmap.put("BIZRID", data.get("BIZRID"));
				hmap.put("BIZRNO", data.get("BIZRNO_DE"));
				//사업장 변경정보 이력등록
				epce0160101Mapper.epce0160131_insert2(hmap);	
				
				//사업자 등록증 등록
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
						} catch (Exception e) {
							// TODO Auto-generated catch block
							org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
						}	//파일저장
				    	SAVE_FILE_NM = (String)map2.get("uploadFileName");
				    	FILE_NM      = (String)map2.get("originalFileName");
				    	FILE_PATH    = (String)map2.get("filePath");
				    	
				    	HashMap<String, String> fileMap = new HashMap<String, String>(); 
						fileMap.put("BIZRID", data.get("BIZRID"));
						fileMap.put("BIZRNO", data.get("BIZRNO_DE"));
						fileMap.put("FILE_NM", FILE_NM);
						fileMap.put("SAVE_FILE_NM", SAVE_FILE_NM);
						fileMap.put("FILE_PATH", FILE_PATH);
						fileMap.put("REG_PRSN_ID", ssUserId);

						if(nRow == 0){
							if(!FILE_NM.equals("")){
								epce0160101Mapper.epce0160116_delete2(fileMap);
								epce0160101Mapper.epce0160131_insert3(fileMap);
							}
						}else{
							if(!FILE_NM.equals("")){
								epce0160101Mapper.epce0160116_delete(fileMap);
								epce0160101Mapper.epce0160131_insert4(fileMap);
							}
						}
						
					}
					
					nRow++;
					
				}
				
			    	
		}catch(Exception e){
			 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
	
}