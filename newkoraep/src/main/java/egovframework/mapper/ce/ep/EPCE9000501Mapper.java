package egovframework.mapper.ce.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper("epce9000501Mapper")
public interface EPCE9000501Mapper {
	//사업자관리 기초데이터
//	public List<?> epce9000501_select(HashMap<String, String> map) ;

	//무인회수기정보 조회
	public List<?> epce9000501_select2(Map<String, String> data) ;
	
	public List<?> epce9000501_select3(Map<String, String> data) ;
	
	//소모품 조회
	public List<?> epce9000532_select2(Map<String, String> data) ;
	
	public List<?> epce9000532_select3(Map<String, String> data) ;

	public List<?> urm_select(Map<String, String> inputMap) ;
	
	public List<?> urm_fix_select(Map<String, String> inputMap) ;
	
	public List<?> urm_fix_reg_dt(Map<String, String> inputMap) ;
	
	public List<?> urm_select2(Map<String, String> inputMap) ;
	public List<?> urm_select3(Map<String, String> inputMap) ;
	
	//사업자관리 조회
	public int epce9000501_select2_cnt(Map<String, String> data) ;

	public void epce9000531_update(HashMap<String, String> data) ;
	
	public void epce9000537_update(HashMap<String, String> data) ;
	
	public void epce9000531_update_hist(HashMap<String, String> data) ;

	public void epce9000531_insert(HashMap<String, String> data) ;
	
	public void epce9000533_insert(HashMap<String, String> data) ;
	
	
	//사업자관리 상세조회
	public HashMap<?, ?> epce9000516_select(Map<String, String> map) ;
	
	public HashMap<?, ?> epce9000536_select(Map<String, String> map) ;
	
	//시리얼번호 중복체크
	public Integer serialNoCheck(HashMap<String, String> map) ;
	
	public Integer urmcodeNoCheck(HashMap<String, String> map) ;
	
	public String urmCeNoCheck(HashMap<String, String> map) ;

	public Long numbercnt();

	public void epce900050142_update(Map<String, String> map);
	
	public void EPCE9000538_select(Map<String, String> map);


	public List<?> epce9000501_2_select(HashMap<String, String> data);

	public List<?> urm_list_select(HashMap<String, String> map);

	public List<?> serial_list_select(Map<String, String> inputMap);

	
	public void epce9000588_update(Map<String, String> map) ;

	public void epce9000531_hist(Map<String, String> map);

	public void epce9000531_insert_old(HashMap<String, String> data);

}