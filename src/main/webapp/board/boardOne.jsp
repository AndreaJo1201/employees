<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import =" vo.*" %>

<%
	//1.
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	//2.
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!"); // DB connection check debuging
	
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	
	if(rs.next()){
		board = new Board();
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
	//3.
%>

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>Insert title here</title>
	</head>

	<body>
		<div class="container">
			
			<div class="mt-4 p-5 bg-info text-white rounded">
					<h1>상세 내용</h1>
			</div>
			
			<div>
				<jsp:include page="/inc/menu.jsp"></jsp:include>
			</div>
		
			<table class="table table-hover text-center table-bordered">
				<tr>
					<th colspan="2">상세 내용 보기</th>
				</tr>
				<tr>
					<td class="col-sm-1">번호</td>
					<td class="col-sm-11"><%=boardNo %></td>
				</tr>
				<tr>
					<td class="col-sm-1">제목</td>
					<td class="col-sm-11"><%=board.boardTitle %></td>
				</tr>
				<tr>
					<td class="col-sm-1">내용</td>
					<td class="col-sm-11"><%=board.boardContent %></td>
				</tr>
				<tr>
					<td class="col-sm-1">작성자</td>
					<td class="col-sm-11"><%=board.boardWriter %></td>
				</tr>
				<tr>
					<td class="col-sm-1">작성일</td>
					<td class="col-sm-11"><%=board.createdate %></td>
				</tr>
			</table>
			
			<div class="d-flex justify-content-between">
				<div>
					<a class="btn btn-success text-white" href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>">수정</a>
					<a class="btn btn-danger" href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>">삭제</a>
				</div>
				<div>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-info text-white btn-lg text-end">Back</a>
				</div>
			</div>
		</div>
		
	</body>
</html>