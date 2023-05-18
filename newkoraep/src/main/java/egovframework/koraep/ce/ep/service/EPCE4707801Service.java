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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.ce.ep.EPCE4707801Mapper;

/**
 * 정산연간조정  서비스
 * @author Administrator
 *
 */
@Service("epce4707801Service")
public class EPCE4707801Service {

	@Resource(name="epce4707801Mapper")
	private EPCE4707801Mapper epce4707801Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce4707801_select(ModelMap model, HttpServletRequest request) {
		List<?> bizrList 	= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
		List<?> adj_se		= commonceService.getCommonCdListNew("C005");		//정산연간조정구분
		
		try {
			model.addAttribute("adj_se", util.mapToJson(adj_se));		//정산연간조정구분
			model.addAttribute("bizrList", util.mapToJson(bizrList));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}	//생산자 리스트
		return model;
	}
	
	/**
	 * 정산연간조정  조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce4707801_select2(Map<String, String> data) {
		
		List<?> searchList=null;
		String adjSe = data.get("ADJ_SE");
		
		if(("D").equals(adjSe)){
			searchList = epce4707801Mapper.epce4707801_select2(data); //출고량조정
		}else if(("C").equals(adjSe) || ("R").equals(adjSe)){
			searchList = epce4707801Mapper.epce4707801_select(data);	 //혼비율조정, 입고량 조정
		}
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(searchList));
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
	
	
	//---------------------------------------------------------------------------------------------------------------------
	//	조정수량관리
	//---------------------------------------------------------------------------------------------------------------------
		
	/**
	 * 페이지 초기값
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce4707888_select(Map<String, String> inputMap, HttpServletRequest request) {
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	  	//파라메터 정보
		String   title				= commonceService.getMenuTitle("EPCE4707888");		//타이틀
		List<?> inde_se		= commonceService.getCommonCdListNew("C006");		//증감구분
		List<?> initList			= epce4707801Mapper.epce4707888_select(inputMap);	//보증금

		try {
			if(inputMap.get("FYER_CRCT_DOC_NO") !=null){
				List<?> updList	= epce4707801Mapper.epce4707888_select3(inputMap);//수정시 데이터
				rtnMap.put("updList",util.mapToJson(updList)); 
			}
			
			rtnMap.put("titleSub", title);	  									   
			rtnMap.put("inde_se",util.mapToJson(inde_se));
			rtnMap.put("initList",util.mapToJson(initList));
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
		return rtnMap;    	
    }	
	
	/**
	 * 조정수량관리 삭제전 데이터 검색
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	public HashMap epce4707888_select2(Map<String, String> inputMap, HttpServletRequest request) {
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		int cnt = epce4707801Mapper.epce4707888_select4(inputMap); //상태 체크
		rtnMap.put("rstCnt", cnt);	 
		return rtnMap;    	
    }	
	
	/**
	 * 조정수량관리  등록
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4707888_insert(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			String errCd = "0000";
			try {
				inputMap.put("REG_PRSN_ID", vo.getUSER_ID());  		
				if(inputMap.get("FYER_CRCT_DOC_NO") !=null){							
					 int cnt = epce4707801Mapper.epce4707888_select4(inputMap); //상태 체크
					 if(cnt==0){
						throw new Exception("A008"); //변조된 데이터 입니다.
					 }
					 epce4707801Mapper.epce4707888_update(inputMap); 								//조정수량관리 수정
				}else{																											//조정수량관리 저장
					 String doc_psnb_cd ="FY"; 								   										// FY 연간조정등록시 채번
					 String fyer_crct_doc_no = commonceService.doc_psnb_select(doc_psnb_cd);	// 문서번호 조회
					 inputMap.put("FYER_CRCT_DOC_NO", fyer_crct_doc_no);								// 문서채번
					 epce4707801Mapper.epce4707888_insert(inputMap);									 //조정수량관리 저장
				}
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				 if(e.getMessage().equals("A008")){
					 throw new Exception(e.getMessage()); 
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}
			return errCd;	
    }
    
    
	/**
	 * 조정수량관리  삭제
	 * @param data
	 * @param request
	 * @return
	 * @throws Exception 
	 * @
	 */
    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public String epce4707888_delete(Map<String, String> inputMap,HttpServletRequest request) throws Exception  {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String errCd = "0000";
			try {
				inputMap.put("REG_PRSN_ID", vo.getUSER_ID());  		
				epce4707801Mapper.epce4707888_delete(inputMap);		
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
