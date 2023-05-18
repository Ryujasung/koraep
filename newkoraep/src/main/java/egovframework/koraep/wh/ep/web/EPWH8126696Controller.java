package egovframework.koraep.wh.ep.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.koraep.ce.ep.service.CommonCeService;
import egovframework.koraep.ce.ep.service.EPCE8126696Service;
import egovframework.koraep.wh.ep.service.EPWH8126696Service;
import egovframework.mapper.ce.ep.EPCE8149093Mapper;

/**
 * 문의/답변 등록 Controller
 * @author pc
 *
 */
@Controller
public class EPWH8126696Controller {
	
	@Resource(name="epce8149093Mapper")
	private EPCE8149093Mapper epce8149093Mapper;
	
	@Resource(name="epce8126696Service")
	private EPCE8126696Service epce8126696Service;
	
	@Resource(name="epwh8126696Service")
	private EPWH8126696Service epwh8126696Service;
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;
	
	/**
	 * 문의/답변 등록 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8126696.do", produces="application/text; charset=utf8")
	public String epwh8126696(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPWH8126696");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epwh8126696Service.epwh8126696(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);

		if(device.isNormal()){ //웹
			return "/WH/EPWH8126696";
		}else{ //모바일
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";

			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			}
			
			return "/WH_M/EPWH8126696";
		}
	}
	
	/**
	 * 문의/답변 수정 페이지 호출
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8126642.do", produces="application/text; charset=utf8")
	public String epwh8126642(ModelMap model, HttpServletRequest request)  {
		
		String title = commonceService.getMenuTitle("EPWH8126642");	//타이틀
		model.addAttribute("titleSub", title);
		
		//조회 상태유지
		model = epwh8126696Service.epwh8126696(model, request);
		
		/* 모바일체크 */
		Device device = DeviceUtils.getCurrentDevice(request);

		if(device.isNormal()){ //웹
			return "/WH/EPWH8126696";
		}else{ //모바일
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String ssUserInfo = "";

			if(vo != null){
				ssUserInfo = vo.getUSER_NM()+"("+vo.getUSER_ID()+")";
				model.addAttribute("userInfo", ssUserInfo); //사용자
				model.addAttribute("ttObject", util.mapToJson(commonceService.getLangCdList())); //다국어
				model.addAttribute("mmObject", util.mapToJson(commonceService.getMenuCdList(vo))); //메뉴
			}
			
			return "/WH_M/EPWH8126696";
		}
	}
	
	/**
	 * 문의/답변 등록
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	@RequestMapping(value="/WH/EPWH8126696_09.do", produces="application/text; charset=utf8")
	@ResponseBody
	public String epwh8126696_update(@RequestParam HashMap<String, String> data, HttpServletRequest request)  {

		String errCd = "";
		
		try{
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String userId = vo.getUSER_ID();
			//세션id의 권한체크
			Map<String,Object> userInfo = (Map<String, Object>) epce8149093Mapper.getUserInfo(userId);
			//게시글 작성자 조회
			Map<String,Object> ansRegId = epce8126696Service.ansRegId(data);
			if(!data.containsKey("ASK_SEQ") || data.get("ASK_SEQ").equals("")){
				errCd = epwh8126696Service.epwh8126696_update(data, request);
				
			}else{
				if(ansRegId.get("REG_ID").equals(userId)){
					errCd = epwh8126696Service.epwh8126696_update(data, request);
				}else{
					errCd = "B003";
				}
			}
			
		}catch (IOException io) {
			System.out.println(io.toString());
		}catch (SQLException sq) {
			System.out.println(sq.toString());
		}catch (NullPointerException nu){
			System.out.println(nu.toString());
		}catch(Exception e){
			errCd = e.getMessage();
		}
		
		JSONObject rtnObj = new JSONObject();
		rtnObj.put("RSLT_CD", errCd);
		rtnObj.put("RSLT_MSG", commonceService.getErrorMsgNew(request, "A", errCd));
		
		return rtnObj.toString();
	}

}
