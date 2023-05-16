<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	function addNewEngine(form) {
		if (!form.name.value) {
			alert("엔진이름을 적어주세요");
			form.name.focus();
			return;
		}

		if (!form.path.value) {
			alert("엔진경로를 적어주세요");
			form.path.focus();
			return;
		}

		if (!form.portNumber.value) {
			alert("엔진포트를 적어주세요");
			form.portNumber.focus();
			return;
		}

		form.submit();
	}
</script>
<div class="container">
	<div class="page-header">
		<h3>엔진서버 추가 페이지</h3>
	</div>
	
	<div style="width: 100%; margin: 0px auto;">
		<form class="form-horizontal" id="engineAddForm" action="index.clip" method="post">
			<input type="hidden" name="ClipID" value="M52">
			<div class="control-group">
			    <label class="control-label" for="inputName">이름</label>
			    <div class="controls">
			      <input type="text" id="inputName" name="name" placeholder="Name">
			    </div>
			  </div>
			  <div class="control-group">
			    <label class="control-label" for="inputPath">주소</label>
			    <div class="controls">
			      <input type="text" id="inputPath" name="path"placeholder="Path">
			    </div>
			  </div>
			  <div class="control-group">
			    <label class="control-label" for="inputPortNumber">포트번호</label>
			    <div class="controls">
					<input type="text" id="inputPortNumber" name="portNumber" placeholder="PortNumber" value="8080">
			    </div>
			  </div>
			  <div class="control-group">
			    <div class="controls">
			      	<button type="button" class="btn btn-primary" onclick="addNewEngine(this.form)">추가</button>
			      	<a class="btn" type="button" href="index.clip?ClipID=M101">취소</a>
			      	<!-- <button type="button" class="btn">Connection Check</button> -->
			    </div>
			  </div>
		</form>
	</div>
</div>