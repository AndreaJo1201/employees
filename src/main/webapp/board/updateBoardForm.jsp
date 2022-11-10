<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import ="java.util.*" %>

<%
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}

%>


<%
	//1. 요청 분석
	System.out.println("--------------------------------UPDATELIST--------------------------------");
	String boardNo = request.getParameter("boardNo");
	System.out.println("boardNo:"+boardNo); // boardNo get consol print : debuging	
	
	if(boardNo == null) { // updateDeptForm.jsp 주소창에 직접 호출하면 deptNo은 null 값임.
		System.out.println("--------------------------------------------------------------------------");
		String msg = "잘못된 접근 방식 입니다."; // GET방식으로 주소창에 문자열 encoding
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
		return;
	}
		
	//2.
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection ... Complete!"); // db connection debuging
	
	int intBoardNo = Integer.parseInt(boardNo);
	
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, intBoardNo);
	
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	
	if(rs.next()){
		board = new Board();
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	System.out.println("UPDATE boardNo :"+boardNo); // boardNo check
	System.out.println("UPDATE boardTitle :"+board.boardTitle); // boardTitle check
	System.out.println("--------------------------------------------------------------------------");
	//3.




%>



<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>UPDATE BOARD FORM</title>
	</head>

	<div class="container">
		<div class="mt-4 p-5 bg-success text-white rounded col-sm">
			<h1>UPDATE BOARD FORM</h1>
		</div>
		
		<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post" id="form">
			<table class="table table-striped table-hover">
				<tr class="text-center">
					<th colspan="2">
						<div>내용 수정</div>
					</th>
				</tr>
				<tr>
					<td class="col-sm-1 text-center"><span>번호</span></td>
					<td class="col-sm-1">
						<input type="text" name="boardNo" value="<%=boardNo%>" readonly="readonly">
					</td>
				</tr>
				
				<tr>
					<td class="col-sm-1 text-center"><span>제목</span></td>
					<td class="col-sm-11">
						<input type="text" name="boardTitle" value="<%=board.boardTitle %>" maxlength="500">
					</td>
				</tr>
				
				<tr>
					<td class="col-sm-1 text-center"><span>내용</span></td>
					<td class="col-sm-11">
						<textarea rows="5" cols="135" name="boardContent"><%=board.boardContent %></textarea>
					</td>
				</tr>
				
				<tr>
					<td class="col-sm-1 text-center"><span>작성자</span></td>
					<td class="col-sm-11">
						<input type="text" name="boardWriter" value="<%=board.boardWriter %>" maxlength="50">
					</td>
				</tr>
				
				<tr>
					<td class="col-sm-1 text-center"><span>작성일</span></td>
					<td class="col-sm-11">
						<span><%=board.createdate %></span>
					</td>
				</tr>
				
				<tr>
					<td class="col-sm-1 text-center"><span>PW</span></td>
					<td class="col-sm-11">
						<input type="password" name="boardPw" value="" maxlength="50" placeholder="비밀번호 입력">
					</td>
				</tr>
						
			</table>
		</form>
		
		<div class="d-flex justify-content-between">
			<div>
				<button type="submit" form="form" class="btn btn-success text-white">UPDATE</button>
			</div>
			<div>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>" class="btn btn-info text-white">Back</a>
			</div>
		</div>
	
	</div>
		
	</body>
</html>