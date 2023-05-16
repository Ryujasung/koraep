<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>표준용기코드관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

     //var stdCtnrList = ${stdCtnrList};
     
     var langSeList;         //언어구분코드
     var cpctCdList;         //용량코드
     var prpsCdList;       //용어코드
     var mfcSeCdList;  //생산자구분
     var alkndCdList;     //주종구분
     var input ={};
     
	$(function() {
		
		langSeList 		=  jsonObject($("#langSeList").val());	
		cpctCdList		=  jsonObject($("#cpctCdList").val());       
		prpsCdList 		=  jsonObject($("#prpsCdList").val());
		mfcSeCdList 	=  jsonObject($("#mfcSeCdList").val());       
		alkndCdList 	=  jsonObject($("#alkndCdList").val());      
		
		
		fnSetGrid1();
		
		 //언어 셋팅
		 //조회부분
		$('#lang_se_sel').text(parent.fn_text('lang_se')); //언어구분 조회
		
		$('#use_yn_sel').text(parent.fn_text('use_yn'));     //사용여부
		$('#use_y_sel').text(parent.fn_text('use_y'));
		$('#use_n_sel').text(parent.fn_text('use_n'));
		
		$('#dlivy_use_yn_sel').text(parent.fn_text('dlivy_use_yn'));     //출고사용여부
		$('#dlivy_use_y_sel').text(parent.fn_text('use_y'));
		$('#dlivy_use_n_sel').text(parent.fn_text('use_n'));
		$('#ctnr_nm_sel').text(parent.fn_text('ctnr_nm'));     //용기명

		//입력창부분
		$('#cpct_cd').text(parent.fn_text('cpct_cd'));      //용량
		$('#prps_cd').text(parent.fn_text('prps_cd'));      //용도
		$('#mfc_se_cd').text(parent.fn_text('mfc_se_cd'));   //생산지구분
		$('#alknd_cd').text(parent.fn_text('alknd_cd'));   //주종구분
		
		$('#ctnr_cd').text(parent.fn_text('ctnr_cd'));         //용기코드
		$('#lang_se').text(parent.fn_text('lang_se'));                //언어구분
		$('#dlivy_use_yn').text(parent.fn_text('dlivy_use_yn'));   //출고사용여부
		$('#dlivy_use_y').text(parent.fn_text('use_y'));
		$('#dlivy_use_n').text(parent.fn_text('use_n'));
		$('#use_yn').text(parent.fn_text('use_yn'));     //사용여부
		$('#use_y').text(parent.fn_text('use_y'));
		$('#use_n').text(parent.fn_text('use_n'));
		
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));       //용기명
		$('#sel_ord').text(parent.fn_text('sel_ord'));         //표시순서
		
		 //div필수값 alt
		 $("#CTNR_CD").attr('alt',parent.fn_text('ctnr_cd'));      //용기코드   
		 $("#CTNR_NM").attr('alt',parent.fn_text('ctnr_nm'));   //용기명     
		 $("#SEL_ORD").attr('alt',parent.fn_text('sel_ord'));      //표시순서
		
		/************************************
		 * 초기화버튼 클릭 이벤트
		 ***********************************/
		$("#btn_init").click(function(){
			fn_init();
		});
      
		/************************************
		 * 조회버튼 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			fn_sel();
		});
		/************************************
		 * 저장버튼 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		kora.common.setEtcCmBx2(langSeList, "","", $("#LANG_SE_CD"),       "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(langSeList, "","", $("#LANG_SE_CD_SEL"), "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(cpctCdList, "","", $("#CPCT_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		kora.common.setEtcCmBx2(prpsCdList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		kora.common.setEtcCmBx2(mfcSeCdList, "","", $("#MFC_SE_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		kora.common.setEtcCmBx2(alkndCdList, "","", $("#ALKND_CD"), "ETC_CD", "ETC_CD_NM", "N","S");

	});

	//조회
   function fn_sel(){

		var url = "/CE/EPCE3951201_19.do";
	    var input_sel ={};
	    
	    input_sel["LANG_SE_CD_SEL"]      	 = $("#LANG_SE_CD_SEL option:selected").val();
	    input_sel["DLIVY_USE_YN_SEL"]      	 = $("#DLIVY_USE_YN_SEL option:selected").val();
	    input_sel["USE_YN_SEL"]             	 = $("#USE_YN_SEL option:selected").val();
	    input_sel["CTNR_NM_SEL"]              = $("#CTNR_NM_SEL").val();
		
   	    showLoadingBar();
      	   ajaxPost(url, input_sel, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {
   					gridApp.setData(rtnData.stdCtnrList);
   				} else {
   					alertMsg("error");
   				}
   		});
   			hideLoadingBar();
		
   }
	
	//초기화
	function fn_init(){
		
		$("#USE_YN_SEL").val("Y").prop("selected",true);
		$("#DLIVY_USE_YN_SEL").val("Y").prop("selected",true);
		$("#CTNR_NM_SEL").val("");
		
		$("#USE_YN").val("Y").prop("selected",true);
		$("#DLIVY_USE_YN").val("Y").prop("selected",true);
		$("#CTNR_NM").val("");
		
		$("#CTNR_CD").val("");
		$("#SEL_ORD").val("");
		
	    $("#LANG_SE_CD_SEL  option").remove();    
   	    $("#LANG_SE_CD  option").remove();
   	    $("#CPCT_CD  option").remove();    
 	    $("#PRPS_CD  option").remove();
 	    $("#MFC_SE_CD  option").remove();    
  	    $("#ALKND_CD  option").remove();
		
		
		kora.common.setEtcCmBx2(langSeList, "","", $("#LANG_SE_CD"),       "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(langSeList, "","", $("#LANG_SE_CD_SEL"), "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(cpctCdList, "","", $("#CPCT_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		kora.common.setEtcCmBx2(prpsCdList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		kora.common.setEtcCmBx2(mfcSeCdList, "","", $("#MFC_SE_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		kora.common.setEtcCmBx2(alkndCdList, "","", $("#ALKND_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		
	}
	
	//저장
	function fn_reg(){
		
		 var url = "/CE/EPCE3951201_192.do";
    	      input ={};
		 
		//필수입력값 체크
		if (!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		
		input["CPCT_CD"]              = $("#CPCT_CD option:selected").val();       //용량
		input["PRPS_CD"]              = $("#PRPS_CD option:selected").val();        //용도
		input["MFC_SE_CD"]          = $("#MFC_SE_CD option:selected").val();        //생산자구분
		input["ALKND_CD"]           = $("#ALKND_CD option:selected").val();        //주종구분
		input["CTNR_CD"]             = $("#CTNR_CD").val();                             //용기코드
		input["LANG_SE_CD"]      	 = $("#LANG_SE_CD option:selected").val();   //언어구분
		input["DLIVY_USE_YN"]      = $("#DLIVY_USE_YN option:selected").val(); //출고사용여부
		input["USE_YN"]             	 = $("#USE_YN option:selected").val();          //사용여부
		input["CTNR_NM"]            = $("#CTNR_NM").val();                            //용기명
		input["SEL_ORD"]              = $("#SEL_ORD").val();                              //표시순서
		input["SAVE_CHK"]    = "S" //   I일경우 저장  , U일경우 수정 
		
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
			
				if(rtnData.RSLT_CD =="A003"){ //중복일경우
					confirm(  (parent.fn_text('present')+"  " + $("#CTNR_CD").val()+ " " +parent.fn_text('same_cd')),"fn_reg_cmpt" );
						input["SAVE_CHK"]    = "U"
						return;
					
				}else if(rtnData.RSLT_CD =="0000"){
					confirm(	 (parent.fn_text('ctnr_cd')+ "  " +parent.fn_text('new_cd')),"fn_reg_cmpt")
					return;
				}
			
			} else {
				alertMsg("error");
			}
		}); 
		 
		
	}
	//저장 수정 완료
	function  fn_reg_cmpt(){
		
		var url = "/CE/EPCE3951201_09.do";
		 showLoadingBar();
     	   ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {
  					alertMsg(rtnData.RSLT_MSG);
  					fn_init(); //입력창 초기화
  					fn_sel();  
  				} else {
  					alertMsg("error");
  				}
  		}); 
  			hideLoadingBar();
	}
	

	//용기코드 생성
	function fn_cpct_cd(){
		
		if( $("#CPCT_CD").val()      !=""   && $("#PRPS_CD").val()     != ""   && $("#MFC_SE_CD").val()  != ""  && $("#ALKND_CD").val()  != ""     ) {
			$("#CTNR_CD").val(  $("#CPCT_CD").val()  + $("#PRPS_CD").val() +$("#MFC_SE_CD").val()+$("#ALKND_CD").val() ); 
		} else {
			$("#CTNR_CD").val("");
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
		layoutStr	.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="35">');
		layoutStr.push('		<columns>');
		layoutStr.push('			<DataGridSelectorColumn id="selector" width="5%" textAlign="center" allowMultipleSelection="false" headerText="'+parent.fn_text('sel')+'"/>');
		layoutStr.push('			<DataGridColumn dataField="SEL_ORD" headerText="'+parent.fn_text('sel_ord')+'" width="7%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="LANG_SE_CD" headerText="'+parent.fn_text('lang_se')+'"  width="10%" textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="CTNR_CD" headerText="'+parent.fn_text('ctnr_cd')+'"  width="15%" itemRenderer="HtmlItem"  textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+parent.fn_text('ctnr_nm')+'"  width="45%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="DLIVY_USE_YN" headerText="'+parent.fn_text('dlivy_use_yn')+'"  width="10%" textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="USE_YN" headerText="'+parent.fn_text('use_yn')+'"  width="10%" textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="PRPS_CD"    headerText="'+parent.fn_text('prps_cd')+'"      width="10%" textAlign="center" visible="false"/>');
		layoutStr.push('			<DataGridColumn dataField="CPCT_CD"    headerText="'+parent.fn_text('cpct_cd')+'"      width="10%" textAlign="center" visible="false"/>');
		layoutStr.push('			<DataGridColumn dataField="MFC_SE_CD"    headerText="'+parent.fn_text('mfc_se_cd')+'"      width="10%" textAlign="center" visible="false"/>');
		layoutStr.push('			<DataGridColumn dataField="ALKND_CD"    headerText="'+parent.fn_text('alknd_cd')+'"      width="10%" textAlign="center" visible="false"/>');
		layoutStr.push('		</columns>');
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
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			fn_rowToInput(rowIndex);
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

	/**
	 * 그리드 loading bar on
	 */
	function showLoadingBar() {
		kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	/**
	 * 그리드 loading bar off
	 */
	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}
	
	//행선택시 입력값 input에  넣기
	function fn_rowToInput(rowIndex) {
		var item = gridRoot.getItemAt(rowIndex);
		selectorColumn.setSelectedIndex(-1);
		selectorColumn.setSelectedIndex(rowIndex);
		$("#CPCT_CD").val( item["CPCT_CD"]).prop("selected", true);         //용량
		$("#PRPS_CD").val( item["PRPS_CD"]).prop("selected", true);          //용도
		$("#MFC_SE_CD").val( item["MFC_SE_CD"]).prop("selected", true);   //생산자구분
		$("#ALKND_CD").val(	 item["ALKND_CD"]).prop("selected", true);     //주종구분
		
		$("#CTNR_CD").val(item["CTNR_CD"]);     //용기코드
		$("#LANG_SE_CD").val(	item["LANG_SE_CD"]).prop("selected", true);   //언어구분
		$("#DLIVY_USE_YN").val(item["DLIVY_USE_YN_ORI"]).prop("selected", true);            //사용여부
		$("#USE_YN").val(item["USE_YN_ORI"]).prop("selected", true);            //사용여부
		
		$("#CTNR_NM").val(item["CTNR_NM"]);     // 용기명
		$("#SEL_ORD").val(item["SEL_ORD"]);        //표시순서

		
	};

/****************************************** 그리드 셋팅 끝***************************************** */


</script>
<style type="text/css">

.row .tit{
width: 77px;
}

</style>

</head>
<body>
    <div class="iframe_inner">
   		<input type="hidden" id="langSeList" value="<c:out value='${langSeList}' />" />
		<input type="hidden" id="cpctCdList" value="<c:out value='${cpctCdList}' />" />
		<input type="hidden" id="prpsCdList" value="<c:out value='${prpsCdList}' />" />
		<input type="hidden" id="mfcSeCdList" value="<c:out value='${mfcSeCdList}' />" />
   		<input type="hidden" id="alkndCdList" value="<c:out value='${alkndCdList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>
		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit" id="lang_se_sel"></div>  <!-- 언어구분 -->
						<div class="box">
							<select id="LANG_SE_CD_SEL" style="width: 179px">
							</select>
						</div>
					</div>
					
					<div class="col"> 
						<div class="tit" id="use_yn_sel"></div>  <!-- 사용여부 -->
						<div class="box">
							<select id="USE_YN_SEL" style="width: 179px" class="i_notnull"> 
								<option value="Y" id="use_y_sel"></option>
								<option value="N" id="use_n_sel"></option>
							</select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="dlivy_use_yn_sel"></div>  <!-- 출고사용여부 -->
						<div class="box">
							<select id="DLIVY_USE_YN_SEL" style="width: 179px" class="i_notnull">
								<option value="Y" id="dlivy_use_y_sel"></option>
								<option value="N" id="dlivy_use_n_sel"></option>
							</select>
						</div>
					</div>
				</div> <!-- end of row -->
				
				<div class="row">
					<div class="col" style="width: 80%">
							<div class="tit" id="ctnr_nm_sel"></div>   <!-- 용기명 -->
							<div class="box" style="width: 80%">
								<input type="text" id="CTNR_NM_SEL" style="width: 100%"  maxByteLength="90">
							</div>
					</div>
					<div class="btn">
							<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
					</div>
				</div> <!-- end of row -->
				
			</div>  <!-- end of srcharea -->
		</section>
	
		<section class="secwrap mt30">
			<div class="srcharea" id="divInput">
				<div class="row">
					<div class="col">
						<div class="tit" id="cpct_cd"></div> <!-- 용량 -->
						<div class="box">
							<select id="CPCT_CD" style="width: 179px"  onchange="fn_cpct_cd();"></select>   
						</div>
					</div>
					<div class="col">
						<div class="tit" id="prps_cd"></div><!-- 용도-->
						<div class="box">
						    <select id="PRPS_CD" style="width: 179px"  onchange="fn_cpct_cd();"></select> 
						</div>
					</div>
					<div class="col">
						<div class="tit" id="mfc_se_cd"></div>  <!-- 생산자구분 -->
						<div class="box">
							<select id="MFC_SE_CD" style="width: 179px" onchange="fn_cpct_cd();" ></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="alknd_cd"></div>  <!-- 주종구분 -->
						<div class="box">
							<select id="ALKND_CD" style="width: 179px"  onchange="fn_cpct_cd();"></select>
						</div>
					</div>
			</div>  <!--end of row  -->
	
				<div class="row">
					<div class="col">
						<div class="tit" id="ctnr_cd"></div>  <!-- 용기코드 -->
						<div class="box">
							<input type="text" id="CTNR_CD"	style="width: 179px; text-align: right; color:red; text-weight:bold;" class="i_notnull" readonly="readonly" >
						</div>
					</div>
							<div class="col">
						<div class="tit" id="lang_se"></div> <!-- 언어구분 -->
						<div class="box">
							<select id="LANG_SE_CD" style="width: 179px"  ></select>  
						</div>
					</div>
				<div class="col">
						<div class="tit" id="dlivy_use_yn"></div> <!-- 출고사용여부 -->
						<div class="box">
							<select id="DLIVY_USE_YN" style="width: 179px" >          
								<option value="Y" id="dlivy_use_y"></option>
								<option value="N" id="dlivy_use_n"></option>
							</select>
						</div>
				 </div>
				<div class="col">
						<div class="tit" id="use_yn"></div> <!-- 사용여부 -->
						<div class="box">   
							<select id="USE_YN" style="width: 179px" >         
								<option value="Y" id="use_y"></option>
								<option value="N" id="use_n"></option>
							</select>
						</div>
				 </div>
					
				</div>

			<div class="row">
			
				
				<div class="col">
					<div class="tit" id="sel_ord"></div>  <!-- 표시순서 -->
					<div class="box">
						<input type="text" id="SEL_ORD"	style="width: 179px; text-align: right;" format="number"  maxByteLength="3" class="i_notnull">
					</div>
				</div>
				<div class="col" 	style="width: 50%;">
					<div class="tit" id="ctnr_nm"></div>  <!-- 용기명 -->
					<div class="box" 	style="width: 72%;"> 
						<input type="text" id="CTNR_NM"	style=" text-align: right;" 	class="i_notnull"  maxByteLength="90">
					</div>
				</div>
				  <div class="btn" style="float: right;">
					<button type="button" class="btn36 c4" style="width: 100px;"	id="btn_init">초기화</button>
					<button type="button" class="btn36 c2" style="width: 100px;"   id="btn_reg">저장</button>
				</div>
			</div>
			
		</div>
		     

			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
	
	
		</section>	<!-- end of secwrap mt30  -->

</div>

</body>
</html>