<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>

<%
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}
%>

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>INSERT BOARD FORM</title>
	</head>

	<body>
		<div class="container">
			<div class="mt-4 p-5 bg-secondary text-white rounded col-sm">
				<h1>INSERT BOARD FORM</h1>
			</div>
			<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
				<table class="table table-striped table-bordered">
					<tr class="text-center">
						<th colspan="2">게시글 작성</th>
					</tr>
					
					<tr>
						<td class="col-sm-1 text-center">제목</td>
						<td class="col-sm-11"><input type="text" name="boardTitle" value="" maxlength="500"></td>
					</tr>
					
					<tr>
						<td class="col-sm-1 text-center text-align-center">내용</td>
						<td class="col-sm-11"><textarea rows="5" cols="135" name="boardContent" placeholder="내용을 입력해주세요."></textarea></td>
					</tr>
					
					<tr>
						<td class="col-sm-1 text-center">작성자</td>
						<td class="col-sm-11"><input type="text" name="boardWriter" value="" maxlength="50"></td>
					</tr>
					
					<tr>
						<td class="col-sm-1 text-center">PW</td>
						<td class="col-sm-11"><input type="password" name="boardPw" value="" maxlength="50"></td>
					</tr>
					
					
					<tr>
						<th colspan="2">
							<button type="submit" class="btn btn-secondary text-white">INSERT</button>
							<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-info text-white">Back</a>
						</th>
					</tr>
				
				</table>
			</form>
			
			
		</div>
		
	</body>
</html>