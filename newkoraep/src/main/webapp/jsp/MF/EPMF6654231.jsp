<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>소매직접반환 등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
	
	<script type="text/javaScript" language="javascript" defer="defer">
	
    	var ctnr_nm = []; //빈용기

    	var mfcSeCdList;  //생산자구분 리스트
        var rtlRtnSeList;
        var INQ_PARAMS;   //파라미터 데이터

		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			INQ_PARAMS	= jsonObject($("#INQ_PARAMS").val());
			rtlRtnSeList = jsonObject($("#rtlRtnSeList").val());
			mfcSeCdList = jsonObject($("#mfcSeCdList").val());
			rtc_dt_list 	= jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	

			//날짜 셋팅
		    $('#RTL_RTN_DT').YJcalendar({  
				triggerBtn : true,
				dateSetting: kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
		    $('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id')) );
			});
		    
			//작성체크용
			$('#MFC_BIZRNM').attr('alt', parent.fn_text('mfc_bizrnm'));
			$('#MFC_BRCH_NM').attr('alt', parent.fn_text('mfc_brch_nm'));
			$('#RTL_RTN_DT').attr('alt', parent.fn_text('drct_rtn_dt'));
			$('#CTNR_NM').attr('alt', parent.fn_text('ctnr_nm'));
			$('#RTL_RTN_SE').attr('alt', parent.fn_text('drct_rtn_se'));
			$('#RTL_RTN_NM').attr('alt', parent.fn_text('drct_rtn_user_nm'));
			$('#RTL_RTN_QTY').attr('alt', parent.fn_text('drct_rtn_qty'));
			$('#DRCT_PAY_FEE').attr('alt', parent.fn_text('drct_pay_fee'));
			
			//버튼셋팅
			fn_btnSetting();

			fnSetGrid1();  //그리드 셋팅
			
			//생산자구분
			kora.common.setEtcCmBx2(mfcSeCdList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N");
			fn_mfc_bizrnm();
			
			//빈용기명
			kora.common.setEtcCmBx2([], "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'S');
			//직접반환구분
			kora.common.setEtcCmBx2(rtlRtnSeList, "","", $("#RTL_RTN_SE"), "ETC_CD", "ETC_CD_NM", "N" ,'S');

			/************************************
			 * 소매직접반환생산자 구분 변경 이벤트
			 ***********************************/
			$("#MFC_BIZRNM").change(function(){
				fn_mfc_bizrnm();
			});
				
			/************************************
			 * 날짜  클릭시 - 삭제 변경 이벤트
			 ***********************************/
			$("#RTL_RTN_DT").click(function(){
			     var start_dt = $("#RTL_RTN_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#RTL_RTN_DT").val(start_dt);
			});
			 
			/************************************
			 * 날짜  클릭시 - 추가 변경 이벤트
			 ***********************************/
			$("#RTL_RTN_DT").change(function(){
			     var start_dt = $("#RTL_RTN_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				 if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#RTL_RTN_DT").val(start_dt);
				 
				 fn_ctnr_cd();
			});
			
			/************************************
			 * 양식다운로드 버튼 클릭 이벤트
			 ***********************************/
			$("#btn_dwnd").click(function(){
				fn_excelDown();
			});
			
			/************************************
			 * 엑셀등록 버튼 클릭 이벤트
			 ***********************************/
			$("#btn_excel_reg").click(function(){
				
				if( $("#MFC_BIZRNM").val()==""  ){
					alertMsg("생산자를 선택 해주세요");
					return;
				}else if( $("#MFC_BRCH_NM").val()==""  ){
					alertMsg("직매장을 선택 해주세요");
					return;
				}else{
					$("#MFC_BIZRNM").prop("disabled",true);
					$("#MFC_BRCH_NM").prop("disabled",true);
					kora.common.gfn_excelUploadPop("fn_popExcel");
				}
				
			});

			//등록
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//취소
			$("#btn_lst").click(function(){
				fn_lst();
			});
			
			//행변경
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			//행삭제
			$("#btn_del").click(function(){
				fn_del();
			});
			
			//행추가
			$("#btn_reg2").click(function(){
				fn_reg2();
			});
			
		});
		
		
		//양식다운로드
	     function fn_excelDown() {
	    	downForm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
	     	downForm.submit();
	     };
	     
	     
	     /**
	      * 엑셀 업로드 후처리
	      */
	     function fn_popExcel(rtnData) {

	     	var input  	= {};
	     	var ctnrCd 	= "";
	     	var url 		= "/MF/EPMF6654231_19.do";
	     	var flag 	= false;
	     	var dup_cnt 		= 0;		//동일한 용기코드 + 생산자 + 지사가 있을경우
	    	var err_cnt 		= 0;		//잘못된 데이터로 디비 정보가 없을 경우
	    	var err_msg = "";
	    	var err_msg2 = "";
	     	
	    	 for(var i=0; i<rtnData.length ;i++) {
	    		 if(
	    			rtnData[i].직접반환일자 =="" ||
	    			rtnData[i].빈용기코드 =="" ||
	    			rtnData[i].직접반환구분 =="" ||
	    			rtnData[i].직접반환자명 =="" ||
	    			rtnData[i].직접반환량 =="" ||
	    			rtnData[i].직접지급수수료 ==""
	    		  ){
	    			alertMsg("필수입력값이 없습니다.")
	    			return;
	    		 }else if(rtnData[i].직접반환구분 =="소매업자" && rtnData[i].사업자등록번호 ==""){
	    			 alertMsg("직접반환구분이 소매업자일 경우 사업자등록번호는 필수입니다.")
		    		 return;
	    		 }
	    	 }
	    	
	    	 var mfc_bizr_val = $("#MFC_BIZRNM").val().split(';');
	    	 var mfc_bizrid = mfc_bizr_val[0];
	    	 var mfc_bizrno = mfc_bizr_val[1];
	    	 
	    	 var mfc_brch_val = $("#MFC_BRCH_NM").val().split(';');
	    	 var mfc_brch_id = mfc_brch_val[0];
	    	 var mfc_brch_no = mfc_brch_val[1];
	    	 
	     	 for(var i=0; i<rtnData.length ;i++) {
	     		 
	     		flag= false
	     		input["MFC_BIZRID"]		= mfc_bizrid;
	     		input["MFC_BIZRNO"]		= mfc_bizrno;
	     		input["MFC_BRCH_ID"]		= mfc_brch_id;
	     		input["MFC_BRCH_NO"]	= mfc_brch_no;
	     		input["RTL_RTN_DT"]		= rtnData[i].직접반환일자
	     		if(!kora.common.fn_validDate_ck( "R", input["RTL_RTN_DT"])){ //등록일자제한 체크
					return;
				}

	     		input["CTNR_CD"]				= rtnData[i].빈용기코드
	     		input["RTL_RTN_SE"]			= rtnData[i].직접반환구분
	     		input["RTL_RTN_NM"]			= rtnData[i].직접반환자명
	     		input["RTL_RTN_BIZRNO"]	= rtnData[i].사업자등록번호
	     		input["RTL_RTN_QTY"] 		= rtnData[i].직접반환량 
	     		input["DRCT_PAY_FEE"]		= rtnData[i].직접지급수수료
	     		input["RMK"]						= kora.common.null2void(rtnData[i].비고)

	     		//사업자번호 체크
	     		if(!input["RTL_RTN_BIZRNO"] == "" && !kora.common.gfn_bizNoCheck(input["RTL_RTN_BIZRNO"])){
	     			err_cnt++
					continue;
				}
	     		
	     		  ajaxPost(url, input, function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {
		    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
		    						
			    						if(rtnData.selList[0].DRCT_RTN_SE == 'D'){ //소매업자 직접등록 설정 사업자번호는 등록 제외
			    							flag =true;
			    							err_cnt++;
			    						}
									    
										if(!flag)gridRoot.addItemAt(rtnData.selList[0]);	
									    
		    					}else{
		    						err_cnt++;
		    					}
	    				}else{
							alertMsg("error");
	    				}
	    		},false);  
				
	     	 }// end for
	    
	     		err_msg = dup_cnt+" 개의 동일한 정보를 제외하고 등록 하였습니다.";
	     		err_msg2 =err_cnt+" 개의 확인되지 않은 정보가 등록 제외되었습니다.";
	     
		     	if(dup_cnt >0 && err_cnt >0){
		     		alertMsg(err_msg+"\n"+err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다.");
		        }else if(dup_cnt >0){
		        	alertMsg(err_msg+"\n등록 정보를 다시 확인해주시기 바랍니다.");
	     		}else if(err_cnt >0){
	     			alertMsg(err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다." );
	     		}
		     	
	     }
		
		
		//소매직접반환 생산자 변경시
	   function fn_mfc_bizrnm(){
			var url = "/MF/EPMF6645231_192.do" 
			var input = {};
			var mfc_bizrnm	= $("#MFC_BIZRNM").val(); 	 //소매직접반환 생산자
			
			ctnr_nm=[];
 			var arr = mfc_bizrnm.split(";");

 			input["BIZRID"] 		    = arr[0];	//생산자 아이디
			input["BIZRNO"]			= arr[1];	//생산자 번호
 			input["CTNR_CD"] 		= $("#CTNR_NM").val();		//용기코드
 			input["DRCT_RTRVL_DT"] 	= $("#RTL_RTN_DT").val(); 		//소매직접반환일자

       	    ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					 ctnr_nm = rtnData.ctnr_nm
   					 kora.common.setEtcCmBx2(rtnData.brch_dtssList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N");//소매직접반환대상 직매장/공장		
   					 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기명
   				}else{
   					 alertMsg("error");
   				}
    		});
		}
		
	   //소매직접반환일자 변경시 빈용기명 재조회
	   function fn_ctnr_cd(){
			var url = "/MF/EPMF6645231_193.do" 
			var input = {};
			var mfc_bizrnm	= $("#MFC_BIZRNM").val(); 	 //소매직접반환 생산자
			
			ctnr_nm=[];
			
			if(mfc_bizrnm == undefined || mfc_bizrnm == ''){
				
				$("#CTNR_NM").children().remove();
				$("#CTNR_NM").append("<option value=''>"+parent.fn_text('cho')+"</option>");
				$("#CTNR_NM").val('');
				
				arr[0] = '';
				arr[1] = '';
				
			}else{
				
	 			var arr = mfc_bizrnm.split(";");
	
	 			input["BIZRID"] 		    = arr[0]; //생산자 아이디
				input["BIZRNO"]			= arr[1]; //생산자 번호
	 			input["DRCT_RTRVL_DT"] 	= $("#RTL_RTN_DT").val(); //소매직접반환일자

	       	    ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {   
	   					 ctnr_nm = rtnData.ctnr_nm;
	   					 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N", 'S'); //빈용기명
	   				}else{
	   					 alertMsg("error");
	   				}
	    		}, false);
	 			
	   		}
		}

		
	    //행추가
	 	function fn_reg2(){
	    	 	 		
	 		if( $("#MFC_BIZRNM").val() !="") {
	 			$("#MFC_BIZRNM").prop("disabled",true);
	 		}
	 		
	 		if( $("#MFC_BRCH_NM").val() !="") {
	 			$("#MFC_BRCH_NM").prop("disabled",true);
	 		}

	 		var input = insRow("A");
	 		if(!input){
	 			return;
	 		}
	 		
	 		gridRoot.addItemAt(input);
	 		dataGrid.setSelectedIndex(-1);
	 	}
	     
	 	//행변경
	 	function fn_upd(){
	 		
	 		var idx = dataGrid.getSelectedIndex();
	 		
	 		if(idx < 0) {
	 			alertMsg(parent.fn_text('alt_row_cho'));
	 			return;
	 		}
	 		
	 		var input = insRow("M");
	 		if(!input){
	 			return;
	 		}

	 		//해당 데이터 수정
	 		gridRoot.setItemAt(input, idx);
	 	}

	 	//행삭제
	 	function fn_del(){
	 		var idx = dataGrid.getSelectedIndex();
	 		var collection = gridRoot.getCollection();  //그리드 데이터

	 		if(idx < 0) {
	 			alertMsg(parent.fn_text('del_row_cho'));
	 			return;
	 		}

	 		gridRoot.removeItemAt(idx);
	 		
	 		if(collection.getLength()!=[]){
	 			//생산자 선택 불가능
    			$("#MFC_BIZRNM").attr("disabled",true).attr("readonly",false);
    			$("#MFC_BRCH_NM").attr("disabled",true).attr("readonly",false);
    		}else{
    			//생산자 선택 가능
    			$("#MFC_BIZRNM").attr("disabled",false).attr("readonly",true);
    			$("#MFC_BRCH_NM").attr("disabled",false).attr("readonly",true);
    		}
	 		
	 	}
	 	 
	 	//행변경 및 행추가 시 그리드 셋팅
	 	insRow = function(gbn) {
	 		
	 		if(!kora.common.cfrmDivChkValid("divInput1")) {
	 			return false;
	 		}
	 		
	 		if(!kora.common.cfrmDivChkValid("divInput2")) {
	 			return false;
	 		}
	 		
	 		//소매업자일때만 필수입력
	 		if($('#RTL_RTN_SE').val() == '2' && $('#RTL_RTN_BIZRNO').val() == ''){
	 			alertMsg("직접반환구분 소매업자 선택시 \n사업자등록번호 작성은 필수입니다.");
	 			$('#RTL_RTN_BIZRNO').focus();
	 			return false;
	 		}
	 		
	 		// 직접반환구분  
	 		if($('#RTL_RTN_BIZRNO').val() != '' && !kora.common.gfn_bizNoCheck($('#RTL_RTN_BIZRNO').val())){
				alertMsg("정상적인 사업자등록번호가 아닙니다.");
				$('#RTL_RTN_BIZRNO').focus();
				return false;
			}

	 		//날짜 정합성 체크.
	 		if(!kora.common.fn_validDate($("#RTL_RTN_DT").val())){ 
	 			alertMsg(parent.fn_text('date_chk')); 
	 			return false;
	 		}
	 		
	 		
	 		var input = {};
		 	var collection = gridRoot.getCollection();  //그리드 데이터
		 	var ctnrCd = $("#CTNR_NM").val();

	 	    var MFC_BIZR = $('#MFC_BIZRNM option:selected').val();
			var MFC_BRCH = $('#MFC_BRCH_NM option:selected').val();
		 	
			if(!kora.common.fn_validDate_ck("R", $("#RTL_RTN_DT").val())){ //등록일자제한 체크
				return;
			}
			
			input["RTL_RTN_SE"] = $('#RTL_RTN_SE').val();
			input["RTL_RTN_DT"] = $("#RTL_RTN_DT").val();
			
			input["MFC_BIZRID"] = MFC_BIZR.split(";")[0];
			input["MFC_BIZRNO"] = MFC_BIZR.split(";")[1];
			input["MFC_BRCH_ID"] = MFC_BRCH.split(";")[0];
			input["MFC_BRCH_NO"] = MFC_BRCH.split(";")[1];
			input["MFC_BRCH_NM"] = $('#MFC_BRCH_NM option:selected').text();
			 		
			input["CTNR_CD"] = $("#CTNR_NM option:selected").val();
			input["CTNR_NM"] = $("#CTNR_NM option:selected").text();
			input["RTL_RTN_NM"] = $("#RTL_RTN_NM").val();
			input["RTL_RTN_BIZRNO"] = $("#RTL_RTN_BIZRNO").val();
			input["RTL_RTN_QTY"] = $("#RTL_RTN_QTY").val().replace(/\,/g,"");
			input["DRCT_PAY_FEE"] = $("#DRCT_PAY_FEE").val().replace(/\,/g,"");
		
			input["RMK"] = $("#RMK").val();

			for(var i=0; i<ctnr_nm.length; i++){  //빈용기리스트 가져오면
				if(ctnr_nm[i].CTNR_CD == ctnrCd) {
					//input["PRPS_SE"] = ctnr_nm[i].CPCT_NM1; //용도
				    input["CPCT_NM"] = ctnr_nm[i].CPCT_NM2;	//용량
				    input["STD_DPS"] = ctnr_nm[i].STD_DPS; //단가
				}
			}
			
			input["DRCT_PAY_GTN"] = Number($("#RTL_RTN_QTY").val().replace(/\,/g,"")) * Number(input["STD_DPS"]); //보증금

	 		return input;
	 	};	
		
	 	function fn_lst(){
	 		kora.common.goPageB('', INQ_PARAMS);
	 	}
		
		//등록
	     function fn_reg(){
	    	
	    	 var collection = gridRoot.getCollection();  //그리드 데이터

	 		if(0 != collection.getLength()){
	 			confirm('등록하시겠습니까?', 'fn_reg_exec');
			}else{
				alertMsg("등록할 자료가 없습니다.\n\n자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 다음 등록 버튼을 클릭하세요.");
			}
		}
		
		function fn_reg_exec(){
			
			var data = {"list": ""};
	 		var row = new Array();
	 		var url = "/MF/EPMF6654231_09.do";
			var collection = gridRoot.getCollection();
			
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot.getItemAt(i);
		 		row.push(tmpData);//행 데이터 넣기
		 	}

			data["list"] = JSON.stringify(row);

			ajaxPost(url, data, function(rtnData){
				if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_lst');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				}else{
					alertMsg("error");
				}
			});
			
		}
	     
   		//선택한 행 입력창에 값 넣기
	 	function fn_rowToInput (rowIndex){
	 		var item = gridRoot.getItemAt(rowIndex);
	 		
	 		$("#RTL_RTN_DT").val(item["RTL_RTN_DT"]);
	 		fn_ctnr_cd();
	 		$("#CTNR_NM").val(	item["CTNR_CD"]).prop("selected", true);    //빈용기명
	 		
	 		//$("#MFC_BRCH_NM").val(item["MFC_BRCH_ID"]+";"+item["MFC_BRCH_NO"]);

	 		$("#RTL_RTN_SE").val(item["RTL_RTN_SE"]);
	 		
	 		$("#RTL_RTN_NM").val(item["RTL_RTN_NM"]);
	 		$("#RTL_RTN_BIZRNO").val(item["RTL_RTN_BIZRNO"]);
	 		
	 		$("#RTL_RTN_QTY").val(kora.common.format_comma(item["RTL_RTN_QTY"]));
	 		$("#DRCT_PAY_FEE").val(kora.common.format_comma(item["DRCT_PAY_FEE"]));
	 		
	 		$("#RMK").val(item["RMK"]);
	 	};
		 			 	
		/****************************************** 그리드 셋팅 시작***************************************** */
		/**
		 * 그리드 관련 변수 선언
		 */
		var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var rowIndexValue ="";
	
		/**
		 * 그리드 셋팅
		 */
		 function fnSetGrid1(reDrawYn) {
				rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

				layoutStr = new Array();
				
				layoutStr.push('<rMateGrid>');
				layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
				layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
				layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
				layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on" headerHeight="35" >');
				layoutStr.push('		<groupedColumns>');
				layoutStr.push('			<DataGridColumn dataField="index" headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" textAlign="center" width="50"  />');
				layoutStr.push('			<DataGridColumn dataField="RTL_RTN_DT" headerText="'+ parent.fn_text('drct_rtn_dt')+ '" textAlign="center" width="110"   formatter="{datefmt2}"/>');
				layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM" headerText="'+ parent.fn_text('mfc_brch_nm')+ '" textAlign="center" width="100"  />');
				layoutStr.push('			<DataGridColumn dataField="RTL_RTN_NM" headerText="'+ parent.fn_text('drct_rtn_user_nm')+ '" textAlign="center" width="120" />');
				layoutStr.push('			<DataGridColumn dataField="RTL_RTN_BIZRNO" headerText="'+ parent.fn_text('bizrno2')+ '" textAlign="center" width="150"  formatter="{maskfmt1}"/>');	
				layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="center" width="200" />');
				layoutStr.push('			<DataGridColumn dataField="CTNR_CD" headerText="'+ parent.fn_text('cd')+ '"  textAlign="center" width="100" />');
				layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  headerText="'+ parent.fn_text('cpct') + '" textAlign="center" width="100" />');
				layoutStr.push('			<DataGridColumn dataField="RTL_RTN_QTY" id="num1" headerText="'+ parent.fn_text('drct_rtn_qty')+ '" width="110" formatter="{numfmt}" textAlign="right" />');
				layoutStr.push('			<DataGridColumn dataField="DRCT_PAY_GTN" id="num2" headerText="'+ parent.fn_text('drct_pay_dps2')+ '" width="130" formatter="{numfmt}" textAlign="right" />');
				layoutStr.push('			<DataGridColumn dataField="DRCT_PAY_FEE" id="num3" headerText="'+ parent.fn_text('drct_pay_fee')+ '" width="130" formatter="{numfmt}" textAlign="right" />');
				layoutStr.push('			<DataGridColumn dataField="RMK" headerText="'+ parent.fn_text('rmk')+ '" textAlign="left" width="100" />');
				layoutStr.push('		</groupedColumns>');
				layoutStr.push('		<footers>');
				layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
				layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//소매직접반환량(개)
				layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//직접지급보증금(원)
				layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//직접지급수수료(원)
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('			</DataGridFooter>');
				layoutStr.push('		</footers>');
				layoutStr.push('	</DataGrid>');
				layoutStr.push('</rMateGrid>');
		}
	
		/**
		 * 조회기준-생산자 그리드 이벤트 핸들러
		 */
		function gridReadyHandler(id) {
			gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
			gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
			gridApp.setLayout(layoutStr.join("").toString());
			gridApp.setData([]);
			var layoutCompleteHandler = function(event) {
				dataGrid = gridRoot.getDataGrid(); // 그리드 객체
				dataGrid.addEventListener("change", selectionChangeHandler);
			}
			var dataCompleteHandler = function(event) {
				dataGrid = gridRoot.getDataGrid(); // 그리드 객체

				//소매직접반환데이터 있을 시 생산자 선택 막기
				var collection = gridRoot.getCollection();  //그리드 데이터
				
				if(collection.getLength()!=[]){
					//생산자 선택 불가능
	    			$("#MFC_BIZRNM").attr("disabled",true).attr("readonly",false);
	    			$("#MFC_BRCH_NM").attr("disabled",true).attr("readonly",false);
	    		}else{
	    			//생산자 선택 가능
	    			$("#MFC_BIZRNM").attr("disabled",false).attr("readonly",true);
	    			$("#MFC_BRCH_NM").attr("disabled",false).attr("readonly",true);
	    		}
				
			}
			var selectionChangeHandler = function(event) {
				var rowIndex = event.rowIndex;
				var columnIndex = event.columnIndex;
				selectorColumn = gridRoot.getObjectById("selector");
				rowIndexValue = rowIndex;
				fn_rowToInput(rowIndex);
		
			}
			gridRoot.addEventListener("dataComplete", dataCompleteHandler);
			gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		}

		
    /****************************************** 그리드 셋팅 끝***************************************** */

</script>

<style type="text/css">

.srcharea .row .col .tit{
width: 120px;
}

</style>

</head>
<body>

    <div class="iframe_inner" >
    	
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
    	<input type="hidden" id="mfcSeCdList" value="<c:out value='${mfcSeCdList}' />" />
    	<input type="hidden" id="rtlRtnSeList" value="<c:out value='${rtlRtnSeList}' />" />
		<input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
    
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="singleRow">
				<div class="btn" id="UR"></div>
				</div>
			</div>
			   
			<section class="secwrap" id="divInput1">
				<div class="srcharea" id="whsl_info"> 
				<div class="row">
						<div class="col">
							<div class="tit" id="drct_rtn_mfc_sel"></div>  <!--소매직접반환 생산자 선택 -->
							<div class="box">
								<select id="MFC_BIZRNM" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="mfc_brch_nm" ></div>  <!--직매장/공장-->
							<div class="box">
								<select id="MFC_BRCH_NM" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
					</div> <!-- end of row -->
				</div>
			</section>
			<section class="secwrap" >
				<div class="srcharea" style="margin-top: 10px" id="divInput2" > 
					<div class="row">
						<div class="col">
							<div class="tit" id="drct_rtn_dt"></div>  <!-- 소매직접반환일자 -->
							<div class="box">
								<div class="calendar">
								<input type="text" id="RTL_RTN_DT"  style="width: 180px;" class="i_notnull" alt=""> <!--시작날짜  -->
							</div>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
							<div class="box">
								<select id="CTNR_NM" style="width: 279px" class="i_notnull" alt=""></select>
							</div>
						</div>
					    
					</div> <!-- end of row -->

					<div class="row">
						<div class="col">
							<div class="tit" id="drct_rtn_se"></div>
							<div class="box">
								<select id="RTL_RTN_SE" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="drct_rtn_user_nm"></div>
							<div class="box">
								<input type="text"  id="RTL_RTN_NM" style="width: 179px" class="i_notnull" maxByteLength="90" />
							</div>
						</div>
						<div class="col">
							<div class="tit" id="bizrno2" ></div>
							<div class="box">
								<input type="text"  id="RTL_RTN_BIZRNO" style="width: 179px" maxByteLength="10"/>
							</div>
						</div>					
					</div> <!-- end of row -->

					<div class="row">
						<div class="col">
							<div class="tit" id="drct_rtn_qty"></div>  <!-- 소매직접반환량 -->
							<div class="box">
								  <input type="text"  id="RTL_RTN_QTY" style="width: 179px;text-align:right" class="i_notnull" maxlength="11" format="minus" />
							</div>
						</div>
						<div class="col">
							<div class="tit" id="drct_pay_fee" ></div>  <!-- 직접지급수수료 -->
							<div class="box">
								<input type="text"  id="DRCT_PAY_FEE" style="width: 179px;text-align:right" class="i_notnull" maxlength="13" format="minus"/>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="rmk"></div>  <!-- 비고 -->
							<div class="box">
								<input type="text"  id="RMK" style="width: 179px" maxByteLength="90"/>
							</div>
						</div>
					</div> <!-- end of row -->	
				</div>  <!-- end of srcharea -->
			</section>
			
			<section class="btnwrap mt10" style="">
				<div class="fl_r" id="CR">
				</div>
			</section>
			
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			
			 <div class="h4group" >
				<h5 class="tit"  style="font-size: 16px;">
					&nbsp;&nbsp;※ 자료를 입력 후 [행추가] 버튼을 클릭하여 저장할 자료를 여러 건 입력한 후 [등록] 버튼을 클릭하여 여러 건을 동시에 저장합니다.<br/>
				</h5>
			</div>
			
    	<section class="btnwrap mt10" style="">
			<div class="fl_r" id="BR">
			</div>
		</section>
		
</div>

<form name="downForm" id="downForm" action="" method="post">
	<input type="hidden" name="fileName" value="RTL_RTN_INFO_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>

</body>
</html>
