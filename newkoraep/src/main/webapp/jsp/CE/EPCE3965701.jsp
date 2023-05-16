<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@include file="/jsp/include/common_page.jsp" %>
	<!-- 오류코드 -->
		<div class="iframe_inner">
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
			</div>
	<script type="text/javaScript" language="javascript" defer="defer">
	
	    var lang_se_cd_list; //언어구분 리스트
	    var err_cd_list;//오류코드 리스트
	    var input ={};
	    
		$(function() {
			
			lang_se_cd_list 	=  jsonObject($("#lang_se_cd_list").val());	
			err_cd_list		=  jsonObject($("#err_cd_list").val());      
			
			
			//그리드 기본셋팅
			fnSetGrid1();
		
			 //div필수값 alt
			 $("#ERR_CD").attr('alt',parent.fn_text('err_cd'));       
			 $("#ERR_MSG").attr('alt',parent.fn_text('err_msg'));
				   
			/************************************
			 * 입력 - 언어구분 변경 이벤트
			 ***********************************/
			$("#LANG_SE_CD").change(function(){
				fn_alt_lang_cd();
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
			
			//SELECT BOX 설정
			kora.common.setEtcCmBx2(lang_se_cd_list, "","", $("#SEL_LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
			kora.common.setEtcCmBx2(lang_se_cd_list, "","", $("#LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
			kora.common.setEtcCmBx2(err_cd_list, "","", $("#ERR_SE"), "ETC_CD", "ETC_CD_NM", "N");
			
		});
	    //오류코드 조회
		function fn_sel(){
			 // 39       448      01               19       2
	        //관리지  다국어   기본페이지   검색    2번째 조회 function
			var url ="/CE/EPCE3965701_19.do"
			
			var input_sel ={};
			input_sel["LANG_SE_CD"]   = $("#SEL_LANG_SE_CD").val();   // 언어구분코드  ex) KOR
			input_sel["ERR_CD"]          = $("#SEL_ERR_CD").val();           // 용어그룹코드  ex) 타이틀
			
				ajaxPost(url,input_sel, function(rtnData){
					if(rtnData != null && rtnData != ""){
						gridApp.setData(rtnData.err_cd_sel_list);
						//fn_init();
						hideLoadingBar();
					} else {
						alertMsg("error");
					}
				});
			
		}
	    //언어구분 select박스 변경시 데이터값 호출   
	  function fn_alt_lang_cd(val){
		  var input ={};
		      input["LANG_SE_CD"]  = $("#LANG_SE_CD option:selected").val();
		      $("#ERR_SE  option").remove();
		  var url ="/CE/EPCE3965701_192.do"
			 ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					$.each(rtnData.err_cd_sel_list, function(i, v){
					     $("#ERR_SE").append('<option value="' + v.ETC_CD + '" '+("selected")+'>' + v.ETC_CD_NM + '</option>'); 
					});
				} else {
					alertMsg("error");
				}
			},false);  
	  }
	  
	     //초기화
	     function fn_init(){
	    	 $("#ERR_CD").val("")                               //오류코드
	    	 $("#ERR_MSG").val("")                                 //오류메시지
	    	 $("#USE_YN").val("Y").prop("selected",true);    //사용여부
	    	 $("#ERR_SE  option").remove();       //오류구분
	    	 $("#LANG_SE_CD  option").remove();
	 	 	 kora.common.setEtcCmBx2(lang_se_cd_list, "","", $("#LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N");
	 		 kora.common.setEtcCmBx2(err_cd_list, "","", $("#ERR_SE"), "ETC_CD", "ETC_CD_NM", "N");
	     }
	     
	     //저장 수정인지 확인 
	     function fn_reg(){
	    	  //필수입력값 체크
	 		if (!kora.common.cfrmDivChkValid("divInput")) {
	 			return;
	 		}
	    	  
	       var url = "/CE/EPCE3965701_193.do";  //저장url
	       input ={};
	       input["SAVE_CHK"]    = "S" //   I일경우 저장  , U일경우 수정
	       input["ERR_SE"]            = $("#ERR_SE").val();               //오류구분
	       input["ERR_CD"]           = $("#ERR_CD").val();             //오류코드
	       input["LANG_SE_CD"]    = $("#LANG_SE_CD").val();     //언어구분
	       input["ERR_MSG"]         = $("#ERR_MSG").val();        //오류메시지
	       input["USE_YN"]           = $("#USE_YN").val();         //사용여부
	      
	       
	       //조회결과에따라 수정 저장 여부 확인
			ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					
					if(rtnData.RSLT_CD =='A003'){
						confirm(  (parent.fn_text('present')+"  " + $("#ERR_CD").val()+ " " +parent.fn_text('same_cd')),"fn_reg_cmpt" );
						input["SAVE_CHK"] ="U"//수정일경우
						return;
					}else{
				    	confirm(	 (parent.fn_text('err_cd')+ "  " +parent.fn_text('new_cd')),"fn_reg_cmpt");
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
	    	 
	    	   var url ="/CE/EPCE3965701_09.do"
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
			layoutStr.push('			<DataGridSelectorColumn id="selector" width="8%" textAlign="center" allowMultipleSelection="false" headerText="선택"/>');
			layoutStr.push('			<DataGridColumn dataField="LANG_SE_CD" headerText="언어구분" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="ERR_SE_NM" headerText="오류구분" width="10%" itemRenderer="HtmlItem"  textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="ERR_CD" headerText="오류코드" width="10%" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="ERR_MSG" headerText="오류메시지" width="40%" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="USE_YN" headerText="사용여부" width="10%" textAlign="center"/>');
   	 	    layoutStr.push('			<DataGridColumn dataField="ERR_SE" headerText="오류구분코드" visible="false" />');
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
			
			if($("#LANG_SE_CD").val() != item["LANG_SE_CD"]   ){ //같은 언어구분시 언어구분 호출 하지 않기위해
			   $("#LANG_SE_CD").val(	item["LANG_SE_CD"]).prop("selected", true);   //언어구분
			    fn_alt_lang_cd(); // 언어구분별 용어구분 조회해서 넣어주기
			}
			$("#ERR_SE").val(item["ERR_SE"]).prop("selected", true);    //용어구분
			$("#ERR_MSG").val(item["ERR_MSG"]);     // 용어코드
			$("#ERR_CD").val(item["ERR_CD"]);     //용어맹
			$("#USE_YN").val(item["USE_YN_ORI"]).prop("selected", true);            //사용여부
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

				    
	    <input type="hidden" id="lang_se_cd_list" value="<c:out value='${lang_se_cd_list}' />" />
		<input type="hidden" id="err_cd_list" value="<c:out value='${err_cd_list}' />" />
		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit">언어구분</div>
						<div class="box">
							<select id="SEL_LANG_SE_CD" style="width: 117px"></select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit">오류코드</div>
						<div class="box">
							<input type="text" id="SEL_ERR_CD" style="width: 179px"></div>
					</div>
					<div class="btn">
						<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
					</div>
				</div>
			</div>
		</section>
	
		<section class="secwrap mt30">
			<div class="srcharea" id="divInput">
				<div class="row">
					<div class="col">
						<div class="tit">오류구분</div>
						<div class="box">
							<select id="ERR_SE" style="width: 117px" class="i_notnull"></select>
						</div>
					</div>
					<div class="col" >
						<div class="tit"  >오류코드</div>
						<div class="box">
							<input type="text" id="ERR_CD" maxlength="4"	style="width: 179px; text-align: center;" class="i_notnull">
						</div>
					</div>
					<div class="col">
						<div class="tit">언어구분</div>
						<div class="box">
							<select id="LANG_SE_CD" style="width: 117px" class="i_notnull" ></select>
						</div>
					</div>
					
				</div>
	
				<div class="row">
					
					<div class="col" >
						<div class="tit">사용여부</div>
						<div class="box">
							<select id="USE_YN" style="width: 117px" class="i_notnull">
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
						</div>
					</div>
					
					<div class="col" style="width: 48%">
						<div class="tit">오류메시지</div>
						<div class="box" style="width:77%">
							<input type="text" id="ERR_MSG"	style="width: 100%;" maxByteLength="200"	class="i_notnull">
						</div>
					</div>
					<div class="btn">
						<button type="button" class="btn36 c4" style="width: 100px;"	 id="btn_init">초기화</button>
						<button type="button" class="btn36 c2" style="width: 100px;"    id="btn_reg">저장</button>
					</div>
				</div>
	
			</div>
	
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
	
	
		</section>	<!-- end of secwrap mt30  -->

</div>   <!--end of  pagedata -->


     