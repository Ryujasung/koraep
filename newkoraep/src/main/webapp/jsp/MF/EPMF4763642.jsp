<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>직접회수 정정수정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javascript" src="/select2/select2.js"></script>
	<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
	<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
	<script type="text/javaScript" language="javascript" defer="defer">
	
		var ctnr_nm; //빈용기
    	var INQ_PARAMS;   //파라미터 데이터
    	var excaStdMap; //정산기간
    	var searchDtl;
    	var rowIndexValue ="";
        var ctnr_seList ={};
        var arr 	= new Array(); //생산자 관련
        var arr2 	= new Array(); //직매장 관련
        var arr3 	= new Array(); //거래처 관련
        
        var whsl_chk = {};
		
		$(document).ready(function(){
  			ctnr_nm 				=  jsonObject($("#ctnr_nm_list").val());  
			INQ_PARAMS 		=  jsonObject($("#INQ_PARAMS").val());       
			excaStdMap = jsonObject($("#excaStdMap").val());
		    searchDtl 			=  jsonObject($("#searchDtl").val());      
			var brchList 		= jsonObject($("#brchList").val());	
			
			
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			//버튼셋팅
			fn_btnSetting();

			//날짜 셋팅
		    $('#DRCT_RTRVL_DT').YJcalendar({  
				triggerBtn : true,
				dateSetting: kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
		  	//text 셋팅
			$('#drct_rtrvl_mfc').text(parent.fn_text('drct_rtrvl_mfc'));
			$('#drct_rtrvl_dt').text(parent.fn_text('drct_rtrvl_dt'));    //직접회수일자
			$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));		  //직매장/공장
			$('#dlivy_se').text(parent.fn_text('dlivy_se'));     		  //직접회수구분
			$('#cust').text(parent.fn_text('cust'));				 	  //판매처
			$('#whsdl').text(parent.fn_text('whsdl'));					  //도매업자
			$('#cust_bizrno').text(parent.fn_text('cust_bizrno2'));	  	  //거래처사업자등록번호
			$('#cust_bizrnm').text(parent.fn_text('cust_bizrnm'));        //거래처명
			$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));				  //빈용기명
			$('#drct_rtrvl_qty').text(parent.fn_text('drct_rtrvl_qty2'));//직접회수량
			$('#rmk').text(parent.fn_text('rmk'));						  //비고
			$('#sn').text(parent.fn_text('sn'));						  //순번
			$('#total').text(parent.fn_text('total'));					  //소계
			$('#cntr').text(parent.fn_text('cntr'));					  //빈용기
			$('#drct_pay_fee').text(parent.fn_text('drct_pay_fee'));	  //직접지급수수료
			
			//작성체크용
			//$('#MFC_BIZRNM').attr('alt', parent.fn_text('mfc_bizrnm'));
			$('#DRCT_RTRVL_DT').attr('alt', parent.fn_text('drct_rtrvl_dt'));
			$('#MFC_BRCH_NM').attr('alt', parent.fn_text('mfc_brch_nm'));
			$('#DLIVY_SE').attr('alt', parent.fn_text('dlivy_se'));
			$('#CTNR_NM').attr('alt', parent.fn_text('ctnr_nm'));
			$('#DLIVY_QTY').attr('alt', parent.fn_text('dlivy_qty'));
			$('#DRCT_RTRVL_QTY').attr('alt', parent.fn_text('drct_rtrvl_qty2'));
			$('#DRCT_PAY_FEE').attr('alt', parent.fn_text('drct_pay_fee'));
			
			$('#CUST_BIZRNO').attr('alt', parent.fn_text('cust_bizrno'));
			$('#CUST_BIZRNM').attr('alt', parent.fn_text('cust_bizrnm'));
			
			/************************************
			 * 직접회수생산자 구분 변경 이벤트
			 ***********************************/
			//$("#MFC_BIZRNM").change(function(){
			//	fn_mfc_bizrnm();
			//});
				
			/************************************
			 * 날짜  클릭시 - 삭제 변경 이벤트
			 ***********************************/
			$("#DRCT_RTRVL_DT").click(function(){
			     var start_dt = $("#DRCT_RTRVL_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#DRCT_RTRVL_DT").val(start_dt);
			});
			 
			/************************************
			 * 날짜  클릭시 - 추가 변경 이벤트
			 ***********************************/
			$("#DRCT_RTRVL_DT").change(function(){
			     var start_dt = $("#DRCT_RTRVL_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				 if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#DRCT_RTRVL_DT").val(start_dt);
				 
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
				
				//if( $("#MFC_BIZRNM").val()==""  ){
				//	alertMsg("생산자를 선택 해주세요");
				//	return;
				//}else if( $("#MFC_BIZRNM").val() !="") {
				//	$("#MFC_BIZRNM").prop("disabled",true);
					kora.common.gfn_excelUploadPop("fn_popExcel");
				//}
				
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
			
	
			fnSetGrid1();  //그리드 셋팅
			
			var brchIdNo = searchDtl.MFC_BRCH_ID + ';' + searchDtl.MFC_BRCH_NO;

			//직접회수대상 직매장/공장
			kora.common.setEtcCmBx2(brchList, "", brchIdNo, $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S'); 
			//빈용기명
			kora.common.setEtcCmBx2(ctnr_nm, "", searchDtl.CTNR_CD, $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'S');
			//도매업자
			//kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'S');
			
			$('#DRCT_RTRVL_DT').val(kora.common.setDelim(searchDtl.DRCT_RTRVL_DT, '9999-99-99'));
			$('#MFC_BIZRNM').text(searchDtl.MFC_BIZRNM);
			$('#CUST_BIZRNM').val(searchDtl.REG_CUST_NM);
			$('#CUST_BIZRNO').val(searchDtl.CUST_BIZRNO_DE);
			$('#DRCT_RTRVL_QTY').val(searchDtl.DRCT_RTRVL_QTY);
			$('#DRCT_PAY_FEE').val(searchDtl.DRCT_PAY_FEE);
			$('#RMK').val(searchDtl.RMK);
			
		});
		
		//정산기간 체크
        function checkExcaDt(paramDt){
        	var checkDt = paramDt.replace(/\-/g,"");
        	if(Number(checkDt) < Number(excaStdMap.EXCA_ST_DT) || Number(checkDt) > Number(excaStdMap.EXCA_END_DT)){
				return false;
        	}else{
        		return true;
        	}
        }
		
		//양식다운로드
	     function fn_excelDown() {
	     	$("#downForm").submit();
	     };
	     
	     
	     /**
	      * 엑셀 업로드 후처리
	      */
	     function fn_popExcel(rtnData) {

	     	var input  	= {};
	     	var ctnrCd 	= "";
	     	var url 		= "/MF/EPMF6645231_195.do";
	     	var flag 	= false;
	     	var dup_cnt 		= 0;		//동일한 용기코드 + 생산자 + 지사가 있을경우
	    	var err_cnt 		= 0;		//잘못된 데이터로 디비 정보가 없을 경우
	    	var err_msg = "";
	    	var err_msg2 = "";
	     	
	    	 for(var i=0; i<rtnData.length ;i++) {
	    		 if(
	    			rtnData[i].직접회수일자 =="" ||
	    			rtnData[i].직매장공장번호 =="" ||
	    			rtnData[i].거래처명 =="" ||
	    			rtnData[i].거래처사업자번호 =="" ||
	    			rtnData[i].빈용기코드 =="" ||
	    			rtnData[i].직접회수량 =="" ||
	    			rtnData[i].직접지급수수료 ==""
	    		  ){
	    			alertMsg("필수입력값이 없습니다.")
	    			return;
	    		 }
	    	 }
	    	
	    	 //var mfc_bizr_val = $("#MFC_BIZRNM").val().split(';');
	    	 var mfc_bizrid = mfc_bizr_val[0];
	    	 var mfc_bizrno = mfc_bizr_val[1];
	    	 
	     	 for(var i=0; i<rtnData.length ;i++) {
	     		 
	     		flag= false
	     		input["MFC_BIZRID"]		= mfc_bizrid;
	     		input["MFC_BIZRNO"]		= mfc_bizrno;
	     		input["DRCT_RTRVL_DT"]	= rtnData[i].직접회수일자
	     		input["MFC_BRCH_NO"]	= rtnData[i].직매장공장번호
	     		input["CUST_BIZRNO"]		= rtnData[i].거래처사업자번호
	     		input["CUST_BIZRNM"]		= rtnData[i].거래처명
	     		input["CTNR_CD"]			= rtnData[i].빈용기코드
	     		input["DRCT_RTRVL_QTY"] 	= rtnData[i].직접회수량 
	     		input["DRCT_PAY_FEE"]		= rtnData[i].직접지급수수료
	     		input["RMK"]						= rtnData[i].비고

	     		//사업자번호 체크
	     		if(!kora.common.gfn_bizNoCheck(input["CUST_BIZRNO"])){
	     			err_cnt++
					continue;
				}
	     		
	     		  ajaxPost(url, input, function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {
		    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
			    						var collection = gridRoot.getCollection();  //그리드 데이터
									    for(var i=0; i<collection.getLength(); i++) {
									    	var gridData = gridRoot.getItemAt(i);
									    	if( gridData.DRCT_RTRVL_DT.replace(/\-/g,"") == input["DRCT_RTRVL_DT"]
									    		&& gridData.MFC_BRCH_NO == input["MFC_BRCH_NO"]
									    		&& gridData.CUST_BIZRNO == input["CUST_BIZRNO"]
									    		&& gridData.CTNR_CD == input["CTNR_CD"]
									    	 ){
									    		flag =true;
									    		dup_cnt++;
											}
									    }	//end of for
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
		
	   //직접회수일자 변경시 빈용기명 재조회
	   function fn_ctnr_cd(){
			var url = "/MF/EPMF6645231_193.do" 
			var input = {};

			ctnr_nm=[];

 			input["BIZRID"] 		    	= searchDtl.MFC_BIZRID;
			input["BIZRNO"]				= searchDtl.MFC_BIZRNO;
 			input["DRCT_RTRVL_DT"] 	= $("#DRCT_RTRVL_DT").val(); //직접회수일자

       	    ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					 ctnr_nm = rtnData.ctnr_nm;
   					 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N", 'S'); //빈용기명
   				}else{
   					 alertMsg("error");
   				}
    		}, false);

		}
		
		 //초기화
	     function fn_init(){
			 
	    	 //$("#MFC_BIZRNM").val(""); 		//생산자
			 $("#MFC_BRCH_NM").val(""); 	//직매장/공장
			 $("#DLIVY_SE").val("");		//직접회수구분
			 $("#CTNR_NM").val(""); 		//빈용기명
 
		}
	    //fn_cust_sel_ck_se
		
	    //행추가
	 	function fn_reg2(){
	    	 
	 		if(!kora.common.cfrmDivChkValid("divInput1")) {
	 			return;
	 		}
	 		
	 		if(!kora.common.cfrmDivChkValid("divInput2")) {
	 			return;
	 		}
	 		
	 		if(!kora.common.gfn_bizNoCheck($('#CUST_BIZRNO').val())){
				alertMsg("정상적인 사업자등록번호가 아닙니다.");
				$('#CUST_BIZRNO').focus();
				return;
			}
	 		
	 		if(!kora.common.gfn_isDate($("#DRCT_RTRVL_DT").val())){
	 			alertMsg(parent.fn_text('date_chk'));
	 			return;
	 		}
	 		
	 		//정산기간 체크
	 		if(!checkExcaDt($("#DRCT_RTRVL_DT").val())){
	 			alertMsg("정산기간에 해당하는 직접회수일자만 등록 가능합니다.");
	 			return;
	 		}

	 		var input = insRow("A");
	 		if(!input){
	 			return;
	 		}
	 		
	 		gridRoot.addItemAt(input);

	 	}
	     
	 	//행변경
	 	function fn_upd(){
	 		var idx = dataGrid.getSelectedIndex();
	 		
	 		if(idx < 0) {
	 			alertMsg(parent.fn_text('alt_row_cho'));
	 			return;
	 		}
	 		
	 		if(!kora.common.cfrmDivChkValid("divInput1")) {
	 			return;
	 		}
	 		
	 		if(!kora.common.cfrmDivChkValid("divInput2")) {
	 			return;
	 		}
	 		
	 		if(!kora.common.gfn_bizNoCheck($('#CUST_BIZRNO').val())){
				alertMsg("정상적인 사업자등록번호가 아닙니다.");
				$('#CUST_BIZRNO').focus();
				return;
			}
	 		
	 		//날짜 정합성 체크. 20160204
	 		if(!kora.common.fn_validDate($("#DRCT_RTRVL_DT").val())){ 
	 			alertMsg(parent.fn_text('date_chk')); 
	 			return; 
	 		}
	 		
	 		//정산기간 체크
	 		if(!checkExcaDt($("#DRCT_RTRVL_DT").val())){
	 			alertMsg("정산기간에 해당하는 직접회수일자만 등록 가능합니다.");
	 			return;
	 		}
	 		
	 		var input = insRow("M");
	 		if(!input){
	 			return;
	 		}
	 		
	 		// 해당 데이터의 이전 수정내역을 삭제
	 		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
	 		
	 		//해당 데이터 수정
	 		gridRoot.setItemAt(input, idx);
	 	}
	 	 
	 	 function fn_del_chk(){
	 		 fn_del();
	 	 }
	
	 	 
	 	//행변경 및 행추가 시 그리드 셋팅
	 	insRow = function(gbn) {
	 		var input = {};
		 	var collection = gridRoot.getCollection();  //그리드 데이터
		 	var ctnrCd = $("#CTNR_NM").val();

			var MFC_BRCH = $('#MFC_BRCH_NM option:selected').val();
		 	
			input["DRCT_RTRVL_DT"] = $("#DRCT_RTRVL_DT").val();
			
			input["MFC_BIZRID"] = searchDtl.MFC_BIZRID;
			input["MFC_BIZRNO"] = searchDtl.MFC_BIZRNO;
			
			input["MFC_BRCH_ID"] = MFC_BRCH.split(";")[0];
			input["MFC_BRCH_NO"] = MFC_BRCH.split(";")[1];
			
			input["MFC_BRCH_NM"] = $('#MFC_BRCH_NM option:selected').text();
			 		
			input["CTNR_CD"] = $("#CTNR_NM option:selected").val();
			input["CTNR_NM"] = $("#CTNR_NM option:selected").text();
			input["CUST_BIZRNM"] = $("#CUST_BIZRNM").val();
			input["CUST_BIZRNO"] = $("#CUST_BIZRNO").val();
			input["DRCT_RTRVL_QTY"] = $("#DRCT_RTRVL_QTY").val().replace(/\,/g,"");
			input["DRCT_PAY_FEE"] = $("#DRCT_PAY_FEE").val().replace(/\,/g,"");
		
			input["RMK"] = $("#RMK").val();

			for(var i=0; i<ctnr_nm.length; i++){  //빈용기리스트 가져오면
				if(ctnr_nm[i].CTNR_CD == ctnrCd) {
					input["PRPS_SE"] = ctnr_nm[i].CPCT_NM1;						//용도
				    input["CPCT_NM"] = ctnr_nm[i].CPCT_NM2;						//용량
				    input["STD_DPS"] = ctnr_nm[i].STD_DPS;				 		  		//단가
				}
			}
			
			input["DRCT_PAY_GTN"] = Number($("#DRCT_RTRVL_QTY").val().replace(/\,/g,"")) * Number(input["STD_DPS"]); //보증금
			
			input["CUST_BRCH_ID"] = '9999999999';
			input["CUST_BRCH_NO"] = '9999999999';

			
			for(var i=0; i<collection.getLength(); i++) {
	 	    	var tmpData = gridRoot.getItemAt(i);
	 	    	if( tmpData.MFC_BIZRID == input["MFC_BIZRID"] && tmpData.MFC_BIZRNO == input["MFC_BIZRNO"] && tmpData.MFC_BRCH_ID == input["MFC_BRCH_ID"] && tmpData.MFC_BRCH_NO == input["MFC_BRCH_NO"]
	 	    		&& tmpData.CUST_BIZRNO == input["CUST_BIZRNO"] && tmpData.CUST_BRCH_ID == input["CUST_BRCH_ID"] && tmpData.CUST_BRCH_NO == input["CUST_BRCH_NO"]
	 	    		&& tmpData.CTNR_CD == input["CTNR_CD"] && tmpData.DRCT_RTRVL_DT == input["DRCT_RTRVL_DT"]
	 	    	  ) {
	 				if(gbn == "M") {
	 					if(rowIndexValue != i) {
	 			    		alertMsg(parent.fn_text('dup001'));
	 			    		return false;
	 			    	}
	 				}else{
	 		    		alertMsg(parent.fn_text('dup001'));
	 		    		return false;
	 				}
	 			}
	 	    } 
			
	 		return input;
	 	};	
		
	 	function fn_lst(){
	 		kora.common.goPageB('', INQ_PARAMS);
	 	}
		
		//등록
	     function fn_reg(){
	    	
	 		var changedData = gridRoot.getChangedData();

	 		if(0 != changedData.length){
	 			confirm('등록하시겠습니까?', 'fn_reg_exec');
			}else{
				alertMsg("등록할 자료가 없습니다.\n\n자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 다음 등록 버튼을 클릭하세요.");
			}
		}
		
		function fn_reg_exec(){
			
			var data = {"list": ""};
	 		var row = new Array();
	 		var url = "/MF/EPMF4763642_21.do";
			var collection = gridRoot.getCollection();
			
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot.getItemAt(i);
		 		row.push(tmpData);//행 데이터 넣기
		 	}

			data["list"] = JSON.stringify(row);
			
			//정산기준코드
			data["EXCA_STD_CD"] = INQ_PARAMS.PARAMS.EXCA_STD_CD;
			data["DRCT_RTRVL_CRCT_DOC_NO"] = INQ_PARAMS.PARAMS.DRCT_RTRVL_CRCT_DOC_NO;
			
			data["MFC_BIZRNO_KEY"] = INQ_PARAMS.PARAMS.MFC_BIZRNO;
			data["MFC_BRCH_NO_KEY"] = INQ_PARAMS.PARAMS.MFC_BRCH_NO;
			data["CUST_BIZRNO_KEY"] = searchDtl.CUST_BIZRNO_DE;
			data["DRCT_RTRVL_DT_KEY"] = INQ_PARAMS.PARAMS.DRCT_RTRVL_DT;
			data["CTNR_CD_KEY"] = INQ_PARAMS.PARAMS.CTNR_CD;

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
	     
	     function fn_init2(){
	    	 var input ={};
			   input["DRCT_RTRVL_DT"] 		= "";    	//직접회수일자    
			   input["MFC_BIZRNM"] 		= "";    	//생산자  
			   input["MFC_BRCH_NM"] 	= "";     	//직매장/공장    
			   input["CUST_BIZR_NO"] 	= "";		//판매처사업자번호
			   input["CUST_NM"] 		= "";		//판매처명
			   input["CTNR_NM"] 		= "";		//빈용기명
			   input["PRPS_SE"] 		= "";		//용도
			   input["CPCT_CD"] 		= "";		//용량
			   input["DLIVY_QTY"]		= "";		//직접회수량
			   input["AMT"] 			= "";		//소계
			   input["DPS"] 			= "";		//단가 
			   input["DLIVY_SE"] 		= "";		//직접회수구분 
			   input["RMK"]				= "";  		//비고
			   
	    	return input
	     }
	    
   		//선택한 행 입력창에 값 넣기
	 	function fn_rowToInput (rowIndex){
	 		var item = gridRoot.getItemAt(rowIndex);
	 		
	 		$("#DRCT_RTRVL_DT").val(item["DRCT_RTRVL_DT"]);
	 		fn_ctnr_cd();
	 		
	 		//$("#MFC_BIZRNM").val(item["MFC_BIZRID"]+";"+item["MFC_BIZRNO"]);    //생산자 이름
	 		
	 		$("#MFC_BRCH_NM").val(item["MFC_BRCH_ID"]+";"+item["MFC_BRCH_NO"]);    //직매장/공장 이름
	 		
	 		$("#CTNR_NM").val(	item["CTNR_CD"]).prop("selected", true);    //빈용기명
	 		
	 		$("#CUST_BIZRNM").val(item["CUST_BIZRNM"]);
	 		$("#CUST_BIZRNO").val(item["CUST_BIZRNO"]);
	 		$("#DRCT_RTRVL_QTY").val(item["DRCT_RTRVL_QTY"]);
	 		$("#DRCT_PAY_FEE").val(item["DRCT_PAY_FEE"]);
	 		
	 		$("#DRCT_RTRVL_QTY").val(kora.common.format_comma($("#DRCT_RTRVL_QTY").val()));
	 		$("#DRCT_PAY_FEE").val(kora.common.format_comma($("#DRCT_PAY_FEE").val()));
	 		
	 		$("#RMK").val(item["RMK"]);
	 	};
		 			 	
		/****************************************** 그리드 셋팅 시작***************************************** */
		/**
		 * 그리드 관련 변수 선언
		 */
		var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
	
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
				layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35" >');
				layoutStr.push('		<groupedColumns>');
				layoutStr.push('			<DataGridColumn dataField="index" headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" textAlign="center" width="50"  />');	        //순번
				layoutStr.push('			<DataGridColumn dataField="DRCT_RTRVL_DT"	headerText="'+ parent.fn_text('drct_rtrvl_dt')+ '"  textAlign="center" width="110"   formatter="{datefmt2}"/>'); 	//직접회수일자
				layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM" 	headerText="'+ parent.fn_text('mfc_brch_nm')+ '" textAlign="center" width="100"  />');							//직매장/공장
				layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM"  	headerText="'+ parent.fn_text('cust_bizrnm')+ '" textAlign="center" width="120" />');							//거래처명
				layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO"  	headerText="'+ parent.fn_text('cust_bizrno2')+ '" textAlign="center" width="150"  formatter="{maskfmt1}"/>');	//거래처사업자등록번호
				layoutStr.push('			<DataGridColumn dataField="PRPS_SE"  		headerText="'+ parent.fn_text('prps_cd')+ '" textAlign="center" width="100" />');								//용도(유흥용/가정용)
				layoutStr.push('			<DataGridColumn dataField="CTNR_NM" 		headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="center" width="200" />');								//빈용기명
				layoutStr.push('			<DataGridColumn dataField="CTNR_CD" 		headerText="'+ parent.fn_text('cd')+ '"  textAlign="center" width="100" />');									//코드
				layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  		headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+ '" textAlign="center" width="100" />');						//용량(ml)
				layoutStr.push('			<DataGridColumn dataField="DRCT_RTRVL_QTY" id="num1"  headerText="'+ parent.fn_text('drct_rtrvl_qty2')+ '" width="110" formatter="{numfmt}" textAlign="right" />');		//직접회수량(개)
				layoutStr.push('			<DataGridColumn dataField="DRCT_PAY_GTN" id="num2" headerText="'+ parent.fn_text('drct_pay_dps2')+ '"  width="130" formatter="{numfmt}" textAlign="right" />');		//직접지급보증금(원)
				layoutStr.push('			<DataGridColumn dataField="DRCT_PAY_FEE" id="num3" headerText="'+ parent.fn_text('drct_pay_fee')+ '"  width="130" formatter="{numfmt}" textAlign="right" />');			//직접지급수수료(원)
				layoutStr.push('			<DataGridColumn dataField="RMK" headerText="'+ parent.fn_text('rmk')+ '" textAlign="left" width="150" />');									//비고
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
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//직접회수량(개)
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
				
				//행추가
				fn_reg2();
				dataGrid.setSelectedIndex(1); //행선택
			}
			var dataCompleteHandler = function(event) {
				dataGrid = gridRoot.getDataGrid(); // 그리드 객체

				//직접회수데이터 있을 시 생산자 선택 막기
				var collection = gridRoot.getCollection();  //그리드 데이터
								
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

.srcharea .row .col{
width: 31%;
} 
.srcharea .row .col .tit{
width: 120px;
}

</style>

</head>
<body>

    <div class="iframe_inner" >
      		<input type="hidden" id="ctnr_nm_list" value="<c:out value='${ctnrList}' />" />
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="excaStdMap" value="<c:out value='${excaStdMap}' />" />
			<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />" />
			<input type="hidden" id="brchList" value="<c:out value='${brchList}' />" />
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
							<div class="tit" id="drct_rtrvl_mfc"></div>
							<div class="box">
								<div class="box" style="line-height: 36px;" id="MFC_BIZRNM"></div>
							</div>
						</div>
					</div> <!-- end of row -->
				</div>
			</section>
			<section class="secwrap" >
				<div class="srcharea" style="margin-top: 10px" id="divInput2" > 
					<div class="row">
						<div class="col">
							<div class="tit" id="drct_rtrvl_dt"></div>  <!-- 직접회수일자 -->
							<div class="box">
								<div class="calendar">
								<input type="text" id="DRCT_RTRVL_DT"  style="width: 180px;" class="i_notnull" alt=""> <!--시작날짜  -->
							</div>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="mfc_brch_nm" style="width: 130px;"></div>  <!--직매장/공장-->
							<div class="box">
								<select id="MFC_BRCH_NM" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
							<div class="box">
								<select id="CTNR_NM" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
					    
					</div> <!-- end of row -->

					<div class="row">
						<div class="col">
							<div class="tit" id="cust_bizrnm"></div>  <!-- 거래처명 -->
							<div class="box">
								<input type="text"  id="CUST_BIZRNM" style="width: 179px" class="i_notnull" maxByteLength="90" />
							</div>
						</div>
						<div class="col">
							<div class="tit" id="cust_bizrno" style="width: 130px;"></div>  <!-- 거래처사업자번호 -->
							<div class="box">
								<input type="text"  id="CUST_BIZRNO" style="width: 179px" class="i_notnull" maxByteLength="10"/>
							</div>
						</div>					
					</div> <!-- end of row -->

					<div class="row">
						<div class="col">
							<div class="tit" id="drct_rtrvl_qty"></div>  <!-- 직접회수량 -->
							<div class="box">
								  <input type="text"  id="DRCT_RTRVL_QTY" style="width: 179px;text-align:right" class="i_notnull" maxlength="11" format="minus" />
							</div>
						</div>
						<div class="col">
							<div class="tit" id="drct_pay_fee" style="width: 130px;"></div>  <!-- 직접지급수수료 -->
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

<form name="downForm" id="downForm" action="/jsp/file_down.jsp" method="post">
	<input type="hidden" name="fileName" value="DRCT_RTRVL_INFO_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>

</body>
</html>
