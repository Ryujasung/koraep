<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수보증금등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
     
     var toDay = kora.common.gfn_toDay();  // 현재 시간
     var INQ_PARAMS;
     var initList;
	$(function() {
		
		INQ_PARAMS	 = jsonObject($('#INQ_PARAMS').val());
	    initList			 = jsonObject($('#initList').val());
		
		//버튼 셋팅
		fn_btnSetting();
		//날짜 셋팅
	    $('#START_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true,
			dateSetting : initList[0].APLC_ST_DT.replaceAll('-','')
		});
		$('#END_DT').YJcalendar({
			fromName : 'from',
			triggerBtn : true,
			dateSetting : initList[0].APLC_END_DT.replaceAll('-','')
		});

		$("#START_DT").val(initList[0].APLC_ST_DT);
		$("#END_DT").val(initList[0].APLC_END_DT);
		
        //value값 넣기		
		$("#RTRVL_CTNR_CD").val(INQ_PARAMS.PARAMS.RTRVL_CTNR_CD);
		$("#CTNR_NM").val(INQ_PARAMS.PARAMS.CTNR_NM);
		
		//text값 넣기
		$("#title_sub").text('<c:out value="${titleSub}" />');									//타이틀
		$('#rtrvl_ctnr_cd').text(parent.fn_text('rtrvl_ctnr_cd'));		//용기코드
		$('#rtrvl_ctnr_nm').text(parent.fn_text('rtrvl_ctnr_nm'));		//용기명
		$('#rtrvl_dps').text(parent.fn_text('rtrvl_dps'));					//회수보증금
		$('#aplc_dt').text(parent.fn_text('aplc_dt'));						//적용기간
		
		
		 //div필수값 alt
		 $("#RTRVL_DPS").attr('alt',parent.fn_text('rtrvl_dps'));				//회수보증금
		 $("#START_DT").attr('alt',parent.fn_text('aplc_dt'));					//적용기간
		 $("#END_DT").attr('alt',parent.fn_text('aplc_dt'));						//적용기간
		
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#START_DT").click(function(){
			    var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#START_DT").val(start_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#START_DT").change(function(){
		     var start_dt = $("#START_DT").val();
		     start_dt   =  start_dt.replace(/-/gi, "");
			if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
		     $("#START_DT").val(start_dt) 
		});
		
		/************************************
		 * 끝날짜  클릭시 - 삭제  변경 이벤트
		 ***********************************/
		$("#END_DT").click(function(){
			    var end_dt = $("#END_DT").val();
			         end_dt  = end_dt.replace(/-/gi, "");
			     $("#END_DT").val(end_dt)
		});
		
		/************************************
		 * 끝날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#END_DT").change(function(){
		     var end_dt  = $("#END_DT").val();
		           end_dt =  end_dt.replace(/-/gi, "");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
		     $("#END_DT").val(end_dt) 
		});
		 
		/************************************
		 * 저장버튼 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		/************************************
		 * 취소버튼 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
					
	});
     
     //취소버튼 이전화면으로
     function fn_cnl(){
    	 kora.common.goPageB('', INQ_PARAMS);
     }
	
	//저장
	function fn_reg(){
		
		var url = "/CE/EPCE0198231_09.do";
     	var start_dt  = $("#START_DT").val();
		var end_dt    = $("#END_DT").val();
        var input ={};
         start_dt   =  start_dt.replace(/-/gi, "");
	     end_dt    =  end_dt.replace(/-/gi, "");
		
		//필수입력값 체크
		if (!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}else if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ //날짜 정합성 체크. 20160204
			alertMsg(parent.fn_text("date_chk"));
			return; 
		}else if(start_dt>end_dt){// 종료일이 시작일 보다 작을때 
			alertMsg(parent.fn_text("date_chk")); 
			return;
		}
		input["RTRVL_CTNR_CD"]  = $("#RTRVL_CTNR_CD").val();	 //용기코드
		input["CTNR_NM"]           = $("#CTNR_NM").val();      	 	//용기명
		input["RTRVL_DPS"]			= $("#RTRVL_DPS").val();			// 회수보증금
		input["START_DT"]			= $("#START_DT").val();				//시작날짜
		input["END_DT"]				= $("#END_DT").val();				//끝날짜
		input["LANG_SE_CD"]		= INQ_PARAMS.PARAMS.LANG_SE_CD //언어코드
		input["SAVE_CHK"]			= "S";
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == "0000"){
						alertMsg(rtnData.RSLT_MSG);
						fn_cnl();
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
			} else {
				alertMsg("error");
			}
		});  
		
	}

/****************************************** 그리드 셋팅 끝***************************************** */

</script>
<style type="text/css">

.secwrap .srcharea .row .col .tit{
width: 82px;
}
</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="initList" value="<c:out value='${initList}' />"/>

    <div class="iframe_inner">
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
			</div>
			<section class="secwrap">
				<div class="srcharea" id="divInput">
					<div class="row">
							<div class="col"   >
					                <div class="write_head">
										<div class="tit"  id="rtrvl_ctnr_cd" style=""></div>  <!-- 용기코드 -->
										<div class="box">
											<input type="text" style="width: 179px; border: 0" id="RTRVL_CTNR_CD"  readonly="readonly" >
										</div>
									</div>
							</div>
							<div class="col">
					                <div class="write_head">
										<div class="tit"  id="rtrvl_ctnr_nm" style=""></div>  <!-- 용기명-->
										<div class="box">
											<input type="text" style="width: 400px; border: 0 " id="CTNR_NM" readonly="readonly"  >
										</div>
									</div>
							</div>
						</div> <!-- end of row -->
							<div class="row">
						<div class="col">
							<div class="tit" id="aplc_dt" style=""></div> <!-- 적용기간 -->
							<div class="box">
								<div class="calendar">
									<input type="text" id="START_DT" name="from"		style="width: 180px;" class="i_notnull" > <!--시작날짜  -->
								</div>
								<div class="obj">~</div>
								<div class="calendar">
									<input type="text" id="END_DT" name="to" style="width: 180px;"	class="i_notnull" >   <!-- 끝날짜 -->
								</div>
							</div>
						</div>
					</div>	<!-- end of row -->
					<div class="row">
						<div class="col">
							<div class="tit" id="rtrvl_dps"></div>	<!-- 회수보증금 -->
							<div class="box">
								<input type="text" id="RTRVL_DPS" maxlength="8" format="number"	style="width: 179px" class="i_notnull" />
							</div>
						</div>
					</div>	<!-- end of row -->
			</div>  <!-- end of srcharea -->
		</section> <!-- end of secwrap -->
 		<section class="btnwrap mt20"  style="height:130px" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
   </div>
</body>
</html>