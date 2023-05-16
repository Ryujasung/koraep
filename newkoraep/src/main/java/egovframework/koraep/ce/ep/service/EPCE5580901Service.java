package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONArray;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.mapper.ce.ep.EPCE5580901Mapper;

/**
 * 마이메뉴 관리서비스
 * @author Administrator
 *
 */
@Service("epce5580901Service")
public class EPCE5580901Service {

	private static final Logger log = LoggerFactory.getLogger(EPCE5580901Service.class);
	
	@Resource(name="epce5580901Mapper")
	private EPCE5580901Mapper epce5580901Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	
	/**
	 * 사용자 권한 메뉴 모두 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epce5580901_select1(Map<String, String> param) {
		List<?> list = epce5580901Mapper.epce5580901_select1(param);
		return list;
	}
	
	
	/**
	 * 사용자 마이 메뉴 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epce5580901_select2(Map<String, String> param) {
		List<?> list = epce5580901Mapper.epce5580901_select2(param);
		return list;
	}
	
	
	
	/**
	 * 사용자 마이메뉴 저장
	 * @param param
	 * @return
	 * @
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public List<?> epce5580901_save(Map<String, Object> param) {
		String id = (String)param.get("USER_ID");
		String regId = (String)param.get("RGST_PRSN_ID");
		
		JSONArray list = JSONArray.fromObject(param.get("list"));
		if(list != null && list.size() > 0){
			for(int i=0; i<list.size(); i++){
				Map<String, String> map = (Map<String, String>)list.get(i);
				map.put("USER_ID", id);
				map.put("RGST_PRSN_ID", regId);
				if(!map.containsKey("INDICT_ORD")) map.put("INDICT_ORD", "");
				
				if(map.get("JOB").equals("D")){
					epce5580901Mapper.epce5580901_delete(map);
				}else{
					epce5580901Mapper.epce5580901_insert(map);
				}
			}
		}
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("USER_ID", (String)param.get("USER_ID"));
		List<?> menuList = epce5580901Mapper.epce5580901_select2(map);
		return menuList;
	}
	
	
	
	/**
	 * 사용자 마이메뉴 추가
	 * @param param
	 * @
	 */
	public void epce5580901_insert(Map<String, String> param) {
		epce5580901Mapper.epce5580901_insert(param);
	}

	/**
	 * 사용자 마이메뉴 삭제
	 * @param param
	 * @
	 */
	public void epce5580901_delete(Map<String, String> param) {
		epce5580901Mapper.epce5580901_delete(param);
	}
}
