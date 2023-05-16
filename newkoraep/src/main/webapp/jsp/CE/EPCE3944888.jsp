<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>언어구분관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
	
	<script type="text/javaScript"  language="javascript" defer="defer">
	
		var lang_se_mgnt_list_p;
		var max = 0; //표시순서 MAX값
		var data={};
		var flag= true;
		$(function() {
		
			lang_se_mgnt_list_p		=  jsonObject($("#lang_se_mgnt_list_p").val());       
			 //버튼 셋팅
	    	 fn_btnSetting("EPCE3944888");
			 
			//그리드 기본셋팅
			fnSetGrid_P();
		
			//표시순서셋팅
			fn_view_ord();
			
			 //div필수값 alt
			 $("#SEL_ORD_P").attr('alt',parent.fn_text('sel_ord'));      
			 $("#LANG_SE_CD_P").attr('alt',parent.fn_text('lang_se_cd'));     
			 $("#LANG_SE_NM_P").attr('alt',parent.fn_text('lang_se_nm'));
			
			
		  //상세코드  코드 대문자 변환
			$("#LANG_SE_CD_P").bind("keyup" ,function(){
				$(this).val( $(this).val().toUpperCase());
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
				fn_reg_chk();
			});
			
		});
	    //저장시 데이터 셋팅
		function fnDataSet(){
		
			var url = "/CE/EPCE3944888_19.do"
 			
	    	   showLoadingBar_p();
	       	   ajaxPost(url, "", function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {
	    					gridApp2.setData(rtnData.lang_se_mgnt_list_p);
	    					lang_se_mgnt_list_p = rtnData.lang_se_mgnt_list_p;
	    					fn_init();
	    				} else {
	    					alertMsg("error");
	    				}
	    		});
	    			hideLoadingBar_p();
			
		}
		//초기화
		function fn_init(){
			$("#LANG_SE_CD_P").val("");
			$("#LANG_SE_NM_P").val("");
			$("#USE_YN_P").val("Y").prop("selected",true);
			$("#STD_YN_P").val("N").prop("selected",true);
			fn_view_ord();
		}
		
		
		
		function fn_reg_chk(){
			 //필수입력값 체크
			if (!kora.common.cfrmDivChkValid("divInput_P")) {
				return;
			}
			var lang_se_cd_check = $("#LANG_SE_CD_P").val()  //언어구분코드 소문자입력해도 대문자로 받아서 리스트 확인
			var str = $("#LANG_SE_CD_P").val();
			var check = /[^a-z0-9]/gi;
				 data={};
				 data["URL"]="";
			for (var i = 0; i < lang_se_mgnt_list_p.length; i++) {
			
				//언어구분코드 영어,숫자 체크
				if (check.test(str)) { 
					alertMsg("영어와 숫자만 입력이 가능합니다");
					$("#LANG_SE_CD_P").focus();
					return;
				}
				//언어구분코드 체크
		 	 	if ( lang_se_cd_check.toUpperCase() == lang_se_mgnt_list_p[i].LANG_SE_CD) { 
						confirm("동일한 언어구분 정보가 존재합니다. 변경사항을 적용하시겠습니까? ","fn_reg_chk2");
						data["URL"] ="/CE/EPCE3944888_21.do";//update url
						flag= false;
						return false;
				}
			}
			fn_reg_chk2();
			
		}
		function fn_reg_chk2(){
			data["LANG_SE_CD_STD"] ="";
			for (var i = 0; i < lang_se_mgnt_list_p.length; i++) {
			  //표준여부 변경시
		         if ($("#STD_YN_P option:selected").val() == lang_se_mgnt_list_p[i].STD_YN_ORI	&& $("#STD_YN_P option:selected").val() == "Y") { //표준여부 변경 체크
	
						if ($("#LANG_SE_CD_P").val() != lang_se_mgnt_list_p[i].LANG_SE_CD) {
								confirm("현재 " + lang_se_mgnt_list_p[i].LANG_SE_NM + " 가 표준으로 설정되어 있습니다. 표준언어 설정을 변경하시겠습니까? ","fn_reg_chk3")
								data["LANG_SE_CD_STD"] = lang_se_mgnt_list_p[i].LANG_SE_CD //표준여부가 변경된 언어구분코드
								flag= false;
								return;
						}else{
						
						}//end of if LANG_SE_CD
				} //end of if STD_YN
			}
			fn_reg_chk3();
		}
		function fn_reg_chk3(){
			if(flag){
			   	confirm(	 (parent.fn_text('lang_se_cd')+ "  " +parent.fn_text('new_cd')),"fn_reg");
			}else{
				fn_reg();
			}
		}
		
		
		
		//저장
	   function fn_reg(){
			var url = "/CE/EPCE3944888_09.do"; //INSERT URL
			data["LANG_SE_CD_CNT"] = "";        //표시순서 CODE변경
			data["SEL_ORD_CG"] = "";               //표시순서 ORD변경
	
			for (var i = 0; i < lang_se_mgnt_list_p.length; i++) {
	
				 //표시순서 변경시 
				 if ($("#SEL_ORD_P").val() == lang_se_mgnt_list_p[i].SEL_ORD) { 
					for(var index=0;index<lang_se_mgnt_list_p.length; index++){
	                       if($("#LANG_SE_CD_P").val() ==  lang_se_mgnt_list_p[index].LANG_SE_CD   ){
	                    	   data["LANG_SE_CD_CNT"] =  lang_se_mgnt_list_p[i].LANG_SE_CD 
	                    	   data["SEL_ORD_CG"]        =   lang_se_mgnt_list_p[index].SEL_ORD 
	                    	   break;
	                       }else{
	                    	   data["LANG_SE_CD_CNT"] =  lang_se_mgnt_list_p[i].LANG_SE_CD 
	                    	   data["SEL_ORD_CG"] = max+1
	                       }
					}//end of for  index
				 }
			} //end of for i
	
			data["LANG_SE_CD"]  = $("#LANG_SE_CD_P").val();
			data["LANG_SE_NM"] = $("#LANG_SE_NM_P").val();
			data["USE_YN"]          = $("#USE_YN_P option:selected").val();
			data["SEL_ORD"]        = $("#SEL_ORD_P").val();
			data["STD_YN"]         = $("#STD_YN_P option:selected").val();
			

              if(data["URL"] !=""){
            	  url = data["URL"];
              }
	
			 ajaxPost(url, data, function(rtnData) {
				if ("" != rtnData && null != rtnData) {
				
					if(rtnData.RSLT_CD =="A003"){ //중복일경우
						alertMsg(rtnData.RSLT_MSG)
					}else{
						alertMsg(rtnData.RSLT_MSG) //정상저장일경우
					}
				} else {
					alertMsg("error");
				}
			}, false); 
				 fnDataSet();  
		}
	
		//행선택시 입력값 input에  넣기
		function fn_rowToInput_P(rowIndex) {
			var item = gridRoot2.getItemAt(rowIndex);
			selectorColumn2.setSelectedIndex(-1);
			selectorColumn2.setSelectedIndex(rowIndex);
			$("#LANG_SE_CD_P").val(item["LANG_SE_CD"]);
			$("#LANG_SE_NM_P").val(item["LANG_SE_NM"]);
			$("#USE_YN_P").val(item["USE_YN_ORI"]);
			$("#SEL_ORD_P").val(item["SEL_ORD"]);
			$("#STD_YN_P").val(item["STD_YN_ORI"]);
		};
	
		//표시순서 셋팅
		function fn_view_ord() {
			for (var i = 0; i < lang_se_mgnt_list_p.length; i++) {
				if (max < lang_se_mgnt_list_p[i].SEL_ORD) {
					max = lang_se_mgnt_list_p[i].SEL_ORD
				}
			}
			$("#SEL_ORD_P").val(max + 1);
		}
	
	
	 /****************************************** 그리드 셋팅 시작***************************************** */
		/**
		 * 그리드 관련 변수 선언
		 */
		var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
		var gridApp2, gridRoot2, dataGrid2, selectorColumn2;
		var layoutStr2 = new Array();
	
		/**
		 * 그리드 셋팅
		 */
		function fnSetGrid_P(reDrawYn) {
			rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
	
			layoutStr2 = new Array();
			layoutStr2.push('<rMateGrid>');
			layoutStr2.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr2.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"  headerHeight="35">');
			layoutStr2.push('		<columns>');
			layoutStr2.push('			<DataGridSelectorColumn id="selector" width="10%" textAlign="center" allowMultipleSelection="false" headerText="선택"/>');
			layoutStr2.push('			<DataGridColumn dataField="LANG_SE_CD" headerText="언어구분코드" width="20%" textAlign="center"/>');
			layoutStr2.push('			<DataGridColumn dataField="LANG_SE_NM" headerText="언어구분명" width="20%"/>');
			layoutStr2.push('			<DataGridColumn dataField="SEL_ORD" headerText="표시순서" width="10%" textAlign="right" />');
			layoutStr2.push('			<DataGridColumn dataField="STD_YN" headerText="표준여부" width="10%" textAlign="right" />');
			layoutStr2.push('			<DataGridColumn dataField="USE_YN" headerText="사용여부" width="10%" textAlign="center"/>');
			layoutStr2.push('		</columns>');
			layoutStr2.push('	</DataGrid>');
			layoutStr2.push('</rMateGrid>');
		};
		
		/**
		 * 조회기준-생산자 그리드 이벤트 핸들러
		 */
		 function gridReadyHandler2(id) {
				gridApp2 = document.getElementById(id); // 그리드를 포함하는 div 객체
				gridRoot2 = gridApp2.getRoot(); // 데이터와 그리드를 포함하는 객체
	
				gridApp2.setLayout(layoutStr2.join("").toString());
	
				var selectionChangeHandler2 = function(event) {
					var rowIndex = event.rowIndex;
					var columnIndex = event.columnIndex;
					selectorColumn2 = gridRoot2.getObjectById("selector");
					fn_rowToInput_P(rowIndex);
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
				gridApp2.setData(lang_se_mgnt_list_p);
			}
		
		/**
		 * 그리드 loading bar on
		 */
		function showLoadingBar_p() {
			kora.common.showLoadingBar(dataGrid2, gridRoot2);

		}
		
		/**
		 * 그리드 loading bar off
		 */
		function hideLoadingBar_p() {
			kora.common.hideLoadingBar(dataGrid2, gridRoot2);
		}
	 /****************************************** 그리드 셋팅 끝***************************************** */
	</script>
<style type="text/css">
	.row .tit{width: 82px;}
</style>
	
	</head>
	<body>
		<div class="layer_popup" style="width:800px;">
		 	<input type="hidden" id="lang_se_mgnt_list_p" value="<c:out value='${lang_se_mgnt_list_p}' />" />
			<div class="layer_head">
				<h1 class="layer_title">언어구분관리</h1>
				<button type="button" class="layer_close" layer="close">팝업닫기</button>
			</div>
			<div class="layer_body">
				<div class="secwrap" id="divInput_P">
					<div class="srcharea">
						<div class="row">
							<div class="col">
								<div class="tit">언어구분코드</div>
								<div class="box">
									<input type="text" id="LANG_SE_CD_P"  format=engNum  maxlength="3" style="width: 179px; text-align: center;" class="i_notnull" >
								</div>
							</div>
							<div class="col">
								<div class="tit">언어구분명</div>
								<div class="box">
									<input type="text" id="LANG_SE_NM_P" maxlength="20"	style="width: 179px; text-align: center;" class="i_notnull" >
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col" style="width: 291px">
								<div class="tit">표시순서</div>
								<div class="box">
									<input type="text" id="SEL_ORD_P"	style="width: 179px; text-align: right;" format="number" maxByteLength="3"	class="i_notnull" >
								</div>
							</div>
							<div class="col">
								<div class="tit">사용여부</div>
								<div class="box">
									<select id="USE_YN_P" style="width: 179px" class="i_notnull">
										<option value="Y">사용</option>
										<option value="N">미사용</option>
									</select>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit">표준여부</div>
								<div class="box">
									<select id="STD_YN_P" style="width: 179px" class="i_notnull">
										<option value="N">비표준</option>
										<option value="Y">표준</option>
									</select>
								</div>
							</div>
						 <div class="btn" style="float:right" id="CR"></div>  
					 	<!-- <div class="btn">
								<button type="button" class="btn36 c4" style="width: 100px;" id="btn_init">초기화</button>
								<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">저장</button>
							</div>  -->
						</div>
					</div>
				</div>
				<div class="secwrap mt10">
					<div class="boxarea">
						<div id="gridHolder2" style="height: 370px; background: #FFF;">
						</div>
					</div>
				</div>
			</div>
	
	</div>
</body>
</html>