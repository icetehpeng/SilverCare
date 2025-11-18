<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"%>
<%@ page session="true" %>

<%
    String jdbcURL = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
    String dbUser = "neondb_owner";
    String dbPass = "npg_KyB82hXZLaRm";
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
        response.sendRedirect("../FrontEnd/login.jsp?errCode=invalidLogin");
        return;
    }

    try {
        Class.forName("org.postgresql.Driver");

        try (Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass)) {
            String sql = "SELECT u.id, u.username, r.role_name " +
                         "FROM silvercare.users u " +
                         "JOIN silvercare.role r ON u.role = r.id " +
                         "WHERE u.email = ? AND u.password = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("sessUserID", rs.getInt("id"));
                session.setAttribute("sessUserName", rs.getString("username"));
                session.setAttribute("role", rs.getString("role_name"));

                String role = rs.getString("role_name");
                if ("Admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("../FrontEnd/adminDashboard.jsp");
                } else {
                    response.sendRedirect("../FrontEnd/home.jsp");
                }
                return;
            } else {
                response.sendRedirect("../FrontEnd/login.jsp?errCode=invalidLogin");
                return;
            }
        }
    } catch (ClassNotFoundException e) {
        out.println("<h3 style='color:red;'>PostgreSQL Driver not found!</h3>");
    } catch (SQLException e) {
        out.println("<h3 style='color:red;'>Database error: " + e.getMessage() + "</h3>");
    }
%>
