package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
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
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF6624501Mapper;

/**
 * 교환관리 서비스
 * @author Administrator
 *
 */
@Service("epmf6624501Service")
public class EPMF6624501Service {

	@Resource(name="epmf6624501Mapper")
	private EPMF6624501Mapper epmf6624501Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 교환관리 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6624501_select(ModelMap model, HttpServletRequest request) {

		try {
		
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			
			List<?> exchStatList = commonceService.getCommonCdListNew("D013");// 교환상태
			List<?> dtList = commonceService.getCommonCdListNew("D016");// 교환일자구분
			List<?> grid_info	 = commonceService.GRID_INFO_SELECT("EPMF6624501",request);		//그리드컬럼 조회
			
			model.addAttribute("grid_info", util.mapToJson(grid_info));
			model.addAttribute("exchStatList", util.mapToJson(exchStatList));
			model.addAttribute("dtList", util.mapToJson(dtList));
			
			List<?> bizrNmList 	= commonceService.mfc_bizrnm_select(request); // 등록 생산자 콤보박스
			List<?> bizrNmList_all = commonceService.mfc_bizrnm_select_all(request); // 확인 생산자 콤보박스
			model.addAttribute("bizrNmList", util.mapToJson(bizrNmList));			// 등록 생산자 리스트
			model.addAttribute("bizrNmList_all", util.mapToJson(bizrNmList_all));	//확인 생산자 리스트
			HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
			Map<String, String> map = new HashMap<String, String>();
			
			if(jmap != null){
				
				String BIZRID_NO = jmap.get("REQ_MFC_SEL");
				if(BIZRID_NO != null && !BIZRID_NO.equals("")){
					map.put("BIZRID", BIZRID_NO.split(";")[0]);
					map.put("BIZRNO", BIZRID_NO.split(";")[1]);
				}else{
					map.put("BIZRID", "");
					map.put("BIZRNO", "");
				}
				List<?> reqBrchList	= commonceService.brch_nm_select(request, map);
				model.addAttribute("reqBrchList", util.mapToJson(reqBrchList)); //직매장
				
				String BIZRID_NO2 = jmap.get("CFM_MFC_SEL");
				if(BIZRID_NO2 != null && !BIZRID_NO2.equals("")){
					map.put("BIZRID", BIZRID_NO2.split(";")[0]);
					map.put("BIZRNO", BIZRID_NO2.split(";")[1]);
				}else{
					map.put("BIZRID", "");
					map.put("BIZRNO", "");
				}
				map.put("ALL_YN", "Y"); //확인 직매장은 전체 조회
				List<?> cfmBrchList	= commonceService.brch_nm_select(request, map);
				model.addAttribute("cfmBrchList", util.mapToJson(cfmBrchList));
				//직매장
				
			}else{
				model.addAttribute("reqBrchList", "{}");	//직매장
				model.addAttribute("cfmBrchList", "{}");	//직매장
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
	 * 교환상세조회 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6624564_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPMF6624564");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		try {
			model.addAttribute("searchList", util.mapToJson(epmf6624501Mapper.epmf6624564_select(param)));
			model.addAttribute("searchDtl", util.mapToJson(epmf6624501Mapper.epmf6624564_select2(param)));
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
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		model.addAttribute("U_BIZRID", vo.getBIZRID());
		model.addAttribute("U_BIZRNO", vo.getBIZRNO_ORI());
		model.addAttribute("U_BRCH_ID", vo.getBRCH_ID());
		model.addAttribute("U_BRCH_NO", vo.getBRCH_NO());
		
		return model;
	}
	
	/**
	 * 교환변경 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6624542_select(ModelMap model, HttpServletRequest request) {

		
		try {
			String title = commonceService.getMenuTitle("EPMF6624542");
			model.addAttribute("titleSub", title);
			
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
			List<?> searchList = epmf6624501Mapper.epmf6624564_select(param);
			model.addAttribute("searchList", util.mapToJson(searchList));
			
			HashMap<String, String> listMap = (HashMap<String, String>)searchList.get(0);

			HashMap<String, String> reqMap = new  HashMap<String, String>();
			reqMap.put("BIZRID", listMap.get("REQ_MFC_BIZRID"));
			reqMap.put("BIZRNO", listMap.get("REQ_MFC_BIZRNO"));
			reqMap.put("USE_YN", "Y");
			
			HashMap<String, String> cfmMap = new  HashMap<String, String>();
			cfmMap.put("BIZRID", listMap.get("CFM_MFC_BIZRID"));
			cfmMap.put("BIZRNO", listMap.get("CFM_MFC_BIZRNO"));
			cfmMap.put("USE_YN", "Y");
			
			//빈용기명(표준용기) 정보
			List<?> reqCtnrList = commonceService.ctnr_nm_std_dps_select(request, reqMap);
			List<?> cfmCtnrList = commonceService.ctnr_nm_std_dps_select(request, cfmMap);
			model.addAttribute("reqCtnrList", util.mapToJson(reqCtnrList));
			model.addAttribute("cfmCtnrList", util.mapToJson(cfmCtnrList));
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
	 * 교환상태 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epmf6624564_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		String sBizrId = "";
		String sBizrNo = "";
		String sBrchId = "";
		String sBrchNo = "";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				if(vo != null){
					sUserId = vo.getUSER_ID();
					sBizrId = vo.getBIZRID();
					sBizrNo = vo.getBIZRNO_ORI();
					sBrchId = vo.getBRCH_ID();
					sBrchNo = vo.getBRCH_NO();
				}
				data.put("S_USER_ID", sUserId);
				data.put("S_BIZRID", sBizrId);
				data.put("S_BIZRNO", sBizrNo);
				data.put("S_BRCH_ID", sBrchId);
				data.put("S_BRCH_NO", sBrchNo);
			    						
			    epmf6624501Mapper.epmf6624564_update(data);
			    
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
	/**
	 * 교환관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf6624501_select2(Map<String, String> data, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		data.put("BIZRID", vo.getBIZRID());
		data.put("BIZRNO", vo.getBIZRNO_ORI());
		if(!vo.getBRCH_NO().equals("9999999999")){
			data.put("BRCH_ID", vo.getBRCH_ID());
			data.put("BRCH_NO", vo.getBRCH_NO());
		}
		
		if(data.get("REQ_MFC_SEL") != null && !data.get("REQ_MFC_SEL").equals("")){
			String[] idNo = data.get("REQ_MFC_SEL").split(";");
			data.put("REQ_MFC_BIZRID", idNo[0]);
			data.put("REQ_MFC_BIZRNO", idNo[1]);
		}
		if(data.get("REQ_MFC_BRCH_SEL") != null && !data.get("REQ_MFC_BRCH_SEL").equals("")){
			String[] idNo = data.get("REQ_MFC_BRCH_SEL").split(";");
			data.put("REQ_MFC_BRCH_ID", idNo[0]);
			data.put("REQ_MFC_BRCH_NO", idNo[1]);
		}
		if(data.get("CFM_MFC_SEL") != null && !data.get("CFM_MFC_SEL").equals("")){
			String[] idNo = data.get("CFM_MFC_SEL").split(";");
			data.put("CFM_MFC_BIZRID", idNo[0]);
			data.put("CFM_MFC_BIZRNO", idNo[1]);
		}
		if(data.get("CFM_MFC_BRCH_SEL") != null && !data.get("CFM_MFC_BRCH_SEL").equals("")){
			String[] idNo = data.get("CFM_MFC_BRCH_SEL").split(";");
			data.put("CFM_MFC_BRCH_ID", idNo[0]);
			data.put("CFM_MFC_BRCH_NO", idNo[1]);
		}
				
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(epmf6624501Mapper.epmf6624501_select(data)));
			map.put("totalList", util.mapToJson(epmf6624501Mapper.epmf6624501_select_cnt(data)));
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
	 * 교환삭제
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epmf6624501_delete(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();
				
				List<?> list = JSONArray.fromObject(data.get("list"));
				
				if(list != null && list.size() > 0){
					
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		
			    		map.put("S_USER_ID", sUserId);
			    		
			    		epmf6624501Mapper.epmf6624501_delete(map);
			    		
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
			throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
	
	/**
	 * 교환등록 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf6624531_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPMF6624531");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		Map<String, String> map = new HashMap<String, String>();
		map.put("WORK_SE", "3"); 																	//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
		HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);		//등록일자제한설정  
		List<?> bizrNmList 	= commonceService.mfc_bizrnm_select_y(request); 			// 등록 생산자 콤보박스
		List<?> bizrNmList_all	= commonceService.mfc_bizrnm_select_all_y(request); // 확인 생산자 콤보박스
		
		try {
			model.addAttribute("bizrNmList", util.mapToJson(bizrNmList));	//생산자 리스트
			model.addAttribute("bizrNmList_all", util.mapToJson(bizrNmList_all));
			model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	    //등록일자제한설정
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
		model.addAttribute("brchNmList", "{}");	//직매장
		
		return model;
	}
	
	/**
	 * 교환관리 데이터 체크
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epmf6624531_select(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";
		Map<String, String> map;
		
		try {
			
			List<?> list = epmf6624501Mapper.epmf6624531_select(data);
			
			if(list != null && list.size() > 0 ){
				map = (Map<String, String>) list.get(0); //하나만 보여줌..
				errCd = map.get("ERR_CD");
			}
			
			//별도 오류 발생시
			//if(1==1) throw new Exception("ABCD"); 
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			
			/*
			//별도 오류코드 리턴
			if(e.getMessage().equals("ABCD")){
				throw new Exception(e.getMessage());
			}else{
				throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			*/
			
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 생산자별 빈용기명 콤보박스 목록조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> epmf6624531_select2(Map<String, String> data)  {


		String BIZRID_NO = data.get("BIZRID_NO");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}else{
			data.put("BIZRID", "");
			data.put("BIZRNO", "");
		}

		//빈용기명(표준용기) 정보
		List<?> list = new ArrayList();
		try {
			list = epmf6624501Mapper.epmf6624531_select2(data);
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
		return list;
			
	}
	
	/**
	 * 교환 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epmf6624531_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		Map<String, String> map;
		String ssUserId  = "";   //사용자ID
		String userBizrid  = "";   //사용자 BIZRID
		String userBizrno  = "";   //사용자 BIZRNO
		
		List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
		boolean keyCheck;
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
					userBizrid = vo.getBIZRID();
					userBizrno = vo.getBIZRNO_ORI();
				}
				
				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0 ){
					
					for(int i=0; i<list.size(); i++) {
						keyCheck = false;
						map = (Map<String, String>)list.get(i);
						map.put("S_USER_ID", ssUserId);
						
						//세션 사업자아이디 및 번호 체크
						if(!map.get("REQ_MFC_BIZRID").equals(userBizrid) || !map.get("REQ_MFC_BIZRNO").equals(userBizrno)){// 세션 사업자정보와 일치하지 않음
							throw new Exception("A008"); // 변조된 데이터 입니다.
						}
						
						//마스터 데이터 체크
						for(int j=0 ;j<list2.size(); j++){
					 		Map<String, String> map2 = (Map<String, String>) list2.get(j);
					 		if(  map.get("REQ_MFC_BIZRID").equals(map2.get("REQ_MFC_BIZRID")) && map.get("REQ_MFC_BIZRNO").equals(map2.get("REQ_MFC_BIZRNO"))       
					 			&& map.get("REQ_MFC_BRCH_ID").equals(map2.get("REQ_MFC_BRCH_ID")) && map.get("REQ_MFC_BRCH_NO").equals(map2.get("REQ_MFC_BRCH_NO"))  
					 			&& map.get("CFM_MFC_BIZRID").equals(map2.get("CFM_MFC_BIZRID")) &&  map.get("CFM_MFC_BIZRNO").equals(map2.get("CFM_MFC_BIZRNO"))
					 			&& map.get("CFM_MFC_BRCH_ID").equals(map2.get("CFM_MFC_BRCH_ID")) &&  map.get("CFM_MFC_BRCH_NO").equals(map2.get("CFM_MFC_BRCH_NO"))
					 			&& map.get("EXCH_DT").equals(map2.get("EXCH_DT")) 
					 		  ){
					 			keyCheck = true;
					 			map.put("EXCH_REQ_DOC_NO", map2.get("EXCH_REQ_DOC_NO"));
					 			break;
					 		  }
					 	}
						
						Map<String, String> chkmap = (Map<String, String>) list.get(i);
						chkmap.put("SDT_DT", map.get("EXCH_DT"));	//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
						chkmap.put("WORK_SE", "3"); 							//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
						int sel =commonceService.rtc_dt_ck(chkmap);		//등록일자제한설정
						
						if(sel !=1){ 
							throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
						}      
						
						if(!keyCheck){
							
							//문서번호 채번
							String EXCH_REQ_DOC_NO = commonceService.doc_psnb_select("EC");
							map.put("EXCH_REQ_DOC_NO", EXCH_REQ_DOC_NO);
							
				 			list2.add(map); //마스터 인서트 여부 체크용ㄴ
							epmf6624501Mapper.epmf6624531_insert(map); //마스터 인서트
						}	
						
						epmf6624501Mapper.epmf6624531_insert2(map); //디테일 인서트
					}
					
					for(int j=0 ;j<list2.size(); j++){
						Map<String, String> map2 = (Map<String, String>) list2.get(j);
						epmf6624501Mapper.epmf6624531_update(map2); //마스터 테이블 합계데이터 업데이트
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
		    if(e.getMessage().equals("A021")){
				throw new Exception(e.getMessage()); 
			}else{
			    throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
		}
		
		return errCd;
	}
	
	/**
	 * 교환 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epmf6624542_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
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
				String EXCH_REQ_DOC_NO = data.get("EXCH_REQ_DOC_NO");

				if(list != null && list.size() > 0 ){
					
					Map<String, String> map2 = new HashMap<String, String>();
					map2.put("EXCH_REQ_DOC_NO", EXCH_REQ_DOC_NO);
					
					epmf6624501Mapper.epmf6624542_delete(map2); //디테일 전체 삭제
					
					for(int i=0; i<list.size(); i++) {
						
						map = (Map<String, String>)list.get(i);
						map.put("S_USER_ID", ssUserId);

						if(!map.containsKey("RMK")){
							map.put("RMK", "");
						}
						
						epmf6624501Mapper.epmf6624531_insert2(map); //디테일 인서트
						
					}
					
					
					int result = epmf6624501Mapper.epmf6624531_update(map2); //마스터 테이블 합계데이터 업데이트
					if(result == 0){
			 			throw new Exception("A012"); //상태정보가 변경되어있습니다.
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
			throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
	/**
	 * 교환관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epmf6624501_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			data.put("BIZRID", vo.getBIZRID());
			data.put("BIZRNO", vo.getBIZRNO_ORI());
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("BRCH_ID", vo.getBRCH_ID());
				data.put("BRCH_NO", vo.getBRCH_NO());
			}
			
			if(data.get("REQ_MFC_SEL") != null && !data.get("REQ_MFC_SEL").equals("")){
				String[] idNo = data.get("REQ_MFC_SEL").split(";");
				data.put("REQ_MFC_BIZRID", idNo[0]);
				data.put("REQ_MFC_BIZRNO", idNo[1]);
			}
			if(data.get("REQ_MFC_BRCH_SEL") != null && !data.get("REQ_MFC_BRCH_SEL").equals("")){
				String[] idNo = data.get("REQ_MFC_BRCH_SEL").split(";");
				data.put("REQ_MFC_BRCH_ID", idNo[0]);
				data.put("REQ_MFC_BRCH_NO", idNo[1]);
			}
			if(data.get("CFM_MFC_SEL") != null && !data.get("CFM_MFC_SEL").equals("")){
				String[] idNo = data.get("CFM_MFC_SEL").split(";");
				data.put("CFM_MFC_BIZRID", idNo[0]);
				data.put("CFM_MFC_BIZRNO", idNo[1]);
			}
			if(data.get("CFM_MFC_BRCH_SEL") != null && !data.get("CFM_MFC_BRCH_SEL").equals("")){
				String[] idNo = data.get("CFM_MFC_BRCH_SEL").split(";");
				data.put("CFM_MFC_BRCH_ID", idNo[0]);
				data.put("CFM_MFC_BRCH_NO", idNo[1]);
			}
					
			List<?> list = epmf6624501Mapper.epmf6624501_select(data);

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
