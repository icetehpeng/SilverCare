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

    if(request.getMethod().equalsIgnoreCase("POST")){
        String name = request.getParameter("service_name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String category_id = request.getParameter("category_id");

        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

            ps = conn.prepareStatement("INSERT INTO silvercare.service (service_name, description, price, category_id) VALUES (?,?,?,?)");
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, Double.parseDouble(price));
            ps.setInt(4, Integer.parseInt(category_id));
            ps.executeUpdate();
            msg = "✅ Service added successfully!";
            isSuccess = true;
        } catch(Exception e){
            msg = "❌ Error: "+e.getMessage();
            isSuccess = false;
        } finally {
            if(ps!=null) ps.close();
            if(conn!=null) conn.close();
            ps = null;
            conn = null;
        }
    }

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
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Service</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<main class="dashboard-wrapper">
    <section class="container container-narrow">
        <div class="dashboard-card form-card">
            <div class="dashboard-title">
                <p class="eyebrow-text">Administration</p>
                <h1>Add New Service</h1>
                <p>Provide the details for the new service and assign it to a category.</p>
            </div>

            <% if(!msg.isEmpty()) { %>
            <p class="<%= statusClass %>"><%= msg %></p>
            <% } %>

            <form method="post" class="form-grid">
                <div class="input-group">
                    <label for="service_name">Service Name</label>
                    <input type="text" id="service_name" name="service_name" placeholder="Enter service name" required>
                </div>

                <div class="input-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" placeholder="Describe the service" required></textarea>
                </div>

                <div class="form-columns">
                    <div class="input-group">
                        <label for="price">Price</label>
                        <input type="number" step="0.01" id="price" name="price" placeholder="0.00" required>
                    </div>

                    <div class="input-group">
                        <label for="category_id">Category</label>
                        <select id="category_id" name="category_id" required>
                            <option value="" disabled selected>Select a category</option>
                            <% for(Map<String,Object> category : categories) { %>
                                <option value="<%= category.get("id") %>"><%= category.get("name") %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="button button-primary full-width">Add Service</button>
                </div>
            </form>
        </div>
    </section>
</main>
</body>
</html>
