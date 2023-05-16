<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div style="width:100%; height:100%;">
	
	<div class="row-fluid">
		<div class="span8">
			<img style="padding-left:30px; padding-top:30px;" src="../img/admin/clipsoft.png">
		</div>
		<div class="span2">
			<form style="float:right;" action="index.jsp" method="post">
				<div class="control-group">
					<input type="hidden" name="ClipID" value="A101" >
					<a style="margin-top:20px;" class="btn btn-primary" href="index.jsp?ClipID=A101"><i class="icon-user icon-white"></i> Admin </a> 
				</div>
			</form> <!-- Form -->
		</div>
		<div class="span2">
			<%@ include file="../../logout.jsp"%>
		</div>
	</div>
</div>