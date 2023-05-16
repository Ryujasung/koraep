<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환정보수정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
     var toDay = kora.common.gfn_toDay();  // 현재 시간
     var dps_fee_list;									// 회수용기 보증금,취급수수료
     var initList;
     var ctnr_list_set_cnt =0;
     var ctnr_input ={};
     $(function() {
    	 
    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());	
    	initList 				= jsonObject($("#initList").val());		
    	rtc_dt_list 			= jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	

    	 //초기 셋팅
    	fn_init();
    	 
    	//버튼 셋팅
    	fn_btnSetting();
		 
		//날짜 셋팅
  	    $('#RTRVL_DT').YJcalendar({  
 			triggerBtn : true,
 			dateSetting: toDay.replaceAll('-','')
 		});
		
		/************************************
		 * 삭제  변경 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
		});
		
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT").click(function(){
			    var rtn_dt = $("#RTRVL_DT").val();
			    rtn_dt   =  rtn_dt.replace(/-/gi, "");
			    $("#RTRVL_DT").val(rtn_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT").change(function(){
		     var dt = $("#RTRVL_DT").val();
		     dt   =  dt.replace(/-/gi, "");
			 if(dt.length == 8)  dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
	     	 $("#RTRVL_DT").val(dt) 
	     	 if($("#RTRVL_DT").val() !=flag_DT){ 		//클릭시 날짜 변경 할경우   기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
			     	flag_DT = $("#RTRVL_DT").val();  	//변경시 날짜 
			     	fn_rtrvl_dt();
	   		  } 
		});
		
		/************************************
		 * 등록 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		/************************************
		 * 취소버튼 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
		$("#CTNR_SE").change(function(){
			var ck = $("input[type=radio][name=select_ctnr]:checked").val();
			$("#RTRVL_CTNR_CD_LIST").find(".inqChk").each(function(){
				if(kora.common.null2void($(this).val()) != "" &&kora.common.null2void($(this).val()) != "0" ){
					var ctnrId =$(this).attr('id');
					ctnr_input[ctnrId] 		=$("#"+ctnrId).val();
				}
			});
			$("#RTRVL_CTNR_CD_LIST").children().remove();  
			for(var i=0; i<dps_fee_list.length; i++){
				if(ck=='gu'){
					if(dps_fee_list[i].RTRVL_CTNR_CD.substr(1,1) !="3"){  
						ctnr_list_set(dps_fee_list[i]);
						$("#"+dps_fee_list[i].RTRVL_CTNR_CD).val(ctnr_input[dps_fee_list[i].RTRVL_CTNR_CD]);
					}
				}else{
					if(dps_fee_list[i].RTRVL_CTNR_CD.substr(1,1) =="3"){
						ctnr_list_set(dps_fee_list[i]);
						$("#"+dps_fee_list[i].RTRVL_CTNR_CD).val(ctnr_input[dps_fee_list[i].RTRVL_CTNR_CD]);
					}
				}
			}
			ctnr_list_set_cnt=0;
			window.frameElement.style.height = $('.iframe_inner').height()+'px'; //height 조정
		});
	
	});
     
     //초기화
     function fn_init(){
    	 
			$("#WHSDL_BIZRNM").text(initList[0].WHSDL_BIZRNM);
			$("#RTRVL_STAT_NM").text(initList[0].RTRVL_STAT_NM);
			$("#WHSDL_BIZRNO").text(kora.common.setDelim(initList[0].WHSDL_BIZRNO_DE, "999-99-99999"));
			$('#RTRVL_DT').val(kora.common.formatter.datetime(initList[0].RTRVL_DT, "yyyy-mm-dd")); 
			flag_DT = $("#RTRVL_DT").val(); 
			fn_rtrvl_dt();
			$('#title_sub').text('<c:out value="${titleSub}" />');		//타이틀
			$('#rtrvl_dt2').text(parent.fn_text('rtrvl_dt2'));				//조회기간
			$('#whsdl').text(parent.fn_text('whsdl'));					  	//도매업자
			$('#whsdl_bizrno').text(parent.fn_text('whsdl_bizrno'));	//도매업자사업자번호
			
			//div필수값 alt
			$("#RTRVL_DT").attr('alt',parent.fn_text('rtrvl_dt2'));		//회수일자
			$("#RTRVL_QTY").attr('alt',parent.fn_text('rtrvl_qty2'));	//회수량
			
			if(initList[0].CTNR_SE =="3"){
				$("#select_ctnr_se2").prop('checked', true); 
				$.each(dps_fee_list, function(i, v){	
					if(v.RTRVL_CTNR_CD.substr(1,1) =="3"){
						ctnr_list_set(v)
						for(var k=0; k<initList.length;k++){
							if(v.RTRVL_CTNR_CD == initList[k].RTRVL_CTNR_CD){
								$("#"+v.RTRVL_CTNR_CD).val( initList[k].RTRVL_QTY );
								break;
							}
						}//end of for
					}//end of if(v.RTRVL_CTNR_CD.substr(1,1) =="3")
				});
			}else{
				$("#select_ctnr_se1").prop('checked', true);   
				$.each(dps_fee_list, function(i, v){	
					if(v.RTRVL_CTNR_CD.substr(1,1) !="3"){
						ctnr_list_set(v)
						for(var k=0; k<initList.length;k++){
							if(v.RTRVL_CTNR_CD == initList[k].RTRVL_CTNR_CD){
								$("#"+v.RTRVL_CTNR_CD).val( initList[k].RTRVL_QTY );
								break;
							}
						}//end of for
					}//end of if(v.RTRVL_CTNR_CD.substr(1,1) !="3")
				});
			}     
			ctnr_list_set_cnt=0;
     }
   
     function ctnr_list_set(v){
    	 	var layoutTr = new Array();	
    	 	if(ctnr_list_set_cnt ==0){
    	 		layoutTr.push('<tr>'); 
    		 	layoutTr.push('	 	<th class="bd_l" >빈용기명(소매)</th>');   
    		 	layoutTr.push('		<th class="bd_l" style="padding: 0 0 0 0px;">반환량</th>');  
    		 	layoutTr.push('</tr>'); 
    	 	}
			layoutTr.push('<tr>'); 
			layoutTr.push('<th class="bd_l">'+v.CTNR_NM+'</th> '); 
			layoutTr.push('	<td>');
			layoutTr.push('		<div class="row" style="border-left: 1px solid rgb(195, 200, 209);">');
			layoutTr.push('			<input type="text" id="'+v.RTRVL_CTNR_CD+'" style="width:100%; text-align:right" format="number" class="inqChk"  alt="'+v.CTNR_NM+'"/>');   
			layoutTr.push('		</div>');
			layoutTr.push('</td>');
			layoutTr.push('</tr>'); 
			$("#RTRVL_CTNR_CD_LIST").append(layoutTr.join("").toString());  
			ctnr_list_set_cnt++;
     }
 
	//회수일자 변경시
	function fn_rtrvl_dt(){
		var url = "/RT/EPRT9025831_192.do"; 
		var input ={};
		input["RTRVL_DT"] = $("#RTRVL_DT").val();
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					dps_fee_list = rtnData.dps_fee_list;
   					kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
   				}else{
					alertMsg("error");
   				}
   		},false);
   }
	
	//도매업자 선택 변경시  
    function fn_whsdl_bizrnm(){
 			if($("#WHSDL_BIZRNM").val() !=""){
 					for(var i=0 ; i <whsdl_cd_list.length ;i++){
							if(whsdl_cd_list[i].WHSDL_BIZRID_NO == $("#WHSDL_BIZRNM").val()  ){  
								$("#WHSDL_BIZRNO").text(kora.common.setDelim(whsdl_cd_list[i].WHSDL_BIZRNO_DE, "999-99-99999"));
								break;
							}
						}
 			}else{
 					$("#WHSDL_BIZRNO").text("");
 			}
    }
	
	
	//등록
	function fn_reg(){
		 
		var url = "/RT/EPRT9025842_09.do"; 
		var data = {"list": ""};
		var row = new Array();
		
		if(!kora.common.fn_validDate($("#RTRVL_DT").val())){  
			alertMsg("올바른 날짜 형식이 아닙니다.");
			return;
		}else if(!kora.common.cfrmDivChkValid("RTRVL_CTNR_CD_LIST")) {
			return;
		}else if(!kora.common.fn_validDate_ck( "U", $("#RTRVL_DT").val(),initList[0].REG_DTTM_STD)){ //등록일자제한 체크
			return;
		}
		var nChk = 0;
		var validch=0;
		$("#RTRVL_CTNR_CD_LIST").find(".inqChk").each(function(){//빈용기중 입력되어있는것들만 조회
			
			if(kora.common.null2void($(this).val()) != ""&&kora.common.null2void($(this).val()) != "0" ){
				var ctnrId =$(this).attr('id');
				var input={};
				var arr= new Array();
				input["RTRVL_DOC_NO"]	=initList[0].RTRVL_DOC_NO;
				input["WHSDL_BIZRID"]		=initList[0].WHSDL_BIZRID;
				input["WHSDL_BIZRNO"]	=initList[0].WHSDL_BIZRNO;
				input["WHSDL_BRCH_ID"]	=initList[0].WHSDL_BRCH_ID;
				input["WHSDL_BRCH_NO"]=initList[0].WHSDL_BRCH_NO;
				input["RTRVL_STAT_CD"]	=initList[0].RTRVL_STAT_CD;   
				input["RTRVL_DT"] 			=	$("#RTRVL_DT").val();	
				input["REG_DTTM_STD"]	= initList[0].REG_DTTM_STD; 									//등록일자제한  수정시 등록일자 기준으로 `체크
				
				input["RTRVL_CTNR_CD"] 	=ctnrId;
				input["RTRVL_QTY"] 			=$("#"+ctnrId).val();
				for(var i=0; i<dps_fee_list.length; i++){
					if(dps_fee_list[i].RTRVL_CTNR_CD == ctnrId) {
						input["CTNR_NM"] 					=dps_fee_list[i].CTNR_NM;
						input["RTRVL_GTN"] 				=input["RTRVL_QTY"] * dps_fee_list[i].RTRVL_DPS; 
						input["REG_RTRVL_FEE"] 			=input["RTRVL_QTY"] *dps_fee_list[i].RTRVL_FEE;
						input["RTRVL_RTL_FEE"] 			=input["RTRVL_QTY"] *dps_fee_list[i].RTRVL_FEE;
						break;	
					}  
				}
				row.push(input);
			}else{
				validch++;
			}
				nChk++;
		});
		if(validch ==nChk ){
			alertMsg("한개 이상은 입력");
			return; 
		}
		data["list"] =JSON.stringify(row);
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="A003"){ // 중복일경우
						alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
					}else if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG);
						fn_cnl();
					}else{
						alertMsg(rtnData.RSLT_MSG);	
		 			}
			}else{
					alertMsg("error");
			}
		});//end of ajaxPost
	}
	
	function fn_del_chk(){
		if(initList[0].RTRVL_STAT_CD !="RG"){
			alertMsg("도매업자가 등록한 반환내역은 삭제할 수 없습니다");
			return;
		}else{
		confirm("선택하신 내역을 삭제 처리 하시겠습니까?","fn_del");
		} 
	}
	function fn_del(){
		var url = "/RT/EPRT9025842_04.do"; 
		var input ={};
		input["RTRVL_DOC_NO"]	=initList[0].RTRVL_DOC_NO;
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG);
						fn_cnl();
					}else{
						alertMsg(rtnData.RSLT_MSG);	
		 			}
			}else{
					alertMsg("error");
			}
		});//end of ajaxPost
	}
	
	 //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/RT/EPRT9025801.do', INQ_PARAMS);
    }
	
	
</script>

<style type="text/css">
 
#RTRVL_CTNR_CD_LIST  th {
text-align: center;
}
</style>


</head>
<body>
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="initList" value="<c:out value='${initList}' />" />
			 <input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
	
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
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
										<col style="width: 14%;">
										<col style="width: 25%;">
										<col style="width: 10%;">
										<col style="width: auto;">
									</colgroup>
								<tbody>
									 <tr>
									 	<th class="bd_l" id="rtrvl_dt2"></th><!--  조회기간 -->
										<td>
											<div class="row" style="overflow: visible;"> 
												<div class="box">
													<div class="calendar">
														<input type="text" id="RTRVL_DT"  style="width: 180px; margin-bottom: 7px;" class="i_notnull" /> <!-- 시작날짜  -->
													</div>
												</div>
											</div>  
										</td>
										<th class="bd_l" >빈용기구분</th> 
										<td>
											<div class="row">
												<div class="box" id="CTNR_SE" style="width:179px">
														<label class="rdo"><input type="radio" id="select_ctnr_se1" name="select_ctnr" value="gu" ><span id="">구병</span></label>
														<label class="rdo"><input type="radio" id="select_ctnr_se2" name="select_ctnr" value="sin"  checked="checked"><span id="">신병</span></label>
												</div>
											</div>
										</td> 
										<th class="bd_l" >등록구분</th> 
										<td>
											<div class="row">
												<div class="row">
													<div class="txtbox" id="RTRVL_STAT_NM"></div>
												</div>
											</div>
										</td>
									</tr>
									 <tr>
									 		<th class="bd_l" id="whsdl"></th> <!-- 도매업자업체명		 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_BIZRNM"></div>
												</div>
											</td>
											<th class="bd_l" id="whsdl_bizrno"></th><!--  도매업자 사업자번호 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_BIZRNO"></div>
												</div>
											</td>
									 </tr>
								</tbody>
							</table>
						</div>
					</div>
			</section>
			<section class="secwrap mt10" style='width:80%'>
					 <div class="write_area">
							<div class="write_tbl">
								<table>
									<colgroup>
										<col style="width: 70%;">
										<col style="width: 30%;">
									</colgroup>
								<tbody id='RTRVL_CTNR_CD_LIST''>
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