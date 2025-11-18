<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SilverCare — Services</title>
    <link rel="stylesheet" href="styles.css">  <!-- ✅ Include your main stylesheet -->
    <style>
        main {
            padding: calc(var(--spacing-unit) * 4) 0;
        }

        .service-section {
            background: var(--color-surface);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-soft);
            padding: calc(var(--spacing-unit) * 2);
            margin-bottom: calc(var(--spacing-unit) * 2);
            border: 1px solid rgba(75, 99, 209, 0.08);
        }

        .service-section h3 {
            margin-top: 0;
            color: var(--color-primary-dark);
            border-bottom: 2px solid var(--color-primary);
            padding-bottom: 0.4rem;
            font-size: 1.3rem;
        }

        .service-list {
            display: grid;
            gap: calc(var(--spacing-unit) * 1);
            padding-top: calc(var(--spacing-unit) * 0.5);
        }

        .service-item {
            background: var(--color-secondary);
            border-radius: var(--radius-sm);
            padding: calc(var(--spacing-unit) * 1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .service-item:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-soft);
        }

        .service-name {
            font-weight: 600;
            font-size: 1.05rem;
            color: var(--color-text);
        }

        .service-price {
            color: var(--color-primary);
            font-weight: 700;
            margin-top: 0.25rem;
        }

        .no-services {
            color: var(--color-muted);
            font-style: italic;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<main>
    <div class="container">
        <h2 style="text-align:center; color:var(--color-primary-dark); margin-bottom:2rem;">
            Our Services
        </h2>

        <%
        String jdbcURL = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
        String dbUser = "neondb_owner";
        String dbPass = "npg_KyB82hXZLaRm";

        try {
            Class.forName("org.postgresql.Driver");
            try (Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass)) {

                // Get service categories
                String catSQL = "SELECT id, category_name FROM silvercare.service_category ORDER BY category_name";
                PreparedStatement catStmt = conn.prepareStatement(catSQL);
                ResultSet catRs = catStmt.executeQuery();

                boolean hasCategories = false;

                while (catRs.next()) {
                    hasCategories = true;
                    int categoryId = catRs.getInt("id");
                    String categoryName = catRs.getString("category_name");
        %>

        <section class="service-section">
            <h3><%= categoryName %></h3>
            <div class="service-list">
                <%
                    String svcSQL = "SELECT service_name, price FROM silvercare.service WHERE category_id = ?";
                    PreparedStatement svcStmt = conn.prepareStatement(svcSQL);
                    svcStmt.setInt(1, categoryId);
                    ResultSet svcRs = svcStmt.executeQuery();

                    boolean hasServices = false;
                    while (svcRs.next()) {
                        hasServices = true;
                %>
                <div class="service-item">
                    <div class="service-name"><%= svcRs.getString("service_name") %></div>
                    <div class="service-price">S$ <%= svcRs.getDouble("price") %></div>
                </div>
                <%
                    }
                    if (!hasServices) {
                %>
                <p class="no-services">No services available in this category.</p>
                <%
                    }
                    svcRs.close();
                    svcStmt.close();
                %>
            </div>
        </section>

        <%
                }
                if (!hasCategories) {
        %>
            <p class="no-services">No service categories found.</p>
        <%
                }
                catRs.close();
                catStmt.close();
            }
        } catch (Exception e) {
        %>
            <p class="no-services">❌ Error loading services: <%= e.getMessage() %></p>
        <%
        }
        %>
    </div>
</main>

<%@ include file="footer.html" %>

</body>
</html>
