package egovframework.koraep.mf.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.mapper.mf.ep.EPMF8716201Mapper;

/**
 * 회원가입 서비스
 * @author Administrator
 *
 */
@Service("epmf8716201Service")
public class EPMF8716201Service {

	@Resource(name="epmf8716201Mapper")
	private EPMF8716201Mapper epmf8716201Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epmf8716231_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPMF8716231");
		model.addAttribute("titleSub", title);
		
		List<?> bankList = commonceService.getCommonCdListNew("S090");// 은행
		try {
			model.addAttribute("bankList", util.mapToJson(bankList));
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

		return model;
	}
	
}
