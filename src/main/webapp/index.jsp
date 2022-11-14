<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>

<%

%>

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>index</title>
	</head>

	<body>
		<div class="container">
		
			<div class="mt-4 p-5 bg-primary text-white rounded">
				<h1>INDEX</h1>
			</div>
			<div>
				<jsp:include page="/inc/menu.jsp"></jsp:include>
			</div>
			
			<div>
				<ul class="list-group list-group-numbered">
					<li><a href="<%=request.getContextPath()%>/dept/deptlist.jsp" class="list-group-item list-group-item-action">부서 관리</a></li>
					<li><a href="<%=request.getContextPath()%>/emp/empList.jsp" class="list-group-item list-group-item-action">사원 목록</a></li>
					<li><a href="<%=request.getContextPath()%>/board/boardList.jsp" class="list-group-item list-group-item-action">게시판 관리</a></li>
					<li><a href="<%=request.getContextPath()%>/salary/salaryList.jsp" class="list-group-item list-group-item-action">연봉 관리</a></li>
				</ul>
			</div>
		</div>
	</body>
</html> 