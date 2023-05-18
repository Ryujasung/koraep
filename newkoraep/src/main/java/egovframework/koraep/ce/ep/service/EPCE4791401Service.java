package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE4791401Mapper;

/**
 * 정산기간관리  서비스
 * @author Administrator
 *
 */
@Service("epce4791401Service")
public class EPCE4791401Service {

	@Resource(name="epce4791401Mapper")
	private EPCE4791401Mapper epce4791401Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4791401_select(ModelMap model, HttpServletRequest request) {

		List<?> statList = commonceService.getCommonCdListNew("C011");
		try {
			model.addAttribute("statList", util.mapToJson(statList));
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
	 * 정산기간관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4791401_select2(Map<String, String> data) {
		
		List<?> menuList = epce4791401Mapper.epce4791401_select(data);

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
	 * 정산기간등록 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4791431_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPCE4791431");
		model.addAttribute("titleSub", title);
		
		return model;
	}
	
	/**
	 * 생산자 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4791431_select2(Map<String, String> data) {
		
		if(!data.containsKey("EXCA_STD_CD")){
			data.put("EXCA_STD_CD", "");
		}
		
		List<?> bizrList = epce4791401Mapper.epce4791431_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(bizrList));
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
	 * 정산기간변경 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4791442_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPCE4791442");
		model.addAttribute("titleSub", title);
		
		return model;
	}
	
	/**
	 * 정산기간상세조회 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4791464_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPCE4791464");
		model.addAttribute("titleSub", title);

		return model;
	}
	
	/**
	 * 정산기간 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4791464_select(Map<String, String> data) {
		
		List<?> list = epce4791401Mapper.epce4791464_select(data);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchDtl", util.mapToJson(list));
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
	 * 등록
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce4791431_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
					sUserId = vo.getUSER_ID();
				}

				String EXCA_ST_DT = "";
			    String EXCA_END_DT = "";
			    String EXCA_SE_YEAR = "";
			    String EXCA_SE_QTRMT = "";
				
				if(data.get("EXCA_SE_CD").equals("Q")){
					
					EXCA_SE_YEAR = data.get("QTY_YEAR");
					EXCA_SE_QTRMT = data.get("QTY");
					String QTY_YEAR = data.get("QTY_YEAR");
					String QTY = data.get("QTY");
					
					if(QTY.equals("1")){
						EXCA_ST_DT = QTY_YEAR + "0101";
						EXCA_END_DT = QTY_YEAR + "0331";
					}else if(QTY.equals("2")){
						EXCA_ST_DT = QTY_YEAR + "0401";
						EXCA_END_DT = QTY_YEAR + "0630";
					}else if(QTY.equals("3")){
						EXCA_ST_DT = QTY_YEAR + "0701";
						EXCA_END_DT = QTY_YEAR + "0930";
					}else if(QTY.equals("4")){
						EXCA_ST_DT = QTY_YEAR + "1001";
						EXCA_END_DT = QTY_YEAR + "1231";
					}
					
				}else if(data.get("EXCA_SE_CD").equals("M")){
					
					EXCA_SE_YEAR = data.get("MT_YEAR");
					EXCA_SE_QTRMT = data.get("MT");
					String MT_YEAR = data.get("MT_YEAR");
					String MT = data.get("MT");
					
					GregorianCalendar cld = new GregorianCalendar ( Integer.parseInt(MT_YEAR), Integer.parseInt(MT) - 1, 1 );
					int lastDay = cld.getActualMaximum ( Calendar.DAY_OF_MONTH );
		
					EXCA_ST_DT = MT_YEAR + MT + "01";
					EXCA_END_DT = MT_YEAR + MT + lastDay;
					
				}else if(data.get("EXCA_SE_CD").equals("S")){
					
					EXCA_SE_YEAR = data.get("EXCA_ST_DT").substring(0,4);
					
					EXCA_ST_DT = data.get("EXCA_ST_DT").replace("-", "");
				    EXCA_END_DT = data.get("EXCA_END_DT").replace("-", "");
				    
				}
				
				String CRCT_PSBL_ST_DT = data.get("CRCT_PSBL_ST_DT").replace("-", "");
				String CRCT_PSBL_END_DT = data.get("CRCT_PSBL_END_DT").replace("-", "");
				String CRCT_CFM_END_DT = data.get("CRCT_CFM_END_DT").replace("-", "");
				
				//일련번호 채번
				String seq = commonceService.psnb_select("S0006");
				String EXCA_STD_CD = EXCA_ST_DT+""+EXCA_END_DT+"_"+seq;
			    data.put("EXCA_STD_CD", EXCA_STD_CD);
			    data.put("EXCA_ST_DT", EXCA_ST_DT);
			    data.put("EXCA_END_DT", EXCA_END_DT);
			    
			    data.put("EXCA_SE_YEAR", EXCA_SE_YEAR);
			    data.put("EXCA_SE_QTRMT", EXCA_SE_QTRMT);
			    
			    data.put("CRCT_PSBL_ST_DT", CRCT_PSBL_ST_DT);
			    data.put("CRCT_PSBL_END_DT", CRCT_PSBL_END_DT);
			    data.put("CRCT_CFM_END_DT", CRCT_CFM_END_DT);

			    data.put("REG_SN", seq);
			    
				epce4791401Mapper.epce4791431_insert(data); //등록
				
				if(data.get("TRGT_YN").equals("I")){
					//생산자 체크목록
					List<?> list = JSONArray.fromObject(data.get("list"));
					
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		
			    		map.put("S_USER_ID", sUserId);
			    		map.put("EXCA_STD_CD", EXCA_STD_CD);

			    		epce4791401Mapper.epce4791431_insert2(map);	//대상등록
			    	}
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
	 * 수정
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce4791442_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String sUserId = "";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
					sUserId = vo.getUSER_ID();
				}

				String EXCA_ST_DT = "";
			    String EXCA_END_DT = "";
			    String EXCA_SE_YEAR = "";
			    String EXCA_SE_QTRMT = "";
				
				if(data.get("EXCA_SE_CD").equals("Q")){
					
					EXCA_SE_YEAR = data.get("QTY_YEAR");
					EXCA_SE_QTRMT = data.get("QTY");
					String QTY_YEAR = data.get("QTY_YEAR");
					String QTY = data.get("QTY");
					
					if(QTY.equals("1")){
						EXCA_ST_DT = QTY_YEAR + "0101";
						EXCA_END_DT = QTY_YEAR + "0331";
					}else if(QTY.equals("2")){
						EXCA_ST_DT = QTY_YEAR + "0401";
						EXCA_END_DT = QTY_YEAR + "0630";
					}else if(QTY.equals("3")){
						EXCA_ST_DT = QTY_YEAR + "0701";
						EXCA_END_DT = QTY_YEAR + "0930";
					}else if(QTY.equals("4")){
						EXCA_ST_DT = QTY_YEAR + "1001";
						EXCA_END_DT = QTY_YEAR + "1231";
					}
					
				}else if(data.get("EXCA_SE_CD").equals("M")){
					
					EXCA_SE_YEAR = data.get("MT_YEAR");
					EXCA_SE_QTRMT = data.get("MT");
					String MT_YEAR = data.get("MT_YEAR");
					String MT = data.get("MT");
					
					GregorianCalendar cld = new GregorianCalendar ( Integer.parseInt(MT_YEAR), Integer.parseInt(MT) - 1, 1 );
					int lastDay = cld.getActualMaximum ( Calendar.DAY_OF_MONTH );
		
					EXCA_ST_DT = MT_YEAR + MT + "01";
					EXCA_END_DT = MT_YEAR + MT + lastDay;
					
				}else if(data.get("EXCA_SE_CD").equals("S")){
					
					EXCA_SE_YEAR = data.get("EXCA_ST_DT").substring(0,4);
					
					EXCA_ST_DT = data.get("EXCA_ST_DT").replace("-", "");
				    EXCA_END_DT = data.get("EXCA_END_DT").replace("-", "");
				    
				}
				
				String CRCT_PSBL_ST_DT = data.get("CRCT_PSBL_ST_DT").replace("-", "");
				String CRCT_PSBL_END_DT = data.get("CRCT_PSBL_END_DT").replace("-", "");
				String CRCT_CFM_END_DT = data.get("CRCT_CFM_END_DT").replace("-", "");
				
			    data.put("EXCA_ST_DT", EXCA_ST_DT);
			    data.put("EXCA_END_DT", EXCA_END_DT);
			    
			    data.put("EXCA_SE_YEAR", EXCA_SE_YEAR);
			    data.put("EXCA_SE_QTRMT", EXCA_SE_QTRMT);
			    
			    data.put("CRCT_PSBL_ST_DT", CRCT_PSBL_ST_DT);
			    data.put("CRCT_PSBL_END_DT", CRCT_PSBL_END_DT);
			    data.put("CRCT_CFM_END_DT", CRCT_CFM_END_DT);
			    
				epce4791401Mapper.epce4791442_update(data); //등록
				
				if(data.get("TRGT_YN").equals("I")){
					//생산자 체크목록
					List<?> list = JSONArray.fromObject(data.get("list"));
					
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);
			    		
			    		map.put("S_USER_ID", sUserId);
			    		map.put("EXCA_STD_CD", data.get("EXCA_STD_CD"));
			    		
			    		if(i == 0){
			    			epce4791401Mapper.epce4791442_delete(map);//기존권한 그룹메뉴 모두 삭제
			    		}
			    		
			    		epce4791401Mapper.epce4791431_insert2(map);	//대상등록
			    	}
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
	 * 삭제
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String epce4791442_delete(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
			
			epce4791401Mapper.epce4791442_delete(data);//삭제
			epce4791401Mapper.epce4791442_delete2(data); //삭제
			
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
	 * 상태 변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String EPCE4791464_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}
				
				data.put("S_USER_ID", ssUserId);
	
				epce4791401Mapper.epce4791464_update(data);	//수정 처리

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
	
}
