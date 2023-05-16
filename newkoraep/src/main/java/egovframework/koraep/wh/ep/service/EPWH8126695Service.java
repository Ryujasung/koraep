package egovframework.koraep.wh.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.wh.ep.EPWH8126695Mapper;

/**
 * 문의/답변상세조회 Service
 * @author pc
 *
 */
@Service("epwh8126695Service")
public class EPWH8126695Service {
	
	@Resource(name="epwh8126695Mapper")
	private EPWH8126695Mapper epwh8126695Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 문의/답변 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh8126695(ModelMap model, HttpServletRequest request) throws Exception {
		
		String title = commonceService.getMenuTitle("EPWH8126695");	//타이틀
		model.addAttribute("titleSub", title);
		
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("ASK_SEQ", request.getParameter("ASK_SEQ"));
		map.put("CNTN_SE", request.getParameter("CNTN_SE"));
		
		//공지사항 상세조회
		List<?> askInfo = epwh8126695Mapper.epwh8126695_select1(map);
		
		//답변글이나 문의글 조회
		if("A".equals(map.get("CNTN_SE"))){
			map.put("CNTN_SE_R", "Q");
		} else if("Q".equals(map.get("CNTN_SE"))){
			map.put("CNTN_SE_R", "A");
		}
		
		if(null == askInfo) {
			model.addAttribute("askInfo", "{}");
		} 
		else {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			
			Map<String, String> askMap = (Map<String, String>)askInfo.get(0);
			
			if(!vo.getUSER_ID().equals(askMap.get("REG_PRSN_ID"))) {
				
				throw new Exception("A024");
			}

			model.addAttribute("askInfo", util.mapToJson(askInfo));

			for(int i=0;i<askInfo.size();i++){
				Map<String, String> rtn = (Map<String, String>) askInfo.get(i);
				rtn.put("REG_DTTM", rtn.get("REG_DTTM").substring(0, 4)+"-"+rtn.get("REG_DTTM").substring(4, 6)+"-"+rtn.get("REG_DTTM").substring(6));
				//rtn.put("CNTN", XSSFilter.getFilter(rtn.get("CNTN")));
			}
		}
		
		
		List<?> ansrInfo = epwh8126695Mapper.epwh8126695_select2(map);
		if(null == ansrInfo) {
			model.addAttribute("ansrInfo", "{}");
		} else {
			try {
				model.addAttribute("ansrInfo", util.mapToJson(ansrInfo));
			} catch (Exception e) {
				// TODO Auto-generated catch block

				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			
			for(int i=0;i<ansrInfo.size();i++){
				Map<String, String> rtn = (Map<String, String>)ansrInfo.get(i);
				String sbj = "<a class='link' href='javascript:fn_dtl_sel_lk("+ String.valueOf(rtn.get("ASK_SEQ")) + ", \"" + rtn.get("CNTN_SE") +"\");' target='_self'>" + rtn.get("SBJ") + "</a>";
				rtn.put("SBJ", sbj);
			}
		}
		
		
		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}
	
	/**
	 * 문의/답변 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@Transactional
	public int epwh8126695_delete(Map<String, String> data, HttpServletRequest request)  {
		
		int result = 0;
		
		result += epwh8126695Mapper.epwh8126695_delete(data);
		
		return result;
		
	}

}
