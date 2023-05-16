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
		  
		  fn_init(); 
		 
		
		$('#title_sub').text('<c:out value="소모품정보변경" />');


		//저장
		$("#btn_reg").click(function(){
			fn_reg();
		});
  
		//취소
		$("#btn_cncl").click(function(){
			fn_cnl();
		});
  

       
        
       
	});

		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){
			
		
		
			 $("#URM_EXP_NM").val(kora.common.null2void(data.URM_EXP_NM));
				$("#URM_FIX_CD").val(kora.common.null2void(data.URM_FIX_CD));
				$("#USE_YN_SEL").val(data.USE_YN).prop("selected",true);
				

		}
	
		//저장
		function fn_reg(){
			
			
			 if(kora.common.format_noComma(kora.common.null2void($("#URM_EXP_NM").val(),0))  < 1) {
		            alertMsg("소모품명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#URM_EXP_NM");
		            return;
		        } 			 
			 
		    
		
			confirm('저장하시겠습니까?', 'fn_reg_exec');
		}

		//셋팅
	    function fn_init(){
	         
	    }

		function fn_reg_exec(){
			var url = "/CE/EPCE9000842_09.do"; 
			var input = {};
			input['URM_EXP_NM'] = $("#URM_EXP_NM").val();
			input['URM_FIX_CD'] = $("#URM_FIX_CD").val();
			input['USE_YN'] = $("#USE_YN_SEL option:selected").val();
				 	
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
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
			<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
			<section class="secwrap"   id="params">
            <div class="srcharea mt10" > 
            	<input type="hidden" id="REG_DT" name="REG_DT">
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">소모품명</div>    <!-- 조회기간 -->
                        <div class="box">
                        <input type="text"  id="URM_EXP_NM" name="URM_EXP_NM" style="width: 330px;" class="i_notnull" alt="무인회수기명">
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">소모품번호</div>    <!-- 조회기간 -->
                        <div class="box">
                        			<input type="text"  disabled="disabled" id="URM_FIX_CD" name="URM_FIX_CD" style="width: 330px;" class="i_notnull" alt="무인회수기시리얼번호"  format="number"  maxByteLength="9">
									<!-- <button type="button" id="bizrnoChk" class="btn34 c6" style="width: 92px;">중복확인</button> -->
                        </div>
                    </div>
                </div> <!-- end of row -->
               
              <!--   <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">공급단가(원)</div>    조회기간
                        <div class="box">
                        	<input type="text"  id="SUP_FEE" name="SUP_FEE" style="width: 330px;" class="i_notnull" alt="센터고유넘버"  maxByteLength="9">
							<button type="button" id="bizrnoChk2" class="btn34 c6" style="width: 92px;">중복확인</button>
                        </div>
                    </div>
                </div> end of row -->
                 <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">사용여부</div>  <!-- 사용여부 -->
						<div class="box">
							<select id="USE_YN_SEL" style="width: 179px" class="i_notnull"> 
								<option value="Y">사용</option>
								<option value="N">사용안함</option>
							</select>
						</div>
                    </div>
                </div> <!-- end of row -->
                
            </div>  <!-- end of srcharea -->
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