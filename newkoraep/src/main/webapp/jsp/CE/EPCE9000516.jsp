<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
	  var INQ_PARAMS;	
	  var toDay = kora.common.gfn_toDay();  // 현재 시간
	  
	  $(document).ready(function(){
		
		fn_btnSetting();
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		searchDtl = jsonObject($('#searchDtl').val());
		fnSetDtlData(searchDtl);
		$('#title_sub').text('<c:out value="무인회수기상세정보" />');

		$("#btn_cncl").click(function(){
			fn_cnl();
		});
	  
		$("#btn_upd").click(function(){
			fn_upd();
		});
	});

		//변경화면 이동
		function fn_upd(){
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000516.do";
			kora.common.goPage('/CE/EPCE9000542.do', INQ_PARAMS);
		}
		function fn_cnl(){		 
			//location.href = "/CE/EPCE8149301.do";		
			kora.common.goPageB('', INQ_PARAMS);
		}
		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){
			
				
			
		
			$("#URM_NM").text(kora.common.null2void(data.URM_NM));
			$("#SERIAL_NO").text(kora.common.null2void(data.SERIAL_NO));
			$("#AREA_NM").text(data.AREA_NM);
			$("#START_DT").text(kora.common.null2void(data.START_DT));
			$("#END_DT").text(kora.common.null2void(data.END_DT));
			$("#PNO").text(data.PNO);
			$("#ADDR").text(data.ADDR);
			$("#TELNO").text(kora.common.null2void(data.TELNO));
			$("#EMAIL").text(kora.common.null2void(data.EMAIL));
			$("#URM_TYPE").text(kora.common.null2void(data.URM_TYPE_NM));
			$("#URM_CE_NO").text(kora.common.null2void(data.URM_CE_NO));
			$("#URM_USE_DT").text(kora.common.null2void(data.URM_USE_DT));
			$("#URM_DE_DT").text(kora.common.null2void(data.URM_DE_DT));
			$("#USE_TOT").text(kora.common.null2void(data.USE_TOT));
			$("#USE_CNT_TOT").text(kora.common.null2void(data.USE_CNT_TOT));
			$("#USE_RTRVL_TOT").text(kora.common.null2void(data.USE_RTRVL_TOT));
			$("#USE_REST_TOT").text(kora.common.null2void(data.USE_REST_TOT));
			$("#USE_YN").text(kora.common.null2void(data.USE_YN));
		

		}
	

</script>
</head>
<body>
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
			<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
		<section class="secwrap">
			<div class="write_area" id='div_input'>
			<div class="write_tbl">
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
					<table>
						<colgroup>
							<col style="width: 8%;">
							<col style="width: 15%;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th colspan="2">설치 소매점</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="URM_NM" name="URM_NM" style="width: 330px;" class="i_notnull" alt="무인회수기명"> -->
									<div class="txtbox" id="URM_NM"></div> &nbsp; 
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">무인회수기 시리얼번호</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" alt="무인회수기시리얼번호"  format="number"  maxByteLength="9"> -->
										<div class="txtbox" id="SERIAL_NO"></div> &nbsp; 
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">센터고유넘버</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" alt="무인회수기시리얼번호"  format="number"  maxByteLength="9"> -->
										<div class="txtbox" id="URM_CE_NO"></div> &nbsp; 
								</div>
							</td>
						</tr>
						
							<tr>
						<tr>
							<th colspan="2">지역</th>
							<td>
								<div class="row">
<!-- 									<select id="AREA_CD" name="AREA_CD" style="width: 210px" class="i_notnull" alt="지역" ></select> -->
										<div class="txtbox" id="AREA_NM" style=""></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2" >주소</th>
							<td>
								<div class="row">
								
										<div class="txtbox" id="PNO"></div>&nbsp;
											<div class="txtbox" id="ADDR"></div>&nbsp;
								</div>
							</td>
						</tr>
							<tr>
							<th colspan="2">설치일자</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="TOTAL_TOT" name="TOTAL_TOT" style="width: 330px;" class="i_notnull" alt="총량" maxByteLength="30"> -->
									<div class="txtbox" id="START_DT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">철거일자</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="TOTAL_TOT" name="TOTAL_TOT" style="width: 330px;" class="i_notnull" alt="총량" maxByteLength="30"> -->
									<div class="txtbox" id="END_DT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">최초설치일자</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="TOTAL_TOT" name="TOTAL_TOT" style="width: 330px;" class="i_notnull" alt="총량" maxByteLength="30"> -->
									<div class="txtbox" id="URM_USE_DT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">품질보증만료일자</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="TOTAL_TOT" name="TOTAL_TOT" style="width: 330px;" class="i_notnull" alt="총량" maxByteLength="30"> -->
									<div class="txtbox" id="URM_DE_DT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">총량</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="USE_TOT" name="TOTAL_TOT" style="width: 330px;" class="i_notnull" alt="총량" maxByteLength="30"> -->
									<div class="txtbox" id="USE_TOT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">총회수량</th>
							<td>
								<div class="row">
									<div class="txtbox" id="USE_RTRVL_TOT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">잔여량</th>
							<td>
								<div class="row">
									<div class="txtbox" id="USE_REST_TOT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">총사용량</th>
							<td>
								<div class="row">
									<div class="txtbox" id="USE_CNT_TOT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">무인회수기 유형</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="USE_TOT" name="TOTAL_TOT" style="width: 330px;" class="i_notnull" alt="총량" maxByteLength="30"> -->
									<div class="txtbox" id="URM_TYPE"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">담당자연락처</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="USE_TOT" name="TOTAL_TOT" style="width: 330px;" class="i_notnull" alt="총량" maxByteLength="30"> -->
									<div class="txtbox" id="TELNO"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">E-MAIL</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="USE_TOT" name="TOTAL_TOT" style="width: 330px;" class="i_notnull" alt="총량" maxByteLength="30"> -->
									<div class="txtbox" id="EMAIL"></div>&nbsp;
								</div>
							</td>
						</tr>
							<tr>
							<th colspan="2">사용여부</th>
							<td>
								<div class="row">
									<div class="txtbox" id="USE_YN"></div>&nbsp;
									</select>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</section>
		</form>
		<section class="btnwrap mt20" >
		<div class="btnwrap">
			<div class="fl_r" id="BR">
<!-- 						<button type="button" class="btn36 c4" style="width: 100px;" id="btn_lst">취소</button> -->
<!-- 						<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">저장</button> -->
			</div>
		</div>
		</section>
	</div>



</body>
</html>