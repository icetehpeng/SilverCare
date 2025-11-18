<%@ page import="java.sql.*,java.util.*" %>
<%@ page session="true" %>
<%
	String jdbcURL = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
	String dbUser = "neondb_owner";
	String dbPass = "npg_KyB82hXZLaRm";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String id = request.getParameter("id");
    String msg = "";
    boolean isSuccess = false;
    String service_name="", description="", price="", category_id="";
    List<Map<String, Object>> categories = new ArrayList<>();

    try{
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        if(request.getMethod().equalsIgnoreCase("POST")){
            service_name = request.getParameter("service_name");
            description = request.getParameter("description");
            price = request.getParameter("price");
            category_id = request.getParameter("category_id");

            ps = conn.prepareStatement("UPDATE silvercare.service SET service_name=?, description=?, price=?, category_id=? WHERE id=?");
            ps.setString(1, service_name);
            ps.setString(2, description);
            ps.setDouble(3, Double.parseDouble(price));
            ps.setInt(4, Integer.parseInt(category_id));
            ps.setInt(5, Integer.parseInt(id));
            ps.executeUpdate();
            msg = "✅ Service updated successfully!";
            isSuccess = true;
        }

        // Load existing service details
        ps = conn.prepareStatement("SELECT * FROM silvercare.service WHERE id=?");
        ps.setInt(1, Integer.parseInt(id));
        rs = ps.executeQuery();
        if(rs.next()){
            service_name = rs.getString("service_name");
            description = rs.getString("description");
            price = String.valueOf(rs.getDouble("price"));
            category_id = String.valueOf(rs.getInt("category_id"));
        }

        // Load categories for dropdown
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        
        ps = conn.prepareStatement("SELECT id, category_name FROM silvercare.service_category ORDER BY category_name");
        rs = ps.executeQuery();

        while(rs.next()) {
            Map<String, Object> category = new HashMap<>();
            category.put("id", rs.getInt("id"));
            category.put("name", rs.getString("category_name"));
            categories.add(category);
        }
    }catch(Exception e){
        msg = "❌ Error: "+e.getMessage();
        isSuccess = false;
    }finally{
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(conn!=null) conn.close();
    }

    String statusClass = isSuccess ? "status-message status-success" : "status-message status-error";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Service</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<%@ include file="header.jsp" %>
<main class="dashboard-wrapper">
    <section class="container container-narrow">
        <div class="dashboard-card form-card">
            <div class="dashboard-title">
                <p class="eyebrow-text">Administration</p>
                <h1>Update Service</h1>
                <p>Modify the service details below and save your changes.</p>
            </div>

            <% if(!msg.isEmpty()) { %>
            <p class="<%= statusClass %>"><%= msg %></p>
            <% } %>

            <form method="post" class="form-grid">
                <input type="hidden" name="id" value="<%= id %>">
                
                <div class="input-group">
                    <label for="service_name">Service Name</label>
                    <input type="text" id="service_name" name="service_name" value="<%= service_name %>" placeholder="Enter service name" required>
                </div>

                <div class="input-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" placeholder="Describe the service" required><%= description %></textarea>
                </div>

                <div class="form-columns">
                    <div class="input-group">
                        <label for="price">Price</label>
                        <input type="number" step="0.01" id="price" name="price" value="<%= price %>" placeholder="0.00" required>
                    </div>

                    <div class="input-group">
                        <label for="category_id">Category</label>
                        <select id="category_id" name="category_id" required>
                            <option value="" disabled>Select a category</option>
                            <% for(Map<String,Object> category : categories) { 
                                String catId = String.valueOf(category.get("id"));
                                String selected = catId.equals(category_id) ? "selected" : "";
                            %>
                                <option value="<%= catId %>" <%= selected %>><%= category.get("name") %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="button button-primary full-width">Update Service</button>
                </div>
            </form>
        </div>
    </section>
</main>
<%@ include file="footer.html" %>
</body>
</html>
