<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"%>
<%@ page session="true" %>

<%
String jdbcURL = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
String dbUser = "neondb_owner";
String dbPass = "npg_KyB82hXZLaRm";

String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");

try {
    Class.forName("org.postgresql.Driver");

    if (username != null && email != null && password != null) {
        try (Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass)) {
            PreparedStatement check = conn.prepareStatement(
                "SELECT * FROM silvercare.users WHERE email = ?"
            );
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                response.sendRedirect("../FrontEnd/register.jsp?errCode=emailExists");
                return;
            }

            PreparedStatement insert = conn.prepareStatement(
                "INSERT INTO silvercare.users (username, email, password, role) VALUES (?, ?, ?, 2)"
            );
            insert.setString(1, username);
            insert.setString(2, email);
            insert.setString(3, password);
            insert.executeUpdate();

            response.sendRedirect("../FrontEnd/register.jsp?errCode=success");
            return;
        }
    } else {
        response.sendRedirect("../FrontEnd/register.jsp?errCode=error");
        return;
    }
} catch (ClassNotFoundException | SQLException e) {
    response.sendRedirect("../frontend/register.jsp?errCode=error");
}
%>