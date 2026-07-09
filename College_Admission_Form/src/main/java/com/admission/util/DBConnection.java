package com.admission.util;
import java.sql.*;

public class DBConnection {
    private static final String DRIVER   = "com.mysql.cj.jdbc.Driver";
    private static final String URL      = "jdbc:mysql://localhost:3306/engineering_admission?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "East"; // ← change this

    static {
        try { Class.forName(DRIVER); }
        catch (ClassNotFoundException e) { throw new RuntimeException("MySQL Driver not found!", e); }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
