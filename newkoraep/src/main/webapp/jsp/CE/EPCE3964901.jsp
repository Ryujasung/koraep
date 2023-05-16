<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수용기코드관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

     //var rtrvlCtnrList = ${rtrvlCtnrList};     
     var langSeList       //언어구분코드
     var cpctCdList      //용량코드
     var prpsCdList      //용어코드
     var input ={};
     
	$(function() {
		
		langSeList 		=  jsonObject($("#langSeList").val());
		cpctCdList 		=  jsonObject($("#cpctCdList").val());       
		prpsCdList 		=  jsonObject($("#prpsCdList").val());      
		
		
		$('#lang_se').text(parent.fn_text('lang_se'));
		$('#lang_se_sel').text(parent.fn_text('lang_se'));
		$('#ctnr_cd').text(parent.fn_text('ctnr_cd'));         //용기코드
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));       //용기명
		$('#ctnr_nm_sel').text(parent.fn_text('ctnr_nm'));  //용기명 조회
		$('#cpct_cd').text(parent.fn_text('cpct_cd'));        //용량
		$('#prps_cd').text(parent.fn_text('prps_cd'));        //용도
		
		$('#use_yn_sel').text(parent.fn_text('use_yn'));
		$('#use_y_sel').text(parent.fn_text('use_y'));
		$('#use_n_sel').text(parent.fn_text('use_n'));
		
		$('#use_yn').text(parent.fn_text('use_yn'));
		$('#use_y').text(parent.fn_text('use_y'));
		$('#use_n').text(parent.fn_text('use_n'));
		
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
		
		
		
		fnSetGrid1();
		
		kora.common.setEtcCmBx2(langSeList, "","", $("#LANG_SE_CD"),       "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(langSeList, "","", $("#SEL_LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(cpctCdList, "","", $("#CPCT_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		kora.common.setEtcCmBx2(prpsCdList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
	   	
	});
      
     //조회
      function fn_sel(){
    	    var input_sel ={};
    	    input_sel["SEL_LANG_SE_CD"]      	 = $("#SEL_LANG_SE_CD option:selected").val();
    	    input_sel["SEL_USE_YN"]             	 = $("#SEL_USE_YN option:selected").val();
    	    input_sel["SEL_CTNR_NM"]              = $("#SEL_CTNR_NM").val();
    		var url ="/CE/EPCE3964901_19.do"
   	    	showLoadingBar();
   	       	ajaxPost(url, input_sel, function(rtnData) {
   	    				if ("" != rtnData && null != rtnData) {
   	    					fn_init();
   	    					gridApp.setData(rtnData.rtrvlCtnrList);
   	    				} else {
   	    					alertMsg("error");
   	    				}
   	    			hideLoadingBar();
   	    	});
      }
	    
     
     
	//초기화
	function fn_init(){
		
		$("#SEL_USE_YN").val("Y").prop("selected",true);
		$("#USE_YN").val("Y").prop("selected",true);
		$("#SEL_CTNR_NM").val("");
		$("#CTNR_NM").val("");
		$("#RTRVL_CTNR_CD").val("");
		
		 $("#SEL_LANG_SE_CD  option").remove();    
    	 $("#LANG_SE_CD  option").remove();
    	 $("#CPCT_CD  option").remove();    
    	 $("#PRPS_CD  option").remove();
    
   		kora.common.setEtcCmBx2(cpctCdList, "","", $("#CPCT_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
   		kora.common.setEtcCmBx2(prpsCdList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N","S");
		kora.common.setEtcCmBx2(langSeList, "","", $("#LANG_SE_CD"),       "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(langSeList, "","", $("#SEL_LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
		
	}
	
	//저장
	function fn_reg(){
		//필수입력값 체크
		if (!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		var url ="/CE/EPCE3964901_192.do"
		 input ={};
		
		input["LANG_SE_CD"]      	 = $("#LANG_SE_CD option:selected").val();
		input["USE_YN"]             	 = $("#USE_YN option:selected").val();
		input["CPCT_CD"]              = $("#CPCT_CD option:selected").val();
		input["PRPS_CD"]              = $("#PRPS_CD option:selected").val();
		input["CTNR_NM"]            = $("#CTNR_NM").val();
		input["RTRVL_CTNR_CD"]   = $("#RTRVL_CTNR_CD").val();
		input["SAVE_CHK"]    = "S" //   I일경우 저장  , U일경우 수정
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
			
				if(rtnData.RSLT_CD =="A003"){ //중복일경우
					confirm((parent.fn_text('present')+"  " + $("#RTRVL_CTNR_CD").val()+ " " +parent.fn_text('same_cd')) ,"fn_reg_cmpt");
					input["SAVE_CHK"]    = "U";
					return;
				}else if(rtnData.RSLT_CD =="0000"){
					confirm(	 (parent.fn_text('rtrvl_ctnr_cd')+ "  " +parent.fn_text('new_cd')),"fn_reg_cmpt")
					return;
				}
			} else {
				alertMsg("error");
			}
		}, false); 
			
	}
	//저장 완료
	function fn_reg_cmpt(){
		
	 	   var url ="/CE/EPCE3964901_09.do"
	    	   showLoadingBar();
	       	   ajaxPost(url, input, function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {
	    					alertMsg(rtnData.RSLT_MSG);
	    					fn_init(); //입력창 초기화
	    					fn_sel();  
	    				} else {
	    					alertMsg("error");
	    				}
	    			hideLoadingBar();
	    		});
	     }
	
	
	//용기코드 생성
	function fn_cpct_cd(){
		
		if("" != $("#CPCT_CD").val() && "" != $("#PRPS_CD").val()){
			$("#RTRVL_CTNR_CD").val( $("#CPCT_CD").val()+ $("#PRPS_CD").val()); 
		} else {
			$("#RTRVL_CTNR_CD").val("");
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
		layoutStr.push('			<DataGridSelectorColumn id="selector" width="10%" textAlign="center" allowMultipleSelection="false"  headerText="'+parent.fn_text('sel')+'" />');
		layoutStr.push('			<DataGridColumn dataField="LANG_SE_CD" headerText="'+parent.fn_text('lang_se')+'" width="15%" textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="RTRVL_CTNR_CD" headerText="'+parent.fn_text('ctnr_cd')+'" width="15%" itemRenderer="HtmlItem"  textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+parent.fn_text('ctnr_nm')+'" width="15%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="USE_YN"    headerText="'+parent.fn_text('use_yn')+'"      width="10%" textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="PRPS_CD"    headerText="'+parent.fn_text('prps_cd')+'"      width="10%" textAlign="center" visible="false"/>');
		layoutStr.push('			<DataGridColumn dataField="CPCT_CD"    headerText="'+parent.fn_text('cpct_cd')+'"      width="10%" textAlign="center" visible="false"/>');
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
		
		$("#CPCT_CD").val(item["CPCT_CD"]).prop("selected", true);              // 용량코드
		$("#PRPS_CD").val(item["PRPS_CD"]).prop("selected", true);               // 용도코드
	    $("#LANG_SE_CD").val(item["LANG_SE_CD"]).prop("selected", true);  //언어구분
		$("#RTRVL_CTNR_CD").val(item["RTRVL_CTNR_CD"]);                       // 용기코드
		$("#CTNR_NM").val(item["CTNR_NM"]);                                        // 용기명
		$("#USE_YN").val(item["USE_YN_ORI"]).prop("selected", true);                 // 사용여부
	};

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.row  .tit {
 width : 70px
 }   
 
 

</style>
</head>
<body>
    <div class="iframe_inner">
      	<input type="hidden" id="langSeList" value="<c:out value='${langSeList}' />" />
		<input type="hidden" id="cpctCdList" value="<c:out value='${cpctCdList}' />" />
		<input type="hidden" id="prpsCdList" value="<c:out value='${prpsCdList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>

		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col" style="width: 280px">
						<div class="tit" id="lang_se_sel"></div>
						<div class="box">
							<select id="SEL_LANG_SE_CD" style="width: 117px">
							</select>
						</div>
					</div>
					
					<div class="col" style="">
						<div class="tit" id="use_yn_sel"></div>
						<div class="box">
							<select id="SEL_USE_YN" style="width: 117px" >
								<option value="Y" id="use_y_sel"></option>
								<option value="N" id="use_n_sel"></option>
							</select>
						</div>
					</div>
					</div>
						<div class="row">
					<div class="col" style="width: 80%">
						<div class="tit" id="ctnr_nm_sel"></div>
						<div class="box"   style="width:80% ">
							<input type="text" id="SEL_CTNR_NM"	style="width:100% ; text-align: left;" maxlength="40"  >
						</div>
					</div>
					<div class="btn">
						<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
					</div>
				</div>
			</div>
		</section>
	
		<section class="secwrap mt30">
			<div class="srcharea" id="divInput">
				<div class="row">
					<div class="col">
						<div class="tit" id="cpct_cd"></div>
						<div class="box">
							<select id=CPCT_CD style="width: 179px" class="i_notnull" onchange="fn_cpct_cd();" alt="용량"  ></select>
						</div>
					</div>
					<div class="col">
						<div class="tit"  id="prps_cd"></div>
						<div class="box">    
						   <select id=PRPS_CD style="width: 179px" class="i_notnull" onchange="fn_cpct_cd();" alt="용도"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="lang_se"></div>
						<div class="box">
							<select id="LANG_SE_CD" style="width: 179px" class="i_notnull" ></select>
						</div>
					</div>
			
			    	<div class="col" >
						<div class="tit"  id="use_yn"></div>
						<div class="box">
							<select id="USE_YN" style="width: 179px" class="i_notnull" >
								<option value="Y" id="use_y"></option>
								<option value="N" id="use_n"></option>
							</select>
						</div>
					</div>
	            </div>  <!--end of row  -->
				<div class="row">
					<div class="col">
						<div class="tit" id="ctnr_cd"></div>    
						<div class="box">
							<input type="text" id="RTRVL_CTNR_CD"	readonly="readonly"  style="width: 179px; text-align: right; color:red; text-weight:bold;"	class="i_notnull" alt="용기코드">
						</div>
					</div>
					<div class="col">
						<div class="tit" id="ctnr_nm"></div>
						<div class="box">
							<input type="text" id="CTNR_NM"	 style="width: 179px; text-align: right;" maxlength="40"	class="i_notnull" alt="용기명"  maxByteLength="90">
						</div>
					</div>
					<div class="btn">
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