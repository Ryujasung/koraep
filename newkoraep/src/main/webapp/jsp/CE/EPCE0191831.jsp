<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>기준취급수수료등록</title>
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
			dateSetting:initList[0].APLC_ST_DT.replaceAll('-','')
		});
		$('#END_DT').YJcalendar({
			fromName : 'from',
			triggerBtn : true,
			dateSetting:initList[0].APLC_END_DT.replaceAll('-','')
		});
		
		
        //value값 넣기		
		$("#CTNR_CD").val(INQ_PARAMS.PARAMS.CTNR_CD);				//용기코드
		$("#CTNR_NM").val(INQ_PARAMS.PARAMS.CTNR_NM);			//빈용기명
		$("#START_DT").val(initList[0].APLC_ST_DT);									//적용기간 시작날짜
		$("#END_DT").val(initList[0].APLC_END_DT);							  		//적용기간 끝날짜
		
		//text값 넣기
		$("#title_sub").text('<c:out value="${titleSub}" />');													//타이틀
		$('#ctnr_cd').text(parent.fn_text('ctnr_cd'));										//용기코드
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));									//빈용기명
		$('#std_fee').text(parent.fn_text('std_fee'));										//기준취급수수료
		$('#psbl_st_fee').text(parent.fn_text('psbl_st_fee'));							//조정 가능 최저 기준취급수수료
		$('#psbl_end_fee').text(parent.fn_text('psbl_end_fee'));						//조정 가능 최고 기준취급수수료
		$('#std_whsl_fee').text(parent.fn_text('std_whsl_fee'));						//기준도매수수료
		$('#psbl_st_whsl_fee').text(parent.fn_text('psbl_st_whsl_fee'));			//조정 가능 최저 기준도매수수료
		$('#psbl_end_whsl_fee').text(parent.fn_text('psbl_end_whsl_fee'));		//조정 가능 최고 기준도매수수료
		$('#std_rtl_fee').text(parent.fn_text('std_rtl_fee'));								//기준소매수수료
		$('#psbl_st_rtl_fee').text(parent.fn_text('psbl_st_rtl_fee'));					//조정 가능 최저 기준소매수수료
		$('#psbl_end_rtl_fee').text(parent.fn_text('psbl_end_rtl_fee'));				//조정 가능 최고 기준소매수수료
		$('#aplc_dt').text(parent.fn_text('aplc_dt'));										//적용기간
		
		 //div필수값 alt
		 $("#STD_FEE").attr('alt',parent.fn_text('std_fee'));								//기준취습수수료
		 $("#PSBL_ST_FEE").attr('alt',parent.fn_text('psbl_st_fee'));   				//최저 기준취습수수료    
		 $("#PSBL_END_FEE").attr('alt',parent.fn_text('psbl_end_fee'));			//최고 기준취습수수료
		 $("#STD_WHSL_FEE").attr('alt',parent.fn_text('std_whsl_fee'));		    //기준도매수수료
		 $("#PSBL_ST_WHSL_FEE").attr('alt',parent.fn_text('psbl_st_whsl_fee')); //최저 기준도매수수료    
		 $("#PSBL_END_WHSL_FEE").attr('alt',parent.fn_text('psbl_end_dps'));	//최고 기준도매수수료
		 $("#STD_RTL_FEE").attr('alt',parent.fn_text('std_rtl_fee'));		    		//기준소매수수료
		 $("#PSBL_ST_RTL_FEE").attr('alt',parent.fn_text('psbl_st_rtl_fee'));   	//최저 기준소매수수료    
		 $("#PSBL_END_RTL_FEE").attr('alt',parent.fn_text('psbl_end_rtl_fee'));	//최고 기준소매수수료
		 $("#START_DT").attr('alt',parent.fn_text('aplc_dt'));							//적용기간 시작 날짜
		 $("#END_DT").attr('alt',parent.fn_text('aplc_dt'));								//적용기간 끝 날짜
		
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
		 * 저장버튼 클릭 이벤트
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

	}
	//수수료 유효성 체크
	function fn_validChk(){
		var std_fee					= Number($("#STD_FEE").val());                   			//기준취급수수료    
		var psbl_st_fee   			= Number($("#PSBL_ST_FEE").val());	   	        			//조정 가능 최저 기준취급수수료   
		var psbl_end_fee     	= Number($("#PSBL_END_FEE").val());  	           		//조정 가능 최고 기준취급수수료   
		var std_whsl_fee     		= Number($("#STD_WHSL_FEE").val());  	       			//기준도매수수료                
		var psbl_st_whsl_fee    = Number($("#PSBL_ST_WHSL_FEE").val());	 	       	//조정 가능 최저 기준도매수수료               
		var psbl_end_whsl_fee = Number($("#PSBL_END_WHSL_FEE").val());     	    //조정 가능 최고 기준도매수수료               
		var std_rtl_fee     		= Number($("#STD_RTL_FEE").val());                   	    //기준소매수수             
		var psbl_st_rtl_fee    	= Number($("#PSBL_ST_RTL_FEE").val());                  	//최저 기준소매수수료         
		var psbl_end_rtl_fee    	= Number($("#PSBL_END_RTL_FEE").val());              	//최고 기준소매수수료                 
		
		if(std_fee < psbl_st_fee ) {
			alertMsg("기준취급수수료 보다 가능 최소수수료가 큽니다.");
			$("#PSBL_ST_FEE").focus();
			return false;
			
		} else if(std_fee > psbl_end_fee)	{		
				alertMsg("기준취급수수료 보다 가능 최대수수료가 작습니다.");
				$("#PSBL_END_FEE").focus();
				return false;
				
		} else if(std_whsl_fee < psbl_st_whsl_fee)	{	
				alertMsg("기준도매수수료 보다 가능 최소 도매 수수료가 큽니다.");
				$("#PSBL_ST_WHSL_FEE").focus();
				return false;
				
		} else if(std_whsl_fee > psbl_end_whsl_fee){ 
		    	alertMsg("기준도매수수료 보다 가능 최대 도매 수수료가 작습니다.");
		    	$("#PSBL_END_WHSL_FEE").focus();
		    	return false;
		    	
		} else if(std_rtl_fee <psbl_st_rtl_fee) 	{	
				alertMsg("기준소매수수료 보다 가능 최소 소매 수수료가 큽니다.");
				$("#PSBL_ST_RTL_FEE").focus();
				return false;
				
		} else if(std_rtl_fee > psbl_end_rtl_fee) {	
				alertMsg("기준소매수수료 보다 가능 최대 소매 수수료가 작습니다.");
				$("#PSBL_END_RTL_FEE").focus();
				return false;
				
		} else if(psbl_st_fee>psbl_st_whsl_fee)  {    
		    	alertMsg("가능 최소 도매수수료가 가능 최소 수수료보다 작으면 안됩니다.");
		    	$("#PSBL_ST_WHSL_FEE").focus();
		    	return false;
		    	
		} else if(psbl_st_fee>psbl_st_rtl_fee)   	{	
		    	alertMsg("가능 최소 소매수수료가 가능 최소 수수료보다 작으면 안됩니다.");
		    	$("#PSBL_ST_RTL_FEE").focus();
		    	return false;
		    	
		} else if(std_fee < std_whsl_fee +std_rtl_fee){
				alertMsg("기준도매수수료+기준소매수수료가 기준취급수수료보다 높습니다.");
				$("#STD_WHSL_FEE").focus();
				return false;
				
		} else if(  std_whsl_fee > psbl_end_fee  || std_whsl_fee < psbl_st_fee ){
				alertMsg("기준도매수수료가  가능 최소수수료보다 작거나  가능 최대수수료 보다 높습니다.");
				return false;
				
		} else if(  std_whsl_fee > psbl_end_fee  || std_whsl_fee < psbl_st_fee ){
				alertMsg("기준소매수수료가  가능 최소수수료보다 작거나  가능 최대수수료 보다 높습니다.");
				return false;
		}else{
				return true;
		}
	    
	}
	//저장
	function fn_reg(){
		
		var url = "/CE/EPCE0191831_09.do";
     	var start_dt  = $("#START_DT").val();
		var end_dt    = $("#END_DT").val();
        var input ={};
         start_dt   =  start_dt.replace(/-/gi, "");
	     end_dt    =  end_dt.replace(/-/gi, "");
		
		//필수입력값 체크
		if (!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		//날짜 정합성 체크. 20160204
		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg(parent.fn_text("date_chk")); 
			return; 
		}
		
/* 		//현재 날짜 보다 작을경우 
	    if(toDay>start_dt){
	    	alertMsg(parent.fn_text("date_chk")); 
	    	return
	    }
		 */
		// 종료일이 시작일 보다 작을때 
		if(start_dt>end_dt){
			alertMsg(parent.fn_text("date_chk")); 
			return;
		} 
		//수수료 유효성 체크
		if(fn_validChk() == false){
			return
		}
		input["CTNR_CD"]						= $("#CTNR_CD").val();        						//용기코드
		input["CTNR_NM"]					= $("#CTNR_NM").val();      						//빈용기명
		input["STD_FEE"]						= $("#STD_FEE").val();      							//기준취급수수료          
		input["PSBL_ST_FEE"]				= $("#PSBL_ST_FEE").val();	   						//조정 가능 최저 기준취급수수료   
		input["PSBL_END_FEE"]				= $("#PSBL_END_FEE").val();  						//조정 가능 최고 기준취급수수료      
		input["STD_WHSL_FEE"]				= $("#STD_WHSL_FEE").val();  					//기준도매수수료     
		input["PSBL_ST_WHSL_FEE"]		= $("#PSBL_ST_WHSL_FEE").val();	 			//조정 가능 최저 기준도매수수료
		input["PSBL_END_WHSL_FEE"]	= $("#PSBL_END_WHSL_FEE").val();     			//조정 가능 최고 기준도매수수료    
		input["STD_RTL_FEE"]				= $("#STD_RTL_FEE").val();          	    		//기준소매수수
		input["PSBL_ST_RTL_FEE"]			= $("#PSBL_ST_RTL_FEE").val();      				//최저 기준소매수수료
		input["PSBL_END_RTL_FEE"]		= $("#PSBL_END_RTL_FEE").val();         		//최고 기준소매수수료    
		input["START_DT"]					= $("#START_DT").val();								//시작날짜
		input["END_DT"]						= $("#END_DT").val();								//끝날짜
		input["LANG_SE_CD"]				= INQ_PARAMS.PARAMS.LANG_SE_CD		//언어코드
		input["BTN_SE_CD"]					= "IS"													//버튼코드
		input["SAVE_CHK"]		    		= "S";
	
		 ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
			
				if(rtnData.RSLT_CD =="A005"){ //적용기간 중복일경우
					alertMsg(rtnData.RSLT_MSG);
				}else if(rtnData.RSLT_CD =="0000"){
					alertMsg(rtnData.RSLT_MSG);
					fn_cnl();
  					//fn_init(); 
				}
			} else {
				alertMsg("error");
			}
		});  
		
		
	}


/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .tit {
width: 120px;
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
						<div class="col"  >
				                <div class="write_head">
									<div class="tit"  id="ctnr_cd" ></div>  <!-- 용기코드 -->
									<div class="box">
										<input type="text" style="width: 179px; border: 0" id="CTNR_CD"  readonly="readonly" >
									</div>
								</div>
						</div>
						<div class="col" >
				                <div class="write_head">
									<div class="tit"  id="ctnr_nm" style="width: 116px; "></div>  <!-- 빈용기명-->
									<div class="box">
										<input type="text" style="width: 400px; border: 0 " id="CTNR_NM" readonly="readonly"  >
									</div>
								</div>
						</div>
					</div> <!-- end of row -->
						
				<div class="row">
					<div class="col">
						<div class="tit" id="aplc_dt" ></div> <!-- 적용기간 -->
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
					<div class="col" >
						<div class="tit" id="std_fee"></div>	<!-- 기준취급수수료 -->
						<div class="box">
							<input type="text" id="STD_FEE" maxlength="8" format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="psbl_st_fee"></div>	<!-- 조정 가능 최저 기준취급수수료 -->
						<div class="box">
							<input type="text" id="PSBL_ST_FEE" maxlength="8" format="number"	 style="width: 179px" class="i_notnull" />
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="psbl_end_fee"></div>	<!-- 조정 가능 최고 기준취급수수료 -->
						<div class="box">
							<input type="text" id="PSBL_END_FEE" maxlength="8" format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
				</div>	<!-- end of row -->
				
				<div class="row">
					<div class="col" >
						<div class="tit" id="std_whsl_fee"></div>	<!-- 기준도매수수료 -->
						<div class="box">
							<input type="text" id="STD_WHSL_FEE" maxlength="8" format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="psbl_st_whsl_fee"></div>	<!-- 조정 가능 최저 기준도매수수료 -->
						<div class="box">
							<input type="text" id="PSBL_ST_WHSL_FEE" maxlength="8" format="number"	 style="width: 179px" class="i_notnull" />
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="psbl_end_whsl_fee"></div>	<!-- 조정 가능 최고 기준도매수수료 -->
						<div class="box">
							<input type="text" id="PSBL_END_WHSL_FEE" maxlength="8" format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
				</div>	<!-- end of row -->
				
				
				<div class="row">
					<div class="col" >
						<div class="tit" id="std_rtl_fee"></div>	<!-- 기준소매수수료 -->
						<div class="box">
							<input type="text" id="STD_RTL_FEE" maxlength="8" format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="psbl_st_rtl_fee"></div>	<!-- 조정 가능 최저 기준소매수수료 -->
						<div class="box">
							<input type="text" id="PSBL_ST_RTL_FEE" maxlength="8" format="number"	 style="width: 179px" class="i_notnull" />
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="psbl_end_rtl_fee"></div>	<!-- 조정 가능 최고 기준소매수수료 -->
						<div class="box">
							<input type="text" id="PSBL_END_RTL_FEE" maxlength="8" format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
				</div>	<!-- end of row -->
			
		</div>  <!-- end of srcharea -->
	</section> <!-- end of secwrap -->
      
 		<section class="btnwrap mt20"  >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
 
</div>

</body>
</html>