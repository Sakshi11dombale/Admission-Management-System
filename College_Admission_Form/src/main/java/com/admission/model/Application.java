package com.admission.model;
import java.math.BigDecimal;
import java.sql.*;

public class Application {
    private int id, studentId, programId, departmentId, entranceRank;
    private String applicationNo, status, firstName, lastName, gender;
    private String category, religion, address, city, state, pincode;
    private String parentName, parentPhone, parentOccupation;
    private String adminRemarks, programName, studentName, studentEmail;
    private String departmentName, degreeType, tenthBoard, twelfthBoard, twelfthStream;
    private String entranceExam;
    private Date dob;
    private BigDecimal tenthMarks, twelfthMarks, entranceScore;
    private BigDecimal applicableFeePerYear, totalProgramFee, annualIncome;
    private Timestamp submittedAt, reviewedAt;

    public String getFullName() { return firstName + " " + lastName; }

    public int getId() { return id; } public void setId(int i) { this.id = i; }
    public int getStudentId() { return studentId; } public void setStudentId(int s) { this.studentId = s; }
    public int getProgramId() { return programId; } public void setProgramId(int p) { this.programId = p; }
    public int getDepartmentId() { return departmentId; } public void setDepartmentId(int d) { this.departmentId = d; }
    public int getEntranceRank() { return entranceRank; } public void setEntranceRank(int r) { this.entranceRank = r; }
    public String getApplicationNo() { return applicationNo; } public void setApplicationNo(String a) { this.applicationNo = a; }
    public String getStatus() { return status; } public void setStatus(String s) { this.status = s; }
    public String getFirstName() { return firstName; } public void setFirstName(String f) { this.firstName = f; }
    public String getLastName() { return lastName; } public void setLastName(String l) { this.lastName = l; }
    public String getGender() { return gender; } public void setGender(String g) { this.gender = g; }
    public String getCategory() { return category; } public void setCategory(String c) { this.category = c; }
    public String getReligion() { return religion; } public void setReligion(String r) { this.religion = r; }
    public String getAddress() { return address; } public void setAddress(String a) { this.address = a; }
    public String getCity() { return city; } public void setCity(String c) { this.city = c; }
    public String getState() { return state; } public void setState(String s) { this.state = s; }
    public String getPincode() { return pincode; } public void setPincode(String p) { this.pincode = p; }
    public String getParentName() { return parentName; } public void setParentName(String p) { this.parentName = p; }
    public String getParentPhone() { return parentPhone; } public void setParentPhone(String p) { this.parentPhone = p; }
    public String getParentOccupation() { return parentOccupation; } public void setParentOccupation(String p) { this.parentOccupation = p; }
    public String getAdminRemarks() { return adminRemarks; } public void setAdminRemarks(String a) { this.adminRemarks = a; }
    public String getProgramName() { return programName; } public void setProgramName(String p) { this.programName = p; }
    public String getStudentName() { return studentName; } public void setStudentName(String s) { this.studentName = s; }
    public String getStudentEmail() { return studentEmail; } public void setStudentEmail(String s) { this.studentEmail = s; }
    public String getDepartmentName() { return departmentName; } public void setDepartmentName(String d) { this.departmentName = d; }
    public String getDegreeType() { return degreeType; } public void setDegreeType(String d) { this.degreeType = d; }
    public String getTenthBoard() { return tenthBoard; } public void setTenthBoard(String t) { this.tenthBoard = t; }
    public String getTwelfthBoard() { return twelfthBoard; } public void setTwelfthBoard(String t) { this.twelfthBoard = t; }
    public String getTwelfthStream() { return twelfthStream; } public void setTwelfthStream(String t) { this.twelfthStream = t; }
    public String getEntranceExam() { return entranceExam; } public void setEntranceExam(String e) { this.entranceExam = e; }
    public Date getDob() { return dob; } public void setDob(Date d) { this.dob = d; }
    public BigDecimal getTenthMarks() { return tenthMarks; } public void setTenthMarks(BigDecimal t) { this.tenthMarks = t; }
    public BigDecimal getTwelfthMarks() { return twelfthMarks; } public void setTwelfthMarks(BigDecimal t) { this.twelfthMarks = t; }
    public BigDecimal getEntranceScore() { return entranceScore; } public void setEntranceScore(BigDecimal e) { this.entranceScore = e; }
    public BigDecimal getApplicableFeePerYear() { return applicableFeePerYear; } public void setApplicableFeePerYear(BigDecimal f) { this.applicableFeePerYear = f; }
    public BigDecimal getTotalProgramFee() { return totalProgramFee; } public void setTotalProgramFee(BigDecimal f) { this.totalProgramFee = f; }
    public BigDecimal getAnnualIncome() { return annualIncome; } public void setAnnualIncome(BigDecimal a) { this.annualIncome = a; }
    public Timestamp getSubmittedAt() { return submittedAt; } public void setSubmittedAt(Timestamp t) { this.submittedAt = t; }
    public Timestamp getReviewedAt() { return reviewedAt; } public void setReviewedAt(Timestamp t) { this.reviewedAt = t; }
}