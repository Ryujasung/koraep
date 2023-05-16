<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>빈용기 회수 종합상황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;
	 var obj;

     $(function() {
    	 
    	 INQ_PARAMS	= jsonObject($('#INQ_PARAMS').val());
    	 console.log(INQ_PARAMS);
    	 searchList		= jsonObject($('#obj').val());

    	 $('#title_sub').text('<c:out value="${titleSub}" />');
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
	
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		 	
	});
     
     
   var parent_item; 
     
   
    //목록
  	function fn_page(){
  		kora.common.goPageB("", INQ_PARAMS);
    }

</script>

<style type="text/css">
</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
    <div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box" id="UR"></div>
		</div>
		   
		<section class="secwrap">
			<div class="h4group" >
			   <h5 class="tit">□ 기간별 출고 및 회수 현황</h5>
			</div>
			<div class="write_area">
			
				<div class="write_tbl">
				
					<table>
						<colgroup>
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 10%;">
							<col style="width: 10%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l" rowspan="2">구분</th>
								<th class="bd_l" rowspan="2">출고량(A)</th>
								<th class="bd_l" colspan="4">회수량</th>
								<th class="bd_l" rowspan="2">회수율(B/A)</th>
								<th class="bd_l" rowspan="2">전주대비증감률</th>
								
							</tr>
							<tr>
								<th class="bd_l">합계(B)</th>
								<th class="bd_l">가정용</th>
								<th class="bd_l">유흥용</th>
								<th class="bd_l">직접 반환하는자</th>
								
							</tr>
							
							<tr>
								<th class = "bd_l">
									<div class="row">
										<div class="txtbox">${INQ_PARAMS.PARAMS.F_START_DT} - ${INQ_PARAMS.PARAMS.F_END_DT }</th></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.DLIVY_QTY_1 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.RTRVL_QTY_1 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FH_CFM_QTY_TOT_1}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FB_CFM_QTY_TOT_1}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.DRCT_CFM_QTY_TOT_1}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id="">${obj.QTY_RT_1}</div>
									</div>
								</td>
								<td rowspan="2">
									<div class="row">
										<div class="txtbox" id="">출고 : ${obj.AA1}<br>회수 : ${obj.AA2} 
										</div>
									</div>
								</td>
								
							</tr>
							<tr>
								<th class = "bd_l">
									<div class="row">
										<div class="txtbox">${INQ_PARAMS.PARAMS.S_START_DT} - ${INQ_PARAMS.PARAMS.S_END_DT }</th></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.DLIVY_QTY_2}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.RTRVL_QTY_2}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FH_CFM_QTY_TOT_2}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FB_CFM_QTY_TOT_2}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.DRCT_CFM_QTY_TOT_2}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id="">${obj.QTY_RT_2}</div>
									</div>
								</td>
								
								
							</tr>
							
						</tbody>
					</table>
				</div>
			</div>
		</section>
		<section class="secwrap">
			<div class="h4group" >
			   <h5 class="tit">□ 가정용 출고 및 소비자 직접회수 현황</h5>
			</div>
			<div class="write_area">
			
				<div class="write_tbl">
				
					<table>
						<colgroup>
							<col style="width: 25%;">
							<col style="width: 25%;">
							<col style="width: 25%;">
							<col style="width: 25%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l" >구분</th>
								<th class="bd_l" >출고량(A)</th>
								<th class="bd_l" >회수량(B)</th>
								<th class="bd_l" >회수율(B/A)</th>
								
							</tr>
							
							<tr>
								<th class = "bd_l">
									<div class="row">
										<div class="txtbox">${INQ_PARAMS.PARAMS.F_START_DT} - ${INQ_PARAMS.PARAMS.F_END_DT }</th></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.PRPS_CD1_1 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FH_CFM_QTY_TOT_1 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id="">${obj.PER_PRPS_CD1}</div>
									</div>
								</td>
								
							</tr>
							<tr>
								<th class = "bd_l">
									<div class="row">
										<div class="txtbox">${INQ_PARAMS.PARAMS.S_START_DT} - ${INQ_PARAMS.PARAMS.S_END_DT }</div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.PRPS_CD1_2}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FH_CFM_QTY_TOT_2}"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id="">${obj.PER_PRPS_CD2}</div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</section>
<section class="secwrap">
			<div class="h4group" >
			   <h5 class="tit">□ 주종별 출고 및 회수 현황</h5>
			</div>
			<div class="write_area">
			
				<div class="write_tbl">
				
					<table>
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l"rowspan="2">구분</th>
								<th class ="bd_l" colspan="2">합계</td>
								<th class ="bd_l" colspan="2">소주</td>
								<th class ="bd_l" colspan="2">맥주</td>
								<th class ="bd_l" colspan="2">음료</td>
<%-- 								<th class="bd_l" colspan="2">${INQ_PARAMS.PARAMS.F_START_DT} - ${INQ_PARAMS.PARAMS.F_END_DT }</th> --%>
<%-- 								<th class="bd_l" colspan="2">${INQ_PARAMS.PARAMS.S_START_DT} - ${INQ_PARAMS.PARAMS.S_END_DT }</th> --%>
								
							</tr>
							<tr>
								<th class="bd_l">출고량</th>
								<th class="bd_l">회수량(회수율)</th>
								<th class="bd_l">출고량</th>
								<th class="bd_l">회수량(회수율)</th>
								<th class="bd_l">출고량</th>
								<th class="bd_l">회수량(회수율)</th>
								<th class="bd_l">출고량</th>
								<th class="bd_l">회수량(회수율)</th>
							</tr>
							<tr>
								<th class="bd_l">${INQ_PARAMS.PARAMS.F_START_DT} - ${INQ_PARAMS.PARAMS.F_END_DT }</th>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.DLIVY_QTY_1 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.RTRVL_QTY_1 }"/><br>(${obj.QTY_RT_1})</div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.ALKND1_1 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FB_CFM_QTY_TOT_11 }"/><br>(${obj.PER_ALKND1_1})</div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.ALKND2_1 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FH_CFM_QTY_TOT_11 }"/><br>(${obj.PER_ALKND2_1})</div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.ALKND9_1 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.DRCT_CFM_QTY_TOT_11 }"/><br>(${obj.PER_ALKND9_1})</div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l">${INQ_PARAMS.PARAMS.S_START_DT} - ${INQ_PARAMS.PARAMS.S_END_DT }</th>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.DLIVY_QTY_2 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.RTRVL_QTY_2 }"/><br>(${obj.QTY_RT_2})</div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.ALKND1_2 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FB_CFM_QTY_TOT_22 }"/><br>(${obj.PER_ALKND1_2})</div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.ALKND2_2 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.FH_CFM_QTY_TOT_22 }"/><br>(${obj.PER_ALKND2_2})</div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.ALKND9_2 }"/></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="txtbox" id=""><fmt:formatNumber value="${obj.DRCT_CFM_QTY_TOT_22 }"/><br>(${obj.PER_ALKND9_2})</div>
									</div>
								</td>
							</tr>
							
						</tbody>
					</table>
				</div>
			</div>
			<div class="h4group" >
			   <h5 class="tit" style="font-size: 16px;">※ 통계 수치는 신·구병 합계임</br>※ (출고량) 출고일 기준 / (회수량) 입고확인일 기준</h5>
			</div>
		</section>

		<section class="btnwrap mt20"  >
			<div class="btn"	 id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>
		
	</div>

</body>
</html>