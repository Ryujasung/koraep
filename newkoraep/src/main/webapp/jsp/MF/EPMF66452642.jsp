<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
	
    	var INQ_PARAMS;   //파라미터 데이터
        var initList;					//그리드 초기값
        var ctnr_nm; //빈용기 콤보박스
    	var rowIndexValue =0;

		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			INQ_PARAMS	= jsonObject($("#INQ_PARAMS").val());
			initList = jsonObject($("#initList_list").val());
			ctnr_nm = jsonObject($("#ctnr_nm_list").val());

			//버튼셋팅
			fn_btnSetting();
			
			//그리드 셋팅
			fnSetGrid1();
			
			$('.bd_l').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			$('.i_notnull').each(function(){
				$(this).attr('alt', parent.fn_text($(this).attr('id').toLowerCase()) );
			});
			
			$('#DRCT_RTRVL_DT').text(INQ_PARAMS.PARAMS.DRCT_RTRVL_DT);
			$('#MFC_BIZRNM').text(INQ_PARAMS.PARAMS.MFC_BIZRNM);
			$('#MFC_BRCH_NM').text(INQ_PARAMS.PARAMS.MFC_BRCH_NM);
			

			//빈용기명
			kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');
			
			
			//저장
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

		

	    //행추가
	 	function fn_reg2(){
	    	 
	 		if(!kora.common.cfrmDivChkValid("divInput")) {
	 			return;
	 		}
	 		
	 		if(!kora.common.gfn_bizNoCheck($('#CUST_BIZRNO').val())){
				alertMsg("정상적인 사업자등록번호가 아닙니다.");
				$('#CUST_BIZRNO').focus();
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
	 		
	 		if(!kora.common.cfrmDivChkValid("divInput")) {
	 			return;
	 		}
	 		
	 		if(!kora.common.gfn_bizNoCheck($('#CUST_BIZRNO').val())){
				alertMsg("정상적인 사업자등록번호가 아닙니다.");
				$('#CUST_BIZRNO').focus();
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
	 	 
	 	//행삭제
	 	function fn_del(){
	 		var idx = dataGrid.getSelectedIndex();
	 		var collection = gridRoot.getCollection();  //그리드 데이터

	 		if(idx < 0) {
	 			alertMsg(parent.fn_text('del_row_cho'));
	 			return;
	 		}

	 		gridRoot.removeItemAt(idx);

	 	}
	 	

	 	//행변경 및 행추가 시 그리드 셋팅
	 	insRow = function(gbn) {
	 		var input = {};
		 	var collection = gridRoot.getCollection();  //그리드 데이터
		 	var ctnrCd = $("#CTNR_CD").val();

			input["CTNR_CD"] = $("#CTNR_CD option:selected").val();
			input["CTNR_NM"] = $("#CTNR_CD option:selected").text();
			input["CUST_BIZRNM"] = $("#CUST_BIZRNM").val();
			input["CUST_BIZRNO"] = $("#CUST_BIZRNO").val();
			input["DRCT_RTRVL_QTY"] = $("#DRCT_RTRVL_QTY").val().replace(/\,/g,"");
			input["DRCT_PAY_FEE"] = $("#DRCT_PAY_FEE").val().replace(/\,/g,"");
			input["RMK"] = $("#RMK").val();

			for(var i=0; i<ctnr_nm.length; i++){  //빈용기리스트 가져오면
				if(ctnr_nm[i].CTNR_CD == ctnrCd) {
					input["PRPS_NM"] = ctnr_nm[i].CPCT_NM1;						//용도
				    input["CPCT_NM"] = ctnr_nm[i].CPCT_NM2;						//용량
				    input["STD_DPS"] = ctnr_nm[i].STD_DPS;				 		//단가
				}
			}
			
			input["DRCT_PAY_GTN"] = Number($("#DRCT_RTRVL_QTY").val().replace(/\,/g,"")) * Number(input["STD_DPS"]); //보증금
			
			input["CUST_BRCH_ID"] = '9999999999';
			input["CUST_BRCH_NO"] = '9999999999';

			
			for(var i=0; i<collection.getLength(); i++) {
	 	    	var tmpData = gridRoot.getItemAt(i);
	 	    	if( tmpData.CUST_BIZRNO == input["CUST_BIZRNO"] && tmpData.CUST_BRCH_ID == input["CUST_BRCH_ID"] && tmpData.CUST_BRCH_NO == input["CUST_BRCH_NO"]
	 	    		&& tmpData.CTNR_CD == input["CTNR_CD"] 
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
	 		kora.common.goPageB('/MF/EPMF6645264.do', INQ_PARAMS);
	 	}
		
		//저장
	    function fn_reg(){
	    	
	 		var changedData = gridRoot.getChangedData();

	 		if(0 != changedData.length){
	 			confirm('저장하시겠습니까?', 'fn_reg_exec');
			}else{
				alertMsg("변경된 데이터가 없습니다.");
			}
		}
		
		function fn_reg_exec(){
			
			var data = {"list": ""};
	 		var row = new Array();
	 		var url = "/MF/EPMF6645242_21.do";
			var collection = gridRoot.getCollection();
			
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot.getItemAt(i);
		 		row.push(tmpData);//행 데이터 넣기
		 	}

			data["list"] = JSON.stringify(row);
			data["PARAMS"] = JSON.stringify(INQ_PARAMS.PARAMS);

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
				layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35" >');
				layoutStr.push('		<groupedColumns>');
				layoutStr.push('			<DataGridColumn dataField="index" headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" textAlign="center" width="50"  />');	        //순번
				layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM" headerText="'+ parent.fn_text('cust_bizrnm')+ '" textAlign="center" width="120" />');							//거래처명
				layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO" headerText="'+ parent.fn_text('cust_bizrno2')+ '" textAlign="center" width="150"  formatter="{maskfmt1}"/>');	//거래처사업자등록번호
				layoutStr.push('			<DataGridColumn dataField="PRPS_NM" headerText="'+ parent.fn_text('prps_cd')+ '" textAlign="center" width="110" />');								//용도(유흥용/가정용)
				layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="center" width="200" />');								//빈용기명
				layoutStr.push('			<DataGridColumn dataField="CTNR_CD" headerText="'+ parent.fn_text('cd')+ '"  textAlign="center" width="100" />');									//코드
				layoutStr.push('			<DataGridColumn dataField="CPCT_NM" headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+ '" textAlign="center" width="100" />');						//용량(ml)
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

			var layoutCompleteHandler = function(event) {
				dataGrid = gridRoot.getDataGrid(); // 그리드 객체
				dataGrid.addEventListener("change", selectionChangeHandler);
				gridApp.setData(initList);
			}
			var dataCompleteHandler = function(event) {
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
		
		//선택한 행 입력창에 값 넣기
	 	function fn_rowToInput (rowIndex){
	 		var item = gridRoot.getItemAt(rowIndex);
	 		
	 		$("#CTNR_CD").val(	item["CTNR_CD"]).prop("selected", true);    //빈용기명
	 		$("#CUST_BIZRNM").val(item["CUST_BIZRNM"]);
	 		$("#CUST_BIZRNO").val(item["CUST_BIZRNO"]);
	 		$("#DRCT_RTRVL_QTY").val(item["DRCT_RTRVL_QTY"]);
	 		$("#DRCT_PAY_FEE").val(item["DRCT_PAY_FEE"]);
	 		
	 		$("#DRCT_RTRVL_QTY").val(kora.common.format_comma($("#DRCT_RTRVL_QTY").val()));
	 		$("#DRCT_PAY_FEE").val(kora.common.format_comma($("#DRCT_PAY_FEE").val()));
	 		
	 		$("#RMK").val(item["RMK"]);
	 	};
	
    /****************************************** 그리드 셋팅 끝***************************************** */
	
</script>

<style type="text/css">

.srcharea .row .col .tit{
width: 87px;
}

</style>

</head>
<body>

    <div class="iframe_inner" id="testee" >
    
    	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
    	<input type="hidden" id="initList_list" value="<c:out value='${initList}' />" />
    	<input type="hidden" id="ctnr_nm_list" value="<c:out value='${ctnr_nm}' />" />
    	
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
			
		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 150px;">
							<col style="width: 250px;">
							<col style="width: 150px;">
							<col style="width: 250px;">
							<col style="width: 150px;">
							<col style="width: auto;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l"  id="drct_rtrvl_dt_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="DRCT_RTRVL_DT"></div>
									</div>
								</td>
								<th class="bd_l" id="mtl_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="MFC_BIZRNM"></div>
									</div>
								</td>
								<th class="bd_l" id="mfc_brch_nm_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="MFC_BRCH_NM"></div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</section>	
			
		<section class="secwrap mt10" >
			<div class="srcharea" id="divInput"> 
				<div class="row">
					<div class="col">
						<div class="tit" id="cust_bizrnm_txt" ></div>
						<div class="box">
							<input type="text"  id="CUST_BIZRNM" style="width: 179px" class="i_notnull" maxByteLength="90" />
						</div>
					</div>
					<div class="col">
						<div class="tit" id="cust_bizrno2_txt" style="width:150px"></div> 
						<div class="box">
							<input type="text"  id="CUST_BIZRNO" style="width: 179px" class="i_notnull" format="number" maxlength="10" />
						</div>
					</div>
				    <div class="col">
						<div class="tit" id="ctnr_nm_txt"></div>
						<div class="box">
							<select id="CTNR_CD" style="width: 179px" class="i_notnull" alt=""></select>
						</div>
					</div>
				</div> <!-- end of row -->
				<div class="row">
					<div class="col">
						<div class="tit" id="drct_rtrvl_qty2_txt" ></div>
						<div class="box">
							<input type="text"  id="DRCT_RTRVL_QTY" style="width: 179px;text-align:right" class="i_notnull" maxlength="11" format="minus"/>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="drct_pay_fee_txt" style="width:150px"></div> 
						<div class="box">
							<input type="text"  id="DRCT_PAY_FEE" style="width: 179px;text-align:right" class="i_notnull" maxlength="13" format="minus"/>
						</div>
					</div>
				    <div class="col">
						<div class="tit" id="rmk_txt"></div>
						<div class="box">
							<input type="text"  id="RMK" style="width: 179px" maxByteLength="90" />
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
			<div id="gridHolder" style="height: 560px;"></div>
		</div>	
		
		<section class="btnwrap mt20" style="">
			<div class="fl_r" id="BR">
			</div>
		</section>
		
</div>
</body>
</html>
