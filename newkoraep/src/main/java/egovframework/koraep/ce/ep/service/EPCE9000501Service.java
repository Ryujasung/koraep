package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0140101Mapper;
import egovframework.mapper.ce.ep.EPCE9000501Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("epce9000501Service")
public class EPCE9000501Service {

	@Resource(name="epce9000501Mapper")
	private EPCE9000501Mapper epce9000501Mapper;

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
	public ModelMap epce9000501_select(ModelMap model, HttpServletRequest request)  {
		//세션정보 가져오기
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO)session.getAttribute("userSession");
		String ssBizrno = uvo.getBIZRNO();		//사업자번호

		List<?> AreaCdList = commonceService.getCommonCdListNew("B010");
		String title = commonceService.getMenuTitle("EPCE9000501");
		Map<String, String> map 		= new HashMap<String, String>();
		List<?>	urm_list2 = urm_select2(request, map);    			//도매업자 업체명조회
		List<?>	urm_list = urm_list_select(request, map);    			//도매업자 업체명조회
		try {
//			model.addAttribute("initList", util.mapToJson(initList));
			model.addAttribute("AreaCdList", util.mapToJson(AreaCdList));
			model.addAttribute("urm_list2", util.mapToJson(urm_list2));
			model.addAttribute("urm_list", util.mapToJson(urm_list));
			
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
	
	public List<?> urm_list_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		List<?> selList=null;
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 도매업자 일경우
			selList = epce9000501Mapper.urm_list_select((HashMap<String, String>) map);
		
		return selList;
	}
	
	
	/**
	 *	 도매업자 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */ 
	public List<?> urm_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		List<?> selList=null;
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 도매업자 일경우
			selList = epce9000501Mapper.urm_select((HashMap<String, String>) map);
		
		return selList;
	}
	
public List<?> urm_fix_select(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		List<?> selList=null;
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 도매업자 일경우
			selList = epce9000501Mapper.urm_fix_select((HashMap<String, String>) map);
		
		return selList;
	}

public List<?> urm_fix_reg_dt(HttpServletRequest request, Map<String, String> data)  {
	
	HttpSession session = request.getSession();
	UserVO uvo = (UserVO) session.getAttribute("userSession");
	
	List<?> selList=null;
	Map<String, String> map =new HashMap<String, String>();
	map.putAll(data);
	
	//로그인자가 도매업자 일경우
		selList = epce9000501Mapper.urm_fix_reg_dt((HashMap<String, String>) map);
	
	return selList;
}
	
public List<?> urm_select2(HttpServletRequest request, Map<String, String> data)  {
		
		HttpSession session = request.getSession();
		UserVO uvo = (UserVO) session.getAttribute("userSession");
		
		List<?> selList=null;
		Map<String, String> map =new HashMap<String, String>();
		map.putAll(data);
		
		//로그인자가 도매업자 일경우
			selList = epce9000501Mapper.urm_select2((HashMap<String, String>) map);
		
		return selList;
	}



	/**
	 * 무인회수기정보 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce9000501_select2(Map<String, String> data, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null){
			data.put("T_USER_ID", vo.getUSER_ID());
		}
		
		List<?> list = epce9000501Mapper.epce9000501_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
			map.put("totalCnt", epce9000501Mapper.epce9000501_select2_cnt(data));
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
	 * 소모품 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce9000532_select2(Map<String, String> data, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null){
			data.put("T_USER_ID", vo.getUSER_ID());
		}

		List<?> list = epce9000501Mapper.epce9000532_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
//			map.put("totalCnt", epce9000501Mapper.epce9000501_select2_cnt(data));
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
	public String epce900053219_05_excel(HashMap<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			
			data.put("excelYn", "Y");
			List<?> list = epce9000501Mapper.epce9000532_select3(data);

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
	 * 사업자관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce9000501_excel(HashMap<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null){
				data.put("T_USER_ID", vo.getUSER_ID());
			}

			
			data.put("excelYn", "Y");
			List<?> list = epce9000501Mapper.epce9000501_select2(data);

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
	 * 사용자변경이력 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce900050118_select(ModelMap model) {

		String title = commonceService.getMenuTitle("EPCE9000501_1");
		model.addAttribute("titleSub", title);

		return model;
	}
	
	public ModelMap epce900050118_select1(ModelMap model) {

		String title = commonceService.getMenuTitle("EPCE9000501_3");
		model.addAttribute("titleSub", title);

		return model;
	}



	/**
	 * 사업자상세 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000516_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE9000516");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		System.out.println("map"+map);
		model.addAttribute("searchDtl", util.mapToJson(epce9000501Mapper.epce9000516_select(map)));

		return model;
	}
	
	/**
	 * 사업자상세 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000536_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE9000536");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		model.addAttribute("searchDtl", util.mapToJson(epce9000501Mapper.epce9000536_select(map)));

		return model;
	}
	
	/**
	 * 반환관리  삭제
	 * @param inputMap
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String EPCE9000538_select(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		if (list != null) {
			try {
				for (int i = 0; i < list.size(); i++) {
					map = (Map<String, String>) list.get(i);
					//int stat = epce9000601Mapper.epce9000601_select6(map); // 상태 체크
					/*if (stat > 0) {
						throw new Exception("A009"); // 반환정보가 변경되었습니다. 다시 조회하시기 바랍니다.
					}*/
					epce9000501Mapper.EPCE9000538_select(map); // 반환내역서 삭제
				}

			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if (e.getMessage().equals("A009")) {
					 throw new Exception(e.getMessage());
				} else {
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}
		}
		return errCd;
	}

	/**
	 * 지급제외설정 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce9000517_select(ModelMap model, HttpServletRequest request) {
		try {
			String title = commonceService.getMenuTitle("EPCE9000517");//타이틀
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
	 * 시리얼번호 중복체크
	 * @param model
	 * @param request
	 * @
	 */

	public String serialNoCheck(HashMap<String, String> map) {
		String rtn = "Y";
		
		int cnt = epce9000501Mapper.serialNoCheck(map);
		if(cnt > 0) rtn = "N";
		
		return rtn;
	}
	
	public String urmcodeNoCheck(HashMap<String, String> map) {
		String rtn = "Y";
		
		int cnt = epce9000501Mapper.urmcodeNoCheck(map);
		if(cnt > 0) rtn = "N";
		
		return rtn;
	}
	
	public String urmCeNoCheck(HashMap<String, String> map) {
		
		String urm_ce_no = epce9000501Mapper.urmCeNoCheck(map);
		
		return urm_ce_no;
	}

	/**
	 * 사업자상세조회2
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce9000516_select2(Map<String, String> data) {

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("searchDtl", util.mapToJson(epce9000501Mapper.epce9000516_select(data)));

		return map;
	}
	/**
	 * 관리자변경 팝업호출
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce90005018_1_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE90005018_1");
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
	public ModelMap epce9000588(ModelMap model, HttpServletRequest request) {
		try {
			String title = commonceService.getMenuTitle("EPCE9000588");//타이틀
			Map<String, String> map 		= new HashMap<String, String>();
			List<?>	urm_list = urm_list_select(request, map);    			//도매업자 업체명조회
			model.addAttribute("urm_list", util.mapToJson(urm_list));
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
	public String epce9000588_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		String errCd = "0000";
		Map<String, String> map;
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		if (list != null) {
			try {
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", vo.getUSER_ID());//등록자
					map.put("USE_YN", "M");//등록자
					System.out.println("MAP"+map);
					epce9000501Mapper.epce900050142_update(map);//상태변경
					epce9000501Mapper.epce9000531_hist(map);	//등록 처리
					epce9000501Mapper.epce9000588_update(map);
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
	
	
	
	
	
	
	
	

	//무인회수기정보수정
		public String epce9000531_update(HashMap<String, String> data,
				HttpServletRequest request) throws Exception {
			String errCd = "0000";
			
			try {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO)session.getAttribute("userSession");
					
					data.put("S_USER_ID", "");
					if(vo != null){
						data.put("S_USER_ID", vo.getUSER_ID());
					}
						
					//data.put("", data.get(key));

					//Long urm_no = epce9000501Mapper.numbercnt(); //지점ID 일련번호 채번
					//Long urmsum = urm_no +1;
				//	String urmno = Long.toString(urmsum);
				//	data.put("URM_NO", urmno);
					System.out.println("data"+data);
					epce9000501Mapper.epce9000531_update_hist(data);	//등록 처리
					epce9000501Mapper.epce9000531_update(data);	//등록 처리
					
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				if(e.getMessage().equals("B007") || e.getMessage().equals("B008") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
			
			return errCd;
		}
	
		//무인회수기소모품정보수정
				public String epce9000537_update(HashMap<String, String> data,
						HttpServletRequest request) throws Exception {
					String errCd = "0000";
					
					try {
							HttpSession session = request.getSession();
							UserVO vo = (UserVO)session.getAttribute("userSession");
							
							data.put("S_USER_ID", "");
							if(vo != null){
								data.put("S_USER_ID", vo.getUSER_ID());
							}
								
							//data.put("", data.get(key));

							Long urm_no = epce9000501Mapper.numbercnt(); //지점ID 일련번호 채번
							Long urmsum = urm_no +1;
							String urmno = Long.toString(urmsum);
							data.put("URM_NO", urmno);
							
							epce9000501Mapper.epce9000537_update(data);	//등록 처리
							
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
					}catch(Exception e){
						if(e.getMessage().equals("B007") || e.getMessage().equals("B008") ){
							 throw new Exception(e.getMessage());
						 }else{
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
					}
					
					return errCd;
				}
		
//무인회수기정보등록
	public String epce9000531_insert(HashMap<String, String> data,
			HttpServletRequest request) throws Exception {
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
					
				//data.put("", data.get(key));

				Long urm_no = epce9000501Mapper.numbercnt(); //지점ID 일련번호 채번
				Long urmsum = urm_no +1;
				String urmno = Long.toString(urmsum);
				String new_yn =data.get("NEW_YN");
				data.put("URM_NO", urmno);
				System.out.println("new_yn : "+new_yn);
				
				if(new_yn.equals("Y")){
					System.out.println("11");
					epce9000501Mapper.epce9000531_insert(data);	//추가등록
//					epce9000501Mapper.epce9000531_insert_old(data);	//추가등록
					
				}else{
					System.out.println("22");
					epce9000501Mapper.epce9000531_insert_old(data);	//신규등록
				}
				
				
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			if(e.getMessage().equals("B007") || e.getMessage().equals("B008") ){
				 throw new Exception(e.getMessage());
			 }else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			 }
		}
		
		return errCd;
	}

	public String epce9000533_insert(HashMap<String, String> data,
			HttpServletRequest request) throws Exception {
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
					
				//data.put("", data.get(key));

				Long urm_no = epce9000501Mapper.numbercnt(); //지점ID 일련번호 채번
				Long urmsum = urm_no +1;
				String urmno = Long.toString(urmsum);
				data.put("URM_NO", urmno);
				
				epce9000501Mapper.epce9000533_insert(data);	//등록 처리
				
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			if(e.getMessage().equals("B007") || e.getMessage().equals("B008") ){
				 throw new Exception(e.getMessage());
			 }else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			 }
		}
		
		return errCd;
	}

	public ModelMap EPCE9000531_select(ModelMap model,
			HttpServletRequest request) {
		//파라메터 정보   
		String reqParams 				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams 			= JSONObject.fromObject(reqParams);
		Map<String, String> map 		= new HashMap<String, String>();
		String   	title						= commonceService.getMenuTitle("EPCE9000531");	//타이틀
		List<?> area_cd_list		= commonceService.getCommonCdListNew("B010");		//지역
		List<?>	urm_fix_list = urm_fix_select(request, map);   
		List<?>	urm_list = urm_list_select(request, map);    			//도매업자 업체명조회
//		List<?>	whsdl_cd_list 			= commonceService.whsdl_select(map);    				//도매업자 업체명조회
//		List<?> stat_cd_list		= commonceService.getCommonCdListNew("S200");						//상태
//		map.put("WORK_SE", "4"); 																				//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
//		HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);					//등록일자제한설정  
		
		try {
				model.addAttribute("titleSub", title);
				model.addAttribute("INQ_PARAMS",jParams);
				model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));
				model.addAttribute("urm_fix_list", util.mapToJson(urm_fix_list));
				model.addAttribute("urm_list", util.mapToJson(urm_list));
//				model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	
//				model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	 
//				model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));	  	 
				
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
	
	public ModelMap EPCE9000533_select(ModelMap model,
			HttpServletRequest request) {
		//파라메터 정보   
		String reqParams 				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams 			= JSONObject.fromObject(reqParams);
		Map<String, String> map 		= new HashMap<String, String>();
		String   	title						= commonceService.getMenuTitle("EPCE9000533");	//타이틀
		List<?>	urm_fix_list = urm_fix_select(request, map);   
		List<?>	urm_list = urm_select2(request, map);    			//도매업자 업체명조회
		
		try {
				model.addAttribute("titleSub", title);
				model.addAttribute("INQ_PARAMS",jParams);
				model.addAttribute("urm_fix_list", util.mapToJson(urm_fix_list));
				model.addAttribute("urm_list", util.mapToJson(urm_list));
				
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
	
	/*public ModelMap EPCE9000538_select(ModelMap model,
			HttpServletRequest request) {
		//파라메터 정보   
		String reqParams 				= util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams 			= JSONObject.fromObject(reqParams);
		Map<String, String> map 		= new HashMap<String, String>();
		String   	title						= commonceService.getMenuTitle("EPCE9000531");	//타이틀
		List<?> area_cd_list		= commonceService.getCommonCdListNew("B010");		//지역
		List<?>	urm_fix_list = urm_fix_select(request, map);   
		//List<?>	urm_list = urm_select(request, map);    			//도매업자 업체명조회
//		List<?>	whsdl_cd_list 			= commonceService.whsdl_select(map);    				//도매업자 업체명조회
//		List<?> stat_cd_list		= commonceService.getCommonCdListNew("S200");						//상태
//		map.put("WORK_SE", "4"); 																				//업무구분 1.출고 ,2.직접회수 ,3.교환 ,4.회수 , 5.반환
//		HashMap<?,?> rtc_dt_list	= commonceService.rtc_dt_list_select(map);					//등록일자제한설정  
		
		try {
			epce9000501Mapper.EPCE9000538_select(map);
				model.addAttribute("titleSub", title);
				model.addAttribute("INQ_PARAMS",jParams);
				model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));
				model.addAttribute("urm_fix_list", util.mapToJson(urm_fix_list));
				//model.addAttribute("urm_list", util.mapToJson(urm_list));
//				model.addAttribute("whsdl_cd_list", util.mapToJson(whsdl_cd_list));	
//				model.addAttribute("rtc_dt_list", util.mapToJson(rtc_dt_list));	  	 
//				model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));	  	 
				
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	
		return model;    	
    }*/
	
	


	public String epce900050142_update(HashMap<String, String> data,
			HttpServletRequest request) throws Exception{
		String errCd = "0000";
		String sUserId = "";


		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				//String ssBizrno = vo.getBIZRNO();
				data.put("USE_YN", data.get("gGubn").equals("A")?"Y":"N");
				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		map.put("S_USER_ID", sUserId);
			    		map.put("USE_YN", data.get("gGubn").equals("A")?"Y":"N");
			    		data.put("S_USER_ID", sUserId);
//			    		long urm_no = data.put("URM_NO", map.get("URM_NO"));
//						long urmno = Long.parseLong(data.put("URM_NO", map.get("URM_NO")));
//						String urm_no = String.valueOf(urmno);
//						data.put("URM_NO", urm_no);
			    		epce9000501Mapper.epce9000531_hist(map);	//등록 처리
			    		epce9000501Mapper.epce900050142_update(map);
			    		//무인회수기 변경이력
			    		
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
			/*e.printStackTrace();*/
			//취약점점검 6339 기원우
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
	}


	public HashMap<?, ?> epce9000501_2_select(HashMap<String, String> data)  {
		List<?> menuList = epce9000501Mapper.epce9000501_2_select(data);

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


	public ModelMap epce9000542_select(ModelMap model,
			HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE0160142");
		model.addAttribute("titleSub", title);

		List<?> BankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
		model.addAttribute("BankCdList", util.mapToJson(BankCdList));
		
		List<?> ErpCdList = commonceService.getCommonCdListNew("S022");//ERP코드리스트
		model.addAttribute("ErpCdList", util.mapToJson(ErpCdList));
		
		List<?> area_cd_list		= commonceService.getCommonCdListNew("B010");		//지역
		
		model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));	
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		HashMap<String, String> smap = (HashMap<String, String>)epce9000501Mapper.epce9000516_select(map);
		
		model.addAttribute("searchDtl", util.mapToJson(smap));

		return model;
	}       


}