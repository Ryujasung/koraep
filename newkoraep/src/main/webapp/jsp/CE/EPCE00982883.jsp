<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의하기 FAQ 상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="_csrf" content="<c:out value='${_csrf.token}' />" />	
<meta name="_csrf_header" content="<c:out value='${_csrf.headerName}' />" />

<link rel="stylesheet" href="/common/css/slick.css">
<link rel="stylesheet" href="/common/css/common.css">
<link rel="stylesheet" href="/common/css/reset.css">

<!-- 페이징 관련 스타일 -->
<style type="text/css">
	.gridPaging { text-align:center; font-family:verdana; font-size:12px; width:100%; padding:15px 0px 15px 0px; }
	.gridPaging a { color:#797674; text-decoration:none; border:1px solid #e0e0e0; background-color:#f6f4f4; padding:3px 5px 3px 5px;}
	.gridPaging a:link { color:#797674; text-decoration:none; }
	.gridPaging a:visited { color:#797674; text-decoration:none; }
	.gridPaging a:hover { text-decoration:none; border:1px solid #7a8ba2; text-decoration:none; }
	.gridPaging a:active { text-decoration:none; }
	.gridPagingMove { font-weight:bold; }
	.gridPagingDisable { font-weight:bold; color:#cccccc; border:1px solid #e0e0e0; background-color:#f6f4f4; padding:3px 5px 3px 5px;}
	.gridPagingCurrent { font-weight:bold; color:#ffffff; border:1px solid #2f3d64; background-color:#2f3d64; padding:3px 5px 3px 5px;}
</style>

<link rel="stylesheet" type="text/css" href="/rMateGrid/rMateGridH5/Assets/rMateH5.css"/>
<script type="text/javascript" src="/rMateGrid/LicenseKey/rMateGridH5License.js"></script>	<!-- rMateGridH5 라이센스 -->
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/rMateGridH5.js"></script>		<!-- rMateGridH5 라이브러리 -->
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/jszip.min.js"></script>


<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/jquery/jquery.ui.datepicker-ko.js"></script>

<script src="/common/js/jquery-1.11.1.min.js"></script>
<script src="/common/js/mobile-detect.min.js"></script>
<script src="/common/js/slick.js"></script>
<script src="/common/js/pub.plugin.js"></script>
<script src="/common/js/pub.common.js"></script>
<script src="/js/kora/kora_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

var jParams;
var notiInfo;
var preNoti;
var nextNoti;
var fileList;

$(document).ready(function(){
	
	jParams = jsonObject($('#INQ_PARAMS').val());
	notiInfo 	= jsonObject($('#notiInfo').val());
	preNoti 	= jsonObject($('#preNoti').val());
	nextNoti = jsonObject($('#nextNoti').val());
	fileList 	= jsonObject($('#fileList').val());
	
	/************************************
	 * 목록 버튼 클릭 이벤트
	 ***********************************/
	 $("#btn_lst").click(function(){
		 fn_lst();
		});
	
	
	fn_init();		//초기 값
});
	//초기 셋팅
	function fn_init(){
		
		document.getElementById("sbj").innerHTML 	= notiInfo[0].SBJ;
		document.getElementById("dttm").innerHTML 	= notiInfo[0].REG_DTTM;
		document.getElementById("cntn").innerHTML 	= notiInfo[0].CNTN;
		
		if("" != preNoti){
			document.getElementById("pre_noti").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+preNoti[0].FAQ_SEQ+")'>"+preNoti[0].SBJ+"</a>";
		}
		if("" != nextNoti){
			document.getElementById("next_noti").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+nextNoti[0].FAQ_SEQ+")'>"+nextNoti[0].SBJ+"</a>";
		}
	
		if(""==fileList){
			$("#fileChk").hide();
		} else {
			for(var i=0;i<fileList.length;i++){
				$("#files").append("<li><a href='javascript:fn_dwnd(\""+fileList[i].SAVE_FILE_NM+"\", \""+fileList[i].FILE_NM+"\")'><span class='down_btn'></span>"+fileList[i].FILE_NM+"</a></li>");
			}
		}
		
	}
 	 
 	//파일다운로드
 	function fn_dwnd(fName, sName){ //fn_down
 		frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
 		frm.fileName.value = fName;
 		frm.saveFileName.value = sName;
 		frm.submit();
 	}

 	//상세조회링크
 	function fn_dtl_sel_lk(faq_seq){
 	
 		var url ="/EP/EPCE00982883_19.do";
		var input ={};
		input["FAQ_SEQ"] =faq_seq;
	 	 ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {   
					notiInfo 		= rtnData.notiInfo;  
					preNoti 		=  rtnData.preNoti; 
					nextNoti 	= rtnData.nextNoti;
					fileList 		= rtnData.fileList; 
				}else{
						 alertMsg("error");
				}
		},false);

		document.getElementById("sbj").innerHTML 	= notiInfo[0].SBJ;
		document.getElementById("dttm").innerHTML 	= notiInfo[0].REG_DTTM;
		document.getElementById("cntn").innerHTML 	= notiInfo[0].CNTN;
		
		if("" != preNoti){
			document.getElementById("pre_noti").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+preNoti[0].FAQ_SEQ+")'>"+preNoti[0].SBJ+"</a>";
		}
		if("" != nextNoti){
			document.getElementById("next_noti").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+nextNoti[0].FAQ_SEQ+")'>"+nextNoti[0].SBJ+"</a>";
		}
		$("#files").empty();
		if(""==fileList){
			$("#fileChk").hide();
		} else {
			for(var i=0;i<fileList.length;i++){
				$("#files").append("<li><a href='javascript:fn_dwnd(\""+fileList[i].SAVE_FILE_NM+"\", \""+fileList[i].FILE_NM+"\")'><span class='down_btn'></span>"+fileList[i].FILE_NM+"</a></li>");
			}
		}
 	};
 	
 	//돌아가기 
 	function fn_lst(){
		kora.common.goPageB('', jParams);
 	}

</script>
<style type="text/css">

</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="notiInfo" value="<c:out value='${notiInfo}' />"/>
<input type="hidden" id="preNoti" value="<c:out value='${preNoti}' />"/>
<input type="hidden" id="nextNoti" value="<c:out value='${nextNoti}' />"/>
<input type="hidden" id="fileList" value="<c:out value='${fileList}' />"/>

	<div class="layer_popup" style="width: 820px;">
		<div class="layer_head">
			<h1 class="layer_title">문의하기</h1>
			<button type="button" class="layer_close" layer="close">팝업닫기</button>
		</div>
		<div class="layer_body">
			<div class="secwrap">
				<div class="infobox">
					<div class="inner">
						<div class="call">
							<span class="color1">지급관리 시스템 콜센터</span>1522 - 0082
						</div>
						<div class="time">
							<strong>운영시간 : 평일(월~금) 9시~18시</strong><br> 토,일요일과 공휴일은 운영하지
							않습니다.
						</div>
					</div>
				</div>
			</div>
			<div class="secwrap mt30">
				<div class="tablist">
					<ul>
						<li ><a style="cursor: pointer;">공지사항</a></li>
						<li class="on"><a style="cursor: pointer;">FAQ</a></li>
					</ul>
					<div class="btnbox">
						<a class="btn36 c11" style="width: 100px;"
							href="https://113366.com/cosmoor/">원격지원요청</a>
					</div>
				</div>
				<div class="tabcont mt25">
					<div>
						<div class="titbox">FAQ</div>
							<section class="secwrap">
									<div class="viewarea">
										<div class="view_head">
											<div class="tit"><p id="sbj"></p></div>
											<div class="day"><p class="date" id="dttm"></p></div>
										</div>
										<div class="atch_box" id="fileChk">
											<div class="tit" id="atch_file" style="width:87px"></div>
											<ul class="filebox" >
												<li id="files"><a href="#self"></a></li>
											</ul>
										</div>
										<div class="view_body"  >
											<p id="cntn" style="height: 300px; overflow: auto;" ></p>
										</div>
										<div class="view_navi">
											<div class="prev">
												<div class="tit" id="bf_doc"></div>
												<span class="txt" id="pre_noti">이전 글이 없습니다.</span>
											</div>
											<div class="next">
												<div class="tit" id="nx_doc"></div>
												<span class="txt" id="next_noti">다음 글이 없습니다.</span>
											</div>
										</div>
										 <div class="btnwrap">
											<div class="fl_r" id="BR">
											<button type="button" class="btn36 c5" style="width: 100px;" id="btn_lst">목록</button>
								      		 </div>
							      		 </div>
									</div>
							</section>
							<form name="frm" action="/jsp/file_down.jsp" method="post">
									<input type="hidden" name="fileName" value="" />
									<input type="hidden" name="saveFileName" value="" />
									<input type="hidden" name="downDiv" value="noti" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
							</form>
					</div>
				</div>
			</div>
		</div><!-- end of layer_body -->
	</div>
</body>
</html>