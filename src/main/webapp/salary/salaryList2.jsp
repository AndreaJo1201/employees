<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %> <%// java.util.HashMap, java.util.ArrayList %>
<%@ page import = "vo.*" %>

<%
	//Map 타입 이해
	//Map 사용 안하고 클래스 사용시
	/*
	Class Student {
		public string name;
		public int age; 
	}

	Student s = new Student();
	s.name = "math";
	s.age = 29;
	System.out.println(s.name);
	System.out.println(s.age);
	*/
	
	//class 사용안하고 map 사용시
	/*
	HashMap<String, Object> m = new HasMap<String, Object>();
	m.put("name", "math");
	m.put("age", 29);
	System.out.println(m.get("name"));
	System.out.println(m.get("age"));
	*/
	
	//집단일시
	/*
	-Class 사용-
	
	Student s1 = new Student();
	s1.name = "eng";
	s1.age = "26";
	Student s2 = new Student();
	s2.name="kor";
	s2.age="27";
	
	ArrayList<Student> studentList = new ArrayList<Student>();
	studentList.add(s1);
	studentList.add(s2);
	System.out.println("studentList 출력 ");
	for(Student stu : studentList) {
		System.out.println(stu.name);
		System.out.println(stu.age);
	}
	----------------------------------------------------------------------
	-HashMap 사용-
	HashMap<String, Object> m1 = newHashMap<String, Object>();
	m.put("name", "eng");
	m.put("age", 26);
	HashMap<String, Object> m2 = newHashMap<String, Object>();
	m.put("name", "kor");
	m.put("age", 27);
	
	ArrayList<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
	mapList.add(m1);
	mapList.add(m2)
	for(HashMap<String, Object> hm : mapList) {
		System.out.println(hm.get("name"));
		System.out.println(hm.get("age"));
	}
	
	
	*/
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>

	<body>
		
	</body>
</html>