package com.admission.dao;
import com.admission.model.FeePayment;
import com.admission.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class FeeDAO {
    private static final String JOIN_SQL =
        "SELECT fp.*, a.application_no, u.full_name as applicant_name, " +
        "p.name as program_name, d.name as department_name " +
        "FROM fee_payments fp " +
        "JOIN applications a ON fp.application_id = a.id " +
        "JOIN users u ON fp.student_id = u.id " +
        "JOIN programs p ON a.program_id = p.id " +
        "JOIN departments d ON p.department_id = d.id ";

    public boolean save(FeePayment f) {
        String sql = "INSERT INTO fee_payments(application_id,student_id,transaction_id,academic_year,year_of_study,semester,amount,payment_type,payment_mode,payment_status,bank_reference,due_date,remarks) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1,f.getApplicationId()); ps.setInt(2,f.getStudentId());
            ps.setString(3,f.getTransactionId()); ps.setString(4,f.getAcademicYear());
            ps.setInt(5,f.getYearOfStudy()); ps.setInt(6,f.getSemester());
            ps.setBigDecimal(7,f.getAmount()); ps.setString(8,f.getPaymentType());
            ps.setString(9,f.getPaymentMode()); ps.setString(10,f.getPaymentStatus());
            ps.setString(11,f.getBankReference()); ps.setDate(12,f.getDueDate());
            ps.setString(13,f.getRemarks());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<FeePayment> findByStudentId(int studentId) {
        List<FeePayment> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE fp.student_id=? ORDER BY fp.payment_date DESC")) {
            ps.setInt(1, studentId); ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<FeePayment> findByApplicationId(int appId) {
        List<FeePayment> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE fp.application_id=? ORDER BY fp.year_of_study, fp.payment_date")) {
            ps.setInt(1, appId); ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<FeePayment> findAll(String status, String search) {
        List<FeePayment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(JOIN_SQL + "WHERE 1=1");
        List<String> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) { sql.append(" AND fp.payment_status=?"); params.add(status); }
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (fp.transaction_id LIKE ? OR u.full_name LIKE ? OR a.application_no LIKE ?)");
            String lk = "%" + search + "%";
            params.add(lk); params.add(lk); params.add(lk);
        }
        sql.append(" ORDER BY fp.payment_date DESC");
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setString(i+1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public BigDecimal totalRevenue() {
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.createStatement().executeQuery(
                "SELECT SUM(amount) FROM fee_payments WHERE payment_status='COMPLETED'")) {
            if (rs.next() && rs.getBigDecimal(1) != null) return rs.getBigDecimal(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    public BigDecimal totalPaidByStudent(int studentId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT SUM(amount) FROM fee_payments WHERE student_id=? AND payment_status='COMPLETED'")) {
            ps.setInt(1, studentId); ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getBigDecimal(1) != null) return rs.getBigDecimal(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    public int count(String status) {
        String sql = status == null ? "SELECT COUNT(*) FROM fee_payments"
                                    : "SELECT COUNT(*) FROM fee_payments WHERE payment_status=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (status != null) ps.setString(1, status);
            ResultSet rs = ps.executeQuery(); if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean confirm(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("UPDATE fee_payments SET payment_status='COMPLETED' WHERE id=?")) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private FeePayment mapRow(ResultSet rs) throws SQLException {
        FeePayment f = new FeePayment();
        f.setId(rs.getInt("id")); f.setApplicationId(rs.getInt("application_id"));
        f.setStudentId(rs.getInt("student_id")); f.setTransactionId(rs.getString("transaction_id"));
        f.setAcademicYear(rs.getString("academic_year")); f.setYearOfStudy(rs.getInt("year_of_study"));
        f.setSemester(rs.getInt("semester")); f.setAmount(rs.getBigDecimal("amount"));
        f.setPaymentType(rs.getString("payment_type")); f.setPaymentMode(rs.getString("payment_mode"));
        f.setPaymentStatus(rs.getString("payment_status")); f.setBankReference(rs.getString("bank_reference"));
        f.setPaymentDate(rs.getTimestamp("payment_date")); f.setDueDate(rs.getDate("due_date"));
        f.setRemarks(rs.getString("remarks"));
        try { f.setApplicationNo(rs.getString("application_no")); } catch (SQLException ignored) {}
        try { f.setApplicantName(rs.getString("applicant_name")); } catch (SQLException ignored) {}
        try { f.setProgramName(rs.getString("program_name")); } catch (SQLException ignored) {}
        try { f.setDepartmentName(rs.getString("department_name")); } catch (SQLException ignored) {}
        return f;
    }
}