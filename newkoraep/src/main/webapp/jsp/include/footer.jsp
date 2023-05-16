<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer id="footer">
	<div class="ft_outer">
		<div class="ft_left">
			<ul class="ft_menu">
				<li><a class="" id="btn_pop1" style="cursor: pointer;">이용약관</a></li>
				<li><a class="" id="btn_pop2" style="cursor: pointer;">개인정보처리방침</a></li>
			</ul>
			<address class="address">
				<div class="row">
					<div class="obj">03149 서울특별시 종로구 인사동7길 12, 자원순환보증금관리센터(백상빌딩 10층)</div>
					<div class="obj">TEL : 1522-0082</div>
					<div class="obj">FAX : 02-535-6464</div>
				</div>
				<div class="row">
					<div class="obj">문의메일 : webmaster@cosmo.or.kr</div>
				</div>
			</address>
			<p class="copyright">COPYRIGHT 2021 COSMO.OR.KR ALL RIGHT RESERVED.</p>
		</div>
		<div class="ft_right" style="">
			<div class="ft_cscenter"  >	고객지원<a class="link" id="btn_pop3" style="cursor: pointer;"><span>문의하기</span></a></div>
			<div class="ft_call"> 
				<div class="call">1522-0082</div>
				<div class="time">운영시간 : 평일 09:00 ~ 18:00</div>
				<button type="button" class="btn36 c4" id="btn_ajax" style="width: 178px;">아작스</button>
<!-- 				<button type="button" class="btn36 c4" id="btn_reg" style="width: 178px;">메일</button> -->
				<button  class="btn34 c6" style="width: 151px;" onclick="fn_phoneCert()">담당자 휴대폰 인증</button>
				
			</div>
		</div>
	</div>
</footer>

<script>

	$(document).ready(function(){
		$("#btn_pop1").click(function(){	//이용약관
			NrvPub.AjaxPopup('/jsp/terms.jsp');
		});
		
		$("#btn_pop2").click(function(){	//개인정보처리방침
			NrvPub.AjaxPopup('/jsp/privacy.jsp');
		});
		
		$("#btn_pop3").click(function(){	//문의하기
			//NrvPub.AjaxPopup('/jsp/CE/EPCE8149088.jsp');
			window.open("/EP/EPCE0098201.do?_csrf=${_csrf.token}", "InstallVestCert", "width=840, height=700, menubar=no,status=no,toolbar=no,resizable=1,scrollbars=1");
		});
	});
	 $("#btn_ajax").click(function(){
// 		 alert("3");
//          //if(!confirm("사업자 정보를 등록하시겠습니까?")) return;
//          //fn_reg();
// //          fn_test();
         fn_ajax1();
//          fn_test();
// //          fn_test();
        
//          //console.log($("#BIZRNO").val());
     });

	 function fn_ajax1() {
		 alert("2");
		 var jsonObject = {};
		 var data = [{
			 "date" : "20230101",
			 "serial_no" : "5725002875",
			 "container_code" : "231",
			 "area_code" : "B04",
			 "branch_code" : "B04GS31132",
			 "branch_name" : "GS수퍼마켓 천안점",
			 "purpose_code" : "1",
			 "receipt_no" : "0078",
			 "sibling_seq" : 1,
			 "sys_type" : "API",
			 "deposit_value" : 100,
			 "qty" : 1,
			 "reg_id" : "RELAB"
			 }, {
			 "date" : "20230101",
			 "serial_no" : "5725002875",
			 "container_code" : "331",
			 "area_code" : "B04",
			 "branch_code" : "B04GS31132",
			 "branch_name" : "GS수퍼마켓 천안점",
			 "purpose_code" : "1",
			 "receipt_no" : "0079",
			 "sibling_seq" : 2,
			 "sys_type" : "API",
			 "deposit_value" : 260,
			 "qty" : 2,
			 "reg_id" : "RELAB"
			 }]
	     
		 jsonObject['data'] = data
		 
		 console.log(data);
		 
// 		 var arr = []
// 		 var obj = {}



// 		console.log(arr);
// 		 jsonObject = arr


// 		 console.log(jsonObject);
//	 	 var jsonData = JSON.stringify(jsonObject);
//	 	 console.log(jsonData);
		 var xhr = new XMLHttpRequest();
//	 	 var xxurl = "https://devreuse2.cosmo.or.kr/api/recvJsonData.do";
		 
		  $.ajax({
			 url:"/api/urmJsonData.do",
			 type:'POST',
			 data:JSON.stringify(jsonObject),
			 contentType:'application/json;charset=UTF-8',
			 dataType:"json",
			 success : function(result){
				 console.log(result);
			 }
		 }) 
	}
	 
	 
	 
	 function fn_ajax2() {
		 alert("2");
		 var jsonObject = {}
	     

		 var arr = []
		 var obj = {}
// 		 	 obj['date']="20220926"
// 			 obj['serial_no']="8008059016500201151"
// 			 obj['container_code']="231"
// 			 obj['area_code']="B06"
// 			 obj['branch_name']="홈플러스 인하점"
// 			 obj['branch_code']="A04HP22201"
// 			 obj['purpose_code']="1"
// 			 obj['receipt_no']="54"
// 			 obj['sibling_seq']="1" 
// 			 obj['sys_type']="API" 
// 			 obj['deposit_value']="35000" 
// 			 obj['qty']="5" 
// 			 obj['reg_id']="RELAB" 
// 			 arr.push(obj)   
// 			 obj = {}
			 obj['date']="20221012"
			 obj['serial_no']="5716002209"
			 obj['container_code']="231"
			 obj['area_code']="B06"
			 obj['branch_name']="하나로마트 강릉내곡점"
			 obj['branch_code']="B02NH25604"
			 obj['purpose_code']="1"
			 obj['receipt_no']="0076"
			 obj['sibling_seq']="1" 
			 obj['sys_type']="API" 
			 obj['deposit_value']="500" 
			 obj['qty']="5" 
			 obj['reg_id']="RELAB" 
			 arr.push(obj)   
			 obj = {}
			 obj['date']="20221012"
			 obj['serial_no']="5716002209"
			 obj['container_code']="331"
			 obj['area_code']="B06"
			 obj['branch_name']="하나로마트 강릉내곡점"
			 obj['branch_code']="B02NH25604"
			 obj['purpose_code']="1"
			 obj['receipt_no']="0076"
			 obj['sibling_seq']="2"
			 obj['sys_type']="API" 
			 obj['deposit_value']="130" 
			 obj['qty']="5"
			 obj['reg_id']="RELAB" 
			 arr.push(obj)   
			 obj = {}
		 jsonObject["data"] = arr
		console.log(jsonObject);
		 


//	 	 var jsonData = JSON.stringify(jsonObject);
//	 	 console.log(jsonData);
		 var xhr = new XMLHttpRequest();
//	 	 var xxurl = "https://devreuse2.cosmo.or.kr/api/recvJsonData.do";
		 
		 $.ajax({
			 url:"/api/urmJsonData.do",
//	 		 url:xxurl,
			 type:'POST',
			 data:JSON.stringify(jsonObject),
			 contentType:'application/json;charset=UTF-8',
			 dataType:"json",
			 success : function(result){
				 console.log(result);
			 }
		 })
	}
 function fn_ajax() {
	 alert("2");
	 var jsonObject = {}
     var fuck = "HwVYQWS24zRlmH7Wc1PO0HOlsI+6cQw0xxJ3AtEfOqblIJkMIBglfcJOTlSr9Lff";
	 var res1 = encodeURIComponent(fuck);
	 console.log(res1);
	 jsonObject['TRMS_DT'] = "20221219"
	 jsonObject['TRMS_TKTM'] = "075330"
	 jsonObject['API_ID'] = "AP_R03"
	 jsonObject['MBR_ISSU_KEY'] = res1
	 jsonObject['BIZRNO'] = "4108509753"
	 jsonObject['REG_DIV'] = "I"
// 	 jsonObject['ERP_CD'] = "E07"

	 var arr = []
	 var obj = {}
	 obj['RTRVL_DT']="20221219"
		 obj['RTRVL_CTNR_CD']="431"
		 obj['RTL_BIZRNO']="0000000000"
		 obj['RTRVL_QTY']="8"
		 obj['RTRVL_GTN']="2800"
		 obj['RTL_FEE']="264"
		 obj['BCNC_SE']="1"
		 obj['RTL_ENP_NM']="회수총량" 
		 arr.push(obj)   
		 obj = {}
	 obj['RTRVL_DT']="20221219"
		 obj['RTRVL_CTNR_CD']="331"
		 obj['RTL_BIZRNO']="0000000000"
		 obj['RTRVL_QTY']="1"
		 obj['RTRVL_GTN']="350"
		 obj['RTL_FEE']="33"
		 obj['BCNC_SE']="1"
		 obj['RTL_ENP_NM']="회수총량" 
		 arr.push(obj)   
		 obj = {}
		 obj['RTRVL_DT']="20221219"
		 obj['RTL_BIZRNO']="4022348591"
		 obj['RTRVL_CTNR_CD']="431"
		 obj['RTRVL_QTY']="2"
		 obj['RTRVL_GTN']="700"
		 obj['RTL_FEE']="66"
		 obj['BCNC_SE']="1"
		 obj['RTL_ENP_NM']="전주한일점" 
		 arr.push(obj)   
		 obj = {}
		 obj['RTRVL_DT']="20221219"
		 obj['RTL_BIZRNO']="4022348591"
		 obj['RTRVL_CTNR_CD']="331"
		 obj['RTRVL_QTY']="1"
		 obj['RTRVL_GTN']="350"
		 obj['RTL_FEE']="33"
		 obj['BCNC_SE']="1"
		 obj['RTL_ENP_NM']="전주한일점" 
		 arr.push(obj)   
		 obj = {}
		 obj['RTRVL_DT']="20221219"
		 obj['RTL_BIZRNO']="3893300202"
		 obj['RTRVL_CTNR_CD']="431"
		 obj['RTRVL_QTY']="2"
		 obj['RTRVL_GTN']="700"
		 obj['RTL_FEE']="66"
		 obj['BCNC_SE']="1"
		 obj['RTL_ENP_NM']="동전주IC점" 
		 arr.push(obj)   
		 obj = {}
		 obj['RTRVL_DT']="20221219"
		 obj['RTL_BIZRNO']="5072000270"
		 obj['RTRVL_CTNR_CD']="431"
		 obj['RTRVL_QTY']="4"
		 obj['RTRVL_GTN']="1400"
		 obj['RTL_FEE']="132"
		 obj['BCNC_SE']="1"
		 obj['RTL_ENP_NM']="전주금호청솔점"
		 arr.push(obj)   
		 obj = {}

	console.log(arr);
	 jsonObject['REPT_REC'] = arr


	 console.log(jsonObject);
// 	 var jsonData = JSON.stringify(jsonObject);
// 	 console.log(jsonData);
	 var xhr = new XMLHttpRequest();
// 	 var xxurl = "https://devreuse2.cosmo.or.kr/api/recvJsonData.do";
	 
	 $.ajax({
		 url:"/api/recvJsonData.do",
// 		 url:xxurl,
		 type:'POST',
		 data:JSON.stringify(jsonObject),
		 contentType:'application/json;charset=UTF-8',
		 dataType:"json",
		 success : function(result){
			 console.log(result);
		 }
	 })
}
</script>