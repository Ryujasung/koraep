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
		$('#title_sub').text('<c:out value="무인회수기소모품현황 상세정보" />');

		$("#btn_cncl").click(function(){
			fn_cnl();
		});
	  
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		/* $("#btn_del").click(function(){
			fn_del();
		}); */
	});

	  
	  
		//변경화면 이동
		function fn_upd(){
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000536.do";
			kora.common.goPage('/CE/EPCE9000537.do', INQ_PARAMS);
		}
		function fn_cnl(){		 
			//location.href = "/CE/EPCE8149301.do";		
			kora.common.goPage('/CE/EPCE9000532.do', INQ_PARAMS);
		}
		/* function fn_del(){
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000536.do";
			kora.common.goPage('/CE/EPCE9000538.do', INQ_PARAMS);
		} */
		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){
			
		
		
			$("#URM_FIX_DT").text(kora.common.null2void(data.URM_FIX_DT));
			$("#SERIAL_NO").text(kora.common.null2void(data.SERIAL_NO));
			$("#URM_EXP_NM").text(data.URM_EXP_NM);
			$("#URM_CNT").text(kora.common.null2void(data.URM_CNT));
			$("#TOT_PAY").text(kora.common.null2void(data.TOT_PAY));
			$("#CEN_PAY").text(kora.common.null2void(data.CEN_PAY));
			$("#RET_PAY").text(kora.common.null2void(data.RET_PAY));
			$("#CUST_PAY").text(kora.common.null2void(data.CUST_PAY));
			$("#REG_SN").text(kora.common.null2void(data.REG_SN));
			
		

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
							<th colspan="2">교체일자</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="URM_NM" name="URM_NM" style="width: 330px;" class="i_notnull" alt="무인회수기명"> -->
									<div class="txtbox" id="URM_FIX_DT"></div> &nbsp; 
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">무인회수기 시리얼번호</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" alt="무인회수기시리얼번호"  format="number"  maxByteLength="9"> -->
										<div class="txtbox" id="SERIAL_NO"></div> &nbsp; 
										<div class="txtbox" id="REG_SN" style="display: none;"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">소모품명</th>
							<td>
								<div class="row">
<!-- 									<input type="text" id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" alt="무인회수기시리얼번호"  format="number"  maxByteLength="9"> -->
										<div class="txtbox" id="URM_EXP_NM"></div> &nbsp; 
								</div>
							</td>
						</tr>
						
							<tr>
						<tr>
							<th colspan="2">개수</th>
							<td>
								<div class="row">
<!-- 									<select id="AREA_CD" name="AREA_CD" style="width: 210px" class="i_notnull" alt="지역" ></select> -->
										<div class="txtbox" id="URM_CNT" style=""></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2" >총 공급단가(원)</th>
							<td>
								<div class="row">
										<div class="txtbox" id="TOT_PAY"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2" >센터부담금액(원)</th>
							<td>
								<div class="row">
										<div class="txtbox" id="CEN_PAY"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2" >소매점부담금액(원)</th>
							<td>
								<div class="row">
										<div class="txtbox" id="RET_PAY"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2" >출고원가(유로)</th>
							<td>
								<div class="row">
										<div class="txtbox" id="CUST_PAY"></div>&nbsp;
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
 						<button type="button" class="btn36 c4" style="width: 100px;" id="btn_cncl">목록</button>
 						<!-- <button type="button" class="btn36 c2" style="width: 100px;" id="btn_upd">정보변경</button> -->
 						<!-- <button type="button" class="btn36 c3" style="width: 100px;" id="btn_del">삭제</button> --> 
 						
			</div>
		</div>
		</section>
	</div>



</body>
</html>