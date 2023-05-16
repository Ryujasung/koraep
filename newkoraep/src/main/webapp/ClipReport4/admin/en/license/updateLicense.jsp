<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String licenseKey = (String) request.getAttribute("licenseKey");
	if (licenseKey.equals("null")) {
		licenseKey = "";
	}
%>
<script type="text/javascript">
	function updateLicense(form) {
		if (!form.licenseKey.value) {
			alert("Please enter your license key.")
			return form.licenseKey.focus();
		}
		
		form.submit();
	}
</script>
<div class="container">
	<div class="page-header">
		<h3>License renewal page</h3>
	</div>
	
	<!-- <p>License.properties 파일을 수정후 갱신을 해주시길 바랍니다.</p> -->
	<div></div>
	<!-- <div style="width: 1200px; margin: 0px auto; padding-top:20px;">
		<form action="index.jsp" method="post">
			<input type="hidden" name="ClipID" value="E103">
	        <button type="submit" class="btn btn-primary" >갱신</button>
		 </form>
	</div> -->
	<form class="form-horizontal" style="display:inline;" action="index.jsp" method="post">
		<p>
			If the change of the project occurs , it is the page to update the license. <br>
			(Note: I will update you ask have you remove the line breaks.)
			<br><br>
			<button type="button" class="btn btn-link" onclick="updateLicense(this.form)"> License renewal </button>
		</p>
		<input type="hidden" name="ClipID" value="E153">
		
		<textarea class="form-control" style="min-width: 70%;" rows="3" placeholder="License Key" name="licenseKey"><%=licenseKey%></textarea>
		<br>
	</form>
	<!-- <a style="margin-top: 20px;" class="btn btn-primary"
		href="index.jsp?ClipID=E153"><i class="icon-edit icon-white"></i>
		갱신 </a> -->
</div>