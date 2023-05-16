<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고정정등록 (일괄등록)</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS; 	//파라미터 데이터
	 var mfc_bizrnmList;	//생산자
	 var mfc_chk = {};
	 var doc_arr = new Array();
	 
     $(function() {
    
    	 INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	
    	 mfc_bizrnmList	=  jsonObject($("#mfc_bizrnmList").val());     
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
			
		 fn_init();
	
		/************************************
		 *등록 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		/************************************
		 * 취소 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
		/************************************
		 * 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del();
		});
		
		/************************************
		 * 양식다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_dwnd").click(function(){
			fn_excelDown();
		});
		
		/************************************
		 * 엑셀등록 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel_reg").click(function(){
			if( $("#MFC_BIZRNM").val()==""){
				alertMsg("생산자를 선택 해주세요");
				return;
			}else{
				$("#MFC_BIZRNM").prop("disabled",true);
				mfc_chk[0] =$("#MFC_BIZRNM").val();
				kora.common.gfn_excelUploadPop("fn_popExcel");
			}
		});
	
	});
   
    function  fn_init(){
    	//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');						 					//타이틀
		$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));					//생산자
		
		//데이터 넣기
		kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" );					//생산자
    }
	
 	 //삭제
	function fn_del(){
		 
		var idx = dataGrid.getSelectedIndex();
		 
		if(idx < 0) {
			alertMsg("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		gridRoot.removeItemAt(idx);
 		 
  	}
    
	//등록
	function fn_reg(){
		 
		var collection = gridRoot.getCollection();
		if(collection.getLength() < 1){
			alertMsg("데이터가 없습니다.");
			return;
		}
		
		var data = {"list": ""};
		var row = new Array();
		var url = "/MF/EPMF47387312_09.do"

		/*
		 * 20180823, 이근표 : 사업관리팀 곽명진팀장 요청
		for(var i =0;i <doc_arr.length ;i++){
			if(doc_arr[i].CRCT_QTY != doc_arr[i].CFM_QTY_TOT ){// 문서의 총 입고확인량이랑 정정총확인량이랑 다를경우 
				alertMsg(doc_arr[i].WRHS_DOC_NO +" 입고문서번호의 입고확인량 합계와 정정확인량 합계가 다른 경우 일괄 등록이 불가능합니다. \n\n다시 한 번 확인해 주시기 바랍니다.");
				return;
			}
		}
        */
        
		for(var i=0;i<collection.getLength(); i++){
	 		var tmpData 	= gridRoot.getItemAt(i);
 			for(var k =0; k< doc_arr.length ;k++){
 				if(tmpData.WRHS_DOC_NO == doc_arr[k].WRHS_DOC_NO){
 				   tmpData.CRCT_TOT	=doc_arr[k].CRCT_QTY;	//총데이터 넣기  나중에 service list2에서  수량 체크때문에 
 					break;
 				}
 			}
	 		row.push(tmpData);//행 데이터 넣기
		}
	 	
	 	data["list"] = JSON.stringify(row);

		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					} else{
						alertMsg(rtnData.RSLT_MSG);
					}
			}else{
					alertMsg("error");
			}
		},false); 

	}
    
     //취소
  	function fn_cnl(){
  		kora.common.goPageB('', INQ_PARAMS);
     }
     
  //양식다운로드
    function fn_excelDown() {
    	downForm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
    	downForm.submit();
    };
    
    /**
     * 엑셀 업로드 후처리
     */
    function fn_popExcel(rtnData) {
    	
    	gridRoot.removeAll();
    	var input  	= {};
    	var ctnrCd 	= "";
    	var url 		= "/MF/EPMF47387312_19.do";
    	var flag 		= false;
    	var dup_cnt 		= 0;		//동일한 용기코드 + 생산자 + 지사가 있을경우
	   	var err_cnt 			= 0;		//잘못된 데이터로 디비 정보가 없을 경우
	   	var err_msg="";				//중복 오류메세지	
	   	var err_msg2="";				//디비정보 없는 오류메세지
	   	var arr3 =new Array();		//중복된 도매업자 용기코드
	   	var arr4 =new Array();		//정보가 없는 도매업자 용기코드
	   	var collection = gridRoot.getCollection();
	   	
	   	doc_arr	= new Array();
		arr			= new Array();
		arr 		= $("#MFC_BIZRNM").val().split(";"); 
		
		//리턴받은 엑셀 데이터
   		for(var i=0; i<rtnData.length ;i++) {	
		   		if(	rtnData[i].입고문서번호 =="" ||
		   			rtnData[i].도매업자사업자번호 =="" ||	
		   			rtnData[i].입고빈용기코드 =="" ||
		   			rtnData[i].정정빈용기코드 =="" ||
		   			rtnData[i].정정확인량 =="" ){
		   			alertMsg("필수입력값이 없습니다.")
		   			return;
		   		 }
   		 }
   		// 엑셀 row 수많큼 조회
    	for(var i=0; i<rtnData.length ;i++) {
    		 
	    		flag= false
	    		input["MFC_BIZRID"]			=	arr[0];														//생산자 아이디
	    		input["MFC_BIZRNO"]		=	arr[1];														//생산자 사업자 번호
	    		input["WRHS_DOC_NO"]	=	rtnData[i].입고문서번호					
	    		input["WHSDL_BIZRNO"]	=	rtnData[i].도매업자사업자번호			
	    		input["CTNR_CD"]				=	rtnData[i].입고빈용기코드				
	    		input["CRCT_CTNR_CD"]	=	rtnData[i].정정빈용기코드						
	    		input["CRCT_QTY"]			=	rtnData[i].정정확인량						
	    		input["EXCA_STD_CD"]		=	INQ_PARAMS.EXCA_PARAM.EXCA_STD_CD	//정산기준코드
				
	    		ajaxPost(url, input, function(rtnData) {
		   				if ("" != rtnData && null != rtnData) {   
			    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
			    							var collection = gridRoot.getCollection();  //그리드 데이터
										    for(var i=0; i<collection.getLength(); i++) {
										    	var tmpData = gridRoot.getItemAt(i);
										    	if(tmpData["CRCT_CTNR_CD"] == rtnData.selList[0].CRCT_CTNR_CD // 쿼리상 데이터는 있지만 동일한용기코드가 있을경우.
										    			&&  tmpData["WRHS_DOC_NO"] == rtnData.selList[0].WRHS_DOC_NO  ) {
										    			flag =true;
										    			arr3[dup_cnt] = input["WRHS_DOC_NO"]+" ," +input["CTNR_CD"]+" ,"+input["CRCT_QTY"];
										    			dup_cnt++;
										    			break;
												}
										    }	//end of for(var i=0; i<gridData.length)
											if(!flag)gridRoot.addItemAt(rtnData.selList[0]);	
			    					}else{// 쿼리상 데이터가 없을경우
			    						arr4[err_cnt] = input["WRHS_DOC_NO"]+" ," +input["CTNR_CD"]+" ,"+input["CRCT_QTY"];
			    						err_cnt++;
			    					}
		   				}else{
								alertMsg("error");
		   				}
	   			},false);  
    	}//end of for(var i=0; i<rtnData.length ;i++) 
    	 
    	err_msg 		= 	dup_cnt+" 개의 동일한 정보를 제외하고 등록 하였습니다. \n";
    	err_msg2 	=	err_cnt+" 개의 확인되지 않은 정보가 등록 제외되었습니다.\n";
    
	    if(dup_cnt >0 && err_cnt >0){
	     		alertMsg(err_msg+"\n"+err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다.");
	    }else if(dup_cnt >0){
	        	alertMsg(err_msg+"\n등록 정보를 다시 확인해주시기 바랍니다.");
    	}else if(err_cnt >0){
    			alertMsg(err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다." );
    	}
	    
	    //문서별 입고확인수량   정정확인수량  체크 
	    for(var i=0;i<collection.getLength(); i++){
	 		var tmpData 	= gridRoot.getItemAt(i);
	 		var cnt =0;
 			if(doc_arr.length ==0){	//첫번째 데이터는 무족건 배열에 넣는다.
 				var input ={};
 				input["WRHS_DOC_NO"] 	=	tmpData.WRHS_DOC_NO;
 				input["CRCT_QTY"] 			=	tmpData.CRCT_QTY;
 				input["CFM_QTY_TOT"]		= 	tmpData.CFM_QTY_TOT;
 				doc_arr.push(input);
 			}else{
 				for(var k =0 ;k< doc_arr.length ;k++ ){
		 			if(doc_arr[k].WRHS_DOC_NO !=tmpData.WRHS_DOC_NO ){
						cnt++;	//arr에 등록되어있는 문서번호가 없을경우  		 				
		 			}else{
		 				//같은 문서번호인경우 arr정정확인량 update
		 				doc_arr[k].CRCT_QTY=	Number(doc_arr[k].CRCT_QTY) + Number(tmpData.CRCT_QTY); 
		 			}
		 		}
 			}
 			if(cnt ==doc_arr.length ){// 만약 arr랑 cnt랑 같을수가 같을경우 같은 문서번호가 없으니 arr 새로운 문서번호 push
				var input ={};
 				input["WRHS_DOC_NO"] 	=	tmpData.WRHS_DOC_NO;
 				input["CRCT_QTY"] 			=	tmpData.CRCT_QTY;
 				input["CFM_QTY_TOT"]		= 	tmpData.CFM_QTY_TOT;
 				doc_arr.push(input);
			}
	 	}//end of for(var i=0;i<collection.getLength(); i++)
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"  horizontalScrollPolicy="on"  headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridSelectorColumn id="selector"	 		 width="40"	textAlign="center" allowMultipleSelection="true" vertical-align="middle" draggable="false"   />');													//선택 
			layoutStr.push('			<DataGridColumn dataField="index" 				 				headerText="'+ parent.fn_text('sn')+ '" 				width="50"    textAlign="center"  draggable="false" itemRenderer="IndexNoItem"  />');//순번
			layoutStr.push('			<DataGridColumn dataField="WRHS_DOC_NO" 				headerText="'+ parent.fn_text('wrhs_doc_no')+ '"	width="150"  textAlign="center"   />');											//입고문서번호
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM"			 		headerText="'+ parent.fn_text('whsdl')+ '"  			width="130"  textAlign="center"  />'); 											//도매업자명
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO_DE" 				headerText="'+parent.fn_text('bizrno')+ '"  			width="110"  formatter="{maskfmt1}" textAlign="center" />');			//도매업자 사업자 번호
			layoutStr.push('			<DataGridColumnGroup  												headerText="'+ parent.fn_text('reg_info')+ '">');																															//등록정보
			layoutStr.push('				<DataGridColumn dataField="CTNR_NM" 					headerText="'+ parent.fn_text('ctnr_nm')+ '"		width="250"	 textAlign="left" />');													//빈용기명
			layoutStr.push('				<DataGridColumn dataField="CTNR_CD" 					headerText="'+ parent.fn_text('cd')+ '" 			width="80"		 textAlign="center" />');													//빈용기코드
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  												headerText="'+ parent.fn_text('crct_reg')+ '">');																															//등록정보
			layoutStr.push('				<DataGridColumn dataField="CRCT_CTNR_NM" 			headerText="'+ parent.fn_text('ctnr_nm')+ '"		width="250"	textAlign="left" />');													//빈용기명
			layoutStr.push('				<DataGridColumn dataField="CRCT_CTNR_CD" 			headerText="'+ parent.fn_text('cd')+ '"	 			width="80"	 	textAlign="center" />');													//빈용기코드
			layoutStr.push('				<DataGridColumn dataField="CRCT_QTY" 					headerText="'+ parent.fn_text('wrhs_qty')+ '"	width="80" 	formatter="{numfmt}" id="num8"   textAlign="right" />');	//입고량
			layoutStr.push('				<DataGridColumn dataField="CRCT_GTN" 		  			headerText="'+ parent.fn_text('dps2')+ '" 		width="110" 	formatter="{numfmt}" id="num9" 	textAlign="right" />');	//보증금
			layoutStr.push('				<DataGridColumn dataField="CRCT_WHSL_FEE" 			headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="110" 	formatter="{numfmt1}" id="num10" textAlign="right" />');//도매수수료
			layoutStr.push('				<DataGridColumn dataField="CRCT_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 	 	width="110" 	formatter="{numfmt1}" id="num12" textAlign="right" />');//소매수수료
			layoutStr.push('				<DataGridColumn dataField="CRCT_WHSL_FEE_STAX" 	headerText="'+ parent.fn_text('stax')+ '"	width="110" 	formatter="{numfmt}" id="num11" textAlign="right" />');	//도매부가세
			layoutStr.push('				<DataGridColumn dataField="CRCT_AMT" 	 				headerText="'+ parent.fn_text('amt')+ '" 			width="100" 	formatter="{numfmt}" id="num14" textAlign="right" />');	//금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>'); 
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt1}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num12}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num11}" formatter="{numfmt1}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num14}" formatter="{numfmt}" textAlign="right"/>');	
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
		gridApp.setData();
		
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

.srcharea .row .col{
width: 31%;
} 
.srcharea .row .col .tit{
width: 81px;
}

</style>

</head>
<body>

    <div class="iframe_inner" id="testee" >
    	 	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="singleRow">
				<div class="btn" id="UR"></div>
				</div>
			</div>
		<section class="secwrap" >
				<div class="srcharea"  id="divInput" > 
					<div class="row">
						<div class="col">
							<div class="tit" id="mfc_bizrnm"></div>  <!--생산자-->
							<div class="box">
								<select id="MFC_BIZRNM" style="width: 250px" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
				</div>  <!-- end of srcharea -->
		</section>	
			
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 650px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap mt10" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
</div>

<form name="downForm" id="downForm"  method="post">
	<input type="hidden" name="fileName" value="WRHS_CRCT_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>
</body>
</html>