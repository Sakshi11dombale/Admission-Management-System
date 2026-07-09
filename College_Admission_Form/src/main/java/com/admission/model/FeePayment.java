package com.admission.model;
import java.math.BigDecimal;
import java.sql.*;

public class FeePayment {
    private int id, applicationId, studentId, yearOfStudy, semester;
    private String transactionId, paymentType, paymentMode, paymentStatus;
    private String academicYear, bankReference, remarks;
    private String applicantName, applicationNo, programName, departmentName;
    private BigDecimal amount;
    private Timestamp paymentDate;
    private Date dueDate;

    public int getId() { return id; } public void setId(int i) { this.id = i; }
    public int getApplicationId() { return applicationId; } public void setApplicationId(int a) { this.applicationId = a; }
    public int getStudentId() { return studentId; } public void setStudentId(int s) { this.studentId = s; }
    public int getYearOfStudy() { return yearOfStudy; } public void setYearOfStudy(int y) { this.yearOfStudy = y; }
    public int getSemester() { return semester; } public void setSemester(int s) { this.semester = s; }
    public String getTransactionId() { return transactionId; } public void setTransactionId(String t) { this.transactionId = t; }
    public String getPaymentType() { return paymentType; } public void setPaymentType(String p) { this.paymentType = p; }
    public String getPaymentMode() { return paymentMode; } public void setPaymentMode(String p) { this.paymentMode = p; }
    public String getPaymentStatus() { return paymentStatus; } public void setPaymentStatus(String p) { this.paymentStatus = p; }
    public String getAcademicYear() { return academicYear; } public void setAcademicYear(String a) { this.academicYear = a; }
    public String getBankReference() { return bankReference; } public void setBankReference(String b) { this.bankReference = b; }
    public String getRemarks() { return remarks; } public void setRemarks(String r) { this.remarks = r; }
    public String getApplicantName() { return applicantName; } public void setApplicantName(String a) { this.applicantName = a; }
    public String getApplicationNo() { return applicationNo; } public void setApplicationNo(String a) { this.applicationNo = a; }
    public String getProgramName() { return programName; } public void setProgramName(String p) { this.programName = p; }
    public String getDepartmentName() { return departmentName; } public void setDepartmentName(String d) { this.departmentName = d; }
    public BigDecimal getAmount() { return amount; } public void setAmount(BigDecimal a) { this.amount = a; }
    public Timestamp getPaymentDate() { return paymentDate; } public void setPaymentDate(Timestamp t) { this.paymentDate = t; }
    public Date getDueDate() { return dueDate; } public void setDueDate(Date d) { this.dueDate = d; }
}
