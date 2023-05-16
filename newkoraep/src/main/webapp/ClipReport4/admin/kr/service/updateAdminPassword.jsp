<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
function changePassword(form) {
	var newPassword = form.newPassword;
	var confirmPassword = form.confirmPassword;
	if (!newPassword.value) {
		alert("새롭게 적용할 비밀번호를 입력하세요");
		return;
	}
	
	if (!confirmPassword.value) {
		alert("새롭게 적용할 비밀번호를 입력하세요");
		return;
	}
	
	if (newPassword.value == confirmPassword.value) {
		form.submit();	
	} else {
		alert("새롭게 적용할 비밀번호가 맞지 않습니다. 다시 한번 입력해주세요");
	}
}
</script>
<div class="container">
	<div class="page-header">
		<h3>관리자 패스워드 수정</h3>
	</div>
	
	<div style="width: 1200px; margin: 0px auto;">
		<form action="index.jsp" method="post">
			<input type="hidden" name="ClipID" value="A151">
			<div class="control-group">
			    <label class="control-label">현재 비밀번호</label>
			    <div class="controls">
					<input type="password" name="currentPassword"  maxlength="15" placeholder=""/>    
			    </div>
			</div>
	        
	        <div class="control-group">
			    <label class="control-label">새 비밀번호</label>
			    <div class="controls">
					<input type="password" name="newPassword" maxlength="15" placeholder=""/>    
			    </div>
			</div>
			
			<div class="control-group">
			    <label class="control-label">새 비밀번호 확인</label>
			    <div class="controls">
					<input type="password" name="confirmPassword" maxlength="15" placeholder=""/>    
			    </div>
			</div>
	        
	        
	        <button type="button" class="btn btn-primary" onclick="changePassword(this.form)">확인</button>
	      	<a class="btn" type="button" href="index.jsp">취소</a>
		 </form>
	</div>
</div>

