<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%request.setCharacterEncoding("UTF-8"); %>

<%
	//1. 요청 처리
	//페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));	
	}
	
	//2. 요청 분석 
	int rowPerPage = 10; // 한 페이지당 출력할 데이터의 개수
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	//lastPage 
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
%>

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>EMPL LIST</title>
	</head>

	<body>
		<div class="container">
			<div class="mt-4 p-5 bg-info text-white rounded">
				<h1>사원목록</h1>
			</div>
			<div>
				<jsp:include page="/inc/menu.jsp"></jsp:include>
			</div>

			<!-- 부서별 사원 목록 출력 -->
			<table>
			
			</table>

			
			<div>현재 페이지 : <%=currentPage %> / <%=lastPage %></div>
			
			<!-- paging code -->
			<div>
				<%
					if(currentPage>1) {
				%>
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음으로</a>
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
				<%
					}
					if(currentPage<lastPage) {
				%>
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">끝으로</a>
				<%		
					}
				%>
			</div>
			
		</div>
	</body>
</html>