package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
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
import egovframework.mapper.mf.ep.EPMF8169997Mapper;

/**
 * FAQ 상세조회 Service
 * @author pc
 *
 */
@Service("epmf8169997Service")
public class EPMF8169997Service {
	
	@Resource(name="epmf8169997Mapper")
	private EPMF8169997Mapper epmf8169997Mapper;
	
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil EgovFileMngUtil;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * FAQ 상세조회 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@Transactional
	public ModelMap epmf8169997(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPMF8169997");	//타이틀
		model.addAttribute("titleSub", title);
		
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("FAQ_SEQ", request.getParameter("FAQ_SEQ"));
		
		//FAQ 상세조회
		List<?> askInfo = epmf8169997Mapper.epmf8169997_select1(map);
		
		//이전글 제목 조회
		List<?> preAsk = epmf8169997Mapper.epmf8169997_select2(map);
		
		//다음글 제목 조회
		List<?> nextAsk = epmf8169997Mapper.epmf8169997_select3(map);
		
		//FAQ 첨부파일 조회
		List<?> fileList = epmf8169997Mapper.epmf8169997_select4(map);
		
		try {
		
			if(null == askInfo) {
				model.addAttribute("askInfo", "{}");
			} else {
				model.addAttribute("askInfo", util.mapToJson(askInfo));
				
				for(int i=0;i<askInfo.size();i++){
					Map<String, String> rtn = (Map<String, String>) askInfo.get(i);
					
					rtn.put("REG_DTTM", rtn.get("REG_DTTM").substring(0, 4)+"-"+rtn.get("REG_DTTM").substring(4, 6)+"-"+rtn.get("REG_DTTM").substring(6));
					//rtn.put("CNTN", XSSFilter.getFilter(rtn.get("CNTN")));
				}
			}
			
			if(null == preAsk) {
				model.addAttribute("preAsk", "{}");
			} else {
				model.addAttribute("preAsk", util.mapToJson(preAsk));
			}
			
			if(null == nextAsk) {
				model.addAttribute("nextAsk", "{}");
			} else {
				model.addAttribute("nextAsk", util.mapToJson(nextAsk));
			}
			
			if(null == fileList) {
				model.addAttribute("fileList", "{}");
			} else {
				model.addAttribute("fileList", util.mapToJson(fileList));
			}
				
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
		
		//페이지이동 조회조건 파라메터 정보
		String reqParams = request.getParameter("INQ_PARAMS");
		if(reqParams==null || reqParams.equals("")) reqParams = "{}";
		JSONObject jParams = JSONObject.fromObject(reqParams);

		model.addAttribute("INQ_PARAMS",jParams);
		
		return model;
	}
	
	/**
	 * FAQ 삭제
	 * @param data
	 * @param request
	 * @return
	 * @
	 */
	@Transactional
	public int epmf8169997_delete(Map<String, String> data, HttpServletRequest request)  {
		
		int result = 0;
		
		boolean fileChk = false;
		
		List<?> fileList = JSONArray.fromObject(data.get("fileList"));
		
		for(int i=0; i<fileList.size(); i++) {
			
			Map<String, String> map = (Map<String, String>) fileList.get(i);
			
			if(!"NONFILE".equals(map.get("fileNm"))){
				//첨부파일 삭제
				try {
					fileChk = EgovFileMngUtil.deleteNotiFile(map.get("fileNm"));
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
			} else {
				fileChk = true;
			}
			
		}
		
		if(fileChk){
			//첨부파일 리스트 삭제
			epmf8169997Mapper.epmf8169997_delete1(data);
			
			//FAQ 삭제
			result += epmf8169997Mapper.epmf8169997_delete2(data);
		}
		
		return result;
		
	}

}
