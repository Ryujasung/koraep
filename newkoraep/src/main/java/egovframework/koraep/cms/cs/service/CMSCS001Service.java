package egovframework.koraep.cms.cs.service;

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
import egovframework.mapper.cms.CMSCS001Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 지급내역조회 서비스
 * @author Administrator
 *
 */
@Service("cmscs001Service")
public class CMSCS001Service {

	@Resource(name="cmscs001Mapper")
	private CMSCS001Mapper cmscs001Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 예금주조회결과 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap cmscs0001_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("CMSCS001");
		model.addAttribute("titleSub", title);
		
		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}
	/**
	 * 예금주조회결과조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> cmscs001_select2(Map<String, String> data) {
	
		List<?> list = cmscs001Mapper.cmscs001_select(data);
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
