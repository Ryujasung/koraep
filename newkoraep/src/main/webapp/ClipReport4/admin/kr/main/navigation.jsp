<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container">
	<div style="width: 100%;">
		<ul class="nav nav-pills nav-justfied">
			
			<li>
				<a href="index.jsp?ClipID=E160">Home</a>
			</li> <!-- Home -->
			 
			 
			<li class="dropdown">
				<a id="drop5" role="button" data-toggle="dropdown" href="#">
					Service Environment<b class="caret"></b>
				</a>
				<ul id="menu2" class="dropdown-menu" role="menu" aria-labelledby="drop5">
					 
					<li role="presentation">
						<a role="menuitem" tabindex="-1" href="index.jsp?ClipID=E102" >프린터 설정</a>
					</li>
					<!-- <li role="presentation">
						<a role="menuitem" tabindex="-1" href="index.jsp?ClipID=E101" >서비스 설정</a>
					</li> -->
					 
					<!-- <li role="presentation" class="divider"></li> -->
					
				</ul>
			</li> <!--  Service Environment  -->
			 
			
			<li class="dropdown">
				<a id="drop5" role="button" data-toggle="dropdown" href="#">
					Engine Management<b class="caret"></b>
				</a>
				
				<ul id="menu2" class="dropdown-menu" role="menu" aria-labelledby="drop5">				
					<li role="presentation">
						<a role="menuitem" tabindex="-1" href="index.jsp?ClipID=L101">기본 설정</a>
					</li>
					<li role="presentation">
						<a role="menuitem" tabindex="-1" href="index.jsp?ClipID=L103">커넥션 설정</a>
					</li>
					
					<!-- <li role="presentation" class="divider"></li> -->
					<%--
					<li role="presentation">
						<a role="menuitem" tabindex="-1" href="index.clip?ClipID=M101">원격엔진관리</a>
					</li>
					  --%>  
					   
					<li role="presentation" class="divider"></li>
					<li role="presentation">
						<a role="menuitem" tabindex="-1" href="index.jsp?ClipID=L102">리포트 로그</a>						 
					</li>
				</ul>
			</li> <!-- Engine Management -->
			
			<li class="dropdown">
				<a id="drop5" role="button" data-toggle="dropdown" href="#">
					License<b class="caret"></b>
				</a>
				<ul id="menu2" class="dropdown-menu" role="menu" aria-labelledby="drop5">
					 
					
					<!-- <li role="presentation">
						<a role="menuitem" tabindex="-1" href="index.clip?ClipID=E101" >서비스 환경설정</a>
					</li> -->
					<li role="presentation">
						<a role="menuitem" tabindex="-1" href="index.jsp?ClipID=E100" >라이센스 갱신</a>
					</li>
					 
					<!-- <li role="presentation" class="divider"></li> -->
					
				</ul>
			</li> <!-- Service Environment --> 
			
		</ul>
	</div>
</div>