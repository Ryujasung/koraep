package egovframework.koraep.rt.ep.service;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONArray;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.mapper.rt.ep.EPRT8160653Mapper;

/**
 * 설문조사 Service
 * @author pc
 *
 */
@Service("eprt8160653Service")
public class EPRT8160653Service {
	
	@Resource(name="eprt8160653Mapper")
	private EPRT8160653Mapper mapper;
	
	
	/**
	 * 등록설문 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> eprt8160653_select1(Map<String, String> param)  {
		List<?> list = mapper.eprt8160653_select1(param);
		return list;
	}
	
	
	/**
	 * 등록설문 문항조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> eprt8160653_select2(Map<String, String> param)  {
		List<?> list = mapper.eprt8160653_select2(param);
		return list;
	}
	
	
	
	/**
	 * 선택설문 참여결과저장
	 * @param param
	 * @throws Exception 
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public void eprt8160653_insert(Map<String, Object> param) throws Exception {
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
					mapper.eprt8160653_insert(map);
				}
			}else if(map.get("ANSR_SE_CD").equals("R")||map.get("ANSR_SE_CD").equals("I")){
				map.put("OPT_NO", optNo);
				mapper.eprt8160653_insert(map);
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
	public String eprt8160653_select3(Map<String, String> param)  {
		String totVoteCnt = (String)mapper.eprt8160653_select3(param);
		return totVoteCnt;
	}
	
	/**
	 * 문항/옵션별 참여수
	 * @param param
	 * @return
	 * @
	 */
	public List<?> eprt8160653_select4(Map<String, String> param)  {
		List<?> list = mapper.eprt8160653_select4(param);
		return list;
	}
	
	/**
	 * 설문설명
	 * @param param
	 * @return
	 * @
	 */
	public List<?> eprt8160653_select5(Map<String, String> param)  {
		List<?> list = mapper.eprt8160653_select22(param);
		return list;
	}
}
