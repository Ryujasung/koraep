package egovframework.koraep.ce.ep.service;

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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE2371201Mapper;

/**
 * 취급수수료고지서 서비스
 * @author Administrator
 *
 */
@Service("epce2371201Service")
public class EPCE2371201Service {

	@Resource(name="epce2371201Mapper")
	private EPCE2371201Mapper epce2371201Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce2371201_select(ModelMap model, HttpServletRequest request) {

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		try {
			List<?> bizrList 	= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
			model.addAttribute("bizrList", util.mapToJson(bizrList));	//생산자 리스트

			//구분코드
			List<?> rtnStatList = epce2371201Mapper.epce2371201_select();
			model.addAttribute("rtnStatList", util.mapToJson(rtnStatList)); //구분리스트
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
		
		HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("SEL_PARAMS"));
		Map<String, String> map = new HashMap<String, String>();
		if(jmap != null){
			
			String BIZRID_NO = jmap.get("MFC_BIZR_SEL");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				map.put("BIZRID", BIZRID_NO.split(";")[0]);
				map.put("BIZRNO", BIZRID_NO.split(";")[1]);
			}else{
				map.put("BIZRID", "");
				map.put("BIZRNO", "");
			}
			List<?> reqBrchList	= commonceService.brch_nm_select(request, map);
			try {
				model.addAttribute("brchList", util.mapToJson(reqBrchList)); //직매장
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
			
		}else{
			model.addAttribute("brchList", "{}");	//직매장
		}
		
		return model;
	}
	
	/**
	 * 취급수수료고지서 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce2371201_select2(Map<String, String> data) {
		
		String BIZRID_NO = data.get("MFC_BIZR_SEL");
		if(BIZRID_NO != null && !BIZRID_NO.equals("")){
			data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
			data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
		}
		String BRCH_ID_NO = data.get("MFC_BRCH_SEL");
		if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
			data.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
			data.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
		}
		
		List<?> list = epce2371201Mapper.epce2371201_select2(data);

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
	 * 취급수수료고지서 발급
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce2371201_insert(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		String ssUserId  = "";   //사용자ID
		if(vo != null){
			ssUserId = vo.getUSER_ID();
		}
		
		String errCd = "0000";
		List<?> list = JSONArray.fromObject(inputMap.get("list"));
		List<Map<String, String>>list2 = new ArrayList<Map<String,String>>();

		if (list != null) {
			try {				
				
				for(int i=0; i<list.size(); i++){
					
					String bill_doc_no ="";
					int cnt = 0;
					boolean keyCheck = false;
					
					Map<String, String> map = (Map<String, String>) list.get(i);
					map.put("S_USER_ID", ssUserId);
					
					//데이터 체크
					Map<String, String> checkMap = epce2371201Mapper.epce2371201_select3(map);
					
					if(!checkMap.get("CFM_QTY_TOT").equals(String.valueOf(map.get("CFM_QTY_TOT"))) 
							|| !checkMap.get("CFM_FEE_TOT").equals(String.valueOf(map.get("CFM_FEE_TOT")))
							|| !checkMap.get("CFM_GTN_TOT").equals(String.valueOf(map.get("CFM_GTN_TOT"))) )
					{
						//취급수수료정보가 일치하지 않습니다. 재조회 후 처리 바랍니다.
						throw new Exception("D002");
					}
					
					for(int j=0 ;j<list2.size(); j++){
						
						Map<String, String> map2 = (Map<String, String>) list2.get(j);
						
				 		if( map.get("MFC_BIZRID").equals(map2.get("MFC_BIZRID")) && map.get("MFC_BIZRNO").equals(map2.get("MFC_BIZRNO")) 
				 			&& map.get("STD_YEAR").equals(map2.get("STD_YEAR")) )
				 	      {
				 			map.put("BILL_DOC_NO", map2.get("BILL_DOC_NO"));
				 			keyCheck = true;
				 			break;
				 		  }
					}
					
					if(!keyCheck){
				 		
				 		String doc_psnb_cd ="BF"; 
				 		bill_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
						map.put("BILL_DOC_NO", bill_doc_no);										//문서채번

						//master
						epce2371201Mapper.epce2371201_insert(map); 			// 마스터 등록

				 		list2.add(map);
				 	}	
				 	
				 	//detail
					cnt = epce2371201Mapper.epce2371201_insert2(map); 		// 상세 등록
					
					if(cnt == 0){
						throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
					}
					
					map.put("RTN_STAT_CD", "IB"); //고지등록 상태로 변경
					epce2371201Mapper.epce2371201_update(map); 		// 입고 및 반환 마스터 상태 변경
					
				}
				
				for(int j=0 ;j<list2.size(); j++){
					Map<String, String> map2 = (Map<String, String>) list2.get(j);
					epce2371201Mapper.epce2371201_update2(map2); //마스터 테이블 합계데이터 업데이트
					
					//잔액 인서트
					//epce2371201Mapper.epce2371201_insert3(map2); 보증금 발급시 처리함 20180730 
				}
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch (Exception e) {
				if(e.getMessage().equals("A012") || e.getMessage().equals("D002") ){
					throw new Exception(e.getMessage()); 
				 }else{
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
			
		}else{
			errCd = "A007"; //저장할 데이타가 없습니다.
		}
		
		return errCd;    	
		
	}
	
	/**
	 *  엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce2371201_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {
			
			String BIZRID_NO = data.get("MFC_BIZR_SEL");
			if(BIZRID_NO != null && !BIZRID_NO.equals("")){
				data.put("MFC_BIZRID", BIZRID_NO.split(";")[0]);
				data.put("MFC_BIZRNO", BIZRID_NO.split(";")[1]);
			}
			String BRCH_ID_NO = data.get("MFC_BRCH_SEL");
			if(BRCH_ID_NO != null && !BRCH_ID_NO.equals("")){
				data.put("MFC_BRCH_ID", BRCH_ID_NO.split(";")[0]);
				data.put("MFC_BRCH_NO", BRCH_ID_NO.split(";")[1]);
			}
			
			data.put("excelYn", "Y");
			List<?> list = epce2371201Mapper.epce2371201_select2(data);

			HashMap<String, String> map = new HashMap();
						
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
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}
		
		return errCd;
	}
	
}
