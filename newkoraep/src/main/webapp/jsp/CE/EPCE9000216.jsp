<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
		var searchDtl;
		
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			searchDtl = jsonObject($('#searchDtl').val());
			
			//fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#bizr_nm').text(parent.fn_text('bizr_nm'));
			$('#bizrno').text(parent.fn_text('bizrno'));
			$('#brch').text(parent.fn_text('brch'));
			$('#dept').text(parent.fn_text('dept'));
			$('#user_nm').text(parent.fn_text('user_nm'));
			$('#id').text(parent.fn_text('id'));
			$('#email').text(parent.fn_text('email'));
			$('#tel_no').text(parent.fn_text('tel_no'));
			$('#tel_no2').text(parent.fn_text('tel_no'));
			$('#mbil_tel_no').text(parent.fn_text('mbil_tel_no'));
			$('#use_ath').text(parent.fn_text('use_ath'));
			$('#user_stat').text(parent.fn_text('user_stat'));
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			/**
			 * 가입/변경요청 승인 버튼 클릭 이벤트
			 */
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			//가입요청 반송 버튼 클릭 이벤트
			$("#btn_upd3").click(function(){
				fn_upd3();
			});
			
			//목록
			$("#btn_page").click(function(){
				fn_page();
			});
			
			//정보삭제
			$("#btn_del").click(function(){
				fn_del();
			});
			
			//지급제외설정
			$("#btn_upd4").click(function(){
				fn_upd4();
			});
			
			/************************************
			 * 지역설정 클릭 이벤트
			 ***********************************/
			$("#btn_upd5").click(function(){
				fn_upd5();
			});
			
			$("#btn_cncl").click(function(){
				fn_cnl();
			});
			
			fnSetDtlData(searchDtl);
			
		});
		
		//지급제외설정
		function fn_upd4(){
			var input = {"list": ""};
			
			input["BIZRID"] = searchDtl.BIZRID;
			input["BIZRNO"] = searchDtl.BIZRNO;
			input["PAY_YN"] = searchDtl.PAY_YN;
			input["INQ_PARAMS"] = INQ_PARAMS.SEL_PARAMS;
			parent_item= input;
			var pagedata = window.frameElement.name;
			var url = "/CE/EPCE0160117.do";//단체설정
			window.parent.NrvPub.AjaxPopup(url, pagedata);
		}
		
		//지역설정
		function fn_upd5(){
			var input = {"list": ""};
			var row = new Array();
			
			var item = {};
			item.BIZRNM = INQ_PARAMS.PARAMS.BIZRNM;
			item.GRP_BRCH_NM = INQ_PARAMS.PARAMS.GRP_BRCH_NM;
			item.BRCH_NM = INQ_PARAMS.PARAMS.BRCH_NM;
			item.BRCH_NO = INQ_PARAMS.PARAMS.BRCH_NO;
			item.BRCH_ID = INQ_PARAMS.PARAMS.BRCH_ID;
			item.BIZRNO = INQ_PARAMS.PARAMS.BIZRNO;
			item.BIZRID = INQ_PARAMS.PARAMS.BIZRID;
			item.BIZRNO_DE = kora.common.setDelim(searchDtl.BIZRNO_DE,"999-99-99999");
			
			row.push(item);
			
		    input["list"] = row;
		    input["areaCnt"] = 1;
		    input["INQ_PARAMS"] = INQ_PARAMS.SEL_PARAMS;
		    parent_item= input;
			var pagedata = window.frameElement.name;
			var url = "/CE/EPCE0181088.do";//지역설정
				window.parent.NrvPub.AjaxPopup(url, pagedata);
		}
		
		//정보삭제
		function fn_del(){
			confirm("사업자정보를 삭제하시겠습니까? 삭제된 정보는 복구할 수 없습니다.", "fn_del_exec");
		}
		
		function fn_del_exec(){
			var input = {};
			input["BIZRID"] = searchDtl.BIZRID;
			input["BIZRNO"] = searchDtl.BIZRNO;
			input["BIZRNO_DE"] = searchDtl.BIZRNO_DE;
			input["FILE_NM"] = kora.common.null2void(searchDtl.FILE_NM);
			input["CTRT_FILE_NM"] = kora.common.null2void(searchDtl.CTRT_FILE_NM);
			
		 	var url = "/CE/EPCE0160116_04.do";
		 	ajaxPost(url, input, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_page'); 
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
		var altReqStatCd = '';
		//가입요청승인
		function fn_upd2(){
			
			if(searchDtl.ALT_REQ_STAT_CD == '0'){
				alertMsg("승인 대상이 아닙니다. 다시 한 번 확인하시기 바랍니다.");
				return;
			}
			
			altReqStatCd = '0';
			confirm("승인처리 하시겠습니까?","fn_upd_exec");
			
		}
		
		//가입요청반송
		function fn_upd3(){
			if(searchDtl.ALT_REQ_STAT_CD == '0'){
				alertMsg("반송대상이 아닙니다. 다시 한번 확인 하시기 바랍니다.");
				return;
			}
			
			altReqStatCd = '5';
			confirm("반송처리 하시겠습니까?", "fn_upd_exec");
		}
		
		function fn_upd_exec(){
			var input = {};
			input["BIZRID"] = searchDtl.BIZRID;
			input["BIZR_STAT_CD"] = searchDtl.BIZR_STAT_CD;
			input["BIZRNO"] = searchDtl.BIZRNO;
			input["BIZRNM"] = searchDtl.BIZRNM;
			input["ALT_REQ_STAT_CD"] = altReqStatCd;
			
		 	var url = "/CE/EPCE0160116_1.do";
		 	ajaxPost(url, input, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_page'); 
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
		//변경화면 이동
		function fn_upd(){
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000216.do";
			kora.common.goPage('/CE/EPCE9000242.do', INQ_PARAMS);
		}
		
		function fn_cnl(){		 
			//location.href = "/CE/EPCE9000201.do";		
			//kora.common.goPageB('', INQ_PARAMS);
			kora.common.goPage('/CE/EPCE9000201.do', INQ_PARAMS);
		}
		
		function fn_page(){
			kora.common.goPageB('', INQ_PARAMS);
		}

		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){
			
 			$("#RCS_NM").text(kora.common.null2void(data.RCS_NM));
			$("#RCS_BIZR_CD").text(kora.common.null2void(data.RCS_BIZR_CD));
			$("#URM_YN").text(kora.common.null2void(data.URM_YN));
			$("#WHSDL_BIZRNM").text(kora.common.null2void(data.WHSDL_BIZRNM));
			$("#WHSDL_BIZRNO").text(kora.common.null2void(data.WHSDL_BIZRNO));
			$("#ACP_BANK_CD").text(kora.common.null2void(data.ACP_BANK_CD));
			$("#ACP_ACCT_NO").text(kora.common.null2void(data.ACP_ACCT_NO));
			$("#AREA_CD").text(kora.common.null2void(data.AREA_CD));
			$("#PNO").text(kora.common.null2void(data.PNO));
			$("#ADDR").text(kora.common.null2void(data.ADDR));
			$("#START_END_DT").text(kora.common.null2void(data.START_END_DT));
			$("#MN_TEL").text(kora.common.null2void(data.MN_TEL));
			$("#MN_HTEL").text(kora.common.null2void(data.MN_HTEL));
			$("#LOC_GOV").text(kora.common.null2void(data.LOC_GOV));
			$("#LOC_NM").text(kora.common.null2void(data.LOC_NM));
			$("#LOC_TEL").text(kora.common.null2void(data.LOC_TEL));
			$("#LOC_HTEL").text(kora.common.null2void(data.LOC_HTEL));
			$("#LOC_EMAIL").text(kora.common.null2void(data.LOC_EMAIL));
			$("#FILE_NM").append("&nbsp;<a class='down' href='javascript:fn_dwnd(\""+kora.common.null2void(data.SAVE_FILE_NM)+"\", \""+kora.common.null2void(data.FILE_NM)+"\")'><span class='down_btn'></span>"+kora.common.null2void(data.FILE_NM)+"</a>");
			
			
		}
		
		 /**
		 * 상세조회
		 */
		function fn_sel(){
			var url = "/CE/EPCE0160116_19.do";
			
			ajaxPost(url, INQ_PARAMS.PARAMS, function(rtnData){
				if(rtnData != null && rtnData != ""){
					fnSetDtlData(rtnData.searchDtl);
				}else {
					alertMsg("error");
				}
			});
		}
		 
		//파일다운로드
		function fn_dwnd(fName, sName){ //fn_down
			frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
			frm.fileName.value = fName;
			frm.saveFileName.value = sName;
			frm.submit();
		}
		
	</script>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>



<div class="iframe_inner">
	<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
	</div>
	<section class="secwrap">
		<div class="write_area">
			<div class="write_tbl">
			<form name="frmMenu" id="frmMenu" method="post" >
				<table>
					<colgroup>
						<col style="width: 8%;height:50px">
						<col style="width: 15%;height:50px">
						<col style="width: auto;height:50px">
					</colgroup>
<!-- 					<tr> -->
<!-- 						<th colspan="2"><span id="bizr_stat_cd">상태</span></th> -->
<!-- 						<td> -->
<!-- 							<div class="row"> -->
<!-- 								<div class="txtbox" id="BIZR_STAT_CD"> -->
<!-- 								</div><p>/</p> -->
<!-- 								<div class="txtbox" id="BIZR_SE_CD"> -->
<!-- 								</div> -->
<!-- 							</div> -->
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th colspan="2" >반환수집소명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="RCS_NM"></div> &nbsp;   <!-- 도매업자 / 공병상 / 생산자 / 소매업자 -->
							</div>
						</td>
					</tr>
							<tr>
						<th colspan="2" >반환수집소상태</th>
						<td>
							<div class="row">
								<div class="txtbox" id="RCS_BIZR_CD"></div>&nbsp;
							</div>
						</td>
					</tr>
						<tr>
						<th colspan="2" >무인회수기여부</th>
						<td>
							<div class="row">
								<div class="txtbox" id="URM_YN"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >반환수집소 주소</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ADDR"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >지역</th>
						<td>
							<div class="row">
								<div class="txtbox" id="AREA_CD"></div>&nbsp;
							</div>
						</td>
					</tr>
			
					<tr>
						<th colspan="2" >관리업체</th>
						<td>
							<div class="row">
								<div class="txtbox" id="WHSDL_BIZRNM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >관리업체사업자번호</th>
						<td>
							<div class="row">
								<div class="txtbox" id="WHSDL_BIZRNO"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >관리업체계좌번호</th>
						<td>
							<div class="row">
								<div class="txtbox" id=ACP_BANK_CD></div>&nbsp;
								<div class="txtbox" id=ACP_ACCT_NO></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >계약서</th>
						<td>
							<!-- <div class="row">
								<div class="txtbox" id="FILE_NM"></div>&nbsp;
							</div> -->
							<div class="row" id="FILE_NM"></div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >계약(운영)기간</th>
						<td>
							<div class="row">
								<div class="txtbox" id="START_END_DT"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >업체 담당자명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="MN_TEL"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >업체 담당자 핸드폰</th>
						<td>
							<div class="row">
								<div class="txtbox" id="MN_HTEL"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >관리 지자체</th>
						<td>
							<div class="row">
								<div class="txtbox" id="LOC_GOV"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >지자체 담당자명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="LOC_NM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >지자체 담당자 연락처</th>
						<td>
							<div class="row">
								<div class="txtbox" id="LOC_TEL"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >지자체 담당자 핸드폰</th>
						<td>
							<div class="row">
								<div class="txtbox" id="LOC_HTEL"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" >담당자 이메일</th>
						<td>
							<div class="row">
								<div class="txtbox" id="LOC_EMAIL"></div>&nbsp;
							</div>
						</td>
					</tr>
				</table>
				</form>
			</div>
		</div>
	</section>
	<section class="btnwrap mt20" >
	<div class="btnwrap">
		<div class="fl_l" id="BL">
		</div>
		<div class="fl_r" id="BR">
				<button type="button" class="btn36 c4" style="width: 100px;" id="btn_cncl">목록</button> 
 				<button type="button" class="btn36 c2" style="width: 100px;" id="btn_upd">정보변경</button>
		</div>
	</div>
	</section>
	</div>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="bizlic" />
	</form>
	
</body>
</html>