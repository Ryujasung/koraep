package egovframework.koraep.ce.ep.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import egovframework.common.util;
import egovframework.koraep.ce.dto.UserVO;
import egovframework.mapper.ce.ep.EPCE3944888Mapper;

@Service("epce3944888Service")
public class EPCE3944888Service{

	@Resource(name="epce3944888Mapper")
	private EPCE3944888Mapper epce3944888Mapper;  //언어구분관리 Mapper
	
	/**
	 * 언어구분관리 초기 화면 데이터
	 * @param model
	 * @param request
	 * @return
	 * @
	 */
		public ModelMap epce3944888_select(ModelMap model, HttpServletRequest request) {

		Map<String, String> map = new HashMap<String, String>();
		
		//언어관리 리스트
		List<?> lang_se_mgnt_list= epce3944888Mapper.epce3944888_select();
		
		try {
			model.addAttribute("lang_se_mgnt_list_p", util.mapToJson(lang_se_mgnt_list));
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
		 * 언어구분관리 저장
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
		public String epce3944888_insert(Map<String, String> data, HttpServletRequest request) throws Exception  {
			
			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				data.put("RGST_PRSN_ID"    ,vo.getUSER_ID());
				

				//저장시 중복데이트 확인
					int rst =epce3944888Mapper.epce3944888_select2(data);
					
					if(rst >0){
						errCd ="A003";
						return errCd; 
					}
			
				//언어구분관리 저장
				epce3944888Mapper.epce3944888_insert(data);
				
				//표준여부 변경시
			    if(!data.get("LANG_SE_CD_STD").equals("")){

				    epce3944888Mapper.epce3944888_update(data); 
			    }
			  
			    //표시순서 변경시
			    if(!data.get("LANG_SE_CD_CNT").equals("") ){
				    epce3944888Mapper.epce3944888_update3(data); 
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
		/**
		 * 언어구분관리 수정
		 * @param data
		 * @param request
		 * @return
		 * @throws Exception 
		 * @
		 */
       public String epce3944888_update(Map<String, String> data, HttpServletRequest request) throws Exception  {
			
			String errCd = "0000";
			try {
				HttpSession session = request.getSession();
				UserVO vo = (UserVO)session.getAttribute("userSession");
				data.put("UPD_PRSN_ID"    ,vo.getUSER_ID());
				//언어구분관리 수정
				epce3944888Mapper.epce3944888_update2(data);
				
				//표준여부 변경시
			  if(!data.get("LANG_SE_CD_STD").equals("")){
				epce3944888Mapper.epce3944888_update(data); 
			  }
			   //표시순서 변경시
			  if(data.get("LANG_SE_CD_CNT") !=""){
				 epce3944888Mapper.epce3944888_update3(data); 
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

		/**
		 * 언어구분관리 조회
		 * @param inputMap
		 * @param request
		 * @return
		 * @
		 */
		  public HashMap epce3944888_select2(Map<String, String> inputMap, HttpServletRequest request) {
		    	HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		    	
		    	try {
					rtnMap.put("lang_se_mgnt_list_p", util.mapToJson(epce3944888Mapper.epce3944888_select()));
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
		
		
}
