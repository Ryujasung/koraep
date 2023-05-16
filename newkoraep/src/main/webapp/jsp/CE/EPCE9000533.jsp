<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

<script type="text/javaScript" language="javascript" defer="defer">
    var INQ_PARAMS;//파라미터 데이터
    var areaList;//지역
    var toDay = kora.common.gfn_toDay();// 현재 시간
    var selList;
    var fix_date_select;
    var urm_list;
    
    $(function() {
         
        INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
        areaList = jsonObject($("#areaList").val());//지역
        urm_list 		= jsonObject($("#urm_list").val());		//도매업자 업체명 조회
        kora.common.setEtcCmBx2(urm_list, "","", $("#SERIAL_NO"), "SERIAL_NO", "URMCENO_SERIAL", "N" ,'T');		//도매업자 업체명
        $("#SERIAL_NO").select2();	
//         fix_date_select 		= jsonObject($("#fix_date_select").val());
//         console.log(fix_date_select);
        fn_init(); 
        fn_rtrvl_dt();
          
        //버튼 셋팅
        fn_btnSetting();
         
        //맵차트 셋팅
        //fnSetMap(false);
         
        //그리드 셋팅(지역)
        //fnSetGrid();

        //그리드 셋팅(생산자)
//         fnSetGrid2();
        
        //파이차트 셋팅
        //fnSetChart();
        
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
        
		/************************************
		 * 회수량 변경시 - 소매수수료 계산
		 ***********************************/
		$("#URM_CNT").change(function(){
			
			if($("#URM_CNT").val() != '' && $("#URM_FIX_CD").val() != ''){
				for(var i=0; i<fix_date_select.length; i++){
					if(fix_date_select[i].URM_FIX_CD == $("#URM_FIX_CD").val() ) {
						var supFee = Number(fix_date_select[i].SUP_FEE); // 단가
						var supPay = Number($("#URM_CNT").val().replace(/\,/g,"")) * Number(fix_date_select[i].SUP_FEE); // 공급가액(갯수 * 단가)
						var fixVatFee = supPay *0.1;
						var sumTot = supPay + fixVatFee;
// 						var cenTot = sumTot * percent;
// 						var retTot = sumTot * percent;
						$('#SUP_FEE').text(kora.common.format_comma(supFee));
						$('#SUP_PAY').text(kora.common.format_comma(supPay));
						$('#FIX_VAT_FEE').text(kora.common.format_comma(fixVatFee));
						$('#SUM_TOT').text(kora.common.format_comma(sumTot));
						if($("#CEN_BUR_RATIO").val() != ""){
							var percent = Number($("#CEN_BUR_RATIO").val().replace(/\,/g,""))/10;
							console.log(percent);
// 							if(percent == 0){
// 								var cenPay = supFee;
// 								var retPay = 0;
// 							}else{
								var cenPay = supFee * percent;
								var retPay = supFee - cenPay;
// 							}
							var cenTot = sumTot * percent;
							var retTot = sumTot -cenTot;
							$('#CEN_TOT').text(kora.common.format_comma(cenTot.toFixed(0)));
							$('#RET_TOT').text(kora.common.format_comma(retTot.toFixed(0)));
							$('#CEN_PAY').text(kora.common.format_comma(cenPay.toFixed(0)));
							$('#RET_PAY').text(kora.common.format_comma(retPay.toFixed(0)));
							
						}
						break;		
					}
				}
			}
			
		});
		
		/************************************
		 * 회수량 변경시 - 소매수수료 계산
		 ***********************************/
		$("#CEN_BUR_RATIO").change(function(){
			
			if($("#CEN_BUR_RATIO").val() != '' && $("#URM_FIX_CD").val() != ''){
				for(var i=0; i<fix_date_select.length; i++){
					if(fix_date_select[i].URM_FIX_CD == $("#URM_FIX_CD").val() ) {
						var supFee = Number(fix_date_select[i].SUP_FEE); // 단가
						var supPay = Number($("#URM_CNT").val().replace(/\,/g,"")) * Number(fix_date_select[i].SUP_FEE); // 공급가액(갯수 * 단가)
						var fixVatFee = supPay *0.1;
						var sumTot = supPay + fixVatFee;
						var percent = Number($("#CEN_BUR_RATIO").val().replace(/\,/g,""))/10;
						var cenTot = sumTot * percent;
						var retTot = sumTot -cenTot;;
						$('#SUP_FEE').text(kora.common.format_comma(supFee));
						$('#SUP_PAY').text(kora.common.format_comma(supPay));
						$('#FIX_VAT_FEE').text(kora.common.format_comma(fixVatFee));
						$('#SUM_TOT').text(kora.common.format_comma(sumTot));
							
// 							if(percent == 0){
// 								var cenPay = supFee;
// 								var retPay = 0;
// 							}else{
								var cenPay = supFee * percent;
								var retPay = supFee - cenPay;
// 							}
							$('#CEN_TOT').text(kora.common.format_comma(cenTot.toFixed(0)));
							$('#RET_TOT').text(kora.common.format_comma(retTot.toFixed(0)));
							$('#CEN_PAY').text(kora.common.format_comma(cenPay.toFixed(0)));
							$('#RET_PAY').text(kora.common.format_comma(retPay.toFixed(0)));
							
						break;		
					}
				}
			}
			
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
        $("#URM_FIX_DT").change(function(){
        	$("#URM_FIX_CD2").val("");
            var start_dt = $("#URM_FIX_DT").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
            $("#URM_FIX_DT").val(start_dt) 
            if($("#URM_FIX_DT").val() !=flag_DT){ 		//클릭시 날짜 변경 할경우   기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
		     	flag_DT = $("#URM_FIX_DT").val();  	//변경시 날짜 
		     	fn_rtrvl_dt();
   		  } 
        });
        
//         kora.common.setEtcCmBx2(fix_date_select, "","", $("#URM_FIX_CD"), "URM_FIX_CD", "URM_EXP_NM", "N" ,'T');		//도매업자 업체명
        $("#URM_FIX_CD").change(function(){
			//옆 인풋박스에 소모품번호 넣기
        	$("#URM_FIX_CD2").val($("#URM_FIX_CD option:selected").val());
        	$("#URM_CNT").trigger('change');
		});
        $("#URM_FIX_CD").select2();
    });
  //등록
	function fn_reg(){
	  
		var cen_bur_ratio_nochk = $("#CEN_BUR_RATIO").val();
		 if(kora.common.format_noComma(kora.common.null2void($("#SERIAL_NO").val(),0))  < 1) {
	            alertMsg("시리얼 번호을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#SERIAL_NO");
	            
	            return;
	        }
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#URM_FIX_CD").val(),0))  < 1) {
	            alertMsg("소모품명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#URM_FIX_CD");
	            
	            return;
	        }
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#URM_CNT").val(),0))  < 1) {
	            alertMsg("개수을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#URM_CNT");
	            
	            return;
	        }
		 if(kora.common.format_noComma(kora.common.null2void($("#CEN_BUR_RATIO").val(),0))  < 0) {
	            alertMsg("센터부담비율을 입력하십시오(0~10까지)", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#CEN_BUR_RATIO");
	            return;
	        }else if(cen_bur_ratio_nochk > 10 ){
				alertMsg("센터부담비율은 0~10까지 입력해주세요.");
				return;
			}
		 
		
		var url = "/CE/EPCE9000533_09.do"; 
		var input = {};
		for(var i=0; i<fix_date_select.length; i++){
			console.log(fix_date_select.length);
			console.log(fix_date_select[i].URM_FIX_CD);
			console.log($("#URM_FIX_CD2").val());
			
			if(fix_date_select[i].URM_FIX_CD == $("#URM_FIX_CD2").val() ) {
				console.log("2");
				var supFee = Number(fix_date_select[i].SUP_FEE); // 단가
				var supPay = Number($("#URM_CNT").val().replace(/\,/g,"")) * Number(fix_date_select[i].SUP_FEE); // 공급가액(갯수 * 단가)
				var fixVatFee = supPay *0.1;
				var sumTot = supPay + fixVatFee;
				var cenTot = sumTot * percent;
				var retTot = sumTot * percent;
				var test = $('#SUP_FEE').text();
				input['SUP_FEE'] = supFee;
				input['SUP_PAY'] = supPay
				input['FIX_VAT_FEE'] = fixVatFee
				input['SUM_TOT'] = sumTot
					var percent = Number($("#CEN_BUR_RATIO").val().replace(/\,/g,""))/10;
// 					if(percent == 0){
// 						var cenPay = supFee;
// 						var retPay = 0;
// 					}else{
						var cenPay = supFee * percent;
						var retPay = supFee - cenPay;
// 					}
					var cenTot = sumTot * percent;
					var retTot = sumTot -cenTot;
					input['CEN_TOT'] = cenTot.toFixed(0);
					input['RET_TOT'] = retTot.toFixed(0);
					input['CEN_PAY'] = cenPay.toFixed(0);
					input['RET_PAY'] = retPay.toFixed(0);
					break;		
			}
			
		}
		input['URM_FIX_DT'] = $("#URM_FIX_DT").val().replaceAll("-","");
		input['SERIAL_NO'] = $("#SERIAL_NO").val();
		input['URM_FIX_CD'] = $("#URM_FIX_CD option:selected").val();
		input['URM_EXP_NM'] = $("#URM_FIX_CD option:selected").text();
		input['URM_CNT'] = $("#URM_CNT").val();
		input["URM_PAY"]    = $("#URM_PAY").val();
		input["CEN_BUR_RATIO"]    = $("#CEN_BUR_RATIO").val() *10;
			 	console.log(input);
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
	 //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/CE/EPCE9000532.do', INQ_PARAMS);
    }
    //셋팅
    function fn_init(){
    	flag_DT = $("#URM_FIX_DT").val(); 
         
        $('#URM_FIX_DT').YJcalendar({  
            toName : '',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
        });
        
        //text 셋팅
        /* $('.row > .col > .tit').each(function(){
            $(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
        }); */
            
        //div필수값 alt
        $("#START_DT").attr('alt',parent.fn_text('sel_term'));
        $("#END_DT").attr('alt',parent.fn_text('sel_term'));
        
        //div필수값 alt
        $("#START_DT3").attr('alt',parent.fn_text('sel_term'));
        $("#START_DT4").attr('alt',parent.fn_text('sel_term'));
        $("#URM_FIX_DT").attr('alt',parent.fn_text('sel_term'));
    }
    
    
    //등록일자 변경시
    function fn_rtrvl_dt(){
 		var url = "/CE/EPCE9000533_192.do"; 
 		var input ={};
 		input["URM_FIX_DT"] = $("#URM_FIX_DT").val();
       	ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {   
    					fix_date_select = rtnData.fix_date_select;
    					kora.common.setEtcCmBx2(rtnData.fix_date_select, "","", $("#URM_FIX_CD"), "URM_FIX_CD", "URM_EXP_NM", "N" ,'S');	//빈용기명(소매)
    					$("#URM_FIX_CD").select2();
    				}else{
 					alertMsg("error");
    				}
    		});
    }
 
    //조회


    
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
 #s2id_URM_FIX_CD{
    width: 100%
}
 
.ax5autocomplete-display-table >div>a>div{
    margin-top: 8px;
}
</style>
</head>
<body>
<div class="iframe_inner" >
           <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
        <input type="hidden" id="urm_list" value="<c:out value='${urm_list}' />" />
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
                        <div class="tit" style="width: 150px">소모품명</div>    <!-- 조회기간 -->
                        <div class="box">
                       			<!-- <select id="URM_FIX_CD" name="URM_FIX_CD" style="width: 330px;">
								<option value="A01">배터리</option>
								<option value="A02">B</option>
								</select> -->
								<select id="URM_FIX_CD" name="URM_FIX_CD"   style="width: 300px"></select>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">소모품번호</div>    <!-- 조회기간 -->
                        <div class="box">
                       			<!-- <select id="URM_FIX_CD" name="URM_FIX_CD" style="width: 330px;">
								<option value="A01">배터리</option>
								<option value="A02">B</option>
								</select> -->
								<input type="text" id="URM_FIX_CD2" name="URM_FIX_CD2" style="width: 150px;" class="i_notnull" readonly="readonly">
                        </div>
                    </div>
                </div> <!-- end of row -->
            	
                
                
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">개수</div>    <!-- 조회기간 -->
                        <div class="box">
                        <input type="number" id="URM_CNT" name="URM_CNT" style="width: 330px;" class="i_notnull">
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px;">센터부담비율</div>    <!-- 조회기간 -->
                        <div class="box">
                        <input type="text" id="CEN_BUR_RATIO" name="CEN_BUR_RATIO" style="width: 330px;" class="i_notnull" maxlength="2" alt="">
                        <p>0~10까지</p>
                        </div>
                    </div>
                </div> <!-- end of row -->
               <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px;">무인회수기 시리얼번호</div>    <!-- 조회기간 -->
                        <div class="box">
                        <select id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" ></select>
                        </div>
                    </div>
                </div> <!-- end of row -->
               <div class="h4group" style="margin-top:3%;">
			   		<h1 style="text-align:center; font-size:25px; bold">□ 미리보기</h5>
			   </div>
               <div class="write_area" style="width:95%; margin-left:2.5%;">
					<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 12.5%;">
							<col style="width: 12.5%;">
							<col style="width: 12.5%;">
							<col style="width: 12.5%;">
							<col style="width: 12.5%;">
							<col style="width: 12.5%;">
							<col style="width: 12.5%;">
							<col style="width: 12.5%;">
						</colgroup>
						<tbody>	
							<tr>
								<th class="bd_l"colspan="3" style="text-align:center;">부품단가(부가세 별도)</th>
								<th class ="bd_l" colspan="5"style="text-align:center;">합계</td>
							</tr>
							<tr>
								<th class="bd_l">단가</th>
								<th class="bd_l">센터부담</th>
								<th class="bd_l">소매점부담</th>
								<th class="bd_l">공급가액</th>
								<th class="bd_l">부가세</th>
								<th class="bd_l">합계</th>
								<th class="bd_l">센터합계</th>
								<th class="bd_l">소매점합계</th>
								
							</tr>
							<tr>
								<td>
									<div class="row">
										<div class="tit"id="SUP_FEE"></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="tit" id="CEN_PAY"></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="tit" id="RET_PAY"></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="tit" id="SUP_PAY"></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="tit" id="FIX_VAT_FEE"></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="tit" id="SUM_TOT"></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="tit" id="CEN_TOT"></div>
									</div>
								</td>
								<td>
									<div class="row">
										<div class="tit" id="RET_TOT"></div>
									</div>
								</td>
								</tr>
							</tbody>
					</table>
					</div>
				</div>
            </div>  <!-- end of srcharea -->
        </section>
        </form>
		<section class="btnwrap mt20" style="height:160px">
		<div class="btnwrap">
			<div class="fl_r" id="BR">
 						<button type="button" class="btn36 c4" style="width: 100px;" id="btn_cnl">취소</button> 
 						<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">저장</button>
			</div>
		</div>
		</section>
     </div>

</body>
</html>