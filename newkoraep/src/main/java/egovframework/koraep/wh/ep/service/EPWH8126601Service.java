package egovframework.koraep.wh.ep.service;
import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.mapper.wh.ep.EPWH8126601Mapper;

/**
 * 문의/답변 Service
 * @author pc
 *
 */
@Service("epwh8126601Service")
public class EPWH8126601Service {
	
	@Resource(name="epwh8126601Mapper")
	private EPWH8126601Mapper epwh8126601Mapper;
	
	/**
	 * 문의/답변 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epwh8126601(ModelMap model, HttpServletRequest request)  {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("CONDITION", "");
		map.put("WORD", "");
		map.put("USER_ID", vo.getUSER_ID());
		//map.put("MBR_SE_CD", vo.getMBR_SE_CD());
		
		//문의/답변 총 게시글 수 조회
		List<?> totalCnt = epwh8126601Mapper.epwh8126601(map);
		
		if(null == totalCnt) {
			model.addAttribute("totalCnt", "{}");
		} else {
			try {
				model.addAttribute("totalCnt", util.mapToJson(totalCnt));
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
		}
		
		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}
	
	/**
	 * 문의/답변 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epwh8126601_select(Map<String, String> data, HttpServletRequest request)  {
		
		HttpSession session = request.getSession();
		UserVO vo = (UserVO)session.getAttribute("userSession");
		
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
		data.put("USER_ID", vo.getUSER_ID());
		//data.put("MBR_SE_CD", vo.getMBR_SE_CD());
		
		//문의/답변 검색 게시글 수 조회
		List<?> totalCnt = epwh8126601Mapper.epwh8126601(data);
		
		//문의/답변 조회
		List<?> list = epwh8126601Mapper.epwh8126601_select(data);
		
		for(int i=0;i<list.size();i++){
			
			Map<String, String> rtn = (Map<String, String>)list.get(i);
			
			String sbj = null;
			
			if("Q".equals(rtn.get("CNTN_SE"))){
			
				sbj = "<a class='gridLink' href='javascript:fn_dtl_sel_lk("+ String.valueOf(rtn.get("ASK_SEQ")) + ", \"" + rtn.get("CNTN_SE") +"\");' target='_self'>문의 : " + rtn.get("SBJ") + "</a>";
			
				if(rtn.get("ANS_YN").equals("Y")){
					sbj += "   <font color='red'>(답변완료)</font>";
				}
			
			} else if("A".equals(rtn.get("CNTN_SE"))){
				
				sbj = "&nbsp&nbsp<a class='gridLink' href='javascript:fn_dtl_sel_lk("+ String.valueOf(rtn.get("ASK_SEQ")) + ", \"" + rtn.get("CNTN_SE") +"\");' target='_self'>ㄴ답변 : " + rtn.get("SBJ") + "</a>";
				rtn.put("ASK_SEQ", "");
				
			}
			
			rtn.put("SBJ", sbj);
			
		}
		
		
		try {
			map.put("searchList", util.mapToJson(list));
			map.put("totalCnt", util.mapToJson(totalCnt));
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
