package com.admission.dao;
import com.admission.model.Document;
import com.admission.util.DBConnection;
import java.sql.*;
import java.util.*;

public class DocumentDAO {
    public boolean save(Document d) {
        String sql = "INSERT INTO documents(application_id,doc_type,original_name,stored_name,file_size,mime_type) VALUES(?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1,d.getApplicationId()); ps.setString(2,d.getDocType());
            ps.setString(3,d.getOriginalName()); ps.setString(4,d.getStoredName());
            ps.setLong(5,d.getFileSize()); ps.setString(6,d.getMimeType());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Document> findByApplicationId(int appId) {
        List<Document> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM documents WHERE application_id=?")) {
            ps.setInt(1,appId); ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Document findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM documents WHERE id=?")) {
            ps.setInt(1,id); ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean verify(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("UPDATE documents SET is_verified=TRUE WHERE id=?")) {
            ps.setInt(1,id); return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Document> findAll() {
        List<Document> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.createStatement().executeQuery("SELECT * FROM documents ORDER BY uploaded_at DESC")) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Document mapRow(ResultSet rs) throws SQLException {
        Document d = new Document();
        d.setId(rs.getInt("id")); d.setApplicationId(rs.getInt("application_id"));
        d.setDocType(rs.getString("doc_type")); d.setOriginalName(rs.getString("original_name"));
        d.setStoredName(rs.getString("stored_name")); d.setFileSize(rs.getLong("file_size"));
        d.setMimeType(rs.getString("mime_type")); d.setVerified(rs.getBoolean("is_verified"));
        d.setUploadedAt(rs.getTimestamp("uploaded_at"));
        return d;
    }
}
