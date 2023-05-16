<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
	  var INQ_PARAMS;	
	  var toDay = kora.common.gfn_toDay();  // 현재 시간
	    var searchDtl;
	     
	  $(document).ready(function(){
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		  searchDtl = jsonObject($('#searchDtl').val());
		fn_btnSetting();
		  fnSetDtlData(searchDtl);
		  $('#drct_input').text(parent.fn_text('drct_input'));
		  kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
		  fn_init(); 
		  
		  var area_cd_list 		= jsonObject($('#area_cd_list').val());
		kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//지역
		$('#title_sub').text('<c:out value="무인회수기정보변경" />');

		$('#START_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true,
			/* dateSetting : toDay.replaceAll('-','') */
		});

		//저장
		$("#btn_reg").click(function(){
			fn_reg();
		});
  
		//취소
		$("#btn_cncl").click(function(){
			fn_cnl();
		});
		/**
		 * 이메일 도메인 변경 이벤트
		 */
		$("#DOMAIN").change(function(){
			
			$("#DOMAIN_TXT").val(kora.common.null2void($(this).val()));
			
			if(kora.common.null2void($(this).val()) != "") 
				$("#DOMAIN_TXT").attr("disabled",true);
			else
				$("#DOMAIN_TXT").attr("disabled",false);
		});

		/**
		 * 우편번호검색 버튼 클릭 이벤트
		 */
		 var parent_item;
		$("#btnPopZip").click(function(){
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/SEARCH_ZIPCODE_POP.do', pagedata);
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
        $("#URM_DE_DT").change(function(){
            var start_dt = $("#URM_DE_DT").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
            $("#URM_DE_DT").val(start_dt) 
        });
        
        /************************************
         * 시작날짜  클릭시 - 추가 변경 이벤트
         ***********************************/
        $("#START_DT4").change(function(){
            var start_dt = $("#START_DT4").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
            $("#START_DT4").val(start_dt) 
        });
        
        /************************************
         * 시작날짜  클릭시 - 추가 변경 이벤트
         ***********************************/
        $("#URM_USE_DT").change(function(){
            var start_dt = $("#URM_USE_DT").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
           
            var urmde_dt = $("#URM_DE_DT").val();
            urmde_dt = urmde_dt.replace(/-/gi, "");
            if(urmde_dt.length == 8)  urmde_dt = kora.common.getDate("yyyy-mm-dd", "D", +364, start_dt)
            console.log(urmde_dt);
            $("#URM_USE_DT").val(start_dt) 
            $("#URM_DE_DT").val(urmde_dt) 
        });
	});

		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){
			 var email = kora.common.null2void(data.EMAIL).split("@");
				$("#EMAIL_TXT").val(email[0]);
				$("#DOMAIN_TXT").val(email[1]);
		
		
			 $("#URM_NM").val(kora.common.null2void(data.URM_NM));
			 $("#URM_NO").val(kora.common.null2void(data.URM_NO));
				$("#SERIAL_NO").val(kora.common.null2void(data.SERIAL_NO));
				//$("#AreaCdList_SEL").val(data.AREA_CD).prop("selected",true);
				$("#START_DT").val(kora.common.null2void(data.START_DT));
				$("#END_DT").val(kora.common.null2void(data.END_DT));
				$("#PNO").val(data.PNO);
				$("#ADDR1").val(data.ADDR1);
				$("#ADDR2").val(data.ADDR2);
				$("#TELNO").val(kora.common.null2void(data.TELNO));
				$('#URM_TYPE').val(data.URM_TYPE).prop("selected",true);
				$("#URM_CE_NO").val(kora.common.null2void(data.URM_CE_NO));
				$("#URM_USE_DT").val(kora.common.null2void(data.URM_USE_DT));
				$("#URM_DE_DT").val(kora.common.null2void(data.URM_DE_DT));
				$("#USE_TOT").val(kora.common.null2void(data.USE_TOT));
				var useYN = data.USE_YN;
				if(useYN == '사용중'){
					useYN = 'Y';
				}else{
					useYN = 'N';
				}
				$('#USE_YN').val(useYN).prop("selected",true);

		}
	
		//저장
		function fn_reg(){
			
			//이메일 유효성 체크
			var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
			var emailAddr = $.trim($("#EMAIL_TXT").val()) +"@"+ $.trim($("#DOMAIN_TXT").val());
			if (!emailAddr.match(regExp)){
				alertMsg("이메일 형식에 맞지 않습니다.");
				return false;
			} 
			 
			 
			 if(kora.common.format_noComma(kora.common.null2void($("#TELNO").val(),0))  < 1) {
		            alertMsg("담당자 연락처을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#TELNO");           
		            return;
		        }
			 
			 if(kora.common.format_noComma(kora.common.null2void($("#EMAIL_TXT").val(),0))  < 1) {
		            alertMsg("E-MAIL을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#EMAIL_TXT");           
		            return;
		        }

		    
		
			confirm('저장하시겠습니까?', 'fn_reg_exec');
		}

		//셋팅
	    function fn_init(){
	         
	        //날짜 셋팅
	        $('#START_DT').YJcalendar({  
	            toName : 'from',
	            triggerBtn : true,
	            //dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
	        });
	        
	        $('#URM_DE_DT').YJcalendar({  
	            toName : '',
	            triggerBtn : true,
	            //dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
	        });
	        
	        $('#START_DT4').YJcalendar({  
	            toName : '',
	            triggerBtn : true,
	           // dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
	        });
	        
	        $('#URM_USE_DT').YJcalendar({  
	            toName : '',
	            triggerBtn : true,
	           // dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
	        });
	        
	        $('#END_DT').YJcalendar({
	            fromName : 'to',
	            triggerBtn : true,
	           // dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
	        });
	        
	        //text 셋팅
	        /* $('.row > .col > .tit').each(function(){
	            $(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
	        }); */
	            
	        //div필수값 alt
	        //$("#START_DT").attr('alt',parent.fn_text('sel_term'));
	        //$("#END_DT").attr('alt',parent.fn_text('sel_term'));
	        
	        //div필수값 alt
	        //$("#URM_USE_DT").attr('alt',parent.fn_text('sel_term'));
	        //$("#START_DT4").attr('alt',parent.fn_text('sel_term'));
	        //$("#URM_DE_DT").attr('alt',parent.fn_text('sel_term'));
	    }

		function fn_reg_exec(){
			var url = "/CE/EPCE9000542_09.do"; 
			var input = {};
			$('#EMAIL').val($.trim($("#EMAIL_TXT").val()) +"@"+ $.trim($("#DOMAIN_TXT").val()));
			var URM_TYPE = $("#URM_TYPE  option:selected").val();
			if(URM_TYPE == "A"){
				input["USE_TOT"]=1140000;
			}else{
				input["USE_TOT"]=3500000;
			}
			input['URM_NM'] = $("#URM_NM").val();
			input['URM_NO'] = $("#URM_NO").val();
			input['SERIAL_NO'] = $("#SERIAL_NO").val();
			input['URM_CE_NO'] = $("#URM_CE_NO").val();
			//input['AREA_CD'] = $("#AreaCdList_SEL option:selected").val();
			input['PNO'] = $("#PNO").val();
			input["ADDR1"]    = $("#ADDR1").val();
			input["ADDR2"]    = $("#ADDR2").val();
			input['START_DT'] = $("#START_DT").val().replaceAll("-","");
// 			input['END_DT'] = $("#END_DT").val().replaceAll("-","");
			input['URM_TYPE'] = URM_TYPE;
			input['TELNO'] = $("#TELNO").val();
			input['EMAIL'] = $("#EMAIL").val();
			input['URM_USE_DT'] = $("#URM_USE_DT").val().replaceAll("-","");
			input['URM_DE_DT'] = $("#URM_DE_DT").val().replaceAll("-","");
// 			input['USE_YN'] = $("#USE_YN  option:selected").val();
				 	
					//showLoadingBar();   
					ajaxPost(url, input, function(rtnData){
						if(rtnData != null && rtnData != ""){
								if(rtnData.RSLT_CD =="A003"){ // 중복일경우
									alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
								}else if(rtnData.RSLT_CD =="A021"){
									alertMsg(rtnData.RSLT_MSG);
								}else if(rtnData.RSLT_CD =="0000"){
									alertMsg(rtnData.RSLT_MSG);
				  					//fn_init(); //입력창 초기화
				  					fn_cnl();
								}else{
									alertMsg(rtnData.RSLT_MSG);
								}
						}else{
								alertMsg("error");
						}
						//hideLoadingBar();
					});//end of ajaxPost
			 
		}
		
		 var parent_item;
			//사업자변경이력 팝업
			function fn_pop(){
				
				var idx = dataGrid.getSelectedIndex();
				
				if(idx < 0){
					alertMsg('선택된 행이 없습니다');
					return;
				}
				
				parent_item = gridRoot.getItemAt(idx);
				var pagedata = window.frameElement.name;
				window.parent.NrvPub.AjaxPopup('/CE/EPCE9000501_1.do', pagedata);
			}
		
		function fn_cnl(){		 
			//location.href = "/CE/EPCE8149301.do";		
			kora.common.goPageB('', INQ_PARAMS);
		}
</script>
<style type="text/css">
.srcharea .row .col .tit{
    width: 120px;
}
.srcharea .row .box > *{
    float:left;
    margin: 0 0 0 0px;
}
</style>
</head>
<body>
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="area_cd_list" value="<c:out value='${area_cd_list}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
			<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
			<section class="secwrap"   id="params">
            <div class="srcharea mt10" > 
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">무인회수기명</div>    <!-- 조회기간 -->
                        <div class="box">
                        <input type="text" disabled="disabled"  id="URM_NM" name="URM_NM" style="width: 330px;" class="i_notnull" alt="무인회수기명">
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">무인회수기 시리얼번호</div>    <!-- 조회기간 -->
                        <div class="box">
                        			<input type="text"  disabled="disabled" id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" alt="무인회수기시리얼번호"  format="number"  maxByteLength="9">
									<!-- <button type="button" id="bizrnoChk" class="btn34 c6" style="width: 92px;">중복확인</button> -->
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">센터고유넘버</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<input type="text"  disabled="disabled" id="URM_CE_NO" name="URM_CE_NO" style="width: 330px;" class="i_notnull" alt="센터고유넘버"  maxByteLength="9">
							<!-- <button type="button" id="bizrnoChk2" class="btn34 c6" style="width: 92px;">중복확인</button> -->
                        </div>
                    </div>
                </div> <!-- end of row -->
                <% /* %><div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">지역</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<select id="AreaCdList_SEL" name="AreaCdList_SEL" style="width: 179px">
							<option value="">전체</option><option class="generated" value="A02">부산광역시</option><option class="generated" value="A03">대구광역시</option><option class="generated" value="A04">인천광역시</option><option class="generated" value="A05">대전광역시</option><option class="generated" value="A06">울산광역시</option><option class="generated" value="A07">광주광역시</option><option class="generated" value="B01">경기도</option><option class="generated" value="B02">강원도</option><option class="generated" value="B03">충청북도</option><option class="generated" value="B04">충청남도</option><option class="generated" value="B05">경상북도</option><option class="generated" value="B06">경상남도</option><option class="generated" value="B07">전라북도</option><option class="generated" value="A01">서울특별시</option><option class="generated" value="B08">전라남도</option><option class="generated" value="B10">세종시</option><option class="generated" value="B09">제주도</option>
							</select>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <% */ %>
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">주소</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<input type="text" class="i_notnull" id="PNO" name="PNO" style="width: 179px;" alt="우편번호" readonly="readonly">
<!-- 							<button type="button" id="btnPopZip" class="btn34 c6" style="width: 122px;">우편번호 검색</button> -->
							<br>
							<input type="text" disabled="disabled"  id="ADDR1" name="ADDR1" style="width: 330px;" maxByteLength="500" class="i_notnull" alt="사업장주소">
							<br>
							<input type="text" disabled="disabled"  id="ADDR2" name="ADDR2" style="width: 330px;" placeholder="상세주소입력" maxByteLength="500" class="i_notnull" alt="사업장 상세주소">
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">설치일자</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<div class="calendar">
                                <input type="text" id="START_DT" name="START_DT" style="width: 179px;" class="i_notnull"><!--시작날짜  -->
                            </div>
                        		<%-- <input type="text" id="START_DT" name="from" value="<c:out value='${VIEW_ST_DATE}' />" style="width: 180px;" class="i_notnull" alt="시작날짜"> --%>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <%-- <div class="row" >
                    <div class="col"  style="width: 100%;">
                        <div class="tit" style="width: 150px">철거일자</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<input type="text" id="END_DT" name="END_DT" value="<c:out value='${VIEW_ST_DATE}' />" style="width: 180px;" class="i_notnull" alt="시작날짜">
                        </div>
                    </div>
                </div> --%> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">최초설치일자</div>   
                        <div class="box">
                                <input type="text" id="URM_USE_DT" name="URM_USE_DT" style="width: 179px;" class="i_notnull"><!--시작날짜  -->
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">품질보증만료일자</div>   
                        <div class="box">
                               <input type="text" id="URM_DE_DT" name="URM_DE_DT" style="width: 179px;"    class="i_notnull"><!-- 끝날짜 -->
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">무인회수기 유형</div>    <!-- 조회기간 -->
                        <div class="box">
                       			<select id="URM_TYPE" style="width: 330px;">
								<option value="A">독립형</option>
								<option value="B">매립형</option>
								</select>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">담당자연락처</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<input type="text" id="TELNO" name="TELNO" style="width: 330px;" class="i_notnull" alt="" maxByteLength="30">
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">E-MAIL</div>    <!-- 조회기간 -->
                        <div class="box">
							<input type="text" id="EMAIL_TXT" name="EMAIL_TXT"
								style="width: 179px;" class="i_notnull" maxLength="20">
							<div class="sign">@</div>
							<input type="text" id="DOMAIN_TXT" name="DOMAIN_TXT"
								style="width: 179px;" class="i_notnull" maxLength="20">
							<select id="DOMAIN" name="DOMAIN" style="width: 179px;">
								<option id="drct_input" value=""></option>
							</select>
						</div>
                    </div>
                </div> <!-- end of row -->
                <!-- <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">사용여부</div>    조회기간
                        <div class="box">
                        	<select id="USE_YN" style="width: 330px;">
								<option value="Y">사용중</option>
								<option value="N">폐기</option>
								</select>
                        	<input type="text" id="USE_YN" name="USE_YN" style="width: 330px;" class="i_notnull" alt="" maxByteLength="30">
                        </div>
                    </div>
                </div> --> <!-- end of row -->
                
            </div>  <!-- end of srcharea -->
            
            <input type="hidden" id="URM_NO" name="URM_NO"/>
            <input type="hidden" id="EMAIL" name="EMAIL"/>
        </section>
        </form>
		<section class="btnwrap mt20" >
		<div class="btnwrap">
			<div class="fl_r" id="BR">
 						 <button type="button" class="btn36 c4" style="width: 100px;" id="btn_cncl">취소</button> 
 						<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">저장</button> 
			</div>
		</div>
		</section>
	</div>



</body>
</html>