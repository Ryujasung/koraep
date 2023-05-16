<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>도매업자 소속단체 설정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<script type="text/javaScript" language="javascript" defer="defer">

    var parent_item; 
    var aff_ogn_cd_list;
    
    $(document).ready(function(){
    
    	aff_ogn_cd_list = jsonObject($('#aff_ogn_cd_list').val());
    	 
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
    	
    	fn_init();
    });

	//선택데이터 팝업화면에 셋팅
	function fn_init() {
        $('#BIZR_NM_TXT').text($("#BIZR_NM").val());                                                      //소속단체
        $('#BIZRNO_TXT' ).text(kora.common.setDelim($("#BIZRNO_DE").val(), "999-99-99999"));                        //사업자명
	    kora.common.setEtcCmBx2(aff_ogn_cd_list, "","", $("#AFF_OGN_CD"), "ETC_CD", "ETC_CD_NM", "N");	//소속단체
 	}
	
	//저장 확인
  	function fn_reg_chk(){
		confirm("소속단체 정보가 변경됩니다. 계속 진행하시겠습니까?","fn_reg");
  	}
	
 	//저장
    function fn_reg(){
	    var url ="/CE/EPCE01810882_21.do"
		var input = {"list": ""};
	    var list  = [{"AFF_OGN_CD":$("#AFF_OGN_CD option:selected").val(), 
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

<input type="hidden" id="aff_ogn_cd_list" value="<c:out value='${aff_ogn_cd_list}' />"/>
<input type="hidden" id="BIZRID" value="<c:out value='${BIZRID}' />"/>
<input type="hidden" id="BIZRNO_DE" value="<c:out value='${BIZRNO}' />"/>
<input type="hidden" id="BIZRNO" value="<c:out value='${BIZRNO_ORI}' />"/>
<input type="hidden" id="BRCH_NO" value="<c:out value='${BRCH_NO}' />"/>
<input type="hidden" id="BRCH_ID" value="<c:out value='${BRCH_ID}' />"/>
<input type="hidden" id="BIZR_NM" value="<c:out value='${BIZR_NM}' />"/>

	<div class="layer_popup" style="width:700px; margin-top: -317px" >
		<div class="layer_head">
            <h1 class="layer_title">소속단체 설정</h1>
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
							<div class="tit">소속단체</div>  <!--소속단체 -->
							<div class="box"  >
								  <select id="AFF_OGN_CD" style="width: 210px"></select>
							</div>
						</div>
					</div>
				</div>
			</section>
            <section class="btnwrap">
                <div class="fl_l" >
                    <div class="h4group" >
                        <h5 class="tit"  style="font-size: 14px;text-align:left">
                            ※ 소속단체를 설정하지 않을 경우 로그인이 되지 않습니다.
                            <br/>&nbsp;&nbsp;&nbsp;소속단체를 설정해 주시기 바랍니다.
                        </h5>
                    </div>
                </div>
            </section>
            <section class="btnwrap">
                <div class="btn" style="float:right">
                    <button type="button" class="btn36 c3" style="width: 100px;" id="btn_reg" >변경요청</button>
                </div>
            </section>
		</div>
	</div>
</body>
</html>