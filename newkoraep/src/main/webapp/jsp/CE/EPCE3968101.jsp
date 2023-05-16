<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 기타코드 관리 -->

<%@include file="/jsp/include/common_page.jsp" %>
	<!-- 기타코드 -->
		<div class="iframe_inner">
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
			</div>
			
<script type="text/javaScript" language="javascript" defer="defer">

   var lang_se_cd_lst;        //언어구분코드
   var dtl_save_chk = false // 상세코드 저장버튼 활성화
   var etc_cd_dtl_lst =  {};    // ${epcnEtcCdList};
   var grdUseYnList = [];
   var grp_se_list=[{"GRP_SE":"S" ,"GRP_SE_NM":"시스템"},{"GRP_SE":"M" ,"GRP_SE_NM":"메뉴"}, {"GRP_SE":"E" ,"GRP_SE_NM":"빈용기"}, {"GRP_SE":"B" ,"GRP_SE_NM":"기준정보상태"}, {"GRP_SE":"D" ,"GRP_SE_NM":"업무상태"}, {"GRP_SE":"C" ,"GRP_SE_NM":"정산상태"}];
   var  max=0;
   var input ={};
   var input2 = {};
   $(document).ready(function(){
	   lang_se_cd_lst 	=  jsonObject($("#lang_se_cd_lst").val());	
	
		 //버튼 셋팅
	  	 fn_btnSetting();
	   
	   //언어 셋팅
		$('#lang_se_sel').text(parent.fn_text('lang_se')); //언어구분 조회
		$('#grp_nm_sel').text(parent.fn_text('grp_nm'));//그룹명 조회

		
		$('#grp_cd_tit').text(parent.fn_text('grp_cd'));      //그룹코드
		$('#grp_cd').text(parent.fn_text('grp_cd'));      //그룹코드
		$('#grp_nm').text(parent.fn_text('grp_nm'));   //그룹명
		$('#use_yn').text(parent.fn_text('use_yn'));     //사용여부
		$('#use_y').text(parent.fn_text('use_y'));
		$('#use_n').text(parent.fn_text('use_n'));
		$('#lang_se').text(parent.fn_text('lang_se'));      //언어구분
		
		$('#cd').text(parent.fn_text('cd'));       //코드
		$('#cd_nm').text(parent.fn_text('cd_nm'));  //코드명
		$('#rsv_item1').text(parent.fn_text('rsv_item')+"1");   //예비항목
		$('#rsv_item2').text(parent.fn_text('rsv_item')+"2");    //예비항목
		$('#rsv_item3').text(parent.fn_text('rsv_item')+"3");     //예비항목
		$('#use_yn_2').text(parent.fn_text('use_yn'));          //사용여부
		$('#use_y_2').text(parent.fn_text('use_y'));
		$('#use_n_2').text(parent.fn_text('use_n'));
		$('#sel_ord').text(parent.fn_text('sel_ord'));                //표시순서
		
		 //div필수값 alt
		 $("#GRP_CD").attr('alt',parent.fn_text('grp_cd'));       
		 $("#GRP_NM").attr('alt',parent.fn_text('grp_nm'));
		   
		 $("#ETC_CD").attr('alt',parent.fn_text('cd'));
		 $("#ETC_CD_NM").attr('alt',parent.fn_text('cd_nm'));
		 $("#SEL_ORD").attr('alt',parent.fn_text('sel_ord'));
	 
		 
			/************************************
			 * 조회버튼 클릭 이벤트
			 ***********************************/
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
		     /************************************
			 * 초기화버튼 클릭 이벤트
			 ***********************************/
			$("#btn_init").click(function(){
				fn_init();
			});
	      
			/************************************
			 * 저장버튼 클릭 이벤트
			 ***********************************/
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			   /************************************
			 * 초기화버튼 클릭 이벤트
			 ***********************************/
			$("#btn_init2").click(function(){
				fn_init2();
			});
	      
			/************************************
			 * 저장버튼 클릭 이벤트
			 ***********************************/
			$("#btn_reg2").click(function(){
				fn_reg2();
			});
		 
   	grdUseYnList.push({'label': "사용", 'code': "Y" });
   	grdUseYnList.push({'label': "미사용", 'code': "N" });
   	
    document.getElementById("GRP_CD").disabled = false;
   	document.getElementById("ETC_CD").disabled = false;
 
 //  	$("#GRP_CD").attr("disabled",false);
 //  	$("#ETC_CD").attr("disabled",false);
   	gridSet();
   	
   	kora.common.setEtcCmBx2(grp_se_list, "","", $("#SEL_GRP_SE"),"GRP_SE", "GRP_SE_NM", "N",'S');
   	kora.common.setEtcCmBx2(grp_se_list, "","", $("#GRP_SE"),"GRP_SE", "GRP_SE_NM", "N",'T');
	kora.common.setEtcCmBx2(lang_se_cd_lst, "","", $("#LANG_SE_CD"),       "LANG_SE_CD", "LANG_SE_CD", "N");
	kora.common.setEtcCmBx2(lang_se_cd_lst, "","", $("#SEL_LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
   	
	//그룹코드 대문자 변환
	$("#GRP_CD").bind("keyup" ,function(){
		$(this).val( $(this).val().toUpperCase());
	});
	//상세코드  코드 대문자 변환
	$("#ETC_CD").bind("keyup" ,function(){
		$(this).val( $(this).val().toUpperCase());
	});
	
   });

   //조회
   function fn_sel(){
   	
   	var input_sel = {};
   	var url = "/CE/EPCE3968101_192.do";
   	
   	input_sel["LANG_SE_CD"] = $("#SEL_LANG_SE_CD").val();
   	input_sel["GRP_SE"]         = $("#SEL_GRP_SE").val();
   	input_sel["GRP_NM"]       = $("#SEL_GRP_NM").val();
   	
   	showLoadingBar();
   	ajaxPost(url, input_sel, function(rtnData){
   		
   		if(rtnData != null && rtnData != ""){
   			
   			var etc_cd_grp_lst = rtnData.etc_cd_grp_lst;
   			
   			for(var i=0; i<etc_cd_grp_lst.length ;i++){
   					for(var k=0; k<grp_se_list.length ;k++){
   						if(etc_cd_grp_lst[i].GRP_SE ==grp_se_list[k].GRP_SE){
   							etc_cd_grp_lst[i].GRP_SE_NM =grp_se_list[k].GRP_SE_NM;
   							break;
   						}
   					}
   			}
   			gridApp.setData(rtnData.etc_cd_grp_lst);
   			fn_init();
   			fn_init2();
   			gridRoot2.removeAll();
   			hideLoadingBar();
   		} else {
   			alertMsg("error");
   		}
   		
   	});
   };

   //상세코드 조회
   function fn_sel2(item){
	   
   	var url = "/CE/EPCE3968101_193.do";
   	
   	showLoadingBar();
   	ajaxPost(url, item, function(rtnData){
   		
   		if(rtnData != null && rtnData != ""){
   			gridApp2.setData(rtnData.etc_cd_dtl_lst);
   			fn_init2();
   			etc_cd_dtl_lst = rtnData.etc_cd_dtl_lst
   			fn_view_ord()  //표시순서셋팅
   			hideLoadingBar();
   		} else {
   			alertMsg("error");
   		}
   		
   	});
   };

	//그룹코드 조회결과에따라 수정 저장 여부 확인
	function fn_reg() {

		//필수입력값 체크
		if (!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		var url = "/CE/EPCE3968101_19.do"; //조회 URL
		input = {};
		input["SAVE_CHK"] = "S" //   I일경우 저장  , U일경우 수정
		input["GRP_CD"] = $("#GRP_CD").val();
		input["GRP_NM"] = $("#GRP_NM").val();
		input["USE_YN"] = $("#USE_YN").val();
		input["GRP_SE"] = $("#GRP_SE").val();
		input["LANG_SE_CD"] = $("#LANG_SE_CD").val();

		ajaxPost(url, input, function(rtnData) {
			if (rtnData != null && rtnData != "") {
				if (rtnData.RSLT_CD == 'A003') {
						confirm(  (parent.fn_text('present')+"  " + $("#GRP_CD").val()+ " " +parent.fn_text('same_cd')),"fn_reg_cmpt" );
						input["SAVE_CHK"] ="U"
						return false;
				} else if(rtnData.RSLT_CD == '0000') {
						confirm(	 (parent.fn_text('grp_cd')+ "  " +parent.fn_text('new_cd')),"fn_reg_cmpt")
						return;
				}
				hideLoadingBar();
			} else {
				alertMsg("error");
			}
		});
	}
    //저장 및 수정
	function  fn_reg_cmpt() {
		var url = "/CE/EPCE3968101_09.do"; //저장 URL
		showLoadingBar();
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG);
				fn_sel();   // 재검색
				fn_init();  //  입력창 초기화
			} else {
				alertMsg("error");
			}
		});
		hideLoadingBar();
	}

	function fn_reg2() {
   
		if(!dtl_save_chk){
			alertMsg("그룹코드를 선택해주세요")
			return 
		}
		//필수입력값 체크
		if (!kora.common.cfrmDivChkValid("divInput2")) {
			return;
		}
		
		var url = "/CE/EPCE3968101_194.do"; //저장 수정여부 검사 URL
		var chkidx = selectorColumn.getSelectedIndices();
		var item = gridRoot.getItemAt(chkidx);
		input2 = {};
		input2["SEL_ORD_CHK"] = "E";
		
		//표시순서 변경시 
		for(var i =0; i<etc_cd_dtl_lst.length ;i++){
			if ($("#SEL_ORD").val() == etc_cd_dtl_lst[i].SEL_ORD && $("#ETC_CD").val() != etc_cd_dtl_lst[i].ETC_CD) { 
				for(var index=0;index<etc_cd_dtl_lst.length; index++){
	                   if($("#ETC_CD").val() ==  etc_cd_dtl_lst[index].ETC_CD   ){
	                	   input2["SEL_ORD_CHK"] = "U";
	                	   input2["ETC_CD_ALT"]    =  etc_cd_dtl_lst[i].ETC_CD    //상대편 코드값
	                	   input2["SEL_ORD_ALT"]  =   etc_cd_dtl_lst[index].SEL_ORD  //내       순번값
	                	   break;
	                   }else{
	                	   input2["SEL_ORD_CHK"] = "U";
	                	   input2["ETC_CD_ALT"]   =  etc_cd_dtl_lst[i].ETC_CD   //새로등록시 상대편 코드값
	                	   input2["SEL_ORD_ALT"] = max+1                                         //새로등록해서 순번값이 없을경우
	                   }
				}  //end of for  index
			}  //end of if
		}  // end of for i 
		
		
		input2["SAVE_CHK"]    = "S" //   I일경우 저장  , U일경우 수정
		input2["ETC_CD"]        = $("#ETC_CD").val();    //기타코드
		input2["USE_YN"]        = $("#USE_YN2").val();   //사용여부
		input2["ETC_CD_NM"]  = $("#ETC_CD_NM").val();   //코드명
		input2["RSV_ITEM1"]    = $("#RSV_ITEM1").val();
		input2["RSV_ITEM2"]    = $("#RSV_ITEM2").val();
		input2["RSV_ITEM3"]    = $("#RSV_ITEM3").val();
		input2["SEL_ORD"]      = $("#SEL_ORD").val();
		input2["GRP_CD"]       = item["GRP_CD"];   //그룹코드
		input2["LANG_SE_CD"] = item["LANG_SE_CD"];
	 	 ajaxPost(url, input2, function(rtnData) {
			if (rtnData != null && rtnData != "") {
				if (rtnData.RSLT_CD == 'A003') {
						confirm(  (parent.fn_text('present')+"  " + $("#ETC_CD").val()+ " " +parent.fn_text('same_cd')),"fn_reg_cmpt2" );
						input2["SAVE_CHK"] ="U"
						return false;
				
				} else if(rtnData.RSLT_CD == '0000') {
					confirm(	 (parent.fn_text('dtl_cd')+ "  " +parent.fn_text('new_cd')),"fn_reg_cmpt2")
					return;
				}
				hideLoadingBar();
			} else {
				alertMsg("error");
			}
		});   

	}
	
	//상세코드 저장
	function fn_reg_cmpt2() {
		var url = "/CE/EPCE3968101_092.do"; //저장 URL
		showLoadingBar();
		ajaxPost(url, input2, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG);
				fn_sel2(input2);   // 재검색
				fn_init2();  //  입력창 초기화
			} else {
				alertMsg("error");
			}
		});
		hideLoadingBar();
		
	}

	// 그룹코드  선택한 행 입력창에 값 넣기
	function fn_rowToInput_grp(rowIndex) {
		//document.getElementById("GRP_CD").disabled = true;
		var item = gridRoot.getItemAt(rowIndex);
		selectorColumn.setSelectedIndex(-1);
 		selectorColumn.setSelectedIndex(rowIndex);
		dataGrid.setSelectedIndex(rowIndex); 
	
		$("#GRP_CD").val(item["GRP_CD"]);
		$("#GRP_NM").val(item["GRP_NM"]);
		$("#USE_YN").val(item["USE_YN"]).prop("selected", true);    //용어구분
		$("#GRP_SE").val(item["GRP_SE"]);    //용어구분
		$("#LANG_SE_CD").val(item["LANG_SE_CD"]).prop("selected", true);    //용어구분
		
       // alertMsg(JSON.stringify(item))
		max = 0;   //상세코드 max 초기화
		fn_sel2(item);   //상세코드 조회
		dtl_save_chk = true //그룹코드 셀선택 해야지만 상세코드 쪽 저장 버튼 활성화
		hideLoadingBar();
	}

	//상세코드  선택한 행 입력창에 값 넣기
	function fn_rowToInput_dtl(rowIndex) {

		//document.getElementById("ETC_CD").disabled = true;
	
		//$("#ETC_CD").removeAttr("disabled", true);
		var item = gridRoot2.getItemAt(rowIndex);
		
		selectorColumn2.setSelectedIndex(-1);
		selectorColumn2.setSelectedIndex(rowIndex);
		dataGrid2.setSelectedIndex(rowIndex);

		$("#ETC_CD").val(item["ETC_CD"]);
		$("#ETC_CD_NM").val(item["ETC_CD_NM"]);
		$("#USE_YN2").val(item["USE_YN"]);
		$("#RSV_ITEM1").val(item["RSV_ITEM1"]);
		$("#RSV_ITEM2").val(item["RSV_ITEM2"]);
		$("#RSV_ITEM3").val(item["RSV_ITEM3"]);
		$("#SEL_ORD").val(item["SEL_ORD"]);

	}

	//그룹코드 입력창 초기화
	function fn_init() {

		document.getElementById("GRP_CD").disabled = false;

		$("#GRP_CD").val("");
		$("#GRP_NM").val("");
		$("#USE_YN").val("Y").prop("selected",true);    //사용여부
		$("#GRP_SE").val("S").prop("selected",true);  
		$("#LANG_SE_CD  option").remove();
	 	kora.common.setEtcCmBx2(lang_se_cd_lst, "","", $("#LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
	  	
	}

	//상세코드 입력창 초기화
	function fn_init2() {

		document.getElementById("ETC_CD").disabled = false;

		$("#ETC_CD").val("");
		$("#ETC_CD_NM").val("");
		$("#USE_YN2").val("Y").prop("selected",true);
		$("#RSV_ITEM1").val("");
		$("#RSV_ITEM2").val("");
		$("#RSV_ITEM3").val("");
		$("#SEL_ORD").val("");

	}
	//표시순서 셋팅
	function fn_view_ord() {
		for (var i = 0; i < etc_cd_dtl_lst.length; i++) {
			if (max < etc_cd_dtl_lst[i].SEL_ORD) {
				max = etc_cd_dtl_lst[i].SEL_ORD
			}
		}
		$("#SEL_ORD").val(max + 1);
	    
	}
	

	//----------------------- 그리드 설정 시작 -------------------------------------

	//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
	var gridApp, gridRoot, dataGrid, selectorColumn;
	var gridApp2, gridRoot2, dataGrid2, selectorColumn2;
	var layoutStr = new Array();
	var layoutStr2 = new Array();

	function gridSet() {

		//rMateDataGrid 를 생성합니다.
		//파라메터 (순서대로) 
		//1. 그리드의 id ( 임의로 지정하십시오. ) 
		//2. 그리드가 위치할 div 의 id (즉, 그리드의 부모 div 의 id 입니다.)
		//3. 그리드 생성 시 필요한 환경 변수들의 묶음인 jsVars
		//4. 그리드의 가로 사이즈 (생략 가능, 생략 시 100%)
		//5. 그리드의 세로 사이즈 (생략 가능, 생략 시 100%)
		rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
		rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");

		layoutStr.push('<rMateGrid>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" class="list_tbl head" sortableColumns="true"  headerHeight="35" headerWordWrap="true" >');
		layoutStr.push('		<columns>');
		layoutStr.push('			<DataGridSelectorColumn id="selector" width="10%" textAlign="center" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'"/>');
		layoutStr.push('			<DataGridColumn dataField="LANG_SE_CD" headerText="'+parent.fn_text('lang_se')+'" textAlign="center" width="18%" />');
		layoutStr.push('			<DataGridColumn dataField="GRP_SE_NM" headerText="'+parent.fn_text('grp_se')+'" textAlign="center" width="18%" />');		
		layoutStr.push('			<DataGridColumn dataField="GRP_CD" headerText="'+parent.fn_text('grp_cd')+'" textAlign="center" width="18%" />');
		layoutStr.push('			<DataGridColumn dataField="GRP_NM" headerText="'+parent.fn_text('grp_nm')+'" width="18%" />');
		layoutStr.push('			<DataGridColumn dataField="USE_YN" headerText="'+parent.fn_text('use_yn')+'" textAlign="center" width="18%"  itemEditor="ComboBoxEditor" editorDataField="selectedDataField" itemRendererDataField="code" itemRenderer="DataProviderItem" itemRendererDataProvider="'
						+ JSON.stringify(grdUseYnList).replace( eval("/" + "\"" + "/g"), "\'") + '"/>');
		layoutStr.push('		</columns>');
		layoutStr.push('	</DataGrid>');
		layoutStr.push('</rMateGrid>');
		
		layoutStr2.push('<rMateGrid>');
		layoutStr2.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" sortableColumns="true" headerHeight="35"  headerWordWrap="true" >');
		layoutStr2.push('		<columns>');
		layoutStr2.push('			<DataGridSelectorColumn id="selector" width="10%" textAlign="center" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'"/>');
		layoutStr2.push('			<DataGridColumn dataField="ETC_CD" headerText="'+parent.fn_text('cd')+'" textAlign="center" width="10%" />');
		layoutStr2.push('			<DataGridColumn dataField="ETC_CD_NM" headerText="'+parent.fn_text('cd_nm')+'" width="15%" />');
		layoutStr2.push('			<DataGridColumn dataField="SEL_ORD" headerText="'+parent.fn_text('sel_ord')+'" textAlign="center" width="10%" />');
		layoutStr2.push('			<DataGridColumn dataField="RSV_ITEM1" headerText="'+parent.fn_text('rsv_item')+'1" width="15%" />');
		layoutStr2.push('			<DataGridColumn dataField="RSV_ITEM2" headerText="'+parent.fn_text('rsv_item')+'2" width="15%" />');
		layoutStr2.push('			<DataGridColumn dataField="RSV_ITEM3" headerText="'+parent.fn_text('rsv_item')+'3" width="15%" />');
		layoutStr2.push('			<DataGridColumn dataField="USE_YN" headerText="'+parent.fn_text('use_yn')+'" textAlign="center" width="10%"  itemEditor="ComboBoxEditor" editorDataField="selectedDataField" itemRendererDataField="code" itemRenderer="DataProviderItem" itemRendererDataProvider="'
						+ JSON.stringify(grdUseYnList).replace(eval("/" + "\"" + "/g"), "\'") + '"/>');
		layoutStr2.push('		</columns>');
		layoutStr2.push('	</DataGrid>');
		layoutStr2.push('</rMateGrid>');

	}

	//그리드의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
	//rMate 그리드의 준비가 완료된 경우 이 함수가 호출됩니다.
	//이 함수를 통해 그리드에 레이아웃과 데이터를 삽입합니다.
	//파라메터 : id - rMateGridH5.create() 사용 시 사용자가 지정한 id 입니다.
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체

		gridApp.setLayout(layoutStr.join("").toString());

		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			fn_rowToInput_grp(rowIndex);
		}

		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		}

		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.setEnabled(true);
			gridRoot.removeLoadingBar();
		}

		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		gridApp.setData();
	}

	
	function gridReadyHandler2(id) {
		gridApp2 = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot2 = gridApp2.getRoot(); // 데이터와 그리드를 포함하는 객체

		gridApp2.setLayout(layoutStr2.join("").toString());

		var selectionChangeHandler2 = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn2 = gridRoot2.getObjectById("selector");
			fn_rowToInput_dtl(rowIndex);
		}

		var layoutCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
			dataGrid2.addEventListener("change", selectionChangeHandler2);
		}

		var dataCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
			dataGrid2.setEnabled(true);
			gridRoot2.removeLoadingBar();
		}

		gridRoot2.addEventListener("dataComplete", dataCompleteHandler2);
		gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler2);
		gridApp2.setData();
	}

	function showLoadingBar() {
		kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}
	//----------------------- 그리드 설정 끝 -----------------------
</script>
   <style type="text/css">

.row .tit{
width: 60px;
}

</style>
    <input type="hidden" id="lang_se_cd_lst" value="<c:out value='${lang_se_cd_lst}' />" />
           <section class="secwrap">
 							<div class="srcharea">
								<div class="row">
									<div class="col">
										<div class="tit"  id='lang_se_sel'></div>
										<div class="box">
											<select id="SEL_LANG_SE_CD" style="width:129px" class="i_notnull"></select>
										</div>
									</div>
									<div class="col">
										<div class="tit">그룹구분</div>
										<div class="box">
										<select id="SEL_GRP_SE" style="width:100px" class="i_notnull">
										</select>
										</div>
									</div>
									<div class="col">
										<div class="tit" id='grp_nm_sel'></div>
										<div class="box">
											<input type="text" id="SEL_GRP_NM" style="width:179px">
										</div>
									</div>
									<div class="btn" id="UR">
									</div>
								</div>
							</div>
						</section>

	<section class="secwrap mt30">
		<div class="halfarea">
			<div class="h4group">
				<h4 class="tit"  id='grp_cd_tit'></h4>
			</div>
			<div class="srcharea" id="divInput">
				<div class="row">
					<div class="col">
						<div class="tit" id='grp_cd''></div>
						<div class="box">
							<input type="text" id="GRP_CD"  maxlength="10" disabled="disabled"	style="width: 130px" class="i_notnull">
						</div>
					</div>
					<div class="col">
						<div class="tit" id='grp_nm'></div>
						<div class="box">
							<input type="text" id="GRP_NM" maxlength="20"  style="width: 185px"	class="i_notnull">
						</div>
					</div>
					<div class="col">
						<div class="tit" id="use_yn"></div>
						<div class="box">
							<select id="USE_YN" style="width: 129px"	class="i_notnull">
											<option value="Y" id="use_y"></option>
											<option value="N" id="use_n"></option>
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit">그룹구분</div>
						<div class="box">
							<select id="GRP_SE" style="width: 129px" class="i_notnull">
											<option value="S">시스템</option>
											<option value="M">메뉴</option>
											<option value="E">빈용기</option>
											<option value="B">기준정보상태</option>
											<option value="D">업무상태</option>
											<option value="C">정산상태</option>
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="lang_se"></div>
						<div class="box">
								<select id="LANG_SE_CD" style="width: 129px" class="i_notnull"></select>
						</div>
					</div>
				</div>
					<div class="row">
					<div class="btn" id="CL">
					</div>
					</div>
				
			</div>   <!-- end of  srcharea  그룹코드 입력란 -->

         <div class="boxarea mt10">
            <div id="gridHolder" class="w_382" style="height:595px;"></div>
        </div>  <!-- boxarea mt10" 그리드 내용표시란 -->
		</div>     <!-- end of halfarea   그룹코드-->
	
	
	    <div class="halfarea">
				<div class="h4group">
					<h4 class="tit">상태코드</h4>
				</div>
      <div class="srcharea"  id="divInput2">
									<div class="row">
										<div class="col">
											<div class="tit" id="cd"></div>
											<div class="box">
												<input type="text" id="ETC_CD" maxlength="10"  disabled="disabled"	style="width: 150px" class="i_notnull"/>
											</div>
										</div>
										<div class="col">
											<div class="tit" id="cd_nm"></div>
											<div class="box">
												<input type="text" id="ETC_CD_NM"  maxlength="20" style="width: 150px"  class="i_notnull"/>
											</div>
										</div>
										<div class="col">
											<div class="tit" id="use_yn_2"></div>
											<div class="box">
												<select id="USE_YN2" style="width: 150px" class="i_notnull">
													<option value="Y" id="use_y_2"></option>
													<option value="N"id="use_n_2"></option>
									           </select>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col">
											<div class="tit" id="rsv_item1"></div>
											<div class="box">
												<input type="text" id="RSV_ITEM1"  maxlength="20"  style="width: 150px"/>
											</div>
										</div>
										<div class="col">
											<div class="tit" id="rsv_item2"></div>
											<div class="box">
												<input type="text" id="RSV_ITEM2"  maxlength="20"  style="width: 150px"/>
											</div>
										</div>
										<div class="col">
											<div class="tit" id="rsv_item3"></div>
											<div class="box">
												<input type="text" id="RSV_ITEM3"  maxlength="20"  style="width: 150px"/>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col">
											<div class="tit" id="sel_ord"></div>
											<div class="box">
												<input type="text" id="SEL_ORD"   maxlength="3"  style="width: 150px" format="number" class="i_notnull">
											</div>
										</div>
										<div class="btn" id="CR">
										</div>
									</div>
								</div>
								
								
      	<div class="boxarea mt10">
      	    <div id="gridHolder2" class="w_382" style="height:540px;">
      	</div>  <!--end of   boxarea mt10 상태코드 그리드-->
      
      </div>
	</section>   <!--end of secwrap mt30  -->
	
			
</div>