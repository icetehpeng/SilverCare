<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Neon DB Credential Test</title>
</head>
<body>
<h2>Neon PostgreSQL Credential Test</h2>

<%
    String url = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
    String user = "neondb_owner"; // replace with your Neon username
    String password = "npg_KyB82hXZLaRm"; // replace with your Neon password

    Connection conn = null;

    try {
        // Load driver
        Class.forName("org.postgresql.Driver");
        out.println("<p>Driver loaded successfully!</p>");

        // Attempt connection
        conn = DriverManager.getConnection(url, user, password);
        if (conn != null) {
            out.println("<p style='color:green;'>Connected successfully! Credentials are correct.</p>");
        } else {
            out.println("<p style='color:red;'>Connection failed! Credentials may be incorrect.</p>");
        }

    } catch (ClassNotFoundException e) {
        out.println("<p style='color:red;'>PostgreSQL JDBC Driver not found!</p>");
        out.println("<pre>" + e.toString() + "</pre>");
    } catch (SQLException e) {
        String msg = e.getMessage().toLowerCase();
        if (msg.contains("password authentication failed") || msg.contains("authentication failed")) {
            out.println("<p style='color:red;'>Authentication failed! Username or password is incorrect.</p>");
        } else {
            out.println("<p style='color:red;'>Connection failed due to SQL error.</p>");
        }
        out.println("<pre>" + e.toString() + "</pre>");
    } finally {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { /* ignore */ }
        }
    }
%>

</body>
</html>
