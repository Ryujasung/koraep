<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var searchList = '';

		$(document).ready(function(){
			
			searchList = jsonObject($("#searchList").val());
					
			//text 셋팅
			$('.write_area .write_tbl table tr th.bd_l').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			//text 셋팅
			//$('.tit').each(function(){
			//	$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			//});
			
			fn_set_grid();
			
		});
		
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
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridColumn dataField="TRGT_SE_NM"  headerText="'+parent.fn_text('anc_trgt')+'" width="20%" />');
			 layoutStr.push('	<DataGridColumn dataField="ANC_SBJ"  headerText="'+parent.fn_text('sbj')+'" width="60%" textAlign="left" />');
			 layoutStr.push('	<DataGridColumn dataField="REG_DTTM"  headerText="'+parent.fn_text('reg_dt2')+'" width="20%" />');
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
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         gridApp.setData(searchList);
		     }
		     var selectionChangeHandler = function(event) {

				rowIndex = event.rowIndex;
				
				var item = gridRoot.getItemAt(rowIndex);
				
				$("#TRGT_SE_NM").text(item["TRGT_SE_NM"]);
			 	$("#ANC_SBJ").text(item["ANC_SBJ"]);
			 	$("#ANC_MSG").text(item["ANC_MSG"]);
				
			 }
		     var dataCompleteHandler = function(event) {
		     	dataGrid = gridRoot.getDataGrid();
		     	
		     	var collection = gridRoot.getCollection();
				for(var i=0;i<collection.getLength();i++){
					var item = gridRoot.getItemAt(i);
					if(item.SEL_YN == 'Y'){	
						dataGrid.setSelectedIndex(i)
						$("#TRGT_SE_NM").text(item["TRGT_SE_NM"]);
					 	$("#ANC_SBJ").text(item["ANC_SBJ"]);
					 	$("#ANC_MSG").text(item["ANC_MSG"]);
						break;
					}
				}
		     	
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
			 
	</script>
			
</head>
<body>
	<div class="iframe_inner">
	
	    <input type="hidden" id="searchList" value="<c:out value='${searchList}' />" />
	    
		<div class="h4group">
			<h4 class="tit"  id='title'></h4>
		</div>
		
		<section class="secwrap">
			<div class="write_area">
		        <div class="write_tbl" id="chkDiv">
					<table>
						<colgroup>
							<col style="width: 15%;">
							<col style="width: 20%;">
							<col style="width: 15%;">
							<col style="width: 50%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l" id="anc_trgt_txt" ></th>
								<td>
									<div class="row">
										&nbsp;<div class="txtbox" id="TRGT_SE_NM"></div>
									</div>
								</td>
								<th class="bd_l" id="sbj_txt" ></th>
								<td>
									<div class="row">
										&nbsp;<div class="txtbox" id="ANC_SBJ"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" id="cnts_txt" ></th>
								<td colspan="3">
									<div class="row">
										&nbsp;<div class="txtbox" id="ANC_MSG"></div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
		        
			</div>
		</section>
		
		<div class="boxarea mt10">
			<div id="gridHolder" style="height:420px;background: #FFF;"></div>
		</div>
		
	</div>

</body>
</html>
