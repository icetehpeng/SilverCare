<%@ page import="java.sql.*,java.util.*" %>
<%@ page session="true" %>
<%
	String jdbcURL = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
	String dbUser = "neondb_owner";
	String dbPass = "npg_KyB82hXZLaRm";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String msg = "";
    boolean isSuccess = false;
    List<Map<String, Object>> categories = new ArrayList<>();

    // Handle add category
    if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter("action") != null) {
        String action = request.getParameter("action");
        
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

            if("add".equals(action)) {
                String categoryName = request.getParameter("category_name");
                if(categoryName != null && !categoryName.trim().isEmpty()) {
                    ps = conn.prepareStatement("INSERT INTO silvercare.service_category (category_name) VALUES (?)");
                    ps.setString(1, categoryName.trim());
                    ps.executeUpdate();
                    msg = "✅ Category added successfully!";
                    isSuccess = true;
                } else {
                    msg = "❌ Category name cannot be empty!";
                    isSuccess = false;
                }
            } else if("delete".equals(action)) {
                String deleteId = request.getParameter("delete_id");
                if(deleteId != null) {
                    // Check if category is being used by any services
                    ps = conn.prepareStatement("SELECT COUNT(*) as count FROM silvercare.service WHERE category_id = ?");
                    ps.setInt(1, Integer.parseInt(deleteId));
                    rs = ps.executeQuery();
                    if(rs.next() && rs.getInt("count") > 0) {
                        msg = "❌ Cannot delete category. It is being used by existing services.";
                        isSuccess = false;
                    } else {
                        if(rs != null) rs.close();
                        if(ps != null) ps.close();
                        ps = conn.prepareStatement("DELETE FROM silvercare.service_category WHERE id = ?");
                        ps.setInt(1, Integer.parseInt(deleteId));
                        ps.executeUpdate();
                        msg = "✅ Category deleted successfully!";
                        isSuccess = true;
                    }
                }
            }
        } catch(Exception e) {
            msg = "❌ Error: " + e.getMessage();
            isSuccess = false;
        } finally {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(conn != null) conn.close();
        }
    }

    // Load all categories
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);
        ps = conn.prepareStatement("SELECT id, category_name FROM silvercare.service_category ORDER BY category_name");
        rs = ps.executeQuery();

        while(rs.next()) {
            Map<String, Object> category = new HashMap<>();
            category.put("id", rs.getInt("id"));
            category.put("name", rs.getString("category_name"));
            categories.add(category);
        }
    } catch(Exception e) {
        if(msg.isEmpty()) {
            msg = "⚠️ Unable to load categories: " + e.getMessage();
        }
        isSuccess = false;
    } finally {
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        if(conn != null) conn.close();
    }

    String statusClass = isSuccess ? "status-message status-success" : "status-message status-error";
    boolean shouldRefresh = isSuccess && !msg.isEmpty();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Categories</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: var(--color-background);
        }
        .modal-container {
            padding: calc(var(--spacing-unit) * 2);
            max-width: 800px;
            margin: 0 auto;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: calc(var(--spacing-unit) * 2);
            padding-bottom: calc(var(--spacing-unit) * 1);
            border-bottom: 2px solid rgba(75, 99, 209, 0.1);
        }
        .modal-header h2 {
            margin: 0;
            color: var(--color-primary-dark);
            font-size: 1.8rem;
        }
        .close-btn {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--color-muted);
            padding: 0.5rem;
            line-height: 1;
            transition: color 0.2s ease;
        }
        .close-btn:hover {
            color: var(--color-primary-dark);
        }
        .add-category-section {
            background: var(--color-surface);
            padding: calc(var(--spacing-unit) * 2);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-soft);
            border: 1px solid rgba(75, 99, 209, 0.08);
            margin-bottom: calc(var(--spacing-unit) * 2);
        }
        .add-category-section h3 {
            margin: 0 0 calc(var(--spacing-unit) * 1.5) 0;
            color: var(--color-primary-dark);
            font-size: 1.3rem;
        }
        .add-category-form {
            display: flex;
            gap: calc(var(--spacing-unit) * 1);
            align-items: flex-end;
        }
        .add-category-form .input-group {
            flex: 1;
            margin: 0;
        }
        .categories-table-section {
            background: var(--color-surface);
            padding: calc(var(--spacing-unit) * 2);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-soft);
            border: 1px solid rgba(75, 99, 209, 0.08);
        }
        .categories-table-section h3 {
            margin: 0 0 calc(var(--spacing-unit) * 1.5) 0;
            color: var(--color-primary-dark);
            font-size: 1.3rem;
        }
        .categories-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid rgba(75, 99, 209, 0.18);
            border-radius: var(--radius-sm);
            overflow: hidden;
        }
        .categories-table thead {
            background: rgba(75, 99, 209, 0.1);
        }
        .categories-table th,
        .categories-table td {
            padding: 0.9rem 1rem;
            text-align: left;
            border-bottom: 1px solid rgba(75, 99, 209, 0.18);
        }
        .categories-table th {
            color: var(--color-primary-dark);
            font-weight: 600;
        }
        .categories-table tbody tr:hover {
            background: rgba(75, 99, 209, 0.06);
        }
        .categories-table tbody tr:last-child td {
            border-bottom: none;
        }
        .empty-state {
            text-align: center;
            color: var(--color-muted);
            padding: calc(var(--spacing-unit) * 3);
            font-style: italic;
        }
    </style>
</head>
<body>
<div class="modal-container">
    <div class="modal-header">
        <h2>Manage Categories</h2>
        <button class="close-btn" onclick="window.close()" title="Close">×</button>
    </div>

    <% if(!msg.isEmpty()) { %>
    <p class="<%= statusClass %>"><%= msg %></p>
    <% } %>

    <div class="add-category-section">
        <h3>Add New Category</h3>
        <form method="post" class="add-category-form">
            <input type="hidden" name="action" value="add">
            <div class="input-group">
                <label for="category_name">Category Name</label>
                <input type="text" id="category_name" name="category_name" placeholder="Enter category name" required>
            </div>
            <button type="submit" class="button button-primary">Add Category</button>
        </form>
    </div>

    <div class="categories-table-section">
        <h3>All Categories</h3>
        <% if(categories.isEmpty()) { %>
        <p class="empty-state">No categories found. Add your first category above.</p>
        <% } else { %>
        <table class="categories-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Category Name</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for(Map<String, Object> category : categories) { %>
                <tr>
                    <td><%= category.get("id") %></td>
                    <td><strong><%= category.get("name") %></strong></td>
                    <td>
                        <form method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this category? This action cannot be undone.')">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="delete_id" value="<%= category.get("id") %>">
                            <button type="submit" class="chip-button chip-button-danger">🗑️ Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>

<% if(shouldRefresh) { %>
<script>
    setTimeout(function() {
        window.location.reload();
    }, 1500);
</script>
<% } %>
</body>
</html>

