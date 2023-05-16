package egovframework.koraep.mf.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.mf.ep.EPMF8169901Mapper;

/**
 * FAQ Service
 * @author pc
 *
 */
@Service("epmf8169901Service")
public class EPMF8169901Service {
	
	@Resource(name="epmf8169901Mapper")
	private EPMF8169901Mapper epmf8169901Mapper;
	
	/**
	 * FAQ 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf8169901(ModelMap model, HttpServletRequest request)  {
		
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("CONDITION", "");
		map.put("WORD", "");
		
		//FAQ 총 게시글 수 조회
		List<?> totalCnt = epmf8169901Mapper.epmf8169901_select1(map);
		
		if(null == totalCnt) {
			model.addAttribute("totalCnt", "{}");
		} else {
			try {
				model.addAttribute("totalCnt", util.mapToJson(totalCnt));
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
	 * FAQ 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf8169901_select(Map<String, String> data, HttpServletRequest request)  {
		
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
		
		//FAQ 검색 게시글 수 조회
		List<?> totalCnt = epmf8169901Mapper.epmf8169901_select1(data);
		
		//FAQ 조회
		List<?> list = epmf8169901Mapper.epmf8169901_select2(data);

		//첨부파일 있는지 조회
		List<?> fileList = epmf8169901Mapper.epmf8169901_select3(data);
		
		for(int i=0;i<list.size();i++){
			
			Map<String, String> rtn = (Map<String, String>)list.get(i);
			
			String sbj = null;
			
			if(0 < fileList.size()){
				
				for(int j=0;j<fileList.size();j++){
					
					Map<String, String> rtnFile = (Map<String, String>)fileList.get(j);
					
					if(String.valueOf(rtn.get("FAQ_SEQ")).equals(String.valueOf(rtnFile.get("FAQ_SEQ")))){
						
						sbj = "<a class='link' href='javascript:fn_dtl_sel_lk("+ String.valueOf(rtn.get("FAQ_SEQ")) +");' target='_self'>" + rtn.get("SBJ") + "&nbsp&nbsp<img src='/images/util/attach_ico.png'></a>";
						
						rtn.put("SBJ", sbj);
						
					} else {
						
						sbj = "<a class='link' href='javascript:fn_dtl_sel_lk("+ String.valueOf(rtn.get("FAQ_SEQ")) +");' target='_self'>" + rtn.get("SBJ") + "</a>";
						
						rtn.put("SBJ", sbj);
						
					}
					
				}
				
			} else {
				
				sbj = "<a class='link' href='javascript:fn_dtl_sel_lk("+ String.valueOf(rtn.get("FAQ_SEQ")) +");' target='_self'>" + rtn.get("SBJ") + "</a>";
				
				rtn.put("SBJ", sbj);
				
			}
			
		}
			
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
