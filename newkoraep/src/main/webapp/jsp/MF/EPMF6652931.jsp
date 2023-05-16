<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>출고정보 등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javascript" src="/select2/select2.js"></script>
	<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
	<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
	<script type="text/javaScript" language="javascript" defer="defer">
	
    	var ctnr_nm=[]; 					 //빈용기
        var regGbn =true;
    	var mfcSeCdList;  //생산자구분 리스트
    	var INQ_PARAMS;   //파라미터 데이터
    	
    	var toDay = kora.common.gfn_toDay();  // 현재 시간
    	var rowIndexValue ="";
        var ctnr_seList ={};
        var arr 	= new Array(); //생산자 관련
        var arr2 	= new Array(); //직매장 관련
        var arr3 	= new Array(); //거래처 관련
        
        var whsl_chk = {};
		
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');

			$("#WHSDL").append("<option value=''>"+parent.fn_text('cho')+"</option>");
			$('#WHSDL').select2();
			
			//버튼셋팅
			fn_btnSetting();
			
			
			mfcSeCdList = jsonObject($("#mfcSeCdList_list").val());  //생산자구분 리스트
	    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());   //파라미터 데이터
	    	rtc_dt_list = jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	

			
			
			//출고 상태 구분
			var dlivy_stat_se = jsonObject($("#dlivy_stat_se").val());	
			kora.common.setEtcCmBx2(dlivy_stat_se, "","", $("#DLIVY_SE"), "ETC_CD", "ETC_CD_NM", "N" ,'D');	//상태
			
			
			//날짜 셋팅
		    $('#DLIVY_DT').YJcalendar({  
				triggerBtn : true,
				dateSetting: kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
		
		  	//text 셋팅
		  	
			$('#dlivy_mfc_sel').text(parent.fn_text('dlivy_mfc_sel'));    //출고 생산자 선택
			$('#dlivy_dt').text(parent.fn_text('dlivy_dt'));              //출고일자
			$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));		  //직매장/공장
			$('#dlivy_se').text(parent.fn_text('dlivy_se'));     		  //출고구분
			$('#cust').text(parent.fn_text('cust'));				 	  //판매처
			$('#whsdl').text(parent.fn_text('whsdl'));					  //도매업자
			$('#cust_bizr_no').text(parent.fn_text('cust_bizr_no'));	  //판매처사업자번호
			$('#cust_nm').text(parent.fn_text('cust_nm'));                //판매처명
			$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));				  //빈용기명
			$('#dlivy_qty').text(parent.fn_text('dlivy_qty'));			  //출고량
			$('#rmk').text(parent.fn_text('rmk'));						  //비고
			$('#sn').text(parent.fn_text('sn'));						  //순번
			$('#total').text(parent.fn_text('total'));					  //소계
			$('#cntr').text(parent.fn_text('cntr'));					  //빈용기
			
			//작성체크용
			$('#MFC_BIZRNM').attr('alt', parent.fn_text('mfc_bizrnm'));
			$('#DLIVY_DT').attr('alt', parent.fn_text('dlivy_dt'));
			$('#MFC_BRCH_NM').attr('alt', parent.fn_text('mfc_brch_nm'));
			$('#DLIVY_SE').attr('alt', parent.fn_text('dlivy_se'));
			$('#CTNR_NM').attr('alt', parent.fn_text('ctnr_nm'));
			$('#DLIVY_QTY').attr('alt', parent.fn_text('dlivy_qty'));
			
	      
			/************************************
			 * 출고생산자 구분 변경 이벤트
			 ***********************************/
			$("#MFC_BIZRNM").change(function(){
				fn_mfc_bizrnm();
			});
			
			/************************************
			 * 직매장/공장 구분 변경 이벤트
			 ***********************************/
			$("#MFC_BRCH_NM").change(function(){
				fn_mfc_brch_nm();
			});
			
		    /************************************
			 * 출고구분 변경 이벤트
			 ***********************************/
			$("#DLIVY_SE").change(function(){
				// 기증주일 경우 직접입력만 가능
				if ($(this).val() == "G") {
					alertMsg("기증주는 도매업자 선택이 불가능합니다.");
					$("#selectCust2").prop("checked", "checked").trigger("change");
					$('input[name=selectCust]').attr("disabled",true);
					
				} else {
					$('input[name=selectCust]').removeAttr("disabled");
				}
			});
			
			/************************************
			 * 판매처 선택 박스 변경 이벤트
			 ***********************************/
			 //$("#CUST_BIZR_NO").attr("disabled",true).attr("readonly",false); //판매처번호 입력 금지
		     //$("#CUST_NM").attr("disabled",true).attr("readonly",false); //판매처명 입력 금지
		     
			 $("#CUST_SEL").change(function(){
				
			    //판매처 입력 선택
		        var CUST_SEL_CK = $("input[type=radio][name=selectCust]:checked").val();
				
			    if(CUST_SEL_CK=="Y"){
					
				  	//$("#CUST_BIZR_NO").attr("disabled",true).attr("readonly",false); //판매처번호 입력불가로 전환
			        //$("#CUST_NM").attr("disabled",true).attr("readonly",false); //판매처명 입력불가로 전환
			        
			        $("#CUST_BIZR_NO").val(""); //판매처번호 빈값으로
					$("#CUST_NM").val("");  //판매처명 빈값으로
					  
					//$("#WHSDL").attr("disabled",false).attr("readonly",true); //선택 가능하게
					
					$('#cust_y').attr('style', '');
					$('#cust_n1').attr('style', 'display:none');
					$('#cust_n2').attr('style', 'display:none');
					
				  }else if(CUST_SEL_CK=="N"){
					  
					  $("#WHSDL").select2("val",""); //도매업자 선택 초기상태로
					  
					  //$("#WHSDL").attr("disabled",true).attr("readonly",false);
					  
					  $("#CUST_BIZR_NO").val(""); //판매처번호 빈값으로
					  $("#CUST_NM").val("");  //판매처명 빈값으로
					  
					  //$("#CUST_BIZR_NO").attr("disabled",false).attr("readonly",false);
				      //$("#CUST_NM").attr("disabled",false).attr("readonly",false);
				      
				      $('#cust_y').attr('style', 'display:none');
					  $('#cust_n1').attr('style', '');
					  $('#cust_n2').attr('style', '');
				  }
			 });
			
			/************************************
			 * 도매업자 변경 이벤트
			 ***********************************/
			 $("#WHSDL").change(function(){
				 fn_whsdl_nm();
			 });
			 
			
			/************************************
			 * 날짜  클릭시 - 삭제 변경 이벤트
			 ***********************************/
			$("#DLIVY_DT").click(function(){
			     var start_dt = $("#DLIVY_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#DLIVY_DT").val(start_dt);
			});
			 
			/************************************
			 * 날짜  클릭시 - 추가 변경 이벤트
			 ***********************************/
			$("#DLIVY_DT").change(function(){
			     var start_dt = $("#DLIVY_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				 if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#DLIVY_DT").val(start_dt);
				
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
				}else if( $("#MFC_BIZRNM").val() !="") {
					$("#MFC_BIZRNM").prop("disabled",true);
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
			
	
			fnSetGrid1();  //그리드 셋팅
			
			$("#MFC_BIZRNM  option").remove();
			//생산자구분
			kora.common.setEtcCmBx2(mfcSeCdList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'E');
			
			//생산자 선택 조회
			fn_mfc_bizrnm();
			
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
	     	var url 		= "/MF/EPMF6652931_195.do";
	     	var flag 	= false;
	     	var dup_cnt 		= 0;		//동일한 용기코드 + 생산자 + 지사가 있을경우
	    	var err_cnt 		= 0;		//잘못된 데이터로 디비 정보가 없을 경우
	    	var err_msg = "";
	    	var err_msg2 = "";
	     	
	    	 for(var i=0; i<rtnData.length ;i++) {

	    		 if(
	    			rtnData[i].출고일자 =="" ||
	    			rtnData[i].직매장공장번호 =="" ||
	    			rtnData[i].출고구분 =="" ||
	    			rtnData[i].판매처사업자번호 =="" ||
	    			rtnData[i].판매처명 =="" ||
	    			rtnData[i].빈용기코드 =="" ||
	    			rtnData[i].출고량 ==""
	    		  ){
	    			alertMsg("필수입력값이 없습니다.")
	    			return;
	    		 }
	    	 }
	    	
	    	 var mfc_bizr_val = $("#MFC_BIZRNM").val().split(';');
	    	 var mfc_bizrid = mfc_bizr_val[0];
	    	 var mfc_bizrno = mfc_bizr_val[1];
	    	 
	     	 for(var i=0; i<rtnData.length ;i++) {
	     		 
	     		flag= false
	     		input["MFC_BIZRID"]		= mfc_bizrid;
	     		input["MFC_BIZRNO"]		= mfc_bizrno;
	     		input["DLIVY_DT"]			= rtnData[i].출고일자
	     		if(!kora.common.fn_validDate_ck( "R", input["DLIVY_DT"])){ 		//등록일자제한 체크
	    			return;
	    		} 
	     		input["MFC_BRCH_NO"]	= rtnData[i].직매장공장번호
	     		input["CUST_BIZRNO"]		= rtnData[i].판매처사업자번호
	     		input["CUST_BIZRNM"]		= rtnData[i].판매처명
	     		input["CTNR_CD"]			= rtnData[i].빈용기코드
	     		input["DLIVY_QTY"]			= rtnData[i].출고량
	     		input["DLIVY_SE_NM"]		= kora.common.null2void(rtnData[i].출고구분)
	     		input["RMK"]					= kora.common.null2void(rtnData[i].비고)
	     		
	     		console.log("111"+";;"+input["CUST_BIZRNO"]);
	     		//사업자번호 체크
	     		if(!kora.common.gfn_bizNoCheck(input["CUST_BIZRNO"])){
	     			err_cnt++
					continue;
				}
	     		console.log("222");
	     		/*
	     		//출고량이 마이너스일때 비고 필수
	     		if(Number(input["DLIVY_QTY"]) < 0 && input["RMK"] == ''){
	     			err_cnt++
					continue;
		 		}
	     		*/
	     		if(input["DLIVY_SE_NM"] == '반품' && Number(input["DLIVY_QTY"]) > 0){ //반품일경우 무조건 마이너스 등록
	     			err_cnt++
					continue;
	     		}else if(input["DLIVY_SE_NM"] != '반품' && Number(input["DLIVY_QTY"]) < 0){ //반품이외에는 무조건 플러스 등록
	     			err_cnt++
					continue;
	     		}

	     		  ajaxPost(url, input, function(rtnData) {
	     			  	
	     			  debugger;
	    				if ("" != rtnData && null != rtnData) {   
		    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
		    						var collection = gridRoot.getCollection();  //그리드 데이터
								    for(var i=0; i<collection.getLength(); i++) {
								    	var gridData = gridRoot.getItemAt(i);
									    	if( gridData.DLIVY_DT.replace(/\-/g,"") == input["DLIVY_DT"]
									    		&& gridData.MFC_BRCH_NO == input["MFC_BRCH_NO"]
									    		&& gridData.CUST_BIZR_NO == input["CUST_BIZRNO"]
									    		&& gridData.CTNR_CD == input["CTNR_CD"]
									    	    && gridData.DLIVY_SE_NM == input["DLIVY_SE_NM"]
									    	 ){
									    		flag = true; 
									    		dup_cnt++;
									    		break;
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
		
		//출고 생산자 변경시
	    function fn_mfc_bizrnm(){
			var url = "/MF/EPMF6652931_192.do" 
			var input = {};
			var mfc_bizrnm	= $("#MFC_BIZRNM").val(); 	 //출고 생산자
			
			ctnr_nm = [];
			
			if(mfc_bizrnm == undefined || mfc_bizrnm == ''){
				
				$("#MFC_BRCH_NM").children().remove();
				$("#MFC_BRCH_NM").append("<option value=''>"+parent.fn_text('cho')+"</option>");
				$("#MFC_BRCH_NM").val('');
				
				$("#CTNR_NM").children().remove();
				$("#CTNR_NM").append("<option value=''>"+parent.fn_text('cho')+"</option>");
				$("#CTNR_NM").val('');
				
				arr[0] = '';
				arr[1] = '';
				
			}else{
			
				arr = mfc_bizrnm.split(";"); 
				
				input["BIZRID"] 		    	= arr[0];	//생산자 아이디
				input["BIZRNO"]				= arr[1];	//생산자 번호				
				input["DLIVY_DT"] 			= $("#DLIVY_DT").val(); 		//출고일자
				   
				if( $("#MFC_BIZRNM").val() ==""){
					input = fn_init2();
					input["BIZRID"] = "";
					input["BIZRNO"] = "";
				}
				
			 	ajaxPost(url, input, function(rtnData) {
					if ("" != rtnData && null != rtnData) {   
						 ctnr_nm = rtnData.ctnr_nm
						 kora.common.setEtcCmBx2(rtnData.brch_dtssList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');//출고대상 직매장/공장		
						 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기명
					}else{
						 alertMsg("error");
					}
				}, false);
		 	
			}
		
		}
		
	    //출고일자 변경시 빈용기명 재조회
	    function fn_ctnr_cd(){
			var url = "/MF/EPMF6652931_196.do" 
			var input = {};
			var mfc_bizrnm	= $("#MFC_BIZRNM").val(); 	 //출고 생산자
			
			ctnr_nm = [];
			
			if(mfc_bizrnm == undefined || mfc_bizrnm == ''){

				$("#CTNR_NM").children().remove();
				$("#CTNR_NM").append("<option value=''>"+parent.fn_text('cho')+"</option>");
				$("#CTNR_NM").val('');
				
				arr[0] = '';
				arr[1] = '';
				
			}else{
			
				arr = mfc_bizrnm.split(";"); 
				
				input["BIZRID"] 		    	= arr[0];	//생산자 아이디
				input["BIZRNO"]				= arr[1];	//생산자 번호
				input["DLIVY_DT"] 			= $("#DLIVY_DT").val(); 		//출고일자

			 	ajaxPost(url, input, function(rtnData) {
					if ("" != rtnData && null != rtnData) {   
						 ctnr_nm = rtnData.ctnr_nm;
						 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기명
					}else{
						 alertMsg("error");
					}
				}, false);
		 	
			}
		
		}
		
		 var whsdl_combo; 
		 //직매장/공장 변경시
		 function fn_mfc_brch_nm(){
			 var url = "/MF/EPMF6652931_193.do" 
			 var input = {};
			 var mfc_brch_nm = $("#MFC_BRCH_NM").val(); 	 	 //직매장/공장

			 if(mfc_brch_nm == undefined || mfc_brch_nm == ''){
				 
				 $("#WHSDL").children().remove();
				 $("#WHSDL").append("<option value=''>"+parent.fn_text('cho')+"</option>");
				 $("#WHSDL").select2("val","");
				 
				 arr2[0] = '';
				 arr2[1] = '';
				 
			 }else{
			 
			   arr2 = mfc_brch_nm.split(";");    	 //직매장/공장 정보넣기

			   input["MFC_BIZRID"] 			= arr[0];    //생산자ID
			   input["MFC_BIZRNO"]			= arr[1];    //생산자번호
			   
			   input["MFC_BRCH_ID"]			= arr2[0];    //생산자지점 ID(직매장)
			   input["MFC_BRCH_NO"]			= arr2[1];    //생산자지점 번호(직매장)
			   
			   if( $("#MFC_BRCH_NM").val() ==""){
				   input = fn_init2();
				   input["MFC_BRCH_ID"] = "";
				   input["MFC_BRCH_NO"] = "";
			   }
		
	       	   ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {
    					whsdl_combo = rtnData.whsdl
    					 kora.common.setEtcCmBx2(rtnData.whsdl, "","", $("#WHSDL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" , "S"); //출고대상 직매장/공장
    					 $("#WHSDL").select2("val", $("#WHSDL").val()); //도매업자 선택 초기상태로
    				}else{
    					 alertMsg("error");
    				}
	    		}, false);
	       	   
			 }
			 
		  }
		 
		 //도매업자 변경시
		 function fn_whsdl_nm(){
			 /*
			 var input = {};
			 whsdl = $("#WHSDL").val();
			 arr3 = [];
			 
			 if($("#WHSDL").val()!=""){
				 
				 arr3	= whsdl.split(";");
				 
			 }else{
				 arr3[0] ="";
				 arr3[1] ="";
			 }
			 
			 input["MFC_BRCH_ID"]			= arr2[0];    //생산자지점 ID(직매장)
			 input["MFC_BRCH_NO"]			= arr2[1];    //생산자지점 번호(직매장)
			 */
		}
		
		 //판매처 입력값 확인
		 function fn_cust_sel_ck_se(){
			 var CUST_SEL_CK = $("input[type=radio][name=selectCust]:checked").val();
		 		
		 		if(CUST_SEL_CK=="Y"){
					if($("#WHSDL").val() ==""){
			 			alertMsg(parent.fn_text('whsdl')+parent.fn_text('cfm_chk'));
			 			return false;
			 		}
		 		}else if(CUST_SEL_CK=="N"){
		 			
		 			if($("#CUST_BIZR_NO").val() ==""){
			 			alertMsg(parent.fn_text('cust_bizr_no')+parent.fn_text('cfm_chk'));
			 			return false;
			 		}
		 			if($("#CUST_NM").val()==""){
						alertMsg(parent.fn_text('cust_nm')+parent.fn_text('cfm_chk'));
						return false;
		 			}
		 			
		 			if(!kora.common.gfn_bizNoCheck($('#CUST_BIZR_NO').val())){
						alertMsg("정상적인 사업자등록번호가 아닙니다.");
						$('#CUST_BIZR_NO').focus();
						return false; 
					}
		 		}
		 		
		 		if($('#DLIVY_QTY').val() == '0'){
		 			alertMsg("출고량(개)  을(를) 확인하세요.");
					$('#DLIVY_QTY').focus();
					return false;
		 		}
		 		
		 		if(Number($('#DLIVY_QTY').val().replace(/\,/g,"")) < 0 && $('#RMK').val() == ''){
		 			alertMsg("출고량 마이너스 입력 시 비고 작성은 필수입니다.");
					$('#RMK').focus();
					return false;
		 		}
		 		
		 		return true;
		 }
		
	    //행추가
	 	function fn_reg2(){
	    	 	    	
	 		if(!kora.common.cfrmDivChkValid("divInput1") || !kora.common.cfrmDivChkValid("divInput2")) {
	 			return;
	 		}
	 		
	 		//판매처 확인
	 		if(!fn_cust_sel_ck_se()){
	 			return;
	 		}
	 		
	 		if(!kora.common.gfn_isDate($("#DLIVY_DT").val())){
	 			alertMsg(parent.fn_text('date_chk'));
	 			return;
	 		}
	 		
	 		if( $("#MFC_BIZRNM").val() !="") {
	 			$("#MFC_BIZRNM").prop("disabled",true);
	 		} 
	 		
	 		regGbn 		=	false;
	 		var input 	=	insRow("A");
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
	 		
	 		if(!kora.common.cfrmDivChkValid("divInput1") || !kora.common.cfrmDivChkValid("divInput2")) {
	 			return;
	 		}
	 		
	 		//판매처 확인
	 		if(!fn_cust_sel_ck_se()){
	 			return;
	 		}
	 		
	 		//날짜 정합성 체크. 20160204
	 		if(!kora.common.fn_validDate($("#DLIVY_DT").val())){ 
	 			alertMsg(parent.fn_text('date_chk')); 
	 			return; 
	 		}
	 		regGbn 		=	false;
	 		var item = insRow("M");
	 		
	 		// 해당 데이터의 이전 수정내역을 삭제
	 		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
	 		
	 		//해당 데이터 수정
	 		gridRoot.setItemAt(item, idx);
	 	}
	 	 
	 	 function fn_del_chk(){
	 		 fn_del();
	 	 }
	 	 
	 	//행삭제
	 	function fn_del(){
	 		var idx = dataGrid.getSelectedIndex();
	 		var collection = gridRoot.getCollection();  //그리드 데이터

	 		if(idx < 0) {
	 			alertMsg(parent.fn_text('del_row_cho'));
	 			return;
	 		}
	 		regGbn 		=	false;
	 		gridRoot.removeItemAt(idx);
	 		
	 		if(collection.getLength()!=[]){
	 			//생산자 선택 불가능
    			$("#MFC_BIZRNM").attr("disabled",true).attr("readonly",false);
    		}else{
    			//생산자 선택 가능
    			$("#MFC_BIZRNM").attr("disabled",false).attr("readonly",true);
    		}
	 		
	 	}
	 	 
	 	//행변경 및 행추가 시 그리드 셋팅
	 	insRow = function(gbn) {
	 		
	 		if($("#DLIVY_SE").val() == 'R' && Number($("#DLIVY_QTY").val().replace(/\,/g,"")) > 0 ){ //반품
	 		    alertMsg("출고구분이 반품일 경우 출고량은 마이너스로 등록해야 합니다.");
	 			return;
	 		}
	 		
            if($("#DLIVY_SE").val() != 'R' && Number($("#DLIVY_QTY").val().replace(/\,/g,"")) < 0 ){ //반품이 아닌경우
        	    alertMsg("출고량 마이너스 입력은 출고구분이 반품인 경우에만 합니다.");
                return;
            }

            var input = {};
	 		var ctnrCd = $("#CTNR_NM").val();
	 		var CUST_SEL_CK = $("input[type=radio][name=selectCust]:checked").val();

	 		if(!kora.common.fn_validDate_ck( "R", $("#DLIVY_DT").val())){ //등록일자제한 체크
				return;
			}
	 		
	 		var mfc_brch_nm	= $("#MFC_BRCH_NM").val(); 	 	 //직매장/공장
	 		if(mfc_brch_nm != undefined){
	 			arr2 = mfc_brch_nm.split(";");    	 //직매장/공장 정보넣기
	 		}else{
	 			arr2[0] ="";
	 			arr2[1] ="";
			}
			
	 		
	 		var whsdl = $("#WHSDL").val(); 	 //도매업자
	 		if(whsdl != undefined){
		 		arr3 = whsdl.split(";");    	 	 //정보넣기
	 		}else{
				 arr3[0] ="";
				 arr3[1] ="";
			}
	 		
	 		
	 		
		 	var collection = gridRoot.getCollection();  //그리드 데이터

	 	    for(var i=0; i<ctnr_nm.length; i++){  //빈용기리스트 가져오면
				
				if(ctnr_nm[i].CTNR_CD == ctnrCd) {
					
						if(ctnrCd.substr(3,2) == "00"){
					    	input["STANDARD_NM"] 					= 	"표준용기";	
					    }else{
					    	input["STANDARD_NM"] 					= 	"비표준용기";	
					    }
					
						input["DLIVY_DT"]			= $("#DLIVY_DT").val();                      //출고일자
					    input["MFC_BIZRNM"] 		= $("#MFC_BIZRNM option:selected").text();   //생산자
					    input["MFC_BRCH_NM"] 	= $("#MFC_BRCH_NM option:selected").text();  //직매장/공장
					    
					    input["CUST_SEL_CK"] = CUST_SEL_CK;
					    if(CUST_SEL_CK=="Y"){
					    	
					    	var whsdl_de;
						    var whsdl_brch_id;
						    var whsdl_brch_no;
						    for(var k=0; k<whsdl_combo.length; k++){ 
						    	if(whsdl_combo[k].CUST_BIZRID_NO ==  $("#WHSDL option:selected").val() ){
						    		whsdl_de = whsdl_combo[k].CUST_BIZRNO_DE;
						    		whsdl_brch_id = whsdl_combo[k].CUST_BRCH_ID;
								    whsdl_brch_no = whsdl_combo[k].CUST_BRCH_NO;
						    	}
						    }
					    	
						    input["CUST_BRCH_ID"]		= whsdl_brch_id;
						    input["CUST_BRCH_NO"]		= whsdl_brch_no;
					    	input["CUST_BIZR_NO"] 		= whsdl_de;   			 //거래처사업자번호 - decrypt
						    input["CUST_NM"] 				= $("#WHSDL option:selected").text();  //판매처명
						    input["CUST_BIZRNM"] 		= $("#WHSDL option:selected").text();	//거래처 명
						    input["REG_CUST_NM"] 		= $("#WHSDL option:selected").text();  //등록거래처명
						    
						    input["CUST_BIZRID"] 			= arr3[0];			//거래처사업자ID
						    input["CUST_BIZRNO"] 		= arr3[1];			//거래처사업자등록번호
						    
					    }else{
					    	
					    	input["CUST_BRCH_ID"] 	 	= "9999999999";		//거래처지점ID
						    input["CUST_BRCH_NO"] 		= "9999999999";		//거래처지점번호
						    input["CUST_BIZR_NO"] 		= $("#CUST_BIZR_NO").val();  				 //판매처사업자번호
						    input["CUST_NM"] 				= $("#CUST_NM").val();						 //판매처명
						    input["CUST_BIZRNM"] 		= $("#CUST_NM").val();						 //거래처 명
						    input["REG_CUST_NM"] 		= $("#CUST_NM").val();					     //등록거래처명
						    
						    input["CUST_BIZRID"] 			= '';
						    input["CUST_BIZRNO"] 		= $("#CUST_BIZR_NO").val();			//거래처사업자등록번호
					    }
					    
					    input["CTNR_NM"] 			= $("#CTNR_NM option:selected").text();		 //빈용기명
					    input["CTNR_CD"] 			= $("#CTNR_NM").val();		 				 //빈용기 코드
					    input["CTNR_NM"] 			= $("#CTNR_NM option:selected").text();   	 //빈용기명
			 		    input["PRPS_SE"] 			= ctnr_nm[i].CPCT_NM1;						 //용도
					    input["CPCT_CD"] 			= ctnr_nm[i].CPCT_NM2;						 //용량
					    input["DLIVY_QTY"] 		= $("#DLIVY_QTY").val().replace(/\,/g,"");					 //출고량
					    input["DPS"] 					= ctnr_nm[i].STD_DPS;				 		 //단가

					    input["DLIVY_SE_NM"] 		= $("#DLIVY_SE option:selected").text();	 //출고구분
					    input["RMK"] 					= $("#RMK").val();							 //비고
					    input["DLIVY_STAT_CD"] 	= "RG";							 			 //출고상태코드(RG고정)
					    
					    input["DLIVY_GTN"] 		= ctnr_nm[i].STD_DPS*$("#DLIVY_QTY").val().replace(/\,/g,"");  //출고보증금(소계)
					    
					    //중복검사 체크용
					    input["MFC_BIZRID"] 				= arr[0];	//생산자 아이디
					    input["MFC_BIZRNO"] 				= arr[1];	//생산자 번호
					    input["MFC_BRCH_ID"] 			= arr2[0];    //생산자지점 ID(직매장)
					    input["MFC_BRCH_NO"] 			= arr2[1];    //생산자지점 번호(직매장)
					    input["DLIVY_SE"] 					= $("#DLIVY_SE").val();	 //출고구분
					    
				}
			}
		 	
	 	   for(var i=0; i<collection.getLength(); i++) {
	 	    	var tmpData = gridRoot.getItemAt(i);
	 	    	if( tmpData.MFC_BIZRID == input["MFC_BIZRID"] && 
	 	    		tmpData.MFC_BIZRNO == input["MFC_BIZRNO"] && 
	 	    		tmpData.MFC_BRCH_ID == input["MFC_BRCH_ID"] && 
	 	    		tmpData.MFC_BRCH_NO == input["MFC_BRCH_NO"] && 
	 	    		tmpData.CUST_BIZRID == input["CUST_BIZRID"] && 
	 	    		tmpData.CUST_BIZRNO == input["CUST_BIZRNO"] && 
	 	    		tmpData.CUST_BRCH_ID == input["CUST_BRCH_ID"] && 
	 	    		tmpData.CUST_BRCH_NO == input["CUST_BRCH_NO"] && 
	 	    		tmpData.CTNR_CD == input["CTNR_CD"] && 
	 	    		tmpData.DLIVY_DT == input["DLIVY_DT"] &&
	                tmpData.DLIVY_SE == input["DLIVY_SE"]	 	    	
	 	    	  ) {
	 				if(gbn == "M") {
	 					if(rowIndexValue != i) {
	 			    		alertMsg(parent.fn_text('dup001'));
	 			    		return false;
	 			    	}
	 				} else {
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
	    	 
	    	 var collection = gridRoot.getCollection();  //그리드 데이터

	 		 if(0 != collection.getLength()){
	 			 
	 			 confirm('저장하시겠습니까?', 'fn_reg_exec');

			}else{
				alertMsg("등록할 자료가 없습니다.\n\n자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 다음 등록 버튼을 클릭하세요.");
			}
		 
		}
		
		function fn_reg_exec(){
			
			var data = {"list": ""};
	 		var row = new Array();
	 		var url = "/MF/EPMF6652931_09.do";
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
			}, false);
			
		}
	     
	     function fn_init2(){
	    	 var input ={};
			   input["DLIVY_DT"] 		= "";    	//출고일자    
			   input["MFC_BIZRNM"] 		= "";    	//생산자  
			   input["MFC_BRCH_NM"] 	= "";     	//직매장/공장    
			   input["CUST_BIZR_NO"] 	= "";		//판매처사업자번호
			   input["CUST_NM"] 		= "";		//판매처명
			   input["CTNR_NM"] 		= "";		//빈용기명
			   input["PRPS_SE"] 		= "";		//용도
			   input["CPCT_CD"] 		= "";		//용량
			   input["DLIVY_QTY"]		= "";		//출고량
			   input["DLIVY_GTN"] 			= "";		//소계
			   input["DPS"] 			= "";		//단가 
			   input["DLIVY_SE"] 		= "";		//출고구분 
			   input["RMK"]				= "";  		//비고
			   
	    	return input
	     }
	    
	   		//선택한 행 입력창에 값 넣기
		 	function fn_rowToInput (rowIndex){
		 		var item = gridRoot.getItemAt(rowIndex);

		 		$("#DLIVY_DT").val(item["DLIVY_DT"]);  //일자
		 		fn_ctnr_cd();
		 		
		 		$("#MFC_BRCH_NM").val(item["MFC_BRCH_ID"]+";"+item["MFC_BRCH_NO"]);    //직매장/공장 이름
		 		fn_mfc_brch_nm(); //직매장 변경 이벤트 펑션

		 		$("#DLIVY_SE").val(item["DLIVY_SE"]).prop("selected", true);    //출고구분
		 		$("#DLIVY_SE").trigger("change");
		 		
		 		$("#WHSDL").select2("val", item["CUST_BIZRID"]+";"+item["CUST_BIZRNO"]); //도매업자
		 		
		 		$("#CTNR_NM").val(	item["CTNR_CD"]).prop("selected", true);    //빈용기명
		 		$("#DLIVY_QTY").val(item["DLIVY_QTY"]);  //출고량
		 		$("#DLIVY_QTY").val(kora.common.format_comma($("#DLIVY_QTY").val()));
		 		
		 		$("#RMK").val(item["RMK"]);            //비고
		 		
		 		$("#CUST_NM").val(item["CUST_NM"]);
		 		$("#CUST_BIZR_NO").val(item["CUST_BIZR_NO"]);
		 		
		 		$(':radio[name="selectCust"][value="' + item["CUST_SEL_CK"] + '"]').prop("checked", true);
		 		if(item["CUST_SEL_CK"] == undefined || item["CUST_SEL_CK"] == 'Y'){
		 			  $('#cust_y').attr('style', '');
					  $('#cust_n1').attr('style', 'display:none');
					  $('#cust_n2').attr('style', 'display:none');
		 		}else{
		 			  $('#cust_y').attr('style', 'display:none');
					  $('#cust_n1').attr('style', '');
					  $('#cust_n2').attr('style', '');
		 		}
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
				layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
				layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
				layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
				layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35">');
				layoutStr.push('		<groupedColumns>');
				layoutStr.push('			<DataGridColumn dataField="index"       	headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" textAlign="center" width="50"  />');	        //순번
				layoutStr.push('			<DataGridColumn dataField="DLIVY_DT"		headerText="'+ parent.fn_text('dlivy_dt')+ '"  textAlign="center" width="150"   formatter="{datefmt2}"/>'); 	//출고일자
				layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" 		headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  textAlign="center" width="100" />');							//생산자
				layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM" 	headerText="'+ parent.fn_text('mfc_brch_nm')+ '" textAlign="center" width="100"  />');							//직매장/공장
				layoutStr.push('			<DataGridColumn dataField="CUST_BIZR_NO"  	headerText="'+ parent.fn_text('cust_bizr_no')+ '" textAlign="center" width="150"  formatter="{maskfmt1}"/>');							//판매처사업자번호
				layoutStr.push('			<DataGridColumn dataField="CUST_NM"  		headerText="'+ parent.fn_text('cust_nm')+ '" textAlign="center" width="110" />');								//판매처명
				layoutStr.push('			<DataGridColumn dataField="CTNR_NM" 		headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="center" width="200" />');								//빈용기명
				layoutStr.push('			<DataGridColumn dataField="PRPS_SE"  		headerText="'+ parent.fn_text('prps_cd')+ '" textAlign="center" width="100" />');								//용도(유흥용/가정용)
				layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="100" textAlign="center"  />');
				layoutStr.push('			<DataGridColumn dataField="CPCT_CD"  		headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+ '" textAlign="center" width="100" />');						//용량(ml)
				layoutStr.push('			<DataGridColumn dataField="DLIVY_QTY" id="num1"  headerText="'+ parent.fn_text('dlivy_qty')+ '" width="90" formatter="{numfmt}" textAlign="right" />');		//출고량(개)
				layoutStr.push('			<DataGridColumnGroup  						headerText="'+ parent.fn_text('cntr')+ parent.fn_text('dps')+'">');																//빈용기보증금(원)																		
				layoutStr.push('				<DataGridColumn dataField="DPS"     	headerText="'+ parent.fn_text('utpc')+ '"  width="80" formatter="{numfmt}" textAlign="right" />');				//단가
				layoutStr.push('				<DataGridColumn dataField="DLIVY_GTN" id="num2"  headerText="'+ parent.fn_text('total')+ '"  width="100" formatter="{numfmt}" textAlign="right" />');			//소계
				layoutStr.push('			</DataGridColumnGroup>');
				layoutStr.push('			<DataGridColumn dataField="DLIVY_SE_NM"  		headerText="'+ parent.fn_text('dlivy_se')+ '" textAlign="center" width="150" />');								//출고구분
				layoutStr.push('			<DataGridColumn dataField="RMK"  			headerText="'+ parent.fn_text('rmk')+ '" textAlign="center" width="50" />');									//비고
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
				layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//상자
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//금액
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('				<DataGridFooterColumn/>');
				layoutStr.push('			</DataGridFooter>');
				layoutStr.push('		</footers>');
				layoutStr.push('	</DataGrid>');
				layoutStr.push('</rMateGrid>');
			};
	
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

				//출고데이터 있을 시 생산자 선택 막기
				var collection = gridRoot.getCollection();  //그리드 데이터
				
				if(collection.getLength()!=[]){
					//생산자 선택 불가능
	    			$("#MFC_BIZRNM").attr("disabled",true).attr("readonly",false);
	    		}else{
	    			//생산자 선택 가능
	    			$("#MFC_BIZRNM").attr("disabled",false).attr("readonly",true);
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
width: 110px;
}

</style>

</head>
<body>

    <div class="iframe_inner" id="testee" >
    
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
    		<input type="hidden" id="mfcSeCdList_list" value="<c:out value='${mfcSeCdList}' />" />
    		<input type="hidden" id="dlivy_stat_se" value="<c:out value='${dlivy_stat_se}' />" />
    		<input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
	
    
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				
				<div class="singleRow">
					<div class="btn" id="UR"></div>
				</div>
				<!--btn_dwnd  -->
				<!--btn_excel_reg  -->
			</div>

			<section class="secwrap" id="divInput1" style="display:none">
				<div class="srcharea" id="whsl_info"> 
				<div class="row">
						<div class="col">
							<div class="tit" id="dlivy_mfc_sel" ></div>  <!--출고 생산자 선택 -->
							<div class="box">
								<select id="MFC_BIZRNM" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
					</div> <!-- end of row -->
				</div>
			</section>
			<section class="secwrap" >
				<div class="srcharea" id="divInput2" > 
					<div class="row">
						<div class="col">
							<div class="tit" id="dlivy_dt" ></div>  <!-- 출고일자 -->
							<div class="box">
								<div class="calendar">
									<input type="text" id="DLIVY_DT" style="width: 180px;" class="i_notnull" alt=""> <!--시작날짜  -->
								</div>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="mfc_brch_nm"></div>  <!--직매장/공장-->
							<div class="box">
								<select id="MFC_BRCH_NM" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
				
					    <div class="col">
							<div class="tit" id="dlivy_se" ></div>  <!-- 출고구분 -->
							<div class="box">
								<select id="DLIVY_SE" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
					</div> <!-- end of row -->
					
					<div class="row">
						<div class="col">
							<div class="tit" id="cust" ></div>   <!-- 판매처 입력 선택-->
							<div class="box" id="CUST_SEL" style="width:179px">
								<label class="rdo"><input type="radio" id="selectCust1" name="selectCust" value="Y" checked="checked"/><span id="">선택</span></label>
								<label class="rdo"><input type="radio" id="selectCust2" name="selectCust" value="N"/><span id="">직접입력</span></label>
							</div>
						</div>
						
						<div class="col" id="cust_y">
							<div class="tit" id="whsdl"></div>  <!-- 도매업자 -->
							<div class="box">
								<select id="WHSDL" style="width: 179px" ></select>
							</div>
						</div>
							
						<div class="col" id="cust_n1" style="display:none">
							<div class="tit" id="cust_nm"></div>  <!-- 판매처명 -->
							<div class="box">
								<input type="text"  id="CUST_NM" style="width: 179px" maxByteLength="90" />
							</div>
						</div>
						<div class="col" id="cust_n2" style="display:none">
							<div class="tit" id="cust_bizr_no" ></div>  <!-- 판매처사업자번호 -->
							<div class="box">
								<input type="text"  id="CUST_BIZR_NO" style="width: 179px" maxLength="10"/>
							</div>
						</div>	
						
					</div> <!-- end of row -->
					
					<div class="row">
						
						<div class="col">
							<div class="tit" id="ctnr_nm" ></div>  <!-- 빈용기명 -->
							<div class="box">
								<select id="CTNR_NM" style="width: 179px" class="i_notnull" alt=""></select>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="dlivy_qty" ></div>  <!-- 출고량 -->
							<div class="box">
								  <input type="text"  id="DLIVY_QTY" style="width: 179px; text-align:right" class="i_notnull" maxlength="11" format="minus" />
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="rmk" ></div>  <!-- 비고 -->
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
			
			<section class="btnwrap mt10" >
             	<div class="btn" style="float:right" id="BR"></div>
      		</section>
		
</div>

<form name="downForm" id="downForm" action="" method="post">
	<input type="hidden" name="fileName" value="DLIVY_INFO_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>

</body>
</html>
