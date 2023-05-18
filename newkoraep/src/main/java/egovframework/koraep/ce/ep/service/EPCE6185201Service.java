package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE6185201Mapper;
  
/**
 * 연도별출고회수현황 Service  
 * @author 이내희
 *  
 */
@Service("epce6185201Service")  
public class EPCE6185201Service {  
	
	   
	@Resource(name="epce6185201Mapper")
	private EPCE6185201Mapper epce6185201Mapper;  //연도별출고회수현황 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**   
	 * 연도별출고회수현황 초기화면
	 * @param inputMap  
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce6185201_select(ModelMap model, HttpServletRequest request) {

		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
		    
			Map<String, String> map= new HashMap<String, String>();		
			
			try {
				
				model.addAttribute("mfc_bizrnm_sel", util.mapToJson(commonceService.mfc_bizrnm_select(request)));
				
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
		 * 연도별출고회수현황  조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @   
		 */   
		public HashMap epce6185201_select2(Map<String, String> inputMap, HttpServletRequest request) {
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
    			
    			if(inputMap.get("SEL_GBN").equals("1")){
    				list = epce6185201Mapper.epce6185201_select(inputMap);
    			}else if(inputMap.get("SEL_GBN").equals("2")){
    				list = epce6185201Mapper.epce6185201_select2(inputMap);
    			}else if(inputMap.get("SEL_GBN").equals("3")){
    				list = epce6185201Mapper.epce6185201_select3(inputMap);
    			}else if(inputMap.get("SEL_GBN").equals("4") || inputMap.get("SEL_GBN").equals("5") ){
    				list = epce6185201Mapper.epce6185201_select4(inputMap);
    			}else if(inputMap.get("SEL_GBN").equals("6")){
    				list = epce6185201Mapper.epce6185201_select10(inputMap);
    			}
    			
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
		 * 연도별출고회수현황 그래프 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @   
		 */   
		public HashMap epce6185201_select3(Map<String, String> inputMap, HttpServletRequest request) {
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
    			List<?> list2 = null;
    			
    			if(inputMap.get("SEL_GBN").equals("1")){
    				list = epce6185201Mapper.epce6185201_select5(inputMap);
    				list2 = epce6185201Mapper.epce6185201_select6(inputMap);
    			}else if(inputMap.get("SEL_GBN").equals("2")){
    				list = epce6185201Mapper.epce6185201_select8(inputMap);
    			}else if(inputMap.get("SEL_GBN").equals("3")){
    				list = epce6185201Mapper.epce6185201_select9(inputMap);
    			}else{
    				list = epce6185201Mapper.epce6185201_select7(inputMap);
    			}
    			
				rtnMap.put("selList", util.mapToJson(list));
				rtnMap.put("selList2", util.mapToJson(list2));
				
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
		 * 연도별출고회수현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce6185201_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
					
				List<?> list = epce6185201Mapper.epce6185201_select(data);

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
}
