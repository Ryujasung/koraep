<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수증빙자료관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<style>
/* The Modal (background) */
.searchModal {
display: none; /* Hidden by default */
position: fixed; /* Stay in place */
z-index: 10; /* Sit on top */
left: 0;
top: 0;
width: 100%; /* Full width */
height: 100%; /* Full height */
overflow: auto; /* Enable scroll if needed */
background-color: rgb(0,0,0); /* Fallback color */
background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}
/* Modal Content/Box */
.search-modal-content {
background-color: #fefefe;
text-align:center;
margin: 15% auto; /* 15% from the top and centered */
padding: 20px;
border: 1px solid #888;
width: 180px; /* Could be more or less, depending on screen size */
border-radius:10px; 
}
</style>

<script type="text/javaScript" language="javascript" defer="defer">

    var INQ_PARAMS;
    var whsdl_cd_list;		//도매업자
    var parent_item;
 	var pagedata 	= window.frameElement.name;
     $(function() {
		
         INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
    	 whsdl_cd_list = jsonObject($('#whsdl_cd_list').val());
    	 
    	 //기본 셋팅
    	 fn_init();
    	
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		 
		/************************************
		 * 도매업자  변경 이벤트
		 ***********************************/
		$("#WHSDL_BIZRNM").change(function(){
			fn_whsdl_bizrnm();
		});
		
		/************************************
		 * 조회버튼 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			fn_sel();
		});
		
		/************************************
		 * 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
		});
		
		/************************************
		 * 취소 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
		/************************************
		 * 등록 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#START_DT").click(function(){
			    var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#START_DT").val(start_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#START_DT").change(function(){
		     var start_dt = $("#START_DT").val();
		     start_dt   =  start_dt.replace(/-/gi, "");
			if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
		     $("#START_DT").val(start_dt) 
		});
		
		/************************************
		 * 끝날짜  클릭시 - 삭제  변경 이벤트
		 ***********************************/
		$("#END_DT").click(function(){
			    var end_dt = $("#END_DT").val();
			         end_dt  = end_dt.replace(/-/gi, "");
			     $("#END_DT").val(end_dt)
		});
		
		/************************************
		 * 끝날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#END_DT").change(function(){
		     var end_dt  = $("#END_DT").val();
		           end_dt =  end_dt.replace(/-/gi, "");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
		     $("#END_DT").val(end_dt) 
		});
		
	});
     
     function fn_init(){
    	 
	 	kora.common.setEtcCmBx2(whsdl_cd_list, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N");		 //업체명
	 	fn_whsdl_bizrnm();
	 	
	 	//text 셋팅
 		$('.row > .col > .tit').each(function(){
 			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
 		});
 		$('#title_sub').text('<c:out value="${titleSub}" />');		
 		$('#whsdl').text(parent.fn_text('whsdl'));										  //도매업자
		$('#whsdl_bizrno').text(parent.fn_text('whsdl_bizrno'));					  //도매업자사업자번호
		$('#sel_term').text(parent.fn_text('sel_term'));					  			  //조회기간
		
		//div필수값 alt
		$("#START_DT").attr('alt',parent.fn_text('sel_term'));   
		$("#END_DT").attr('alt',parent.fn_text('sel_term'));   
		
		//날짜 셋팅
		$('#START_DT').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
				
		 });
		$('#END_DT').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
		 });  
	
		//파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
			for(var i=0 ; i <whsdl_cd_list.length ;i++){
				if(whsdl_cd_list[i].BIZRID_NO == $("#WHSDL_BIZRNM").val()  ){
					$("#WHSDL_BIZRNO").val(kora.common.setDelim(whsdl_cd_list[i].BIZRNO_DE, "999-99-99999"));
					break;
				}
			}
		}// end of if 파라미터 조회조건 
		
		//select2
		//$("#WHSDL_BIZRNM").select2();
		
     }
     

     //도매업자 선택 변경시
     function fn_whsdl_bizrnm(){
		for(var i=0 ; i <whsdl_cd_list.length ;i++){
				if(whsdl_cd_list[i].BIZRID_NO == $("#WHSDL_BIZRNM").val() ){
					$("#WHSDL_BIZRNO").text(kora.common.setDelim(whsdl_cd_list[i].BIZRNO_DE, "999-99-99999"));
					break;
				}
		} 
     }
     
	//조회
   function fn_sel(){
	  	 var input	={};
		 var url = "/WH/EPWH2925897_19.do" 
		 var start_dt 			= $("#START_DT").val();
		 var end_dt    		= $("#END_DT").val();
		 var arr 				= 	new Array();	//업체명 split
		 start_dt   				=  start_dt.replace(/-/gi, "");
	 	 end_dt    				=  end_dt.replace(/-/gi, "");
	
		 //날짜 정합성 체크. 20160204
		 if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		 }else if(start_dt>end_dt){
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		 } 
		if($("#WHSDL_BIZRNM").val() !="" ){	//도매업자
		 	 arr		=[];
			 arr	= $("#WHSDL_BIZRNM").val().split(";");
			 input["WHSDL_BIZRID"]   	= arr[0];
			 input["WHSDL_BIZRNO"] 	= arr[1]; 
		 }
		input["START_DT"]			= $("#START_DT").val();			 //날짜
		input["END_DT"]				= $("#END_DT").val();		
		input["WHSDL_BIZRNM"]	= $("#WHSDL_BIZRNM").val(); //도매업자선택
		
		INQ_PARAMS["SEL_PARAMS"] = input;
//     	showLoadingBar();
$("#modal").show();
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {
   					gridApp.setData(rtnData.selList);
   					/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
   				} else {
   					alertMsg("error");
   				}
//    				hideLoadingBar(); 
   				$("#modal").hide();
   		});
	}
	
   //취소버튼 이전화면으로
   function fn_cnl(){
  	 kora.common.goPageB('/WH/EPWH2925801.do', INQ_PARAMS);
   }
	
	//등록 페이지 이동
	function fn_page(){
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";    
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2925888.do";
		kora.common.goPage('/WH/EPWH0122701.do', INQ_PARAMS);
	}

	//회수증빙자료 삭제 confirm
   	function fn_del_chk(){
   		var selectorColumn = gridRoot.getObjectById("selector");
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		confirm("선택된 증빙자료가 삭제됩니다. \n 삭제 하신 자료는 복원되지 않습니다. 계속 진행하시겠습니까?","fn_del");
	}
   
   	//회수정보 삭제
   	function fn_del(){
   		var url 			= "/WH/EPWH2925897_04.do"; 
   		var selectorColumn 	= gridRoot.getObjectById("selector");
		var data  = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
		var input = {};
		
        input["WHSDL_BIZRID"] = data["WHSDL_BIZRID"];       
        input["WHSDL_BIZRNO"] = data["WHSDL_BIZRNO"];       
        input["RTRVL_DT"] = data["RTRVL_DT"];       
        input["DTL_SN"]   = data["DTL_SN"];
        
	 	ajaxPost(url, input, function(rtnData){
	 	    
			if(rtnData.RSLT_CD == "0000"){
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			}else{
				alertMsg(rtnData.RSLT_MSG);
			}
		});    
	   
   	}
   	
    //회수증빙자료등록
	function fn_page(){
    	
    	var input={};
    	if($("#WHSDL_BIZRNM").val() ==""){
    		alertMsg("도매업자를 선택해주세요.");
    		return;
    	}else{
    		var arr = $("#WHSDL_BIZRNM").val().split(";"); 	//도매업자 
    		input["WHSDL_BIZRID"] 			= arr[0]; 
    		input["WHSDL_BIZRNO"] 			= arr[1];
    		parent_item =input;
    		var url = "/WH/EPWH2925888.do";	
    		window.parent.NrvPub.AjaxPopup(url, pagedata);
    	}
		
	  }
   	
    //회수증빙자료다운로드
	function link(){
		var idx 			= dataGrid.getSelectedIndices();
		var input		= gridRoot.getItemAt(idx);
		var url 			= "/WH/EPWH29258882.do";	  
		window.parent.NrvPub.AjaxPopup(url, input);
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
			layoutStr.push('    <DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalScrollPolicy="on" horizontalGridLines="true" headerHeight="35">');
			layoutStr.push('		<columns>');
			layoutStr.push('			<DataGridSelectorColumn id="selector"	 	headerText="'+ parent.fn_text('sel')+ '"		width="50"	textAlign="center" allowMultipleSelection="false" />');							//선택
			layoutStr.push('			<DataGridColumn dataField="index" 			headerText="'+ parent.fn_text('sn')+ '"			width="100" textAlign="center" itemRenderer="IndexNoItem" />');	//순번
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNM"	headerText="'+ parent.fn_text('whsdl')+ '" 		width="250" textAlign="left"/>');						//지역
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT"		headerText="'+ parent.fn_text('rtrvl_dt2') + '" width="250" textAlign="center" formatter="{datefmt2}"/>'); //회수일자										
			layoutStr.push('			<DataGridColumn dataField="REG_DTTM" headerText="'+ parent.fn_text('prf_reg_dt') + '"		width="250"	textAlign="center"/>');						//증빙등록일자
			layoutStr.push('			<DataGridColumn dataField="FILE_NM"	 	headerText="'+ parent.fn_text('prf_file') + '"   	width="80"	itemRenderer="HtmlItem" textAlign="center"/>');	//증빙자료
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
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
			
			//파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 6023 기원우
			 }else{
				 gridApp.setData();
			 }
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");

			rowIndexValue = rowIndex;
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex);
		
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

/****************************************** 그리드 셋팅 끝***************************************** */


</script>
<style type="text/css">

#s2id_WHSDL_BIZRNM{
    width: 100%
}
</style>
</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="whsdl_cd_list" value="<c:out value='${whsdl_cd_list}' />"/>

    <div class="iframe_inner" >
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
			</div>
		<section class="secwrap">
		
			<div class="srcharea" style=""  > 
				<div class="row" >
					<div class="col" >
						<div class="tit" id="whsdl"></div>
						<div class="box" >
							<select id="WHSDL_BIZRNM" style="width:179px"></select>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id="whsdl_bizrno"></div>
						<div class="box" style="width:109px">
							<div class="txtbox" id="WHSDL_BIZRNO" style="margin-top:8px"></div>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id="sel_term"></div>
						<div class="box" >
							<div class="calendar">
								<input type="text" id="START_DT" name="from" style="width: 140px;" class="i_notnull"><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT" name="to" style="width: 140px;"	class="i_notnull"><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					<div class="btn"  id="CR" ></div>
				</div> <!-- end of row -->
			</div>
				<!-- 
				 <div class="write_area">
						<div class="write_tbl">
							<table>
								<colgroup>
									<col style="width: 8%;">
									<col style="width: 17%;">
									<col style="width: 14%;">
									<col style="width: 12%;">
									<col style="width: 9%;">
									<col style="width: auto;">
								</colgroup>
							<tbody>
								 <tr>
									<th class="bd_l" id="whsdl"></th> 
									<td>
										<div class="row">
												<select id="WHSDL_BIZRNM" style=""></select>
										</div>
									</td>
									<th class="bd_l" id="whsdl_bizrno"></th> 
									<td>
										<div class="row">
											<div class="txtbox" id="WHSDL_BIZRNO"></div>
										</div>
									</td>
									<th class="bd_l" id="sel_term"></th> 
									<td>
										<div class="row" >
									 		<div class="box" style="width: 73%">
												<div class="calendar" style="width: 43%">
													<input type="text" id="START_DT" name="from" style="" class="i_notnull">
												</div>
												<div class="obj">~</div>
												<div class="calendar" style="width: 43%">
													<input type="text" id="END_DT" name="to" style=""	class="i_notnull">
												</div>
											</div>
											<div class="btn"  id="CR" style="float: right;"></div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				 -->
		</section>
		
		<div class="boxarea mt10">
			<div id="gridHolder" style="height: 605px; background: #FFF;"></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>	<!-- 그리드 셋팅 -->
		<section class="btnwrap"  >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
 
</div>
	<div id="modal" class="searchModal"  style="display: none;">
		<div class="search-modal-content" >
			<h5> <img alt="" src="../../images/main/loading.gif"></h5>
		</div>
	</div>
</body>
</html>