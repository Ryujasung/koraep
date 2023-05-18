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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.mapper.ce.ep.EPCE8160653Mapper;
import egovframework.mapper.ce.ep.EPCE81606641Mapper;

/**
 * 설문조사 Service
 * @author pc
 *
 */
@Service("epce8160653Service")
public class EPCE8160653Service {
	
	@Resource(name="epce8160653Mapper")
	private EPCE8160653Mapper mapper;
	
	@Resource(name="epce81606641Mapper")
	private EPCE81606641Mapper epce81606641Mapper;
	

	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	
	/**
	 * 등록설문 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epce8160653_select1(Map<String, String> param)  {
		List<?> list = mapper.epce8160653_select1(param);
		return list;
	}
	
	/**
	 * 20200371 보나뱅크 ERP 설문 
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epce8160653_select_erp(Map<String, String> param)  {
		List<?> list = mapper.epce8160653_select_erp(param);
		return list;
	}
	
	
	/**
	 * 등록설문 문항조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epce8160653_select2(Map<String, String> param)  {
		List<?> list = mapper.epce8160653_select2(param);
		return list;
	}
	
	
	
	/**
	 * 선택설문 참여결과저장
	 * @param param
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public void epce8160653_insert(Map<String, Object> param) throws Exception {
		String svyNo = (String)param.get("SVY_NO");
		String userId = (String)param.get("USER_ID");
		
		JSONArray list = JSONArray.fromObject(param.get("OPT_LIST"));
		if(list == null || list.size() == 0) throw new Exception();
		
		for(int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>)list.get(i);
			map.put("SVY_NO", svyNo);
			map.put("USER_ID", userId);
			
			String optNo = map.get("ANSR_CNTN");
			
			if(map.get("ANSR_SE_CD").equals("C")){
				String[] opts = optNo.split(",");
				for(int x=0; x<opts.length; x++){
					map.put("OPT_NO", opts[x]);
					mapper.epce8160653_insert(map);
				}
			}else if(map.get("ANSR_SE_CD").equals("R")||map.get("ANSR_SE_CD").equals("I")){
				map.put("OPT_NO", optNo);
				mapper.epce8160653_insert(map);
			}else if(map.get("ANSR_SE_CD").equals("X")){

			}
		}
	}

	
	
	/**
	 * 총 참여수
	 * @param param
	 * @return
	 * @
	 */
	public String epce8160653_select3(Map<String, String> param)  {
		String totVoteCnt = (String)mapper.epce8160653_select3(param);
		return totVoteCnt;
	}
	
	/**
	 * 문항/옵션별 참여수
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epce8160653_select4(Map<String, String> param)  {
		List<?> list = mapper.epce8160653_select4(param);
		return list;
	}
	
	/**
	 * 설문설명
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epce8160653_select5(Map<String, String> param)  {
		List<?> list = epce81606641Mapper.epce81606641_select(param);
		return list;
	}
	
	/**
	 * 설문 결과 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce8160653_excel(HashMap<String, String> data, HttpServletRequest request) {
		
		String errCd = "0000";

		try {

			List<?> list = mapper.epce8160653_excel(data);

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
	
	
}
