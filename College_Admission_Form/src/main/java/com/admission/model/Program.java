package com.admission.model;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Program {
    private int id, departmentId, durationYears, totalSeats, availableSeats;
    private String name, code, degreeType, eligibility, description, departmentName, departmentCode;
    private BigDecimal baseFee;
    private BigDecimal feeGeneral, feeObc, feeSc, feeSt, feeEws, feeMinority;
    private BigDecimal feeYear1, feeYear2, feeYear3, feeYear4;
    private boolean active;
    private Timestamp createdAt;

    public int getId() { return id; } public void setId(int i) { this.id = i; }
    public int getDepartmentId() { return departmentId; } public void setDepartmentId(int d) { this.departmentId = d; }
    public int getDurationYears() { return durationYears; } public void setDurationYears(int d) { this.durationYears = d; }
    public int getTotalSeats() { return totalSeats; } public void setTotalSeats(int t) { this.totalSeats = t; }
    public int getAvailableSeats() { return availableSeats; } public void setAvailableSeats(int a) { this.availableSeats = a; }
    public String getName() { return name; } public void setName(String n) { this.name = n; }
    public String getCode() { return code; } public void setCode(String c) { this.code = c; }
    public String getDegreeType() { return degreeType; } public void setDegreeType(String d) { this.degreeType = d; }
    public String getEligibility() { return eligibility; } public void setEligibility(String e) { this.eligibility = e; }
    public String getDescription() { return description; } public void setDescription(String d) { this.description = d; }
    public String getDepartmentName() { return departmentName; } public void setDepartmentName(String d) { this.departmentName = d; }
    public String getDepartmentCode() { return departmentCode; } public void setDepartmentCode(String d) { this.departmentCode = d; }
    public BigDecimal getBaseFee() { return baseFee; } public void setBaseFee(BigDecimal b) { this.baseFee = b; }
    public BigDecimal getFeeGeneral() { return feeGeneral; } public void setFeeGeneral(BigDecimal f) { this.feeGeneral = f; }
    public BigDecimal getFeeObc() { return feeObc; } public void setFeeObc(BigDecimal f) { this.feeObc = f; }
    public BigDecimal getFeeSc() { return feeSc; } public void setFeeSc(BigDecimal f) { this.feeSc = f; }
    public BigDecimal getFeeSt() { return feeSt; } public void setFeeSt(BigDecimal f) { this.feeSt = f; }
    public BigDecimal getFeeEws() { return feeEws; } public void setFeeEws(BigDecimal f) { this.feeEws = f; }
    public BigDecimal getFeeMinority() { return feeMinority; } public void setFeeMinority(BigDecimal f) { this.feeMinority = f; }
    public BigDecimal getFeeYear1() { return feeYear1; } public void setFeeYear1(BigDecimal f) { this.feeYear1 = f; }
    public BigDecimal getFeeYear2() { return feeYear2; } public void setFeeYear2(BigDecimal f) { this.feeYear2 = f; }
    public BigDecimal getFeeYear3() { return feeYear3; } public void setFeeYear3(BigDecimal f) { this.feeYear3 = f; }
    public BigDecimal getFeeYear4() { return feeYear4; } public void setFeeYear4(BigDecimal f) { this.feeYear4 = f; }
    public boolean isActive() { return active; } public void setActive(boolean a) { this.active = a; }
    public Timestamp getCreatedAt() { return createdAt; } public void setCreatedAt(Timestamp t) { this.createdAt = t; }
    public int getFilledSeats() { return totalSeats - availableSeats; }
    public double getOccupancyPercent() { return totalSeats == 0 ? 0 : (getFilledSeats() * 100.0) / totalSeats; }

    public BigDecimal getFeeByCategory(String category) {
        if (category == null) return feeGeneral;
        switch (category.toUpperCase()) {
            case "OBC":      return feeObc;
            case "SC":       return feeSc;
            case "ST":       return feeSt;
            case "EWS":      return feeEws;
            case "MINORITY": return feeMinority;
            default:         return feeGeneral;
        }
    }

    public BigDecimal getFeeByYear(int year) {
        switch (year) {
            case 1: return feeYear1;
            case 2: return feeYear2;
            case 3: return feeYear3;
            case 4: return feeYear4;
            default: return baseFee;
        }
    }
}