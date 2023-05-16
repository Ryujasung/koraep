package egovframework.koraep.cms.cs.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.cms.CMSCS003Mapper;
import net.sf.json.JSONObject;

/**
 * 계좌거래내역조회 서비스
 * @author Administrator
 *
 */
@Service("cmscs003Service")
public class CMSCS003Service {

	@Resource(name="cmscs003Mapper")
	private CMSCS003Mapper cmscs003Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 계좌거래내역조회 페이지 초기화
	 * 
	 * @param model
	 * @param request
	 * @return @
	 */
	public ModelMap cmscs003_select(ModelMap model, HttpServletRequest request) {
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
		
		List<?> acctNoList = cmscs003Mapper.cmscs003_select0(null);
		model.addAttribute("acctNoList", util.mapToJson(acctNoList)); //계좌번호 리스트
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}

	/**
	 * 계좌거래내역조회
	 * 
	 * @param model
	 * @param request
	 * @return @
	 */
	public HashMap<String, Object> cmscs003_select2(Map<String, String> data) {

		String acctTy = data.get("ACCT_SEL");
		List<?> searchList = new ArrayList();
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			
			if(acctTy.equals("01")) {
				searchList = cmscs003Mapper.cmscs003_select(data);	// 가상계좌
			} else {
				searchList = cmscs003Mapper.cmscs003_select2(data);	// 실계좌
			}

			map.put("searchList", util.mapToJson(searchList));
			
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}
	
	/**
	 *  엑셀저장
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String cmscs003_excel(HashMap<String, String> data, HttpServletRequest request) {
		String errCd = "0000";

		String acctTy = data.get("ACCT_SEL");
		List<?> list = new ArrayList();
		
		try {
			
			if(acctTy.equals("01")) {
				list = cmscs003Mapper.cmscs003_select(data);	// 가상계좌
			} else {
				list = cmscs003Mapper.cmscs003_select2(data);	// 실계좌
			}
		
			HashMap<String, String> map = new HashMap();

			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());

			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
	}
	
	/**
	 * 계좌잔액조회
	 * 
	 * @param model
	 * @param request
	 * @return @
	 */
	public HashMap<String, Object> cmscs003_select3(Map<String, String> data) {

		HashMap<String, Object> map = new HashMap<String, Object>();

		try {
			
			List<?> acctBalList = cmscs003Mapper.cmscs003_select3(data);
			map.put("searchList", util.mapToJson(acctBalList));
			
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}
}
