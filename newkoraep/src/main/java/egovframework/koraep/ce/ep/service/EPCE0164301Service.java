package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.CommonCeMapper;
import egovframework.mapper.ce.ep.EPCE0105901Mapper;
import egovframework.mapper.ce.ep.EPCE0164301Mapper;

/**
 * 개별취급수수료관리 Service
 * @author 양성수
 *
 */
@Service("epce0164301Service")
public class EPCE0164301Service {
	
	
	@Resource(name="epce0164301Mapper")
	private EPCE0164301Mapper epce0164301Mapper;  //개별취급수수료관리 Mapper
	
	@Resource(name="epce0105901Mapper")
	private EPCE0105901Mapper epce0105901Mapper;  //빈용기기준금액관리 Mapper
	
	@Resource(name="commonceService")
	private CommonCeService commonceService;  //공통
	
	@Resource(name="commonceMapper")
	private CommonCeMapper commonceMapper;
	
	/**
	 * 개별취급수수료관리
	 * @param inputMap
	 * @param request
	 * @return
	 * @
	 */
	  public ModelMap epce0164301_select(ModelMap model, HttpServletRequest request) {
		  
		  	Map<String, String> map = new HashMap<String, String>(); 
		  	
			//파라메터 정보
			String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
			JSONObject jParams = JSONObject.fromObject(reqParams);
			model.addAttribute("INQ_PARAMS",jParams);
			String   title				 	= commonceService.getMenuTitle("EPCE0164388");
			List<?> mfcSeCdList 	= commonceService.mfc_bizrnm_select(request); 				// 생산자 콤보박스
			List<?> bizrTpCd		 	= epce0164301Mapper.epce0164331_select(); 			// 거래처구분
			List<?> std_fee_yn		= commonceService.getCommonCdListNew("S007");	//기준수수료여부
			try {
				model.addAttribute("titleSub", title);
				model.addAttribute("std_fee_yn", util.mapToJson(std_fee_yn));	//기준수수료여부
				model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));	//생산자구분 리스트
				model.addAttribute("bizrTpCd", util.mapToJson(bizrTpCd));
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
			}	//거래처구분
			return model;    	
	    }
	  
		/**
		 * 개별취급수수료관리 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		public HashMap epce0164301_select2(Map<String, String> inputMap, HttpServletRequest request) {
	    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
	    	try {
				rtnMap.put("initList", util.mapToJson(epce0164301Mapper.epce0164301_select(inputMap)));
				rtnMap.put("totalCnt", epce0164301Mapper.epce0164301_select_cnt(inputMap));
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
			return rtnMap;    	
	    }
		
		/**
		 * 개별취급수수료관리 엑셀
		 * @param map
		 * @param request
		 * @return
		 * @
		 */
		public String epce0164301_excel(HashMap<String, String> data, HttpServletRequest request) {
			
			String errCd = "0000";

			try {
				
				data.put("excelYn", "Y");
				List<?> list = epce0164301Mapper.epce0164301_select(data);
				
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
		 * 개별취급수수료관리 삭제
		 * @param inputMap
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public  List<?> epce0164301_delete(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
			HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			Map<String, String> map = new HashMap<String, String>(); 
			try {
			
				HttpSession session = request.getSession();
				UserVO vo = (UserVO) session.getAttribute("userSession");
				inputMap.put("RGST_PRSN_ID", vo.getUSER_ID());
				int sel_rst = epce0164301Mapper.epce0164301_select2(inputMap); //기준보증금관리 삭제여부 가능한지 확인
				if(sel_rst>0){
					throw new Exception("A006"); //이미 적용 중인 내역은 삭제할 수 없습니다.
				}
					epce0164301Mapper.epce0164301_delete2(inputMap);			// 기준보증금이력 삭제
					epce0164301Mapper.epce0164301_delete(inputMap);			// 기준보증금 삭제
				List<?> list = epce0164301Mapper.epce0164301_select(map);	// 개별취급수수료 다시 조회
				return list;    	
				
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if (e.getMessage().equals("A006")) {
					throw new Exception(e.getMessage());
				} else {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}	
			
	    }
		
	  
	  
	  /**
		 * 개별취급수수료등록
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce0164331_select(ModelMap model, HttpServletRequest request) {
			  
			   Map<String, String> map = new HashMap<String, String>(); 
			   
				//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				model.addAttribute("INQ_PARAMS",jParams);
				
				map.put("MFC_SE_CD", "");
				map.put("CTNR_CD", "");
				
				String   title				 	= commonceService.getMenuTitle("EPCE0164331");
				List<?> mfcSeCdList		= commonceService.mfc_bizrnm_select(request); 		// 생산자 콤보박스
				List<?> bizrTpCd			= epce0164301Mapper.epce0164331_select(); // 사업자유형코드(거래처구분)
				
				model.addAttribute("titleSub", title);
				
				try {
					model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
					model.addAttribute("bizrTpCd", util.mapToJson(bizrTpCd));
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
			 * 개별취급수수료등록 기준취급수수료 선택 부분 빈용기명 조회
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epce0164331_select2(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
			    	List<?> ctnrNmList	= commonceService.ctnr_nm_select(request, inputMap);
			    	List<?> brchList		= epce0164301Mapper.epce0164331_select2(inputMap); // 직매장/공장
			    	
			    	try {
			    		rtnMap.put("ctnrNmList", util.mapToJson(ctnrNmList));    
						rtnMap.put("brchList", util.mapToJson(brchList));
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
			    	return rtnMap;    	
		    }
			
			/**
			 * 개별취급수수료등록 기준취급수수료 선택 부분   적용기간 조회
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epce0164331_select3(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	try {
					rtnMap.put("aplc_dt", util.mapToJson(epce0164301Mapper.epce0164331_select3(inputMap)));
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
				return rtnMap;    	
		    }
			
			/**
			 * 개별취급수수료등록 기준취급수수료 선택 부분     조회
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			public HashMap epce0164331_select4(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	try {
					rtnMap.put("selList", util.mapToJson(epce0164301Mapper.epce0164331_select4(inputMap)));
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
		    	
				return rtnMap;    	
		    }
		  
			/**
			 * 개별취급수수료등록 일괄 적용대상 설정     조회
			 * @param inputMap
			 * @param request
			 * @return
			 * @throws Exception 
			 * @
			 */
			public List<?>  epce0164331_select5(Map<String, String> inputMap, HttpServletRequest request) throws Exception {
		    	try {
			    	int reg_cnt = epce0164301Mapper.epce0164331_select9(inputMap); //기준취급수수료날짜 체크
					if (reg_cnt !=1) {
						throw new Exception("A015"); // 기준취급수수료 적용기간 안에서만 가능합니다. \n 다시 한번 확인해주시기 바랍니다다.
					}
			    	List<?> list = epce0164301Mapper.epce0164331_select5(inputMap);
					return list;
		    	}catch (IOException io) {
		    		System.out.println(io.toString());
		    	}catch (SQLException sq) {
		    		System.out.println(sq.toString());
		    	}catch (NullPointerException nu){
		    		System.out.println(nu.toString());
		    	}catch(Exception e){
					if (e.getMessage().equals("A015")) {
						throw new Exception(e.getMessage());
					} else {
						throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
					}
				}
		    }
		  
		/**
		 * 개별취급수수료등록  저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
	    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
		public String epce0164331_insert(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
		
			HttpSession session = request.getSession();
			UserVO vo = (UserVO) session.getAttribute("userSession");
			String errCd = "0000";
			Map<String, String> map;

			List<?> list = JSONArray.fromObject(inputMap.get("list"));
			if (list != null) {
			try {
				
				for(int i=0; i<list.size(); i++){
					map = (Map<String, String>) list.get(i);
					if (!"".equals(map.get("START_DT"))) {
						map.put("START_DT",map.get("START_DT").replace("-", ""));
					}
					if (!"".equals(map.get("END_DT"))) {
						map.put("END_DT",map.get("END_DT").replace("-", ""));
					}

					int reg_cnt = epce0164301Mapper.epce0164331_select9(map); //기준취급수수료날짜 체크
					if (reg_cnt !=1) {
						throw new Exception("A015"); // 기준취급수수료 적용기간 안에서만 가능합니다. \n 다시 한번 확인해주시기 바랍니다다.
					}
					
						reg_cnt = epce0164301Mapper.epce0164331_select8(map); //날짜 중복 체크
					if(reg_cnt>0){
						throw new Exception("A003"); //중복된 데이터 입니다
					}
					
						map.put("PSNB_CD", "S0003");
						String reg_sn 	= commonceService.psnb_select("S0003"); // 등록순번
						map.put("PSNB_SEQ", reg_sn);
						String aplc_no = epce0164301Mapper.epce0164331_select7(map); // 적용번호
	
						map.put("REG_PRSN_ID", vo.getUSER_ID());
						map.put("INDV_SN", reg_sn);
						map.put("APLC_NO", aplc_no);
	
						epce0164301Mapper.epce0164331_insert(map); // 개별취급수수료 저장
						epce0164301Mapper.epce0164331_insert2(map); // 개별취급수수료이력	저장

					
				}
			}catch (IOException io) {
				System.out.println(io.toString());
			}catch (SQLException sq) {
				System.out.println(sq.toString());
			}catch (NullPointerException nu){
				System.out.println(nu.toString());
			} catch (Exception e) {
				if (e.getMessage().equals("A015") || e.getMessage().equals("A003")) {
					throw new Exception(e.getMessage());
				}else {
					throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
				}
			}
		}
		return errCd;
	}

		  /**
			 * 개별취급수수료변경
			 * @param inputMap
			 * @param request
			 * @return
			 * @
			 */
			  public ModelMap epce0164342_select(ModelMap model, HttpServletRequest request) {
				  
				  	Map<String, String> map = new HashMap<String, String>(); 
				  	
					//파라메터 정보
					String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
					JSONObject jParams = JSONObject.fromObject(reqParams);
					model.addAttribute("INQ_PARAMS",jParams);
					
					JSONObject jParams2 =  (JSONObject)jParams.get("PARAMS");
					
				 	String ctnr_cd			=  jParams2.get("CTNR_CD").toString();
				 	String lang_se_cd		=  jParams2.get("LANG_SE_CD").toString();
				 	String reg_sn			=  jParams2.get("REG_SN").toString();
				 	String indv_sn			=  jParams2.get("INDV_SN").toString();
				 	String bizrno			=  jParams2.get("MFC_BIZRNO").toString();  	//생산자 사업자번호
				 	String bizrid			=  jParams2.get("MFC_BIZRID").toString();  	//생산자 사업자번호
					String aplc_st_dt		=  jParams2.get("APLC_ST_DT").toString();  	//적용기간
				 	String aplc_end_dt	=  jParams2.get("APLC_END_DT").toString();  //적용기간
					String rtl_fee			=  jParams2.get("RTL_FEE").toString();  			//소매수수료
				 	String whsl_fee		=  jParams2.get("WHSL_FEE").toString();  		//도매수수료
				 	
				 	map.put("CTNR_CD", ctnr_cd);
				 	map.put("LANG_SE_CD", lang_se_cd);
				 	map.put("REG_SN", reg_sn);
				 	map.put("INDV_SN", indv_sn);
				 	map.put("BIZRNO", bizrno);
				 	map.put("BIZRID", bizrid);
				 	map.put("RTL_FEE", rtl_fee);
				 	map.put("WHSL_FEE", whsl_fee);
					map.put("START_DT", aplc_st_dt);
				 	map.put("END_DT", aplc_end_dt);
				 	map.put("SAVE_CHK", "U");
				 
				 	List<?> initList		=  epce0164301Mapper.epce0164342_select(map);
					List<?> initList2	=  epce0164301Mapper.epce0164331_select5(map);
					String   title			=  commonceService.getMenuTitle("EPCE0164342");
					
					try {
						model.addAttribute("initList", util.mapToJson(initList));		//기준취급수수료 정보 그리드 조회
						model.addAttribute("initList2", util.mapToJson(initList2));
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
					} catch (Exception e) {
						// TODO Auto-generated catch block
						org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
					}	//일괄 적용대상 설정 조회
					model.addAttribute("titleSub", title);
					return model;    	
			    }
	  
			  /**
				 * 개별취급수수료수정 일괄등록
				 * @param data
				 * @param request
				 * @return
				 * @throws Exception 
				 * @
				 */
			    @Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
				public String epce0164342_update(Map<String, Object> inputMap,HttpServletRequest request) throws Exception  {
				
						HttpSession session = request.getSession();
						UserVO vo = (UserVO) session.getAttribute("userSession");
						String errCd = "0000";
						Map<String, String> map;

				List<?> list = JSONArray.fromObject(inputMap.get("list"));
				if (list != null) {
					try {

						for(int i=0; i<list.size(); i++){
							map = (Map<String, String>) list.get(i);
							
							if (!"".equals(map.get("START_DT"))) {
								map.put("START_DT",map.get("START_DT").replace("-", ""));
							}
							if (!"".equals(map.get("END_DT"))) {
								map.put("END_DT",map.get("END_DT").replace("-", ""));
							}

							int reg_cnt = epce0164301Mapper.epce0164331_select9(map); //기준취급수수료날짜 체크
							if (reg_cnt !=1) {
								throw new Exception("A015"); // 기준취급수수료 적용기간 안에서만 가능합니다. \n 다시 한번 확인해주시기 바랍니다다.
							}
							
							reg_cnt = epce0164301Mapper.epce0164331_select8(map); //날짜 중복 체크
							if (reg_cnt > 0) {
								throw new Exception("A003"); //중복된 데이터 입니다. 다시 한번 확인해주시기 바랍니다.
							}
							
							map.put("REG_PRSN_ID", vo.getUSER_ID());
							epce0164301Mapper.epce0164342_update(map); // 개별취급수수료변경
							epce0164301Mapper.epce0164331_insert2(map); // 개별취급수수료이력	저장
							
					  	}
					}catch (IOException io) {
						System.out.println(io.toString());
					}catch (SQLException sq) {
						System.out.println(sq.toString());
					}catch (NullPointerException nu){
						System.out.println(nu.toString());
					} catch (Exception e) {
						if (e.getMessage().equals("A015") || e.getMessage().equals("A003")) {
							throw new Exception(e.getMessage());
						}else {
							throw new Exception("A001"); // DB 처리중 오류가 발생하였습니다. 관리자에게 문의하세요.
						}
					}
				}
				return errCd;
			}	  

	  /**
		 * 기준수수료조회 팝업창 오픈
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public ModelMap epce0164388_select(ModelMap model, HttpServletRequest request) {
			  
			  	Map<String, String> map = new HashMap<String, String>(); 
			  	
				//파라메터 정보
				String reqParams = util.null2void(request.getParameter("INQ_PARAMS"),"{}");
				JSONObject jParams = JSONObject.fromObject(reqParams);
				model.addAttribute("INQ_PARAMS",jParams);
				
				
				map.put("MFC_SE_CD", "");
				map.put("CTNR_CD", "");
				
				map.put("ROWS_PER_PAGE", "15");
				map.put("CURRENT_PAGE", "1");
				
				List<?> initList			= epce0105901Mapper.epce0105901_select(map);  //빈용기 기준금액관리 조회 기준수수료 조회
				List<?> mfcSeCdList= commonceService.mfc_bizrnm_select(request); // 생산자 콤보박스
				String   title				= commonceService.getMenuTitle("EPCE0164388");
				
				model.addAttribute("titleSub", title);
				
				try {
					model.addAttribute("initList", util.mapToJson(initList));					//빈용기기준금액관리
					model.addAttribute("mfcSeCdList", util.mapToJson(mfcSeCdList));
				}catch (IOException io) {
					System.out.println(io.toString());
				}catch (SQLException sq) {
					System.out.println(sq.toString());
				}catch (NullPointerException nu){
					System.out.println(nu.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					org.slf4j.LoggerFactory.getLogger(egovframework.common.AuthenticationFailHandlerImpl.class).debug("Exception Error");
				}	//생산자구분 리스트
		    	
				return model;    	
		    }
	  
}
