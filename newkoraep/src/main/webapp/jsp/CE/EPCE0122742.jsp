<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>기준보증금변경</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
     
     var toDay = kora.common.gfn_toDay();  // 현재 시간
     var INQ_PARAMS;
     var  flag = false;
     
	$(function() {
		
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		
		//버튼 셋팅
		fn_btnSetting();
		
         //날짜 셋팅
		$('#START_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true,
			dateSetting : INQ_PARAMS.PARAMS.APLC_ST_DT
		});
		$('#END_DT').YJcalendar({
			fromName : 'from',
			triggerBtn : true,
			dateSetting : INQ_PARAMS.PARAMS.APLC_END_DT
		});
		
         //value 값 넣기            
	     $("#CTNR_CD").val(INQ_PARAMS.PARAMS.CTNR_CD);
	     $("#CTNR_NM").val(INQ_PARAMS.PARAMS.CTNR_NM);
	     $("#STD_DPS").val(INQ_PARAMS.PARAMS.STD_DPS);
	     $("#PSBL_ST_DPS").val(INQ_PARAMS.PARAMS.PSBL_ST_DPS);
	     $("#PSBL_END_DPS").val(INQ_PARAMS.PARAMS.PSBL_END_DPS);
	     $("#START_DT").val(INQ_PARAMS.PARAMS.APLC_ST_DT);
		 $("#END_DT").val(INQ_PARAMS.PARAMS.APLC_END_DT);
		 
		 var start_dt	= $("#START_DT").val();
		 var end_dt		= $("#END_DT").val();
			  start_dt	=  start_dt.replace(/-/gi, "");
			  end_dt		=  end_dt.replace(/-/gi, "");
		 if(start_dt.length == 8)	 start_dt	= kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
		 if(end_dt.length	== 8)	 end_dt	= kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
	     $("#START_DT").val(start_dt) 
	     $("#END_DT").val(end_dt)
	     
	     if(INQ_PARAMS.PARAMS.APLC_ST_DT <= toDay){
			 $("#calendar_start *").prop("disabled",true);
			 $("#STD_DPS").prop("disabled",true);
			 flag = true;
		 } 
		
	    //text값 넣기
		$("#title_sub").text('<c:out value="${titleSub}" />');									//타이틀
		$('#ctnr_cd').text(parent.fn_text('ctnr_cd'));						//용기코드
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));					//빈용기명
		$('#std_dps').text(parent.fn_text('std_dps'));					//기준보증금
		$('#psbl_st_dps').text(parent.fn_text('psbl_st_dps'));			//조정 가능 최저 보증금
		$('#psbl_end_dps').text(parent.fn_text('psbl_end_dps'));	//조정 가능 최고 보증금
		$('#aplc_dt').text(parent.fn_text('aplc_dt'));						//적용기간
		
		 //div필수값 alt
		 $("#STD_DPS").attr('alt',parent.fn_text('std_dps'));					//기준보증금
		 $("#PSBL_ST_DPS").attr('alt',parent.fn_text('psbl_st_dps'));   		//최저 보증금    
		 $("#PSBL_END_DPS").attr('alt',parent.fn_text('psbl_end_dps'));	//최고 보증금
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
	
	//초기화
	function fn_init(){
		
		 $("#STD_DPS").val("");
		 $("#PSBL_ST_DPS").val("");
		 $("#PSBL_END_DPS").val("");
		 $("#START_DT").val("");
		 $("#END_DT").val("");
	}
	
	//저장
	function fn_reg(){
		
		    var url = "/CE/EPCE0122742_21.do";
	     	var start_dt  = $("#START_DT").val();
			var end_dt    = $("#END_DT").val();
	        var input ={};
			 start_dt   =  start_dt.replace(/-/gi, "");
		     end_dt    =  end_dt.replace(/-/gi, "");
			
			//필수입력값 체크
			if (!kora.common.cfrmDivChkValid("divInput")) {
				return;
			//날짜 정합성 체크. 20160204
			}else if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			// 종료일이 시작일 보다 작을때 
			}else if(start_dt>end_dt){
				alertMsg(parent.fn_text("date_chk")); 
				return;
			}else if(Number($("#STD_DPS").val()) < Number($("#PSBL_ST_DPS").val())  ) {
				alertMsg(parent.fn_text("psbl_st_chk"));
				return 
			}else if(Number($("#STD_DPS").val()) >Number($("#PSBL_END_DPS").val()) ) {
				alertMsg(parent.fn_text("psbl_end_chk"));
				return 
			}else if(Number($("#PSBL_ST_DPS").val()) >Number($("#PSBL_END_DPS").val()) ) {
				alertMsg(parent.fn_text("psbl_st_end_chk"));  
				return 
			}else if(flag){
				if( $("#STD_DPS").val() !=INQ_PARAMS.PARAMS.STD_DPS 
						|| $("#START_DT").val().replace(/-/gi, "") !=INQ_PARAMS.PARAMS.APLC_ST_DT){
						alertMsg("변조된 데이터 입니다.");				
						return;
					}
				}
			
			input["CTNR_CD"]				= $("#CTNR_CD").val();        	//용기코드
			input["CTNR_NM"]			= $("#CTNR_NM").val();      	//빈용기명
			input["STD_DPS"]				= $("#STD_DPS").val();         	// 기준보증금
			input["PSBL_ST_DPS"]		= $("#PSBL_ST_DPS").val();		//조정 가능 최저 보증금
			input["PSBL_END_DPS"]		= $("#PSBL_END_DPS").val();  //조정 가능 최고 보증금
			input["START_DT"]			= $("#START_DT").val();			//시작날짜
			input["END_DT"]				= $("#END_DT").val();			//끝날짜
			input["LANG_SE_CD"]		= INQ_PARAMS.PARAMS.LANG_SE_CD //언어코드
			input["REG_SN"]				= INQ_PARAMS.PARAMS.REG_SN		//등록순번
			input["BTN_SE_CD"]			= "IS"													//버튼코드
			input["SAVE_CHK"]			= "U";      
			
		 	 ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD =="A005"){ //적용기간 중복일경우
						alertMsg(rtnData.RSLT_MSG);
					}else if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG);
						  fn_cnl();
	  					//fn_init(); //입력창 초기화
					}
				} else {
					alertMsg("error");
				}
			});   
		
		
	}

/****************************************** 그리드 셋팅 끝***************************************** */


</script>
<style type="text/css">
	.row .tit{width: 126px;}
</style>


</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>

    <div class="iframe_inner">
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
			</div>

		<section class="secwrap">
			<div class="srcharea" id="divInput">
				<div class="row">
						<div class="col" >
				                <div class="write_head">
									<div class="tit"  id="ctnr_cd" style=""></div>  <!-- 용기코드 -->
									<div class="box">
										<input type="text" style="width: 179px; border: 0" id="CTNR_CD"  readonly="readonly" value="테스트">
									</div>
								</div>
						</div>
						<div class="col">
				                <div class="write_head">
									<div class="tit"  id="ctnr_nm" style=""></div>  <!-- 빈용기명-->
									<div class="box">
										<input type="text" style="border: 0 ; width: 400px" id="CTNR_NM" readonly="readonly"  value="테스트">
									</div>
								</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
					<div class="col">
						<div class="tit" id="aplc_dt" ></div> <!-- 적용기간 -->
						<div class="box">
							<div class="calendar" id="calendar_start">
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
					<div class="col" >
						<div class="tit" id="std_dps"></div>	<!-- 기준보증금 -->
						<div class="box">
							<input type="text" id="STD_DPS" maxlength="8" 	format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="psbl_st_dps"></div>	<!-- 조정 가능 최저 보증금 -->
						<div class="box">
							<input type="text" id="PSBL_ST_DPS" maxlength="8"  format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="psbl_end_dps"></div>	<!-- 조정 가능 최고 보증금 -->
						<div class="box">
							<input type="text" id="PSBL_END_DPS" maxlength="8" 	format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
				
				</div>	<!-- end of row -->
				
		</div>  <!-- end of srcharea -->
		<div class="h4group" >
					<h5 class="tit"  style="font-size: 15px;color: red; padding-left: 10px">※시작일이 오늘 이전인 내역인 경우 종료일자 및 조정 가능 금액 항목만 변경 가능합니다</h5>
		 </div>
	</section> <!-- end of secwrap -->
      
 <section class="btnwrap mt20"  style="height:130px" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
 
</div>

</body>
</html>