<%@page import="java.net.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import ="java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>

<%
	System.out.println("--------------------------------INSERTBOARD--------------------------------");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	String boardWriter = request.getParameter("boardWriter");
	
	//제목, 내용, 비밀번호 미입력 또는 insertBoardAction.jsp로 강제로 넘어왔을 경우
	//insertBoardAction.jsp로 이동
	if(request.getParameter("boardTitle") == null ||
		request.getParameter("boardContent") == null ||
		request.getParameter("boardPw") == null ||
		request.getParameter("boardWriter") == null ||
		boardTitle.equals("")||
		boardContent.equals("")||
		boardPw.equals("") ||
		boardWriter.equals("")) {
			String msg = "미 입력한 항목이 있습니다."; // GET방식으로 주소창에 문자열 encoding
			System.out.println("---------------------------------------------------------------------------");
			response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
			return;
		}
	System.out.println(boardTitle+"<-boardTitle / "+boardPw+"<-boardPw"); // title, pw check
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!"); // DB connection check debuging
	
	String insSql = "INSERT INTO board (board_title, board_content, board_writer, board_pw, createdate) Values(?, ?, ?, ?, CURDATE())";
	PreparedStatement insStmt = conn.prepareStatement(insSql);
	
	insStmt.setString(1,boardTitle);
	insStmt.setString(2,boardContent);
	insStmt.setString(3,boardWriter);
	insStmt.setString(4,boardPw);
	
	System.out.println("Insert board_title : "+boardTitle);
	System.out.println("Insert board_Content : "+boardContent);
	System.out.println("Insert board_writer : "+boardWriter);
	System.out.println("Insert board_pw : "+boardPw);
	
	int row = insStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("Insert Complete");
	} else {
		System.out.println("Insert False...");
	}
	System.out.println("---------------------------------------------------------------------------");
	
	//3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>