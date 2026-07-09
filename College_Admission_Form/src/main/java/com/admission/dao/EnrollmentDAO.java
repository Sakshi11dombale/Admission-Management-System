package com.admission.dao;
import com.admission.model.Enrollment;
import com.admission.util.DBConnection;
import java.sql.*;
import java.util.*;

public class EnrollmentDAO {

    private static final String JOIN =
        "SELECT e.*, u.full_name student_name, u.email student_email, " +
        "p.name program_name, d.name department_name " +
        "FROM enrollments e " +
        "JOIN users u ON e.student_id = u.id " +
        "JOIN programs p ON e.program_id = p.id " +
        "JOIN departments d ON e.department_id = d.id ";

    // ---- CREATE ----
    public boolean create(Enrollment e) {
        String sql = "INSERT INTO enrollments(student_id, application_id, program_id, " +
                     "department_id, year_of_study, academic_year, enrollment_no, " +
                     "applicable_fee, status) VALUES(?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String no = "ENR" + e.getYearOfStudy() + String.valueOf(System.currentTimeMillis()).substring(7);
            e.setEnrollmentNo(no);

            System.out.println("=== ENROLLMENT DEBUG ===");
            System.out.println("studentId: " + e.getStudentId());
            System.out.println("applicationId: " + e.getApplicationId());
            System.out.println("programId: " + e.getProgramId());
            System.out.println("departmentId: " + e.getDepartmentId());
            System.out.println("yearOfStudy: " + e.getYearOfStudy());
            System.out.println("academicYear: " + e.getAcademicYear());
            System.out.println("applicableFee: " + e.getApplicableFee());
            System.out.println("========================");

            ps.setInt(1, e.getStudentId());
            ps.setInt(2, e.getApplicationId());
            ps.setInt(3, e.getProgramId());
            ps.setInt(4, e.getDepartmentId());
            ps.setInt(5, e.getYearOfStudy());
            ps.setString(6, e.getAcademicYear());
            ps.setString(7, no);
            ps.setBigDecimal(8, e.getApplicableFee() != null ? e.getApplicableFee() : java.math.BigDecimal.ZERO);
            ps.setString(9, e.getStatus() != null ? e.getStatus() : "PENDING");
            int rows = ps.executeUpdate();
            System.out.println("Rows inserted: " + rows);
            return rows > 0;
        } catch (SQLException ex) {
            System.out.println("=== ENROLLMENT INSERT FAILED ===");
            ex.printStackTrace();
            System.out.println("=================================");
            return false;
        }
    }

    // ---- READ SINGLE ----
    public Enrollment findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN + "WHERE e.id = ?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ---- READ BY STUDENT ----
    public List<Enrollment> findByStudent(int studentId) {
        List<Enrollment> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                JOIN + "WHERE e.student_id = ? ORDER BY e.year_of_study ASC")) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ---- READ BY APPLICATION ----
    public List<Enrollment> findByApplication(int appId) {
        List<Enrollment> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                JOIN + "WHERE e.application_id = ? ORDER BY e.year_of_study ASC")) {
            ps.setInt(1, appId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ---- READ ALL (admin) ----
    public List<Enrollment> findAll(String status) {
        List<Enrollment> list = new ArrayList<>();
        String sql = JOIN + (status != null && !status.isEmpty()
            ? "WHERE e.status = ? " : "") + "ORDER BY e.enrolled_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (status != null && !status.isEmpty()) ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ---- CHECK IF ENROLLMENT EXISTS ----
    public Enrollment findByStudentProgramYear(int studentId, int programId, int year) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                JOIN + "WHERE e.student_id = ? AND e.program_id = ? AND e.year_of_study = ?")) {
            ps.setInt(1, studentId); ps.setInt(2, programId); ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ---- GET LATEST APPROVED YEAR ----
    public int getLatestApprovedYear(int studentId, int programId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT MAX(year_of_study) FROM enrollments " +
                "WHERE student_id = ? AND program_id = ? AND status = 'APPROVED'")) {
            ps.setInt(1, studentId); ps.setInt(2, programId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ---- UPDATE STATUS ----
    public boolean updateStatus(int id, String status, String remarks) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "UPDATE enrollments SET status=?, admin_remarks=?, approved_at=NOW() WHERE id=?")) {
            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ---- UPDATE FEE PAID ----
    public boolean markFeePaid(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "UPDATE enrollments SET fee_paid=TRUE, fee_paid_date=NOW() WHERE id=?")) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ---- UPDATE ACADEMIC PERFORMANCE ----
    public boolean savePerformance(int id, double sgpa, double cgpa, int backlogs, double attendance) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "UPDATE enrollments SET sgpa=?, cgpa=?, backlogs=?, attendance_percent=? WHERE id=?")) {
            ps.setDouble(1, sgpa); ps.setDouble(2, cgpa);
            ps.setInt(3, backlogs); ps.setDouble(4, attendance);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ---- COUNT ----
    public int count(String status) {
        String sql = status == null ? "SELECT COUNT(*) FROM enrollments"
            : "SELECT COUNT(*) FROM enrollments WHERE status=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (status != null) ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Enrollment map(ResultSet rs) throws SQLException {
        Enrollment e = new Enrollment();
        e.setId(rs.getInt("id"));
        e.setStudentId(rs.getInt("student_id"));
        e.setApplicationId(rs.getInt("application_id"));
        e.setProgramId(rs.getInt("program_id"));
        e.setDepartmentId(rs.getInt("department_id"));
        e.setYearOfStudy(rs.getInt("year_of_study"));
        e.setAcademicYear(rs.getString("academic_year"));
        e.setEnrollmentNo(rs.getString("enrollment_no"));
        e.setStatus(rs.getString("status"));
        e.setApplicableFee(rs.getBigDecimal("applicable_fee"));
        e.setFeePaid(rs.getBoolean("fee_paid"));
        e.setAdminRemarks(rs.getString("admin_remarks"));
        e.setEnrolledAt(rs.getTimestamp("enrolled_at"));
        try { e.setApprovedAt(rs.getTimestamp("approved_at")); } catch (Exception ignored) {}
        try { e.setFeePaidDate(rs.getTimestamp("fee_paid_date")); } catch (Exception ignored) {}
        try { e.setSgpa(rs.getBigDecimal("sgpa")); } catch (Exception ignored) {}
        try { e.setCgpa(rs.getBigDecimal("cgpa")); } catch (Exception ignored) {}
        try { e.setBacklogs(rs.getInt("backlogs")); } catch (Exception ignored) {}
        try { e.setAttendancePercent(rs.getBigDecimal("attendance_percent")); } catch (Exception ignored) {}
        try { e.setStudentName(rs.getString("student_name")); } catch (Exception ignored) {}
        try { e.setStudentEmail(rs.getString("student_email")); } catch (Exception ignored) {}
        try { e.setProgramName(rs.getString("program_name")); } catch (Exception ignored) {}
        try { e.setDepartmentName(rs.getString("department_name")); } catch (Exception ignored) {}
        return e;
    }
}
