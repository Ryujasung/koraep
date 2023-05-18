package egovframework.koraep.mf.ep.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.mapper.mf.ep.EPMF8160601Mapper;

/**
 * 설문조사 Service
 * @author pc
 *
 */
@Service("epmf8160601Service")
public class EPMF8160601Service {
	
	@Resource(name="epmf8160601Mapper")
	private EPMF8160601Mapper mapper;
	
	
	/**
	 * 설문 마스터 조회
	 * @param param
	 * @return
	 * @
	 */
	public List<?> epmf8160601_select1(Map<String, String> param)  {
		List<?> list = new ArrayList();
		try {
			list = mapper.epmf8160601_select1(param);
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
		return list;
	}

	
	/**
	 * 설문 마스터 등록/수정
	 * @param param
	 * @
	 */
	public void epmf8160601_update(Map<String, String> param)  {
		try {
			mapper.epmf8160601_update(param);
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
	}
}
