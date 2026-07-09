package com.admission.dao;
import com.admission.model.Program;
import com.admission.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ProgramDAO {
    private static final String SELECT_SQL =
        "SELECT p.*, d.name as dept_name, d.code as dept_code FROM programs p " +
        "JOIN departments d ON p.department_id = d.id ";

    public List<Program> findAll() {
        return query(SELECT_SQL + "WHERE p.is_active=TRUE ORDER BY d.name, p.degree_type", null);
    }

    public List<Program> findAllActive() { return findAll(); }

    public List<Program> findByDepartment(int deptId) {
        return query(SELECT_SQL + "WHERE p.is_active=TRUE AND p.department_id=? ORDER BY p.degree_type", deptId);
    }

    public List<Program> findByDegreeType(String type) {
        List<Program> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT_SQL + "WHERE p.is_active=TRUE AND p.degree_type=? ORDER BY d.name")) {
            ps.setString(1, type); ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Program findById(int id) {
        List<Program> list = query(SELECT_SQL + "WHERE p.id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    public boolean create(Program p) {
        String sql = "INSERT INTO programs(department_id,name,code,degree_type,duration_years,total_seats,available_seats,base_fee,fee_general,fee_obc,fee_sc,fee_st,fee_ews,fee_minority,fee_year1,fee_year2,fee_year3,fee_year4,eligibility,description) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1,p.getDepartmentId()); ps.setString(2,p.getName()); ps.setString(3,p.getCode());
            ps.setString(4,p.getDegreeType()); ps.setInt(5,p.getDurationYears());
            ps.setInt(6,p.getTotalSeats()); ps.setInt(7,p.getTotalSeats());
            ps.setBigDecimal(8,p.getBaseFee()); ps.setBigDecimal(9,p.getFeeGeneral());
            ps.setBigDecimal(10,p.getFeeObc()); ps.setBigDecimal(11,p.getFeeSc());
            ps.setBigDecimal(12,p.getFeeSt()); ps.setBigDecimal(13,p.getFeeEws());
            ps.setBigDecimal(14,p.getFeeMinority()); ps.setBigDecimal(15,p.getFeeYear1());
            ps.setBigDecimal(16,p.getFeeYear2()); ps.setBigDecimal(17,p.getFeeYear3());
            ps.setBigDecimal(18,p.getFeeYear4()); ps.setString(19,p.getEligibility());
            ps.setString(20,p.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(Program p) {
        String sql = "UPDATE programs SET name=?,code=?,degree_type=?,duration_years=?,total_seats=?,base_fee=?,fee_general=?,fee_obc=?,fee_sc=?,fee_st=?,fee_ews=?,fee_minority=?,fee_year1=?,fee_year2=?,fee_year3=?,fee_year4=?,eligibility=?,description=?,is_active=? WHERE id=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,p.getName()); ps.setString(2,p.getCode()); ps.setString(3,p.getDegreeType());
            ps.setInt(4,p.getDurationYears()); ps.setInt(5,p.getTotalSeats());
            ps.setBigDecimal(6,p.getBaseFee()); ps.setBigDecimal(7,p.getFeeGeneral());
            ps.setBigDecimal(8,p.getFeeObc()); ps.setBigDecimal(9,p.getFeeSc());
            ps.setBigDecimal(10,p.getFeeSt()); ps.setBigDecimal(11,p.getFeeEws());
            ps.setBigDecimal(12,p.getFeeMinority()); ps.setBigDecimal(13,p.getFeeYear1());
            ps.setBigDecimal(14,p.getFeeYear2()); ps.setBigDecimal(15,p.getFeeYear3());
            ps.setBigDecimal(16,p.getFeeYear4()); ps.setString(17,p.getEligibility());
            ps.setString(18,p.getDescription()); ps.setBoolean(19,p.isActive()); ps.setInt(20,p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("UPDATE programs SET is_active=FALSE WHERE id=?")) {
            ps.setInt(1,id); return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int count() {
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.createStatement().executeQuery("SELECT COUNT(*) FROM programs WHERE is_active=TRUE")) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private List<Program> query(String sql, Integer param) {
        List<Program> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (param != null) ps.setInt(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Program mapRow(ResultSet rs) throws SQLException {
        Program p = new Program();
        p.setId(rs.getInt("id")); p.setDepartmentId(rs.getInt("department_id"));
        p.setName(rs.getString("name")); p.setCode(rs.getString("code"));
        p.setDegreeType(rs.getString("degree_type")); p.setDurationYears(rs.getInt("duration_years"));
        p.setTotalSeats(rs.getInt("total_seats")); p.setAvailableSeats(rs.getInt("available_seats"));
        p.setBaseFee(rs.getBigDecimal("base_fee"));
        p.setFeeGeneral(rs.getBigDecimal("fee_general")); p.setFeeObc(rs.getBigDecimal("fee_obc"));
        p.setFeeSc(rs.getBigDecimal("fee_sc")); p.setFeeSt(rs.getBigDecimal("fee_st"));
        p.setFeeEws(rs.getBigDecimal("fee_ews")); p.setFeeMinority(rs.getBigDecimal("fee_minority"));
        p.setFeeYear1(rs.getBigDecimal("fee_year1")); p.setFeeYear2(rs.getBigDecimal("fee_year2"));
        p.setFeeYear3(rs.getBigDecimal("fee_year3")); p.setFeeYear4(rs.getBigDecimal("fee_year4"));
        p.setEligibility(rs.getString("eligibility")); p.setDescription(rs.getString("description"));
        p.setActive(rs.getBoolean("is_active"));
        try { p.setCreatedAt(rs.getTimestamp("created_at")); } catch (SQLException ignored) {}
        try { p.setDepartmentName(rs.getString("dept_name")); p.setDepartmentCode(rs.getString("dept_code")); } catch (SQLException ignored) {}
        return p;
    }
}