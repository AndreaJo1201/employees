<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import ="java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>

<%	
	// 1. 요청 분석
	System.out.println("--------------------------------INSERTLIST--------------------------------");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 부서번호 또는 부서명을 입력하지않거나 강제로 insertDeptAction.jsp로 넘어왔을 경우
	// insertDeptForm.jsp로 이동
	if(request.getParameter("deptName") == null ||
		request.getParameter("deptNo") == null ||
		deptNo.equals("")||
		deptName.equals("")) {
			String msg = "부서 번호 또는 부서명을 입력하십시오."; // GET방식으로 주소창에 문자열 encoding
			System.out.println("--------------------------------------------------------------------------");
			response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
			return;
	}
	System.out.println(deptNo + " <- getParameter : deptNo"); // deptNo check
	System.out.println(deptName + " <- getParameter : deptName"); //deptName check
	
	// 2. 요청 처리
	
	//이미 존재하는 key(dept_no)값과 동일한 값이 발생하면 예외(에러)가 발생
	// - > 동일한 key값이 있는지 확인 후 반환처리 필요.
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!"); // DB connection check debuging
	
	// 2-1. 요청 처리(중복 검사)
	String sql1 = "SELECT * FROM departments WHERE dept_no=? OR dept_name=?"; // INSERT 작업 하기전에 중복된 dept_no가 존재하는지 확인
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1,deptNo);
	stmt1.setString(2,deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 실행시 중복된 dept_no가 존재함을 알 수 있음.
		String msg = "해당 부서 번호 또는 부서 명은 중복되어 사용할 수 없습니다.";
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
		return;
	}
	
	// 2-2. 요청 처리(입력 작업)
	String sql2 = "INSERT INTO departments (dept_no, dept_name) Values(?, ?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	
	stmt2.setString(1,deptNo);
	stmt2.setString(2,deptName);
	
	System.out.println("Insert dept_name : "+deptName); // insert name check
	System.out.println("Insert dept_no : "+deptNo); // insert no check
	
	int row = stmt2.executeUpdate();
	
	if(row == 1) { // result check
		System.out.println("Insert Complete!");
	} else {
		System.out.println("Insert False...");
	}
	System.out.println("--------------------------------------------------------------------------");
	
	
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptlist.jsp");
%>