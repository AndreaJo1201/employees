<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>

<%
	// 부서번호 또는 부서명을 입력하지않거나 강제로 insertDeptAction.jsp로 넘어왔을 경우
	// insertDeptForm.jsp로 이동
	if(request.getParameter("deptName") == null ||
		request.getParameter("deptNo") == null) {
		response.sendRedirect(request.getContextPath()+"/insertDeptForm.jsp");
		return;
	}

	// 1. 요청 분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	System.out.println(deptNo + " <- getParameter : deptNo"); // deptNo check
	System.out.println(deptName + " <- getParameter : deptName"); //deptName check
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!"); // DB connection check debuging
	
	String sql = "INSERT INTO departments (dept_no, dept_name) Values(?, ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1,deptNo);
	stmt.setString(2,deptName);
	
	System.out.println("Insert dept_name : "+deptName); // insert name check
	System.out.println("Insert dept_no : "+deptNo); // insert no check
	
	int row = stmt.executeUpdate();
	
	if(row == 1) { // result check
		System.out.println("Insert Complete!");
	} else {
		System.out.println("Insert False...");
	}
	
	
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptlist.jsp");
%>