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
			response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
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
				String msg = "입력하지 않은 빈칸이 존재합니다."; // GET방식으로 주소창에 문자열 encoding
				System.out.println("--------------------------------------------------------------------------");
				response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+URLEncoder.encode(boardNo, "UTF-8")+"&msg="+URLEncoder.encode(msg,"UTF-8"));
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
		String updateSql = "UPDATE board SET board_title = ?, board_writer = ?, board_content = ? WHERE board_no = ?";
		PreparedStatement updateStmt = conn.prepareStatement(updateSql);
		updateStmt.setString(1, boardTitle);
		updateStmt.setString(2, boardWriter);
		updateStmt.setString(3, boardContent);
		updateStmt.setString(4, boardNo);
		
		int row = updateStmt.executeUpdate();
		if(row == 1) { // result check
			System.out.println("UPDATE Complete!!");
		} else {
			System.out.println("UPDATE False...");
		}
		System.out.println("--------------------------------------------------------------------------");
		String msg = "수정되었습니다.";
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp?&msg="+URLEncoder.encode(msg,"UTF-8"));
		return;
	} else {
		String msg = "비밀번호가 일치하지 않습니다.";
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+URLEncoder.encode(boardNo, "UTF-8")+"&msg="+URLEncoder.encode(msg,"UTF-8"));
	}
	
%>
