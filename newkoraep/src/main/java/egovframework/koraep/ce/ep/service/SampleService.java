package egovframework.koraep.ce.ep.service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.SampleMapper;

/**
 * 공지사항 Service
 * @author pc
 *
 */
@Service("sampleService")
public class SampleService {
	
	@Resource(name="sampleMapper")
	private SampleMapper sampleMapper;
	
	/**
	 * 공지사항 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap initList(ModelMap model, HttpServletRequest request)  {
		
		Map<String, String> map = new HashMap<String, String>();
		Map<String, String> inputMap = new HashMap<String, String>();
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		
		map.put("CONDITION", "");
		map.put("WORD", "");
		
		//공지사항 총 게시글 수 조회
		List<?> totalCnt = sampleMapper.totalCntList(map);
		
		try {
			if(null == totalCnt) {
				model.addAttribute("totalCnt", "{}");
			} else {
				model.addAttribute("totalCnt", util.mapToJson(totalCnt));
			}
			
			inputMap.put("BIZRNO", vo.getBIZRNO());
			inputMap.put("MFC_SE_CD", "NO");
			//빈용기명(표준용기) 리스트
			List<?> epcnStdCtnrList = sampleMapper.SELECT_EPCN_STD_CTNR_CD_LIST(inputMap);
			
			model.addAttribute("epcnMbrList", util.mapToJson(epcnStdCtnrList));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		
		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}
	
	/**
	 * 공지사항 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> searchList(Map<String, String> data, HttpServletRequest request)  {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		//검색범위 계산
		int startRnum = 0;	//검색 시작번호
		int endRnum = 0;	//검색 끝번호
		int page = Integer.parseInt(data.get("PAGE"));	//현재 페이지 번호
		int cntRow = Integer.parseInt(data.get("CNTROW"));	//페이지당 게시글 수
		
		if(page<=0 || page>=10000){
			page = 1;
		}
		
		if(cntRow<=0 || cntRow>=100){
			page = 12;
		}
		
		startRnum = (page - 1) * cntRow + 1;
		endRnum = page * cntRow;
		
		data.put("STARTROW", String.valueOf(startRnum));
		data.put("ENDROW", String.valueOf(endRnum));
		
		//공지사항 검색 게시글 수 조회
		List<?> totalCnt = sampleMapper.totalCntList(data);
		
		//공지사항 조회
		List<?> list = sampleMapper.searchList(data);
		
		
		try {
			map.put("searchList", util.mapToJson(list));
			map.put("totalCnt", util.mapToJson(totalCnt));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
		
	}

}
