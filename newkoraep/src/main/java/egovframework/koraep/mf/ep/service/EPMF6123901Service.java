package egovframework.koraep.mf.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF6123901Mapper;

/**
 * 생산자별 출고/회수 현황 Service
 * @author 이내희
 *
 */
@Service("epmf6123901Service")
public class EPMF6123901Service {  
	
	@Resource(name="epmf6123901Mapper")
	private EPMF6123901Mapper epmf6123901Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	  /**
	   * 생산자별 출고/회수 현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epmf6123901_select(Map<String, String> data, HttpServletRequest request) {
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			data.put("BIZRID", vo.getBIZRID());  					
			data.put("BIZRNO", vo.getBIZRNO_ORI());  
			if(!vo.getBRCH_NO().equals("9999999999")){
				data.put("BRCH_ID", vo.getBRCH_ID());  					
				data.put("BRCH_NO", vo.getBRCH_NO());  
			}
			
			try {
				List<?> list = epmf6123901Mapper.epmf6123901_select(data);
				map.put("searchList", util.mapToJson(list));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}

			return map;
  	  }
		
		/**
		 * 생산자별 출고/회수 현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf6123901_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
				
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				data.put("BIZRID", vo.getBIZRID());  					
				data.put("BIZRNO", vo.getBIZRNO_ORI());  
				if(!vo.getBRCH_NO().equals("9999999999")){
					data.put("BRCH_ID", vo.getBRCH_ID());  					
					data.put("BRCH_NO", vo.getBRCH_NO());  
				}
				
				data.put("excelYn", "Y");
				List<?> list = epmf6123901Mapper.epmf6123901_select(data);

				//엑셀파일 저장
				commonceService.excelSave(request, data, list);

			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}
}
