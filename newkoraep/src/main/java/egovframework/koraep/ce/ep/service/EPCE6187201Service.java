package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE6187201Mapper;
  
/**
 * 기간별 대비 현황 Service  
 * @author 이근표
 *  
 */
@Service("epce6187201Service")  
public class EPCE6187201Service {  
	   
	@Resource(name="epce6187201Mapper")
	private EPCE6187201Mapper epce6187201Mapper;  //기간별 대비 현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 기간별 대비 현황 초기화면
	 * @param inputMap  
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce6187201_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> ctnrSe = commonceService.getCommonCdListNew("E005"); //빈용기구분 구/신
		List<?> prpsCd = commonceService.getCommonCdListNew("E002"); //빈용기구분 가정/유흥/반환
	    
		try {
			
			model.addAttribute("mfc_bizrnm_sel", util.mapToJson(commonceService.mfc_bizrnm_select(request)));
			model.addAttribute("ctnrSe", util.mapToJson(ctnrSe));
			model.addAttribute("prpsCd", util.mapToJson(prpsCd));
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
		}
		
		return model;    	
    }
  
	/**   
	 * 기간별 대비 현황  조회
	 * @param inputMap
	 * @param request
	 * @return
	 * @   
	 */   
	public HashMap<String, Object> epce6187201_select2(Map<String, String> inputMap, HttpServletRequest request) {
    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();

    	String MFC_BIZRNM = inputMap.get("MFC_BIZRNM");

		if(MFC_BIZRNM != null && !MFC_BIZRNM.equals("")){
			inputMap.put("MFC_BIZRID", MFC_BIZRNM.split(";")[0]);
			inputMap.put("MFC_BIZRNO", MFC_BIZRNM.split(";")[1]);
		}else{
			inputMap.put("MFC_BIZRID", "");
			inputMap.put("MFC_BIZRNO", "");
		}
		try {    
			
			List<?> list = null;
			
			list = epce6187201Mapper.epce6187201_select(inputMap);
			
			rtnMap.put("selList", util.mapToJson(list));
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
		}	  

    	return rtnMap;    	
    }
	
	/**
	 * 기간별 대비 현황 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce6187201_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
				
			List<?> list = epce6187201Mapper.epce6187201_select(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

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
	
	public ModelMap epce6187261_select(ModelMap model, HttpServletRequest request) {
		
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS", jParams);
		Map<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));

		model.addAttribute("titleSub", commonceService.getMenuTitle("EPCE6187261"));
		model.addAttribute("obj", util.mapToJson(epce6187201Mapper.epce6187201_select1(map)));

		return model;
	}
}