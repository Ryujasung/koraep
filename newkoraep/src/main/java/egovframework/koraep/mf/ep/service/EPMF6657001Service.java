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
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF6657001Mapper;

/**
 * 연간출고회수현황확인서 Service
 * @author pc
 *
 */
@Service("epmf6657001Service")
public class EPMF6657001Service {
	
	@Resource(name="epmf6657001Mapper")
	private EPMF6657001Mapper epmf6657001Mapper;
	
	@Resource(name="commonceService")
    private CommonCeService commonceService;
	
	/**
	 * 연간출고회수현황확인서 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epmf6657001_select(ModelMap model, HttpServletRequest request) {

		    Map<String, String> map = new HashMap<String, String>();
		  
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			String ssUserNm = "";   //사용자명
			String ssBizrNm = "";   //부서명
			if(vo != null){
				ssUserNm = vo.getUSER_NM();
				ssBizrNm = vo.getBIZRNM();
			}
			model.addAttribute("ssUserNm", ssUserNm);
			model.addAttribute("ssBizrNm", ssBizrNm);
		    
			try {
				List<?> ctnrSe = commonceService.getCommonCdListNew("E005"); //빈용기구분 구/신
				model.addAttribute("ctnrSe", util.mapToJson(ctnrSe));
				
				List<?> prpsCdList	 = commonceService.getCommonCdListNew("E002"); //용도
				model.addAttribute("prpsCdList", util.mapToJson(prpsCdList));	
				
				List<?> alkndCdList	 = commonceService.getCommonCdListNew("E004"); //주종
				model.addAttribute("alkndCdList", util.mapToJson(alkndCdList));	

				List<?> mfcBizrList = commonceService.mfc_bizrnm_select(request); // 생산자
				model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	
			} catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	
						
			return model;    	
	    }
	  
	  /**
	   * 연간출고회수현황확인서 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epmf6657001_select2(Map<String, Object> data) {

			HashMap<String, Object> map = new HashMap<String, Object>();
			
			List<?> list = epmf6657001Mapper.epmf6657001_select(data);
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
			
			map.put("totalList", epmf6657001Mapper.epmf6657001_select_cnt(data));
			
			return map;
  	  }
  	  
  	  public String epmf6657001_excel(HashMap<String, Object> data, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null ){
			data.put("T_USER_ID", vo.getUSER_ID());
		}
		
		String errCd = "0000";
		try {
			List<?> list = epmf6657001Mapper.epmf6657001_select(data);
			
			//object라 String으로 담아서 보내기
			HashMap<String, String> map = new HashMap<String, String>(); 
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());
			
			//엑셀파일 저장
			commonceService.excelSave(request, map, list);
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
