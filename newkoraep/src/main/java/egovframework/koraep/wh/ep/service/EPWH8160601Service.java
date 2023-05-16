package egovframework.koraep.wh.ep.service;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.mapper.wh.ep.EPWH8160601Mapper;

/**
 * 설문조사 Service
 * @author pc
 *
 */
@Service("epwh8160601Service")
public class EPWH8160601Service {
	
	@Resource(name="epwh8160601Mapper")
	private EPWH8160601Mapper mapper;
	
	
	/**
	 * 설문 마스터 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epwh8160601_select1(Map<String, String> param)  {
		List<?> list = new ArrayList();
		try {
			list = mapper.epwh8160601_select1(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
		return list;
	}

	
	/**
	 * 설문 마스터 등록/수정
	 * @param param
	 * @
	 */
	public void epwh8160601_update(Map<String, String> param)  {
		try {
			mapper.epwh8160601_update(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}
	}
}
