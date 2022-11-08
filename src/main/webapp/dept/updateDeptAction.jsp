<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import = "vo.*" %>

<%
	//1. 요청 분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	System.out.println("deptNo:"+deptNo);
	System.out.println("deptName:"+deptName);
	
	//2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String sql = "UPDATE departments SET dept_name=? WHERE dept_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("UPDATE Complete!!");
	} else {
		System.out.println("UPDATE False...");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptlist.jsp");
%>

