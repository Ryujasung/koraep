package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE3969301Mapper;

/**
 * 배치관리 서비스
 * @author Administrator
 *
 */
@Service("epce3969301Service")
public class EPCE3969301Service {

	@Resource(name="epce3969301Mapper")
	private EPCE3969301Mapper epce3969301Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce3969301_select(ModelMap model, HttpServletRequest request) {

		List<?> reptList = commonceService.getCommonCdListNew("S010");//반복여부
		List<?> useList = commonceService.getCommonCdListNew("S008");//사용여부
		
		
		try {
			model.addAttribute("reptList", util.mapToJson(reptList));
			model.addAttribute("useList", util.mapToJson(useList));
			
			List<?> procList = epce3969301Mapper.epce3969301_select(); //프로시저 목록
			model.addAttribute("procList", util.mapToJson(procList));
			
			List<?> btchList = epce3969301Mapper.epce3969301_select2(); //배치 목록
			model.addAttribute("btchList", util.mapToJson(btchList));
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
	 * 배치관리 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce3969301_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				
				data.put("S_USER_ID", "");
				
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				
				if(data.get("NEW_YN").equals("Y")){
					//스케줄러 생성
					epce3969301Mapper.epce3969301_update2(data);
				}else{
					
					String jobNm = "JOB_" + data.get("BTCH_CD");
					data.put("JOB_NM", jobNm);
					
					String schNm = "SCH_" + data.get("BTCH_CD");
					data.put("SCH_NM", schNm);
					
					//스케줄러 변경
					epce3969301Mapper.epce3969301_update3(data);
				}
				
				epce3969301Mapper.epce3969301_update(data);	
				
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
	 * 배치관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce3969301_select2() {
		
		List<?> list = epce3969301Mapper.epce3969301_select2();

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(list));
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
	
}
