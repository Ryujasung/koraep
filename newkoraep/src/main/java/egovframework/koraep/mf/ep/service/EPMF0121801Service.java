package egovframework.koraep.mf.ep.service;

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
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.mf.ep.EPMF0121801Mapper;

/**
 * 직매장별거래처관리 서비스
 * @author Administrator
 *
 */
@Service("epmf0121801Service")
public class EPMF0121801Service {

	@Resource(name="epmf0121801Mapper")
	private EPMF0121801Mapper epmf0121801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf0121801_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("BIZR_TP_CD","W1");//도매업자
		List<?> bizrList = commonceService.bizr_select(map);
		
		List<?> areaList = commonceService.getCommonCdListNew("B010");//지역
		List<?> statList = commonceService.getCommonCdListNew("S011");//거래여부
		List<?> bizrTpList = epmf0121801Mapper.epmf0121801_select();//거래처구분
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList)); //도매업자
			model.addAttribute("areaList", util.mapToJson(areaList));
			model.addAttribute("statList", util.mapToJson(statList));
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
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
	public HashMap<String, Object> epmf0121801_select2(Map<String, String> data) {
		
		String BIZRID_NO = data.get("WHSDL_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
				
		List<?> list = epmf0121801Mapper.epmf0121801_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
			map.put("totalCnt", epmf0121801Mapper.epmf0121801_select2_cnt(data));
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
	 * 등록화면 페이지 초기화
	 * @param model
	 * @param request
	 * @return 
	 * @
	 */
	public ModelMap epmf0121831_select(ModelMap model, HttpServletRequest request) {
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("BIZR_TP_CD","W1");//도매업자
		List<?> bizrList = commonceService.bizr_select(map);
		
		List<?> bizrTpList = epmf0121801Mapper.epmf0121801_select();//거래처구분
		
		try {
			model.addAttribute("bizrList", util.mapToJson(bizrList)); //도매업자
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
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
		
		String title = commonceService.getMenuTitle("EPMF0121831");
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
	public String epmf0121831_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
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
						Map<String, String> checkMap = (Map<String, String>) epmf0121801Mapper.epmf0121831_select(map);

						if(checkMap != null && !checkMap.get("BIZR_TP_CD").equals("R1") && !checkMap.get("BIZR_TP_CD").equals("R2")){ 
							//errCd = ""; // 이미 등록되어있는 사업자가 소매업자가 아닐경우는 거래처 데이터를 등록하지 않는다
							continue;
						}
						
						if(checkMap != null && !checkMap.get("BIZRID").equals("") && !checkMap.get("BRCH_ID").equals("N") ){ //사업자, 지점 둘다 등록상태
							
							//이미 해당 사업자번호로 사업자 및 지점이 등록되어있는 경우는 해당 데이터를 통해 거래처를 등록한다.  즉  작성한 거래처명, 사업자유형은 무시함
							//errCd = ""; //이미 등록된 소매거래처 지점정보로 저장된 건이 있습니다. 등록결과를 확인하시기 바랍니다.
							map.put("BIZRID", checkMap.get("BIZRID"));
						}else{
						
							if(checkMap == null || (checkMap != null && checkMap.get("BIZRID").equals("")) ){ //사업자데이터가 없을경우
								
								String psnbSeq = commonceService.psnb_select("S0001"); //사업자ID 일련번호 채번
								//map.put("BIZRID", "D3H"+psnbSeq); //사업자ID = 소매거래처등록사업자(D3) - 수기(H)
								
								String bizrTpCd = map.get("BIZR_TP_CD");
								map.put("BIZRID", bizrTpCd+"H"+psnbSeq); //사업자ID = R1 가정용;R2 영업용 - 수기(H)

								epmf0121801Mapper.epmf0121831_insert(map); //소매 사업자등록
								epmf0121801Mapper.epmf0121831_insert2(map); //소매 지점등록
								
							}else if(checkMap != null && checkMap.get("BRCH_ID").equals("N") ){ //지점데이터가 없을경우
								
								map.put("BIZRID", checkMap.get("BIZRID")); //조회된 사업자ID로 등록
								epmf0121801Mapper.epmf0121831_insert2(map); //소매 지점등록
							}
						}
						
						if(data.containsKey("FRC_YN")){ 
							map.put("FRC_YN", data.get("FRC_YN"));
							epmf0121801Mapper.epmf0121831_update(map); //가맹점 인서트 및 업데이트
						}else{
							epmf0121801Mapper.epmf0121831_insert3(map); //소매거래처정보등록
						}
						
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
	 * 소매거래처관리 데이터 체크
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epmf0121831_select2(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";
		Map<String, String> map;
		
		try {
			
			List<?> list = epmf0121801Mapper.epmf0121831_select2(data);
			
			if(list != null && list.size() > 0 ){
				map = (Map<String, String>) list.get(0); //하나만 보여줌..
				errCd = map.get("ERR_CD");
			}
			
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
	
	/**
	 * 소매거래처관리 데이터 체크 (엑셀저장용)
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epmf0121831_select3(HashMap<String, String> data, HttpServletRequest request) {
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
    	try {
			rtnMap.put("selList", util.mapToJson(epmf0121801Mapper.epmf0121831_select3(data)));
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
	 * 거래상태 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epmf0121801_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
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
					
					epmf0121801Mapper.epmf0121801_update(map);	//수정 처리
					
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
	 * 소매거래처 변경 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf0121888_select(ModelMap model) {
		
		String title = commonceService.getMenuTitle("EPMF0121888");
		model.addAttribute("titleSub", title);

		List<?> bizrTpList = epmf0121801Mapper.epmf0121801_select();//거래처구분
		try {
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
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
	 * 소매거래처 정보 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epmf0121888_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				data.put("S_USER_ID", ssUserId);
				
				int rCnt = epmf0121801Mapper.epmf0121888_update(data); //사업자
				if(rCnt > 0){
					epmf0121801Mapper.epmf0121888_update2(data); //지점
					epmf0121801Mapper.epmf0121888_update3(data); //거래처
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
	 * 엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epmf0121801_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			String BIZRID_NO = data.get("WHSDL_BIZR_SEL");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("BIZRID", BIZRID_NO.split(";")[0]);
				data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}
			
			data.put("excelYn", "Y");
			List<?> list = epmf0121801Mapper.epmf0121801_select2(data);

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
	
}