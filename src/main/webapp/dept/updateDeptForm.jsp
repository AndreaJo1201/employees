<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import ="java.util.*" %>

<%
	//1. 요청 분석
	System.out.println("--------------------------------UPDATELIST--------------------------------");
	String deptNo = request.getParameter("deptNo");
	System.out.println("deptNo:"+deptNo); // deptNo get consol print : debuging
	

	//2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection ... Complete!"); // db connection debuging
	
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	
	ResultSet rs = stmt.executeQuery();
	
	String deptName = null;
	
	if(rs.next()) {
		deptName = rs.getString("deptName");
		System.out.println("deptName:"+deptName);
	}
	
	System.out.println("UPDATE deptNo :"+deptNo); // deptNo check
	System.out.println("UPDATE deptName :"+deptName); // deptName check
	System.out.println("--------------------------------------------------------------------------");
	
	
%>

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>UPDATE DEPT</title>
	</head>

	<body>
	<div class="container">
		<div class="mt-4 p-5 bg-success text-white rounded col-sm">
			<h1>UPDATE DEPT FORM</h1>
		</div>
		
		<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
			<table class="table table-striped table-hover text-center">
				<tr>
					<th colspan="2">
						<div>부서 수정</div>
					</th>
				</tr>
				
				<tr>
					<td><span>부서 번호</span></td>
					<td>
						<input type="text" name="deptNo" value="<%=deptNo %>" readonly="readonly">
					</td>
				</tr>
				
				<tr>
					<td><span>부서 이름</span></td>
					<td>
						<input type="text" name="deptName" value="<%=deptName %>">
					</td>
				</tr>
				
				<tr>
					<th colspan="2">
						<button type="submit" class="btn btn-success text-white">UPDATE</button>
						<a href="<%=request.getContextPath()%>/dept/deptlist.jsp" class="btn btn-info text-white">Back</a>
					</th>
				</tr>
				
				
			</table>
		</form>
	
	</div>
		
	</body>
</html>