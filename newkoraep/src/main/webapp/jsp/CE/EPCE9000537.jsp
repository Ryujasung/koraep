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
    var INQ_PARAMS;//파라미터 데이터
    var areaList;//지역
    var toDay = kora.common.gfn_toDay();// 현재 시간
    var selList;
    
    $(function() {
         
        INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
        areaList = jsonObject($("#areaList").val());//지역
        searchDtl = jsonObject($('#searchDtl').val());
		fnSetDtlData(searchDtl);
        fn_init(); 
          
        //버튼 셋팅
        fn_btnSetting();
         
        
        /************************************
         * 조회 클릭 이벤트
         ***********************************/
        $("#btn_sel").click(function(){
            fn_sel();
        });
        $("#btn_cnl").click(function(){
        	fn_cnl();
        });
        /**
		*등록
		*/
		$("#btn_reg").click(function(){
			fn_reg();
		});
        
		
		//저장
		function fn_reg(){

	        var url = "/CE/EPCE9000537_09.do"; 
			var input = {};
			
			input['URM_FIX_DT'] = $("#URM_FIX_DT").val().replaceAll('-','');
			input['SERIAL_NO'] = $("#SERIAL_NO").val();
			input['URM_FIX_CD'] = $("#URM_FIX_CD option:selected").val();
			input['URM_EXP_NM'] = $("#URM_FIX_CD option:selected").text();
			input['URM_CNT'] = $("#URM_CNT").val();
			input["URM_PAY"]    = $("#URM_PAY").val();
			input["REG_SN"]   =  $("#REG_SN").val();
				 	
					//showLoadingBar();   
					ajaxPost(url, input, function(rtnData){
						if(rtnData != null && rtnData != ""){
								if(rtnData.RSLT_CD =="A003"){ // 중복일경우
									alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
								}else if(rtnData.RSLT_CD =="A021"){
									alertMsg(rtnData.RSLT_MSG);
								}else if(rtnData.RSLT_CD =="0000"){
									alertMsg(rtnData.RSLT_MSG);
				  					//fn_init(); //입력창 초기화
				  					fn_cnl();
								}else{
									alertMsg(rtnData.RSLT_MSG);
								}
						}else{
								alertMsg("error");
						}
						//hideLoadingBar();
					});//end of ajaxPost
		}
		
			
		//등록
		/* function fn_reg(){
			 
			var url = "/CE/EPCE9000533_09.do"; 
			var input = {};
			
			input['URM_FIX_DT'] = $("#URM_FIX_DT").val().replaceAll("-","");
			input['SERIAL_NO'] = $("#SERIAL_NO").val();
			input['URM_FIX_CD'] = $("#URM_FIX_CD option:selected").val();
			input['URM_EXP_NM'] = $("#URM_FIX_CD option:selected").text();
			input['URM_CNT'] = $("#URM_CNT").val();
			input["URM_PAY"]    = $("#URM_PAY").val();
				 	
					//showLoadingBar();   
					ajaxPost(url, input, function(rtnData){
						if(rtnData != null && rtnData != ""){
								if(rtnData.RSLT_CD =="A003"){ // 중복일경우
									alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
								}else if(rtnData.RSLT_CD =="A021"){
									alertMsg(rtnData.RSLT_MSG);
								}else if(rtnData.RSLT_CD =="0000"){
									alertMsg(rtnData.RSLT_MSG);
				  					//fn_init(); //입력창 초기화
				  					fn_cnl();
								}else{
									alertMsg(rtnData.RSLT_MSG);
								}
						}else{
								alertMsg("error");
						}
						//hideLoadingBar();
					});//end of ajaxPost
			 
		} */
		 //취소버튼 이전화면으로
	    function fn_cnl(){
	   	 kora.common.goPageB('/CE/EPCE9000536.do', INQ_PARAMS);
	    }
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
        $("#START_DT3").change(function(){
            var start_dt = $("#START_DT3").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
            $("#START_DT3").val(start_dt) 
        });
        
        /************************************
         * 시작날짜  클릭시 - 추가 변경 이벤트
         ***********************************/
        $("#START_DT4").change(function(){
            var start_dt = $("#START_DT4").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
            $("#START_DT4").val(start_dt) 
        });
        
        /************************************
         * 시작날짜  클릭시 - 추가 변경 이벤트
         ***********************************/
        $("#URM_FIX_DT").change(function(){
            var start_dt = $("#URM_FIX_DT").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
            $("#URM_FIX_DT").val(start_dt) 
        });
    });
    
    //셋팅
    function fn_init(){
         
        //날짜 셋팅
        $('#START_DT').YJcalendar({  
            toName : 'to',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
        });
        
        $('#START_DT3').YJcalendar({  
            toName : '',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
        });
        
        $('#START_DT4').YJcalendar({  
            toName : '',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
        });
        
        $('#URM_FIX_DT').YJcalendar({  
            toName : '',
            triggerBtn : true,
            //dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
        });
        
        $('#END_DT').YJcalendar({
            fromName : 'from',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
        });
            
        //div필수값 alt
        $("#START_DT").attr('alt',parent.fn_text('sel_term'));
        $("#END_DT").attr('alt',parent.fn_text('sel_term'));
        
        //div필수값 alt
        $("#START_DT3").attr('alt',parent.fn_text('sel_term'));
        $("#START_DT4").attr('alt',parent.fn_text('sel_term'));
        $("#URM_FIX_DT").attr('alt',parent.fn_text('sel_term'));
    }
 
    //조회

 function fnSetDtlData(data){
			
		
			$("#URM_FIX_DT").val(kora.common.null2void(data.URM_FIX_DT));
			$("#SERIAL_NO").val(kora.common.null2void(data.SERIAL_NO));
			$("#URM_FIX_CD").val(data.URM_FIX_CD);
			$("#URM_CNT").val(kora.common.null2void(data.URM_CNT));
			$("#URM_PAY").val(kora.common.null2void(data.URM_PAY));
			$("#URM_PAY").val(kora.common.null2void(data.URM_PAY));
			$("#REG_SN").val(data.REG_SN);
		}
    
    function clickFunction(code, label, data) {
        
        if(INQ_PARAMS.SEL_PARAM ==null) return; 
    
        var url = "/CE/EPCE6190101_19.do"
        var input = INQ_PARAMS["SEL_PARAM"];
        input["AREA_CD"] = code;
        
        document.body.style.cursor = "wait";
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {
                //selList = rtnData.selList;
                gridApp2.setData(rtnData.selList);
                
                var pieData  = new Array();
                
                $.each(rtnData.selList, function(i, v){
                    var pieDataLine = {};
                    pieDataLine["TITLE_IN"]  = v.BIZRNM + "(" + "입고" + ")";
                    pieDataLine["TITLE_OUT"] = v.BIZRNM + "(" + "출고" + ")";
                    pieDataLine["VAL_IN"]    = v.CFM_QTY;
                    pieDataLine["VAL_OUT"]   = v.DLIVY_QTY;
                 
                    pieData.push(pieDataLine);
                });

                chartApp.setData(pieData);
            }else{
                alertMsg("error");
            }
            document.body.style.cursor = "default";
        });
        
        $("#AREA_NM").text(label);
    }

    
    
    
    /****************************************** 그리드 셋팅 끝***************************************** */
</script>
<style type="text/css">
.srcharea .row .col .tit{
    width: 120px;
}

.fa-close:before, .fa-times:before {
    content: "X"; 
    font-weight: 550;
}
 
 
.ax5autocomplete-display-table >div>a>div{
    margin-top: 8px;
}
</style>
</head>
<body>
<div class="iframe_inner" >
           <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
        <input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
        <input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
        <input type="hidden" id="REG_SN" />
        <div class="h3group">
            <h3 class="tit" >무인회수기 소모품현황 등록</h3>
            <div class="btn" style="float:right" id="UR">
            <!--btn_dwnd  -->
            <!--btn_excel  -->
            </div>
        </div>
        
        <form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
        
        <section class="secwrap"   id="params">
            <div class="srcharea mt10" > 
            	<div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">교체일자</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<div class="calendar">
                                <input type="text" id="URM_FIX_DT" name="from" style="width: 179px;" class="i_notnull"><!--시작날짜  -->
                            </div>
                        		<%-- <input type="text" id="START_DT" name="from" value="<c:out value='${VIEW_ST_DATE}' />" style="width: 180px;" class="i_notnull" alt="시작날짜"> --%>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">무인회수기 시리얼번호</div>    <!-- 조회기간 -->
                        <div class="box">
                        <input type="text" id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" alt="무인회수기명">
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">소모품명</div>    <!-- 조회기간 -->
                        <div class="box">
                       			<select id="URM_FIX_CD" name="URM_FIX_CD" style="width: 330px;">
								<option value="A01">배터리</option>
								<option value="A02">B</option>
								</select>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">개수</div>    <!-- 조회기간 -->
                        <div class="box">
                        <input type="number" id="URM_CNT" name="URM_CNT" style="width: 330px;" class="i_notnull" alt="무인회수기명">
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">가격</div>    <!-- 조회기간 -->
                        <div class="box">
                        <input type="number" id="URM_PAY" name="URM_PAY" style="width: 330px;" class="i_notnull" alt="무인회수기명">
                        </div>
                    </div>
                </div> <!-- end of row -->
                
            </div>  <!-- end of srcharea -->
        </section>
        </form>
		<section class="btnwrap mt20" >
		<div class="btnwrap">
			<div class="fl_r" id="BR">
 						<button type="button" class="btn36 c4" style="width: 100px;" id="btn_cnl">취소</button> 
 						<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">수정</button>
			</div>
		</div>
		</section>
     </div>

</body>
</html>