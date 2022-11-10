<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import = "vo.*" %>

<%
	//1. 요청 분석
	String boardNo = request.getParameter("boardNo");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	
	if(request.getParameter("boardNo") == null ||
		boardNo.equals("")) {
			String msg = "잘못된 접근 방식 입니다."; // GET방식으로 주소창에 문자열 encoding
			System.out.println("--------------------------------------------------------------------------");
			response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?&msg="+URLEncoder.encode(msg,"UTF-8"));
			return;
	} else if(request.getParameter("boardNo") != null &&
			(request.getParameter("boardTitle") == null ||
			request.getParameter("boardWriter") == null ||
			request.getParameter("boardContent") == null ||
			request.getParameter("boardPw") == null ||
			boardTitle.equals("") ||
			boardWriter.equals("") ||
			boardContent.equals("") ||
			boardPw.equals("")) ) {
				String msg = "비밀번호를 입력해주세요."; // GET방식으로 주소창에 문자열 encoding
				System.out.println("--------------------------------------------------------------------------");
				response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+URLEncoder.encode(boardNo, "UTF-8")+"&msg="+URLEncoder.encode(msg,"UTF-8"));
				return;
	}
	
	//2. 
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!"); // DB connection check debuging
	
	String pwSql = "SELECT board_pw boardPw FROM board WHERE board_no = ? AND board_pw = ?";
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	pwStmt.setString(1, boardNo);
	pwStmt.setString(2, boardPw);
	ResultSet pwRs = pwStmt.executeQuery();
	if(pwRs.next()){
		String deleteSql = "DELETE FROM board WHERE board_no = ?";
		PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
		deleteStmt.setString(1, boardNo);
		
		int row = deleteStmt.executeUpdate();
		if(row == 1) { // result check
			System.out.println("DELETE Complete!!");
		} else {
			System.out.println("DELETE False...");
		}
		System.out.println("--------------------------------------------------------------------------");
		String msg = "삭제되었습니다.";
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp?&msg="+URLEncoder.encode(msg,"UTF-8"));
		
	} else {
		String msg = "비밀번호가 일치하지 않습니다.";
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+URLEncoder.encode(boardNo, "UTF-8")+"&msg="+URLEncoder.encode(msg,"UTF-8"));
		return;
	}
	
%>
