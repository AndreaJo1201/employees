<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<%
	
%>

<!-- partial jsp 페이지 사용할 코드 -->
<nav class="navbar navbar-expand bg-dark navbar-dark">
	<div class="container-fluid d-flex justify-content-around">
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" href ="<%=request.getContextPath()%>/index.jsp">[홈으로]</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href ="<%=request.getContextPath()%>/dept/deptlist.jsp">[부서관리]</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href ="<%=request.getContextPath()%>/emp/empList.jsp">[사원목록]</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href ="<%=request.getContextPath()%>/board/boardList.jsp">[게시판관리]</a>
			</li>
		</ul>
	</div>
</nav>