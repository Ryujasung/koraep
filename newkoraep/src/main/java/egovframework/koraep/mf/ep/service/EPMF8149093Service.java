package egovframework.koraep.mf.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF8149093Mapper;

/**
 * 공지사항 상세조회 Service
 * @author pc
 *
 */
@Service("epmf8149093Service")
public class EPMF8149093Service {
	
	@Resource(name="epmf8149093Mapper")
	private EPMF8149093Mapper epmf8149093Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil EgovFileMngUtil;
	
	/**
	 * 공지사항 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@Transactional
	public ModelMap epmf8149093(ModelMap model, HttpServletRequest request)  {
		
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("NOTI_SEQ", request.getParameter("NOTI_SEQ"));
		
		try{
		
		//공지사항 상세조회
		List<?> notiInfo = epmf8149093Mapper.epmf8149093_select1(map);
		
		//공지사항 조회수 증가
		epmf8149093Mapper.epmf8149093_update(map);
		
		//이전글 제목 조회
		List<?> preNoti = epmf8149093Mapper.epmf8149093_select2(map);
		
		//다음글 제목 조회
		List<?> nextNoti = epmf8149093Mapper.epmf8149093_select3(map);
		
		//공지사항 첨부파일 조회
		List<?> fileList = epmf8149093Mapper.epmf8149093_select4(map);
		
		
		
		if(null == notiInfo) {
			model.addAttribute("notiInfo", "{}");
		} else {
			model.addAttribute("notiInfo", util.mapToJson(notiInfo));
			
			for(int i=0;i<notiInfo.size();i++){
				Map<String, String> rtn = (Map<String, String>) notiInfo.get(i);
				
				rtn.put("REG_DTTM", rtn.get("REG_DTTM").substring(0, 4)+"-"+rtn.get("REG_DTTM").substring(4, 6)+"-"+rtn.get("REG_DTTM").substring(6));
				//rtn.put("CNTN", XSSFilter.getFilter(rtn.get("CNTN")));

			}
		}
		
		if(null == preNoti) {
			model.addAttribute("preNoti", "{}");
		} else {
			model.addAttribute("preNoti", util.mapToJson(preNoti));
		}
		
		if(null == nextNoti) {
			model.addAttribute("nextNoti", "{}");
		} else {
			model.addAttribute("nextNoti", util.mapToJson(nextNoti));
		}
		
		if(null == fileList) {
			model.addAttribute("fileList", "{}");
		} else {
			model.addAttribute("fileList", util.mapToJson(fileList));
		}
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		
		String title = commonceService.getMenuTitle("EPMF8149093");
		model.addAttribute("titleSub", title);
		
		
		return model;
	}
	
	/**
	 * 공지사항 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@Transactional
	public int epmf8149093_delete(Map<String, String> data, HttpServletRequest request)  {
		
		int result = 0;
		
		boolean fileChk = false;
		
		List<?> fileList = JSONArray.fromObject(data.get("fileList"));
		
		try{
		
		for(int i=0; i<fileList.size(); i++) {
			
			Map<String, String> map = (Map<String, String>) fileList.get(i);
			
			if(!"NONFILE".equals(map.get("fileNm"))){
				//첨부파일 삭제
				fileChk = EgovFileMngUtil.deleteNotiFile(map.get("fileNm"));
			} else {
				fileChk = true;
			}
			
		}
		
		if(fileChk){
			//첨부파일 리스트 삭제
			epmf8149093Mapper.epmf8149093_delete1(data);
			
			//공지사항 삭제
			result += epmf8149093Mapper.epmf8149093_delete2(data);
		}
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return result;
		
	}

}
