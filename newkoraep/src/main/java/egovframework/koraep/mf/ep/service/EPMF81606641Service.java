package egovframework.koraep.mf.ep.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONArray;

import org.springframework.stereotype.Service;

import egovframework.common.EgovFileMngUtil;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF81606641Mapper;

/**
 * 설문 문항 및 선택 옵션 관리 Service
 * @author kwon
 *
 */
@Service("epmf81606641Service")
public class EPMF81606641Service {
	
	@Resource(name="epmf81606641Mapper")
	private EPMF81606641Mapper epmf81606641Mapper;
	
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
	public List<?> epmf81606641_select1(Map<String, String> map)  {
		List<?> list = new ArrayList();
		try {
			list = epmf81606641Mapper.epmf81606641_select1(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return list;
	}
	
	/**
	 * 조사문항 저장
	 * @param map
	 * @throws Exception 
	 * @
	 */
	@SuppressWarnings("unchecked")
	public void epmf81606641_update1(Map<String, String> param) throws Exception  {
		
		List<?> list = JSONArray.fromObject(param.get("item_list"));
		if(list == null || list.size() == 0) throw new Exception();
		
		for(int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>)list.get(i);
			map.put("UPD_PRSN_ID", param.get("UPD_PRSN_ID"));
			map.put("REG_PRSN_ID", param.get("REG_PRSN_ID"));
			if(map.get("JOB").equals("D")){
				epmf81606641Mapper.epmf81606641_delete1(map);
			}else{
				epmf81606641Mapper.epmf81606641_update1(map);
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
	public List<?> epmf81606641_select2(Map<String, String> map)  {
		List<?> list = new ArrayList();
		try {
			list = epmf81606641Mapper.epmf81606641_select2(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return list;
	}
	
	

	/**
	 * 선택문항의 옵션 저장
	 * @param map
	 * @throws Exception 
	 * @
	 */
	@SuppressWarnings("unchecked")
	public void epmf81606641_update2(Map<String, String> param) throws Exception  {
		
		List<?> list = JSONArray.fromObject(param.get("option_list"));
		if(list == null || list.size() == 0) throw new Exception();
		
		for(int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>)list.get(i);
			map.put("UPD_PRSN_ID", param.get("UPD_PRSN_ID"));
			map.put("REG_PRSN_ID", param.get("REG_PRSN_ID"));
			if(map.get("JOB").equals("D")){
				epmf81606641Mapper.epmf81606641_delete2(map);
			}else{
				epmf81606641Mapper.epmf81606641_update2(map);
			}
		}
		
	}
}
