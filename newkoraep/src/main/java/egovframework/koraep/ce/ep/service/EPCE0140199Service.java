/**
 *
 */
package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0140199Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 회원관리 서비스
 * @author Administrator
 *
 */
@Service("epce0140199Service")
public class EPCE0140199Service {

	@Resource(name="epce0140199Mapper")
	private EPCE0140199Mapper epce0140199Mapper;

	@Resource(name="commonceService")
	private CommonCeService commonceService;

	/**
	 * 페이지 초기화
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0140199_select(ModelMap model, HttpServletRequest request) {

		List<?> bizrTpList = commonceService.getCommonCdListNew("B001");// 사업자유형
		List<?> areaList = commonceService.getCommonCdListNew("B010");// 지역구분
		List<?> userSeList = commonceService.getCommonCdListNew("B006");// 사용자구분
		List<?> pwdAltReqList = commonceService.getCommonCdListNew("S013");// 비밀번호변경요청
		List<?> userStatList = commonceService.getCommonCdListNew("B007");// 사용자상태
		List<?> mailStatList = commonceService.getCommonCdListNew("B901");// 메일발송상태

		try {
			model.addAttribute("bizrTpList", util.mapToJson(bizrTpList));
			model.addAttribute("areaList", util.mapToJson(areaList));
			model.addAttribute("userSeList", util.mapToJson(userSeList));
			model.addAttribute("pwdAltReqList", util.mapToJson(pwdAltReqList));
			model.addAttribute("userStatList", util.mapToJson(userStatList));
			model.addAttribute("mailStatList", util.mapToJson(mailStatList));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		return model;
	}

	/**
	 * 회원관리 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0140199_select2(Map<String, String> data, HttpServletRequest request) {

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("userSession");

		if(vo != null){
			if(vo.getATH_SE_CD().equals("B")){ //센터지사
				data.put("T_USER_ID", vo.getUSER_ID());
			}
		}

		List<?> menuList = epce0140199Mapper.epce0140199_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();

		try {
			map.put("searchList", util.mapToJson(menuList));
			map.put("totalCnt", epce0140199Mapper.epce0140199_select_cnt(data));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 회원관리 엑셀
	 * @param map
	 * @param request
	 * @return
	 * @
	 */
	public String epce0140199_excel(HashMap<String, String> data, HttpServletRequest request) {

		String errCd = "0000";

		try {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			if(vo != null){
				if(vo.getATH_SE_CD().equals("B")){ //센터지사
					data.put("T_USER_ID", vo.getUSER_ID());
				}
			}

			data.put("excelYn", "Y");
			List<?> list = epce0140199Mapper.epce0140199_select(data);

			//엑셀파일 저장
			commonceService.excelSave(request, data, list);

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			return "A001"; //DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;
	}

	
	
	/**
	 * 휴면계정리스트 추가
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140199_merge(Map<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {



    		epce0140199Mapper.epce0140199_merge(data);


		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}
	

/**
 * 메일전송
 * @param map
 * @param request
 * @return
 * @throws Exception
 * @
 */
public String epce0140199_mail(HashMap<String, String> data, HttpServletRequest request) throws Exception {

	Calendar cal = Calendar.getInstance();
    cal.setTime(new Date());
    DateFormat df = new SimpleDateFormat("yyyy.MM.dd");
    System.out.println("current: " + df.format(cal.getTime()));
    String date1 = df.format(cal.getTime());
    cal.add(Calendar.DATE, 30);
    String date2 = df.format(cal.getTime());
    System.out.println("after: " + df.format(cal.getTime()));
	
	String email_title ="[자원순환보증금관리센터] 지급관리시스템 휴면계정 처리 안내";
	String email_contents = "";
	
	
	String errCd = "0000";
	String sUserId = "";
	String lastDate = "";

	try {
			HttpSession session = request.getSession();
			UserVO vo = (UserVO)session.getAttribute("userSession");
			sUserId = vo.getUSER_ID();

			List<?> list = JSONArray.fromObject(data.get("list"));

			if(list != null && list.size() > 0){

				for(int i=0; i<list.size(); i++){
					
					Map<String, String> map = (Map<String, String>)list.get(i);
					lastDate = map.get("LST_LGN_DTTM").substring(0, 10).replace("-", ".");
//					email_contents = "한국순환자원유통지원센터에서 지급관리시스템 휴면계정 처리 관련하여 안내드립니다.\n\n지급관리시스템을 1년 이상 로그인하지 않을 경우 정보통신망 이용 촉진 및 정보 보호등에 관한 \n\n법률(제29조/시행령 제16조)에 근거하여 휴면계정 전환 후 개인정보를 별도 분리보관합니다. \n\n분리보관된 개인정보는 개인정보처리방침의 보유기간 동안 임시보관 후 파기 처리됩니다.\n\n서비스 이용을 원하시면 휴면전환 전 지급관리시스템에 로그인하여 주십시오.\n\n[지급관리시스템 로그인하기] : https://reuse.kora.or.kr/\n\n□ 최근 로그인 일시 : "+lastDate+" (메일발송일자 : "+date1+")\n□ 휴면처리 예정일 : "+date2+"\n□ 분리보관 항목 : 회원가입 시 수집된 개인정보\n\n해당 조치 이후 로그인 및 정상적인 서비스가 불가하며, 지급관리시스템 회원가입절차를 진행한 후 정상적인 이용이 가능합니다. \n\n\n\n※본 메일은 관계법령에 따른 의무사항이므로 수신동의와 관계없이 지급관리시스템 이용자에게 발송되는 메일입니다. \n기타 문의사항은 운영지원팀(02-768-1681~3)으로 문의하여 주시기 바랍니다. \n/ 상호명 : 한국순환자원유통지원센터 / 대표 : 정회석 / 개인정보책임자 : 양재영 / 사업자등록번호 : 107-82-17851 \n/ 서울특별시 서초구 명달로 9(방배빌딩 7층)";
					//EMAIL START 20200514 휴면계정메일발송
//					email_contents = "<html><body><h1><a href="+"http://www.naver.co.kr"+">aaaa</a></h1></body></html>";
//					email_contents = "<a href="+"https://reuse.kora.or.kr/login.do"+"> <img src=\"http://175.115.52.202/images/mail.png\"></a>";
					email_contents =
							"<body >"
						+"<div style=\"font-size:14px;letter-spacing:-1px;width:720px; margin:0 auto;border:1px solid #bfbfbf;\">"
					 +"<div style=\"padding:20px 40px;\" class=\"wrap \">"
					 +"<div class=\"logo\"><img src=\"https://reuse.cosmo.or.kr/images/top_logo.jpg\" width=\"180px\"></div>"
					 +"<div class=\"title\" style=\"background:linear-gradient(90deg, rgba(48,120,111,1) 0%, rgba(59,129,92,1) 100%); padding:20px 0;margin:10px 0; text-align:center; font-weight:bold; line-height:35px;color:#fff;font-size:20px;\">"
					 +"<span style=\"color:#E2F0D9\">|  빈용기보증금 및 취급수수료 지급관리시스템  |"
					 +"</span><br>	1년 이상 미로그인 회원 개인정보 파기 관련 안내 </div>"
					 +"<p style=\"line-height:2; padding:15px 0;\">자원순환보증금관리센터에서 지급관리시스템 휴면계정 처리 관련하여 안내드립니다.<br><span style=\"color:#f00;\">지급관리시스템을 1년 이상 로그인하지 않을 경우</span> 개인정보보호법(제39조의6/시행령 제 48조의5)에 근거하여 휴면계정 전환 후 개인정보를 별도 분리보관합니다. <br>"
					 +"분리보관된 개인정보는 개인정보처리방침의 보유기간 동안 <span style=\"color:#f00;\">임시보관 후 파기 처리됩니다.</span><br>"
					 +"서비스 이용을 원하시면 휴면전환 전 지급관리시스템에 로그인하여 주십시오.<br>	</p>"
					 +"<table style=\"width:100%; border-collapse: collapse;border-top:2px solid #000;border-bottom:2px solid #000;line-height:2.5;font-size:14px;\">"
					 +"<tr><th style=\"width:30%; background-color:#D9D9D9;text-align:left;padding-left:8px;\">최근 로그인 일시</th><td style=\"width:70%;padding-left:8px;color:#f00;\">"+lastDate+"(메일발송일자 :  "+date1+")	</td></tr>"
					 +"<tr><th style=\"width:30%;background-color:#D9D9D9;text-align:left;padding-left:8px;\">휴면처리 예정일"
					 +"</th><td style=\"width:70%;padding-left:8px;color:#f00;\"> "+date2+"</td></tr>"
					 +"<tr><th style=\"width:30%;background-color:#D9D9D9;text-align:left;padding-left:8px;\">분리보관 항목	</th><td style=\"width:70%; padding-left:8px;\">회원가입 시 수집된 개인정보(이름, 이메일, 휴대전화번호 등)</td></tr>"
					 +"</table>"
					 +"<p style=\"padding:10px 0;\">해당 조치 이후 로그인 및 정상적인 서비스가 불가하며, 지급관리시스템 회원가입절차를 진행한 후 정상적인 이용이 가능합니다.	</p>"
					 +"<div style=\"display:block; width:330px; margin:20px auto 10px; height:42px;line-height:42px;box-shadow: 0px 3px 0px #D8D8D8; border-radius:21px; \"><a href=\"https://reuse.cosmo.or.kr/login.do\"style=\"display:block; width:330px; margin:20px auto 10px; height:42px;line-height:42px;box-shadow: 0px 3px 0px #D8D8D8; border-radius:21px; text-align:center; font-weight:bold;color:#fff;background-color:#404040;font-size:16px;text-decoration:none;\">지급관리시스템 로그인하기</a></div>"
					 +"</div>"
					 +"<div class=\"footer\" style=\"background-color:#BFBFBF; overflow:hidden; padding:10px;letter-spacing:0px;\"><p style=\"width:78%; float:left;font-size:10px;line-height:1.8;\">※본 메일은 관계법령에 따른 의무사항이므로 수신동의와 관계없이 지급관리시스템 이용자에게 발송되는 메일입니다. <br>"
					 +"기타 문의사항은 빈용기보증금운영팀(02-2071-7156~7)으로 문의하여 주시기 바랍니다.<br>	상호명 : 자원순환보증금관리센터 / 대표 : 정복영 / 개인정보책임자 : 허규회<br>사업자등록번호 : 162-82-00401 / 서울특별시 종로구 인사동7길 12,(백상빌딩 10층)	</p></div>"
					 +"</div>"
					 +"</body>";
					

					try {
						SimpleEmail email = new SimpleEmail();
						//setHostName에 실제 메일서버정보
						email.setCharset("euc-kr"); // 한글 인코딩  
						email.setHostName("mail.cosmo.or.kr"); //SMTP서버 설정
						//email.setAuthentication("kora_test", "dbxhdcenter1!"); //테스트용
						email.setAuthentication("systemmaster", "cosmo4050100130"); //운영용
						email.addTo(map.get("EMAIL"), map.get("USER_NM")); // 수신자 추가
						email.setFrom("webmaster@cosmo.or.kr", "COSMO"); // 보내는 사람
						email.setSubject(email_title); // 메일 제목
						email.setContent(email_contents, "text/html");
						email.setSmtpPort(25);
						email.send();
					
					//EMAIL END
					
		    		map.put("S_USER_ID", sUserId);
		    		map.put("SEND_MAIL_YN", data.get("gGubn").equals("A")?"Y":"N");
		    		map.put("MAIL_TITLE", email_title);
		    		//map.put("MAIL_CONTENTS", email_contents.replace("\n", "."));
		    		map.put("MAIL_CONTENTS", email_contents);

		    		epce0140199Mapper.epce0140199_mail(map);
					} catch (EmailException e) {
						e.printStackTrace();
					}

		    	}

			}else{
				errCd = "A007"; //저장할 데이타가 없습니다.
			}

	}catch (IOException io) {
		io.getMessage();
	}catch (SQLException sq) {
		sq.getMessage();
	}catch (NullPointerException nu){
		nu.getMessage();
	}catch(Exception e){
		throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
	}

	return errCd;

}

/**
 * 메일전송2
 * @param map
 * @param request
 * @return
 * @throws Exception
 * @
 */
public String epce0140199_mail2(Map<String, String> data) throws Exception {

	Calendar cal = Calendar.getInstance();
    cal.setTime(new Date());
    DateFormat df = new SimpleDateFormat("yyyy.MM.dd");
    System.out.println("current: " + df.format(cal.getTime()));
    String date1 = df.format(cal.getTime());
    cal.add(Calendar.DATE, 30);
    String date2 = df.format(cal.getTime());
    System.out.println("after: " + df.format(cal.getTime()));
	
	String email_title ="[자원순환보증금관리센터] 지급관리시스템 휴면계정 처리 안내";
	String email_contents = "";
	
	
	String errCd = "0000";
//	String sUserId = "";
	String lastDate = "";

	try {
//			HttpSession session = request.getSession();
//			UserVO vo = (UserVO)session.getAttribute("userSession");
//			sUserId = vo.getUSER_ID();

			//List<?> list = (List<?>) data.get("list");
			Map<String, String> map = data;
//			if(list != null && list.size() > 0){
//
//				for(int i=0; i<list.size(); i++){
					//Map<String, String> map = (Map<String, String>)list.get(i);
					lastDate = map.get("LST_LGN_DTTM").substring(0, 10).replace("-", ".");
//					email_contents = "한국순환자원유통지원센터에서 지급관리시스템 휴면계정 처리 관련하여 안내드립니다.\n\n지급관리시스템을 1년 이상 로그인하지 않을 경우 정보통신망 이용 촉진 및 정보 보호등에 관한 \n\n법률(제29조/시행령 제16조)에 근거하여 휴면계정 전환 후 개인정보를 별도 분리보관합니다. \n\n분리보관된 개인정보는 개인정보처리방침의 보유기간 동안 임시보관 후 파기 처리됩니다.\n\n서비스 이용을 원하시면 휴면전환 전 지급관리시스템에 로그인하여 주십시오.\n\n[지급관리시스템 로그인하기] : https://reuse.kora.or.kr/\n\n□ 최근 로그인 일시 : "+lastDate+" (메일발송일자 : "+date1+")\n□ 휴면처리 예정일 : "+date2+"\n□ 분리보관 항목 : 회원가입 시 수집된 개인정보\n\n해당 조치 이후 로그인 및 정상적인 서비스가 불가하며, 지급관리시스템 회원가입절차를 진행한 후 정상적인 이용이 가능합니다. \n\n\n\n※본 메일은 관계법령에 따른 의무사항이므로 수신동의와 관계없이 지급관리시스템 이용자에게 발송되는 메일입니다. \n기타 문의사항은 운영지원팀(02-768-1681~3)으로 문의하여 주시기 바랍니다. \n/ 상호명 : 한국순환자원유통지원센터 / 대표 : 정회석 / 개인정보책임자 : 양재영 / 사업자등록번호 : 107-82-17851 \n/ 서울특별시 서초구 명달로 9(방배빌딩 7층)";
					//EMAIL START 20200514 휴면계정메일발송
//					email_contents = "<html><body><h1><a href="+"http://www.naver.co.kr"+">aaaa</a></h1></body></html>";
//					email_contents = "<a href="+"https://reuse.kora.or.kr/login.do"+"> <img src=\"http://175.115.52.202/images/mail.png\"></a>";
					email_contents =
							"<body >"
						+"<div style=\"font-size:14px;letter-spacing:-1px;width:720px; margin:0 auto;border:1px solid #bfbfbf;\">"
					 +"<div style=\"padding:20px 40px;\" class=\"wrap \">"
					 +"<div class=\"logo\"><img src=\"https://reuse.cosmo.or.kr/images/top_logo.jpg\" width=\"180px\"></div>"
					 +"<div class=\"title\" style=\"background:linear-gradient(90deg, rgba(48,120,111,1) 0%, rgba(59,129,92,1) 100%); padding:20px 0;margin:10px 0; text-align:center; font-weight:bold; line-height:35px;color:#fff;font-size:20px;\">"
					 +"<span style=\"color:#E2F0D9\">|  빈용기보증금 및 취급수수료 지급관리시스템  |"
					 +"</span><br>	1년 이상 미로그인 회원 개인정보 파기 관련 안내 </div>"
					 +"<p style=\"line-height:2; padding:15px 0;\">자원순환보증금관리센터에서 지급관리시스템 휴면계정 처리 관련하여 안내드립니다.<br><span style=\"color:#f00;\">지급관리시스템을 1년 이상 로그인하지 않을 경우</span> 정보통신망 이용 촉진 및 정보 보호등에 관한 법률(제29조/시행령 제16조)에 근거하여 휴면계정 전환 후 개인정보를 별도 분리보관합니다. <br>"
					 +"분리보관된 개인정보는 개인정보처리방침의 보유기간 동안 <span style=\"color:#f00;\">임시보관 후 파기 처리됩니다.</span><br>"
					 +"서비스 이용을 원하시면 휴면전환 전 지급관리시스템에 로그인하여 주십시오.<br>	</p>"
					 +"<table style=\"width:100%; border-collapse: collapse;border-top:2px solid #000;border-bottom:2px solid #000;line-height:2.5;font-size:14px;\">"
					 +"<tr><th style=\"width:30%; background-color:#D9D9D9;text-align:left;padding-left:8px;\">최근 로그인 일시</th><td style=\"width:70%;padding-left:8px;color:#f00;\">"+lastDate+"(메일발송일자 :  "+date1+")	</td></tr>"
					 +"<tr><th style=\"width:30%;background-color:#D9D9D9;text-align:left;padding-left:8px;\">휴면처리 예정일"
					 +"</th><td style=\"width:70%;padding-left:8px;color:#f00;\"> "+date2+"</td></tr>"
					 +"<tr><th style=\"width:30%;background-color:#D9D9D9;text-align:left;padding-left:8px;\">분리보관 항목	</th><td style=\"width:70%; padding-left:8px;\">회원가입 시 수집된 개인정보(이름, 이메일, 휴대전화번호 등)</td></tr>"
					 +"</table>"
					 +"<p style=\"padding:10px 0;\">해당 조치 이후 로그인 및 정상적인 서비스가 불가하며, 지급관리시스템 회원가입절차를 진행한 후 정상적인 이용이 가능합니다.	</p>"
					 +"<div style=\"display:block; width:330px; margin:20px auto 10px; height:42px;line-height:42px;box-shadow: 0px 3px 0px #D8D8D8; border-radius:21px; \"><a href=\"https://reuse.cosmo.or.kr/login.do\"style=\"display:block; width:330px; margin:20px auto 10px; height:42px;line-height:42px;box-shadow: 0px 3px 0px #D8D8D8; border-radius:21px; text-align:center; font-weight:bold;color:#fff;background-color:#404040;font-size:16px;text-decoration:none;\">지급관리시스템 로그인하기</a></div>"
					 +"</div>"
					 +"<div class=\"footer\" style=\"background-color:#BFBFBF; overflow:hidden; padding:10px;letter-spacing:0px;\"><p style=\"width:78%; float:left;font-size:10px;line-height:1.8;\">※본 메일은 관계법령에 따른 의무사항이므로 수신동의와 관계없이 지급관리시스템 이용자에게 발송되는 메일입니다. <br>"
					 +"기타 문의사항은 운영관리팀(02-2071-7156)으로 문의하여 주시기 바랍니다.<br>	상호명 : 자원순환보증금관리센터 / 대표 : 이재형 / 개인정보책임자 : 여수호<br>사업자등록번호 : 162-82-00401 / 서울특별시 종로구 인사동7길 12,(백상빌딩 10층)	</p></div>"
					 +"</div>"
					 +"</body>";
					System.out.println(map.get("USER_NM")+"님메일발송");
					try {
						SimpleEmail email = new SimpleEmail();
						//setHostName에 실제 메일서버정보
						email.setCharset("euc-kr"); // 한글 인코딩  
						email.setHostName("mail.cosmo.or.kr"); //SMTP서버 설정
						//email.setAuthentication("kora_test", "dbxhdcenter1!"); //테스트용
						email.setAuthentication("systemmaster", "cosmo4050100130"); //운영용
						email.addTo(map.get("EMAIL"), map.get("USER_NM")); // 수신자 추가
						email.setFrom("webmaster@cosmo.or.kr", "COSMO"); // 보내는 사람
						email.setSubject(email_title); // 메일 제목
						email.setContent(email_contents, "text/html");
						email.setSmtpPort(25);
						email.send();
					//EMAIL END
		    		//map.put("S_USER_ID", "admin");
		    		//map.put("SEND_MAIL_YN", data.get("gGubn").equals("A")?"Y":"N");
		    		map.put("MAIL_TITLE", email_title);
		    		//map.put("MAIL_CONTENTS", email_contents.replace("\n", "."));
		    		map.put("MAIL_CONTENTS", email_contents);
		    		epce0140199Mapper.epce0140199_mail(map);
					} catch (EmailException e) {
						e.printStackTrace();
					}

//		    	}

//			}else{
//				errCd = "A007"; //저장할 데이타가 없습니다.
//			}

	}catch (IOException io) {
		io.getMessage();
	}catch (SQLException sq) {
		sq.getMessage();
	}catch (NullPointerException nu){
		nu.getMessage();
	}catch(Exception e){
		throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
	}

	return errCd;

}
	
	/**
	 * 회원복원
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140199_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		String sUserId = "";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();

				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);

			    		map.put("S_USER_ID", sUserId);
			    		map.put("USER_STAT_CD", data.get("gGubn").equals("A")?"Y":"N");

			    		epce0140199Mapper.epce0140199_update(map);

			    		//사용자변경이력등록
			    		epce0140199Mapper.epce0140199_insert(map);
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

	/**
	 * 관리자변경
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140199_update2(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {

				//세션정보 가져오기
				HttpSession session = request.getSession();
				UserVO uvo = (UserVO)session.getAttribute("userSession");
				String ssUserId   = uvo.getUSER_ID();		//세션사용자ID
				String ssBizrno   = uvo.getBIZRNO_ORI();		//세션사업자번호
				String ssUserSeCd = uvo.getUSER_SE_CD();	//세션사용자구분(D:관리자, S:업무담당자)
				String ssGrpCd    = uvo.getGRP_CD();		//세션권한그룹코드

				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);

			    		map.put("S_USER_ID", ssUserId);

			    		/*
						if(!ssBizrno.equals(data.get("BIZRNO"))){
							//rtnMsg = "사업장 권한이 없습니다.";
							return "B001";
						}else
						*/
						if(map.get("USER_SE_CD").equals("D")){
							//rtnMsg = "관리자는 선택하실 수 없습니다.";
							return "B002";
						}
						/*
						else if(ssUserId.equals(data.get("USER_ID"))){
							//rtnMsg = "관리자는 선택하실 수 없습니다.";
							return "B002";
						}

						else if(!ssUserSeCd.equals("S")){
							//rtnMsg = "처리권한이 없습니다.";
							return "B003";
						}
						*/


			    		//사용자구분코드 변경, 권한변경, 이력등록

			    		//업무담당자 => 관리자 변경
			    		map.put("USER_SE_CD", "D"); //사용자구분코드 관리자로 변경

			    		epce0140199Mapper.epce0140199_update2(map); //사용자구분코드 관리자로 변경 //기존 관리자 => 업무담당자 변경

			    		//사업자정보 관리자변경
			    		epce0140199Mapper.epce0140199_update3(map);

			    		//사용자정보 변경이력등록
			    		epce0140199Mapper.epce0140199_insert(map);

			    		//사업자정보 변경이력등록
			    		epce0140199Mapper.epce0140199_insert2(map);
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

	/**
	 * 비밀번호변경승인
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140199_update3(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		String sUserId = "";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();

				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);

			    		map.put("S_USER_ID", sUserId);

			    		epce0140199Mapper.epce0140199_update4(map);

			    		//사용자변경이력등록
			    		epce0140199Mapper.epce0140199_insert(map);
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}
	
	/**
	 * 비밀번호오류초기화
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140199_update4(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";
		String sUserId = "";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				sUserId = vo.getUSER_ID();

				List<?> list = JSONArray.fromObject(data.get("list"));

				if(list != null && list.size() > 0){

					for(int i=0; i<list.size(); i++){
						Map<String, String> map = (Map<String, String>)list.get(i);

			    		map.put("S_USER_ID", sUserId);

			    		epce0140199Mapper.epce0140199_update5(map);

			    		//사용자변경이력등록
			    		epce0140199Mapper.epce0140199_insert(map);
			    	}

				}else{
					errCd = "A007"; //저장할 데이타가 없습니다.
				}

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

	/**
	 * 권한설정 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0140188_select(ModelMap model) {

		String title = commonceService.getMenuTitle("EPCE0140188");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 권한그룹 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0140188_select2(Map<String, String> data) {

		List<?> menuList = epce0140199Mapper.epce0140188_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 메뉴 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0140188_select3(Map<String, String> data) {

		List<?> menuList = epce0140199Mapper.epce0140188_select2(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 권한그룹 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140188_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}

				epce0140199Mapper.epce0140188_update(data);

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

	/**
	 * 사용자변경이력 팝업
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce01401882_select(ModelMap model) {

		String title = commonceService.getMenuTitle("EPCE01401882");
		model.addAttribute("titleSub", title);

		return model;
	}

	/**
	 * 사용자변경이력 조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce01401882_select2(Map<String, String> data) {

		List<?> menuList = epce0140199Mapper.epce01401882_select(data);

		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("searchList", util.mapToJson(menuList));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		return map;
	}

	/**
	 * 회원 상세조회
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0140164_select(ModelMap model, HttpServletRequest request, HashMap<String, String> map) {

		model.addAttribute("searchDtl", util.mapToJson(epce0140199Mapper.epce0140164_select(map)));

		return model;
	}

	/**
	 * 회원상세조회2
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public HashMap<String, Object> epce0140164_select2(Map<String, String> data) {

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("searchDtl", util.mapToJson(epce0140199Mapper.epce0140164_select(data)));

		return map;
	}

	/**
	 * 회원 정보 변경
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
	public ModelMap epce0140142_select(ModelMap model, HttpServletRequest request) {

		String title = commonceService.getMenuTitle("EPCE0140142");
		model.addAttribute("titleSub", title);

		//파라메터 정보
		String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
		JSONObject jParams = JSONObject.fromObject(reqParams);
		model.addAttribute("INQ_PARAMS",jParams);

		HashMap<String, String> map = util.jsonToMap(jParams.getJSONObject("PARAMS"));

		/* 마이페이지 본인조회용 */
		if(map == null ){
			map = new HashMap<String, String>();

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if(vo != null){
				map.put("USER_ID", vo.getUSER_ID());
			}
		}

		HashMap<String, String> smap = (HashMap<String, String>)epce0140199Mapper.epce0140164_select(map);
		HashMap<String, String> bdMap = new HashMap<String, String>();
		bdMap.put("BIZRID", smap.get("BIZRID"));
		bdMap.put("BIZRNO", smap.get("BIZRNO"));

		try {
			if(smap.get("BIZR_TP_CD").equals("T1")){//사업자유형 센터
				model.addAttribute("brchList", util.mapToJson(commonceService.getCommonCdListNew("B009"))); //센터지부
			}else{
				model.addAttribute("brchList", util.mapToJson(commonceService.brch_nm_select_all(bdMap))); //모두조회..
			}
			model.addAttribute("deptList", util.mapToJson(commonceService.dept_nm_select(bdMap)));
		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
		}

		model.addAttribute("searchDtl", util.mapToJson(smap));

		return model;
	}

	/**
	 * 회원 정보 변경 저장
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140142_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}

				if(data.containsKey("BRCH_CD")){
					if(data.get("BIZR_TP_CD").equals("T1")){
						data.put("CET_BRCH_CD", data.get("BRCH_CD"));
						//data.put("BRCH_ID", "");
						//data.put("BRCH_NO", "");
					}else{
						String[] brchIdNo = data.get("BRCH_CD").split(";");
						data.put("BRCH_ID", brchIdNo[0]);
						data.put("BRCH_NO", brchIdNo[1]);
						data.put("CET_BRCH_CD", "");
					}
				}else{
					data.put("GBN", "M"); //마이페이지에서 수정

					String pwd = epce0140199Mapper.epce0140142_select(data); //USER_ID

					//기존비밀번호 체크, 센터메뉴에선 체크 안함
					String sBfPwd = data.get("PRE_PWD");
					sBfPwd = util.encrypt(sBfPwd);
					
					String sAfPwd = data.get("ALT_PWD");
					sAfPwd = util.encrypt(sAfPwd);

					if(!sBfPwd.equals(pwd)){
						throw new Exception("B017"); //"비밀번호가 맞지 않습니다.\n다시한번 확인 하시기 바랍니다.";
					}
					
					if(sAfPwd.equals(pwd)){
						throw new Exception("A028"); //"이전과 동일한 비밀번호를 사용할 수 없습니다.";
					}

				}

				//비번 암호화
				if(!data.get("ALT_PWD").equals("")){
					String sAfPwd = data.get("ALT_PWD");
					data.put("ALT_PWD", util.encrypt(sAfPwd));
				}

				if(!data.containsKey("DEPT_CD")){
					data.put("DEPT_CD", "");
				}

				epce0140199Mapper.epce0140142_update(data);

				//사용자변경이력등록
	    		epce0140199Mapper.epce0140199_insert(data);

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			if(e.getMessage().equals("B017") ){
				 throw new Exception(e.getMessage());
			 }else if(e.getMessage().equals("A028") ){
				 throw new Exception(e.getMessage());
			 }else{
				 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			 }
		}

		return errCd;

	}

	/**
	 * 회원 정보 삭제
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140142_delete(HashMap<String, String> data, HttpServletRequest request) throws Exception {

		String errCd = "0000";

		try {
				//권한 삭제
				epce0140199Mapper.epce0140142_delete(data);

				//사용자정보 삭제
				epce0140199Mapper.epce0140142_delete2(data);

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("B020"); // 해당 사용자정보 사용데이터가 존재합니다.
		}

		return errCd;

	}

	/**
	 * 회원가입승인
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140164_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		String errCd = "0000";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				data.put("S_USER_ID", "");
				if(vo != null){
					data.put("S_USER_ID", vo.getUSER_ID());
				}

				if(!data.get("USER_STAT_CD").equals("W")){
					//"승인대상이 아닙니다.";
					return "B005";
				}

				epce0140199Mapper.epce0140164_update(data);

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

	/**
	 * 회원탈퇴
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 * @
	 */
	public String epce0140164_update2(HashMap<String, String> data, HttpServletRequest request) throws Exception {
		String errCd = "0000";

		try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");

				String ssUserId = "";

				if(vo != null){
					ssUserId = vo.getUSER_ID();
				}

				data.put("S_USER_ID", ssUserId);
				String id = (data.get("USER_ID") == null) ? "" : data.get("USER_ID");
				String voId = (ssUserId == null) ? "" : ssUserId;

				if(!id.equals(voId)){
					//"회원탈퇴 권한이 없습니다.";
					//return "B004";
				}
				
				//템프테이블에 탈퇴정보 추가
				 epce0140199Mapper.epce0140164_insert2(data);
				
				 epce0140199Mapper.epce0140164_update2(data);
				 epce0140199Mapper.epce0140164_update3(data);

		}catch (IOException io) {
			io.getMessage();
		}catch (SQLException sq) {
			sq.getMessage();
		}catch (NullPointerException nu){
			nu.getMessage();
		}catch(Exception e){
			throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
		}

		return errCd;

	}

}
