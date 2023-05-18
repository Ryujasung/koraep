package egovframework.koraep.ce.ep.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.springframework.stereotype.Service;

import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE8160601Mapper;

/**
 * 설문조사 Service
 * @author pc
 *
 */
@Service("epce8160601Service")
public class EPCE8160601Service {
	
	@Resource(name="epce8160601Mapper")
	private EPCE8160601Mapper mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 설문 마스터 조회
	 * @param param
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce8160601_select1(Map<String, String> param)  {
		HashMap<String, Object> map = new HashMap<String, Object>();
		List<?> list = mapper.epce8160601_select1(param);
		
		try {
			map.put("searchList", util.mapToJson(list));
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		} catch (Exception e) {
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		
		return map;
	}
	
	/**
	 * 설문 참여자 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epce81606012_select1(Map<String, String> param)  {
		List<?> list = mapper.epce81606012_select1(param);
		return list;
	}

	/**
	 * 설문 참여자 조회 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce81606012_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {

			List<?> list = mapper.epce81606012_select1(data);

			HashMap<String, String> map = new HashMap();
						
			map.put("fileName", data.get("fileName").toString());
			map.put("columns", data.get("columns").toString());
			
			//엑셀파일 저장
			commonceService.excelSave(request, map, list);

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
	
	
	/**
	 * 설문 마스터 등록/수정
	 * @param param
	 * @
	 */
	public void epce8160601_update(Map<String, String> param)  {

		List<?> list = JSONArray.fromObject(param.get("SVY_TRGT_CD"));
		StringBuffer sb = new StringBuffer();
		String strSvyTrgtCd = "";
		
		for(int i=0; i<list.size(); i++) {
			strSvyTrgtCd = (String) list.get(i);
			if(i != 0) sb.append("|");
			sb.append(strSvyTrgtCd);
		}
		
		param.put("SVY_TRGT_CD", sb.toString());
		
		mapper.epce8160601_update(param);
	}
}
