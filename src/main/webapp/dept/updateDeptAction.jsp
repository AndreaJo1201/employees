<%@page import="java.net.URLEncoder"%>
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
	
	if(request.getParameter("deptName") == null ||
			request.getParameter("deptNo") == null ||
			deptNo.equals("")||
			deptName.equals("")) {
				String msg = "잘못된 접근 방식 또는 부서 이름을 입력하지않았습니다."; // GET방식으로 주소창에 문자열 encoding
				System.out.println("--------------------------------------------------------------------------");
				response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
				return;
	}
	
	//2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!"); // DB connection check debuging
	
	
	String sql3 = "SELECT * FROM departments WHERE dept_name=?"; // INSERT 작업 하기전에 중복된 dept_name이 존재하는지 확인
	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1,deptName);
	ResultSet rs2 = stmt3.executeQuery();
	if(rs2.next()) { // 실행시 중복된 dept_no가 존재함을 알 수 있음.
		String msg = "해당 부서 이름은 중복되어 사용할 수 없습니다.";
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
		return;
	}
	
	
	String sql = "UPDATE departments SET dept_name=? WHERE dept_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	int row = stmt.executeUpdate();
	if(row == 1) { // result check
		System.out.println("UPDATE Complete!!");
	} else {
		System.out.println("UPDATE False...");
	}
	System.out.println("--------------------------------------------------------------------------");
	
	response.sendRedirect(request.getContextPath()+"/dept/deptlist.jsp");
%>

