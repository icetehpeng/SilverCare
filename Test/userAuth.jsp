<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>SilverCare - Login & Register</title>
    <style>
        body { font-family: Arial; background-color: #f0f4f7; text-align: center; margin-top: 40px; }
        form { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); display: inline-block; }
        input { margin: 10px; padding: 10px; width: 250px; border: 1px solid #ccc; border-radius: 5px; }
        button { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .switch { background: none; border: none; color: #007bff; text-decoration: underline; cursor: pointer; margin-top: 15px; display: block; }
        .msg { margin: 10px; color: #333; }
    </style>
    <script>
        function toggleForm() {
            const loginForm = document.getElementById("loginForm");
            const registerForm = document.getElementById("registerForm");
            loginForm.style.display = loginForm.style.display === "none" ? "block" : "none";
            registerForm.style.display = registerForm.style.display === "none" ? "block" : "none";
        }
    </script>
</head>
<body>

<h2>SilverCare Portal</h2>

<%
String jdbcURL = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
String dbUser = "neondb_owner";
String dbPass = "npg_KyB82hXZLaRm";

String msg = "";
String action = request.getParameter("action");

// Load PostgreSQL driver
try {
    Class.forName("org.postgresql.Driver");
} catch (ClassNotFoundException e) {
    msg = "❌ PostgreSQL Driver not found!";
}

if (action != null && !msg.contains("Driver not found")) {
    try (Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass)) {

        if ("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Dynamic role verification via role table
            String sql = "SELECT u.id, u.username, r.role_name " +
                         "FROM silvercare.users u " +
                         "JOIN silvercare.role r ON u.role = r.id " +
                         "WHERE u.email = ? AND u.password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Set session attributes for header.jsp
                session.setAttribute("sessUserID", rs.getInt("id"));
                session.setAttribute("sessUserName", rs.getString("username"));
                session.setAttribute("role", rs.getString("role_name")); // dynamic role from DB

                // Redirect to home.jsp after successful login
                response.sendRedirect("home.jsp");
                return; // Stop further processing
            } else {
                msg = "❌ Invalid email or password.";
            }

        } else if ("register".equals(action)) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Check if email exists
            PreparedStatement check = conn.prepareStatement(
                "SELECT * FROM silvercare.users WHERE email = ?"
            );
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                msg = "⚠️ Email already registered.";
            } else {
                // Insert new user with default role_id = 2 (Customer)
                PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO silvercare.users (username, email, password, role) VALUES (?, ?, ?, 2)"
                );
                insert.setString(1, username);
                insert.setString(2, email);
                insert.setString(3, password);
                insert.executeUpdate();
                msg = "✅ Registration successful! Please log in.";
            }
        }

    } catch (SQLException e) {
        String errMsg = e.getMessage().toLowerCase();
        if (errMsg.contains("password authentication failed") || errMsg.contains("authentication failed")) {
            msg = "❌ Database authentication failed! Check Neon DB credentials.";
        } else {
            msg = "❌ Database error: " + e.getMessage();
        }
    }
}
%>

<div class="msg"><%= msg %></div>

<form id="loginForm" action="" method="post">
    <h3>Login</h3>
    <input type="hidden" name="action" value="login">
    <input type="email" name="email" placeholder="Email" required><br>
    <input type="password" name="password" placeholder="Password" required><br>
    <button type="submit">Login</button>
    <button type="button" class="switch" onclick="toggleForm()">No account? Register here</button>
</form>

<form id="registerForm" action="" method="post" style="display:none;">
    <h3>Register</h3>
    <input type="hidden" name="action" value="register">
    <input type="text" name="username" placeholder="Username" required><br>
    <input type="email" name="email" placeholder="Email" required><br>
    <input type="password" name="password" placeholder="Password" required><br>
    <button type="submit">Register</button>
    <button type="button" class="switch" onclick="toggleForm()">Already have an account? Login</button>
</form>

</body>
</html>
