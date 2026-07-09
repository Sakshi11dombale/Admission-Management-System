package com.admission.dao;
import com.admission.model.Notification;
import com.admission.util.DBConnection;
import java.sql.*;
import java.util.*;

public class NotificationDAO {
    public boolean create(Notification n) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("INSERT INTO notifications(user_id,title,message) VALUES(?,?,?)")) {
            ps.setInt(1,n.getUserId()); ps.setString(2,n.getTitle()); ps.setString(3,n.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Notification> findAll() {
        List<Notification> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.createStatement().executeQuery(
                "SELECT n.*,u.full_name user_name FROM notifications n JOIN users u ON n.user_id=u.id ORDER BY n.created_at DESC")) {
            while (rs.next()) { Notification n = mapRow(rs); n.setUserName(rs.getString("user_name")); list.add(n); }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Notification> findByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC")) {
            ps.setInt(1,userId); ResultSet rs = ps.executeQuery(); while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countUnread(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM notifications WHERE user_id=? AND is_read=FALSE")) {
            ps.setInt(1,userId); ResultSet rs = ps.executeQuery(); if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public void markAllRead(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("UPDATE notifications SET is_read=TRUE WHERE user_id=?")) {
            ps.setInt(1,userId); ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id")); n.setUserId(rs.getInt("user_id"));
        n.setTitle(rs.getString("title")); n.setMessage(rs.getString("message"));
        n.setRead(rs.getBoolean("is_read")); n.setCreatedAt(rs.getTimestamp("created_at"));
        return n;
    }
}
