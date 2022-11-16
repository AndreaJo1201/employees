<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import = " vo.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>

<%
	
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}

	String word = request.getParameter("word");
	
%>

<%
	int currentPage = 1;
	if(request.getParameter("currentPage") != null && !request.getParameter("currentPage").equals("")) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10;
	
	System.out.println("--------------------------------DEPT_EMP_LIST--------------------------------");
	
	String driver = "org.mariadb.jdbc.Driver";
	Class.forName(driver);
	System.out.println("jdbc Driver Loading Complete!"); // 드라이버 로딩 디버그
	
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	Connection conn = DriverManager.getConnection(url, user, password);
	System.out.println("DB Connection Complete!"); // DB 연결 체크 디버그
	
	//페이징 체크
	String cntSql = null;
	PreparedStatement cntStmt = null;
	
	if(word==null) {
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? OR d.dept_name LIKE ? ";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1,"%"+word+"%");
		cntStmt.setString(2,"%"+word+"%");
		cntStmt.setString(3,"%"+word+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
		if(cnt == 0) {
			cnt = 1;
		}
	}
	
	int lastPage = cnt / ROW_PER_PAGE;
	if(cnt % ROW_PER_PAGE != 0) {
		lastPage = lastPage + 1;
	}
	
	if(currentPage > lastPage) { // 페이지를 넘어선 다른 수를 입력했을 때 예외(에러) 처리
		String stringMsg = "존재하지 않는 페이지입니다.";
		out.println("<script>alert('"+stringMsg+"');</script>"); // 스크립트 alert(경고메시지) 출력
		currentPage = lastPage;
		System.out.println("go to lastPage");
			if(currentPage == 0){ // 존재하지 않는 검색어 입력시 page count 에러 처리를 위해
				currentPage = 1;
			}
		
	} else if(currentPage < 1) {
		String stringMsg = "존재하지 않는 페이지입니다.";
		out.println("<script>alert('"+stringMsg+"');</script>");
		currentPage = 1;
		System.out.println("go to firstPage");
	}
	
	int beginRow = ROW_PER_PAGE * (currentPage-1);
//---------------------------------------------------------------------------------------------------//

	//리스트 출력
	String sql = null;
	PreparedStatement stmt = null;
	if(word == null) {
		sql = "SELECT de.emp_no empNo, de.dept_no deptNo, d.dept_name deptName, e.first_name firstName, e.last_name lastName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1,beginRow);
		stmt.setInt(2,ROW_PER_PAGE);
	} else {
		sql = "SELECT de.emp_no empNo, de.dept_no deptNo, d.dept_name deptName, e.first_name firstName, e.last_name lastName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? OR d.dept_name LIKE ? ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setString(3, "%"+word+"%");
		stmt.setInt(4,beginRow);
		stmt.setInt(5,ROW_PER_PAGE);
	}

	ResultSet rs = stmt.executeQuery();

	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(rs.next()) {
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.dept = new Department();
		
		de.emp.empNo = rs.getInt("empNo");
		de.dept.deptNo = rs.getString("deptNo");
		de.dept.deptName = rs.getString("deptName");
		de.emp.firstName = rs.getString("firstName");
		de.emp.lastName = rs.getString("lastName");
		de.fromDate = rs.getString("fromDate");
		de.toDate = rs.getString("toDate");
		
		list.add(de);
	}
	
	//DeptEmp.class가 없다면
	//deptEmpMapList.jsp
	/*ArrayList<HashMap<String, Object<>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next) {
		
	}*/
%>

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>DEPT_EMP_LIST</title>
	</head>

	<body>
	<div class="container">
		<div class="mt-4 p-5 bg-info text-white rounded">
			<h1>DEPT(EMP)LIST</h1>
		</div>
		
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		
		<table class="table table-striped table-hover text-center table-bordered">
		
			<tr>
				<th class="col-sm-2">사원번호</th>
				<!-- <th class="col-sm-2">DEPT_NO</th> -->
				<th class="col-sm-2">부서명</th>
				<th class="col-sm-2">이름</th>
				<th class="col-sm-2">성</th>
				<th class="col-sm-2">계약일</th>
				<th class="col-sm-2">종료일</th>
			</tr>
			
			<%
				for(DeptEmp de : list) {
			%>
					<tr>
						<td><%=de.emp.empNo %></td>
						<td><%=de.dept.deptName %></td>
						<td><%=de.emp.firstName %></td>
						<td><%=de.emp.lastName %></td>
						<td><%=de.fromDate %></td>
						<td><%=de.toDate %></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<div>
			<%
				if(word == null) {
			%>
			<div class="d-flex justify-content-between">
					
					<div>
						<a href="<%=request.getContextPath()%>/deptEmp/insertDeptEmpForm.jsp" class="btn btn-secondary text-white btn-lg text-end">신규 작성</a>
					</div>
				
					<div>
						<a class="btn btn-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1">처음</a>
						<%
							if(currentPage>1) {
						%>
								<a class="btn btn-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>">이전</a>
						<%
							}
						%>
						<span style="text-align:center" class="text-center"><%=currentPage %> / <%=lastPage%></span>
						<%
							if(currentPage<lastPage) {
						%>
								<a class="btn btn-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>">다음</a>
						<%
							}
						%>
						<a class="btn btn-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">끝</a>
					</div>
					
					<div>
						<a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-primary text-white btn-lg text-end">Back</a>
					</div>
					
				</div>	
			<%
				} else {
			%>
					<div class="d-flex justify-content-between">
					
						<div>
							<a href="<%=request.getContextPath()%>/deptEmp/insertDeptEmpForm.jsp" class="btn btn-secondary text-white btn-lg text-end">신규 작성</a>
						</div>
					
						<div>
							<a class="btn btn-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>">처음</a>
							<%
								if(currentPage>1) {
							%>
									<a class="btn btn-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
							<%
								}
							%>
							<span style="text-align:center" class="text-center"><%=currentPage %> / <%=lastPage%></span>
							<%
								if(currentPage<lastPage) {
							%>
									<a class="btn btn-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
							<%
								}
							%>
							<a class="btn btn-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">끝</a>
						</div>
						
						<div>
							<a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-primary text-white btn-lg text-end">Back</a>
						</div>
					
					</div>
			<%
				}
			%>
			<%	
				if(word==null) {
			%>
				<div class="text-center">
					<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" method="post" class="text-center">
						<input type="text" name="currentPage" value="" placeholder="이동하려는 page 번호" style="width:200px" class="text-center">
						<button class="btn btn-dark" type="submit">이동</button>
					</form>
				</div>
			<%	
				} else {
			%>
					<div class="text-center">
					<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?&word=<%=word %>" method="post" class="text-center">
						<input type="text" name="currentPage" value="" placeholder="이동하려는 page 번호" style="width:200px" class="text-center">
						<button class="btn btn-dark" type="submit">이동</button>
					</form>
				</div>
			<%
				}
			%>
				
				
				<div class="text-center">
					<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" method="post" class="text-center">
						<input type="text" name="word" value="" placeholder="검색 단어" style="width:200px" class="text-center" id="word">
						<button class="btn btn-dark" type="submit">검색</button>
					</form>
				</div>
				
		</div>
	
	</div>
		
	</body>
</html>