package com.admission.dao;
import com.admission.model.Application;
import com.admission.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ApplicationDAO {
	private static final String JOIN_SQL =
	        "SELECT a.*, p.name AS program_name, p.degree_type, d.name AS department_name, " +
	        "u.full_name AS student_name, u.email AS student_email " +
	        "FROM applications a " +
	        "JOIN programs p ON a.program_id = p.id " +
	        "JOIN departments d ON p.department_id = d.id " +
	        "JOIN users u ON a.student_id = u.id ";

    public boolean create(Application a) {
        String sql = "INSERT INTO applications(application_no,student_id,program_id,department_id,first_name,last_name,dob,gender,category,religion,address,city,state,pincode,parent_name,parent_phone,parent_occupation,annual_income,tenth_marks,tenth_board,twelfth_marks,twelfth_board,twelfth_stream,entrance_exam,entrance_score,entrance_rank,applicable_fee_per_year,total_program_fee) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            String appNo = "ENGG" + System.currentTimeMillis();
            a.setApplicationNo(appNo);
            ps.setString(1,appNo); ps.setInt(2,a.getStudentId()); ps.setInt(3,a.getProgramId());
            ps.setInt(4,a.getDepartmentId());
            ps.setString(5,a.getFirstName()); ps.setString(6,a.getLastName());
            ps.setDate(7,a.getDob()); ps.setString(8,a.getGender());
            ps.setString(9,a.getCategory() != null ? a.getCategory() : "GENERAL");
            ps.setString(10,a.getReligion() != null ? a.getReligion() : "HINDU");
            ps.setString(11,a.getAddress()); ps.setString(12,a.getCity());
            ps.setString(13,a.getState()); ps.setString(14,a.getPincode());
            ps.setString(15,a.getParentName()); ps.setString(16,a.getParentPhone());
            ps.setString(17,a.getParentOccupation()); ps.setBigDecimal(18,a.getAnnualIncome());
            ps.setBigDecimal(19,a.getTenthMarks()); ps.setString(20,a.getTenthBoard());
            ps.setBigDecimal(21,a.getTwelfthMarks()); ps.setString(22,a.getTwelfthBoard());
            ps.setString(23,a.getTwelfthStream());
            ps.setString(24,a.getEntranceExam()); ps.setBigDecimal(25,a.getEntranceScore());
            ps.setInt(26,a.getEntranceRank());
            ps.setBigDecimal(27,a.getApplicableFeePerYear()); ps.setBigDecimal(28,a.getTotalProgramFee());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Application findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE a.id=?")) {
            ps.setInt(1, id); ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Application findByApplicationNo(String appNo) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE a.application_no=?")) {
            ps.setString(1, appNo); ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Application> findByStudentId(int studentId) {
        List<Application> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE a.student_id=? ORDER BY a.submitted_at DESC")) {
            ps.setInt(1, studentId); ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Application> findAllFiltered(String status, String programId, String search) {
        List<Application> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(JOIN_SQL + "WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) { sql.append(" AND a.status=?"); params.add(status); }
        if (programId != null && !programId.isEmpty()) { sql.append(" AND a.program_id=?"); params.add(Integer.parseInt(programId)); }
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (a.application_no LIKE ? OR a.first_name LIKE ? OR a.last_name LIKE ? OR u.email LIKE ?)");
            String lk = "%" + search + "%";
            params.add(lk); params.add(lk); params.add(lk); params.add(lk);
        }
        sql.append(" ORDER BY a.submitted_at DESC");
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                if (params.get(i) instanceof Integer) ps.setInt(i+1,(Integer)params.get(i));
                else ps.setString(i+1,(String)params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Application> findRecent(int limit) {
        List<Application> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "ORDER BY a.submitted_at DESC LIMIT ?")) {
            ps.setInt(1, limit); ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(int id, String status, String remarks) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "UPDATE applications SET status=?,admin_remarks=?,reviewed_at=NOW() WHERE id=?")) {
            ps.setString(1,status); ps.setString(2,remarks); ps.setInt(3,id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int count() { return countByStatus(null); }

    public int countByStatus(String status) {
        String sql = status==null ? "SELECT COUNT(*) FROM applications" : "SELECT COUNT(*) FROM applications WHERE status=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (status != null) ps.setString(1, status);
            ResultSet rs = ps.executeQuery(); if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String,Integer> countByStatusAll() {
        Map<String,Integer> map = new HashMap<>();
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.createStatement().executeQuery("SELECT status,COUNT(*) cnt FROM applications GROUP BY status")) {
            while (rs.next()) map.put(rs.getString("status"), rs.getInt("cnt"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId(rs.getInt("id")); a.setApplicationNo(rs.getString("application_no"));
        a.setStudentId(rs.getInt("student_id")); a.setProgramId(rs.getInt("program_id"));
        a.setStatus(rs.getString("status")); a.setFirstName(rs.getString("first_name"));
        a.setLastName(rs.getString("last_name")); a.setDob(rs.getDate("dob"));
        a.setGender(rs.getString("gender")); a.setAddress(rs.getString("address"));
        a.setCity(rs.getString("city")); a.setState(rs.getString("state"));
        a.setPincode(rs.getString("pincode")); a.setParentName(rs.getString("parent_name"));
        a.setParentPhone(rs.getString("parent_phone")); a.setAdminRemarks(rs.getString("admin_remarks"));
        a.setSubmittedAt(rs.getTimestamp("submitted_at")); a.setReviewedAt(rs.getTimestamp("reviewed_at"));
        try { a.setProgramName(rs.getString("program_name")); } catch (SQLException ignored) {}
        try { a.setStudentName(rs.getString("student_name")); } catch (SQLException ignored) {}
        try { a.setStudentEmail(rs.getString("student_email")); } catch (SQLException ignored) {}
        try { a.setDepartmentName(rs.getString("department_name")); } catch (SQLException ignored) {}
        try { a.setDegreeType(rs.getString("degree_type")); } catch (SQLException ignored) {}
        try { a.setCategory(rs.getString("category")); } catch (SQLException ignored) {}
        try { a.setReligion(rs.getString("religion")); } catch (SQLException ignored) {}
        try { a.setTenthMarks(rs.getBigDecimal("tenth_marks")); } catch (SQLException ignored) {}
        try { a.setTwelfthMarks(rs.getBigDecimal("twelfth_marks")); } catch (SQLException ignored) {}
        try { a.setEntranceScore(rs.getBigDecimal("entrance_score")); } catch (SQLException ignored) {}
        try { a.setApplicableFeePerYear(rs.getBigDecimal("applicable_fee_per_year")); } catch (SQLException ignored) {}
        try { a.setTotalProgramFee(rs.getBigDecimal("total_program_fee")); } catch (SQLException ignored) {}
        try { a.setEntranceExam(rs.getString("entrance_exam")); } catch (SQLException ignored) {}
        try { a.setEntranceRank(rs.getInt("entrance_rank")); } catch (SQLException ignored) {}
        try { a.setParentOccupation(rs.getString("parent_occupation")); } catch (SQLException ignored) {}
        return a;
    }
}