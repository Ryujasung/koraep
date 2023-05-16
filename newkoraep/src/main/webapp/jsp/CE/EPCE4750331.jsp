<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>생산자정산지급내역 연계전송</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer" >

	var INQ_PARAMS; //파라미터 데이터
	
	$(document).ready(function(){
		
	    $('#title_sub').text('<c:out value="${titleSub}" />');
	    
		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());

		//버튼 셋팅
	    fn_btnSetting();
	    
		//그리드 셋팅
	    fnSetGrid1();  
	
		//연계자료생성
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		//취소
        $("#btn_cnl").click(function(){
            fn_cnl();
        });
	});

    var fn_reg_stat = '0';

    function fn_cnl(){
        if(fn_reg_stat == '1'){
            return;
        }   
        
        kora.common.goPageB('', INQ_PARAMS);
    }
            
    //지급생성
    function fn_reg(){
        if(fn_reg_stat == '1'){
            return;
        }
        
        confirm('모든 정보에 대해 지급 연계 정보를 생성하시겠습니까?', "fn_reg_exec");
    }
	
    function fn_reg_exec(){

        fn_reg_stat = '1';
        
        var data = {};

        data["list"] = JSON.stringify(INQ_PARAMS.PARAMS.list);

        document.body.style.cursor = "wait";
        kora.common.showLoadingBar(dataGrid, gridRoot)
        
        var url = "/CE/EPCE4750301_21.do";
        
        ajaxPost(url, data, function(rtnData){
            if ("" != rtnData && null != rtnData) {
                if(rtnData.RSLT_CD == '0000'){
                    alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
                }else{
                    alertMsg(rtnData.RSLT_MSG);
                }
            } else {
                alertMsg("error");
            }
            kora.common.hideLoadingBar(dataGrid, gridRoot);
            document.body.style.cursor = "default";
            fn_reg_stat = '0';
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="auto" draggableColumns="true" headerHeight="35" textAlign="center" >');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" width="50"/>');
			layoutStr.push('			<DataGridColumn dataField="EXCA_REG_DT_PAGE"  headerText="'+ parent.fn_text('exca_issu_dt') +'" width="100" itemRenderer="HtmlItem"/>');
			layoutStr.push('			<DataGridColumn dataField="BIZRNM"  headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  width="180"/>'); 
			layoutStr.push('			<DataGridColumn dataField="EXCA_ISSU_SE_NM"  headerText="'+ parent.fn_text('exca_issu_se')+ '"  width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="BANK_NM"  headerText="'+ parent.fn_text('acp_bank_nm')+ '"  width="110"/>');
			layoutStr.push('			<DataGridColumn dataField="ACCT_NO"  headerText="'+ parent.fn_text('acp_acct_no')+ '"  width="130"/>');
			layoutStr.push('			<DataGridColumn dataField="REAL_PAY_DT" headerText="'+parent.fn_text('real_pay_dt')+'" width="140" />');
			layoutStr.push('			<DataGridColumn dataField="GTN" id="num1"  headerText="'+ parent.fn_text('gtn')+ '"  width="100" textAlign="right" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="FEE" id="num2"  headerText="'+ parent.fn_text('fee')+ '"  width="100" textAlign="right" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="FEE_STAX" id="num3"  headerText="'+ parent.fn_text('stax')+ '" textAlign="right" width="100" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="EXCA_AMT" id="num4"  headerText="'+ parent.fn_text('pay_amt')+ '" textAlign="right" width="100" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="EXCA_PROC_STAT_NM"  headerText="'+ parent.fn_text('stat')+ '"  width="100"/>');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
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

		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			selectorColumn = gridRoot.getObjectById("selector");
			dataGrid.addEventListener("change", selectionChangeHandler);
			gridApp.setData(INQ_PARAMS.PARAMS.list);
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		
	}

   /****************************************** 그리드 셋팅 끝***************************************** */
	</script>
	
    <style type="text/css">
        .row .tit{width: 77px;}
    </style>

</head>
<body>

    <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>

    <div class="iframe_inner">
        <div class="h3group">
            <h3 class="tit" id="title_sub"></h3>
            <div class="btn_box">
            </div>
        </div>
        <section class="secwrap">
            <div class="boxarea">
                <div id="gridHolder" style="height:330px;"></div>
            </div>
        </section>
    
        <section class="btnwrap mt20" >
            <div class="fl_l" id="BL">
            </div>
            <div class="fl_r" id="BR">
            </div>
        </section>
        
    </div>
    
</body>
</html>