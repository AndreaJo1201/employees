<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import ="vo.*" %>
<%request.setCharacterEncoding("UTF-8"); %>

<%
	//1. 요청 분석(Controller)
	
	//2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, list, ...))
	Class.forName("org.mariadb.jdbc.Driver"); // DB Driver loading...
	System.out.println("Driver loading complete!!");
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234"); // DB connection..
	System.out.println("DB Connection... Complete!!");
	
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("PreparedStatement : "+sql);
	
	ResultSet rs = stmt.executeQuery();
	// <-- 모델 데이터 ResultSet은 보편적인 타입X
	// ResultSet rs <- 모델 자료구조를 일반적이고 독립적인 자료구조로 변경 필요
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()) { //이터레이트? iterate | ResultSet의 API(사용방법)을 모른다면 사용할 수 없는 반복문.
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
		
	}
	
	//3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	
%>

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>DEPT LIST</title>
	</head>

	<body>
		<div class="container">
			<div class="mt-4 p-5 bg-info text-white rounded">
				<h1>DEPT LIST</h1>
			</div>
			
			<table class="table table-striped table-hover">
				<tr>
					<th>부서 번호</th>
					<th>부서 이름</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
					<!-- 부서 목록 출력(부서번호 내림차순) -->
				<%
					for(Department d : list) { // Java에서 제공하는 foreach문
				%>
						<tr>
							<td><%=d.deptNo %></td>
							<td><%=d.deptName %></td>
							<td><a href="" class="badge bg-primary">수정</a></td>
							<td><a href="" class="badge bg-danger">삭제</a></td>
						</tr>
				<%		
					}
				%>
			</table>
			
			<div>
				<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp" class="btn btn-secondary text-white btn-lg">부서 추가</a>
			</div>
			
		</div>	
	</body>
</html>