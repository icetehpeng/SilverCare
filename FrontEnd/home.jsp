<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SilverCare - Home</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>

<%@ include file="header.jsp" %>

<main>
    <section class="hero">
        <div class="hero-content container">
            <h2>Compassionate Care for Every Stage of Aging</h2>
            <p>
                SilverCare provides professional in-home support, assisted living services, and personalized therapy
                so seniors can thrive with confidence and dignity.
            </p>
            <div class="hero-actions">
                <a href="serviceCategories.jsp" class="button button-primary">Explore Services</a>
                <%
                    if (session.getAttribute("sessUserID") == null) {
                %>
                    <a href="register.jsp" class="button button-secondary">Become a Member</a>
                <%
                    }
                %>
            </div>
        </div>
    </section>

    <section class="features container">
        <article class="feature-card">
            <h3>Trusted Professionals</h3>
            <p>Certified caregivers, nurses, and therapists carefully matched to every client's needs.</p>
        </article>
        <article class="feature-card">
            <h3>Flexible Scheduling</h3>
            <p>Book one-time visits, recurring care, or on-call assistance that fits your routine.</p>
        </article>
        <article class="feature-card">
            <h3>Holistic Wellness</h3>
            <p>From daily living support to therapy and companionship, we care for mind and body.</p>
        </article>
    </section>

    <section class="testimonials">
        <div class="container">
            <div class="testimonials-header">
                <h2>What Our Clients Say</h2>
                <p>Real stories from families who trust SilverCare</p>
            </div>
            <div class="testimonials-scroll-container">
                <div class="testimonials-grid">
                    <%
                        String jdbcURL = "jdbc:postgresql://ep-spring-truth-a19dpek3-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require&channel_binding=require";
                        String dbUser = "neondb_owner";
                        String dbPass = "npg_KyB82hXZLaRm";
                        
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        
                        try {
                            Class.forName("org.postgresql.Driver");
                            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);
                            
                            // Query feedback table - adjust column names based on your actual table structure
                            // Assuming table structure: id, user_id, name, rating, comment, created_at
                            String sql = "SELECT f.id, f.rating, f.comment, " +
                                       "COALESCE(u.username, f.name, 'Anonymous') as reviewer_name, " +
                                       "COALESCE(f.relationship, 'Client') as relationship " +
                                       "FROM silvercare.feedback f " +
                                       "LEFT JOIN silvercare.users u ON f.user_id = u.id " +
                                       "WHERE f.rating IS NOT NULL AND f.comment IS NOT NULL " +
                                       "ORDER BY f.created_at DESC, f.id DESC " +
                                       "LIMIT 8";
                            
                            ps = conn.prepareStatement(sql);
                            rs = ps.executeQuery();
                            
                            boolean hasReviews = false;
                            while (rs.next()) {
                                hasReviews = true;
                                int rating = rs.getInt("rating");
                                String comment = rs.getString("comment");
                                String reviewerName = rs.getString("reviewer_name");
                                String relationship = rs.getString("relationship");
                    %>
                    <article class="testimonial-card">
                        <div class="testimonial-rating">
                            <%
                                // Display stars based on rating
                                for (int i = 1; i <= 5; i++) {
                                    if (i <= rating) {
                            %>
                            <span class="star">★</span>
                            <%
                                    } else {
                            %>
                            <span class="star" style="opacity: 0.3;">★</span>
                            <%
                                    }
                                }
                            %>
                        </div>
                        <p class="testimonial-text">
                            "<%= comment %>"
                        </p>
                        <div class="testimonial-author">
                            <strong><%= reviewerName %></strong>
                            <span><%= relationship %></span>
                        </div>
                    </article>
                    <%
                            }
                            
                            // If no reviews found, show a message
                            if (!hasReviews) {
                    %>
                    <article class="testimonial-card">
                        <p class="testimonial-text" style="text-align: center; padding: 2rem;">
                            No reviews available yet. Be the first to share your experience!
                        </p>
                    </article>
                    <%
                            }
                            
                        } catch (Exception e) {
                            // If table doesn't exist or error occurs, show error message
                            out.println("<!-- Error loading reviews: " + e.getMessage() + " -->");
                    %>
                    <article class="testimonial-card">
                        <p class="testimonial-text" style="text-align: center; padding: 2rem; color: #666;">
                            Reviews are currently unavailable. Please check back later.
                        </p>
                    </article>
                    <%
                        } finally {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </div>
            </div>
        </div>
    </section>
</main>

<%@ include file="footer.html" %>

</body>
</html>