<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수용기코드관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
	
	    var lang_se_cd_list; //언어구분 리스트
	    var err_cd_list;//오류코드 리스트
	    var mappCtnrCd, dtlSn;
	    var input = {};
	    
	    var mfc_bizrnm_sel;//생산자
	    
		$(function() {
			
			mfc_bizrnm_sel = jsonObject($("#mfc_bizrnm_sel_list").val());//생산자
			
			//버튼 셋팅.
			fn_btnSetting();
			
			$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));//빈용기명
			$('#mfc_bizrnm_sel').text(parent.fn_text('mfc_bizrnm'));//생산자
			
			//SELECT BOX 설정
			kora.common.setEtcCmBx2(mfc_bizrnm_sel, "", "", $("#MFC_BIZRNM_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			kora.common.setEtcCmBx2([], "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'S');
			
			//그리드 기본셋팅
			fnSetGrid1();
		
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
			
			/************************************
			 * 출고생산자 구분 변경 이벤트
			 ***********************************/
			$("#MFC_BIZRNM_SEL").change(function(){
				fn_mfc_bizrnm();
			});
			
			
			
		});
	    
		//출고 생산자 변경시
	    function fn_mfc_bizrnm(){
			var url = "/CE/EPCE3965801_192.do" 
			var input = {};
			var mfc_bizrnm = $("#MFC_BIZRNM_SEL").val();//출고 생산자
			
			ctnr_nm = [];
			
			if(mfc_bizrnm == undefined || mfc_bizrnm == ''){
				$("#CTNR_NM").children().remove();
				$("#CTNR_NM").append("<option value=''>"+parent.fn_text('cho')+"</option>");
				$("#CTNR_NM").val('');
				
				arr[0] = '';
				arr[1] = '';
			}else{
				arr = mfc_bizrnm.split(";"); 
				
				input["BIZRID"] = arr[0];//생산자 아이디
				input["BIZRNO"]	= arr[1];//생산자 번호				
				   
				if( $("#MFC_BIZRNM_SEL").val() == "" ){
					input = fn_init2();
					input["BIZRID"] = "";
					input["BIZRNO"] = "";
				}
				
			 	ajaxPost(url, input, function(rtnData) {
					if ("" != rtnData && null != rtnData) {   
						 ctnr_nm = rtnData.ctnr_nm
						 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "",mappCtnrCd, $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기명
					}else{
						 alertMsg("error");
					}
				}, false);
			}
		}
		
	    //생산자제품코드관리 조회
		function fn_sel(){
			var url ="/CE/EPCE3965801_19.do"
			var mfc_bizrnm = $("#MFC_BIZRNM_SEL").val();//생산자
			var input_sel = {};
			
			arr = mfc_bizrnm.split(";");
			
			input["BIZRID"] = arr[0];//생산자 아이디
			input["BIZRNO"]	= arr[1];//생산자 번호	
			input["MFC_CTNR_NM"] = $("#MFC_CTNR_NM_P").val();//제품명
			input["MFC_CTNR_CD"] = $("#MFC_CTNR_CD_P").val();//제품코드	
			
			ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.err_cd_sel_list);
					hideLoadingBar();
				} else {
					alertMsg("error");
				}
			});
		}
	  
	    //초기화
	    function fn_init(){
	    	mappCtnrCd = "";
	     	$("#MFC_CTNR_CD").val("");//제품코드
	    	$("#SE_CD1").val("");//구분코드1
	    	$("#SE_CD2").val("");//구분코드2
	    	$("#SE_CD3").val("");//구분코드3
	    	$("#MFC_CTNR_NM").val("");//제품명
	    	$("#USE_YN").val("Y").prop("selected",true);//사용여부
	    	//$("#MFC_BIZRNM_SEL").trigger('change');//빈용기
	    	$("#CTNR_NM").val('');
	    }
	     
		//저장 수정인지 확인 
		function fn_reg(){
	    	//필수입력값 체크
	 		if (!kora.common.cfrmDivChkValid("divInput")) return;
	    	  
			var url = "/CE/EPCE3965801_193.do";  //저장url
			var mfc_bizrnm = $("#MFC_BIZRNM_SEL").val();//출고 생산자
			var input_sel = {};
			
			arr = mfc_bizrnm.split(";");
			input = {};
			
			input["SAVE_CHK"] = "S";//S일경우 저장  , U일경우 수정
			input["MFC_CTNR_CD"] = $("#MFC_CTNR_CD").val();//제품코드
			input["MFC_CTNR_NM"] = $("#MFC_CTNR_NM").val();//제품명
			input["MAPP_CTNR_CD"] = $("#CTNR_NM").val();//빈용기명
			input["SE_CD1"] = $("#SE_CD1").val();//구분코드1
			input["SE_CD2"] = $("#SE_CD2").val();//구분코드2
			input["SE_CD3"] = $("#SE_CD3").val();//구분코드3
			input["DTL_SN"] = dtlSn;//순번
			input["USE_YN"] = $("#USE_YN").val();//사용여부
			input["MFC_BIZRID"] = arr[0];//생산자 아이디
			input["MFC_BIZRNO"]	= arr[1];//생산자 번호	
	       
	       //조회결과에따라 수정 저장 여부 확인
			ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =='A003'){
						confirm( (parent.fn_text('present')+"  " + $("#MFC_CTNR_CD").val()+ " " +parent.fn_text('same_cd')),"fn_reg_cmpt" );
						input["SAVE_CHK"] ="U"//수정일경우
						return;
					}else{
				    	confirm( ("생산자제품코드  " +parent.fn_text('new_cd')),"fn_reg_cmpt" );
				    	return;
					}
					hideLoadingBar();
				} else {
					alertMsg("error");
				}
			}); 
		}
		
		//저장  수정 
		function fn_reg_cmpt (){
    	   var url ="/CE/EPCE3965801_09.do"
    	   showLoadingBar();
       	   ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {
   					alertMsg(rtnData.RSLT_MSG);
   					fn_sel();  //재검색
   					fn_init(); //입력창 초기화
   				} else {
   					alertMsg("error");
   				}
    		});
    		hideLoadingBar();
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
			layoutStr.push('			<DataGridSelectorColumn id="selector" width="50" textAlign="center" allowMultipleSelection="false" headerText="선택"/>');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRID" headerText="생산자" width="200" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="MFC_CTNR_CD" headerText="제품코드" width="200" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="SE_CD1" headerText="구분코드1" width="100" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="SE_CD2" headerText="구분코드2" width="100" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="SE_CD3" headerText="구분코드3" width="100" textAlign="center"/>');
   	 	    layoutStr.push('			<DataGridColumn dataField="MFC_CTNR_NM" headerText="제품명" />');
   	 	    layoutStr.push('			<DataGridColumn dataField="MAPP_CTNR_NM" headerText="매핑빈용기명" width="300"  textAlign="center"/>');
   	 	    layoutStr.push('			<DataGridColumn dataField="USE_YN" headerText="사용여부" width="100"  textAlign="center"/>');
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
			mappCtnrCd = item["MAPP_CTNR_CD"];
			dtlSn = item["DTL_SN"];
			
			$("#MFC_BIZRNM_SEL").val(item["MFC_BIZRID"]+";"+item["MFC_BIZRNO"]).trigger('change');//생산자
			$("#MFC_CTNR_NM").val(item["MFC_CTNR_NM"]);
			$("#MFC_CTNR_CD").val(item["MFC_CTNR_CD"]);
			$("#SE_CD1").val(item["SE_CD1"]);
			$("#SE_CD2").val(item["SE_CD2"]);
			$("#SE_CD3").val(item["SE_CD3"]);
			$("#USE_YN").val(item["USE_YN"]).prop("selected", true);//사용여부
			//$("#CTNR_NM").val(item["MAPP_CTNR_CD"]).prop("selected", true);//빈용기
		};
		
    /****************************************** 그리드 셋팅 끝***************************************** */
	</script>
	
<style type="text/css">
.row .tit{
width: 65px;
}
#row .col {
/* width: 17%; */
}
</style>
</head>
<body>
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>
				    
	    <input type="hidden" id="mfc_bizrnm_sel_list" value="<c:out value='${mfc_bizrnm_sel}' />" />
		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col" >  <!--출고 생산자 선택 -->
						<div class="tit" id="mfc_bizrnm_sel" ></div>
						<div class="box" style="width:280px">
							<select id="MFC_BIZRNM_SEL" style="width: 179px"></select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit">제품코드</div>
						<div class="box">
							<input type="text" id="MFC_CTNR_CD_P" style="width: 179px">
						</div>
					</div>
					
					<div class="col">
						<div class="tit">제품명</div>
						<div class="box">
							<input type="text" id="MFC_CTNR_NM_P" style="width: 179px">
						</div>
					</div>
					
					<div class="btn" style="float:right" id="UR"></div>
				</div>
			</div>
		</section>
	
		<section class="secwrap mt30">
			<div class="srcharea" id="divInput">
				<div class="row">
					<div class="col">
						<div class="tit">제품코드</div>
						<div class="box">
							<input type="text" id="MFC_CTNR_CD" maxlength="20" style="width: 179px; text-align: center;" class="i_notnull" alt="제품코드">
						</div>
					</div>
					<div class="col" >
						<div class="tit">구분코드1</div>
						<div class="box">
							<input type="text" id="SE_CD1" maxlength="8" style="width: 179px; text-align: center;" class="i_notnull" alt="구분코드1">
						</div>
					</div>
					<div class="col" >
						<div class="tit">구분코드2</div>
						<div class="box">
							<input type="text" id="SE_CD2" maxlength="8" style="width: 179px; text-align: center;" class="i_notnull" alt="구분코드2">
						</div>
					</div>
					<div class="col" >
						<div class="tit">구분코드3</div>
						<div class="box">
							<input type="text" id="SE_CD3" maxlength="8" style="width: 179px; text-align: center;" class="i_notnull" alt="구분코드3">
						</div>
					</div>
					
				</div>
	
				<div class="row">
					<div class="col" >
						<div class="tit">제품명</div>
						<div class="box">
							<input type="text" id="MFC_CTNR_NM" style="width: 179px; text-align: center;" class="i_notnull" alt="제품명">
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="ctnr_nm" ></div>  <!-- 빈용기명 -->
						<div class="box">
							<select id="CTNR_NM" style="width: 179px" class="i_notnull" alt="빈용기명"></select>
						</div>
					</div>
					
					<div class="col" >
						<div class="tit">사용여부</div>
						<div class="box">
							<select id="USE_YN" style="width: 117px" class="i_notnull">
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
						</div>
					</div>
					
					<div class="btn">
						<button type="button" class="btn36 c4" style="width: 100px;" id="btn_init">초기화</button>
						<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">저장</button>
					</div>
				</div>
	
			</div>
	
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
	
		</section>	<!-- end of secwrap mt30  -->

	</div>   <!--end of  pagedata -->
</body>
</html>

     