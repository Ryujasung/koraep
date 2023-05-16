package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE6123901Mapper;

/**
 * 생산자별 출고/회수 현황 Service
 * @author 이내희
 *
 */
@Service("epce6123901Service")
public class EPCE6123901Service {  
	
	@Resource(name="epce6123901Mapper")
	private EPCE6123901Mapper epce6123901Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	  /**
	   * 생산자별 출고/회수 현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
  	  public HashMap<String, Object> epce6123901_select(Map<String, String> data) {
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			List<?> list = epce6123901Mapper.epce6123901_select(data);
			try {
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
		public String epce6123901_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
				
				data.put("excelYn", "Y");
				List<?> list = epce6123901Mapper.epce6123901_select(data);

				//엑셀파일 저장
				commonceService.excelSave(request, data, list);

			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}
}
