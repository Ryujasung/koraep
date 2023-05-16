<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>소모품코드관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;// 현재 페이지
	gridTotalRowCount = 0;//전체 행 수

	 var INQ_PARAMS;//파라미터 데이터
     var toDay = kora.common.gfn_toDay();// 현재 시간
	 var urm_fix_list;
	 var pageFlag =false;
	 
     $(function() {
   		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());//파라미터 데이터
  	 	urm_fix_list 		= jsonObject($("#urm_fix_list").val());
  	 //console.log(urm_fix_list);
  	/*  console.log(period_list); */
	  	  //버튼 셋팅
	   	 fn_btnSetting();
	   	 
	   	 //그리드 셋팅
		 fnSetGrid1();
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');//타이틀
		
      
		/************************************
		 * 반환내역서 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
		});
		
		/************************************
		 * 조회 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
		});
		
		/************************************
		 * 소매품 정보 등록 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		/************************************
		 * 소매품 단가관리 클릭 이벤트
		 ***********************************/
		$("#btn_page1").click(function(){
			fn_page1();
		});
		
		/************************************
		 * 소매품 정보 변경 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });
		
  		fn_init();
  		/* 	
  		 //autoComplete 셋팅 멀티 SELECTBOX 
  		 $('[data-ax5autocomplete]').ax5autocomplete({
             removeIcon: '<i class="fa fa-times" aria-hidden="true"></i>',
             onSearch: function (callBack) {
                 var searchWord = this.searchWord;
                 setTimeout(function () {
                     var regExp = new RegExp(searchWord);
                     var myOptions = [];
                     whsdlList.forEach(function (n) {				//리스트정보
                         if (n.CUST_BIZRNM.match(regExp)) {
                             myOptions.push({
                                 value: n.CUST_BIZRID_NO,		//SELECTBOX value
                                 text: n.CUST_BIZRNM				//SELECTBOX text
                             })
                         }
                     });
                     callBack({
                    	 options: myOptions,
                     });
                     
                 }, 150);
  
             }
         });
  		 */
	 });
     
   //변경 페이지 이동 
  	function fn_upd() {
  		var selectorColumn 	= gridRoot.getObjectById("selector");
  		var input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
  		if(selectorColumn.getSelectedIndices() == "") {
  			alertMsg("선택한 행이 없습니다.");
  			return;
  		}else if(selectorColumn.getSelectedIndices().length >1) {
  			alertMsg("한건만 선택이 가능합니다.");
  			return;
  		//회수등록 ,회수조정 상태인경우만 가능	
  		};
  		
  		

 	   	//파라미터에 조회조건값 저장 
 		INQ_PARAMS["PARAMS"] = {}
 		INQ_PARAMS["PARAMS"] = input;
 		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
 		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000801.do";

 		kora.common.goPage('/CE/EPCE9000842.do', INQ_PARAMS);
  	}

  	//반환내역등록 일괄확인 
    function fn_upd2_check() {
        var selectorColumn  = gridRoot.getObjectById("selector");
        var input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
        
        if(selectorColumn.getSelectedIndices() == "") {
            alertMsg("선택한 건이 없습니다.");
            return;
        }
        
        for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
            var item = {};
            item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
            //반환등록 ,입고조정 ,입고확인 상태만 가능
            if(item["STAT_NM"] != "회수등록"){
                alertMsg("회수등록 상태만 가능합니다. 다시 한 번 확인하시기 바랍니다.");
                return;
            }
        }
        
        confirm("선택하신 내역이 모두 회수확인 됩니다. 계속 진행하시겠습니까?","fn_upd2");
    }
  	
   
     
    //초기화
    function fn_init(){
    	
		kora.common.setEtcCmBx2(urm_fix_list, "","", $("#URM_FIX_CD"), "URM_FIX_CD", "URM_EXP_NM", "N" ,'T');		//도매업자 업체명
		 $("#URM_FIX_CD").select2();
    }
    
    
   //반환내역서 조회
    function fn_sel(){
	 	var input	={};
	 	var url = "/CE/EPCE9000801_194.do";
// 		input["URM_EXP_NM"] = $("#URM_FIX_CD option:selected").text();
		input["URM_FIX_CD"] = $("#URM_FIX_CD option:selected").val();
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] = input;
		showLoadingBar();
		ajaxPost(url, input, function(rtnData) {
		    //console.log("ddddd : " + JSON.stringify(rtnData));
			if ("" != rtnData && null != rtnData) {
				gridApp.setData(rtnData.selList);
				/* 페이징 표시 */
				gridTotalRowCount = rtnData.totalCnt; //총 카운트
				drawGridPagingNavigation(gridCurrentPage);
			}else{
				alertMsg("error");
			}
			
			hideLoadingBar();// 그리드 loading bar on
   		});
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
   
	//반환내역서 삭제 confirm
   	function fn_del_chk(){
   		var selectorColumn = gridRoot.getObjectById("selector");
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
		 }
		confirm("선택된 내역이 삭제됩니다. 계속 진행하시겠습니까? ","fn_del");
	}
   
   //반환내역서 삭제
   function fn_del(){
	    var selectorColumn = gridRoot.getObjectById("selector");
		var input = {"list": ""};
		var row = new Array();
		var url ="/CE/EPCE9000801_04.do";
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
			/* if(item["RTN_STAT_CD"] !="RG" && item["RTN_STAT_CD"] !="RA"){
			    alertMsg("반환등록 또는 반환등록요청 상태의 정보만 삭제 가능합니다");
				return;
			} */
			row.push(item);
		}
		
	    input["list"] = JSON.stringify(row);
    	showLoadingBar()
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				fn_sel();
				alertMsg(rtnData.RSLT_MSG);
			}else{
				fn_sel();
				alertMsg(rtnData.RSLT_MSG);
			}
			hideLoadingBar();
		});    
	   
   }
	//반환내역서 등록 페이지 이동 
	function fn_page() {
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000801.do";
		kora.common.goPage('/CE/EPCE9000831.do', INQ_PARAMS);
	}
	
	//기준보증금관리 페이지 이동
	function fn_page1(){
		 
		if(!pageFlag){
			alertMsg(parent.fn_text('sel_not'))
			return
		}
	
		var input ={};
		var item = gridRoot.getItemAt(rowIndexValue);
		input["URM_FIX_CD"] = item["URM_FIX_CD"];
		input["URM_EXP_NM"]	= item["URM_EXP_NM"];
	
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";    
// 		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0105901.do";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000801.do";
		kora.common.goPage('/CE/EPCE90008011.do', INQ_PARAMS);
		
	}
	//엑셀저장
	function fn_excel(){
		var collection = gridRoot.getCollection();
		if(collection.getLength() < 1){
			alertMsg("데이터가 없습니다.");
			return;
		}
		if(INQ_PARAMS["SEL_PARAMS"] == undefined){
			alertMsg("먼저 데이터를 조회해야 합니다.");
			return;
		}
		var now = new Date();// 현재시간 가져오기
		var hour = new String(now.getHours());// 시간 가져오기
		var min = new String(now.getMinutes());// 분 가져오기
		var sec = new String(now.getSeconds());// 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title_sub').text().replace("/","_") +"_" + today+hour+min+sec+".xlsx";
		
		//그룹헤더용
        var groupList = dataGrid.getGroupedColumns();
        var groupCntTot = 0;
        var groupCnt = 0;
        
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};
			
				item['headerText'] = columns[i].getHeaderText();
				item['dataField'] = columns[i].getDataField();
				
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				col.push(item);
			}
		}
		
		
        
		var input = INQ_PARAMS["SEL_PARAMS"];
		input['excelYn'] = 'Y';
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		var url = "/CE/EPCE9000801_05.do";
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
			
			hideLoadingBar()// 그리드 loading bar on
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
		layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
		layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
		layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true" headerHeight="35">');
		layoutStr.push('		<groupedColumns>');
		layoutStr.push('			<DataGridSelectorColumn id="selector"	 headerText="'+ parent.fn_text('sel')+ '"	 width="50"	textAlign="center" allowMultipleSelection="false" />');
		layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"  />');						//순번
		layoutStr.push('			<DataGridColumn dataField="URM_EXP_NM" headerText="소모품명" textAlign="center" width="270"/>');
		layoutStr.push('			<DataGridColumn dataField="URM_FIX_CD" headerText="소모품번호"  textAlign="center" width="200"  />');//도매업자구분
		layoutStr.push('			<DataGridColumn dataField="SUP_FEE" 		headerText="공급단가(원)" width="250" formatter="{numfmt}"  id="num1"  textAlign="right" />');		//가정용
		layoutStr.push('			<DataGridColumn dataField="APLC_DT"			 headerText="'+"소모품"+' ' +parent.fn_text('aplc_dt')	+ '"			width="300"	textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="USE_YN"			 headerText="'+"소모품"+' ' +parent.fn_text('use_yn')	+ '"			width="100"	textAlign="center"/>');
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
			var layoutCompleteHandler = function(event) {
				dataGrid = gridRoot.getDataGrid(); // 그리드 객체
				dataGrid.addEventListener("change", selectionChangeHandler);
				
				//파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }else{
					 gridApp.setData();
					/* 페이징 표시 */
					drawGridPagingNavigation(gridCurrentPage);
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
				pageFlag =true;
			
			}
			gridRoot.addEventListener("dataComplete", dataCompleteHandler);
			gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		}

	
	/**
	 * 그리드 상태 및 비밀번호변경 건 스타일 처리
	 */
	 //그리드 데이터 객체
	/*  function setSpanAttributes() {
		 var collection = gridRoot.getCollection();
	    if (collection == null) {
	        alertMsg("collection 객체를 찾을 수 없습니다");
	        return;
	    } 
	
	    for (var i = 0; i < collection.getLength(); i++) {
	    	var data = gridRoot.getItemAt(i);
	    	if( data.RTN_STAT_CD == 'PP' || data.RTN_STAT_CD == 'PC' ){
	    		collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20);
	    	}
	    }
	}  */

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

</head>
<body>
    
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="urm_fix_list" value="<c:out value='${urm_fix_list}' />" />
	<div class="iframe_inner"  >		
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR">
				<button type="button" class="btn36 c2" style="width: 120px;" id="btn_excel"><span class="excel">엑셀저장</span></button>
				</div>
			</div>
			<section class="secwrap"  id="params">
				<div class="srcharea" style=""  > 
				<div class="row" >
					  <div class="col">
                        <div class="tit">소모품명</div>    <!-- 조회기간 -->
                        <div class="box">
								<select id="URM_FIX_CD" name="URM_FIX_CD"   style="width: 300px"></select>
                        </div>
                    </div>
						<div class="btn"  id="CR" >
							<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
						</div>
				</div> <!-- end of row -->

				</div>  <!-- end of srcharea -->
			</section>
		<section class="btnwrap mt10" >
			<div class="btn" id="GL"></div>
			<div class="btn" style="float:right" id="GR">
				<button type="button" class="btn36 c3" style="width: 150px;" id="btn_upd">소모품변경</button>
				<button type="button" class="btn36 c5" style="width: 150px;" id="btn_del">소모품삭제</button>
				<button type="button" class="btn36 c2" style="width: 150px;" id="btn_page">소모품등록</button>
			</div>
		</section>
		<div class="boxarea mt10">
			<div id="gridHolder" style="height: 590px; background: #FFF;"></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>	<!-- 그리드 셋팅 -->
		<section class="btnwrap mt20"  >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
		
</div>
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>
