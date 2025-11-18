<%@ page session="true" %>
<header class="site-header">
    <div class="header-inner">
        <h1 class="logo">
            <a href="home.jsp">SilverCare</a>
        </h1>
        <nav class="main-nav">
            <ul>
                <li><a href="home.jsp">Home</a></li>
                <li><a href="about.jsp">About Us</a></li>
                <li><a href="serviceCategory.jsp">Services</a></li>
                <li><a href="contact.jsp">Contact Us</a></li>
                <%
                    Object roleObj = null;
                    if (session != null) {
                        roleObj = session.getAttribute("role");
                    }
                    String userRole = (roleObj != null) ? (String) roleObj : null;
                    if (userRole == null) {
                %>
                    <li><a href="login.jsp" class="button button-primary">Login</a></li>
                <%
                    } else {
                        if ("Admin".equals(userRole)) {
                %>
                    <li><a href="adminDashboard.jsp">Admin Dashboard</a></li>
                <%
                        } else if ("Customer".equals(userRole)) {
                %>
                    <li><a href="bookings.jsp">My Bookings</a></li>
                <%
                        }
                %>
                    <li><a href="../BackEnd/logout.jsp" class="button button-secondary">Logout</a></li>
                <%
                    }
                %>
            </ul>
        </nav>
    </div>
</header>
