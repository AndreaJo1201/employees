<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import="vo.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
	
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}
	
%>

<%
	//1. 요청 분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//2. 요청 처리
	final int ROW_PER_PAGE = 10; // 페이지당 출력할 데이터의 개수
	
	System.out.println("--------------------------------BOARD_LIST--------------------------------");
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("Driver loading complete!!"); //driver debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!!"); //conn debuging
	
	//last page 구하기
	String cntSql = "SELECT COUNT(*) cnt FROM board";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	//올림 시 double 형태로 반환
	//int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
	int lastPage = cnt / ROW_PER_PAGE;
	if(cnt % ROW_PER_PAGE != 0) {
		lastPage = lastPage + 1;
	}
	
	if(currentPage > lastPage) { // 페이지를 넘어선 다른 수를 입력했을 때 예외(에러) 처리
		String stringMsg = "존재하지 않는 페이지입니다.";
		out.println("<script>alert('"+stringMsg+"');</script>"); // 스크립트 alert(경고메시지) 출력
		currentPage = lastPage;
		System.out.println("go to lastPage");
		
	} else if(currentPage < 1) {
		String stringMsg = "존재하지 않는 페이지입니다.";
		out.println("<script>alert('"+stringMsg+"');</script>");
		currentPage = 1;
		System.out.println("go to firstPage");
	}
	
	int beginRow = ROW_PER_PAGE * (currentPage-1); //LIMIT beginRow, ROW_PER_PAGE;
	
	//리스트 부르기
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery();
	
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(listRs.next()) {
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}
	

	
	//3. 출력



%>

<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1" charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<title>BOARD LIST</title>
	</head>

	<body>
		<div class="container">
			<div class="mt-4 p-5 bg-info text-white rounded">
					<h1>BOARD</h1>
			</div>
			
			<div>
				<jsp:include page="/inc/menu.jsp"></jsp:include>
			</div>
			
			<table class="table table-striped table-hover text-center table-bordered">
				<tr>
					<th class="col-sm-1">번호</th>
					<th class="col-sm-11">제목</th>
				</tr>
				
				<%
					for(Board b : boardList) {
				%>
					<tr>
						<td class="col-sm-2"><%=b.boardNo %></td>
						<!-- 제목 클릭시 상세보기 이동 -->
						<td class="col-sm-10">
						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle%></a>
						</td>
					</tr>
				<%		
					}
				%>
			</table>
			
			<!-- 페이징 -->
			
			<div>
				
				<div class="d-flex justify-content-between">
					
					<div>
						<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp" class="btn btn-secondary text-white btn-lg text-end">게시글 작성</a>
					</div>
				
					<div>
						<a class="btn btn-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
						<%
							if(currentPage>1) {
						%>
								<a class="btn btn-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
						<%
							}
						%>
						<span style="text-align:center" class="text-center"><%=currentPage %> / <%=lastPage %></span>
						<%
							if(currentPage<lastPage) {
						%>
								<a class="btn btn-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>
						<%
							}
						%>
						<a class="btn btn-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">끝</a>
					</div>
					
					<div>
						<a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-primary text-white btn-lg text-end">Back</a>
					</div>
					
				</div>
				
				<div class="text-center">
					<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post" class="text-center">
						<input type="text" name="currentPage" value="" placeholder="이동하려는 page 번호" style="width:200px" class="text-center">
						<button class="btn btn-dark" type="submit">이동</button>
					</form>
				</div>
				
			</div>
			
		</div>
		
	</body>
</html>