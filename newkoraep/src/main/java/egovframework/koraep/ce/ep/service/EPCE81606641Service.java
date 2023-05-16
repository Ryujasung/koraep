package egovframework.koraep.ce.ep.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.EgovFileMngUtil;
import egovframework.common.util;
import egovframework.mapper.ce.ep.EPCE81606641Mapper;

/**
 * 설문 문항 및 선택 옵션 관리 Service
 * @author kwon
 *
 */
@Service("epce81606641Service")
public class EPCE81606641Service {
	
	@Resource(name="epce81606641Mapper")
	private EPCE81606641Mapper epce81606641Mapper;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil EgovFileMngUtil;
	
	/**
	 * 선택 설문 문항 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public List<?> epce81606641_select1(Map<String, String> map)  {
		List<?> list = epce81606641Mapper.epce81606641_select1(map);
		return list;
	}

	/**
	 * 선택 설문 문항 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public List<?> epce81606641_select_cntn(Map<String, String> map)  {
		List<?> list = epce81606641Mapper.epce81606641_select(map);
		return list;
	}

	/**
	 * 조사문항 저장
	 * @param map
	 * @throws Exception 
	 * @
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public void epce81606641_update1(Map<String, String> param) throws Exception  {
		
		List<?> list = JSONArray.fromObject(param.get("item_list"));
		if(list == null || list.size() == 0) throw new Exception();
		
		for(int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>)list.get(i);
			map.put("UPD_PRSN_ID", param.get("UPD_PRSN_ID"));
			map.put("REG_PRSN_ID", param.get("REG_PRSN_ID"));
			if(map.get("JOB").equals("D")){
				epce81606641Mapper.epce81606641_delete1(map);
			}else{
				epce81606641Mapper.epce81606641_update1(map);
			}
			
		}
	}
	
	/**
	 * 선택문항 옵션조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public List<?> epce81606641_select2(Map<String, String> map)  {
		List<?> list = epce81606641Mapper.epce81606641_select2(map);
		return list;
	}
	
	

	/**
	 * 선택문항의 옵션 저장
	 * @param map
	 * @throws Exception 
	 * @
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public void epce81606641_update2(Map<String, String> param) throws Exception  {
		
		List<?> list = JSONArray.fromObject(param.get("option_list"));
		if(list == null || list.size() == 0) throw new Exception();
		
		for(int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>)list.get(i);
			map.put("UPD_PRSN_ID", param.get("UPD_PRSN_ID"));
			map.put("REG_PRSN_ID", param.get("REG_PRSN_ID"));
			
			if(!map.containsKey("REFN_IMG")) map.put("REFN_IMG", "");
			if(!map.containsKey("REFN_IMG_NM")) map.put("REFN_IMG_NM", "");

			if(map.get("JOB").equals("D")){
				epce81606641Mapper.epce81606641_delete2(map);
			}else{
				epce81606641Mapper.epce81606641_update2(map);
			}
		}
		
	}


	/**
	 * 설명 저장
	 * @param map
	 * @throws Exception 
	 * @
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public void epce81606641_update3(Map<String, String> param) throws Exception  {
		
		epce81606641Mapper.epce81606641_update3(param);
	}
}