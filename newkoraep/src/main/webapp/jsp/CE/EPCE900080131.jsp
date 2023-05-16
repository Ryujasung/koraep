<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>소모품단가등록</title>
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
		$("#URM_FIX_CD").val(INQ_PARAMS.PARAMS.URM_FIX_CD);				//용기코드
		$("#URM_EXP_NM").val(INQ_PARAMS.PARAMS.URM_EXP_NM);			//빈용기명
		$("#START_DT").val(initList[0].APLC_ST_DT);									//적용기간 시작날짜
		$("#END_DT").val(initList[0].APLC_END_DT);							  		//적용기간 끝날짜
		
		//text값 넣기
		$("#title_sub").text('<c:out value="${titleSub}" />');													//타이틀
		$('#urm_fix_cd').text("소모품코드");										//소모품코드
		$('#urm_exp_nm').text("소모품명");									//소모품명
		$('#sup_fee').text("공급단가(원)");										//기준취급수수료
		$('#aplc_dt').text(parent.fn_text('aplc_dt'));										//적용기간
		
		 //div필수값 alt
		 $("#SUP_FEE").attr('alt',"공급단가(원)");								//기준취습수수료
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
	    
	}
	//저장
	function fn_reg(){
		
		var url = "/CE/EPCE900080131_09.do";
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
		input["URM_FIX_CD"]						= $("#URM_FIX_CD").val();        				//소모품코드
		input["URM_EXP_NM"]					= $("#URM_EXP_NM").val();      						//소모품명
		input["SUP_FEE"]						= $("#SUP_FEE").val();      					//공급단가(원)          
		input["START_DT"]					= $("#START_DT").val();								//시작날짜
		input["END_DT"]						= $("#END_DT").val();								//끝날짜
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
							<div class="tit"  id="urm_fix_cd" ></div>  <!-- 용기코드 -->
							<div class="box">
								<input type="text" style="width: 179px; border: 0" id="URM_FIX_CD"  readonly="readonly" >
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col" >
							<div class="tit"  id="urm_exp_nm"></div>  <!-- 빈용기명-->
							<div class="box">
								<input type="text" style="width: 378px; border: 0 " id="URM_EXP_NM" readonly="readonly"  >
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
						<div class="tit" id="sup_fee"></div>	<!-- 기준취급수수료 -->
						<div class="box">
							<input type="text" id="SUP_FEE" maxlength="8" format="number"	style="width: 179px" class="i_notnull" />
						</div>
					</div>
				</div>	<!-- end of row -->
		</div>  <!-- end of srcharea -->
	</section> <!-- end of secwrap -->
      
 		<section class="btnwrap mt20" style="height:160px">
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
 
</div>

</body>
</html>