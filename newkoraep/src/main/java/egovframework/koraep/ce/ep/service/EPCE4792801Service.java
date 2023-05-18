package egovframework.koraep.ce.ep.service;

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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE4770701Mapper;
import egovframework.mapper.ce.ep.EPCE4792801Mapper;

/**
 * 도매업자정산발급  서비스
 * @author Administrator
 *
 */
@Service("epce4792801Service")
public class EPCE4792801Service {

	@Resource(name="epce4792801Mapper")
	private EPCE4792801Mapper epce4792801Mapper;
	
	@Resource(name="epce4770701Mapper")
	private EPCE4770701Mapper epce4770701Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4792801_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		List<?> mfcBizrList = epce4770701Mapper.epce4770701_select();
				
		try {
			model.addAttribute("excaStdMgnt", util.mapToJson(epce4792801Mapper.epce4792801_select()));	
			model.addAttribute("mfcBizrList", util.mapToJson(mfcBizrList));	
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
	 * 도매업자정산내역 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4792864_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE4792864");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		Map<String, String> param = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				
		try {
			model.addAttribute("searchList", util.mapToJson(epce4792801Mapper.epce4792864_select(param)));	
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
	 * 도매업자정산발급 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4792801_select2(Map<String, String> data) {

		String BIZRID_NO = data.get("MFC_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("BIZRID", BIZRID_NO.split(";")[0]);
			data.put("BIZRNO", BIZRID_NO.split(";")[1]);
		}
		
		List<?> list = epce4792801Mapper.epce4792801_select2(data);

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
	
	/**
	 * 도매업자 정산서발급
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4792801_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception  {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");
		String errCd = "0000";
		String ssUserId  = "";   //사용자ID

		try {
			
			if(vo != null){
				ssUserId = vo.getUSER_ID();
			}
			
			String BIZRID_NO = inputMap.get("MFC_BIZR_SEL");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				inputMap.put("BIZRID", BIZRID_NO.split(";")[0]);
				inputMap.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}
			
			//List<JSONObject> list = JSONArray.fromObject(inputMap.get("list"));
			//재조회 함
			List<?> list = epce4792801Mapper.epce4792801_select2(inputMap);
	
			for(int i=0; i<list.size(); i++){
				
				Map<String, String> map = (Map<String, String>) list.get(i);
				
				//정산서문서번호 조회
				String doc_psnb_cd ="BL"; 
		 		String stac_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
				map.put("STAC_DOC_NO", stac_doc_no); 											//문서채번
				map.put("EXCA_PROC_STAT_CD", "I");												//I:발급 (C024)
				map.put("EXCA_ISSU_SE_CD", "W"); 													//정산서발급구분코드(G:보증금, F:취급수수료, W:반환정산)
				map.put("WRHS_CRCT_PAY_AMT", map.get("EXCA_SE_CD").equals("A") ? String.valueOf(map.get("EXCA_AMT")):"0");
				map.put("WRHS_CRCT_ACP_AMT", map.get("EXCA_SE_CD").equals("C") ? String.valueOf(map.get("EXCA_AMT")):"0");
				map.put("S_USER_ID", ssUserId);

				//정산서발급 
				epce4792801Mapper.epce4792801_insert(map);
				
				//정산서발급 상세 
				epce4792801Mapper.epce4792801_insert2(map);
				
				//입고정정 상태변경
				epce4792801Mapper.epce4792801_update(map);
				
	    	}
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
		
	}
}
