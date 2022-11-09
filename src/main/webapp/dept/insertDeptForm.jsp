<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>

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
		<title>DEPT FORM</title>
	</head>

	<body>
		<div class="container">
			<div class="mt-4 p-5 bg-secondary text-white rounded col-sm">
				<h1>DEPT FORM</h1>
			</div>
			<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp" method="post">
				<table class="table table-striped table-hover text-center">
					<tr>
						<th colspan="2">
							<div class="">부서 추가</div>
						</th>
					</tr>
					
					<tr>
						<td><span>부서 번호</span></td>
						<td>
							<input type="text" name="deptNo" value="" placeholder="ex)k007">
						</td>
					</tr>
					
					<tr>
						<td><span>부서 명</span></td>
						<td><input type="text" name="deptName" value=""></td>
					</tr>
					
					<tr>
						<th colspan="2">
							<button type="submit" class="btn btn-secondary text-white">INSERT</button>
							<a href="<%=request.getContextPath()%>/dept/deptlist.jsp" class="btn btn-info text-white">Back</a>
						</th>
					</tr>
					
				</table>
			</form>
		</div>
	</body>
</html>