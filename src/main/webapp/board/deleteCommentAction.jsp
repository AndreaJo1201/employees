<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import = "vo.*" %>

<%
	String boardNo = request.getParameter("boardNo");
	String commentNo = request.getParameter("commentNo");
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	
	if(request.getParameter("boardNo") == null ||
		boardNo.equals("") ||
		request.getParameter("commentNo") == null ||
		commentNo.equals("")) {
			String msg = "잘못된 접근 방식 입니다.";
			System.out.println("--------------------------------------------------------------------------");
			response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
			return;
	} else if (request.getParameter("boardNo") != null &&
			request.getParameter("commentNo") != null &&
			(request.getParameter("commentContent") == null ||
			request.getParameter("commentPw") == null ||
			commentContent.equals("") ||
			commentPw.equals(""))) {
				String msg = "입력하지 않은 빈칸이 존재합니다."; // GET방식으로 주소창에 문자열 encoding
				System.out.println("--------------------------------------------------------------------------");
				response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+URLEncoder.encode(boardNo,"UTF-8")+"&commentNo="+URLEncoder.encode(commentNo,"UTF-8")+"&msg="+URLEncoder.encode(msg,"UTF-8"));
				return;
	}
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("jdbc Driver Loading Complete!"); // driver loading debuging
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println("DB Connection... Complete!"); // DB connection check debuging
	
	String pwSql = "SELECT comment_pw commentPw FROM comment WHERE comment_no = ? AND comment_pw = ?";
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	pwStmt.setString(1, commentNo);
	pwStmt.setString(2, commentPw);
	ResultSet pwRs = pwStmt.executeQuery();
	if(pwRs.next()){
		String deleteSql = "DELETE FROM comment WHERE comment_no = ?";
		PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
		deleteStmt.setString(1, commentNo);
		
		int row = deleteStmt.executeUpdate();
		if(row == 1) { // result check
			System.out.println("DELETE Complete!!");
		} else {
			System.out.println("DELETE False...");
		}
		System.out.println("--------------------------------------------------------------------------");
		String msg = "삭제되었습니다.";
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+URLEncoder.encode(boardNo, "UTF-8")+"&msg="+URLEncoder.encode(msg,"UTF-8"));
		
	} else {
		String msg = "비밀번호가 일치하지 않습니다.";
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+URLEncoder.encode(boardNo, "UTF-8")+"&commentNo="+URLEncoder.encode(commentNo,"UTF-8")+"&msg="+URLEncoder.encode(msg,"UTF-8"));
		return;
	}
%>
