<%@ page import="java.sql.*,java.util.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Enforce admin-only access
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp?errCode=unauthorized");
        return;
    }
    if (!"Admin".equals(role)) {
        response.sendRedirect("home.jsp?errCode=forbidden");
        return;
    }

    String jdbcURL = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
    String dbUser = "neondb_owner";
    String dbPass = "npg_KyB82hXZLaRm";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List<Map<String, Object>> services = new ArrayList<>();
    List<Map<String, Object>> users = new ArrayList<>();

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        // Load services
        String sql = "SELECT s.id, s.service_name, s.description, s.price, c.category_name " +
                     "FROM silvercare.service s " +
                     "JOIN silvercare.service_category c ON s.category_id = c.id " +
                     "ORDER BY s.id";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> service = new HashMap<>();
            service.put("id", rs.getInt("id"));
            service.put("service_name", rs.getString("service_name"));
            service.put("description", rs.getString("description"));
            service.put("price", rs.getDouble("price"));
            service.put("category_name", rs.getString("category_name"));
            services.add(service);
        }

        // Close previous result set and statement
        if(rs != null) rs.close();
        if(ps != null) ps.close();

        // Load users/clients
        String userSql = "SELECT u.id, u.username, u.email, r.role_name " +
                         "FROM silvercare.users u " +
                         "JOIN silvercare.role r ON u.role = r.id " +
                         "ORDER BY u.id";
        ps = conn.prepareStatement(userSql);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> user = new HashMap<>();
            user.put("id", rs.getInt("id"));
            user.put("username", rs.getString("username"));
            user.put("email", rs.getString("email"));
            user.put("role_name", rs.getString("role_name"));
            users.add(user);
        }

    } catch(Exception e) {
        out.println("<p style='color:red'>❌ Error loading data: " + e.getMessage() + "</p>");
    } finally {
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        if(conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - SilverCare</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .dashboard-tabs {
            display: flex;
            gap: calc(var(--spacing-unit) * 0.5);
            margin-bottom: calc(var(--spacing-unit) * 2);
            border-bottom: 2px solid rgba(75, 99, 209, 0.1);
        }
        .dashboard-tab {
            background: none;
            border: none;
            padding: calc(var(--spacing-unit) * 1) calc(var(--spacing-unit) * 1.5);
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-muted);
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: all 0.2s ease;
            font-family: inherit;
        }
        .dashboard-tab:hover {
            color: var(--color-primary-dark);
        }
        .dashboard-tab.active {
            color: var(--color-primary-dark);
            border-bottom-color: var(--color-primary);
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<main class="dashboard-wrapper">
    <section class="container">
        <div class="dashboard-header">
            <div class="dashboard-title">
                <p class="eyebrow-text">Administration</p>
                <h1>Admin Dashboard</h1>
                <p>Manage services and view client information.</p>
            </div>
            <div class="dashboard-actions">
                <button class="button button-secondary button-compact" onclick="window.open('editCategory.jsp','EditCategory','width=900,height=700,scrollbars=yes')">
                    📁 Manage Categories
                </button>
                <button class="button button-primary button-compact" onclick="window.open('addService.jsp','AddService','width=500,height=400')">
                    + Add Service
                </button>
            </div>
        </div>

        <div class="dashboard-tabs">
            <button class="dashboard-tab active" onclick="showTab('services', this)">Services</button>
            <button class="dashboard-tab" onclick="showTab('users', this)">Client Information</button>
        </div>

        <!-- Services Tab -->
        <div id="services-tab" class="tab-content active">
            <div class="dashboard-card">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Service Name</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if(services.isEmpty()){
                        %>
                        <tr>
                            <td colspan="6" class="table-empty-state">
                                No services available yet. Click "Add Service" to create your first offering.
                            </td>
                        </tr>
                        <%
                            } else {
                                for(Map<String,Object> s : services){
                        %>
                        <tr>
                            <td><%= s.get("id") %></td>
                            <td><%= s.get("service_name") %></td>
                            <td><%= s.get("category_name") %></td>
                            <td><%= s.get("description") %></td>
                            <td>$<%= s.get("price") %></td>
                            <td>
                                <div class="table-actions">
                                    <button class="chip-button chip-button-primary"
                                            onclick="window.open('updateService.jsp?id=<%=s.get("id")%>','UpdateService','width=500,height=400')">
                                        ✏️ Edit
                                    </button>
                                    <form method="post" action="adminDashboard.jsp" class="inline-form">
                                        <input type="hidden" name="delete_id" value="<%=s.get("id")%>">
                                        <button class="chip-button chip-button-danger" type="submit" onclick="return confirm('Are you sure?')">
                                            🗑️ Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Users/Clients Tab -->
        <div id="users-tab" class="tab-content">
            <div class="dashboard-card">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if(users.isEmpty()){
                        %>
                        <tr>
                            <td colspan="4" class="table-empty-state">
                                No users found in the system.
                            </td>
                        </tr>
                        <%
                            } else {
                                for(Map<String,Object> u : users){
                        %>
                        <tr>
                            <td><%= u.get("id") %></td>
                            <td><strong><%= u.get("username") %></strong></td>
                            <td><%= u.get("email") %></td>
                            <td>
                                <span class="chip-button" style="background: <%= "Admin".equals(u.get("role_name")) ? "rgba(75, 99, 209, 0.2)" : "rgba(16, 185, 129, 0.2)" %>; color: <%= "Admin".equals(u.get("role_name")) ? "#3b4fb5" : "#047857" %>;">
                                    <%= u.get("role_name") %>
                                </span>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</main>

<script>
function showTab(tabName, element) {
    // Hide all tab contents
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Remove active class from all tabs
    document.querySelectorAll('.dashboard-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Show selected tab content
    document.getElementById(tabName + '-tab').classList.add('active');
    
    // Add active class to clicked tab
    element.classList.add('active');
}
</script>

<%@ include file="footer.html" %>

<%
    // Handle delete
    String deleteId = request.getParameter("delete_id");
    if(deleteId != null){
        try {
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);
            ps = conn.prepareStatement("DELETE FROM silvercare.service WHERE id = ?");
            ps.setInt(1, Integer.parseInt(deleteId));
            ps.executeUpdate();
            response.sendRedirect("adminDashboard.jsp");
        } catch(Exception e){
            out.println("<p style='color:red'>❌ Error deleting service: "+e.getMessage()+"</p>");
        } finally {
            if(ps!=null) ps.close();
            if(conn!=null) conn.close();
        }
    }
%>
</body>
</html>
