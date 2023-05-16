package egovframework.koraep.ce.ep.service;

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
import egovframework.mapper.ce.ep.EPCE6624501Mapper;

/**
 * 교환관리 서비스
 * @author Administrator
 *
 */
@Service("epce6624501Service")
public class EPCE6624501Service {

	@Resource(name="epce6624501Mapper")
	private EPCE6624501Mapper epce6624501Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 교환관리 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce6624501_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> exchStatList = commonceService.getCommonCdListNew("D013");// 교환상태
		List<?> dtList = commonceService.getCommonCdListNew("D016");// 교환일자구분
		List<?> grid_info			= commonceService.GRID_INFO_SELECT("EPCE6624501",request);		//그리드 컬럼 정보
		
		
		try {
			model.addAttribute("grid_info", util.mapToJson(grid_info));
			model.addAttribute("exchStatList", util.mapToJson(exchStatList));
			model.addAttribute("dtList", util.mapToJson(dtList));
			
			List<?> bizrNmList 		= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
			
			model.addAttribute("bizrNmList", util.mapToJson(bizrNmList));
				//생산자 리스트
			
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
				List<?> cfmBrchList	= commonceService.brch_nm_select(request, map);
				model.addAttribute("cfmBrchList", util.mapToJson(cfmBrchList)); //직매장
				
			}else{
				model.addAttribute("reqBrchList", "{}");	//직매장
				model.addAttribute("cfmBrchList", "{}");	//직매장
			}
			
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
	public ModelMap epce6624564_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE6624564");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보    
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		try {
			model.addAttribute("searchList", util.mapToJson(epce6624501Mapper.epce6624564_select(param)));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return model;
	}
	
	/**
	 * 교환변경 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce6624542_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE6624542");
		model.addAttribute("titleSub", title);
		
		try {
		
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
	
			HashMap<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
			model.addAttribute("searchList", util.mapToJson(epce6624501Mapper.epce6624564_select(param)));
			
			
			HashMap<String, String> reqMap = new  HashMap<String, String>();
			reqMap.put("BIZRID", param.get("REQ_MFC_BIZRID"));
			reqMap.put("BIZRNO", param.get("REQ_MFC_BIZRNO"));
			reqMap.put("USE_YN", "Y");
			
			HashMap<String, String> cfmMap = new  HashMap<String, String>();
			cfmMap.put("BIZRID", param.get("CFM_MFC_BIZRID"));
			cfmMap.put("BIZRNO", param.get("CFM_MFC_BIZRNO"));
			cfmMap.put("USE_YN", "Y");
			
			//빈용기명(표준용기) 정보
			List<?> reqCtnrList = commonceService.ctnr_nm_std_dps_select(request, reqMap);
			List<?> cfmCtnrList = commonceService.ctnr_nm_std_dps_select(request, cfmMap);
			model.addAttribute("reqCtnrList", util.mapToJson(reqCtnrList));
		
			model.addAttribute("cfmCtnrList", util.mapToJson(cfmCtnrList));
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
	public String epce6624564_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();

				data.put("S_USER_ID", sUserId);
			    		
			    epce6624501Mapper.epce6624564_update(data);
			    
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
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
	public HashMap<String, Object> epce6624501_select2(Map<String, String> data) {
		
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
			map.put("searchList", util.mapToJson(epce6624501Mapper.epce6624501_select(data)));
			map.put("totalList", util.mapToJson(epce6624501Mapper.epce6624501_select_cnt(data)));
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
	public String epce6624501_delete(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
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
			    		
			    		epce6624501Mapper.epce6624501_delete(map);
			    		
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}
				
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
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
	public ModelMap epce6624531_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE6624531");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		Map<String, String> map = new HashMap<String, String>();
		map.put("WORK_SE", "3"); 																	//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
		HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);		//등록일자제한설정  
		List<?> bizrNmList 	= commonceService.mfc_bizrnm_select(request); 				// 생산자 콤보박스
		try {
			model.addAttribute("bizrNmList", util.mapToJson(bizrNmList));
			model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	    //등록일자제한설정
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
	public String epce6624531_select(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";
		Map<String, String> map;
		
		try {
			
			List<?> list = epce6624501Mapper.epce6624531_select(data);
			
			if(list != null && list.size() > 0 ){
				map = (Map<String, String>) list.get(0); //하나만 보여줌..
				errCd = map.get("ERR_CD");
			}
			
			//별도 오류 발생시
			//if(1==1) throw new Exception("ABCD"); 
			
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
	 * @throws Exception 
	 * @
	 */ 
	public List<?> epce6624531_select2(Map<String, String> data) throws Exception  {

		try {
			
			String BIZRID_NO = data.get("BIZRID_NO");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("BIZRID", BIZRID_NO.split(";")[0]);
				data.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}else{
				data.put("BIZRID", "");
				data.put("BIZRNO", "");
			}
	
			//빈용기명(표준용기) 정보
			List<?> list = epce6624501Mapper.epce6624531_select2(data);
			return list;
			
		}catch(Exception e){
			throw new Exception("A001"); //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
			
	}
	
	/**
	 * 교환 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce6624531_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		Map<String, String> map;
		String ssUserId  = "";   //사용자ID
		List<Map<String, String>>list2 =new ArrayList<Map<String,String>>();
		boolean keyCheck;
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0 ){
					
					for(int i=0; i<list.size(); i++) {
						keyCheck = false;
						map = (Map<String, String>)list.get(i);
						map.put("S_USER_ID", ssUserId);

						map.put("SDT_DT", map.get("EXCH_DT"));		//등록일자제한설정  등록일자 1.DLIVY_DT,2.DRCT_RTRVL_DT, 3.EXCH_DT, 4.RTRVL_DT, 5.RTN_DT
						map.put("WORK_SE", "3"); 							//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
						int sel =commonceService.rtc_dt_ck(map);		//등록일자제한설정
						if(sel !=1){
							throw new Exception("A021"); //등록일자제한일자 입니다. 다시 한 번 확인해주시기 바랍니다.
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
						
						if(!keyCheck){
							
							//문서번호 채번
							String EXCH_REQ_DOC_NO = commonceService.doc_psnb_select("EC");
							map.put("EXCH_REQ_DOC_NO", EXCH_REQ_DOC_NO);
							
				 			list2.add(map); //마스터 인서트 여부 체크용ㄴ
							epce6624501Mapper.epce6624531_insert(map); //마스터 인서트
						}	
						
						epce6624501Mapper.epce6624531_insert2(map); //디테일 인서트
					}
					
					for(int j=0 ;j<list2.size(); j++){
						Map<String, String> map2 = (Map<String, String>) list2.get(j);
						epce6624501Mapper.epce6624531_update(map2); //마스터 테이블 합계데이터 업데이트
					}
					
				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}
				
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
	public String epce6624542_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
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
					
					epce6624501Mapper.epce6624542_delete(map2); //디테일 전체 삭제
					
					for(int i=0; i<list.size(); i++) {
						
						map = (Map<String, String>)list.get(i);
						map.put("S_USER_ID", ssUserId);

						if(!map.containsKey("RMK")){
							map.put("RMK", "");
						}
						
						epce6624501Mapper.epce6624531_insert2(map); //디테일 인서트
						
					}
					
					int result = epce6624501Mapper.epce6624531_update(map2); //마스터 테이블 합계데이터 업데이트
					if(result == 0){
			 			throw new Exception("A012"); //상태정보가 변경되어있습니다.
			 		}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}
				
		}catch(Exception e){
			if(e.getMessage().equals("A012") ){
				 throw new Exception(e.getMessage());
			}else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
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
	public String epce6624501_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
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
					
			List<?> list = epce6624501Mapper.epce6624501_select(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}
