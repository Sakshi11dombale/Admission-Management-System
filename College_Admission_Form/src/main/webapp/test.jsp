<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>DB Test</title>
<style>
body{font-family:Arial;padding:30px;background:#f1f5f9}
.box{background:#fff;border-radius:12px;padding:24px;margin-bottom:16px;border:1px solid #e2e8f0}
.ok{color:#059669;font-weight:700} .err{color:#dc2626;font-weight:700}
table{width:100%;border-collapse:collapse;margin-top:12px}
th{background:#1a4b8c;color:#fff;padding:10px;text-align:left}
td{padding:9px;border-bottom:1px solid #e2e8f0}
</style>
</head>
<body>
<h2>Database Connection Test</h2>

<%
String dbUrl  = "jdbc:mysql://localhost:3306/engineering_admission?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
String dbUser = "root";
String dbPass = "your_password"; // ← PUT YOUR MYSQL PASSWORD HERE

// Test 1 - Driver
out.println("<div class='box'><h3>Test 1: JDBC Driver</h3>");
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    out.println("<p class='ok'>✅ MySQL Driver loaded successfully</p>");
} catch(Exception e) {
    out.println("<p class='err'>❌ Driver error: " + e.getMessage() + "</p>");
}
out.println("</div>");

// Test 2 - Connection
Connection conn = null;
out.println("<div class='box'><h3>Test 2: Database Connection</h3>");
try {
    conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
    out.println("<p class='ok'>✅ Connected to database successfully!</p>");
    out.println("<p>Database: <strong>engineering_admission</strong></p>");
} catch(Exception e) {
    out.println("<p class='err'>❌ Connection failed: " + e.getMessage() + "</p>");
    out.println("<p>URL: " + dbUrl + "</p>");
    out.println("<p>User: " + dbUser + "</p>");
}
out.println("</div>");

// Test 3 - Tables
if (conn != null) {
    out.println("<div class='box'><h3>Test 3: Tables</h3>");
    try {
        ResultSet rs = conn.createStatement().executeQuery("SHOW TABLES");
        out.println("<p class='ok'>✅ Tables found:</p><ul>");
        while(rs.next()) out.println("<li>" + rs.getString(1) + "</li>");
        out.println("</ul>");
    } catch(Exception e) {
        out.println("<p class='err'>❌ " + e.getMessage() + "</p>");
    }
    out.println("</div>");

    // Test 4 - Users
    out.println("<div class='box'><h3>Test 4: Users Table</h3>");
    try {
        ResultSet rs = conn.createStatement().executeQuery("SELECT id, username, password, role, full_name FROM users");
        out.println("<table><tr><th>ID</th><th>Username</th><th>Password</th><th>Role</th><th>Full Name</th></tr>");
        int count = 0;
        while(rs.next()) {
            count++;
            out.println("<tr><td>" + rs.getInt("id") + "</td>"
                + "<td>" + rs.getString("username") + "</td>"
                + "<td>" + rs.getString("password") + "</td>"
                + "<td>" + rs.getString("role") + "</td>"
                + "<td>" + rs.getString("full_name") + "</td></tr>");
        }
        out.println("</table>");
        if(count == 0) out.println("<p class='err'>⚠️ Users table is EMPTY — need to insert admin</p>");
        else out.println("<p class='ok'>✅ " + count + " user(s) found</p>");
    } catch(Exception e) {
        out.println("<p class='err'>❌ Users table error: " + e.getMessage() + "</p>");
    }
    out.println("</div>");

    // Test 5 - Login simulation
    out.println("<div class='box'><h3>Test 5: Login Simulation (admin/admin123)</h3>");
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE username=? AND password=?");
        ps.setString(1, "admin"); ps.setString(2, "admin123");
        ResultSet rs = ps.executeQuery();
        if(rs.next()) {
            out.println("<p class='ok'>✅ Login works! User: " + rs.getString("full_name") + " | Role: " + rs.getString("role") + "</p>");
        } else {
            out.println("<p class='err'>❌ Login failed — username/password not matching in DB</p>");
        }
    } catch(Exception e) {
        out.println("<p class='err'>❌ Login test error: " + e.getMessage() + "</p>");
    }
    out.println("</div>");

    conn.close();
}
%>

<div class="box">
    <h3>Quick Fix</h3>
    <p>If users table is empty, run this SQL in MySQL Workbench:</p>
    <pre style="background:#f8fafc;padding:12px;border-radius:8px;font-size:13px">
USE engineering_admission;
INSERT INTO users (username, password, email, role, full_name, phone)
VALUES ('admin', 'admin123', 'admin@engg.edu', 'ADMIN', 'Admin User', '9000000001');
    </pre>
</div>
</body>
</html>