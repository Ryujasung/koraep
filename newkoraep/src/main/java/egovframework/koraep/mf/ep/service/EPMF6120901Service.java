package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF6120901Mapper;

/**
 * 출고자료등록현황 Service
 * @author 이내희
 *
 */
@Service("epmf6120901Service")
public class EPMF6120901Service {  
	
	@Resource(name="epmf6120901Mapper")
	private EPMF6120901Mapper epmf6120901Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	/**
	   * 상세출고현황 리스트 조회
	   * @param model
	   * @param request
	   * @return
	   * @
	   */
	  public HashMap<String, Object> epmf6120901_select(Map<String, String> data) {

			HashMap<String, Object> map = new HashMap<String, Object>();
			
			
			try {
				List<?> list = epmf6120901Mapper.epmf6120901_select(data);
				map.put("searchList", util.mapToJson(list));
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
	  
	  /**
		 * 상세출고현황 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epmf6120901_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
				
				data.put("excelYn", "Y");
				List<?> list = epmf6120901Mapper.epmf6120901_select(data);

				//엑셀파일 저장
				commonceService.excelSave(request, data, list);

			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}
			
			return errCd;
		}

}
