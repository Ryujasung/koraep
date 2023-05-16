<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환업무설정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">
  
	 var INQ_PARAMS;	//파라미터 데이터
     var toDay = kora.common.gfn_toDay();  // 현재 시간
     var initList_w;										//도매업자
	 var initList_m										//생산자
     $(function() {
    	 
    	INQ_PARAMS 	= jsonObject($("#INQ_PARAMS").val());	
    	initList_w 		= jsonObject($("#initList_w").val());		
    	initList_m		= jsonObject($("#initList_m").val());		
    	 //초기 셋팅
    	fn_init();
    	 
    	//버튼 셋팅
    	fn_btnSetting();
		
		/************************************
		 * 설정 저장버튼 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		/************************************
		 * 거래처 추가버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
	
	});
	  //거래처 추가 시 도매업자 다시 조회
     function fn_sel(){
    	var url = "/RT/EPRT9017301_19.do";     
 		var input = {}
    	ajaxPost(url, input, function(rtnData){
 			if(rtnData != null && rtnData != ""){
 				initList_w =  rtnData.initList_w;
 			}else{
 					alertMsg("error");
 			} 
    	 },false);
    	 fn_init();
     }
     
     //초기화
     function fn_init(){
    	$("#rtrvl_work_set_list").children().remove();  
    	var layoutTh = new Array();
    	layoutTh.push('<tr>');
    	layoutTh.push('	<th class="" >거래처구분</th>'); 
    	layoutTh.push('	<th class="" >거래처명</th>'); 
    	layoutTh.push('	<th class="" >사업자번호</th>'); 
    	layoutTh.push('	<th class="" >반환등록구분선택</th> ');
    	layoutTh.push('	<th class="" >수납방식선택</th>'); 
    	layoutTh.push('	<th class="" >생산자직접반환선택</th> ');
    	layoutTh.push('</tr>');
		$("#rtrvl_work_set_list").append(layoutTh.join("").toString());  
		
		$.each(initList_w, function(i, v){	//도매업자
			whsdl_table_set(v);
			//회수등록구분
			if(v.RTRVL_REG_SE =='M'){// 도매업자위임
				$("#"+v.WHSDL_BIZRID+"_1").prop('checked', true); 
			}else if(v.RTRVL_REG_SE =='P'){	//도매업자 대행
				$("#"+v.WHSDL_BIZRID+"_2").prop('checked', true); 
			}else{//D 직접등록
				$("#"+v.WHSDL_BIZRID+"_3").prop('checked', true); 
			}
			//직접지급구분
			if(v.DRCT_PAY_SE =='M'){// 도매업자위임
				$("#"+v.WHSDL_BIZRID+"_pay1").prop('checked', true); 
			}else if(v.DRCT_PAY_SE =='G'){	//보증금직접지급
				$("#"+v.WHSDL_BIZRID+"_pay2").prop('checked', true); 
			}else if(v.DRCT_PAY_SE =='F'){	//취급수수료직접지급
				$("#"+v.WHSDL_BIZRID+"_pay3").prop('checked', true); 
			}else{//R2 전체직접지급
				$("#"+v.WHSDL_BIZRID+"_pay4").prop('checked', true); 
			}
		},false);	
		$.each(initList_m, function(i, v){	  //생산자
			mfc_table_set(v);
			//직접반환구분
			if(v.DRCT_RTN_SE =='M'){// 생산자위임
				$("#"+v.MFC_BIZRID+"_1").prop('checked', true); 
			}else if(v.DRCT_RTN_SE =='P'){	//생산자대행
				$("#"+v.MFC_BIZRID+"_2").prop('checked', true); 
			}else if(v.DRCT_RTN_SE =='D'){	//직접반환 미사용
				$("#"+v.MFC_BIZRID+"_3").prop('checked', true); 
			}else{//R2 전체직접지급
				$("#"+v.MFC_BIZRID+"_4").prop('checked', true); 
			}
		},false);	
		window.frameElement.style.height = $('.iframe_inner').height()+'px'; //height 조정
    }
     
    //도매업자
    function whsdl_table_set(v){
    	var layoutTr = new Array();	
 		layoutTr.push('<tr>');
 		layoutTr.push('	<td>');
 		layoutTr.push('			<div class="txtbox" id="">'+v.BIZR_TP_NM+'</div>');//사업자유형
 		layoutTr.push('	</td>');
 		layoutTr.push('	<td>');
 		layoutTr.push('			<div class="txtbox" id="">'+v.WHSDL_BIZRNM+'</div>');//사업자명
 		layoutTr.push('	</td>');
 		layoutTr.push('	<td>');			
 		layoutTr.push('			<div class="txtbox" id="">'+kora.common.setDelim(v.WHSDL_BIZRNO_DE, "999-99-99999")+'</div>');//사업자코드
 		layoutTr.push('	</td>');
 		layoutTr.push('	<td>');																	//회수등록구분 
 		layoutTr.push('			<label class="rdo"><input type="radio" id="'+v.WHSDL_BIZRID+'_1" name="'+v.WHSDL_BIZRID_NO+'" value="M" ><span id="">도매업자 위임 등록</span></label></br>');   
 		layoutTr.push('			<label class="rdo"><input type="radio" id="'+v.WHSDL_BIZRID+'_2" name="'+v.WHSDL_BIZRID_NO+'" value="P" ><span id="">도매업자 대행 등록</span></label></br>');
 		layoutTr.push('			<label class="rdo"><input type="radio" id="'+v.WHSDL_BIZRID+'_3" name="'+v.WHSDL_BIZRID_NO+'" value="D"><span id="">직접 등록</span></label>');
 		layoutTr.push('	</td>');
 		layoutTr.push('	<td>');																	//직접지급구분
 		layoutTr.push('			<label class="rdo"><input type="radio" id="'+v.WHSDL_BIZRID+'_pay1" name="'+v.WHSDL_BIZRID_NO+'_pay" value="M" ><span id="">도매업자 위임 지급 </span></label></br>');
 		layoutTr.push('			<label class="rdo"><input type="radio" id="'+v.WHSDL_BIZRID+'_pay2" name="'+v.WHSDL_BIZRID_NO+'_pay" value="G" ><span id="">보증금만 직접 수납</span></label></br>');
 		layoutTr.push('			<label class="rdo"><input type="radio" id="'+v.WHSDL_BIZRID+'_pay3" name="'+v.WHSDL_BIZRID_NO+'_pay" value="F"><span id="">취급수수료만 직접 수납</span></label></br>');
 		layoutTr.push('			<label class="rdo"><input type="radio" id="'+v.WHSDL_BIZRID+'_pay4" name="'+v.WHSDL_BIZRID_NO+'_pay" value="A" ><span id="">전체 직접 수납</span></label>');
 		layoutTr.push('	</td>');
 		layoutTr.push('	<td>');
 		layoutTr.push('		<div class="row"></div>');
 		layoutTr.push('	</td>');
 		layoutTr.push('</tr>');
 		$("#rtrvl_work_set_list").append(layoutTr.join("").toString()); 
    }
     
   	//생산자
	function mfc_table_set(v){
	   var layoutTr = new Array();	
		layoutTr.push('<tr>');
		layoutTr.push('	<td>');
		layoutTr.push('			<div class="txtbox" id="">'+v.BIZR_TP_NM+'</div>');
		layoutTr.push('	</td>');
		layoutTr.push('	<td>');
		layoutTr.push('			<div class="txtbox" id="">'+v.MFC_BIZRNM+'</div>');
		layoutTr.push('	</td>');
		layoutTr.push('	<td>');					
		layoutTr.push('			<div class="txtbox" id="">'+kora.common.setDelim(v.MFC_BIZRNO_DE, "999-99-99999")+'</div>');
		layoutTr.push('	</td>');
		layoutTr.push('	<td></td>');
		layoutTr.push('	<td></td>');
		layoutTr.push('	<td>');
		layoutTr.push('		<label class="rdo"><input type="radio" id="'+v.MFC_BIZRID+'_1" name="'+v.MFC_BIZRID_NO+'" value="M" ><span id="">생산자 위임 등록</span></label></br>');
		layoutTr.push('		<label class="rdo"><input type="radio" id="'+v.MFC_BIZRID+'_2" name="'+v.MFC_BIZRID_NO+'" value="P" ><span id="">생산자 대행 등록</span></label></br>');
		layoutTr.push('		<label class="rdo"><input type="radio" id="'+v.MFC_BIZRID+'_3" name="'+v.MFC_BIZRID_NO+'" value="D" ><span id="">직접 등록</span></label></br>');
		layoutTr.push('		<label class="rdo"><input type="radio" id="'+v.MFC_BIZRID+'_4" name="'+v.MFC_BIZRID_NO+'" value="N"  checked="checked"><span id="">직접 반환 미사용</span></label></br>');
		layoutTr.push('	</td>');
		layoutTr.push('</tr>');
		$("#rtrvl_work_set_list").append(layoutTr.join("").toString());  
   	}  
      
   	//설정저장
	function fn_reg(){
		var url = "/RT/EPRT9017301_09.do";     
		var data = {"list": ""};
		var row = new Array();
		if(initList_w.length !=0){
				$.each(initList_w, function(i, v){	  //도매업자
					var input={};
					input["BIZR_TP_CD"]				="W"
					input["WHSDL_BRCH_ID"]		=v.WHSDL_BRCH_ID;
					input["WHSDL_BRCH_NO"]	=v.WHSDL_BRCH_NO;
					input["WHSDL_BIZRID"]			=v.WHSDL_BIZRID;
					input["WHSDL_BIZRNO"]		=v.WHSDL_BIZRNO;
					input["RTRVL_REG_SE"]			= $("input[type=radio][name='"+v.WHSDL_BIZRID_NO+"']:checked").val();		//회수등록구분
					input["DRCT_PAY_SE"]			= $("input[type=radio][name='"+v.WHSDL_BIZRID_NO+"_pay']:checked").val();//직접지급구분
					row.push(input);
				},false);
		}
		if(initList_m.length !=0){
				$.each(initList_m, function(i, v){	  //생산자
					var input={};
					input["BIZR_TP_CD"]			="M"
					input["MFC_BRCH_ID"]		=v.MFC_BRCH_ID;
					input["MFC_BRCH_NO"]	=v.MFC_BRCH_NO;
					input["MFC_BIZRID"]			=v.MFC_BIZRID;
					input["MFC_BIZRNO"]		=v.MFC_BIZRNO;
					input["DRCT_RTN_SE"]		= $("input[type=radio][name='"+v.MFC_BIZRID_NO+"']:checked").val(); 	//직접반환구분
					row.push(input);
				},false);
		}//end of if length
		
		data["list"] =JSON.stringify(row);
		console.log(data)
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG);
					}else{
						alertMsg(rtnData.RSLT_MSG);	
		 			}
			}else{
					alertMsg("error");
			}
		});//end of ajaxPost
		
   	}
   	
	//거래처추가
	function fn_page(){
		var pagedata = window.frameElement.name;
		var url = "/RT/EPRT9017331.do";		//거래처추가
		window.parent.NrvPub.AjaxPopup(url, pagedata);
   	}
	 
</script>

<style type="text/css">
.write_tbl table tr td{
     /* border-left: 1px solid rgb(195, 200, 209); */
     text-align: center;
}

.write_area  .rdo span {
    font-weight: 500;
    font-size: 13px;
 }
.write_tbl table tr td .rdo{
margin-left: 0px;
}

.txtbox{
text-align: center;
}
 .write_tbl table tr th{
 text-align: center;
 padding:0;
 }
 
 .write_area .rdo span{
   width: 130px;
   text-align: left;
 }

</style>

</head>
<body>
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="initList_w" value="<c:out value='${initList_w}' />" />  
			<input type="hidden" id="initList_m" value="<c:out value='${initList_m}' />" />  
			
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="singleRow">
				<div class="btn" id="UR"></div>
				</div>
				<!--btn_dwnd  -->
				<!--btn_excel  -->
			</div>
			<section class="secwrap">
				 <div class="write_area">
						<div class="write_tbl">
							<table>
								<colgroup>
										<col style="width: 10%;">
										<col style="width: 20%;">
										<col style="width: 10%;">
										<col style="width: 20%;">
										<col style="width: 20%;">
										<col style="width: auto;">
								</colgroup>
								<tbody id='rtrvl_work_set_list'>
								</tbody>
						</table>
					</div>
				</div>
		</section>
		<section class="btnwrap mt10" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
</div>

</body>
</html>