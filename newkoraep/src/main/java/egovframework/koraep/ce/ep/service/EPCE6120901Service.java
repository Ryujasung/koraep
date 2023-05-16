package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE6120901Mapper;

/**
 * 출고자료등록현황 Service
 * @author 이내희
 *
 */
@Service("epce6120901Service")
public class EPCE6120901Service {  
	
	@Resource(name="epce6120901Mapper")
	private EPCE6120901Mapper epce6120901Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	   * 상세출고현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
	  public HashMap<String, Object> epce6120901_select(Map<String, String> data) {

			HashMap<String, Object> map = new HashMap<String, Object>();
			
			List<?> list = epce6120901Mapper.epce6120901_select(data);
			try {
				map.put("searchList", util.mapToJson(list));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}
			
			return map;
	  }
	  
	  /**
		 * 상세출고현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce6120901_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
				
				data.put("excelYn", "Y");
				List<?> list = epce6120901Mapper.epce6120901_select(data);

				//엑셀파일 저장
				commonceService.excelSave(request, data, list);

			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}

}
