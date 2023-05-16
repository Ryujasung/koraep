<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고정정등록(건별등록)</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS; 	//파라미터 데이터
	 var iniList;				//상세조회 반환내역서 공급 부분
	 var cfm_gridList;
	 var cfm_gridList2;
	 var crct_gridList;
     var ctnr_se;			//빈용기구분  구병 신병
     var ctnr_seList;		//빈용기구분
     var ctnr_nm; 			//빈용기
     var ctnr_nm_init; 	//빈용기 초기값
     var rmk_list;     		//소매수수료 적용여부 비고
     var rowIndexValue	=	"";
     var rtn_qty_tot		=	0;
     var crct_wrhs_dt_chk 	= "";
     var crct_rtn_dt_chk	 	= "";
     var ctnr_nm_all		//정정반환일자 적용시 구병신병 유흥,가정 직접 다가져오기
     var ctnrCdAll ="";
 
     $(function() {
    
    	INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	
   		iniList			=  jsonObject($("#iniList").val());       
   		cfm_gridList 	=  jsonObject($("#cfm_gridList").val());
   		cfm_gridList2 	=  jsonObject($("#crct_gridList").val());     
   		crct_gridList	=  jsonObject($("#crct_gridList").val());

   		ctnr_se 			=  jsonObject($("#ctnr_se_list").val());      
   		ctnr_seList 	=  jsonObject($("#ctnr_seList").val());	
   		ctnr_nm			=  jsonObject($("#ctnr_nm_init").val());       
   		ctnr_nm_init 	=  jsonObject($("#ctnr_nm_init").val());
   		rmk_list			=  jsonObject($("#rmk_list").val());				//비고	
   		
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
    	 
		//날짜 셋팅
		 $('#CRCT_RTN_DT').YJcalendar({  
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, crct_gridList[0].CRCT_RTN_DT).replaceAll('-','')
				
		 });
		$('#CRCT_WRHS_DT').YJcalendar({
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, iniList[0].WRHS_CFM_DT).replaceAll('-','')
		 });  	
    	 
		/************************************
		 * 빈용기구분 구병 / 신병 변경시 
		 ***********************************/
		$("#CTNR_SE").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 빈용기 구분 변경 이벤트 유흥/가정/직접
		 ***********************************/
		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 빈용기코드 변경 이벤트
		 ***********************************/
		$("#CTNR_CD").change(function(){
			fn_rtn_check();
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
			fn_del_chk();
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
		 *등록 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		/************************************
		 * 취소 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
		/************************************
		 * 정정반환일자 적용버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd2").click(function(){
			confirm("반환일자 변경 시 취급수수료 정보가 변경될 수 있습니다. 계속 진행하시겠습니까?","fn_ck"); 
		});
		
		/************************************
		 * 정정입고확인일자 적용버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd3").click(function(){
			 confirm("입고확인일자를 변경하시겠습니까?","fn_crct_wrhs_dt_chk"); 
		});
		
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#CRCT_RTN_DT").click(function(){
			var start_dt = $("#CRCT_RTN_DT").val();
			start_dt   =  start_dt.replace(/-/gi, "");
			$("#CRCT_RTN_DT").val(start_dt);
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#CRCT_RTN_DT").change(function(){
		    var start_dt = $("#CRCT_RTN_DT").val();
		    start_dt   =  start_dt.replace(/-/gi, "");
			if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
		    $("#CRCT_RTN_DT").val(start_dt) 
		});
		
		/************************************
		 * 끝날짜  클릭시 - 삭제  변경 이벤트
		 ***********************************/
		$("#CRCT_WRHS_DT").click(function(){
			var end_dt = $("#CRCT_WRHS_DT").val();
			end_dt  = end_dt.replace(/-/gi, "");
			$("#CRCT_WRHS_DT").val(end_dt)
		});
		
		/************************************
		 * 끝날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#CRCT_WRHS_DT").change(function(){
		    var end_dt  = $("#CRCT_WRHS_DT").val();
		    end_dt =  end_dt.replace(/-/gi, "");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
		    $("#CRCT_WRHS_DT").val(end_dt) 
		});
		
		fn_init();
	    	
	});
   
     function fn_rtn_check(){
    	 
       	var rtnDataYn = '';
       	$.each(cfm_gridList, function(i, v){
   			if($("#CTNR_CD").val() == v.CTNR_CD){ //반환데이터에 존재하는 용기코드
   				//$('#RTN_QTY').val(v.RTN_QTY);
   				$("#DMGB_QTY").removeAttr("disabled");
   				$("#VRSB_QTY").removeAttr("disabled");	
   				rtnDataYn = 'Y';
   				return;
   			}
   		});
       	
       	if(rtnDataYn == ''){ //반환데이터에 존재하지않는 용기코드
       		//$('#RTN_QTY').val('');
       		$('#DMGB_QTY').val('');
       		$('#VRSB_QTY').val('');
       		$("#DMGB_QTY").prop("disabled",true);
   			$("#VRSB_QTY").prop("disabled",true);	
       	}
       	 
     }
     
    function  fn_init(){
     	
    	//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');				//타이틀
		$('#se').text(parent.fn_text('se'));											//구분
		$('#mtl_nm').text(parent.fn_text('mtl_nm'));								//상호명
		$('#mtl_nm2').text(parent.fn_text('mtl_nm'));							//상호명
		$('#bizrno').text(parent.fn_text('bizrno2'));								//사업자번호
		$('#bizrno2').text(parent.fn_text('bizrno2'));								//사업자번호	
		$('#user_nm').text(parent.fn_text('user_nm'));							//성명
		$('#user_nm2').text(parent.fn_text('user_nm'));						//성명
		$('#addr').text(parent.fn_text('addr'));									//주소
		$('#addr2').text(parent.fn_text('addr'));									//주소
		$('#tel_no').text(parent.fn_text('tel_no2'));								//연락처
		$('#tel_no2').text(parent.fn_text('tel_no2'));								//연락처
		$('#supplier').text(parent.fn_text('supplier'));							//공급자
		$('#receiver').text(parent.fn_text('receiver'));							//공급받는자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));			//직매장									
		$('#car_no').text(parent.fn_text('car_no')); 								//차량번호
		$('#rtrvl_dt').text(parent.fn_text('rtrvl_dt')); 								//반환일자
		$('#ctnr_se').text(parent.fn_text('ctnr_se'));								//빈용기 구분
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));							//빈용기명
		$('#rtn_qty').text(parent.fn_text('rtn_qty')); 			 				//반환량(개)
		$('#dmgb_qty').text(parent.fn_text('dmgb_qty')); 					//결병(개)
		$('#vrsb_qty').text(parent.fn_text('vrsb_qty')); 			 				//잡병(개)
		$('#cfm_qty').text(parent.fn_text('cfm_qty')); 			 				//확인량(개)
		$('#wrhs_crct_data').text('('+parent.fn_text('wrhs_crct_data')+')');//입고확인내역
		$('#rtn_data').text('('+parent.fn_text('rtn_data') +')' ); 			 	//반환내역
		
		$('#doc_no').text(parent.fn_text('doc_no')); 							//문서번호
		$('#rtn_doc_no').text(parent.fn_text('rtn_doc_no')); 					//반환문서번호
		$('#wrhs_doc_no').text(parent.fn_text('wrhs_doc_no')); 				//입고문서번호
		
		$('#crct_wrhs_dt').text(parent.fn_text('crct_wrhs_dt')); 				//정정입고일자
		$('#crct_rtn_dt').text(parent.fn_text('crct_rtn_dt')); 					//정정반환일자
		
		$('#wrhs_cfm_dt').text(parent.fn_text('wrhs_cfm_dt')); 				//입고확인일자
		$('#rtrvl_dt').text(parent.fn_text('rtrvl_dt')); 								//반환일자
		
		//div필수값 alt
		$("#PRPS_CD").attr('alt',parent.fn_text('ctnr_se'));   					//빈용기구분
		$("#CTNR_CD").attr('alt',parent.fn_text('ctnr_nm'));   				//빈용기명
		$("#RTN_QTY").attr('alt',parent.fn_text('rtn_qty'));					//반환량
		
		//데이터 넣기
		$("#RTN_DT")   	  				.text(kora.common.formatter.datetime(iniList[0].RTN_DT, "yyyy-mm-dd"));				//반환일자
		$("#WRHS_CFM_DT")   	  	.text(kora.common.formatter.datetime(iniList[0].WRHS_CFM_DT, "yyyy-mm-dd"));	//입고확인일자
		$("#CAR_NO")          			.text(iniList[0].CAR_NO);																					//차량번호
		$("#MFC_BIZRNM")    			.text(iniList[0].MFC_BIZRNM);																			//생산자명
		$("#MFC_BIZRNO")    			.text(kora.common.setDelim(iniList[0].MFC_BIZRNO, "999-99-99999"));					//생산자 사업자번호
		$("#MFC_RPST_NM") 			.text(iniList[0].MFC_RPST_NM);																		//생산자 대표자
		$("#MFC_RPST_TEL_NO")		.text(iniList[0].MFC_RPST_TEL_NO);																	//생산자 연락처
		$("#MFC_ADDR")      			.text(iniList[0].MFC_ADDR);																				//생산자 주소
		$("#MFC_BRCH_NM")      		.text(iniList[0].MFC_BRCH_NM);																		//생산자 직매장
		$("#WHSDL_BIZRNM")      	.text(iniList[0].WHSDL_BIZRNM);                                                                    	//도매업자명    
		$("#WHSDL_BIZRNO")      	.text(kora.common.setDelim(iniList[0].WHSDL_BIZRNO, "999-99-99999"));              //도매업자 사업자번호                   
		$("#WHSDL_RPST_NM")   		.text(iniList[0].WHSDL_RPST_NM);                                                                   	//도매업자 대표자             
		$("#WHSDL_RPST_TEL_NO")	.text(iniList[0].WHSDL_RPST_TEL_NO);                                                              //도매업자 연락처             
		$("#WHSDL_ADDR")				.text(iniList[0].WHSDL_ADDR);                                                                  		//도매업자 주소   
		$("#RTN_DOC_NO")				.text(iniList[0].RTN_DOC_NO);																			//반환문서번호
		$("#WRHS_DOC_NO")			.text(iniList[0].WRHS_DOC_NO);																		//입고문서번호
		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");									//빈용기구분
		kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N");								//빈용기구분 코드
		kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');							//빈용기명
		kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//비고
		rtn_qty_tot	=INQ_PARAMS.PARAMS.RTN_QTY_TOT;
		 
    }
    
    //입력창 초기화
    function fn_init2(){
    	ctnr_nm 	=[];
    	ctnr_nm =ctnr_nm_init;    	
    	kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N");						//빈용기구분 코드
		kora.common.setEtcCmBx2(ctnr_nm_init, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');					//빈용기명
		$("#DMGB_QTY").removeAttr("disabled");
		$("#VRSB_QTY").removeAttr("disabled");	
		$("#RTN_QTY").removeAttr("disabled");
		$("#CFM_QTY").val("");
		$("#RTN_QTY").val("");
		$("#DMGB_QTY").val("");
		$("#VRSB_QTY").val("");
		fn_rmk();
    }
    
    //빈용기 구분 선택시
    function fn_prps_cd(){
	    	var url = "/MF/EPMF4705631_19.do" 
			var input ={};
			if( $("#PRPS_CD").val() !=""){
				input["CUST_BIZRID"] 		= 	cfm_gridList[0].WHSDL_BIZRID		//도매업자아이디                     
				input["CUST_BIZRNO"] 	= 	cfm_gridList[0].WHSDL_BIZRNO	//도매업자사업자번호                   
				input["CUST_BRCH_ID"] 	= 	cfm_gridList[0].WHSDL_BRCH_ID	//도매업자 지점 아이디             
				input["CUST_BRCH_NO"] 	= 	cfm_gridList[0].WHSDL_BRCH_NO	//도매업자 지점 번호                      
				input["MFC_BIZRID"] 		= 	cfm_gridList[0].MFC_BIZRID			//생산자 아이디             
				input["MFC_BIZRNO"] 		= 	cfm_gridList[0].MFC_BIZRNO		//생산자 사업자번호           
				input["MFC_BRCH_ID"] 	= 	cfm_gridList[0].MFC_BRCH_ID		//생산자 직매장/공장 아이디      
				input["MFC_BRCH_NO"] 	= 	cfm_gridList[0].MFC_BRCH_NO		//생산자 직매장/공장 번호               
				input["WRHS_CFM_DT"] 	=	cfm_gridList[0].WRHS_CFM_DT		//반환일자
				input["CTNR_SE"] 			=  $("#CTNR_SE").val();						//빈용기명 구분 구/신
				if(ctnrCdAll =="T"){
					 input["CTNR_CD_ALL"] 	= "T";
					 input["RTN_DT"]				=	$("#CRCT_RTN_DT").val();			//반환일자 수수료 적용날짜
				}else{
					input["RTN_DT"]				=	iniList[0].RTN_DT;							//반환일자 수수료 적용날짜
					input["PRPS_CD"] 			= $("#PRPS_CD").val();					//빈용기명  유흥/가정/공병/직접 
				}
				ajaxPost(url, input, function(rtnData) {
					if ("" != rtnData && null != rtnData) {   
						if(ctnrCdAll =="T"){		//정정반환일자 적용시 모든 빈용기 정보 가져오기
							 ctnr_nm_all	 = [];
							 ctnr_nm_all	 = rtnData.ctnr_nm
						}else{  
							 ctnr_nm	 = [];	
							 ctnr_nm = rtnData.ctnr_nm
							 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기
						} 
					}else{
						alertMsg("error");
					}
				},false);
			}else{
				ctnr_nm=[];
				kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
			}
			fn_rmk()//비고 부분 초기화
			ctnrCdAll="";
    }
    //소매수수료 적용여부 ㅇㄷ----------------------------------------------------------------------------------------------------
	//소매수수료 적용여부
	function fn_rmk_list(){
  		var ck = $("input[type=radio][name=select_rtl]:checked").val(); //소매수수료 라디오 
  		if(ck !="ext"){	//적용인경우
	  		$("#RMK_SELECT").prop("disabled",true);	//비고 선택부분 비활성화
	  		$("#RMK").prop("disabled",true);				//비고 입력부분 비활성화
	  		$("#RMK_SELECT").val("")						//비고 선택부분 초기화
	  		$("#RMK").val("");									//비고 입력부분 초기화
  		}else{				//제외인경우
	  		if($("#PRPS_CD").val() !="1"){	//유흥인데  소매수수료 제외를 누를경우
	      		 $("#select_rtl1").prop('checked', true);
	      		 alertMsg("빈용기 구분이 가정용 일경우에만 적용됩니다.");
	      		 return;
	      	}
  		 	$("#RMK_SELECT").removeAttr("disabled");//비고 선택부분 활성화
  		}
	}
	//비고 선택 변경
	function fn_rmk_select(){
	  	if($("#RMK_SELECT").val() =="A" || $("#RMK_SELECT").val() =="B"){ 	//소비자 직접반화 ,무인회수기인경우
	  		 $("#RMK").prop("disabled",true);											//비고 입력란 비활성화
	  		 $("#RMK").val($("#RMK_SELECT option:selected").text());				//비고 선택부분 텍스트 입력
	  	}else if($("#RMK_SELECT").val() =="C"){ 										//직접입력인경우
	  		 $("#RMK").removeAttr("disabled");											//비고 입력란 활성화
	  		 $("#RMK").val("");																//비고 입력란 초기화
	  	}else if($("#RMK_SELECT").val() ==""){											//선택일경우
	  		$("#RMK").prop("disabled",true);  											//비고 입력란 비활성화
	  		$("#RMK").val("");																	//초기화
	  	}  
   	}
	//비고부분 초기화
	function fn_rmk(){
		$("#RMK").val("");									//비고입력부분
   		$("#RMK_SELECT").val("");						//비고선택부분
	    $("#select_rtl1").prop('checked', true);		//소매수수료여부 적용
		$("#RMK_SELECT").prop("disabled",true);	//비고선택부분 비활성화
   		$("#RMK").prop("disabled",true);				//비고입력부분 비활성화
	}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
    
	 //행등록
	function fn_reg2(){
	
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		var input 	=	insRow("A");
		if(!input){
			return;
		}
		gridRoot2.addItemAt(input);
		dataGrid2.setSelectedIndex(-1);		
		fn_init2();
	}
	 //행 수정
	function fn_upd(){
		var idx = dataGrid2.getSelectedIndex();
		
		if(idx < 0) {
			alertMsg("변경할 행을 선택하시기 바랍니다.");
			return;
		}
		
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		var item = insRow("M");
		
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot2.removeChangedData(gridRoot2.getItemAt(idx));
		
		//해당 데이터 수정
		gridRoot2.setItemAt(item, idx);
		//dataGrid2.setSelectedIndex(-1);		
		//fn_init2();
	}
	 
	 function fn_del_chk(){
		 fn_del();
	 }
	 
	//행삭제
	function fn_del(){
		var idx = dataGrid2.getSelectedIndex();
 
		if(idx < 0) {
			alertMsg("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		gridRoot2.removeItemAt(idx);
		fn_init2();
	}
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
		var input = {};
		var ctnrCd = $("#CTNR_CD").val();
	    var rtrvlQty = kora.common.format_noComma($("#RTN_QTY").val());
		var collection = gridRoot2.getCollection();
		var rtl_fee_select = $("input[type=radio][name=select_rtl]:checked").val();//수수료적용여부  라디오체크여부
		
	 	for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot2.getItemAt(i);
	 		if(tmpData.CTNR_CD == ctnrCd ){
			 		if(gbn == "M") {
						if(rowIndexValue != i) {
				    		alertMsg("동일한 빈용기명이 있습니다.");
				    		return false;
				    	}
					} else {
			    		alertMsg("동일한 빈용기명이 있습니다..");
			    		return false;
					}
	 		}
	 	}
	
		for(var i=0; i<ctnr_nm.length; i++){
			
			if(ctnr_nm[i].CTNR_CD == ctnrCd) { //같은 용기코드가 있을경우
				
				for(var k=0;k<cfm_gridList.length ;k++){
					if(cfm_gridList[k].CTNR_CD ==ctnrCd){	//입고확인내역에 같은 용기코드가있을경우 반환량 넣기
						 input["RTN_QTY"] =cfm_gridList[k].RTN_QTY;	//반환량
						 break;
					}
				}

			    input["CTNR_SE"] 					= $("#CTNR_SE").val();  	 								//빈용기명 구분 구/신
			    input["PRPS_NM"] 					= $("#PRPS_CD option:selected").text();   			//빈용기명 구분 유흥/가정
			    input["PRPS_CD"] 					= $("#PRPS_CD").val();  						 			//빈용기명 구분 유흥/가정 코드
			    input["CTNR_NM"] 					= $("#CTNR_CD option:selected").text(); 			//빈용기명
			    input["CTNR_CD"] 					= $("#CTNR_CD").val(); 									//빈용기 코드
			    input["CPCT_NM"] 					= ctnr_nm[i].CPCT_NM;									//용량ml
				if($("#CFM_QTY").val() !=""){
					input["CRCT_QTY"] = $("#CFM_QTY").val();	//확인수량
				}else{
				  	input["CRCT_QTY"] ="0";
				}
				if($("#DMGB_QTY").val() !=""){
					input["CRCT_DMGB_QTY"] 	= $("#DMGB_QTY").val(); 	//결병
				}else{
					input["CRCT_DMGB_QTY"] 	="0";
				}
				if($("#VRSB_QTY").val() !=""){
					input["CRCT_VRSB_QTY"] = $("#VRSB_QTY").val(); 	//잡병
				}else{
					input["CRCT_VRSB_QTY"] ="0";
				}
			    input["CRCT_GTN"] 					=  input["CRCT_QTY"] * ctnr_nm[i].STD_DPS; 	//빈용기보증금(원) - 합계
			    input["CRCT_WHSL_FEE"]    		=	input["CRCT_QTY"] *ctnr_nm[i].WHSL_FEE;		//도매수수료 합계
			    input["CRCT_WHSL_FEE_STAX"]	=	kora.common.truncate(parseInt(input["CRCT_WHSL_FEE"],10)/10);	//도매 부과세
			
			    if($("#PRPS_CD").val() =="1"){	//빈용기구분이 가정일 경우에만 적용
				    if(rtl_fee_select =="ext"){							//소매수수료적영여부 제외시
			    		if($("#RMK_SELECT").val() =="" ){
			    			alertMsg("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
			    			return;
			    		}else if ($("#RMK").val() ==""){
			    			alertMsg("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
			    			return;
			    		}
						if($("#RMK_SELECT").val() !="C"){
							input["RMK"] 						=	$("#RMK_SELECT").val()+"-"+$("#RMK_SELECT option:selected").text();	//비고 텍스트값
							input["RMK_C"] 					=	$("#RMK_SELECT option:selected").text();											//비고 텍스트값(view용)
						}else{
							input["RMK"] 						=	$("#RMK_SELECT").val()+"-"+$("#RMK").val();	//비고 텍스트값
							input["RMK_C"] 					=	$("#RMK").val();										//비고 텍스트값(view용)
						}
						input["CRCT_RTL_FEE"]      	=	'0';		//소매수수료 합계	
						input["CRCT_RTL_FEE_STAX"]   =	'0.00';	//소매 부과세
						
				    }else{//소매수수료 적용 시
						  input["CRCT_RTL_FEE"]      		=	input["CRCT_QTY"] * ctnr_nm[i].RTL_FEE;			//소매수수료 합계	
						  input["CRCT_RTL_FEE_STAX"]    	=	kora.common.truncate(parseInt(input["CRCT_RTL_FEE"],10)/10);		//소매 부과세
				    }
			    }else{
					  input["CRCT_RTL_FEE"]      		=	input["CRCT_QTY"] * ctnr_nm[i].RTL_FEE;			//소매수수료 합계	
					  input["CRCT_RTL_FEE_STAX"]    	=	kora.common.truncate(parseInt(input["CRCT_RTL_FEE"],10)/10);		//소매 부과세
			    }
			    //console.log(Number(input["CRCT_GTN"]) +";"+ Number(input["CRCT_WHSL_FEE"]) +";"+ Number(input["CRCT_WHSL_FEE_STAX"]) +";"+ Number(input["CRCT_RTL_FEE"]) +";"+ Number(input["CRCT_RTL_FEE_STAX"]));
			    
			    //소매부가세를 도매부가세로
			    input["CRCT_RTL_FEE_STAX"] = 0;
			    input["CRCT_WHSL_FEE_STAX"]	=	kora.common.truncate( (parseInt(input["CRCT_WHSL_FEE"],10) + parseInt(input["CRCT_RTL_FEE"],10)) / 10 );	//도매 부과세
			    
			    input["CRCT_AMT"] 					=	Number(input["CRCT_GTN"]) + Number(input["CRCT_WHSL_FEE"]) + Number(input["CRCT_WHSL_FEE_STAX"]) + Number(input["CRCT_RTL_FEE"]) + Number(input["CRCT_RTL_FEE_STAX"]); //총합계
			    input["WHSDL_BIZRID"] 			= 	cfm_gridList[0].WHSDL_BIZRID;		//도매업자아이디
			    input["WHSDL_BIZRNO"] 			= 	cfm_gridList[0].WHSDL_BIZRNO;		//도매업자사업자번호
			    input["WHSDL_BRCH_ID"] 		= 	cfm_gridList[0].WHSDL_BRCH_ID;		//도매업자 지점 아이디
			    input["WHSDL_BRCH_NO"] 		= 	cfm_gridList[0].WHSDL_BRCH_NO;		//도매업자 지점 번호
			    input["MFC_BIZRID"] 				= 	cfm_gridList[0].MFC_BIZRID;				//생산자 아이디
			    input["MFC_BIZRNO"] 				= 	cfm_gridList[0].MFC_BIZRNO;			//생산자 사업자번호
			    input["MFC_BRCH_ID"] 			= 	cfm_gridList[0].MFC_BRCH_ID;			//생산자 직매장/공장 아이디
			    input["MFC_BRCH_NO"] 			= 	cfm_gridList[0].MFC_BRCH_NO;			//생산자 직매장/공장 번호
			    input["WRHS_DOC_NO"]			= 	cfm_gridList[0].WRHS_DOC_NO;	   	// 입고문서번호

			    input["WRHS_CRCT_DOC_NO_RE"] = INQ_PARAMS.PARAMS.WRHS_CRCT_DOC_NO_RE; // 입고정정 재등록 문서번호
			    input["WRHS_CRCT_DOC_NO"] = INQ_PARAMS.PARAMS.WRHS_CRCT_DOC_NO; // 입고정정문서번호
			    
			    break;
			}
		}
		return input;
	};	
	//입고정정확인일자
	function fn_crct_wrhs_dt_chk(){
		crct_wrhs_dt_chk = $("#CRCT_WRHS_DT").val();
	}
	
	//comfirm창으로 변수가 안넘어가서... 젠장 ..css
	function fn_ck(){
		ctnrCdAll ="T";
		fn_upd2();
	}
	
	function fn_upd2(){
		fn_prps_cd();
		crct_rtn_dt_chk = $("#CRCT_RTN_DT").val();
		var collection = gridRoot2.getCollection();
		for(var i=0;i<collection.getLength(); i++){
		 		var tmpData 	= gridRoot2.getItemAt(i);
		 		var input ={}
				input["CTNR_SE"] 					=tmpData["CTNR_SE"]; 			
				input["PRPS_NM"] 					=tmpData["PRPS_NM"]; 			
				input["PRPS_CD"] 					=tmpData["PRPS_CD"]; 			
				input["CTNR_NM"] 					=tmpData["CTNR_NM"]; 			
				input["CTNR_CD"] 					=tmpData["CTNR_CD"]; 			
				input["CPCT_NM"] 					=tmpData["CPCT_NM"]; 			
				input["CRCT_QTY"] 					=tmpData["CRCT_QTY"]; 	
				input["RTN_QTY"]					=tmpData["RTN_QTY"]; 
				input["CRCT_DMGB_QTY"] 		=tmpData["CRCT_DMGB_QTY"]; 		
				input["CRCT_VRSB_QTY"] 		=tmpData["CRCT_VRSB_QTY"]; 		
				input["WHSDL_BIZRID"] 			=tmpData["WHSDL_BIZRID"]; 		
				input["WHSDL_BIZRNO"] 			=tmpData["WHSDL_BIZRNO"]; 		
				input["WHSDL_BRCH_ID"] 		=tmpData["WHSDL_BRCH_ID"]; 		
				input["WHSDL_BRCH_NO"] 		=tmpData["WHSDL_BRCH_NO"]; 		
				input["MFC_BIZRID"] 				=tmpData["MFC_BIZRID"];		
				input["MFC_BIZRNO"] 				=tmpData["MFC_BIZRNO"]; 		
				input["MFC_BRCH_ID"] 			=tmpData["MFC_BRCH_ID"]; 		
				input["MFC_BRCH_NO"] 			=tmpData["MFC_BRCH_NO"]; 		
				input["WRHS_DOC_NO"]			=tmpData["WRHS_DOC_NO"];		
				  for(var k=0; k<ctnr_nm_all.length; k++){
				    	if(ctnr_nm_all[k].CTNR_CD == tmpData["CTNR_CD"]) {
					 	    input["CRCT_GTN"] 					=tmpData["CRCT_QTY"] * ctnr_nm_all[k].STD_DPS;
						    input["CRCT_WHSL_FEE"]    		=tmpData["CRCT_QTY"] * ctnr_nm_all[k].WHSL_FEE;  	
						    input["CRCT_WHSL_FEE_STAX"]	=kora.common.truncate(parseInt(tmpData["CRCT_WHSL_FEE"],10)/10)
						    if(tmpData["RMK"] !="" && tmpData["RMK"] !=undefined){
						    	input["RMK"] 							=tmpData["RMK"]; 		
								input["RMK_C"]						=tmpData["RMK_C"];	
							    input["CRCT_RTL_FEE"]      		='0';		//소매수수료 합계	
							    input["CRCT_RTL_FEE_STAX"]  	='0.00';	//소매 부과세
						    } else{
						    	input["CRCT_RTL_FEE"]      		=tmpData["CRCT_QTY"] *ctnr_nm_all[k].RTL_FEE;    	
								input["CRCT_RTL_FEE_STAX"]  	=kora.common.truncate(parseInt(tmpData["CRCT_RTL_FEE"],10)/10)
						    }
						    input["CRCT_AMT"] 					=Number(tmpData["CRCT_QTY"])+ Number(tmpData["CRCT_WHSL_FEE"] )+ Number(tmpData["CRCT_WHSL_FEE_STAX"])+ Number(tmpData["CRCT_RTL_FEE_STAX"])+ Number(tmpData["CRCT_RTL_FEE_STAX"]); //총합계
						    break; 
				    	}
				    }
				  
				  input["WRHS_CRCT_DOC_NO_RE"] = INQ_PARAMS.PARAMS.WRHS_CRCT_DOC_NO_RE; // 입고정정 재등록 문서번호
				  input["WRHS_CRCT_DOC_NO"] = INQ_PARAMS.PARAMS.WRHS_CRCT_DOC_NO; // 입고정정문서번호
				  
				// 해당 데이터의 이전 수정내역을 삭제
				gridRoot2.removeChangedData(gridRoot2.getItemAt(i));
				//해당 데이터 수정
				gridRoot2.setItemAt(input, i);
			
	    }//end of for(var i=0;i<collection.getLength(); i++)
	}	
	
	//등록
	function fn_reg(){
		 
		var data = {"list": ""};
		var row = new Array();
		var url = ""; 

		var crct_tot=0;
		var collection = gridRoot2.getCollection();
		var url = "/MF/EPMF4705642_21.do"
		
		for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot2.getItemAt(i);
			tmpData["WRHS_CRCT_STAT_CD"]		= "R";
			tmpData["EXCA_STD_CD"]				= INQ_PARAMS.PARAMS.EXCA_STD_CD; //정산기준코드
			tmpData["REG_PRSN_ID"]					= crct_gridList[0].REG_PRSN_ID; //최초등록자  
	 		tmpData["REG_DTTM"]						= crct_gridList[0].REG_DTTM	; //최초등록시간
			crct_tot += Number(tmpData["CRCT_QTY"]) +Number(tmpData["CRCT_DMGB_QTY"])+Number(tmpData["CRCT_VRSB_QTY"]);
 			row.push(tmpData);//행 데이터 넣기
	 	}
		
	 	for(var i=0;i<row.length ;i++){
	 			row[i].CRCT_TOT =crct_tot;
	 			row[i].WRHS_CRCT_DOC_NO_RE =INQ_PARAMS.PARAMS.WRHS_CRCT_DOC_NO_RE;
		 		if(crct_rtn_dt_chk !="" ){	//정정반환일자 적용 클릭시
		 			row[i].CRCT_RTN_DT = crct_rtn_dt_chk;
		 		}else{
		 			row[i].CRCT_RTN_DT = crct_gridList[0].CRCT_RTN_DT;
		 		}
				
		 		if(crct_wrhs_dt_chk !="" ){	//정정입고확인일자 적용 클릭시
		 			row[i].CRCT_WRHS_CFM_DT = crct_wrhs_dt_chk;
		 		}else{
		 			row[i].CRCT_WRHS_CFM_DT = iniList[0].WRHS_CFM_DT;
		 		}
		 		
	 		}

		if(	crct_tot != rtn_qty_tot ){
			alertMsg("반환량 합계와 결병 + 잡병 + 확인량의 합계가 동일해야 합니다. \n  반환 수량과 확인 수량이 맞지 않습니다. (결병, 잡병 수량 포함) 다시 한 번 확인해 주시기 바랍니다");
			return;
		}
		
	 	data["list_ori"] = JSON.stringify(jsonObject($("#crct_gridList").val()));
	 	data["list"] = JSON.stringify(row);
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					} else{
						alertMsg(rtnData.RSLT_MSG);
					}
			}else{
					alertMsg("error");
			}
		},false); 
	
	}
    
     //취소
  	function fn_cnl(){
  		kora.common.goPageB('', INQ_PARAMS);
     }
     
  //선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		var item = gridRoot2.getItemAt(rowIndex);
		//빈용기구분 구병/신병 정보가 다를 경우에만 api호출
		if($("#CTNR_SE").val() != item["CTNR_SE"]  || $("#PRPS_CD").val() != item["PRPS_CD"]  ){
			fn_dataSet(item);
		}
		$("#CTNR_SE").val(item["CTNR_SE"]).prop("selected", true);   		//빈용기명 구분 구병 /신병
		$("#PRPS_CD").val(item["PRPS_CD"]).prop("selected", true);   		//빈용기명 구분 유흥/가정 / 직접
		$("#CTNR_CD").val(item["CTNR_CD"]).prop("selected", true);    	//빈용기명
		$("#DMGB_QTY").val(item["CRCT_DMGB_QTY"]);						//결병
		$("#VRSB_QTY")  .val(item["CRCT_VRSB_QTY"]);							//잡병
		$("#CFM_QTY")  .val(item["CRCT_QTY"]);									//확인수량
		
		//소매수수료 적용여부 ㅇㄷ----------
		if(item["RMK"] !=undefined){//비고가 있을경우 
			if(item["RMK"].substring(0,1) =="C"){  	//비고중 직접입력일경우
				$("#RMK").removeAttr("disabled");  //input창 활성화
			}else{
				$("#RMK").prop("disabled",true);		//비고입력창 비활성화
			}
			$("#select_rtl2").prop('checked', true); 					//소매수수료적용여부 제외로
	    	$("#RMK_SELECT").removeAttr("disabled");			//비고 선택부분 활성화
			$("#RMK_SELECT").val(item["RMK"].substring(0,1)); //비고 원본(코드+글자) 비고 선택부분 코드
			$("#RMK").val(item["RMK_C"]);  							//비고 글자만
		}else{									//비고가 없을경우
			$("#select_rtl1").prop('checked', true); 		//소매수수료적용여부 적용
	    	$("#RMK_SELECT").prop("disabled",true);	//비고선택부분 비활성화
	    	$("#RMK").prop("disabled",true);				//비고입력창 비활성화
			$("#RMK_SELECT").val(""); 						//비고선택부분 선택으로
			$("#RMK").val("");  								//비고 초기화  
		}
		//-------------------------------------------
		
		fn_rtn_check();
	};
	
	function fn_dataSet(item){
		var input						= {};
		var url 	 						= "/MF/EPMF4705631_19.do"; 
		input["CUST_BIZRID"] 		= item["WHSDL_BIZRID"];		//도매업자아이디
		input["CUST_BIZRNO"] 	= item["WHSDL_BIZRNO"];	//도매업자사업자번호
		input["CUST_BRCH_ID"] 	= item["WHSDL_BRCH_ID"];	//도매업자 지점 아이디
		input["CUST_BRCH_NO"] 	= item["WHSDL_BRCH_NO"];	//도매업자 지점 번호
		input["MFC_BIZRID"] 		= item["MFC_BIZRID"];			//생산자 아이디
		input["MFC_BIZRNO"] 		= item["MFC_BIZRNO"];		//생산자 사업자번호
		input["MFC_BRCH_ID"] 	= item["MFC_BRCH_ID"];		//생산자 직매장/공장 아이디
		input["MFC_BRCH_NO"] 	= item["MFC_BRCH_NO"];		//생산자 직매장/공장 번호
		input["CTNR_SE"] 			= item["CTNR_SE"];				//빈용기명 구분 구/신
		input["PRPS_CD"] 			= item["PRPS_CD"];				//빈용기명  유흥/가정/공병/직접 
		input["RTN_DT"]				= $("#CRCT_RTN_DT").val();		//반환일자 수수료 적용날짜
		ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {   
				 	ctnr_nm	 = [];						//빈용기정보 초기화
  					ctnr_nm = rtnData.ctnr_nm
  					kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명
  				}else{
				alertMsg("error");
  				}
   		},false);
	}
     
	/****************************************** 그리드 셋팅 시작***************************************** */
	/**
	 * 그리드 관련 변수 선언
	 */
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
	
	var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
	var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;

	/**
	 * 그리드 셋팅
	 */
	 function fnSetGrid1(reDrawYn) {
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
			rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");

			layoutStr = new Array();
			layoutStr2 = new Array();
			
			/* 입고확인내역 */
			layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" 			 headerText="'+ parent.fn_text('sn')+ '"  		 	width="40"	  	itemRenderer="IndexNoItem" textAlign="center" />');							//순번
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"  	 headerText="'+ parent.fn_text('prps_cd')+ '"		width="70"  textAlign="center"/>');																		//용도(유흥용/가정용)
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  	 headerText="'+ parent.fn_text('ctnr_nm')+ '"	width="230"  textAlign="left"/>');																		//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" 	 headerText="'+ parent.fn_text('cd')+ '" 			width="60"  textAlign="center" />');																		//코드
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  	 headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="120"  textAlign="center"/>');																	//용량(ml)]
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY"  	 headerText="'+ parent.fn_text('rtn_qty')+'" width="80" formatter="{numfmt}"  textAlign="right" id="num1"/>');															//반환량
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cfm_data')+ '">');																																									//확인내역
			layoutStr.push('				<DataGridColumn dataField="DMGB_QTY" 	headerText="'+ parent.fn_text('dmgb')+ '"		width="50" formatter="{numfmt}" textAlign="right"  id="num2"/>');						//결병
			layoutStr.push('				<DataGridColumn dataField="VRSB_QTY" 	headerText="'+ parent.fn_text('vrsb')+ '"			width="70" formatter="{numfmt}" textAlign="right"  id="num3"/>');						//잡병
			layoutStr.push('				<DataGridColumn dataField="CFM_QTY" 	headerText="'+ parent.fn_text('cfm_qty2')+ '" 	width="70" formatter="{numfmt}" textAlign="right"  id="num4"/>');						//입고확인수량
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumn dataField="CFM_GTN"   headerText="'+ parent.fn_text('cntr_dps2')+ '" 	width="120" formatter="{numfmt}" textAlign="right"  id="num5"/>');						//빈용기보증금
		 	layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																		//빈용기 취급수수료(원
			layoutStr.push('				<DataGridColumn dataField="CFM_WHSL_FEE" 			headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="150" 	formatter="{numfmt1}" textAlign="right"   id="num6"/>'); //도매수수료
			layoutStr.push('				<DataGridColumn dataField="CFM_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="150" 	formatter="{numfmt1}" textAlign="right"  id="num8"/>');	//소매수수료
			layoutStr.push('				<DataGridColumn dataField="CFM_WHSL_FEE_STAX"   	headerText="'+ parent.fn_text('stax')+ '"	width="150" 	formatter="{numfmt}" 	textAlign="right"  id="num7"/>');	//도매부가세
			layoutStr.push('				<DataGridColumn dataField="CFM_RTL_FEE_STAX"   		headerText="'+ parent.fn_text('rtl_stax2')+ '"  visible="false"  	width="150" 	formatter="{numfmt}" 	textAlign="right"  id="num9"/>');	//소매부가세
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="CFM_AMT" 						headerText="'+ parent.fn_text('amt_tot')+ '" 	width="100"  	formatter="{numfmt}" 	textAlign="right"  id="num10"/>');		//금액합계(원)
			layoutStr.push('			<DataGridColumn dataField="RMK_C"		headerText="'+ parent.fn_text('rmk')+ '"		width="100" textAlign="center"  />');														//비고
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRID"  		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BRCH_ID"    	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BRCH_NO"    visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRID"  		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNO"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_ID"    	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NO"    	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD"    			visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTN_DOC_NO"    	visible="false" />');
			layoutStr.push('		</groupedColumns>');
	 		layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//반환량
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//결병
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//잡병
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//최종입고수량
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	//빈용기 보증금
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//도매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt1}" textAlign="right"/>');	//도매부가세
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	//소매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt1}" textAlign="right"/>');	//소매부가세
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');	//금액합계
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>'); 
			layoutStr.push('	</DataGrid>');
			layoutStr.push('</rMateGrid>');
			/* 입고정정내역 */
			layoutStr2.push('<rMateGrid>');
			layoutStr2.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr2.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr2.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr2.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35">');
			layoutStr2.push('		<groupedColumns>');
			layoutStr2.push('			<DataGridColumn dataField="index" 			 headerText="'+ parent.fn_text('sn')+ '"  		 	width="40"	 	 textAlign="center"	itemRenderer="IndexNoItem"  />');						//순번
			layoutStr2.push('			<DataGridColumn dataField="PRPS_NM"  	 headerText="'+ parent.fn_text('prps_cd')+ '"		width="70" 	 textAlign="center"/>');																	//용도(유흥용/가정용)
			layoutStr2.push('			<DataGridColumn dataField="CTNR_NM"  	 headerText="'+ parent.fn_text('ctnr_nm')+ '"	width="230" 	 textAlign="left"/>');																	//빈용기명
			layoutStr2.push('			<DataGridColumn dataField="CTNR_CD" 	 headerText="'+ parent.fn_text('cd')+ '" 			width="60" 	 textAlign="center" />');																	//코드
			layoutStr2.push('			<DataGridColumn dataField="CPCT_NM"  	 headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" 	width="120" 	 textAlign="center"/>');															//용량(ml)]
			layoutStr2.push('			<DataGridColumn dataField="RTN_QTY"  	 headerText="'+ parent.fn_text('rtn_qty')+'"				width="80"		formatter="{numfmt}" textAlign="right" id="num1"/>');											//반환량
			layoutStr2.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cfm_data')+ '">');																																									//확인내역
			layoutStr2.push('				<DataGridColumn dataField="CRCT_DMGB_QTY" 	headerText="'+ parent.fn_text('dmgb')+ '"		width="50" formatter="{numfmt}" textAlign="right"  id="num2"/>');				//결병
			layoutStr2.push('				<DataGridColumn dataField="CRCT_VRSB_QTY" 	headerText="'+ parent.fn_text('vrsb')+ '"			width="70" formatter="{numfmt}" textAlign="right"  id="num3"/>');				//잡병
			layoutStr2.push('				<DataGridColumn dataField="CRCT_QTY" 	  		headerText="'+ parent.fn_text('cfm_qty2')+ '" 	width="70" formatter="{numfmt}" textAlign="right"  id="num4"/>');				//입고확인수량
			layoutStr2.push('			</DataGridColumnGroup>');
			layoutStr2.push('				<DataGridColumn dataField="CRCT_GTN"  			headerText="'+ parent.fn_text('cntr_dps2')+ '" 	width="120" formatter="{numfmt}" textAlign="right"  id="num5"/>');				//빈용기보증금
		 	layoutStr2.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																		//빈용기 취급수수료(원
			layoutStr2.push('				<DataGridColumn dataField="CRCT_WHSL_FEE"			headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="150" 	formatter="{numfmt1}" textAlign="right"  id="num6"/>'); 	//도매수수료
			layoutStr2.push('				<DataGridColumn dataField="CRCT_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="150" 	formatter="{numfmt1}" textAlign="right"  id="num8"  />');//소매수수료
			layoutStr2.push('				<DataGridColumn dataField="CRCT_WHSL_FEE_STAX"	headerText="'+ parent.fn_text('stax')+ '"	width="150" 	formatter="{numfmt}" 	textAlign="right"  id="num7"  />');//도매부가세
			layoutStr2.push('				<DataGridColumn dataField="CRCT_RTL_FEE_STAX"   	headerText="'+ parent.fn_text('rtl_stax2')+ '"  visible="false"  	width="150" 	formatter="{numfmt}" 	textAlign="right"  id="num9"  />');//소매부가세
			layoutStr2.push('			</DataGridColumnGroup>');
			layoutStr2.push('			<DataGridColumn dataField="CRCT_AMT" 	headerText="'+ parent.fn_text('amt_tot')+ '" 		width="100"  	formatter="{numfmt}" 	textAlign="right"  id="num10"  />');//금액합계(원)
			layoutStr2.push('			<DataGridColumn dataField="RMK_C"			headerText="'+ parent.fn_text('rmk')+ '"		width="100" textAlign="center"  />');														//비고
			layoutStr2.push('			<DataGridColumn dataField="RMK"    		visible="false" />');
			layoutStr2.push('		</groupedColumns>');
	 		layoutStr2.push('		<footers>');
			layoutStr2.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr2.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr2.push('				<DataGridFooterColumn/>');  
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//반환량
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//결병
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//잡병
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//최종입고수량
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	//빈용기 보증금
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//도매수수료
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	//도매부가세
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	//소매수수료
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	//소매부가세
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');	//금액합계
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('			</DataGridFooter>');
			layoutStr2.push('		</footers>'); 
			layoutStr2.push('	</DataGrid>');
			layoutStr2.push('</rMateGrid>');
			
		};

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러
	 */
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp.setLayout(layoutStr.join("").toString());
		gridApp.setData(cfm_gridList);
		
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

	

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러2
	 */
	function gridReadyHandler2(id) {
		gridApp2 = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot2 = gridApp2.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp2.setLayout(layoutStr2.join("").toString());
		gridApp2.setData(cfm_gridList2);
		
		var layoutCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
			dataGrid2.addEventListener("change", selectionChangeHandler2);
		}
		var dataCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler2 = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn2 = gridRoot2.getObjectById("selector");
			rowIndexValue = rowIndex;
			fn_rowToInput(rowIndex);
		}
		gridRoot2.addEventListener("dataComplete", dataCompleteHandler2);
		gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler2);
	}

	
	

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col{
width: 46%;
} 
.srcharea .row .col .tit{
width: 81px;
}
.srcharea .row .box{
width: 63%
}
#btn_upd2 ,#btn_upd3{
margin-left: 10px;
}


</style>

</head>
<body>
    <div class="iframe_inner" id="" >
    
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="iniList" value="<c:out value='${iniList}' />" />
			<input type="hidden" id="cfm_gridList" value="<c:out value='${cfm_gridList}' />" />
			<input type="hidden" id="crct_gridList" value="<c:out value='${crct_gridList}' />" />
    		<input type="hidden" id="ctnr_se_list" value="<c:out value='${ctnr_se}' />" />
    		<input type="hidden" id="ctnr_seList" value="<c:out value='${ctnr_seList}' />" />
			<input type="hidden" id="ctnr_nm_init" value="<c:out value='${ctnr_nm}' />" />
    		<input type="hidden" id="rmk_list" value="<c:out value='${rmk_list}' />" />
		
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR"><!--인쇄  -->
				</div>
			</div>
			   
			<section class="secwrap">
						<div class="write_area">
							<div class="write_tbl">
								<table>
									<colgroup>
										<col style="width: 10%;">
										<col style="width: 15%;">
										<col style="width: 20%;">
										<col style="width: 15%;">
										<col style="width: auto;">
									</colgroup>
									<tbody>
										<tr>
											<th colspan="1" id="doc_no"></th>					<!-- 문서번호-->
											<th class="bd_l"  id="rtn_doc_no"></th>			<!-- 반환문서 -->
											<td>
												<div class="row">
													<div class="txtbox" id="RTN_DOC_NO"></div>
												</div>
											</td>
											<th class="bd_l" id="wrhs_doc_no"></th> <!-- 입고문서 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WRHS_DOC_NO"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th colspan="1" id="se"></th>
											<th class="bd_l"  id="rtrvl_dt"></th>
											<td >
												<div class="row">
													<div class="txtbox" id="RTN_DT"></div>
												</div>
											</td>
											<th class="bd_l" id="wrhs_cfm_dt" ></th> <!-- 입고확인일자 -->
											<td >
												<div class="row" >
													<div class="txtbox" id="WRHS_CFM_DT"></div>
												</div>
											</td> 
										</tr>
										<tr>
											<th rowspan="3"  id="supplier"></th>
											<th class="bd_l" id="mtl_nm"></th> <!-- 상호명 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_BIZRNM"></div>
												</div>
											</td>
											<th class="bd_l" id="bizrno"></th> <!-- 사업자번호-->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_BIZRNO"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="addr"></th> <!-- 주소 -->
											<td colspan="3">
												<div class="row">
													<div class="txtbox" id="WHSDL_ADDR"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l" id="tel_no"></th> <!-- 연락처 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_RPST_TEL_NO"></div>
												</div>
											</td>
											<th class="bd_l"  id="user_nm"></th><!-- 성명 -->
											<td>
												<div class="row">
													<div class="txtbox"  id=WHSDL_RPST_NM></div>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="4" id="receiver"></th>
											<th class="bd_l" id="mtl_nm2"></th>
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BIZRNM"></div> <!-- 상호명 -->
												</div>
											</td>
											<th class="bd_l" id="bizrno2" ></th>
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BIZRNO"></div>	<!-- 사업자등록번호 -->
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="addr2"></th><!-- 생산자 주소 -->
											<td colspan="3" >
												<div class="row" >
													<div class="txtbox"  id="MFC_ADDR"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l" id="tel_no2"></th><!-- 전화번호 -->
											<td>
												<div class="row">
													<div class="txtbox"  id="MFC_RPST_TEL_NO"></div>
												</div>
											</td>
											<th class="bd_l"  id="user_nm2"></th><!-- 성명 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_RPST_NM"></div> 	
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="mfc_brch_nm"></th><!-- 직매장 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BRCH_NM"></div>
												</div>
											</td>
											<th class="bd_l" id="car_no"></th> <!-- 차량번호 -->
											<td>
												<div class="row">
													<div class="txtbox" id="CAR_NO"></div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</section>
					
			<div class="boxarea mt10">
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;" id="wrhs_crct_data"><h5>
				</div>
				<div id="gridHolder" style="height: 360px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			
		<section class="secwrap"  id="params">
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px; margin-top: 10px" id="wrhs_crct_rgst"><h5>
				</div>
				<div class="srcharea" style="" > 
					<div class="row" >
						<div class="col" style="">
							<div class="tit" id="crct_rtn_dt"></div>	<!-- 정정반환일자 -->
							<div class="box">
								<div class="calendar">
									<input type="text" id="CRCT_RTN_DT" name="" style="width: 179px;" class="i_notnull">
								</div>
								<button type="button" class="btn36 c2" style="width: 100px;" id="btn_upd2">적용</button>
							</div> 
						</div>
						
						<div class="col" style="width: 50%;display:none">
							<div class="tit" id="crct_wrhs_dt" style="width:120px"></div>	<!-- 정정입고일자 -->
							<div class="box">
								<div class="calendar">
									<input type="text" id="CRCT_WRHS_DT" name="" style="width: 179px;"	class="i_notnull">
								</div>
								<button type="button" class="btn36 c2" style="width: 100px;" id="btn_upd3">적용</button>
							</div> 
						</div>
						
					</div><!-- end of row -->
				</div><!-- end of srcharea -->
		</section>
		<section class="secwrap" >
				<div class="srcharea"  id="divInput" > 
					<div class="row">
						<div class="col">
							<div class="tit" id="ctnr_se"></div>  <!-- 빈용기구분 -->
							<div class="box">
								<select id="CTNR_SE" style="width: 80px" class="i_notnull" ></select> <!-- 구병/신병 -->
								<select id="PRPS_CD" style="width: 150px" class="i_notnull" ></select><!-- 유흥 / 가정 / 직접 -->
							</div>
						</div>
						
						<div class="col" >
							<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
							<div class="box" style="" >
								<select id="CTNR_CD"  class="i_notnull" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col">
							<div class="tit"  style="width:120px">소매수수료 적용여부</div>  
							<div class="box" id="RMK_LIST" style="">   
								<label class="rdo"><input type="radio" id="select_rtl1" name="select_rtl" value="aplc"  checked="checked"><span id="">적용</span></label>
								<label class="rdo"><input type="radio" id="select_rtl2" name="select_rtl" value="ext"  ><span id="">제외</span></label>
							</div>
						</div>
						<div class="col" style="">
							<div class="tit" >비고</div>  <!-- 비고 -->
							<div class="box"  style="">
									<select id="RMK_SELECT" style="width: 40%"  disabled="disabled"></select>
									<input type="text"  id="RMK" style="width: 58%; max-width: 610px" maxByteLength="30"  disabled="disabled" />
							</div> 
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col"  style="width:31%">
							<div class="tit" id="dmgb_qty"></div>  <!-- 결병 -->
							<div class="box">
								<input type="text"  id="DMGB_QTY" style="" format="number"  maxlength="8" disabled="disabled"/>
							</div>
						</div>
						<div class="col" style="width:31%">
							<div class="tit" id="vrsb_qty"></div>  <!-- 잡병 -->
							<div class="box">
								<input type="text"  id="VRSB_QTY" style="" format="number" maxlength="8" disabled="disabled"/>
							</div>
						</div>
						<div class="col" style="width:31%">
							<div class="tit" id="cfm_qty"></div>  <!-- 확인량 -->
							<div class="box">
								<input type="text"  	id="CFM_QTY" style="" format="number" maxlength="8"/>
							</div>
						</div>
						
					</div> <!-- end of row -->
					<div class="singleRow" style="float:right ">
						<div class="btn" id="CR"></div>
					</div>
					
				</div>  <!-- end of srcharea -->
			</section>	
			
			<div class="boxarea mt10">
				<div id="gridHolder2" style="height: 360px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap" style="height: 50px; margin-top:10px" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
</div>

</body>
</html>