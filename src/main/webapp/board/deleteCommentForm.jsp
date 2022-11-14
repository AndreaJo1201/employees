<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import = "vo.*" %>

<%
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}

%>



<%
	// 1. 요청분석
	System.out.println("--------------------------------UPDATELIST--------------------------------");
	String commentNo = request.getParameter("commentNo");
	String boardNo = request.getParameter("boardNo");
	
	if(boardNo == null ||
		commentNo == null) { // updateDeptForm.jsp 주소창에 직접 호출하면 deptNo은 null 값임.
		System.out.println("--------------------------------------------------------------------------");
		String msg = "잘못된 접근 방식 입니다."; // GET방식으로 주소창에 문자열 encoding
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
		return;
	}
	
	String msg = request.getParameter("msg");
	
	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); 	
	// 쿼리문 작성
	String sql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, createdate FROM comment WHERE comment_no=? AND board_no=? ";
	// 쿼리 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 쿼리문 ?값 지정
	stmt.setString(1, commentNo);
	stmt.setString(2, boardNo);
	// 쿼리 실행
	ResultSet rs = stmt.executeQuery();
	
	// rs반복해서 Content랑 createdate 참조값 저장하기
	String commentContent = null;
	String createdate = null;
	while(rs.next()) {
		commentContent = rs.getString("commentContent");
		createdate = rs.getString("createdate");
	}	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>DELETE COMMENT FORM</title>
	</head>
	<body>
	<div class="container">
		<div class="mt-4 p-5 bg-danger text-white rounded col-sm">
			<h1>DELETE COMMENT FORM</h1>
		</div>
		
		<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp" method="post" id="form">
			<table class="table table-striped table-hover">
				<tr class="text-center">
					<th colspan="2">
						<div>내용 삭제</div>
					</th>
				</tr>
				<tr>
					<td class="col-sm-12" colspan="2">
						<input type="hidden" name="commentNo" value="<%=commentNo%>">
						<input type="hidden" name="boardNo" value="<%=boardNo%>">
					</td>
				</tr>
				<tr>
					<td class="col-sm-1 text-center"><span>내용</span></td>
					<td class="col-sm-11">
						<textarea rows="3" cols="100" name="commentContent" readonly="readonly"><%=commentContent %></textarea>
					</td>
				</tr>
				<tr>
					<td class="col-sm-1 text-center"><span>PW</span></td>
					<td class="col-sm-11">
						<input type="password" name="commentPw" value="" maxlength="50" placeholder="비밀번호입력">
					</td>
				</tr>
			</table>
		
		</form>
		
		<div class="d-flex justify-content-between">
			<div>
				<button type="submit" form="form" class="btn btn-danger text-white">DELETE</button>
			</div>
			<div>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>" class="btn btn-info text-white">Back</a>
			</div>
		</div>

	</div>

	</body>
</html>