<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
			<%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/webserverdev_proj", "root", "rlsRms5244");
                stmt = conn.createStatement();
           %>
</body>
</html>