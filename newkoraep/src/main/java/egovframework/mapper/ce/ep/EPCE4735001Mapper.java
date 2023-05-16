package egovframework.mapper.ce.ep;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * 도매업자정산 수납확인 Mapper
 * @author Administrator
 *
 */

@Mapper("epce4735001Mapper")
public interface EPCE4735001Mapper {
	
	/**
	 * 고지서 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce4735001_select(Map<String, String> data) ;
	
	/**
	 * 가상계좌수납 리스트 조회
	 * @return
	 * @
	 */
	public List<?> epce4735001_select2(Map<String, String> data) ;
	
	/**
	 * 가상계좌번호 콤보박스 조회
	 * @return
	 * @
	 */
	public List<?> epce4735001_select3(Map<String, String> data) ;
	
	/**
	 * 도매업자정산 수납확인 중복 조회
	 * @return
	 * @
	 */
	public int epce4735001_select4(Map<String, String> data) ;
	
	/**
	 * 도매업자정산 수납확인 상태  업데이트
	 * @param map
	 * @
	 */
	 public int epce4735001_update(Map<String, String> map) ;
	 
	/**
	 * 도매업자정산 수납확인 상태  업데이트 (가상계좌수납내역)
	 * @param map
	 * @
	 */
	 public int epce4735001_update2(Map<String, String> map) ;
	 
	 /**
	 * 착오수납처리
	 * @param map
	 * @
	 */
	 public int epce4735001_update3(Map<String, String> map) ;
	
	/**
	 * 보증금잔액 인서트
	 * @param map
	 * @
	 */
	 public int epce4735001_insert(Map<String, String> map) ;
	 
	 /**
     * ERP 연계테이블 인서트 (반환정산)
     * @param map
     * @
     */
    public void INSERT_FI_Z_KORA_ECDOCU_W(Map<String, String> map) ;
	 
	 /**
     * ERP 연계테이블 인서트 (취급수수료)
     * @param map
     * @
     */
    public void INSERT_FI_Z_KORA_ECDOCU_F(Map<String, String> map) ;
    
    /**
     * ERP 연계테이블 인서트 (보증금)
     * @param map
     * @
     */
    public void INSERT_FI_Z_KORA_ECDOCU_G(Map<String, String> map) ;
    
}



