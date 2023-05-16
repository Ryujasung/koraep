<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS;

		$(document).ready(function(){

			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			//버튼 셋팅
			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#whsdl').text(parent.fn_text('whsdl'));
			$('#brch_nm').text(parent.fn_text('brch_nm'));
			$('#bizr_tp').text(parent.fn_text('bizr_tp_cd'));
			$('#cust_bizrnm').text(parent.fn_text('cust_bizrnm'));
			$('#bizrno').text(parent.fn_text('bizrno'));
			
			$('#WHSDL_BIZR').attr('alt', parent.fn_text('whsdl'));
			$('#WHSDL_BRCH').attr('alt', parent.fn_text('brch_nm'));
			$('#BIZR_TP_CD').attr('alt', parent.fn_text('bizr_tp_cd'));
			$('#BIZRNM').attr('alt', parent.fn_text('cust_bizrnm'));
			$('#BIZRNO').attr('alt', parent.fn_text('bizrno'));
			
			var bizrList = jsonObject($('#bizrList').val());
			var bizrTpList = jsonObject($('#bizrTpList').val());

			kora.common.setEtcCmBx2(bizrList, "", "", $("#WHSDL_BIZR"), "BIZRID_NO", "BIZRNM", "N", "S");
			kora.common.setEtcCmBx2([], "", "", $("#WHSDL_BRCH"), "BRCHID_NO", "BRCH_NM", "N", "S");
			kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
			
			$("#WHSDL_BIZR").select2();
			
			//그리드 셋팅
			fn_set_grid();

			/************************************
			 * 도매업자 변경 이벤트
			 ***********************************/
			$("#WHSDL_BIZR").change(function(){
				fn_change();
			});
			
			//행추가 버튼
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//행변경 버튼
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			//행삭제 버튼
			$("#btn_del").click(function(){
				fn_del();
			});
			
			//취소 버튼
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			//저장 버튼
			$("#btn_reg2").click(function(){
				fn_reg2();
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
				kora.common.gfn_excelUploadPop("fn_popExcel");
			});

		});
		
		//양식다운로드
	     function fn_excelDown() {
	    	downForm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
	     	$("#downForm").submit();
	     };
	     
	     /**
	      * 엑셀 업로드 후처리
	      */
	     function fn_popExcel(rtnData) {

	     	var input  	= {};
	     	var ctnrCd 	= "";
	     	var flag 	= false;
	     	var dup_cnt 	= 0;		//중복 데이터
	    	var err_cnt 	= 0;		//잘못된 데이터로 디비 정보가 없을 경우
	    	var err_msg = "";
	    	var err_msg2 = "";
	     	
	    	 for(var i=0; i<rtnData.length ;i++) {

	    		 if(
	    			rtnData[i].도매업자사업자번호 =="" ||
	    			rtnData[i].지점번호 =="" ||
	    			rtnData[i].거래처구분 =="" ||
	    			rtnData[i].거래처명 =="" ||
	    			rtnData[i].거래처사업자번호 ==""
	    		  ){
	    			alertMsg("필수입력값이 없습니다.")
	    			return;
	    		 }
	    	 }

	     	 for(var i=0; i<rtnData.length ;i++) {
	     		 
	     		flag= false;
	     		input["WHSDL_BIZRNO"]			= rtnData[i].도매업자사업자번호;
	     		input["WHSDL_BRCH_NO"]		= rtnData[i].지점번호;
	     		input["BIZR_TP_NM"]				= rtnData[i].거래처구분;
	     		
	     		if(input["BIZR_TP_NM"] == '소매업자(가정용)'){
	     			input["BIZR_TP_CD"] = 'R1'
	     		}else if(input["BIZR_TP_NM"] == '소매업자(영업용)'){
	     			input["BIZR_TP_CD"] = 'R2'
	     		}else{
	     			err_cnt++
					continue;
	     		}
	     		
	     		input["BIZRNM"]						= rtnData[i].거래처명;
	     		input["BIZRNO"]						= rtnData[i].거래처사업자번호;
	     		
	     		//사업자번호 체크
	     		if(!kora.common.gfn_bizNoCheck(input["WHSDL_BIZRNO"]) || !kora.common.gfn_bizNoCheck(input["BIZRNO"])){
	     			err_cnt++
					continue;
				}
	     		
	     		var url = "/CE/EPCE0121831_192.do";
	     		ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {   
	    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
	    						var collection = gridRoot.getCollection();  //그리드 데이터
							    for(var i=0; i<collection.getLength(); i++) {
							    	var gridData = gridRoot.getItemAt(i);
							    	if( gridData.WHSDL_BIZRNO == input["WHSDL_BIZRNO"]
								    	 && gridData.WHSDL_BRCH_NO == input["WHSDL_BRCH_NO"]
								    	 && gridData.BIZRNO == input["BIZRNO"]
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
		
		//저장여부, 사업자유형 체크
		function fn_dataCheck(gbn, input, idx){
			
			var url  = "/CE/EPCE0121831_19.do";

			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					
					if(rtnData.RSLT_CD != '0000' && rtnData.RSLT_CD != 'A002'){ //가맹점은 중복데이터 업데이트 처리
						alertMsg(rtnData.RSLT_MSG, '');
					}else{
						if(gbn == 'ADD'){
							//데이터 추가
							gridRoot.addItemAt(input);
							dataGrid.setSelectedIndex(-1);
						}else if(gbn == 'UPD'){
							//해당 데이터 수정
							gridRoot.setItemAt(input, idx);
						}
					}
				} else {
					alertMsg("error");
				}
			});
		}
		
		function fn_reg2(){
			
			var collection = gridRoot.getCollection();
			if(collection.getLength() < 1){
				alertMsg("데이터가 없습니다.");
				return;
			}
			
			confirm('거래처 사업자번호가 지점정보에 등록되어 있는 경우 \n해당 사업자 및 지점정보를 이용하여 등록됩니다. \n저장하시겠습니까?', 'fn_reg2_exec');
		}
		
		function fn_reg2_exec(){

			var url  = "/CE/EPCE0121831_09.do";
			var data = {};
			var row = new Array();
			var collection = gridRoot.getCollection();
		 	for(var i=0;i<collection.getLength(); i++){
		 		var item = gridRoot.getItemAt(i);
		 		row.push(item);
		 	}
			
		 	data["FRC_YN"] = 'Y'; //가맹점여부
			data["list"] = JSON.stringify(row);
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
				} else {
					alertMsg("error");
				}
			});
		}
		
		//취소
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		//행삭제
		function fn_del(){
			var idx = dataGrid.getSelectedIndex();

			if(idx < 0) {
				alertMsg("삭제할 행을 선택하시기 바랍니다.");
				return;
			}
			
			gridRoot.removeItemAt(idx);
		}
		 
		//행추가
		function fn_reg(){
			
            if($("#WHSDL_BIZR").val() ==""){
                alertMsg(parent.fn_text('whsdl')+parent.fn_text('cfm_chk'));
                return false;
            }

			if(!kora.common.cfrmDivChkValid("params")) {
				return;
			 }
			
			if(!kora.common.gfn_bizNoCheck($('#BIZRNO').val())){
				alertMsg("정상적인 사업자등록번호가 아닙니다.");
				$('#BIZRNO').focus();
				return;
			}

			var input = insRow('A');
			if(!input) return;
			
			//DB데이터 체크
			fn_dataCheck('ADD', input);
			
		}
		
		//행변경
		function fn_upd(){
			
			var idx = dataGrid.getSelectedIndex();
			
			if(idx < 0) {
				alertMsg("변경할 행을 선택하시기 바랍니다.");
				return;
			}
			
            if($("#WHSDL_BIZR").val() ==""){
                alertMsg(parent.fn_text('whsdl')+parent.fn_text('cfm_chk'));
                return false;
            }
			
			if(!kora.common.cfrmDivChkValid("params")) {
				return;
			 }
			
			if(!kora.common.gfn_bizNoCheck($('#BIZRNO').val())){
				alertMsg("정상적인 사업자등록번호가 아닙니다.");
				$('#BIZRNO').focus();
				return;
			}

			var input = insRow('M');
			if(!input) return;
			
			//DB데이터 체크
			fn_dataCheck('UPD', input, idx);
	
		}
		
		//로우데이터 셋팅
		function insRow(gbn){
			
			var input = {};
			var WHSDL_BIZR = $('#WHSDL_BIZR option:selected').val();
			var WHSDL_BRCH = $('#WHSDL_BRCH option:selected').val();
			var BIZRNO = $('#BIZRNO').val();
			
			var collection = gridRoot.getCollection();
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot.getItemAt(i);
		 		if(tmpData.WHSDL_BIZRID+";"+tmpData.WHSDL_BIZRNO == WHSDL_BIZR
		 			&& tmpData.WHSDL_BRCH_ID+";"+tmpData.WHSDL_BRCH_NO == WHSDL_BRCH
		 			&& tmpData.BIZRNO_DE == BIZRNO
		 		  ){
		 			
		 			if(gbn == 'M' && rowIndex == i){ //행변경시 선택된 행의 데이터는 패스
		 				continue;
		 			}
		 			
		 			alertMsg('중복된 데이터가 존재합니다.');
		 			return false;
		 		}
		 	}
			
			input["WHSDL_BIZRID"] = WHSDL_BIZR.split(";")[0];
			input["WHSDL_BIZRNO"] = WHSDL_BIZR.split(";")[1];
			input["WHSDL_BIZRNM"] = $('#WHSDL_BIZR option:selected').text();
			input["WHSDL_BRCH_ID"] = WHSDL_BRCH.split(";")[0];
			input["WHSDL_BRCH_NO"] = WHSDL_BRCH.split(";")[1];
			input["WHSDL_BRCH_NM"] = $('#WHSDL_BRCH option:selected').text();
			input["BIZR_TP_CD"] = $('#BIZR_TP_CD option:selected').val();
			input["BIZR_TP_NM"] = $('#BIZR_TP_CD option:selected').text();
			input["BIZRNM"] = $('#BIZRNM').val();
			input["BIZRNO"] = BIZRNO;
			input["BIZRNO_DE"] = BIZRNO;
			
			return input;
		}
		
		//도매업자 변경시 지점조회
		function fn_change(){

			var url = "/SELECT_BRCH_LIST.do" 
			var input ={};
		    input["BIZRID_NO"] =$("#WHSDL_BIZR").val();

       	    ajaxPost(url, input, function(rtnData) {
   				if (null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData, "","", $("#WHSDL_BRCH"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');
   				} else {
   					alertMsg("error");
   				}
    		}, false);
		}
		
		/**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var layoutStr = new Array();
		var rowIndex;
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35"  horizontalGridLines="true"  textAlign="center" 	draggableColumns="true" sortableColumns="true" > ');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="순번" itemRenderer="IndexNoItem" textAlign="center" width="5%" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BRCH_NM"  headerText="'+parent.fn_text('brch_nm')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp_cd')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('cust_bizrnm')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="20%" formatter="{maskfmt}"/>');
			 layoutStr.push('</columns>');
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());

		     var layoutCompleteHandler = function(event) {
		    	 dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    	 selectorColumn = gridRoot.getObjectById("selector");
		    	 dataGrid.addEventListener("change", selectionChangeHandler);
		    	 gridApp.setData();
		    }
		     var selectionChangeHandler = function(event) {
				 rowIndex = event.rowIndex;
				 fn_rowToInput ();
			}
		    var dataCompleteHandler = function(event) {
		    }
		    
		    gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		    gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }
		
		//선택한 행 입력창에 값 넣기
		function fn_rowToInput (){
			var item = gridRoot.getItemAt(rowIndex);
			$("#WHSDL_BIZR").val(item["WHSDL_BIZRID"]+";"+item["WHSDL_BIZRNO"]).prop("selected", true);
			fn_change();
			$("#WHSDL_BRCH").val(item["WHSDL_BRCH_ID"]+";"+item["WHSDL_BRCH_NO"]).prop("selected", true);
			$("#BIZR_TP_CD").val(	item["BIZR_TP_CD"]).prop("selected", true);
			$("#BIZRNM").val(item["BIZRNM"]);
			$("#BIZRNO").val(item["BIZRNO_DE"]); 
		};

	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>
<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="singleRow">
				<div class="btn" id="UR"></div>
			</div>
		</div>

		<section class="secwrap">
			<div class="srcharea" id="params">
				<div class="row">
					<div class="col">
						<div class="tit" id="whsdl"></div>
						<div class="box">
							<select id="WHSDL_BIZR" name="WHSDL_BIZR" style="width: 179px"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="brch_nm"></div>
						<div class="box">
							<select id="WHSDL_BRCH" name="WHSDL_BRCH" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="bizr_tp"></div>
						<div class="box">
							<select id="BIZR_TP_CD" name="BIZR_TP_CD" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
				</div>
	
				<div class="row">
					<div class="col">
						<div class="tit" id="cust_bizrnm"></div>
						<div class="box">
							<input type="text" id="BIZRNM" name="BIZRNM" maxByteLength="90" style="width: 179px;" class="i_notnull">
						</div>
					</div>  
					<div class="col" >
						<div class="tit" id="bizrno"></div>
						<div class="box">
							<input type="text" id="BIZRNO" name="BIZRNO" maxlength="10" style="width: 179px;" class="i_notnull" format="number">
						</div>
					</div>
				</div>
			</div>
			
			<div class="singleRow">
				<div class="btn" id="CR">
				</div>
			</div>
				
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:418px;"></div>
			</div>
		</section>
		<section class="btnwrap mt20" >
			<div class="btn" id="BL">
			</div>
			<div class="btn" style="float:right" id="BR">
			</div>
		</section>
	</div>
	
	<form name="downForm" id="downForm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="RTL_CUST_INFO_EXCEL_FORM.xlsx" />
		<input type="hidden" name="downDiv" value="" />
	</form>
	
</body>
</html>
