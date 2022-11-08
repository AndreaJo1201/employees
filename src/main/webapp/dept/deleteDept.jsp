<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>

<%request.setCharacterEncoding("UTF-8"); %>

<%
	// 1. 요청 분석
	System.out.println("--------------------------------DELETELIST--------------------------------");
	String deptNo = request.getParameter("deptNo");

	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	System.out.println("DB Connection... Complete!"); // db connection debuging
	
	String sql = "DELETE FROM departments WHERE dept_no = ?";
	System.out.println("Delete : deptNo = "+deptNo); // deptNo check
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,deptNo);
	System.out.println("stmt set complete deptNo : "+sql); // query check debuging
	
	int row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("Delete Complete!!");
	} else {
		System.out.println("Delete False ...");
	}
	System.out.println("--------------------------------------------------------------------------");
	
	response.sendRedirect(request.getContextPath()+"/dept/deptlist.jsp");
%>
