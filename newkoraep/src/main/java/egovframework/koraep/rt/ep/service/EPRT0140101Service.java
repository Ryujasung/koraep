package egovframework.koraep.rt.ep.service;

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
import egovframework.mapper.rt.ep.EPRT0140101Mapper;

/**
 * 회원관리 서비스
 * @author Administrator
 *
 */
@Service("eprt0140101Service")
public class EPRT0140101Service {

	@Resource(name="eprt0140101Mapper")
	private EPRT0140101Mapper eprt0140101Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	
	/**
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap eprt0140164_select(ModelMap model, HttpServletRequest request, HashMap<String, String> map) {
		
		model.addAttribute("searchDtl", util.mapToJson(eprt0140101Mapper.eprt0140164_select(map)));

		return model;
	}
	
	/**
	 * 회원상세조회2
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> eprt0140164_select2(Map<String, String> data) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("searchDtl", util.mapToJson(eprt0140101Mapper.eprt0140164_select(data)));
		
		return map;
	}
	
	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap eprt0140142_select(ModelMap model, HttpServletRequest request) {
		
		String title = commonceService.getMenuTitle("EPRT0140142");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));
		
		/* 마이페이지 본인조회용 */
		if(map == null ){
			map = new HashMap<String, String>();
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				map.put("USER_ID", vo.getUSER_ID());
				map.put("S_BIZRNO", vo.getBIZRNO_ORI());
			}
		}
		
		HashMap<String, String> smap = (HashMap<String, String>)eprt0140101Mapper.eprt0140164_select(map);
		
		try {
			if(smap.get("BIZR_TP_CD").equals("T1")){//사업자유형 센터
				model.addAttribute("brchList", util.mapToJson(commonceService.getCommonCdListNew("B009"))); //센터지부
			}else{
				model.addAttribute("brchList", util.mapToJson(commonceService.brch_nm_select(request, smap)));
			}
			model.addAttribute("deptList", util.mapToJson(commonceService.dept_nm_select(smap)));
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
		
		model.addAttribute("searchDtl", util.mapToJson(smap));

		return model;
	}
	
	/**
	 * 회원 정보 변경 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String eprt0140142_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}
				
				if(data.containsKey("BRCH_CD")){
					if(data.get("BIZR_TP_CD").equals("T1")){
						data.put("CET_BRCH_CD", data.get("BRCH_CD"));
						data.put("BRCH_ID", "");
						data.put("BRCH_NO", "");
					}else{
						String[] brchIdNo = data.get("BRCH_CD").split(";");
						data.put("BRCH_ID", brchIdNo[0]);
						data.put("BRCH_NO", brchIdNo[1]);
						data.put("CET_BRCH_CD", "");
					}
				}else{
					data.put("GBN", "M"); //마이페이지에서 수정
					
					//변경비밀번호 작성시만 기존 비밀번호 체크
					if(!data.get("ALT_PWD").equals("")){
						String pwd = eprt0140101Mapper.eprt0140142_select(data); //USER_ID
						
						//기존비밀번호 체크, 센터메뉴에선 체크 안함
						String sBfPwd = data.get("PRE_PWD");
						sBfPwd = util.encrypt(sBfPwd);
						
						String sAfPwd = data.get("ALT_PWD");
						sAfPwd = util.encrypt(sAfPwd);
						
						if(!sBfPwd.equals(pwd)){
							throw new Exception("B017"); //"비밀번호가 맞지 않습니다.\n다시한번 확인 하시기 바랍니다.";
						}
						
						if(sAfPwd.equals(pwd)){
							throw new Exception("A028"); //"이전과 동일한 비밀번호를 사용할 수 없습니다.";
						}
					}
				
				}
				
				//비번 암호화
				if(!data.get("ALT_PWD").equals("")){
					String sAfPwd = data.get("ALT_PWD");
					if(util.encrypt(sAfPwd)!=null) {
						data.put("ALT_PWD", util.encrypt(sAfPwd));
					}
				}
				
				if(!data.containsKey("DEPT_CD")){
					data.put("DEPT_CD", "");
				}
				
				eprt0140101Mapper.eprt0140142_update(data);
				
				//사용자변경이력등록
	    		eprt0140101Mapper.eprt0140101_insert(data);
			    	
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			if(e.getMessage().equals("B017") ){
				 throw new Exception(e.getMessage());
			 }else if(e.getMessage().equals("A028") ){
				 throw new Exception(e.getMessage());
			 }else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			 }
		}
		
		return errCd;
		
	}
	
	/**
	 * 회원탈퇴
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	public String eprt0140164_update2(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		
		String errCd = "0000";
		
		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				String ssUserId = "";
				
				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				data.put("S_USER_ID", ssUserId);
				
				String id = (data.get("USER_ID") == null) ? "" : data.get("USER_ID");
				String voId = (ssUserId == null) ? "" : ssUserId;
				
				if(!id.equals(voId)){
					//"회원탈퇴 권한이 없습니다.";
					//return "B004";
				}

				eprt0140101Mapper.eprt0140164_update2(data);
				eprt0140101Mapper.eprt0140164_update3(data);
			    	
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
