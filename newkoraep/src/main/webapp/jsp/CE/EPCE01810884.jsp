<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>도매업자 ERP 설정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<script type="text/javaScript" language="javascript" defer="defer">

    var parent_item; 
    var erp_cd_list;
    
    $(document).ready(function(){
    
    	erp_cd_list = jsonObject($('#ERP_CD_LIST').val());
    	 
    	/************************************
    	 * 취소 버튼 클릭 이벤트
    	 ***********************************/
    	$("#btn_cnl").click(function(){
    		$('[layer="close"]').trigger('click');
    	});
    
    	/************************************
    	 * 저장 버튼 클릭 이벤트
    	 ***********************************/
    	$("#btn_reg").click(function(){
    		fn_reg_chk();
    	});
    	
		/**
		 * ERP코드 변경 이벤트
		 */
		$("#ERP_CD").change(function(){
			if(kora.common.null2void($(this).val()) == "E99") {
				$("#ERP_CD_NM").attr("disabled",false);
				$("#ERP_CD_NM").addClass("i_notnull");
			}else {
				$("#ERP_CD_NM").val("");
				$("#ERP_CD_NM").removeClass("i_notnull");
				$("#ERP_CD_NM").attr("disabled",true);
				
			}
		});
    	
    	fn_init();
    });

	//선택데이터 팝업화면에 셋팅
	function fn_init() {
        $('#BIZR_NM_TXT').text($("#BIZR_NM").val());                                                      //소속단체
        $('#BIZRNO_TXT' ).text(kora.common.setDelim($("#BIZRNO_DE").val(), "999-99-99999"));                        //사업자명
	    kora.common.setEtcCmBx2(erp_cd_list, "","", $("#ERP_CD"), "ETC_CD", "ETC_CD_NM", "N");	//erp코드
	    $("#ERP_CD").val($("#ERP_CD_PRE").val());

	    if ($("#ERP_CD_PRE").val() == "E99") {
			$("#ERP_CD_NM").attr("disabled",false);
			$("#ERP_CD_NM").addClass("i_notnull");
		    $("#ERP_CD_NM").val($("#ERP_CD_NM_PRE").val());
        }
 	}
	
	//저장 확인
  	function fn_reg_chk(){
        if(!kora.common.cfrmDivChkValid("regForm")) {
            return;
        }
		
		confirm("ERP 정보가 변경됩니다. 계속 진행하시겠습니까?","fn_reg");
  	}
	
 	//저장
    function fn_reg(){
	    var url ="/CE/EPCE01810884_21.do"
		var input = {"list": ""};
	    var list  = [{"ERP_CD":$("#ERP_CD option:selected").val(),
   		 			 "ERP_CD_NM":$("#ERP_CD_NM").val(),	    	
            		 "BIZRID":$("#BIZRID").val(), 
            		 "BIZRNO":$("#BIZRNO").val(),
            		 "BRCH_NO":$("#BRCH_NO").val(),
            		 "BRCH_ID":$("#BRCH_ID").val()}];
            		
	    input["list"] = JSON.stringify(list);
		
	    ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				parent.setAffOgnCd();
				$('[layer="close"]').trigger('click');
			}else{
				alertMsg(rtnData.RSLT_MSG);
			}
		});
    }
 /****************************************** 그리드 셋팅 끝***************************************** */

</script>
</head>
<body>
<form name="regForm" id="regForm" method="post" >
<input type="hidden" id="ERP_CD_LIST" value="<c:out value='${ERP_CD_LIST}' />"/>
<input type="hidden" id="ERP_CD_PRE" value="<c:out value='${ERP_CD}' />"/>
<input type="hidden" id="ERP_CD_NM_PRE" value="<c:out value='${ERP_CD_NM}' />"/>
<input type="hidden" id="BIZRID" value="<c:out value='${BIZRID}' />"/>
<input type="hidden" id="BIZRNO_DE" value="<c:out value='${BIZRNO}' />"/>
<input type="hidden" id="BIZRNO" value="<c:out value='${BIZRNO_ORI}' />"/>
<input type="hidden" id="BRCH_NO" value="<c:out value='${BRCH_NO}' />"/>
<input type="hidden" id="BRCH_ID" value="<c:out value='${BRCH_ID}' />"/>
<input type="hidden" id="BIZR_NM" value="<c:out value='${BIZR_NM}' />"/>

	<div class="layer_popup" style="width:700px; margin-top: -317px" >
		<div class="layer_head">
            <h1 class="layer_title">ERP 설정</h1>
			<button type="button" class="layer_close" layer="close" style="display:none" >팝업닫기</button>
		</div>
	   	<div class="layer_body">		
	   	
			<div class="h4group" >
				<h5 class="tit"  style="font-size: 16px;" id=""><h5>
			</div>
			
			<section class="secwrap"   id="params">
				<div class="srcharea" style="" > 
                    <div class="row">
                        <div class="col" style="width:280px">
                            <div class="tit">사업자명</div>  <!-- 도매업자구분 -->
                            <div class="box"><label class="txt"><span id="BIZR_NM_TXT"></span></label></div>
                        </div>
                        
                        <div class="col">
                            <div class="tit">사업자번호</div>  <!-- 도매업자업체명 -->
                            <div class="box"><label class="txt"><span id="BIZRNO_TXT"></span></label></div>
                        </div>
                    </div>
					<div class="row">
						<div class="col" style="">
							<div class="tit">ERP 구분</div>  <!-- ERP 구분 -->
							<div class="box"  >
								  <select id="ERP_CD" style="width: 210px" class="i_notnull" alt="ERP구분"></select>
							</div>
							<input type="text" id="ERP_CD_NM" name="ERP_CD_NM" style="width: 210px;" maxLength="20" disabled alt="ERP구분명"/>
						</div>
					</div>
				</div>
			</section>
            <section class="btnwrap">
                <div class="fl_l" >
                    <div class="h4group" >
                        <h5 class="tit"  style="font-size: 14px;text-align:left">
                            ※ 원활한 서비스 제공을 위해 ERP정보를 등록해 주시기 바랍니다.
                            <br/>&nbsp;&nbsp;&nbsp;&nbsp;사용ERP를 등록하지 않을 경우 로그인이 되지 않습니다.
                        </h5>
                    </div>
                </div>
            </section>
            <section class="btnwrap">
                <div class="btn" style="float:right">
                    <button type="button" class="btn36 c3" style="width: 100px;" id="btn_reg" >저장</button>
                </div>
            </section>
		</div>
	</div>
</form>	
</body>
</html>