<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고내역서 등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp"%>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
	 var iniList;				//상세조회 반환내역서 공급 부분
	 var gridList;			//그리드 데이터
	 var gridList2;			//그리드 데이터   그리드 안에서 행삭제 또는 수정시 자꾸 내용이 변경되서 만듬;
	 var cfm_gridList;
	 var cfm_gridList2; 	//그리드 안에서 행삭제 또는 수정시 자꾸 내용이 변경되서 만듬;
     var ctnr_se;			//빈용기구분  구병 신병
     var ctnr_seList;		//빈용기구분
     var ctnr_nm;			//빈용기
     var rmk_list;     		//소매수수료 적용여부 비고
     var rowIndexValue	=	"";
     var rtn_qty_tot		=	0;
	 
     $(function() {
		INQ_PARAMS	=  jsonObject($("#INQ_PARAMS").val());			
		iniList				=  jsonObject($("#iniList").val());			
		gridList			=  jsonObject($("#gridList").val());			
		gridList2			=  jsonObject($("#gridList").val());			
		cfm_gridList	=  jsonObject($("#cfm_gridList").val());			
		cfm_gridList2	=  jsonObject($("#cfm_gridList").val());		
		ctnr_se			=  jsonObject($("#ctnr_se_list").val());			
		ctnr_seList		=  jsonObject($("#ctnr_seList").val());			
		ctnr_nm			=  jsonObject($("#ctnr_nm_list").val());			
		rmk_list			=  jsonObject($("#rmk_list").val());				//비고	

    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
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
		
		//자동계산
		$("#RTN_QTY").blur(function(){
			fn_cal();
		});
		$("#DMGB_QTY").blur(function(){
			fn_cal();
		});
		$("#VRSB_QTY").blur(function(){
			fn_cal();
		});
		
		fn_init();
	    	
	});
     
     function fn_rtn_check(){
    	 
     	var rtnDataYn = '';
     	$.each(gridList, function(i, v){
 			if($("#CTNR_CD").val() == v.CTNR_CD){ //반환데이터에 존재하는 용기코드
 				$('#RTN_QTY').val(v.RTN_QTY);
 				$("#DMGB_QTY").removeAttr("disabled");
 				$("#VRSB_QTY").removeAttr("disabled");	
 				rtnDataYn = 'Y';
 				return;
 			}
 		});
     	
     	if(rtnDataYn == ''){ //반환데이터에 존재하지않는 용기코드
     		$('#RTN_QTY').val('');
     		$('#DMGB_QTY').val('');
     		$('#VRSB_QTY').val('');
     		$("#DMGB_QTY").prop("disabled",true);
 			$("#VRSB_QTY").prop("disabled",true);	
     	}
     	 
      }
     
   //자동계산
     function fn_cal(){
    	 var rtn_qty 		=Number( $("#RTN_QTY").val());
		 var dmgb_qty	=Number( $("#DMGB_QTY").val());
		 var vrsb_qty	 	=Number( $("#VRSB_QTY").val());
		 var cfm_qty 	 	=Number( $("#CFM_QTY").val());
		 if(rtn_qty !=0){
			 cfm_qty = rtn_qty - (dmgb_qty+vrsb_qty);
			 $("#CFM_QTY").val(cfm_qty)
		 }
     }
     
   
    function  fn_init(){
     	
    	//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');						 					//타이틀
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
		$('#rtn_reg_dt').text(parent.fn_text('rtn_reg_dt')); 					//반환등록일자
		$('#ctnr_se').text(parent.fn_text('ctnr_se'));								//빈용기 구분
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));							//빈용기명
		$('#rtn_qty').text(parent.fn_text('rtn_qty')); 			 				//반환량(개)
		$('#dmgb_qty').text(parent.fn_text('dmgb_qty')); 					//결병(개)
		$('#vrsb_qty').text(parent.fn_text('vrsb_qty')); 			 				//잡병(개)
		$('#cfm_qty').text(parent.fn_text('cfm_qty')); 			 				//확인량(개)
		$('#wrhs_cfm_data').text('('+parent.fn_text('wrhs_cfm_data')+')');//입고확인내역
		$('#rtn_data').text('('+parent.fn_text('rtn_data') +')' ); 			 	//반환내역
		$('#rtn_doc_no').text(parent.fn_text('rtn_doc_no')); 					//반환문서번호
		
		//div필수값 alt
		 $("#RTN_QTY").attr('alt',parent.fn_text('rtn_qty'));					//반환량
		 $("#DMGB_QTY").attr('alt',parent.fn_text('dmgb_qty'));			//결병
		 $("#VRSB_QTY").attr('alt',parent.fn_text('vrsb_qty'));				//잡병
		 $("#CFM_QTY").attr('alt',parent.fn_text('cfm_qty'));					//확인량
		 $("#CTNR_CD").attr('alt',parent.fn_text('ctnr_nm'));					//빈용기명
			
		 //데이터 넣기
   		 $("#RTN_DT")   	  				.text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_DT, "yyyy-mm-dd"));		//반환일자
   		 $("#RTN_REG_DT")    			.text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_REG_DT, "yyyy-mm-dd"));//반환등록일자
   		 $("#CAR_NO")          			.text(iniList[0].CAR_NO);																										//차량번호
   		 $("#MFC_BIZRNM")    			.text(iniList[0].MFC_BIZRNM);																								//생산자명
   		 $("#MFC_BIZRNO")    			.text(kora.common.setDelim(iniList[0].MFC_BIZRNO, "999-99-99999"));										//생산자 사업자번호
   		 $("#MFC_RPST_NM") 			.text(iniList[0].MFC_RPST_NM);																							//생산자 대표자
   		 $("#MFC_RPST_TEL_NO")		.text(iniList[0].MFC_RPST_TEL_NO);																						//생산자 연락처
   		 $("#MFC_ADDR")      			.text(iniList[0].MFC_ADDR);																									//생산자 주소
   		 $("#MFC_BRCH_NM")      	.text(iniList[0].MFC_BRCH_NM);																							//생산자 직매장
   		 $("#WHSDL_BIZRNM")      	.text(iniList[0].WHSDL_BIZRNM);                                                                    						//도매업자명    
   		 $("#WHSDL_BIZRNO")      	.text(kora.common.setDelim(iniList[0].WHSDL_BIZRNO, "999-99-99999"));                              		//도매업자 사업자번호                   
   		 $("#WHSDL_RPST_NM")   	.text(iniList[0].WHSDL_RPST_NM);                                                                   						//도매업자 대표자             
   		 $("#WHSDL_RPST_TEL_NO")	.text(iniList[0].WHSDL_RPST_TEL_NO);                                                                   				//도매업자 연락처             
   		 $("#WHSDL_ADDR")			.text(iniList[0].WHSDL_ADDR);                                                                  							//도매업자 주소   
   		 $("#RTN_DOC_NO")			.text(iniList[0].RTN_DOC_NO);																								//반환문서번호
	   	 kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		 kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N");						//빈용기구분 코드
		 kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');					//빈용기명
		 kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//비고
		 rtn_qty_tot	=INQ_PARAMS.PARAMS.RTN_QTY_TOT
    }
    
    //입력창 초기화
    function fn_init2(){
    	 //kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		 //kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N");						//빈용기구분 코드
		 //kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');					//빈용기명
		//$("#DMGB_QTY").removeAttr("disabled");
		//$("#VRSB_QTY").removeAttr("disabled");	
		//$("#RTN_QTY").removeAttr("disabled");
		$("#CFM_QTY").val("");
		$("#RTN_QTY").val("");
		$("#DMGB_QTY").val("");
		$("#VRSB_QTY").val("");
		fn_rmk();
    }
    
    //빈용기 구분 선택시
    function fn_prps_cd(){
		var url = "/CE/EPCE2910142_19.do" 
		var input ={};
		if( null != $("#PRPS_CD").val() && $("#PRPS_CD").val() !=""){
		    input["CUST_BIZRID"] 	= gridList[0].WHSDL_BIZRID	//도매업자아이디                     
		    input["CUST_BIZRNO"] 	= gridList[0].WHSDL_BIZRNO	//도매업자사업자번호                   
		    input["CUST_BRCH_ID"] 	= gridList[0].WHSDL_BRCH_ID	//도매업자 지점 아이디             
		    input["CUST_BRCH_NO"] 	= gridList[0].WHSDL_BRCH_NO	//도매업자 지점 번호                      
		    input["MFC_BIZRID"] 	= gridList[0].MFC_BIZRID	//생산자 아이디             
		    input["MFC_BIZRNO"] 	= gridList[0].MFC_BIZRNO	//생산자 사업자번호           
		    input["MFC_BRCH_ID"] 	= gridList[0].MFC_BRCH_ID	//생산자 직매장/공장 아이디      
		    input["MFC_BRCH_NO"] 	= gridList[0].MFC_BRCH_NO	//생산자 직매장/공장 번호               
		    input["RTN_DT"] 		= gridList[0].RTN_DT		//반화일자
		    input["CTNR_SE"] 		= $("#CTNR_SE").val();		//빈용기명 구분 구/신
		    input["PRPS_CD"] 		= $("#PRPS_CD").val();		//빈용기명  유흥/가정/공병/직접 

		    ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
	   				ctnr_nm = rtnData.ctnr_nm
	   				kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
	   			}
   				else{
					alertMsg("error");
	   			}
	   		});
		}
		else{
			ctnr_nm=[];
			kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
		}
		
		fn_rmk()//비고 부분 초기화
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
		var regNumber = /^[0-9]*$/;
		var rtn_qty =$("#RTN_QTY").val()
		if(!regNumber.test(rtn_qty)) {
		    alertMsg('숫자만 입력해주세요.');
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
		if(!item){
			return;
		}
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot2.removeChangedData(gridRoot2.getItemAt(idx));
		//해당 데이터 수정
		gridRoot2.setItemAt(item, idx);
		dataGrid2.setSelectedIndex(-1);			
		fn_init2();
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
		var collection = gridRoot2.getCollection();
		var flag =false;
	    var rtl_fee_select = $("input[type=radio][name=select_rtl]:checked").val();//수수료적용여부  라디오체크여부
		
		if( $("#CFM_QTY").val() <0){
			 alertMsg("‘반환 수량과 확인 수량이 맞지 않습니다. (결병, 잡병 수량 포함) 다시 한 번 확인해 주시기 바랍니다");
			 return;
		}
		//반환내역에 없는 빈용기 입력시
		for(var k=0;k<gridList.length;k++){
				if(gridList[k].CTNR_CD ==ctnrCd){
					flag =true;
				}
		}//end of for
		if(!flag){
			 if($("#RTN_QTY").val() !=0 ||$("#DMGB_QTY").val() !=0 ||$("#VRSB_QTY").val() !=0){
					alertMsg("반환내역에 없는 빈용기는 반환량,결병,잡병 을 추가 할수없습니다.");
					return;
				}
		}//end of if(!flag)
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
	 	}//end of for(var i=0;i<collection.getLength(); i++)
		for(var i=0; i<ctnr_nm.length; i++){
			if(ctnr_nm[i].CTNR_CD == ctnrCd) {
				if(ctnrCd.substr(3,2) == "00"){
			    	input["STANDARD_NM"] 					= 	"표준용기";	
			    }else{
			    	input["STANDARD_NM"] 					= 	"비표준용기";	
			    }
				input["CTNR_SE"] 		= $("#CTNR_SE").val();  	 								//빈용기명 구분 구/신
				input["PRPS_NM"] 		= $("#PRPS_CD option:selected").text();   			//빈용기명 구분 유흥/가정
				input["PRPS_CD"] 		= $("#PRPS_CD").val();  						 			//빈용기명 구분 유흥/가정 코드
				input["CTNR_NM"] 		= $("#CTNR_CD option:selected").text(); 			//빈용기명
				input["CTNR_CD"]			= $("#CTNR_CD").val(); 									//빈용기 코드
				input["CPCT_NM"]		= ctnr_nm[i].CPCT_NM;									//용량ml
				if($("#CFM_QTY").val() !=""){
				input["CFM_QTY"] = $("#CFM_QTY").val();	//확인수량
				}else{
				  	input["CFM_QTY"] ="0";
				}
				if($("#DMGB_QTY").val() !=""){
					input["DMGB_QTY"] 	= $("#DMGB_QTY").val(); 	//결병
				}else{
					input["DMGB_QTY"] 	="0";
				}
				if($("#VRSB_QTY").val() !=""){
					input["VRSB_QTY"] = $("#VRSB_QTY").val(); 	//잡병
				}else{
					input["VRSB_QTY"] ="0";
				}
				if($("#RTN_QTY").val() !=""){
					input["RTN_QTY"] = $("#RTN_QTY").val(); 		//반환량
				}else{
					input["RTN_QTY"] ="0";
				}
				input["RTN_GTN_UTPC"]      		=	ctnr_nm[i].STD_DPS;									//기준보증금 
				input["CFM_GTN"] 					=  input["CFM_QTY"] * ctnr_nm[i].STD_DPS; 		//빈용기보증금(원) - 합계
				input["RTN_WHSL_FEE_UTPC"]	=	ctnr_nm[i].WHSL_FEE;								//도매수수료
				input["CFM_WHSL_FEE"]    		=	input["CFM_QTY"] *ctnr_nm[i].WHSL_FEE;		//도매수수료 합계
				input["CFM_WHSL_FEE_STAX"]   	=	kora.common.truncate(parseInt(input["CFM_WHSL_FEE"],10)/10);    						//도매 부과세
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
							input["RTN_RTL_FEE_UTPC"]	=	'0'; 	//소매수수료    
							input["CFM_RTL_FEE"]      		=	'0';		//소매수수료 합계	
							
					    }else{//소매수수료 적용 시
					    	  input["RTN_RTL_FEE_UTPC"]		=	ctnr_nm[i].RTL_FEE;										//소매수수료
							  input["CFM_RTL_FEE"]      		=	input["CFM_QTY"] * ctnr_nm[i].RTL_FEE;			//소매수수료 합계	
					    }
			    }else{
			    	  input["RTN_RTL_FEE_UTPC"]		=	ctnr_nm[i].RTL_FEE;										//소매수수료
					  input["CFM_RTL_FEE"]      		=	input["CFM_QTY"] * ctnr_nm[i].RTL_FEE;			//소매수수료 합계	
			    }
				
				//소매부가세를 도매부가세로
				input["CFM_WHSL_FEE_STAX"] = kora.common.truncate( (parseInt(input["CFM_WHSL_FEE"],10) + parseInt(input["CFM_RTL_FEE"],10)) / 10);
				
				
				input["AMT_TOT"] 					=	Number(input["CFM_GTN"])+ Number(input["CFM_WHSL_FEE"]) + Number(input["CFM_WHSL_FEE_STAX"])+ Number(input["CFM_RTL_FEE"]); //총합계
				input["WHSDL_BIZRID"] 			= 	gridList[0].WHSDL_BIZRID		//도매업자아이디
				input["WHSDL_BIZRNO"] 			= 	gridList[0].WHSDL_BIZRNO		//도매업자사업자번호
				input["WHSDL_BRCH_ID"] 		= 	gridList[0].WHSDL_BRCH_ID		//도매업자 지점 아이디
				input["WHSDL_BRCH_NO"] 		= 	gridList[0].WHSDL_BRCH_NO	//도매업자 지점 번호
				input["MFC_BIZRID"] 				= 	gridList[0].MFC_BIZRID			//생산자 아이디
				input["MFC_BIZRNO"] 				= 	gridList[0].MFC_BIZRNO			//생산자 사업자번호
				input["MFC_BRCH_ID"] 			= 	gridList[0].MFC_BRCH_ID			//생산자 직매장/공장 아이디
				input["MFC_BRCH_NO"] 			= 	gridList[0].MFC_BRCH_NO		//생산자 직매장/공장 번호
				input["RTN_DOC_NO"]				= 	gridList[0].RTN_DOC_NO	   		 // 반환문서번호
				input["WRHS_DOC_NO"]			= 	gridList[0].WRHS_DOC_NO	   	 // 입고문서번호
				input["RTN_DT"]						=	gridList[0].RTN_DT					//반화일자
				input["ADD_FILE"]						=	'<a href="javascript:link();">['+parent.fn_text('atch')+']</a>' //증빙사진
				break;
			}//end of if
		}//end of for
		return input;
	};	
	
	//등록
	function fn_reg(){
		 
		var data = {"list": ""};
		var row = new Array();
		var url = "/CE/EPCE2983931_09.do"; 
		var changedData = gridRoot2.getChangedData();
		var cfm_qty = 0
		var dmgb_qty = 0
		var vrsb_qty = 0		
		var collection = gridRoot2.getCollection();
		
				//입고조정시
				if(INQ_PARAMS.PARAMS.RTN_STAT_CD == "WJ"){
						url = "/CE/EPCE2983931_21.do"; 
						for(var i=0;i<collection.getLength(); i++){
					 		var tmpData = gridRoot2.getItemAt(i);
					 		tmpData["REG_PRSN_ID"]		= cfm_gridList[0].REG_PRSN_ID		//최초등록자  
					 		tmpData["REG_DTTM"]			= cfm_gridList[0].REG_DTTM		//최초등록시간
							tmpData["RTN_STAT_CD"]		= "WJ";
							tmpData["SYS_SE"]				= 'W';								//시스템구분	
							cfm_qty 		+= Number(tmpData["CFM_QTY"]) 
							dmgb_qty 	+= Number(tmpData["DMGB_QTY"]) 
							vrsb_qty 	+= Number(tmpData["VRSB_QTY"]) 
					 		row.push(tmpData);//행 데이터 넣기
				 		}
				//입고문서 첫번째 저장시		
				}else if(INQ_PARAMS.PARAMS.RTN_STAT_CD == "RG"){
						for(var i=0;i<collection.getLength(); i++){
					 		var tmpData 	= gridRoot2.getItemAt(i);
							if(0 == changedData.length){
								tmpData["RTN_STAT_CD"]		="WC";  
							}else{
								tmpData["RTN_STAT_CD"]		="WJ";
							}
								tmpData["SYS_SE"]				='W';									//시스템구분	
								cfm_qty 		+= Number(tmpData["CFM_QTY"]) 
								dmgb_qty 	+= Number(tmpData["DMGB_QTY"]) 
								vrsb_qty 	+= Number(tmpData["VRSB_QTY"]) 
					 		row.push(tmpData);//행 데이터 넣기
					 	}
				//반환상태가 다른놈일경우		
				}else{
					alertMsg("반환상태가 반환등록 ,입고조정인 경우에만 가능합니다");
					return
				}
			 	for(var i=0;i<row.length ;i++){
			 		row[i].QTY_TOT =cfm_qty+dmgb_qty+vrsb_qty
			 	}
				if(cfm_qty+dmgb_qty+vrsb_qty != rtn_qty_tot){
					alertMsg("반환량 합계와 결병 + 잡병 + 확인량의 합계가 동일해야 합니다. \n 차이가 날 경우 ‘반환 수량과 확인 수량이 맞지 않습니다. (결병, 잡병 수량 포함) 다시 한 번 확인해 주시기 바랍니다");
					return;
				}				 	
				data["list_ori"] = JSON.stringify(gridList);
			 	data["list"] = JSON.stringify(row);
				ajaxPost(url, data, function(rtnData){
					if(rtnData != null && rtnData != ""){
							if(rtnData.RSLT_CD =="0000"){
								alertMsg(rtnData.RSLT_MSG);
			  					fn_cnl();
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
    	var	url		="/CE/EPCE2983931_04.do";  
		var	input	={};
		input["RTN_DOC_NO"]	= 	gridList[0].RTN_DOC_NO	//반환문서번호 
  		ajaxPost(url, input, function(rtnData){						//증빙사진 temp 삭제 
		},false); 
  		kora.common.goPageB('', INQ_PARAMS);					//입고관리로
     }
     
  	var parent_item;	
     //첨부파일 클릭시
	function link(){
		var idx = dataGrid2.getSelectedIndices();
		parent_item = gridRoot2.getItemAt(idx);
		var pagedata = window.frameElement.name;
		window.parent.NrvPub.AjaxPopup('/CE/EPCE29839882.do', pagedata);
/* 
		var url ='/CE/EPCE2983931_092.do'	//템프에 저장		
		showLoadingBar()
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD != "0000"){
				alertMsg(rtnData.RSLT_MSG);
				return;
			}else{
			}
		},false);    
			hideLoadingBar(); */
	//	window.open("/EPCM/EPCMSLRH_POP.do", "EPCMSLRH_POP", "width=450, height=480, menubar=no,status=no,toolbar=no, scrollbars=1");
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
		
		
		if(item["RTN_QTY"] !=0 && item["RTN_QTY"] !=''){
			$("#DMGB_QTY").removeAttr("disabled");
			$("#VRSB_QTY").removeAttr("disabled");	
			//$("#RTN_QTY").removeAttr("disabled");
		}else{
			$("#DMGB_QTY").prop("disabled",true);
			$("#VRSB_QTY").prop("disabled",true);	
			//$("#RTN_QTY").prop("disabled",true);	
		}
		
		
		$("#DMGB_QTY").val(item["DMGB_QTY"]);								//결병
		$("#VRSB_QTY")  .val(item["VRSB_QTY"]);									//잡병
		$("#CFM_QTY")  .val(item["CFM_QTY"]);									//확인수량
		$("#RTN_QTY")  .val(item["RTN_QTY"]);										//반환량
		
		
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
	};
	
	function fn_dataSet(item){
		var input	={};
		var url 	 	= "/CE/EPCE2983931_19.do"; 
		  	   
	    input["CUST_BIZRID"] 		= item["WHSDL_BIZRID"];		//도매업자아이디
	    input["CUST_BIZRNO"] 		= item["WHSDL_BIZRNO"];	//도매업자사업자번호
	    input["CUST_BRCH_ID"] 	= item["WHSDL_BRCH_ID"];	//도매업자 지점 아이디
	    input["CUST_BRCH_NO"] 	= item["WHSDL_BRCH_NO"];	//도매업자 지점 번호
	    input["MFC_BIZRID"] 		= item["MFC_BIZRID"];			//생산자 아이디
	    input["MFC_BIZRNO"] 		= item["MFC_BIZRNO"];		//생산자 사업자번호
	    input["MFC_BRCH_ID"] 		= item["MFC_BRCH_ID"];		//생산자 직매장/공장 아이디
	    input["MFC_BRCH_NO"] 	= item["MFC_BRCH_NO"];		//생산자 직매장/공장 번호
	    input["CTNR_SE"] 			= item["CTNR_SE"];				//빈용기명 구분 구/신
	    input["PRPS_CD"] 			= item["PRPS_CD"];				//빈용기명  유흥/가정/공병/직접 
	    input["RTN_DT"] 				= item["RTN_DT"];				//반환일자
	    
	    if( null != $("#PRPS_CD").val() && $("#PRPS_CD").val() !=""){
       	    ajaxPost(url, input, function(rtnData) {
       			if ("" != rtnData && null != rtnData) {   
    				 ctnr_nm	 = [];						//빈용기정보 초기화
       				 ctnr_nm = rtnData.ctnr_nm
       				 kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명
       			}
       			else{
    				alertMsg("error");
       			}
        	},false);
	    }
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
			
			layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true"  draggableColumns="true" sortableColumns="true"  headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index"			headerText="'+ parent.fn_text('sn')+ '" 		width="4%"	textAlign="center"  itemRenderer="IndexNoItem" />');	//순번
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"  	headerText="'+ parent.fn_text('prps_cd')+ '" width="7%" 	textAlign="center"  />');		//용도(유흥용/가정용)
			layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="7%" textAlign="center"  />');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  	headerText="'+ parent.fn_text('ctnr_nm')+ '" width="15%" 	textAlign="left" />');		//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" 	headerText="'+ parent.fn_text('cd')+ '" 		width="4%" 	textAlign="center" />');		//코드
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  	headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="6%"	textAlign="center"   />');	//용량(ml)
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('qty')+ '">');																																						//수량
			layoutStr.push('				<DataGridColumn dataField="BOX_QTY" headerText="'+ parent.fn_text('box_qty')+ '"	width="4%" formatter="{numfmt}" textAlign="right"  id="num1" />');			//상자
			layoutStr.push('				<DataGridColumn dataField="RTN_QTY"	headerText="'+ parent.fn_text('btl')+ '" 		width="4%" formatter="{numfmt}" textAlign="right"   	id="num2"  />');		//병
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+ parent.fn_text('dps')+'">');																															//빈용기보증금(원)																		
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN_UTPC"   	headerText="'+ parent.fn_text('utpc')+ '"	width="4%" formatter="{numfmt}" textAlign="right" />');					//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN"				headerText="'+ parent.fn_text('amt')+ '"	width="5%" formatter="{numfmt}" textAlign="right"   id="num3"  />');//금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																			//빈용기 취급수수료(원
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_UTPC"		headerText="'+ parent.fn_text('utpc')+ '" 			width="4%" 	formatter="{numfmt}" 	textAlign="right" />');						//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE"				headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="6.5%" 	formatter="{numfmt1}" textAlign="right"   id="num4"  />'); 	//도매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE_UTPC"   		headerText="'+ parent.fn_text('utpc')+ '" 			width="4%" 	formatter="{numfmt}" 	textAlign="right" />');						//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="6.5%" 	formatter="{numfmt1}" textAlign="right"  id="num6"  />');	//소매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_STAX"  	headerText="'+ parent.fn_text('stax')+ '" 	width="6.5%" 	formatter="{numfmt}" 	textAlign="right"   id="num5"  />');	//도매부가세
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT"	headerText="'+ parent.fn_text('amt_tot')+ '" width="6%" textAlign="right"	     formatter="{numfmt}"  id="num8"   />');	//금액합계(원)
			layoutStr.push('			<DataGridColumn dataField="RMK_C"		headerText="'+ parent.fn_text('rmk')+ '"		width="7%" textAlign="center"  />');														//비고
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//상자
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//병
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//금액
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//도매수수료
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//소매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	//부가세
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	//합계
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>');
			layoutStr.push('	</DataGrid>');
			layoutStr.push('</rMateGrid>');
			
			layoutStr2.push('<rMateGrid>');
			layoutStr2.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr2.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr2.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr2.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35">');
			layoutStr2.push('		<groupedColumns>');
			layoutStr2.push('			<DataGridColumn dataField="index" 			headerText="'+ parent.fn_text('sn')+ '"  		width="40"		itemRenderer="IndexNoItem" textAlign="center" />');	//순번
			layoutStr2.push('			<DataGridColumn dataField="PRPS_NM"  	headerText="'+ parent.fn_text('prps_cd')+ '"	width="70"		textAlign="center"/>');												//용도(유흥용/가정용)
			layoutStr2.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="100" textAlign="center"  />');
			layoutStr2.push('			<DataGridColumn dataField="CTNR_NM"	headerText="'+ parent.fn_text('ctnr_nm')+ '"	width="250"  textAlign="left"/>');												//빈용기명
			layoutStr2.push('			<DataGridColumn dataField="CTNR_CD"		headerText="'+ parent.fn_text('cd')+ '" 		width="60"	 	textAlign="center" />');												//코드
			layoutStr2.push('			<DataGridColumn dataField="CPCT_NM"		headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="120"  textAlign="center"/>');										//용량(ml)]
			layoutStr2.push('			<DataGridColumn dataField="RTN_QTY"		headerText="'+ parent.fn_text('rtn_qty')+'" 	width="70"		textAlign="right"  formatter="{numfmt}" id="num0" />');				//반환량
			layoutStr2.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cfm_data')+ '">');																																		//확인내역
			layoutStr2.push('				<DataGridColumn dataField="DMGB_QTY"	headerText="'+ parent.fn_text('dmgb')+ '"		width="50" textAlign="right"  formatter="{numfmt}"  id="num1"/>');	//결병
			layoutStr2.push('				<DataGridColumn dataField="VRSB_QTY"	headerText="'+ parent.fn_text('vrsb')+ '"			width="70" textAlign="right"  formatter="{numfmt}"  id="num2"/>');	//잡병
			layoutStr2.push('				<DataGridColumn dataField="CFM_QTY" 	headerText="'+ parent.fn_text('cfm_qty2')+ '"	width="70" textAlign="right"  formatter="{numfmt}"  id="num3"/>');	//입고확인수량
			layoutStr2.push('				<DataGridColumn dataField="ADD_FILE" 	headerText="'+ parent.fn_text('prf_file2')+ '"  	width="80" textAlign="center" itemRenderer="HtmlItem"  />');			//증빙사진
			layoutStr2.push('			</DataGridColumnGroup>');
			layoutStr2.push('				<DataGridColumn dataField="CFM_GTN"		headerText="'+ parent.fn_text('cntr_dps2')+ '" 	width="100" formatter="{numfmt}" textAlign="right"  id="num4"  />');	//빈용기보증금
		 	layoutStr2.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																		 //빈용기 취급수수료(원
			layoutStr2.push('				<DataGridColumn dataField="CFM_WHSL_FEE"				headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="100" 	formatter="{numfmt1}" textAlign="right"  id="num5"/>');//도매수수료
			layoutStr2.push('				<DataGridColumn dataField="CFM_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="100" 	formatter="{numfmt1}" textAlign="right"  id="num7"/>');//소매수수료
			layoutStr2.push('				<DataGridColumn dataField="CFM_WHSL_FEE_STAX"    headerText="'+ parent.fn_text('stax')+ '"	width="100" 	formatter="{numfmt}" 	textAlign="right"  id="num6"/>');//부가세
			layoutStr2.push('			</DataGridColumnGroup>');
			layoutStr2.push('			<DataGridColumn dataField="AMT_TOT"	headerText="'+ parent.fn_text('amt_tot')+ '" 	width="100"  	formatter="{numfmt}" 	textAlign="right"  id="num9"  />');	 //금액합계(원)
			layoutStr2.push('			<DataGridColumn dataField="RMK_C"		headerText="'+ parent.fn_text('rmk')+ '"		width="100" textAlign="center"  />');														//비고
			layoutStr2.push('			<DataGridColumn dataField="CUST_BIZRID"  		visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="CUST_BIZRNO"		visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="CUST_BRCH_ID"    	visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="CUST_BRCH_NO"    visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="MFC_BIZRID"  		visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="MFC_BIZRNO"		visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="MFC_BRCH_ID"    	visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="MFC_BRCH_NO"    	visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="PRPS_CD"    			visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="RTN_DOC_NO"    	visible="false" />');
			layoutStr2.push('			<DataGridColumn dataField="RMK"    				visible="false" />');
			layoutStr2.push('		</groupedColumns>');
	 		layoutStr2.push('		<footers>');
			layoutStr2.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr2.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num0}" formatter="{numfmt}" textAlign="right"/>');	//반환량
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//결병
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//잡병
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//최종입고수량
 			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//빈용기 보증금
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	//도매수수료
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	//소매수수료
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//부가세
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	//금액합계
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
		gridApp.setData(gridList);
		
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
		
		if(cfm_gridList[0] !=null){
		gridApp2.setData(cfm_gridList2);
		}else{
		gridApp2.setData(gridList2);
		}
		
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
.srcharea .row .col {
    width: 31%;
}

.srcharea .row .col .tit {
    width: 68px
}

.srcharea .row .box {
    width: 68%
}
</style>

</head>
<body>

    <div class="iframe_inner" id="testee">
        <input type="hidden" id="INQ_PARAMS"
            value="<c:out value='${INQ_PARAMS}' />" /> <input
            type="hidden" id="iniList"
            value="<c:out value='${iniList}' />" /> <input
            type="hidden" id="gridList"
            value="<c:out value='${gridList}' />" /> <input
            type="hidden" id="cfm_gridList"
            value="<c:out value='${cfm_gridList}' />" /> <input
            type="hidden" id="ctnr_se_list"
            value="<c:out value='${ctnr_se}' />" /> <input
            type="hidden" id="ctnr_seList"
            value="<c:out value='${ctnr_seList}' />" /> <input
            type="hidden" id="ctnr_nm_list"
            value="<c:out value='${ctnr_nm}' />" /> <input
            type="hidden" id="rmk_list"
            value="<c:out value='${rmk_list}' />" />
        <div class="h3group">
            <h3 class="tit" id="title_sub"></h3>
            <div class="btn" style="float: right" id="UR">
                <!--인쇄  -->
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
                            <th colspan="1" id="rtn_doc_no"></th>
                            <!-- 반환문서 -->
                            <td colspan="4"
                                style="border-left: 1px solid #c3c8d1;">
                                <div class="row">
                                    <div class="txtbox" id="RTN_DOC_NO"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th colspan="1" id="se"></th>
                            <!-- 구분 -->
                            <th class="bd_l" id="rtn_reg_dt"></th>
                            <!-- 반환등록일자 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="RTN_REG_DT"></div>
                                </div>
                            </td>
                            <th class="bd_l" id="rtrvl_dt"></th>
                            <!-- 반환일자 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="RTN_DT"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="3" id="supplier"></th>
                            <th class="bd_l" id="mtl_nm"></th>
                            <!-- 상호명 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox"
                                        id="WHSDL_BIZRNM"></div>
                                </div>
                            </td>
                            <th class="bd_l" id="bizrno"></th>
                            <!-- 사업자번호-->
                            <td>
                                <div class="row">
                                    <div class="txtbox"
                                        id="WHSDL_BIZRNO"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="bd_l" id="addr"></th>
                            <!-- 주소 -->
                            <td colspan="3">
                                <div class="row">
                                    <div class="txtbox" id="WHSDL_ADDR"></div>
                                </div>
                            </td>
                            <!-- 	<th class="bd_l" style="background-color: white; border-left-color: white;"></th>
											<td>
												<div class="row">
													<div class="txtbox"></div>
												</div>
											</td> -->
                        </tr>
                        <tr>
                            <th class="bd_l" id="tel_no"></th>
                            <!-- 연락처 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox"
                                        id="WHSDL_RPST_TEL_NO"></div>
                                </div>
                            </td>
                            <th class="bd_l" id="user_nm"></th>
                            <!-- 성명 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id=WHSDL_RPST_NM></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="4" id="receiver"></th>
                            <th class="bd_l" id="mtl_nm2"></th>
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="MFC_BIZRNM"></div>
                                    <!-- 상호명 -->
                                </div>
                            </td>
                            <th class="bd_l" id="bizrno2"></th>
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="MFC_BIZRNO"></div>
                                    <!-- 사업자등록번호 -->
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="bd_l" id="addr2"></th>
                            <!-- 생산자 주소 -->
                            <td colspan="3">
                                <div class="row">
                                    <div class="txtbox" id="MFC_ADDR"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="bd_l" id="tel_no2"></th>
                            <!-- 전화번호 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox"
                                        id="MFC_RPST_TEL_NO"></div>
                                </div>
                            </td>
                            <th class="bd_l" id="user_nm2"></th>
                            <!-- 성명 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="MFC_RPST_NM"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="bd_l" id="mfc_brch_nm"></th>
                            <!-- 직매장 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="MFC_BRCH_NM"></div>
                                </div>
                            </td>
                            <th class="bd_l" id="car_no"></th>
                            <!-- 차량번호 -->
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
            <div class="h4group">
                <h5 class="tit" style="font-size: 16px;" id="rtn_data">
                    <h5>
            </div>
            <div id="gridHolder"
                style="height: 360px; background: #FFF;"></div>
        </div>
        <!-- 그리드 셋팅 -->


        <section class="secwrap">
        <div class="h4group">
            <h5 class="tit" style="font-size: 16px; margin-top: 10px"
                id="wrhs_cfm_data">
                <h5>
        </div>
        <div class="srcharea" id="divInput">
            <div class="row">
                <div class="col">
                    <div class="tit" id="ctnr_se"></div>
                    <!-- 빈용기구분 -->
                    <div class="box">
                        <select id="CTNR_SE" style="width: 41%"
                            class="i_notnull"></select>
                        <!-- 구병/신병 -->
                        <select id="PRPS_CD" style="width: 57%"
                            class="i_notnull"></select>
                        <!-- 유흥 / 가정 / 직접 -->
                    </div>
                </div>

                <div class="col">
                    <div class="tit" id="ctnr_nm"></div>
                    <!-- 빈용기명 -->
                    <div class="box" style="width: 65%">
                        <select id="CTNR_CD" class="i_notnull"></select>
                    </div>
                </div>

                <div class="col">
                    <div class="tit" id="rtn_qty"></div>
                    <!-- 반환량(개) -->
                    <div class="box">
                        <input type="text" id="RTN_QTY" style=""
                            format="number" maxlength="8"
                            disabled="disabled" />
                    </div>
                </div>
            </div>
            <!-- end of row -->
            <div class="row">
                <div class="col">
                    <div class="tit" style="width: 38%">소매수수료 적용여부</div>
                    <div class="box" id="RMK_LIST" style="width: 52%">
                        <label class="rdo"><input type="radio"
                            id="select_rtl1" name="select_rtl"
                            value="aplc" checked="checked"><span
                            id="">적용</span></label> <label class="rdo"><input
                            type="radio" id="select_rtl2"
                            name="select_rtl" value="ext"><span
                            id="">제외</span></label>
                    </div>
                </div>
                <div class="col" style="width: 65%">
                    <div class="tit">비고</div>
                    <!-- 비고 -->
                    <div class="box" style="width: 84%">
                        <select id="RMK_SELECT" style="width: 29%"
                            disabled="disabled"></select> <input
                            type="text" id="RMK"
                            style="width: 69%; max-width: 610px"
                            maxByteLength="30" disabled="disabled" />
                    </div>
                </div>
            </div>
            <!-- end of row -->
            <div class="row">
                <div class="col">
                    <div class="tit" id="dmgb_qty"></div>
                    <!-- 결병 -->
                    <div class="box">
                        <input type="text" id="DMGB_QTY" style=""
                            format="number" maxlength="8"
                            disabled="disabled" />
                    </div>
                </div>

                <div class="col">
                    <div class="tit" id="vrsb_qty"></div>
                    <!-- 잡병 -->
                    <div class="box">
                        <input type="text" id="VRSB_QTY" style=""
                            format="number" maxlength="8"
                            disabled="disabled" />
                    </div>
                </div>

                <div class="col">
                    <div class="tit" id="cfm_qty"></div>
                    <!-- 확인량 -->
                    <div class="box">
                        <input type="text" id="CFM_QTY" style=""
                            format="number" maxlength="8" />
                    </div>
                </div>

            </div>
            <!-- end of row -->
            <div class="singleRow" style="float: right">
                <div class="btn" id="CR"></div>
            </div>

        </div>
        <!-- end of srcharea --> </section>

        <div class="boxarea mt10">
            <div id="gridHolder2"
                style="height: 360px; background: #FFF;"></div>
        </div>
        <!-- 그리드 셋팅 -->

        <section class="btnwrap mt10">
        <div class="btn" id="BL"></div>
        <div class="btn" style="float: right" id="BR"></div>
        </section>
    </div>

</body>
</html>