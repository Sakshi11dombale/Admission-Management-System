package com.admission.dao;
import com.admission.model.Department;
import com.admission.util.DBConnection;
import java.sql.*;
import java.util.*;

public class DepartmentDAO {
    public List<Department> findAll() {
        List<Department> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.createStatement().executeQuery("SELECT * FROM departments WHERE is_active=TRUE ORDER BY name")) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Department findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM departments WHERE id=?")) {
            ps.setInt(1, id); ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Department mapRow(ResultSet rs) throws SQLException {
        Department d = new Department();
        d.setId(rs.getInt("id")); d.setName(rs.getString("name"));
        d.setCode(rs.getString("code")); d.setHodName(rs.getString("hod_name"));
        d.setTotalSeats(rs.getInt("total_seats")); d.setAvailableSeats(rs.getInt("available_seats"));
        d.setDescription(rs.getString("description")); d.setActive(rs.getBoolean("is_active"));
        return d;
    }
}
