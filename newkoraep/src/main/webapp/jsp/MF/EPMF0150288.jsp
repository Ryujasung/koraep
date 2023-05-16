<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>직매장/공장관리 지역일괄설정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

var parent_item; 
var area_cd_list;

$(document).ready(function(){
	
	area_cd_list = jsonObject($('#area_cd_list').val());

	 //버튼 셋팅
	fn_btnSetting('EPMF0150288');
	
	parent_item = window.frames[$("#pagedata").val()].parent_item;
	 
	 //그리드 셋팅
	 fnSetGrid1();
	 
	/************************************
	 * 취소 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_cnl").click(function(){
		 $('[layer="close"]').trigger('click');
	});

	/************************************
	 * 저장 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_reg").click(function(){
		fn_reg_chk();
	});
	
	fn_init();
});

	//선택데이터 팝업화면에 셋팅
	function fn_init(data) {
		 kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//지역
		$('#title_sub').text('<c:out value="${titleSub}" />');						  			//타이틀
		$('#area').text(parent.fn_text('area')); 							//지역
		
 	}
	//저장 확인
  	function fn_reg_chk(){

        if(!kora.common.cfrmDivChkValid("params")) {
            return;
        }
	    
		confirm(parent_item.areaCnt+"개 지점의 지역 정보가 변경됩니다. 계속 진행하시겠습니까?","fn_reg");
  	}
 	 //저장
 	 function fn_reg(){
		var url ="/MF/EPMF0150288_21.do"
		var input 	= {"list": ""};
			for(var i =0; i<parent_item.list.length; i++){
				parent_item.list[i].AREA_CD = $("#AREA_CD").val();
			}
			input["list"] 	 = JSON.stringify(parent_item.list);
		ajaxPost(url, input, function(rtnData){
				if(rtnData.RSLT_CD == "0000"){
					alertMsg(rtnData.RSLT_MSG);	
					window.frames[$("#pagedata").val()].fn_sel();
					$('[layer="close"]').trigger('click');
				}else{
					alertMsg(rtnData.RSLT_MSG);
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
 			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"    headerHeight="35">');
 			layoutStr.push('		<groupedColumns>');   	
 			layoutStr.push('			<DataGridColumn dataField="BIZRNM"							headerText="'+ parent.fn_text('mfc_bizrnm')+ '"	width="200"  textAlign="left"		    />');							//생산자
 			layoutStr.push('			<DataGridColumn dataField="GRP_BRCH_NM" 				headerText="'+ parent.fn_text('grp_brch_nm')+ '"	width="190"  textAlign="left" 	  />');							//총괄직매장
 			layoutStr.push('			<DataGridColumn dataField="BRCH_NM"			 			headerText="'+ parent.fn_text('mfc_brch_nm')+ '" 	width="190"  textAlign="left"		  />'); 							//직매장
 			layoutStr.push('			<DataGridColumn dataField="BRCH_NO" 						headerText="'+parent.fn_text('mfc_brch_no')+ '"  	width="100"  textAlign="center" />');								//직매장번호
 			layoutStr.push('		</groupedColumns>');
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
 		gridApp.setData();
 		var layoutCompleteHandler = function(event) {
 			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
 			dataGrid.addEventListener("change", selectionChangeHandler);
 			gridApp.setData(parent_item.list);
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

 	
 /****************************************** 그리드 셋팅 끝***************************************** */


</script>
<style type="text/css">


</style>

</head>
<body>

<input type="hidden" id="area_cd_list" value="<c:out value='${area_cd_list}' />"/>

    	<div class="layer_popup" style="width:700px; margin-top: -317px" >
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub"></h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">		
			   	
						<div class="h4group" >
							<h5 class="tit"  style="font-size: 16px;" id=""><h5>
						</div>
						
					   	<div class="boxarea mt10">  <!-- 634 -->
							<div id="gridHolder" style="height: 300px; background: #FFF;"></div>
						</div>	<!-- 그리드 셋팅 -->
						<section class="secwrap"   id="params">
								<div class="srcharea" style="" > 
									<div class="row">
										<div class="col"    style="">
											<div class="tit" id="area"></div>  <!-- 지역 -->
											<div class="box"  >
												  <select id="AREA_CD" name="AREA_CD" style="width: 210px" class="i_notnull" alt="지역" ></select>
											</div>
										</div>
									</div>
								</div>
						</section>
						<section class="btnwrap mt20"  >
								<div class="btn" style="float:right" id="BR"></div>
						</section>
						<input type="hidden" name ="pagedata"  id="pagedata"/> 
				</div>
		</div>
</body>
</html>