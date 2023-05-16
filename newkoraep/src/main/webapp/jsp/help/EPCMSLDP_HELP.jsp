<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>도움말 가이드</title>
<link rel="stylesheet" href="../../css/basic.css" type="text/css">
<link rel="stylesheet" href="../../css/common.css" type="text/css">
<link rel="stylesheet" href="../../css/pop.css" type="text/css">
</head>

<body>
<!-- 팝업 사이즈 width:870px; height:580px↓ style 지워주세요-->
<div id="pop_wrap" class="help_wrap" style="width:870px; height:580px">
	<header>
		<h1>도움말 가이드</h1>
	</header>
	<div id="pop_container">
		<div class="pop contents bdB_none">
			<div class="helpBox">
				<p class="img"><img src="../../images/help/img_2_4.gif" alt=""></p>
				<div class="txtBox">
					<dl>
						<dt>1</dt>
						<dd>
							<p>
								반환내역서 및 해당건이 입고되는 입고내역서를 연결하여 조회 합니다.<br>							
								상태는 전체 10가지 상세 상태가 변경되며 권환에 따라 일부만 보여집니다.
							</p>
							<p> - 반환등록 : 도매업자 혹은 공병상이 반환내역서를 등록<br>
								- 입고확인 : 반환내역서 수량이 변경 없이 정상 입고 처리 완료<br>
								- 입고조정 : 반환내역서 수량이 검수 과정에 변경되어 도매업자 또는 공병상에 확인 요청<br>
								- 조사확인요청(도매업자) : 도매업자 또는 공병상이 센터에 확인을 요청한 상태<br>
								- 조사확인요청(생산자) : 생산자가 센터에 확인을 요청한 상태, 센터 직접방문 현장 실태조사도 동일</p>
						
								- 센터확인 : 조사확인요청건을 센터가 최종 확인 완료한 상태<br>
								- 고지등록 : 수량확인이 완료되어 생산자에게 취급수수료 고지서를 발행한 상태<br>
								- 수납확인 : 취급수수료 고지서서 수납이 확인된 상태<br>
								- 지급요청 : 도매업자 혹은 공병상이 해당건에 지급을 요청한 상태<br>
								- 지급예정 : 센터가 해당건에 지급절차가 진행 중인 상태<br>
								- 지급확인 : 반환등록부터 지급결과 확인까지 모든 처리가 완료된 상태
							</p>
						</dd>
						<dt>2</dt>
						<dd>조회조건을 선택하고 "조회" 버튼을 클릭 하여 자료를 조회 합니다.</dd>
						<dt>3</dt>
						<dd>"반환일자"을 클릭하면 상세내역을 조회 할 수 있습니다. (아래 그림 1)</dd>
						<dt>4</dt>
						<dd>"입고확인일자"를 클릭하면 입고내역서상세조회를 조회 할 수 있습니다.(아래 그림 2)</dd>
					</dl>
				</div>	
			</div>
			
			<div class="helpBox">
				<p class="img"><img src="../../images/help/img_2_4_2.gif" alt=""></p>
				<div class="txtBox">
					<dl>
						<dt>1</dt>
						<dd>"반환내역서상세조회" 현황을 조회합니다.</dd>
						<dt>2</dt>
						<dd>상단에 "인쇄" 버튼을 클릭하여 인쇄합니다.</dd>
						<dt>3</dt>
						<dd>상단에 "엑셀저장" 버튼을 클릭하여 저장합니다.</dd>
						<dt>4</dt>
						<dd>"목록" 버튼을 클릭하여 이전화면으로 이동합니다.</dd>
					</dl>
				</div>
			</div>
			
			<div class="helpBox">
				<p class="img"><img src="../../images/help/img_2_4_3.gif" alt=""></p>
				<div class="txtBox">
					<dl>
						<dt>1</dt>
						<dd>"입고내역서상세조회" 현황을 조회합니다.</dd>
						<dt>2</dt>
						<dd>"상단에 "인쇄" 버튼을 클릭하여 인쇄합니다.</dd>
						<dt>3</dt>
						<dd>"목록" 버튼을 클릭하여 이전화면으로 이동합니다.</dd>
					</dl>
				</div>
			</div>				
			
		</div>
		
		<div class="pop_close"><a href="javascript:window.close();">닫기</a></div>
	</div>
</div>
</body>
</html>
