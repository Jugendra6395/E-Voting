<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.election.dao.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Setup</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; }
        .error { color: red; }
        pre { background-color: #f5f5f5; padding: 10px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <h1>Database Setup</h1>
    
    <%
    Connection conn = null;
    Statement stmt = null;
    
    try {
        // Load the MySQL driver explicitly
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // First, connect to MySQL to create the database if it doesn't exist
        String dbUrl = "jdbc:mysql://localhost:3306?useSSL=false&allowPublicKeyRetrieval=true";
        String dbUser = "root";
        String dbPassword = "Root";
        
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        stmt = conn.createStatement();
        
        out.println("<p class='success'>Connected to MySQL server!</p>");
        
        // Create database
        String createDbSql = "CREATE DATABASE IF NOT EXISTS evoting";
        stmt.executeUpdate(createDbSql);
        out.println("<p class='success'>Created database 'evoting' (if it didn't exist)</p>");
        
        // Close the connection and reconnect to the specific database
        stmt.close();
        conn.close();
        
        // Now connect to the evoting database
        conn = DBUtil.getConnection();
        stmt = conn.createStatement();
        
        out.println("<p class='success'>Connected to 'evoting' database!</p>");
        
        // Create users table
        String createUserTableSql = 
            "CREATE TABLE IF NOT EXISTS users (" +
            "    user_id INT AUTO_INCREMENT PRIMARY KEY," +
            "    username VARCHAR(50) NOT NULL UNIQUE," +
            "    password VARCHAR(255) NOT NULL," +
            "    email VARCHAR(100) NOT NULL UNIQUE," +
            "    full_name VARCHAR(100) NOT NULL," +
            "    role VARCHAR(20) NOT NULL DEFAULT 'voter'," +
            "    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "    is_active BOOLEAN DEFAULT TRUE" +
            ")";
        stmt.executeUpdate(createUserTableSql);
        out.println("<p class='success'>Created 'users' table (if it didn't exist)</p>");
        
        // Create elections table
        String createElectionTableSql = 
            "CREATE TABLE IF NOT EXISTS elections (" +
            "    election_id INT AUTO_INCREMENT PRIMARY KEY," +
            "    title VARCHAR(100) NOT NULL," +
            "    description TEXT," +
            "    start_date DATETIME NOT NULL," +
            "    end_date DATETIME NOT NULL," +
            "    created_by INT," +
            "    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "    is_active BOOLEAN DEFAULT TRUE," +
            "    FOREIGN KEY (created_by) REFERENCES users(user_id)" +
            ")";
        stmt.executeUpdate(createElectionTableSql);
        out.println("<p class='success'>Created 'elections' table (if it didn't exist)</p>");
        
        // Create candidates table
        String createCandidateTableSql = 
            "CREATE TABLE IF NOT EXISTS candidates (" +
            "    candidate_id INT AUTO_INCREMENT PRIMARY KEY," +
            "    election_id INT NOT NULL," +
            "    name VARCHAR(100) NOT NULL," +
            "    description TEXT," +
            "    FOREIGN KEY (election_id) REFERENCES elections(election_id)" +
            ")";
        stmt.executeUpdate(createCandidateTableSql);
        out.println("<p class='success'>Created 'candidates' table (if it didn't exist)</p>");
        
        // Create votes table
        String createVoteTableSql = 
            "CREATE TABLE IF NOT EXISTS votes (" +
            "    vote_id INT AUTO_INCREMENT PRIMARY KEY," +
            "    election_id INT NOT NULL," +
            "    voter_id INT NOT NULL," +
            "    candidate_id INT NOT NULL," +
            "    vote_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "    FOREIGN KEY (election_id) REFERENCES elections(election_id)," +
            "    FOREIGN KEY (voter_id) REFERENCES users(user_id)," +
            "    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id)," +
            "    UNIQUE KEY (election_id, voter_id)" +
            ")";
        stmt.executeUpdate(createVoteTableSql);
        out.println("<p class='success'>Created 'votes' table (if it didn't exist)</p>");
        
        // Check if admin user exists
        ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE username = 'admin'");
        
        if (!rs.next()) {
            // Insert admin user if it doesn't exist
            String insertAdminSql = 
                "INSERT INTO users (username, password, email, full_name, role) " +
                "VALUES ('admin', 'admin123', 'admin@example.com', 'System Administrator', 'admin')";
            stmt.executeUpdate(insertAdminSql);
            out.println("<p class='success'>Created admin user (username: admin, password: admin123)</p>");
            
            // Get the admin user's ID for creating a sample election
            rs = stmt.executeQuery("SELECT user_id FROM users WHERE username = 'admin'");
            rs.next();
            int adminId = rs.getInt("user_id");
            
            // Create a sample election
            String insertElectionSql = 
                "INSERT INTO elections (title, description, start_date, end_date, created_by) " +
                "VALUES ('Student Council Election 2025', 'Annual student council election for the academic year 2025-2026', " +
                "'2025-05-01 08:00:00', '2025-05-10 20:00:00', " + adminId + ")";
            stmt.executeUpdate(insertElectionSql);
            out.println("<p class='success'>Created sample election</p>");
            
            // Get the election ID
            rs = stmt.executeQuery("SELECT election_id FROM elections ORDER BY election_id DESC LIMIT 1");
            rs.next();
            int electionId = rs.getInt("election_id");
            
            // Create sample candidates
            String insertCandidatesSql = 
                "INSERT INTO candidates (election_id, name, description) VALUES " +
                "(" + electionId + ", 'John Smith', 'Junior, Computer Science major'), " +
                "(" + electionId + ", 'Maria Garcia', 'Senior, Political Science major'), " +
                "(" + electionId + ", 'David Johnson', 'Sophomore, Business Administration major')";
            stmt.executeUpdate(insertCandidatesSql);
            out.println("<p class='success'>Created sample candidates</p>");
        } else {
            out.println("<p>Admin user already exists</p>");
        }
        
        rs.close();
        
    } catch (Exception e) {
        out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p class='error'>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
    %>
    
    <h2>Setup Complete</h2>
    <p>If no errors were shown above, the database has been set up successfully.</p>
    <p>You can now <a href="${pageContext.request.contextPath}/login">login</a> with the following credentials:</p>
    <ul>
        <li><strong>Username:</strong> admin</li>
        <li><strong>Password:</strong> admin123</li>
    </ul>
    
</body>
</html> 