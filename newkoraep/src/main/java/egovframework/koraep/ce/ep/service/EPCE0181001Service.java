package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE0150201Mapper;
import egovframework.mapper.ce.ep.EPCE0181001Mapper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 도매 도매업자 지점관리 Service
 * @author 양성수
 *
 */
@Service("epce0181001Service")
public class EPCE0181001Service {

	@Resource(name="epce0181001Mapper")
	private EPCE0181001Mapper epce0181001Mapper;  //도매업자 지점관리 Mapper

	@Resource(name="epce0150201Mapper")
	private EPCE0150201Mapper epce0150201Mapper;  //직매장/공장관리 Mapper

	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통

	/**
	 * 도매업자 지점관리 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0181001_select(ModelMap model, HttpServletRequest request) {

		  try {
		  	//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);

			Map<String, String> map	= new HashMap<String, String>();
			List<?> whsl_se_cdList = commonceService.whsdl_se_select(request, map);//도매업자구분
			List<?> whsdlList = commonceService.whsdl_select(map);//도매업자 업체명조회
			List<?> aff_ogn_cd_list = commonceService.getCommonCdListNew("B004");//소속단체
			List<?> stat_cd_list = epce0181001Mapper.epce0181001_select3();//상태 활동 비활동
			List<?> area_cd_list = commonceService.getCommonCdListNew("B010");//지역
			List<?> acp_mgnt_yn_list = commonceService.getCommonCdListNew("S015");//수납관리여부
			List<?> ctnr_cd_rtc_yn_list = commonceService.getCommonCdListNew("S021");//용기코드제한여부
			String title = commonceService.getMenuTitle("EPCE0181001");//타이틀
			model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));
			model.addAttribute("whsdlList", util.mapToJson(whsdlList));
			model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));
			model.addAttribute("stat_cd_list", util.mapToJson(stat_cd_list));
			model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));
			model.addAttribute("acp_mgnt_yn_list", util.mapToJson(acp_mgnt_yn_list));
			model.addAttribute("ctnr_cd_rtc_yn_list", util.mapToJson(ctnr_cd_rtc_yn_list));
			
			model.addAttribute("titleSub", title);

			Map<String, String> paramMap = new HashMap<String, String>();
			if(jParams.get("SEL_PARAMS") !=null){
				JSONObject param2 =(JSONObject)jParams.get("SEL_PARAMS");
				if(param2.get("BIZRNO") !=null){
					paramMap.put("BIZRNO", param2.get("BIZRNO").toString());
					paramMap.put("BIZRID", param2.get("BIZRID").toString());
					List<?> grp_brch_no_list = commonceService.grp_brch_no_select(paramMap);//총괄지점
					model.addAttribute("grp_brch_no_list", util.mapToJson(grp_brch_no_list));
				}
			}


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

		  /**
			 *	도매업자 조회
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epce0181001_select4(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	try {
		    		rtnMap.put("whsdlList", util.mapToJson(commonceService.whsdl_select(inputMap)));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}//사업자 지점/공장 조회
				return rtnMap;
		    }

		/**
		 *	총괄지점 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0181001_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
	    		rtnMap.put("grp_brch_noList", util.mapToJson(commonceService.grp_brch_no_select(inputMap)));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}//사업자 지점/공장 조회
			return rtnMap;
	    }

		/**
		 * 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0181001_select3(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    		try {
					rtnMap.put("selList", util.mapToJson(epce0181001Mapper.epce0181001_select  (inputMap)));
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
	    		rtnMap.put("totalCnt", epce0181001Mapper.epce0181001_select_cnt(inputMap));
	    	return rtnMap;
	    }

		/**
		 * 도매업자 지점관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce0181001_excel(HashMap<String, String> data, HttpServletRequest request) {

			String errCd = "0000";
			try {
				List<?> list = epce0181001Mapper.epce0181001_select(data);
				//엑셀파일 저장
				commonceService.excelSave(request, data, list);
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

		/**
		 * 도매업자 지점관리  활동/ 비활동
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epce0181001_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						int stat = epce0181001Mapper.epce0181001_select2(map); //상태 체크
						 if(stat>0){
							throw new Exception("A012"); //상태정보가 변경되어있습니다. 다시 한 번 확인하시기 바랍니다.
						 }
						 map.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
						 epce0181001Mapper.epce0181001_update(map);//상태변경
					}
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch (Exception e) {
					if(e.getMessage().equals("A012") ){
						 throw new Exception(e.getMessage());
					 }else{
						 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					 }
				}
			}

			return errCd;
	    }

/***************************************************************************************************************************************************************************************
 * 		도매업자 지점관리 저장/ 수정
 ****************************************************************************************************************************************************************************************/

  /**
	 * 도매업자 지점관리 등록 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0181031_select(ModelMap model, HttpServletRequest request) {

		  try {
			  	//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				model.addAttribute("INQ_PARAMS",jParams);

				HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("PARAMS"));
				Map<String, String> map = new HashMap<String, String>();
				List<?> whsl_se_cdList = commonceService.whsdl_se_select(request, map);//도매업자구분
				List<?> aff_ogn_cd_list = commonceService.getCommonCdListNew("B004");//소속단체
				List<?> area_cd_list = commonceService.getCommonCdListNew("B010");//지역
				List<?> acp_mgnt_yn_list = commonceService.getCommonCdListNew("S015");//수납관리여부
				String   title = commonceService.getMenuTitle("EPCE0181031");//타이틀
				model.addAttribute("whsl_se_cdList", util.mapToJson(whsl_se_cdList));
				model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));
				model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));
				model.addAttribute("acp_mgnt_yn_list", util.mapToJson(acp_mgnt_yn_list));
				model.addAttribute("titleSub", title);

				List<?> BankCdList = commonceService.getCommonCdListNew("S090");//은행리스트
				model.addAttribute("BankCdList", util.mapToJson(BankCdList));

			//	List<?> whsdlList 				= commonceService.whsdl_select(map);    					//도매업자 업체명조회
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

	  /**
		 * 도매업자 지점관리 변경 초기화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce0181042_select(ModelMap model, HttpServletRequest request) {

			  try {
				  	//파라메터 정보
					String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
					JSONObject jParams = JSONObject.fromObject(reqParams);
					model.addAttribute("INQ_PARAMS",jParams);

					HashMap<String, String> jmap = util.jsonToMap(jParams.getJSONObject("PARAMS"));

					if(jmap != null){

						HashMap<String, String> map = (HashMap<String, String>)epce0181001Mapper.epce0181031_select2(jmap);

						if(map.get("ASTN_EMAIL") != null){
							map.put("EMAIL1", map.get("ASTN_EMAIL").split("@")[0]);
							map.put("EMAIL2", map.get("ASTN_EMAIL").split("@")[1]);
						}

						model.addAttribute("searchDtl", util.mapToJson(map));
					}else{
						model.addAttribute("searchDtl", "[]");
					}

					List<?> aff_ogn_cd_list = commonceService.getCommonCdListNew("B004");		//소속단체
					List<?> area_cd_list = commonceService.getCommonCdListNew("B010");		//지역
					List<?> acp_mgnt_yn_list = commonceService.getCommonCdListNew("S015");		//수납관리여부
					List<?> ctnr_cd_rtc_yn_list = commonceService.getCommonCdListNew("S021");		//용기코드제한여부
					String title = commonceService.getMenuTitle("EPCE0181042");		//타이틀

					model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));
					model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));
					model.addAttribute("acp_mgnt_yn_list", util.mapToJson(acp_mgnt_yn_list));
					model.addAttribute("ctnr_cd_rtc_yn_list", util.mapToJson(ctnr_cd_rtc_yn_list));
					model.addAttribute("titleSub", title);

					List<?> BankCdList = commonceService.getCommonCdListNew("S090"); //은행리스트
					model.addAttribute("BankCdList", util.mapToJson(BankCdList));

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

		/**
		 * 총괄지점 검색
		 * @param model
		 * @param request
		 * @return
		 * @
		 */
		public HashMap<String, Object> epce0181031_select(Map<String, String> data) {
			if(data.get("BIZRID_NO") != null && !data.get("BIZRID_NO").equals("")){
				String[] BIZR_CD = data.get("BIZRID_NO").split(";");
				data.put("BIZRID", BIZR_CD[0]);
				data.put("BIZRNO", BIZR_CD[1]);
			}else{
				data.put("BIZRID", "");
				data.put("BIZRNO", "");
			}

			HashMap<String, Object> map = new HashMap<String, Object>();
			try {
				map.put("grpList", util.mapToJson(epce0181001Mapper.epce0181031_select(data)));
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

			return map;
		}

		/**
		 * 지점 등록
		 * @param map
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epce0181031_insert(HashMap<String, String> data, HttpServletRequest request) throws Exception {
			String errCd = "0000";

			try {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO)session.getAttribute("userSession");

					data.put("S_USER_ID", "");
					if(vo != null){
						data.put("S_USER_ID", vo.getUSER_ID());
					}

					if(data.get("BIZRNM") != null && !data.get("BIZRNM").equals("")){
						String[] BIZR_CD = data.get("BIZRNM").split(";");
						data.put("BIZRID", BIZR_CD[0]);
						data.put("BIZRNO", BIZR_CD[1]);
					}else{
						data.put("BIZRID", "");
						data.put("BIZRNO", "");
					}

					int ck = epce0181001Mapper.epce0181031_select3(data);
					if(ck > 0){
						throw new Exception("B007"); //중복체크
					}

					if(data.get("ACP_MGNT_YN").equals("Y")){ //수납관리
						int ck2 = epce0150201Mapper.epce0150231_select4(data);
						if(ck2 > 0){
							throw new Exception("B008"); //중복
						}

						//ERP사업자코드 채번
						String erpBizrCd = "2" + commonceService.psnb_select("S0002");
						data.put("ERP_BIZR_CD", erpBizrCd); //ERP사업자코드

						epce0150201Mapper.epce0150231_insert2(data);	//사업자정보 등록 처리
					}

					String psnbSeq = commonceService.psnb_select("S0007"); //지점ID 일련번호 채번
					data.put("PSNB_SEQ", psnbSeq);

					if(data.get("GRP_YN").equals("Y")){
						data.put("GRP_BRCH_NO", "");
					}

					epce0181001Mapper.epce0181031_insert(data);	//등록 처리

			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				if(e.getMessage().equals("B007") || e.getMessage().equals("B008") ){
					 throw new Exception(e.getMessage());
				 }else{
					 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				 }
			}

			return errCd;
		}

		/**
		 * 지점 변경
		 * @param map
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epce0181042_update(HashMap<String, String> data, HttpServletRequest request) throws Exception {
			String errCd = "0000";

			try {
					HttpSession session = request.getSession();
					UserVO vo = (UserVO)session.getAttribute("userSession");

					data.put("S_USER_ID", "");
					if(vo != null){
						data.put("S_USER_ID", vo.getUSER_ID());
					}

					if(data.get("GRP_YN").equals("Y")){
						data.put("GRP_BRCH_NO", "");
					}

					epce0181001Mapper.epce0181042_update(data);	//수정

					if(data.get("ACP_MGNT_YN").equals("Y")){ //수납관리

						if(data.get("BRCH_NM_CHANGE_YN").equals("Y")){
							//ERP사업자코드 채번
							String erpBizrCd = "2" + commonceService.psnb_select("S0002");
							data.put("ERP_BIZR_CD", erpBizrCd); //ERP사업자코드
						}

						epce0150201Mapper.epce0150242_update2(data);	//사업자정보 변경
					}else{
						epce0150201Mapper.epce0150242_update3(data);	//사업자정보 비활성화
					}

			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			}catch(Exception e){
				throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
			}

			return errCd;
		}


/***************************************************************************************************************************************************************************************
 * 					지역 일괄 설정
 ****************************************************************************************************************************************************************************************/

		/**
		 * 지역 일괄 설정 초기화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce0181088_select(ModelMap model, HttpServletRequest request) {

			  try {
					List<?> area_cd_list = commonceService.getCommonCdListNew("B010");		//지역
					String   title = commonceService.getMenuTitle("EPCE0181088");		//타이틀
					model.addAttribute("area_cd_list", util.mapToJson(area_cd_list));
					model.addAttribute("titleSub", title);
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

		  /**
			 * 지역 일괄 설정 저장
			 * @param inputMap
			 * @param request
			 * @return
			 * @throws Exception
			 * @
			 */
			public String epce0181088_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
				String errCd = "0000";
				Map<String, String> map;
				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				if (list != null) {
					try {
						for(int i=0; i<list.size(); i++){
							map = (Map<String, String>) list.get(i);
							map.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
							epce0181001Mapper.epce0181088_update(map);//상태변경
						}
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
					}catch (Exception e) {
						if(e.getMessage().equals("A012") ){
							 throw new Exception(e.getMessage());
						 }else{
							 throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						 }
					}
				}

				return errCd;
		    }


/***************************************************************************************************************************************************************************************
 * 					단체 설정
 ****************************************************************************************************************************************************************************************/

	/**
	 * 단체 설정 초기화면
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce01810882_select(ModelMap model, HttpServletRequest request) {
		  try {
				List<?> aff_ogn_cd_list = commonceService.getCommonCdListNew("B004");//소속단체
				String title = commonceService.getMenuTitle("EPCE01810882");//타이틀
				model.addAttribute("aff_ogn_cd_list", util.mapToJson(aff_ogn_cd_list));
				model.addAttribute("titleSub", title);
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

	  /**
		 * 단체 설정 저장
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epce01810882_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						map.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
						epce0181001Mapper.epce01810882_update(map);//상태변경
					}
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch (Exception e) {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}

			return errCd;
	    }

		/**
		 * 단체 설정 초기화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public ModelMap epce01810883_select(ModelMap model, HttpServletRequest request) {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			try {
				model.addAttribute("aff_ogn_cd_list", util.mapToJson(commonceService.getCommonCdListNew("B004"))); //소속단체
				//model.addAttribute("titleSub"  , commonceService.getMenuTitle("EPCE01810883")); //타이틀
				model.addAttribute("BIZR_NM"   , vo.getBIZRNM());
				model.addAttribute("BIZRNO"    , vo.getBIZRNO());
				model.addAttribute("BIZRID"    , vo.getBIZRID());
				model.addAttribute("BIZRNO_ORI", vo.getBIZRNO_ORI());
				model.addAttribute("BRCH_NO"   , vo.getBRCH_NO());
				model.addAttribute("BRCH_ID"   , vo.getBRCH_ID());

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
		
		/**
		 * ERP정보등록 초기화면
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public ModelMap epce01810884_select(ModelMap model, HttpServletRequest request) {

			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");

			try {
				model.addAttribute("ERP_CD_LIST", util.mapToJson(commonceService.getCommonCdListNew("S022"))); //ERP코드
				model.addAttribute("BIZR_NM"   , vo.getBIZRNM());
				model.addAttribute("BIZRNO"    , vo.getBIZRNO());
				model.addAttribute("BIZRID"    , vo.getBIZRID());
				model.addAttribute("BIZRNO_ORI", vo.getBIZRNO_ORI());
				model.addAttribute("BRCH_NO"   , vo.getBRCH_NO());
				model.addAttribute("BRCH_ID"   , vo.getBRCH_ID());
				model.addAttribute("ERP_CD"    , vo.getERP_CD());
				model.addAttribute("ERP_CD_NM" , vo.getERP_CD_NM());

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
		
		 /**
		 * ERP 설정 저장
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception
		 * @
		 */
		public String epce01810884_update(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			String errCd = "0000";
			Map<String, String> map;
			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			if (list != null) {
				try {
					for(int i=0; i<list.size(); i++){
						map = (Map<String, String>) list.get(i);
						map.put("REG_PRSN_ID", vo.getUSER_ID());//등록자
						epce0181001Mapper.epce01810884_update(map);//ERP
					}
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				}catch (Exception e) {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}

			return errCd;
	    }
}
