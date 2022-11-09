<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%request.setCharacterEncoding("UTF-8"); %>

<%
	//1. 요청 처리
	//페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) { // 페이지 번호
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		System.out.println("currentPage->request.getParameter() = "+currentPage);
	}
	
	//2. 요청 분석 
	int rowPerPage = 10; // 한 페이지당 출력할 데이터의 개수
	System.out.println("--------------------------------EMP_LIST--------------------------------");
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("Driver loading complete!!"); //driver debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!!"); //conn debuging
	
	//lastPage 
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	System.out.println("PreparedStatement : "+countSql); // stmt debuging
	
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
	if(currentPage > lastPage) { // 페이지를 넘어선 다른 수를 입력했을 때 예외(에러) 처리
		String stringMsg = "존재하지 않는 페이지입니다.";
		out.println("<script>alert('"+stringMsg+"');</script>"); // 스크립트 alert(경고메시지) 출력
		currentPage = lastPage;
		System.out.println("go to lastPage");
	} else if(currentPage < 1) {
		String stringMsg = "존재하지 않는 페이지입니다.";
		out.println("<script>alert('"+stringMsg+"');</script>");
		currentPage = 1;
		System.out.println("go to firstPage");
	}
	
	//페이지당 출력할 emp 목록
	String empSql ="SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1,rowPerPage*(currentPage-1));
	empStmt.setInt(2,rowPerPage);
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()) {
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
	System.out.println("------------------------------------------------------------------------");
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
			<table class="table table-striped table-hover text-center">
				<tr>
					<th class="col-sm-2">사원 번호</th>
					<th class="col-sm-5">firstName</th>
					<th class="col-sm-5">lastName</th>
				</tr>
				<%
					for(Employee e : empList) {
				%>
						<tr>
							<td class="col-sm-2"><%=e.empNo%></td>
							<td class="col-sm-5"><%=e.firstName%></td>
							<td class="col-sm-5"><%=e.lastName%></td>
						</tr>
				<%		
					}
				%>
			</table>
			<div class="text-center">
				<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="post" class="text-center">
					<input type="text" name="currentPage" value="" placeholder="이동하려는 page 번호" style="width:200px" class="text-center">
					<button class="btn btn-dark" type="submit">이동</button>
				</form>
			</div>
			

			
			<div class="text-center">Page No : <%=currentPage %> / <%=lastPage %></div>
			
			<!-- paging code -->
			<div class="text-center">
				<%
					if(currentPage>1) {
				%>
						<a class="btn btn-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음으로</a>
						<a class="btn btn-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
				<%
					}
					if(currentPage<lastPage) {
				%>
						<a class="btn btn-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
						<a class="btn btn-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">끝으로</a>
				<%		
					}
				%>
			</div>
			
		</div>
	</body>
</html>