package egovframework.koraep.mf.ep.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.mapper.mf.ep.EPMF8149001Mapper;

/**
 * 공지사항 Service
 * @author pc
 *
 */
@Service("epmf8149001Service")
public class EPMF8149001Service {
	
	@Resource(name="epmf8149001Mapper")
	private EPMF8149001Mapper epmf8149001Mapper;
	
	/**
	 * 공지사항 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf8149001(ModelMap model, HttpServletRequest request)  {
		
		Map<String, String> map = new HashMap<String, String>();
				
		map.put("CONDITION", "");
		map.put("WORD", "");
		
		//공지사항 총 게시글 수 조회
		List<?> totalCnt = epmf8149001Mapper.epmf8149001(map);
		
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
	 * 공지사항 조회
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epmf8149001_select(Map<String, String> data, HttpServletRequest request)  {
		
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
		List<?> totalCnt = epmf8149001Mapper.epmf8149001(data);
		
		//공지사항 조회
		List<?> list = epmf8149001Mapper.epmf8149001_select1(data);
		
		//첨부파일 있는지 조회
		List<?> fileList = epmf8149001Mapper.epmf8149001_select2(data);
		
		int k = 0;
		String sTmpSbj = "";

		for(int i=0;i<list.size();i++){
			
			Map<String, String> rtn = (Map<String, String>)list.get(i);
		
			sTmpSbj = "<a class='link' href='javascript:fn_dtl_sel_lk("+ String.valueOf(rtn.get("NOTI_SEQ")) +");' target='_self'>" + rtn.get("SBJ") + "</a>";

			if(0 < fileList.size()){
				
				for(int j=k;j<fileList.size();j++){
					
					Map<String, String> rtnFile = (Map<String, String>)fileList.get(j);
					
					if(String.valueOf(rtn.get("NOTI_SEQ")).equals(String.valueOf(rtnFile.get("NOTI_SEQ")))){
						sTmpSbj += "&nbsp&nbsp<img src='/images/util/attach_ico.png'>" ;
						k++;
						break;
					}
				}
			}
			
			rtn.put("SBJ", sTmpSbj);
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
