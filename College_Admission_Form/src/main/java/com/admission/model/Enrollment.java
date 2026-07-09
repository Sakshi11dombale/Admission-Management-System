package com.admission.model;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Enrollment {
    private int id, studentId, applicationId, programId, departmentId;
    private int yearOfStudy, backlogs;
    private String enrollmentNo, academicYear, status, adminRemarks;
    private String studentName, studentEmail, programName, departmentName, rollNumber;
    private BigDecimal applicableFee, sgpa, cgpa, attendancePercent;
    private boolean feePaid;
    private Timestamp enrolledAt, approvedAt, feePaidDate;

    public int getId() { return id; } public void setId(int i) { this.id = i; }
    public int getStudentId() { return studentId; } public void setStudentId(int s) { this.studentId = s; }
    public int getApplicationId() { return applicationId; } public void setApplicationId(int a) { this.applicationId = a; }
    public int getProgramId() { return programId; } public void setProgramId(int p) { this.programId = p; }
    public int getDepartmentId() { return departmentId; } public void setDepartmentId(int d) { this.departmentId = d; }
    public int getYearOfStudy() { return yearOfStudy; } public void setYearOfStudy(int y) { this.yearOfStudy = y; }
    public int getBacklogs() { return backlogs; } public void setBacklogs(int b) { this.backlogs = b; }
    public String getEnrollmentNo() { return enrollmentNo; } public void setEnrollmentNo(String e) { this.enrollmentNo = e; }
    public String getAcademicYear() { return academicYear; } public void setAcademicYear(String a) { this.academicYear = a; }
    public String getStatus() { return status; } public void setStatus(String s) { this.status = s; }
    public String getAdminRemarks() { return adminRemarks; } public void setAdminRemarks(String a) { this.adminRemarks = a; }
    public String getStudentName() { return studentName; } public void setStudentName(String s) { this.studentName = s; }
    public String getStudentEmail() { return studentEmail; } public void setStudentEmail(String s) { this.studentEmail = s; }
    public String getProgramName() { return programName; } public void setProgramName(String p) { this.programName = p; }
    public String getDepartmentName() { return departmentName; } public void setDepartmentName(String d) { this.departmentName = d; }
    public String getRollNumber() { return rollNumber; } public void setRollNumber(String r) { this.rollNumber = r; }
    public BigDecimal getApplicableFee() { return applicableFee; } public void setApplicableFee(BigDecimal f) { this.applicableFee = f; }
    public BigDecimal getSgpa() { return sgpa; } public void setSgpa(BigDecimal s) { this.sgpa = s; }
    public BigDecimal getCgpa() { return cgpa; } public void setCgpa(BigDecimal c) { this.cgpa = c; }
    public BigDecimal getAttendancePercent() { return attendancePercent; } public void setAttendancePercent(BigDecimal a) { this.attendancePercent = a; }
    public boolean isFeePaid() { return feePaid; } public void setFeePaid(boolean f) { this.feePaid = f; }
    public Timestamp getEnrolledAt() { return enrolledAt; } public void setEnrolledAt(Timestamp t) { this.enrolledAt = t; }
    public Timestamp getApprovedAt() { return approvedAt; } public void setApprovedAt(Timestamp t) { this.approvedAt = t; }
    public Timestamp getFeePaidDate() { return feePaidDate; } public void setFeePaidDate(Timestamp t) { this.feePaidDate = t; }

    public String getYearLabel() {
        switch (yearOfStudy) {
            case 1: return "1st Year";
            case 2: return "2nd Year";
            case 3: return "3rd Year";
            case 4: return "4th Year";
            default: return yearOfStudy + "th Year";
        }
    }
}