<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>다국어관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

    var lang_se_cd_list; //언어구분 리스트
    var lang_grp_cd_list;//용어구분 리스트
    var lang_info_list; //def값 리스트

	$(function() {
		
			lang_se_cd_list 		=  jsonObject($("#lang_se_cd_list").val());	
			lang_grp_cd_list		=  jsonObject($("#lang_grp_cd_list").val());       
			lang_info_list 			=  jsonObject($("#lang_info_list").val());
		
		
			//그리드 기본셋팅
			fnSetGrid1();

			 //버튼 셋팅
	    	 fn_btnSetting();
			 
			 
	    	//div필수값 alt
			 $("#LANG_CD").attr('alt',parent.fn_text('lang_cd'));       
			 $("#LANG_NM").attr('alt',parent.fn_text('lang_nm'));
				   

		/************************************
		 * 조회부분 - 언어구분 변경 이벤트
		 ***********************************/
		$("#SEL_LANG_SE_CD").change(function(){
			fn_alt_lang_cd(19);
			$("#SEL_LANG_GRP_CD").val("");
		});
		
		/************************************
		 * 입력부분 - 언어구분 변경 이벤트
		 ***********************************/
		$("#LANG_SE_CD").change(function(){
			fn_alt_lang_cd();
			$("#LANG_GRP_CD").val("1");
		});

		
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
		 * 팝업창버튼 클릭 이벤트
		 ***********************************/
		$("#btn_pop").click(function(){
			fn_pop();
		});
		
		$("#SEL_LANG_NM").keydown(function(e){if(e.keyCode == 13)  fn_sel(); });
		
		//SELECT BOX 설정
		
		kora.common.setEtcCmBx2(lang_se_cd_list, "","", $("#SEL_LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(lang_grp_cd_list, "","", $("#SEL_LANG_GRP_CD"), "ETC_CD", "ETC_CD_NM", "N","T");
		kora.common.setEtcCmBx2(lang_se_cd_list, "","", $("#LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
		kora.common.setEtcCmBx2(lang_grp_cd_list, "","", $("#LANG_GRP_CD"), "ETC_CD", "ETC_CD_NM", "N");
		
	});
    
    //다국어관리 조회
	function fn_sel(){
		 // 39       448      01               19       2
        //관리지  다국어   기본페이지   검색    2번째 조회 function
		var url ="/CE/EPCE3944801_192.do"
		
		var input ={};
		input["LANG_SE_CD"]   = $("#SEL_LANG_SE_CD").val();   // 언어구분코드  ex) KOR
		input["LANG_GRP_CD"] = $("#SEL_LANG_GRP_CD").val();   // 용어그룹코드  ex) 타이틀

		input["LANG_NM"]  =$("#SEL_LANG_NM").val();
			ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.lang_info_list);
				//	fn_init();
					hideLoadingBar();
				} else {
					alertMsg("error");
				}
			});
		
	}
    //언어구분 select박스 변경시 데이터값 호출   
  function fn_alt_lang_cd(val){
	  
	  var input ={};
	  if(val =="19"){ //조회 쪽 언어구분
		  $("#SEL_LANG_GRP_CD option").remove();
		  input["LANG_SE_CD"]  = $("#SEL_LANG_SE_CD option:selected").val();
	  }else{ //입력쪽 언어구분
	      input["LANG_SE_CD"]  = $("#LANG_SE_CD option:selected").val();
	      $("#LANG_GRP_CD  option").remove();
	  } 
	  
	  var url ="/CE/EPCE3944801_19.do"
		 ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				
					if(val ==19){
						kora.common.setEtcCmBx2(rtnData.lang_grp_cd_list, "","", $("#SEL_LANG_GRP_CD"), "ETC_CD", "ETC_CD_NM", "N","T");
					}else{
						kora.common.setEtcCmBx2(rtnData.lang_grp_cd_list, "","", $("#LANG_GRP_CD"), "ETC_CD", "ETC_CD_NM", "N","T");
					}
					
			} else {
				alertMsg("error");
			}
		},false);  
  }
  
     //초기화
     function fn_init(){
    	 $("#SEL_LANG_NM").val("");
    	 $("#LANG_CD").val("")                               //용어코드
    	 $("#LANG_NM").val("")                                 //용어명
    	 $("#USE_YN").val("Y").prop("selected",true);    //사용여부
    	 $("#LANG_GRP_CD  option").remove();    
    	 $("#LANG_SE_CD  option").remove();
 	 	 kora.common.setEtcCmBx2(lang_se_cd_list, "","", $("#LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
 		 kora.common.setEtcCmBx2(lang_grp_cd_list, "","", $("#LANG_GRP_CD"), "ETC_CD", "ETC_CD_NM", "N");
     }
     
     
     //저장 수정인지 확인 
     function fn_reg(){
    	 
    	//필수입력값 체크
 		if (!kora.common.cfrmDivChkValid("divInput")) {
 			return;
 		}
    	  
 	   var input ={};
       input["LANG_CD"]          = $("#LANG_CD").val();       	//용어코드
       input["LANG_SE_CD"]      = $("#LANG_SE_CD").val();   //언어구분
       input["LANG_GRP_CD"]   = $("#LANG_GRP_CD").val(); //용어구분
       input["LANG_NM"]         = $("#LANG_NM").val();        //용어명
       input["USE_YN"]             = $("#USE_YN").val();        //사용여부
      
       //조회결과에따라 수정 저장 여부 확인
		ajaxPost("/CE/EPCE3944801_193.do",input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				
				if(rtnData.RSLT_CD =='A003'){
					confirm(  (parent.fn_text('present')+"  " + $("#LANG_CD").val()+ " " +parent.fn_text('same_cd')),"fn_reg_cmpt2" );
					return;
				}else{
					confirm(	 (parent.fn_text('lang_cd')+ "  " +parent.fn_text('new_cd')),"fn_reg_cmpt");
			    	return;
				}
				
			} else {
				alertMsg("error");
			}
		}); 
       
    
	 }
     
     //저장   
     function fn_reg_cmpt (){
    	 var input ={};
    	 var url = "/CE/EPCE3944801_09.do";  //저장url
         input["LANG_CD"]          = $("#LANG_CD").val();       //용어코드
         input["LANG_SE_CD"]      = $("#LANG_SE_CD").val();         //언어구분
         input["LANG_GRP_CD"]   = $("#LANG_GRP_CD").val();        //용어구분
         input["LANG_NM"]         = $("#LANG_NM").val();        //용어명
         input["USE_YN"]             = $("#USE_YN").val();         //사용여부
        
       	   ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {
    					alertMsg(rtnData.RSLT_MSG);
    					fn_sel();
    				} else {
    					alertMsg("error");
    				}
    		});
     }
     
     //수정 
     function fn_reg_cmpt2 (input,url){
    	 var input ={};
    	 var url = "/CE/EPCE3944801_21.do";
         input["LANG_CD"]          = $("#LANG_CD").val();       //용어코드
         input["LANG_SE_CD"]      = $("#LANG_SE_CD").val();         //언어구분
         input["LANG_GRP_CD"]   = $("#LANG_GRP_CD").val();         //용어구분
         input["LANG_NM"]         = $("#LANG_NM").val();        //용어명
         input["USE_YN"]             = $("#USE_YN").val();           //사용여부
        
    	   showLoadingBar();
       	   ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {
    					alertMsg(rtnData.RSLT_MSG);
    					fn_sel();
    				} else {
    					alertMsg("error");
    				}
    		},false);
    			hideLoadingBar();
     }
		//언어구분관리 페이지 호출
	function fn_pop() {
		window.parent.NrvPub.AjaxPopup('/CE/EPCE3944888.do');
	};
	

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
		layoutStr.push('			<DataGridSelectorColumn id="selector" width="5%" textAlign="center" allowMultipleSelection="false" headerText="선택"/>');
		layoutStr.push('			<DataGridColumn dataField="LANG_SE_CD" headerText="언어구분" width="10%" textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="ETC_CD_NM" headerText="용어구분" width="10%" itemRenderer="HtmlItem"  textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="LANG_CD" headerText="용어코드" width="20%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="LANG_NM" headerText="용어명" width="50%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="USE_YN" headerText="사용여부" width="10%" textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="LANG_GRP_CD" headerText="용어구분코드" visible="false" />');
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
		gridApp.setData(lang_info_list);
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
		
		if($("#LANG_SE_CD").val() != item["LANG_SE_CD"]   ){ //같은 언어구분시 언어구분 호출 하지 않기위해
		   $("#LANG_SE_CD").val(	item["LANG_SE_CD"]).prop("selected", true);   //언어구분
		    fn_alt_lang_cd(); // 언어구분별 용어구분 조회해서 넣어주기
		}
	    $("#LANG_GRP_CD").val(item["LANG_GRP_CD"]).prop("selected", true);    //용어구분
		$("#LANG_CD").val(item["LANG_CD"]);     // 용어코드
		$("#LANG_NM").val(item["LANG_NM"]);     //용어맹
		$("#USE_YN").val(item["USE_YN_ORI"]).prop("selected", true);            //사용여부
	};
	/****************************************** 그리드 셋팅 끝***************************************** */
</script>
<style type="text/css">
.row .tit{
width: 60px;
}
</style>
</head>
	<body>

		<div class="iframe_inner">
		    <input type="hidden" id="lang_se_cd_list" value="<c:out value='${lang_se_cd_list}' />" />
			<input type="hidden" id="lang_grp_cd_list" value="<c:out value='${lang_grp_cd_list}' />" />
			<input type="hidden" id="lang_info_list" value="<c:out value='${lang_info_list}' />" />
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
			</div>
			<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit">언어구분</div>
						<div class="box">
							<select id="SEL_LANG_SE_CD" style="width: 179px">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit">용어구분</div>
						<div class="box">
							<select id="SEL_LANG_GRP_CD" style="width: 179px"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit">용어명</div>
						<div class="box">
							<input type="text" id="SEL_LANG_NM" maxlength="15"	style="width: 250px;">
						</div>
					</div>
					
					
					<div class="btn">
						<button type="button" class="btn36 c1" style="width: 100px;"	id="btn_sel">조회</button>
					</div>
				</div>
			</div>
			</section>
	
			<section class="secwrap mt30">
			<div class="srcharea" id="divInput">
				<div class="row">
					<div class="col">
						<div class="tit">용어구분</div>
						<div class="box">
							<select id="LANG_GRP_CD" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit">용어코드</div>
						<div class="box">
							<input type="text" id="LANG_CD" maxlength="20"	style="width: 179px;" class="i_notnull">
						</div>
					</div>
					<div class="col">
						<div class="tit">언어구분</div>
						<div class="box">
							<select id="LANG_SE_CD" style="width: 117px" class="i_notnull"></select>
						</div>
					</div>
				</div>
	
				<div class="row">
					<div class="col">
						<div class="tit">용어명</div>
						<div class="box">
							<input type="text" id="LANG_NM" style="width: 467px;" maxlength="40"	class="i_notnull">
						</div>
					</div>
					<div class="col">
						<div class="tit">사용여부</div>
						<div class="box">
							<select id="USE_YN" style="width: 117px" class="i_notnull">
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
						</div>
					</div>
					<div class="btn">
						<button type="button" class="btn36 c4" style="width: 100px;"	id="btn_init">초기화</button>
						<button type="button" class="btn36 c2" style="width: 100px;"	id="btn_reg">저장</button>
					</div>
				</div>
			</div>

	       </section>		<!-- end of secwrap mt30  -->
			
			<section class="secwrap">
				<div class="boxarea mt10">
					<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
				</div>	<!-- 그리드 셋팅 -->
			</section>	<!-- end of secwrap mt30  -->
				
			<section class="btnwrap mt20" style="height: 90px; " >
				<div class="btn" style="float:right" id="BR"></div>
			</section>
			
		</div><!-- end of  iframe_inner -->
	</body>
</html>


     