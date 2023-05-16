<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>우편번호검색</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
$(document).ready(function(){

});

//특수문자, 특정문자열(sql예약어의 앞뒤공백포함) 제거
function checkSearchedWord(obj){
	if(obj.value.length >0){
		//특수문자 제거
		var expText = /[%=><]/ ;
		if(expText.test(obj.value) == true){
			alert("특수문자를 입력 할수 없습니다.") ;
			obj.value = obj.value.split(expText).join(""); 
			return false;
		}
		
		//특정문자열(sql예약어의 앞뒤공백포함) 제거
		var sqlArray = new Array(
			//sql 예약어
			"OR", "SELECT", "INSERT", "DELETE", "UPDATE", "CREATE", "DROP", "EXEC",
             		 "UNION",  "FETCH", "DECLARE", "TRUNCATE" 
		);
		
		var regex;
		for(var i=0; i<sqlArray.length; i++){
			regex = new RegExp( sqlArray[i] ,"gi") ;
			
			if (regex.test(obj.value) ) {
			    alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex, "");
				return false;
			}
		}
	}
	return true ;
}


//검색
function fn_search(pg) {
	var keyword = $("#keyword").val();
	if(keyword == null || keyword == ""){
		alertMsg("검색어를 입력하세요");
		return;
	}
	
	if(!checkSearchedWord(document.frmMenu.keyword)) {
		return;
	}
	
	var sData = {"keyword":keyword, "currentPage":pg};
	var url = "/EP/SELECT_ZIPCODE.do";
	ajaxPost(url, sData, fn_setList);
}

//검색 결과 세팅
function fn_setList(data){
	
	var totCnt=0;
	var currentPage=1;
	var totalPage = 1;
	var addrList = [];
	if(data.totalCount != null){
		totCnt = Number(data.totalCount);
		currentPage = Number(data.currentPage);
		totalPage = Number(data.totalPage);
		addrList = data.addrList;
	}
	
	var txt = new Array();
	if(addrList.length == 0){
		txt.push('<tr><td colspan="2">검색된 주소가 없습니다.</td></tr>');
	}else{
		for(var i=0; i<addrList.length; i++){
			var map = addrList[i];
			txt.push('<tr><td style=""><a href="javascript:fn_setRtnValue(\'' + map.postcd + '\', \'' + map.address + '\');">' + map.postcd + '</a></td>');
			txt.push('<td style="text-align:left; padding-left:5px">[도로주소] <a href="javascript:fn_setRtnValue(\'' + map.postcd + '\', \'' + map.address + '\');">' + map.address + '</a><br/>');
			txt.push('[지번주소] <a href="javascript:fn_setRtnValue(\'' + map.postcd + '\', \'' + map.address + '\');">' + map.addrjibun + '</a></td></tr>');
			//txt.push('<td><a href="javascript:fn_setRtnValue(\'' + map.postcd + '\', \'' + map.address + '\');">' + map.address + '</a></td></tr>');
			//txt.push('<td>' + map.addrjibun + '</td></tr>');
		}
	}
	$("#list").html(txt.join("").toString());
	
	
	var pgGroupSize = 10;
	var currGroup = 1;
	var totGroup = 1;
	var startPage = 1;
	var endPage = pgGroupSize;
	
	if(currentPage <= 0) currentPage = 1;
	if(totalPage <= 0) totalPage = 1;
	
	currGroup = parseInt(currentPage / pgGroupSize);
	totGroup = parseInt(totalPage / pgGroupSize);
	if(currentPage % pgGroupSize > 0) currGroup++;
	if(totalPage % pgGroupSize > 0) totGroup++;
	
	startPage = (currGroup-1) * pgGroupSize + 1;
	endPage = currGroup * pgGroupSize;
	if(startPage <= 0) startPage = 1;
	if(endPage > totalPage) endPage = totalPage;
	
	var gridStartTxt = "≪";
	var gridEndTxt = "≫";
	var gridPrevTxt = "◀";
	var gridNextTxt = "▶";
	
	txt = new Array();
	if(currentPage > 1){
		txt.push('<a href="javascript:fn_search(1);"  class="first_on"><em class="blind">'+gridStartTxt+'</em></a> ');
	}else{
		txt.push('<a class="first"><em class="blind">'+gridStartTxt+'</em></a> ');
	}
	
	if(currGroup > 1){
		txt.push('<a href="javascript:fn_search(' + (startPage - pgGroupSize) + ');" class="prev_on"><em class="blind">'+gridPrevTxt+'</em></a> ');
	}else{
		txt.push('<a class="prev"><em class="blind">'+gridPrevTxt+'</em></a> ');
	}
	$("#pagePre").html(txt.join("").toString());
	
	txt = new Array();
	for(var i=startPage; i<= endPage; i++){
		if(i == currentPage){
			txt.push('<strong class="pagingCurrent">' + i + '</strong> ');
		}else{
			txt.push('<a href="javascript:fn_search(' + i + ');">' + i + '</a> ');
		}
	}
	$("#pageNum").html(txt.join("").toString());
	
	txt = new Array();
	if(currGroup < totGroup){
		txt.push('<a href="javascript:fn_search(' + (startPage + pgGroupSize) + ');" class="next_on"><em class="blind">'+gridNextTxt+'</em></a> ');
	}else{
		txt.push('<a class="next"><em class="blind">'+gridNextTxt+'</em></a> ');
	}
	
	if(currentPage < totalPage){
		txt.push('<a href="javascript:fn_search(' + totalPage + ');" class="last_on"><em class="blind">'+gridEndTxt+'</em></a> ');
	}else{
		txt.push('<a class="last"><em class="blind">'+gridEndTxt+'</em></a>');
	}
	$("#pageNext").html(txt.join("").toString());
	
}

//선택 주소 리턴
function fn_setRtnValue(zipCd, addr){
	
	if($("#pagedata").val() != ''){
		$(window.frames[$("#pagedata").val()].document).find('#PNO').val(zipCd);
		$(window.frames[$("#pagedata").val()].document).find('#ADDR1').val(addr);
	}else{
		//레이어팝업을 호출한 페이지 펑션
		zipCdSet(zipCd, addr);
	}
		
	fn_close();
}

//취소, 닫기
function fn_close(){
	$('[layer="close"]').trigger('click');
}

// -->
</script>
<style type="text/css">
	.paging { text-align:center; font-family:verdana; font-size:12px; width:100%; padding:15px 0px 15px 0px; }
	.paging a { color:#797674; text-decoration:none; border:1px solid #e0e0e0; background-color:#f6f4f4; padding:3px 5px 3px 5px;}
	.paging a:link { color:#797674; text-decoration:none; }
	.paging a:visited { color:#797674; text-decoration:none; }
	.paging a:hover { text-decoration:none; border:1px solid #7a8ba2; text-decoration:none; }
	.paging a:active { text-decoration:none; }
	.pagingMove { font-weight:bold; }
	.pagingDisable { font-weight:bold; color:#cccccc; border:1px solid #e0e0e0; background-color:#f6f4f4; padding:3px 5px 3px 5px;}
	.pagingCurrent { font-weight:bold; color:#ffffff; border:1px solid #2f3d64; background-color:#2f3d64; padding:3px 5px 3px 5px;}
</style>	

</head>
<body>
<input type="hidden" id="pagedata"/>
<div class="layer_popup" style="width:1024px;">
    <div class="layer_head">
        <h1 class="layer_title">우편번호검색</h1>
        <button type="button" class="layer_close" layer="close">팝업닫기</button>
    </div>
	<div id="layer_body" style="height:801px; padding:30px; overflow-y:scroll;">
		<form name="frmMenu" id="frmMenu" method="post" onsubmit="fn_search(1);return false;">
		<div class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit">지역명</div>
					</div>
					<div class="col">
						<div>
							<input type="text" name="keyword" id="keyword" maxlength="50" style="width:200px;" />
						</div>
					</div>
					<div class="col">
						<div class="btn34 c2" id="UR" style="width:100px"><a href="javascript:fn_search(1);" >검색</a></div>
					</div>
				</div>
			</div>

			<div class="h4group mt10">
				<h3 class="tit" style="color: #222222;">해당하는 우편번호/지역명을 선택해 주세요.</h3>
			</div>

				<div class="secwrap">
					<div class="boxarea">
						<div class="list_tbl head">
							<table>
								<colgroup>
									<col width="15%">
									<col width="85%">
								</colgroup>
								<thead>
									<tr>
										<th rowspan="1">우편번호</th>
										<th rowspan="1">지역명</th>
									</tr>
								</thead>
							</table>
						</div>
						<div class="list_tbl body">
							<table>
								<colgroup>
									<col width="15%">
									<col width="85%">
								</colgroup>
								<tbody id="list">
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
									<tr><td></td><td></td></tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				
				<div class="paging">
					<span class="pageBtn" id="pagePre">
					</span>
					<span class="num" id="pageNum">
					</span>
					<span class="pageBtn" id="pageNext">
					</span>
				</div>
				
		</div>	<!-- //pop contents -->
		</form>
		
		<section class="btnwrap" >
			<div class="fl_r" id="BR" style="padding:0 15px 0 15px">
				<button type="button" class="btn36 c4" style="width: 100px;" onclick="fn_close()">닫기</button>
			</div>
		</section>
	</div>	
</div>
</body>
</html>

