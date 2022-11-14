<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import =" vo.*" %>
<%@ page import="java.net.*" %>

<%
	//1.
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}

	String boardNo = request.getParameter("boardNo");
	
	if(request.getParameter("boardNo") == null ||
		boardNo.equals("")) {
			String msg = "잘못된 접근 방식 입니다."; // GET방식으로 주소창에 문자열 encoding
			System.out.println("--------------------------------------------------------------------------");
			response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
			return;
		}

	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	//2.
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!"); // DB connection check debuging
	
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	
	if(rs.next()){
		board = new Board();
		board.boardNo = Integer.parseInt(boardNo);
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
	
	//2-1 comment data
	
	int rowPerPage = 5;
	int beginRow = (currentPage-1)%rowPerPage;
	
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent, createdate FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	
	commentStmt.setString(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, rowPerPage);
	
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){
		Comment c = new Comment(); 
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		c.createdate = commentRs.getString("createdate");
		commentList.add(c);
	}
	
	//2-2 comment page -> last page
	String cntSql = "SELECT COUNT(*) FROM comment";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("COUNT(*)");
	}
	int lastPage = cnt / rowPerPage;
	if(cnt % rowPerPage != 0 ){
		lastPage = lastPage + 1;
	} else if(lastPage == 0) {
		lastPage = 1;
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
			
			
			<table class="table table-hover text-center table-bordered" >
				<tr>
					<th colspan="5">CommentList</th>
				</tr>
				<%
					for(Comment c : commentList) {
				%>
						<tr>
							<td class="col-sm-1"><%=c.commentNo%></td>
							<td class="col-sm-7"><%=c.commentContent %></td>
							<td class="col-sm-2"><%=c.createdate %></td>
							<td class="col-sm-1"><a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?commentNo=<%=c.commentNo%>&currentPage=<%=currentPage%>&boardNo=<%=boardNo%>">수정</a></td>
							<td class="col-sm-1"><a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&currentPage=<%=currentPage%>&boardNo=<%=boardNo%>">삭제</a></td>
						</tr>
				<%
					}
				%>
			</table>
			
			<div class="d-flex justify-content-center">
				<!-- paging code -->
				<div class="text-center">
					<a class="btn btn-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=1">처음</a>
					<%
						if(currentPage>1) {
					%>
							<a class="btn btn-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage-1%>">이전</a>
					<%
						}
					%>
					<span style="text-align:center" class="text-center"><%=currentPage %> / <%=lastPage %></span>
					<%
						if(currentPage<lastPage) {
					%>
							<a class="btn btn-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage+1%>">다음</a>
					<%		
						}
					%>
					<a class="btn btn-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=lastPage%>">끝</a>
				</div>
			
			</div>
			
			<form method="post" action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
				<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
				<input type="hidden" name="currentPage" value="<%=currentPage%>">
				<table class="table table-hover table-bordered">
					<tr>
						<td class="col-sm-1 text-center">내용</td>
						<td class="col-sm-11">
							<textarea rows="3" cols="80" name="commentContent" placeholder="댓글작성"></textarea>
						</td>
					</tr>
					<tr>
						<td class="col-sm-1 text-center">PW</td>
						<td>
							<input type="password" name="commentPw" value="">
							<button type="submit" class="btn btn-dark">입력</button>
					</tr>
				</table>
			</form>
			
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