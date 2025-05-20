<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.election.dao.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Test</title>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        // Load the MySQL driver explicitly
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Test database connection
        conn = DBUtil.getConnection();
        out.println("<p>Database connection successful!</p>");
        
        // Test if tables exist
        DatabaseMetaData metaData = conn.getMetaData();
        rs = metaData.getTables(null, null, "users", null);
        
        if (rs.next()) {
            out.println("<p>Users table exists.</p>");
            
            // Check if admin user exists
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM users WHERE username = 'admin'");
            
            if (rs.next()) {
                out.println("<p>Admin user exists with:</p>");
                out.println("<ul>");
                out.println("<li>Username: " + rs.getString("username") + "</li>");
                out.println("<li>Password: " + rs.getString("password") + "</li>");
                out.println("<li>Email: " + rs.getString("email") + "</li>");
                out.println("<li>Role: " + rs.getString("role") + "</li>");
                out.println("<li>Active: " + rs.getBoolean("is_active") + "</li>");
                out.println("</ul>");
            } else {
                out.println("<p>Admin user does not exist!</p>");
                
                // Try to create admin user
                try {
                    PreparedStatement pstmt = conn.prepareStatement(
                        "INSERT INTO users (username, password, email, full_name, role) " +
                        "VALUES ('admin', 'admin123', 'admin@example.com', 'System Administrator', 'admin')"
                    );
                    int rowsAffected = pstmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        out.println("<p>Admin user created successfully!</p>");
                    } else {
                        out.println("<p>Failed to create admin user.</p>");
                    }
                    
                    pstmt.close();
                } catch (SQLException e) {
                    out.println("<p>Error creating admin user: " + e.getMessage() + "</p>");
                }
            }
        } else {
            out.println("<p>Users table does not exist!</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
    %>
    
    <hr>
    <h2>Direct SQL Statement</h2>
    
    <%
    try {
        conn = DBUtil.getConnection();
        stmt = conn.createStatement();
        
        // Execute the same query as in UserDAO.validateUser method
        rs = stmt.executeQuery("SELECT * FROM users WHERE username = 'admin' AND password = 'admin123' AND is_active = true");
        
        if (rs.next()) {
            out.println("<p>Login query for admin/admin123 returns a result!</p>");
        } else {
            out.println("<p>Login query for admin/admin123 returns no results!</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error with query: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
    %>
    
    <p>
        <a href="${pageContext.request.contextPath}/login">Return to Login</a>
    </p>
</body>
</html> 