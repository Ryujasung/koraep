<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>무인회수기 월별 회수량</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;
	 var obj;
	 var obj2;

     $(function() {
    	 
    	 INQ_PARAMS	= jsonObject($('#INQ_PARAMS').val());

    	 $('#title_sub').text('<c:out value="${titleSub}" />');
    	 
    	 doSum()
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		 	
	});
     function doSum(){
    	    let sum = 0;
    	    for(var j = 1; j < 3; j++){
				for(var i = 1; i < 14; i++){
					var className = j +"month" + i;
					var sumName = j +"sum" + i;
					var sumExp = null;
					$(document.getElementsByClassName(className)).each(function(){
						if(!isNaN($(this).val())){
							
							sum +=parseInt($(this).text().replace(/,/g,''));
						}
						sumExp = sum.toString().replace(/\B(?=(\d{3})+(?!\d))/g,',');
						document.getElementById(sumName).innerText = sumExp;
					});
					sum = 0;
		     	}
    	    }
    	}
     
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
<%-- <input type="hidden" class="obj" value="<c:out value='${obj}' />"/> --%>
    <div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" class="title_sub"></h3>
			<div class="btn_box" class="UR"></div>
		</div>
		   
		<section class="secwrap">
			<div class="h4group" >
			   <h5 class="tit">□ 월별 무인회수기 회수량</h5>
			</div>
			<div class="write_area">
			
				<div class="write_tbl">
				
					<table>
						<colgroup>
							<col style="width: 6%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 10%;">
							
						</colgroup>
						<tbody>
							<tr>
							
								<th class="bd_l" >구분</th>
								<th class="bd_l" >1월</th>
								<th class="bd_l" >2월</th>
								<th class="bd_l" >3월</th>
								<th class="bd_l" >4월</th>
								<th class="bd_l" >5월</th>
								<th class="bd_l" >6월</th>
								<th class="bd_l" >7월</th>
								<th class="bd_l" >8월</th>
								<th class="bd_l" >9월</th>
								<th class="bd_l" >10월</th>
								<th class="bd_l" >11월</th>
								<th class="bd_l" >12월</th>
								<th class="bd_l" >합계</th>
								
							</tr>
							<c:set var = "total1" value = "0" />
							<c:set var = "total2" value = "0" />
							<c:set var = "total3" value = "0" />
							<c:set var = "total4" value = "0" />
							<c:set var = "total5" value = "0" />
							<c:set var = "total6" value = "0" />
							<c:set var = "total7" value = "0" />
							<c:set var = "total8" value = "0" />
							<c:set var = "total9" value = "0" />
							<c:set var = "total10" value = "0" />
							<c:set var = "total11" value = "0" />
							<c:set var = "total12" value = "0" />
							<c:set var = "yyyytotal" value = "0" />
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2015</div></div>
								</th>
								<td><div class="row"><div class="txtbox 1month1"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month2"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month3"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month4"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month5"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month6"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month7"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month8"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month9"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month10"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month11"><fmt:formatNumber value="114660"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month12"><fmt:formatNumber value="127566"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 1month13"><fmt:formatNumber value="242226"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2016</div></div>
								</th>
								<td><div class="row"><div class="txtbox 1month1"><fmt:formatNumber value="192643"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month2"><fmt:formatNumber value="184875"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month3"><fmt:formatNumber value="322623"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month4"><fmt:formatNumber value="249813"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month5"><fmt:formatNumber value="280538"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month6"><fmt:formatNumber value="248436"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month7"><fmt:formatNumber value="269021"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month8"><fmt:formatNumber value="262912"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month9"><fmt:formatNumber value="329909"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month10"><fmt:formatNumber value="366155"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month11"><fmt:formatNumber value="398682"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month12"><fmt:formatNumber value="513942"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 1month13"><fmt:formatNumber value="3619549"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2017</div></div>
								</th>
								<td><div class="row"><div class="txtbox 1month1"><fmt:formatNumber value="535630"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month2"><fmt:formatNumber value="791665"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month3"><fmt:formatNumber value="978896"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month4"><fmt:formatNumber value="1089300"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month5"><fmt:formatNumber value="1290616"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month6"><fmt:formatNumber value="1247297"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month7"><fmt:formatNumber value="1395836"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month8"><fmt:formatNumber value="1452295"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month9"><fmt:formatNumber value="1469891"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month10"><fmt:formatNumber value="1579038"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month11"><fmt:formatNumber value="1345120"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month12"><fmt:formatNumber value="1419350"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 1month13"><fmt:formatNumber value="14594934"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2018</div></div>
								</th>
								<td><div class="row"><div class="txtbox 1month1"><fmt:formatNumber value="1336495"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month2"><fmt:formatNumber value="1397301"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month3"><fmt:formatNumber value="1561412"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month4"><fmt:formatNumber value="1421721"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month5"><fmt:formatNumber value="1472943"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month6"><fmt:formatNumber value="1427484"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month7"><fmt:formatNumber value="1383830"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month8"><fmt:formatNumber value="1323951"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month9"><fmt:formatNumber value="1436056"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month10"><fmt:formatNumber value="1425417"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month11"><fmt:formatNumber value="1345182"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month12"><fmt:formatNumber value="1427629"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 1month13"><fmt:formatNumber value="16959421"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2019</div></div>
								</th>
								<td><div class="row"><div class="txtbox 1month1"><fmt:formatNumber value="1558359"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month2"><fmt:formatNumber value="1524072"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month3"><fmt:formatNumber value="1612310"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month4"><fmt:formatNumber value="1379834"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month5"><fmt:formatNumber value="1517437"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month6"><fmt:formatNumber value="1540799"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month7"><fmt:formatNumber value="1411981"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month8"><fmt:formatNumber value="1476364"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month9"><fmt:formatNumber value="1496853"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month10"><fmt:formatNumber value="1494504"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month11"><fmt:formatNumber value="1442683"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month12"><fmt:formatNumber value="1533833"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 1month13"><fmt:formatNumber value="17989029"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2020</div></div>
								</th>
								<td><div class="row"><div class="txtbox 1month1"><fmt:formatNumber value="1557446"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month2"><fmt:formatNumber value="1422883"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month3"><fmt:formatNumber value="1735750"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month4"><fmt:formatNumber value="1703994"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month5"><fmt:formatNumber value="1707634"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month6"><fmt:formatNumber value="1550300"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month7"><fmt:formatNumber value="1608932"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month8"><fmt:formatNumber value="1576635"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month9"><fmt:formatNumber value="1827042"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month10"><fmt:formatNumber value="1778893"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month11"><fmt:formatNumber value="1645156"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month12"><fmt:formatNumber value="1993100"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 1month13"><fmt:formatNumber value="20107765"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2021</div></div>
								</th>
								<td><div class="row"><div class="txtbox 1month1"><fmt:formatNumber value="2096891"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month2"><fmt:formatNumber value="1841610"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month3"><fmt:formatNumber value="1911377"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month4"><fmt:formatNumber value="1799148"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month5"><fmt:formatNumber value="1958044"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month6"><fmt:formatNumber value="1712452"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month7"><fmt:formatNumber value="1829626"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month8"><fmt:formatNumber value="1815439"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month9"><fmt:formatNumber value="1737079"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month10"><fmt:formatNumber value="1751582"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month11"><fmt:formatNumber value="1467570"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month12"><fmt:formatNumber value="1608461"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 1month13"><fmt:formatNumber value="21529279"/></div></div>
								</td>
							</tr>
 							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2022</div></div>
								</th>
								<td><div class="row"><div class="txtbox 1month1"><fmt:formatNumber value="1799727"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month2"><fmt:formatNumber value="1638330"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month3"><fmt:formatNumber value="1646088"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month4"><fmt:formatNumber value="1579552"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month5"><fmt:formatNumber value="1612433"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month6"><fmt:formatNumber value="1456595"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month7"><fmt:formatNumber value="1549891"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month8"><fmt:formatNumber value="1606828"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month9"><fmt:formatNumber value="1664200"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month10"><fmt:formatNumber value="1706032"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month11"><fmt:formatNumber value="1558748"/></div></div></td>
								<td><div class="row"><div class="txtbox 1month12"><fmt:formatNumber value="1591186"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 1month13"><fmt:formatNumber value="19409610"/></div></div>
								</td>
							</tr>
							<c:forEach var ="item" items="${obj }" varStatus="status">
								
								<tr>
									<th class="bd_l" >
										<div class="row">
											<div class="txtbox">${item.YYYY }</div>
										</div>
									</th>
									<td>
										<div class="row">
											<div class="txtbox 1month1"><fmt:formatNumber value="${item.MONTH1 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month2"><fmt:formatNumber value="${item.MONTH2 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month3"><fmt:formatNumber value="${item.MONTH3 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month4"><fmt:formatNumber value="${item.MONTH4 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month5"><fmt:formatNumber value="${item.MONTH5 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month6"><fmt:formatNumber value="${item.MONTH6 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month7"><fmt:formatNumber value="${item.MONTH7 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month8"><fmt:formatNumber value="${item.MONTH8 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month9"><fmt:formatNumber value="${item.MONTH9 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month10"><fmt:formatNumber value="${item.MONTH10 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month11"><fmt:formatNumber value="${item.MONTH11 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 1month12"><fmt:formatNumber value="${item.MONTH12 }"/></div>
										</div>
									</td>
									<th class="bd_l" >
										<div class="row">
											<div class="txtbox 1month13" ><fmt:formatNumber value="${item.YYYYTOTAL }"/></div>
										</div>
									</td>
								</tr>
							</c:forEach>
							<tr>
								<th class="bd_l" >합계</th>
								<th><div class="txtbox" id="1sum1" ></div></th>
								<th><div class="txtbox" id="1sum2" ></div></th>
								<th><div class="txtbox" id="1sum3" ></div></th>
								<th><div class="txtbox" id="1sum4" ></div></th>
								<th><div class="txtbox" id="1sum5" ></div></th>
								<th><div class="txtbox" id="1sum6" ></div></th>
								<th><div class="txtbox" id="1sum7" ></div></th>
								<th><div class="txtbox" id="1sum8" ></div></th>
								<th><div class="txtbox" id="1sum9" ></div></th>
								<th><div class="txtbox" id="1sum10" ></div></th>
								<th><div class="txtbox" id="1sum11" ></div></th>
								<th><div class="txtbox" id="1sum12" ></div></th>
								<th><div class="txtbox" id="1sum13" ></div></th>
							</tr>
							
						</tbody>
					</table>
				</div>
			</div>
			<div class="h4group" >
			   <h5 class="tit" style="font-size: 16px;">
			   		※ 회수일 기준 월별 통계입니다.</br>
			   		※ 시리얼 번호가 등록되어있는 회수량만 집계됩니다.
			   	</h5>
			</div>
			<div class="h4group" >
			   <h5 class="tit">□ 월별 반환수집소 회수량</h5>
			</div>
						<div class="write_area">
			
				<div class="write_tbl">
				
					<table>
						<colgroup>
							<col style="width: 6%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 7%;">
							<col style="width: 10%;">
							
						</colgroup>
						<tbody>
							<tr>
							
								<th class="bd_l" >구분</th>
								<th class="bd_l" >1월</th>
								<th class="bd_l" >2월</th>
								<th class="bd_l" >3월</th>
								<th class="bd_l" >4월</th>
								<th class="bd_l" >5월</th>
								<th class="bd_l" >6월</th>
								<th class="bd_l" >7월</th>
								<th class="bd_l" >8월</th>
								<th class="bd_l" >9월</th>
								<th class="bd_l" >10월</th>
								<th class="bd_l" >11월</th>
								<th class="bd_l" >12월</th>
								<th class="bd_l" >합계</th>
								
							</tr>
							<c:set var = "total1" value = "0" />
							<c:set var = "total2" value = "0" />
							<c:set var = "total3" value = "0" />
							<c:set var = "total4" value = "0" />
							<c:set var = "total5" value = "0" />
							<c:set var = "total6" value = "0" />
							<c:set var = "total7" value = "0" />
							<c:set var = "total8" value = "0" />
							<c:set var = "total9" value = "0" />
							<c:set var = "total10" value = "0" />
							<c:set var = "total11" value = "0" />
							<c:set var = "total12" value = "0" />
							<c:set var = "yyyytotal" value = "0" />
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2017</div></div>
								</th>
								<td><div class="row"><div class="txtbox 2month1"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month2"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month3"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month4"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month5"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month6"><fmt:formatNumber value="0"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month7"><fmt:formatNumber value="6828"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month8"><fmt:formatNumber value="8004"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month9"><fmt:formatNumber value="15893"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month10"><fmt:formatNumber value="18802"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month11"><fmt:formatNumber value="40420"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month12"><fmt:formatNumber value="66206"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 2month13"><fmt:formatNumber value="156153"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2018</div></div>
								</th>
								<td><div class="row"><div class="txtbox 2month1"><fmt:formatNumber value="64661"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month2"><fmt:formatNumber value="81204"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month3"><fmt:formatNumber value="90578"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month4"><fmt:formatNumber value="114743"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month5"><fmt:formatNumber value="170661"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month6"><fmt:formatNumber value="162526"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month7"><fmt:formatNumber value="169550"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month8"><fmt:formatNumber value="174931"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month9"><fmt:formatNumber value="150841"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month10"><fmt:formatNumber value="176705"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month11"><fmt:formatNumber value="158981"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month12"><fmt:formatNumber value="144709"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 2month13"><fmt:formatNumber value="1660090"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2019</div></div>
								</th>
								<td><div class="row"><div class="txtbox 2month1"><fmt:formatNumber value="178570"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month2"><fmt:formatNumber value="182759"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month3"><fmt:formatNumber value="206457"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month4"><fmt:formatNumber value="204062"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month5"><fmt:formatNumber value="226635"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month6"><fmt:formatNumber value="262217"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month7"><fmt:formatNumber value="300856"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month8"><fmt:formatNumber value="369816"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month9"><fmt:formatNumber value="399569"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month10"><fmt:formatNumber value="469172"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month11"><fmt:formatNumber value="413954"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month12"><fmt:formatNumber value="423441"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 2month13"><fmt:formatNumber value="3637508"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2020</div></div>
								</th>
								<td><div class="row"><div class="txtbox 2month1"><fmt:formatNumber value="513885"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month2"><fmt:formatNumber value="554208"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month3"><fmt:formatNumber value="678053"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month4"><fmt:formatNumber value="592466"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month5"><fmt:formatNumber value="602293"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month6"><fmt:formatNumber value="624438"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month7"><fmt:formatNumber value="649585"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month8"><fmt:formatNumber value="597358"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month9"><fmt:formatNumber value="756268"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month10"><fmt:formatNumber value="767497"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month11"><fmt:formatNumber value="703286"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month12"><fmt:formatNumber value="823962"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 2month13"><fmt:formatNumber value="7863299"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2021</div></div>
								</th>
								<td><div class="row"><div class="txtbox 2month1"><fmt:formatNumber value="838835"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month2"><fmt:formatNumber value="819601"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month3"><fmt:formatNumber value="925281"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month4"><fmt:formatNumber value="878892"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month5"><fmt:formatNumber value="860104"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month6"><fmt:formatNumber value="938420"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month7"><fmt:formatNumber value="736334"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month8"><fmt:formatNumber value="742309"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month9"><fmt:formatNumber value="813126"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month10"><fmt:formatNumber value="805332"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month11"><fmt:formatNumber value="705266"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month12"><fmt:formatNumber value="781595"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 2month13"><fmt:formatNumber value="9845095"/></div></div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" >
									<div class="row"><div class="txtbox">2022</div></div>
								</th>
								<td><div class="row"><div class="txtbox 2month1"><fmt:formatNumber value="858458"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month2"><fmt:formatNumber value="860092"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month3"><fmt:formatNumber value="832611"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month4"><fmt:formatNumber value="778300"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month5"><fmt:formatNumber value="795409"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month6"><fmt:formatNumber value="746206"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month7"><fmt:formatNumber value="768589"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month8"><fmt:formatNumber value="831364"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month9"><fmt:formatNumber value="783565"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month10"><fmt:formatNumber value="772241"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month11"><fmt:formatNumber value="753070"/></div></div></td>
								<td><div class="row"><div class="txtbox 2month12"><fmt:formatNumber value="762051"/></div></div></td>
								<th class="bd_l" >
									<div class="row"><div class="txtbox 2month13"><fmt:formatNumber value="9541956"/></div></div>
								</td>
							</tr>
							<c:forEach var ="item" items="${obj2 }" varStatus="status">
							
								<tr>
									<th class="bd_l" >
										<div class="row">
											<div class="txtbox">${item.YYYY }</div>
										</div>
									</th>
									<td>
										<div class="row">
											<div class="txtbox 2month1"><fmt:formatNumber value="${item.MONTH1 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month2"><fmt:formatNumber value="${item.MONTH2 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month3"><fmt:formatNumber value="${item.MONTH3 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month4"><fmt:formatNumber value="${item.MONTH4 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month5"><fmt:formatNumber value="${item.MONTH5 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month6"><fmt:formatNumber value="${item.MONTH6 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month7"><fmt:formatNumber value="${item.MONTH7 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month8"><fmt:formatNumber value="${item.MONTH8 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month9"><fmt:formatNumber value="${item.MONTH9 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month10"><fmt:formatNumber value="${item.MONTH10 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month11"><fmt:formatNumber value="${item.MONTH11 }"/></div>
										</div>
									</td>
									<td>
										<div class="row">
											<div class="txtbox 2month12"><fmt:formatNumber value="${item.MONTH12 }"/></div>
										</div>
									</td>
									<th class="bd_l" >
										<div class="row">
											<div class="txtbox 2month13" ><fmt:formatNumber value="${item.YYYYTOTAL }"/></div>
										</div>
									</td>
								</tr>
							</c:forEach>
							<tr>
								<th class="bd_l" >합계</th>
								<th><div class="txtbox" id="2sum1" ></div></th>
								<th><div class="txtbox" id="2sum2" ></div></th>
								<th><div class="txtbox" id="2sum3" ></div></th>
								<th><div class="txtbox" id="2sum4" ></div></th>
								<th><div class="txtbox" id="2sum5" ></div></th>
								<th><div class="txtbox" id="2sum6" ></div></th>
								<th><div class="txtbox" id="2sum7" ></div></th>
								<th><div class="txtbox" id="2sum8" ></div></th>
								<th><div class="txtbox" id="2sum9" ></div></th>
								<th><div class="txtbox" id="2sum10" ></div></th>
								<th><div class="txtbox" id="2sum11" ></div></th>
								<th><div class="txtbox" id="2sum12" ></div></th>
								<th><div class="txtbox" id="2sum13" ></div></th>
							</tr>
							
						</tbody>
					</table>
				</div>
			</div>
			<div class="h4group" >
			   <h5 class="tit" style="font-size: 16px;">
			   		※ 수집소 관리업체 작성 기준 월별통계입니다.
			   	</h5>
			</div>
		</section>

		<section class="btnwrap mt20"  >
			<div class="btn"	 class="BL"></div>
			<div class="btn" style="float:right" class="BR">
				<button type="button" class="btn36 c5" style="width: 100px;" id="btn_page">목록</button>
			</div>
		</section>
		
	</div>

</body>
</html>