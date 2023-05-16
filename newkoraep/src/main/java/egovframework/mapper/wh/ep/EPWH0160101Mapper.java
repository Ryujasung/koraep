package egovframework.mapper.wh.ep;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper("epwh0160101Mapper")
public interface EPWH0160101Mapper {
	//사업자관리 기초데이터
//	public List<?> epwh0160101_select(HashMap<String, String> map) ;

	//사업자관리 조회
	public List<?> epwh0160101_select2(Map<String, String> data) ;

	//사업자관리 조회
	public int epwh0160101_select2_cnt(Map<String, String> data) ;

	//사업자관리 등록 관리자아이디 중복체크
	public Integer epwh01601311_select(HashMap<String, String> map) ;

	//사업자관리 등록 사업자번호 중복체크
	public Integer epwh01601311_select2(HashMap<String, String> map) ;

	//휴대번호 중복체크
	public Integer epwh01601311_select3(HashMap<String, String> map) ;

	//활동/비활동처리 대상조회
	public List<?> epwh0160101_select3(Map<String, String> map) ;

	//활동/비활동처리
	public void epwh0160101_update3(Map<String, String> map) ;

	//사업자 정보 등록
	public void epwh0160131_insert(Map<String, String> map) ;

	//지점 정보 등록
	public void epwh0160131_insert6(Map<String, String> map) ;

	//담당자 정보 등록
	public void epwh0160131_insert7(Map<String, String> map) ;

	//사업자 변경이력정보 등록
	public void epwh0160131_insert2(Map<String, String> map) ;

	//사용자 정보변경(등록) 이력
	public void epwh0160131_insert5(Map<String, String> map) ;

	//사업자 변경이력 조회
	public List<?> epwh0160101_select5(Map<String, String> map) ;

	//사업자관리 상세조회
	public HashMap<?, ?> epwh0160116_select(Map<String, String> map) ;

	//사업자관리 상세조회
	//public HashMap<String, String> epwh0160101_select4(Map<String, String> data) ;

	//사업자관리 사업자정보 변경
	public void epwh0160142_update(Map<String, String> map) ;

	//지점테이블 사업자명 변경
	public void epwh0160142_update2(Map<String, String> map) ;

	//가입승인변경여부 수정
	public void epwh0160116_update(Map<String, String> map) ;

	//회원정보 활동/비활동처리
	public void epwh0160101_update5(Map<String, String> map) ;

	//사업자정보 관리자변경
	public void epwh0160101_update4(Map<String, String> map) ;

	//사업자등록증 등록
	public void epwh0160131_insert3(HashMap<String, String> map) ;

	//생산자계약서 첨부파일 등록
	public void epwh0160131_insert4(Map<String, String> map) ;

	//사용자 메뉴 권한 그룹 등록
	public void epwh0160101_update6(Map<String, String> map) ;

	//휴폐업 상태 업데이트
	public void epwh0160101_update7(Map<String, String> map) ;

	//삭제할 첨부파일 조회
	public List<?> epwh0160116_select4(Map<String, String> map) ;

	//삭제할 첨부파일 조회
	public List<?> epwh0160116_select5(Map<String, String> map) ;

	//사업자관리 첨부파일 삭제
	public void epwh0160116_delete(Map<String, String> map) ;

	//사업자관리 첨부파일 삭제2
	public void epwh0160116_delete2(Map<String, String> map) ;

	//사업자관리 첨부파일 기존파일 순번 재조정
	public void epwh0160116_update4(Map<String, String> map) ;

	//사업자 관리자 확인
	public String epwh0160116_select6(Map<String, String> map) ;

	//지역일괄설정 저장/수정
	public void epce55990013_update (Map<String, String> map) ;

	//지역일괄설정 저장/수정
	 public void epwh0181088_update (Map<String, String> map) ;

}