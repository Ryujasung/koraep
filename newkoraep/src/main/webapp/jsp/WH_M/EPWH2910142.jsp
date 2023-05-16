<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환내역서 변경</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;//파라미터 데이터
     var ctnr_se;//빈용기구분  구병 신병
     var ctnr_seList;//빈용기구분
     var ctnr_nm;//빈용기
     var initList;//그리드 초기값
     var initList2;//그리드 초기값
     var rmk_list;//소매수수료 적용여부 비고

     var arr = new Array();
	 var rowIndexValue =0;
	 
     $(function() {
    	 INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());//파라미터 데이터
         ctnr_se = jsonObject($("#ctnr_se_list").val());//빈용기구분  구병 신병
         ctnr_seList = jsonObject($("#ctnr_seList").val());//빈용기구분
         ctnr_nm = jsonObject($("#ctnr_nm_list").val());//빈용기
         rmk_list = jsonObject($("#rmk_list").val());//비고
         initList = jsonObject($("#initList").val());//그리드 초기값
         initList2 = jsonObject($("#initList").val());//그리드 초기값

    	 //그리드 셋팅
		 fnSetGrid1();
         
		/************************************
		 * 빈용기구분 구병 / 신병 변경시 
		 ***********************************/
		$("#CTNR_SE").change(function(){
			fn_prps_cd();
		});
		/************************************
		 * 빈용기 구분 변경 이벤트
		 ***********************************/
		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		});
		/************************************
		 * 빈용기코드 변경 이벤트
		 ***********************************/
		$("#CTNR_CD").change(function(){
			fn_rmk();			
		});
		/************************************
		 * 소매수수료 적용여부 이벤트
		 ***********************************/
		$("#RMK_LIST").change(function(){  
			fn_rmk_list();     
		});
		/************************************
		 * 비고 변경 이벤트
		 ***********************************/
		$("#RMK_SELECT").change(function(){  
			fn_rmk_select();     
		});
		
		/************************************
		 * 행 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del2();
		});
		/************************************
		 * 행 변경 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
		/************************************
		 * 행 추가 클릭 이벤트
		 ***********************************/
		$("#btn_reg2").click(function(){
			fn_reg2();
		});
		
		/************************************
		 * 저장 클릭 이벤트
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
		
		
  		fn_init();
  		
  		if('${sBizrTpCd}' == 'W2'){ //공병상
    		$('#RMK_SELECT').val('C'); //직접입력
    		$('#RMK').val('공병상');
    		$("#select_rtl2").prop('checked', true); //소매수수료적용여부 제외로

    		$("#RMK_SELECT").removeAttr("disabled");//비고 선택부분 활성화
    		$("#RMK").removeAttr("disabled");//비고 선택부분 활성화
			
    		//$("#w2Hide").hide();
    	} 
  		
	});
     
	//초기화
	function fn_init(){
 		//text 셋팅
		$('.box_wrap .boxed .sort, .txtTable tr th').each(function(){
			if($(this).attr('id') != ''){
				$(this).html(fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt')) ) );
			}
		});

		//div필수값 alt
		$("#PRPS_CD").attr('alt',parent.fn_text('ctnr_se'));   	
		$("#CTNR_CD").attr('alt',parent.fn_text('ctnr_nm'));   	
		$("#RTN_QTY").attr('alt',parent.fn_text('rtn_qty'));
		$("#BOX_QTY").attr('alt',parent.fn_text('box_qty'));

		$("#RTN_DT").text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_DT_ORI, "yyyy-mm-dd"));//반환일자
		$("#CAR_NO").text(INQ_PARAMS.PARAMS.CAR_NO);//차량번호
		$("#MFC_BIZRNM").text(INQ_PARAMS.PARAMS.MFC_BIZRNM);//생산자명
		$("#MFC_BRCH_NM").text(INQ_PARAMS.PARAMS.MFC_BRCH_NM);//생산자지사명
		$("#CUST_BIZRNM").text(INQ_PARAMS.PARAMS.CUST_BIZRNM);//도매업자명
		$("#CUST_BRCH_NM").text(INQ_PARAMS.PARAMS.CUST_BRCH_NM);//도매업자지사명
		arr[0] = INQ_PARAMS.PARAMS.WHSDL_BIZRID;//도매업자 사업자 아이디
		arr[1] = INQ_PARAMS.PARAMS.WHSDL_BIZRNO_ORI;//도매업자 사업자 번호
		arr[2] = INQ_PARAMS.PARAMS.WHSDL_BRCH_ID;//도매업자 지사 사업자 아이디
		arr[3] = INQ_PARAMS.PARAMS.WHSDL_BRCH_NO;//도매업자 지사 번호
		arr[4] = INQ_PARAMS.PARAMS.MFC_BIZRID;//생산자 사업자 아이디
		arr[5] = INQ_PARAMS.PARAMS.MFC_BIZRNO;//생산자 사업자 번호
		arr[6] = INQ_PARAMS.PARAMS.MFC_BRCH_ID;//생산자 지사 사업자 아이디
		arr[7] = INQ_PARAMS.PARAMS.MFC_BRCH_NO;//생산자 지사 번호
		arr[8] = INQ_PARAMS.PARAMS.RTN_DT_ORI;//반환일자
		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");//빈용기구분
		kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N");//빈용기구분 코드
		kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');//빈용기명
		kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');//비고
	}
	
   //빈용기 구분 선택시
   function fn_prps_cd(){
		var url = "/WH/EPWH2910142_19.do" 
		var input ={};
		if( $("#PRPS_CD").val() !="" ){
			input["CUST_BIZRID"] = arr[0];//도매업자아이디
			input["CUST_BIZRNO"] = arr[1];//도매업자사업자번호
			input["CUST_BRCH_ID"] = arr[2];//도매업자 지점 아이디
			input["CUST_BRCH_NO"] = arr[3];//도매업자 지점 번호
			input["MFC_BIZRID"] = arr[4];//생산자 아이디
			input["MFC_BIZRNO"] = arr[5];//생산자 사업자번호
			input["MFC_BRCH_ID"] = arr[6];//생산자 직매장/공장 아이디
			input["MFC_BRCH_NO"] = arr[7];//생산자 직매장/공장 번호
			input["RTN_DT"] = arr[8] //반환일자 
			input["CTNR_SE"] = $("#CTNR_SE").val();//빈용기명 구분 구/신
			input["PRPS_CD"] = $("#PRPS_CD").val();//빈용기명  유흥/가정/공병/직접 
			
	       	ajaxPost(url, input, function(rtnData) {
	    			if ("" != rtnData && null != rtnData) {   
	    				 ctnr_nm = rtnData.ctnr_nm
	    				 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
	    			}else{
						alert("error");
	    			}
	    	},false);
		}else{
			ctnr_nm=[];
			kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
		}
		fn_rmk()//비고 부분 초기화
   	}
   
//소매수수료 적용여부 ㅇㄷ----------------------------------------------------------------------------------------------------
	//소매수수료 적용여부
	function fn_rmk_list(){
 		var ck = $("input[type=radio][name=select_rtl]:checked").val();	//소매수수료 라디오 
 		if(ck !="ext"){//적용인경우
	  		$("#RMK_SELECT").prop("disabled",true);//비고 선택부분 비활성화
	  		$("#RMK").prop("disabled",true);//비고 입력부분 비활성화
	  		$("#RMK_SELECT").val("");//비고 선택부분 초기화
	  		$("#RMK").val("");//비고 입력부분 초기화
 		}else{//제외인경우
	  		if($("#PRPS_CD").val() =="0"){//유흥인데  소매수수료 제외를 누를경우  (공병상일 경우 직접반환도 적용)
	      		 $("#select_rtl1").prop('checked', true);
	      		 alert("빈용기 구분이 가정용 일경우에만 적용됩니다.");
	      		 return;
	      	}
 		 	$("#RMK_SELECT").removeAttr("disabled");//비고 선택부분 활성화	
 		}
	}
	
	//비고 선택 변경
	function fn_rmk_select(){
	  	if($("#RMK_SELECT").val() =="A" || $("#RMK_SELECT").val() =="B"){//소비자 직접반화 ,무인회수기인경우
	  		 $("#RMK").prop("disabled",true);//비고 입력란 비활성화
	  		 $("#RMK").val($("#RMK_SELECT option:selected").text());//비고 선택부분 텍스트 입력
	  	}else if($("#RMK_SELECT").val() =="C"){//직접입력인경우
	  		 $("#RMK").removeAttr("disabled");//비고 입력란 활성화
	  		 $("#RMK").val("");//비고 입력란 초기화
	  	}else if($("#RMK_SELECT").val() ==""){//선택일경우
	  		$("#RMK").prop("disabled",true);//비고 입력란 비활성화
	  		$("#RMK").val("");//초기화
	  	}  
  	}
	//비고부분 초기화
	function fn_rmk(){
		if('${sBizrTpCd}' != 'W2'){//공병상
			$("#RMK").val("");//비고입력부분
	  		$("#RMK_SELECT").val("");//비고선택부분
		    $("#select_rtl1").prop('checked', true);//소매수수료여부 적용
			$("#RMK_SELECT").prop("disabled",true);//비고선택부분 비활성화
	  		$("#RMK").prop("disabled",true);//비고입력부분 비활성화
		}
	}
	 
	 //행등록
	function fn_reg2(){
	
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}else if( $("#BIZR_TP_CD").val() !="" && $("#ENP_NM").val() != "" && $("#BRCH_NM").val() != ""  ) {
			$("#BIZR_TP_CD").prop("disabled",true);
			$("#ENP_NM").prop("disabled",true);
			$("#BRCH_NM").prop("disabled",true);
		}  
		var input = insRow("A");
		if(!input){
			return;
		}
		gridRoot.addItemAt(input);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
		dataGrid.setSelectedIndex(-1);			

	}
	 //행 수정
	function fn_upd(){
		var idx = dataGrid.getSelectedIndex();
		
		if(idx < 0) {
			alert("변경할 행을 선택하시기 바랍니다.");
			return;
		}else if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		var item = insRow("M");
		
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
		
		//해당 데이터 수정
		gridRoot.setItemAt(item, idx);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
		//dataGrid.setSelectedIndex(-1);			
	}
	 
	//행삭제
	function fn_del2(){
		var idx = dataGrid.getSelectedIndex();

		if(idx < 0) {
			alert("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		gridRoot.removeItemAt(idx);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
	}
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
		var input = {};
		var ctnrCd = $("#CTNR_CD").val();
		var MFC_BIZRID 	 	=  arr[4];	//생산자 아이디
		var MFC_BIZRNO 	=	arr[5];	//생산자 사업자번호
		var MFC_BRCH_ID 	=  arr[6];	//생산자 지사 아이디
		var MFC_BRCH_NO =	arr[7];	//생산자 지사 번호
		var collection = gridRoot.getCollection();
		var rtl_fee_select = $("input[type=radio][name=select_rtl]:checked").val();	//수수료적용여부  라디오체크여부
		for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot.getItemAt(i);
	 		if(tmpData.CTNR_CD == ctnrCd ){
		 		if(gbn == "M") {
					if(rowIndexValue != i) {
			    		alert("동일한 빈용기명이 있습니다.");
			    		return false;
			    	}
				} else {
		    		alert("동일한 빈용기명이 있습니다..");
		    		return false;
				}
	 		}
	 	}
	    
		for(var i=0; i<ctnr_nm.length; i++){
			
			if(ctnr_nm[i].CTNR_CD == ctnrCd) {
			 	if($("#BOX_QTY").val() !=0 ){
			    	input["BOX_QTY"] = $("#BOX_QTY").val();//상자
			    }else{
			    	input["BOX_QTY"] = "0"//상자
			    }
			 	
			    input["MFC_BIZRNM"] = INQ_PARAMS.PARAMS.MFC_BIZRNM//생산자명
			    input["MFC_BRCH_NM"] = INQ_PARAMS.PARAMS.MFC_BRCH_NM // 직매장/공장
			    input["CTNR_SE"] = $("#CTNR_SE").val();//빈용기명 구분 구/신
			    input["PRPS_NM"] = $("#PRPS_CD option:selected").text();//빈용기명 구분 유흥/가정
			    input["PRPS_CD"] = $("#PRPS_CD").val();//빈용기명 구분 유흥/가정 코드
			    input["CTNR_NM"] = $("#CTNR_CD option:selected").text();//빈용기명
			    input["CTNR_CD"] = $("#CTNR_CD").val();//빈용기 코드
			    input["CPCT_NM"] = ctnr_nm[i].CPCT_NM;//용량ml
			    input["RTN_QTY"] = $("#RTN_QTY").val();//반환량	
			    input["RTN_GTN_UTPC"] = ctnr_nm[i].STD_DPS;//기준보증금 
			    input["RTN_GTN"] = input["RTN_QTY"] * ctnr_nm[i].STD_DPS;//빈용기보증금(원) - 합계
			    input["RTN_WHSL_FEE_UTPC"] = ctnr_nm[i].WHSL_FEE;//도매수수료
			    input["RTN_WHSL_FEE"] = input["RTN_QTY"] *ctnr_nm[i].WHSL_FEE;//도매수수료 합계
			    input["RTN_WHSL_FEE_STAX"] = kora.common.truncate(parseInt(input["RTN_WHSL_FEE"],10)/10);//도매 부과세
			    
				//소매수수료 적용여부 ㅇㄷ----------------------------------------------------------------------------------------
			    if($("#PRPS_CD").val() =="1" || $("#PRPS_CD").val() =="2"){//빈용기구분이 가정일 경우에만 적용  (공병상일경우 직접반환도 적용)
					    if(rtl_fee_select =="ext"){	//소매수수료적영여부 제외시
				    		if($("#RMK_SELECT").val() =="" ){
				    			alert("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
				    			return;
				    		}else if ($("#RMK").val() ==""){
				    			alert("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
				    			return;
				    		}
					    
					    	input["RTN_RTL_FEE_UTPC"] = 0;//소매수수료    
							input["RTN_RTL_FEE"] = 0;//소매수수료 합계	
							
							if($("#RMK_SELECT").val() !="C"){//비고선택부분이  직접입력이 아닐경우
								input["RMK"] = $("#RMK_SELECT").val()+"-"+$("#RMK_SELECT option:selected").text();//비고 텍스트값
								input["RMK_C"] = $("#RMK_SELECT option:selected").text();//비고 텍스트값(view용)
							}else{//비고선택이 직접입력일경우
								input["RMK"] = $("#RMK_SELECT").val()+"-"+$("#RMK").val();//비고 텍스트값
								input["RMK_C"] = $("#RMK").val();//비고 텍스트값(view용)
							}
					    }else{//소매수수료 적용 시
					    	  input["RTN_RTL_FEE_UTPC"]	= ctnr_nm[i].RTL_FEE;//소매수수료
							  input["RTN_RTL_FEE"] = input["RTN_QTY"] * ctnr_nm[i].RTL_FEE;//소매수수료 합계	
					    }
		    	}else{//빈용기 구분이 유흥일 경우
			    	  input["RTN_RTL_FEE_UTPC"] = ctnr_nm[i].RTL_FEE;//소매수수료
					  input["RTN_RTL_FEE"] = input["RTN_QTY"] * ctnr_nm[i].RTL_FEE;//소매수수료 합계	
		   	 	}
			    
			  	//소매부과세를 도매부과세로
			    input["RTN_WHSL_FEE_STAX"] = kora.common.truncate( (parseInt(input["RTN_WHSL_FEE"],10) + parseInt(input["RTN_RTL_FEE"],10)) / 10 ); //도매 부과세
			    
				//-------------------------------------------------------------------------------------------------------------
			    input["CAR_NO"] = $("#CAR_NO").text();//차량번호
			    input["AMT_TOT"] = input["RTN_GTN"]+ input["RTN_WHSL_FEE"] + input["RTN_WHSL_FEE_STAX"]+ input["RTN_RTL_FEE"];//총합계
			    input["CUST_BIZRID"] = arr[0];//도매업자아이디
			    input["CUST_BIZRNO"] = arr[1];//도매업자사업자번호
			    input["CUST_BRCH_ID"] = arr[2];//도매업자 지점 아이디
			    input["CUST_BRCH_NO"] = arr[3];//도매업자 지점 번호
			    input["MFC_BIZRID"] = arr[4];//생산자 아이디
			    input["MFC_BIZRNO"] = arr[5];//생산자 사업자번호
			    input["MFC_BRCH_ID"] = arr[6];//생산자 직매장/공장 아이디
			    input["MFC_BRCH_NO"] = arr[7];//생산자 직매장/공장 번호
			    input["RTN_DT"] = arr[8];//반환일자 
			    input["SYS_SE"]	= 'W';//시스템구분	
			    input["RTN_STAT_CD"] = 'RG';//반환상태코드
			    input["FH_RTN_QTY_TOT"] = '0';//가정용 반환량 합계
			    input["FB_RTN_QTY_TOT"]	= '0';//영업용 반환량 합계
			    input["DRCT_RTN_QTY_TOT"] = '0';//직접    반환량 합계
			    input["BIZR_TP_CD"]	= INQ_PARAMS.PARAMS.BIZR_TP_CD_ORI;// 도매업자 구분 
			    input["RTN_DOC_NO"]	= initList[0].RTN_DOC_NO;// 반환문서번호
			    input["REG_PRSN_ID"] = initList[0].REG_PRSN_ID;// 등록자 
			    input["REG_DTTM"] = initList[0].REG_DTTM;// 등록일시 최조
			    input["GBN"] = INQ_PARAMS.PARAMS.GBN      // 도매업자 구분
			   break;
			}
				
		}

		return input;
	};	
	
	function fn_del_chk(){
		if(confirm("반환 내역이 모두 삭제되었습니다. 계속 진행하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.")){
			fn_del_exec();
		}
	}
	
	function fn_del_exec(){
		var url ="/WH/EPWH2910142_04.do"; 
		var input ={}
		input["RTN_DOC_NO"] = initList[0].RTN_DOC_NO //반환문서번호
		ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				alert(rtnData.RSLT_MSG);
				fn_cnl2();
			}else{
				alert(rtnData.RSLT_MSG);
			}
		},false);  
	}
	
	//등록
	function fn_reg(){
		
		//var data = {"list": ""};
		//var row = new Array();
		//var url = "/WH/EPWH2910142_21.do"; 
		
		var changedData = gridRoot.getChangedData();
		if(0 != changedData.length){
			
			var collection = gridRoot.getCollection();
			if(collection.getLength()==0){
				fn_del_chk();	//행 데이터 전부 삭제 할경우 데이터 삭제
			}else{//변경시 
				if(confirm('저장하시겠습니까?')){
					fn_reg_exec();
				}
			}	
		}else{// 변경된 자료 없을경우
			alert("변경된 자료가 없습니다.");
		}
	}
	
	function fn_reg_exec(){
		var data = {"list": ""};
		var row = new Array();
		var url = "/WH/EPWH2910142_21.do"; 
		var collection = gridRoot.getCollection();
		
		for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot.getItemAt(i);
	 		row.push(tmpData);//행 데이터 넣기
	 	}
		data["list"] = JSON.stringify(row);
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
				if(rtnData.RSLT_CD =="0000"){
					alert(rtnData.RSLT_MSG);
					fn_cnl();
				}else{
					alert(rtnData.RSLT_MSG);
				}
			}else{
				alert("error");
			}
		},false); 
	}
	
	//취소버튼 이전화면으로  반환상세페이지로 이동
    function fn_cnl(){
   	 	kora.common.goPageB('', INQ_PARAMS);
    }
	  
    //모든 데이터 삭제 할경우  반환관리 화면으로 이동
    function fn_cnl2(){
   	 	kora.common.goPageB('/WH/EPWH2910101.do', INQ_PARAMS);
    }
	
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		var item = gridRoot.getItemAt(rowIndex);
		fn_dataSet(item);
		$("#CTNR_SE").val(item["CTNR_SE"]).prop("selected", true);//빈용기명 구분 구병 /신병
		$("#PRPS_CD").val(item["PRPS_CD"]).prop("selected", true);//빈용기명 구분 유흥/가정 / 직접
		$("#CTNR_CD").val(item["CTNR_CD"]).prop("selected", true);//빈용기명
		$("#RTN_QTY").val(item["RTN_QTY"]);
		$("#BOX_QTY").val(item["BOX_QTY"]);
		//$("#CAR_NO").text(item["CAR_NO"]); 
		
		//소매수수료 적용여부 ㅇㄷ----------
		if(item["RMK"] !=undefined){//비고가 있을경우 
			if(item["RMK"].substring(0,1) =="C"){//비고중 직접입력일경우
				$("#RMK").removeAttr("disabled");//input창 활성화
			}else{
				$("#RMK").prop("disabled",true);//비고입력창 비활성화
			}
			$("#select_rtl2").prop('checked', true);//소매수수료적용여부 제외로
	    	$("#RMK_SELECT").removeAttr("disabled");//비고 선택부분 활성화
			$("#RMK_SELECT").val(item["RMK"].substring(0,1));//비고 원본(코드+글자) 비고 선택부분 코드
			$("#RMK").val(item["RMK_C"]);//비고 글자만
		}else{//비고가 없을경우
			$("#select_rtl1").prop('checked', true);//소매수수료적용여부 적용
	    	$("#RMK_SELECT").prop("disabled",true);//비고선택부분 비활성화
	    	$("#RMK").prop("disabled",true);//비고입력창 비활성화
			$("#RMK_SELECT").val("");//비고선택부분 선택으로
			$("#RMK").val("");//비고 초기화  
		}
	};
	
	function fn_dataSet(item){
		  var input	= {};
		  var url = "/WH/EPWH2910142_192.do"; 
		   input["CUST_BIZRID"] = item["CUST_BIZRID"];//도매업자아이디
		   input["CUST_BIZRNO"] = item["CUST_BIZRNO"];//도매업자사업자번호
		   input["CUST_BRCH_ID"] = item["CUST_BRCH_ID"];//도매업자 지점 아이디
		   input["CUST_BRCH_NO"] = item["CUST_BRCH_NO"];//도매업자 지점 번호
		   input["MFC_BIZRID"] = item["MFC_BIZRID"];//생산자 아이디
		   input["MFC_BIZRNO"] = item["MFC_BIZRNO"];//생산자 사업자번호
		   input["MFC_BRCH_ID"] = item["MFC_BRCH_ID"];//생산자 직매장/공장 아이디
		   input["MFC_BRCH_NO"] = item["MFC_BRCH_NO"];//생산자 직매장/공장 번호
		   input["CTNR_SE"] = item["CTNR_SE"];//빈용기명 구분 구/신
		   input["PRPS_CD"] = item["PRPS_CD"];//빈용기명  유흥/가정/공병/직접 
		   input["RTN_DT"] = item["RTN_DT"];//반환일자 
		   
       	   ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
					 ctnr_nm	 = [];
   					 ctnr_nm = rtnData.ctnr_nm
   					 kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');//빈용기명
   				}else{
					alert("error");
   				}
    		},false);
	}
	
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
 			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
 			layoutStr.push('	<DataGrid id="dg1" autoHeight="true" minHeight="750" rowHeight="110" styleName="gridStyle" textAlign="center">');
 			layoutStr.push('		<columns>');
 			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('mfc_bizrnm')+"&lt;br&gt;("+fn_text('ctnr_nm')+ ')" width="70%"/>');
 			layoutStr.push('			<DataGridColumn dataField="RTN_DT" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('rtrvl_dt')+"&lt;br&gt;("+fn_text('rtn_qty2')+ ')" width="30%"/>');
 			layoutStr.push('		</columns>');
 			layoutStr.push('	</DataGrid>');
 			layoutStr.push('    <Style>');
 			layoutStr.push('		.gridStyle {');
 			layoutStr.push('			headerColors:#565862,#565862;');
 			layoutStr.push('			headerStyleName:gridHeaderStyle;');
 			layoutStr.push('			verticalAlign:middle;headerHeight:70;fontSize:28;');
 			layoutStr.push('		}');
 			layoutStr.push('		.gridHeaderStyle {');
 			layoutStr.push('			color:#ffffff;');
 			layoutStr.push('			fontWeight:bold;');
 			layoutStr.push('			horizontalAlign:center;');
 			layoutStr.push('			verticalAlign:middle;');
 			layoutStr.push('		}');
 			layoutStr.push('    </Style>');
 			layoutStr.push('</rMateGrid>');
 		};

 	/**
 	 * 조회기준-생산자 그리드 이벤트 핸들러
 	 */
 	function gridReadyHandler(id) {
 		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
 		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
 		gridApp.setLayout(layoutStr.join("").toString());
 		
 		var layoutCompleteHandler = function(event) {
 			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
 			dataGrid.addEventListener("change", selectionChangeHandler);
 			
 			gridApp.setData(initList2);
 		}
 		var dataCompleteHandler = function(event) {
 			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
 		}
 		var selectionChangeHandler = function(event) {
 			var rowIndex = event.rowIndex;
 			var columnIndex = event.columnIndex;
 			rowIndexValue = rowIndex;
 			fn_rowToInput(rowIndex);
 		}
 		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
 		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
 	}

 	// labelJsFunction 기능을 이용하여 Quarter 컬럼에 월 분기 표시를 함께 넣어줍니다.
 	// labelJsFunction 함수의 파라메터는 다음과 같습니다.
 	// function labelJsFunction(item:Object, value:Object, column:Column)
 	//	      item : 해당 행의 data 객체
 	//	      value : 해당 셀의 라벨
 	//	      column : 해당 셀의 열을 정의한 Column 객체
 	// 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
 	function convertItem(item, value, column) {
 		
 		var dataField = column.getDataField();
 		
 		if(dataField == "MFC_BIZRNM"){
 			return item["MFC_BIZRNM"] + "</br>(" + item["CTNR_NM"] + ")";
 		}
 		else if(dataField == "RTN_DT"){
 			return kora.common.formatter.datetime(item["RTN_DT"], "yyyy-mm-dd") + "</br>(" + kora.common.format_comma(item["RTN_QTY"]) + ")";
 		}
 		else {
 			return "";
 		}
 	}
 	
 /****************************************** 그리드 셋팅 끝******************************************/


</script>

<style>
	.contbox .boxed.v2 .sort {width: 190px;}
	.contbox .boxed.v2 .cont {width: 440px;}
</style>

</head>
<body>

  	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="ctnr_se_list" value="<c:out value='${ctnr_se}' />" />
	<input type="hidden" id="ctnr_seList" value="<c:out value='${ctnr_seList}' />" />
	<input type="hidden" id="ctnr_nm_list" value="<c:out value='${ctnr_nm}' />" />
  	<input type="hidden" id="initList" value="<c:out value='${initList}' />" />
  	<input type="hidden" id="rmk_list" value="<c:out value='${rmk_list}' />" />

	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
				<button class="btn_back" id="btn_cnl"><span class="hide">뒤로가기</span></button>
			</div><!-- id : subvisual -->

			<div id="contents">
			
				<div class="contbox bdn pb40">
					<div class="tbl">
						<table class="txtTable">
							<colgroup>
								<col style="width: 177px;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th id="whsdl_txt"></th>
									<td id="CUST_BIZRNM"></td>
								</tr>
								<tr style="display:none">
									<th id="brch_txt"></th>
									<td id="CUST_BRCH_NM"></td>
								</tr>
								<tr>
									<th id="rtrvl_dt_txt"></th>
									<td id="RTN_DT"></td>
								</tr>
								<tr>
									<th id="car_no_txt"></th>
									<td id="CAR_NO"></td>
								</tr>
								<tr>
									<th id="rtrvl_trgt_mfc_br_txt" rowspan="2"></th>
									<td id="MFC_BIZRNM"></td>
								</tr>
								<tr>
									<td id="MFC_BRCH_NM"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			
				<div class="contbox pb50" id="divInput">
					<div class="box_wrap" style="margin: -20px 0 0">
						<div class="boxed v2">
							<div class="sort" id="ctnr_se_txt"></div>
							<div class="cont">
								<select style="width: 150px;" id="CTNR_SE" class="i_notnull"></select>
								<select style="width: 250px;margin-left:5px" id="PRPS_CD" class="i_notnull"></select>
							</div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="ctnr_nm2_txt"></div>
							<div class="cont">
								<select style="width: 450px;" id="CTNR_CD" class="i_notnull"></select>
							</div>
						</div>
					</div>
					<div class="box_wrap">
						<div class="boxed v2">
							<div class="sort" id="rtl_fee_aplc_yn_br_txt"></div>
							<div class="cont" style="font-size:17pt;color:#222222;font-weight:bold" id="RMK_LIST">
								<input type="radio" id="select_rtl1" name="select_rtl" value="aplc" checked="checked" style="width:30px;height:30px;margin-right:10px"/><span>적용</span>
								<input type="radio" id="select_rtl2" name="select_rtl" value="ext" style="width:30px;height:30px;margin:0 10px 0 10px"/><span>제외</span>
							</div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="rtn_qty_txt"></div>
							<div class="cont"><input type="number" placeholder="직접입력" style="text-align: right;" maxlength="10" id="RTN_QTY" class="i_notnull" format="number"></div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="box_qty_txt"></div>
							<div class="cont"><input type="number" placeholder="직접입력" style="text-align: right;" maxlength="10" id="BOX_QTY" class="i_notnull" format="number"></div>
						</div>
					</div>
					<div class="box_wrap">
						<div class="boxed v2">
							<div class="sort" id="rmk_txt"></div>
							<div class="cont">
								<select id="RMK_SELECT" style="width: 279px" disabled="disabled"></select>
								<br>
								<input type="text" id="RMK" style="width: 450px;margin-top:5px" maxlength="50" disabled="disabled" />
							</div>
						</div>
					</div>
					<div class="btn_wrap mt10 line">
						<div class="fl_c">
							<button class="btnCircle c2" id="btn_upd">변경</button>
							<button class="btnCircle c1" id="btn_del">삭제</button>
							<button class="btnCircle c3" id="btn_reg2">추가</button>
						</div>
					</div>
				</div>
				
				<div class="tblbox">
					<div class="tbl_inquiry v2">
						<div id="gridHolder"></div> <!-- 그리드 -->
					</div>
					<div class="btn_wrap" style="height:50px">
						<button class="btnCircle c1" id="btn_reg">저장</button>
					</div>
				</div>
				
			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->

</body>
</html>