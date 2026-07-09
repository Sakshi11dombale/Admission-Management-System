<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    request.setAttribute("pageTitle","Engineering Admission Form");
    request.setAttribute("currentPage","apply");
%>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i> Home</a>
    <span class="sep">/</span>
    <span class="current">Apply for Admission</span>
</div>

<c:if test="${not empty errorMsg}">
    <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMsg}</div>
</c:if>

<!-- Page Header -->
<div style="background:linear-gradient(135deg,#0a1628,#1a4b8c);border-radius:16px;padding:24px 28px;margin-bottom:24px;color:#fff">
    <div style="display:flex;align-items:center;gap:16px">
        <div style="width:54px;height:54px;background:rgba(245,158,11,0.2);border:2px solid rgba(245,158,11,0.5);border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:24px">🎓</div>
        <div>
            <h2 style="font-size:20px;font-weight:700;margin-bottom:4px">B.Tech Engineering Admission Form</h2>
            <p style="color:#93c5fd;font-size:13px;margin:0">Academic Year 2025-26 | Fill all details carefully</p>
        </div>
    </div>
</div>

<!-- DEPARTMENT FILTER -->
<div class="card" style="margin-bottom:20px">
    <div class="card-header">
        <h5 class="card-title"><i class="fas fa-building"></i> Select Department</h5>
        <span style="font-size:12px;color:#64748b">Choose department to filter programs</span>
    </div>
    <div class="card-body" style="padding:16px 22px">
        <div style="display:flex;flex-wrap:wrap;gap:8px">
            <a href="${pageContext.request.contextPath}/ApplicationServlet?action=applyForm"
               style="text-decoration:none;padding:8px 16px;border-radius:20px;font-size:12px;font-weight:600;border:1.5px solid ${empty selectedDeptId ? '#2563eb' : '#e2e8f0'};background:${empty selectedDeptId ? '#2563eb' : '#fff'};color:${empty selectedDeptId ? '#fff' : '#64748b'};transition:all 0.2s;display:flex;align-items:center;gap:6px">
                <i class="fas fa-th"></i> All Departments
            </a>
            <c:forEach var="dept" items="${departments}">
                <a href="${pageContext.request.contextPath}/ApplicationServlet?action=applyForm&deptId=${dept.id}"
                   style="text-decoration:none;padding:8px 16px;border-radius:20px;font-size:12px;font-weight:600;border:1.5px solid ${selectedDeptId == dept.id ? '#2563eb' : '#e2e8f0'};background:${selectedDeptId == dept.id ? '#2563eb' : '#fff'};color:${selectedDeptId == dept.id ? '#fff' : '#64748b'};transition:all 0.2s;display:flex;align-items:center;gap:6px">
                    <i class="fas fa-microchip"></i> ${dept.code} — ${dept.name}
                </a>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Step Indicator -->
<div style="display:flex;align-items:center;margin-bottom:24px;background:#fff;border-radius:14px;padding:18px 24px;border:1px solid #e2e8f0;box-shadow:0 2px 8px rgba(0,0,0,0.04)">
    <c:forEach begin="1" end="4" var="i">
        <div id="ind${i}" style="display:flex;align-items:center;gap:8px;flex:1">
            <div id="circle${i}" style="width:34px;height:34px;border-radius:50%;background:${i==1?'#2563eb':'#e2e8f0'};color:${i==1?'#fff':'#94a3b8'};display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;flex-shrink:0;${i==1?'box-shadow:0 0 0 4px rgba(37,99,235,0.15)':''}">${i}</div>
            <div>
                <div id="label${i}" style="font-size:12px;font-weight:${i==1?'700':'600'};color:${i==1?'#2563eb':'#94a3b8'}">
                    <c:choose>
                        <c:when test="${i==1}">Personal Info</c:when>
                        <c:when test="${i==2}">Academic Info</c:when>
                        <c:when test="${i==3}">Category & Fee</c:when>
                        <c:when test="${i==4}">Documents</c:when>
                    </c:choose>
                </div>
            </div>
        </div>
        <c:if test="${i < 4}">
            <div style="flex:1;height:2px;background:#e2e8f0;margin:0 4px;position:relative;max-width:60px">
                <div id="line${i}" style="position:absolute;top:0;left:0;height:100%;width:0%;background:#2563eb;transition:width 0.5s ease"></div>
            </div>
        </c:if>
    </c:forEach>
</div>

<form method="post" action="${pageContext.request.contextPath}/ApplicationServlet" enctype="multipart/form-data" id="applyForm">
    <input type="hidden" name="action" value="submit">

    <!-- ===== STEP 1: PERSONAL + PROGRAM ===== -->
    <div id="step1">
        <!-- Program Selection -->
        <div class="card">
            <div style="background:linear-gradient(135deg,#f0fdf4,#dcfce7);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#059669;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-book-open"></i></div>
                <div style="font-size:14px;font-weight:700;color:#1e293b">Program Selection</div>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-8">
                        <label class="form-label">Select Engineering Program <span style="color:#dc2626">*</span></label>
                        <c:choose>
                            <c:when test="${not empty programs}">
                                <select name="programId" id="programSelect" class="form-select" required onchange="onProgramChange(this)">
                                    <option value="">-- Select Program --</option>
                                    <c:forEach var="prog" items="${programs}">
                                        <option value="${prog.id}"
                                                data-dept="${prog.departmentName}"
                                                data-code="${prog.code}"
                                                data-degree="${prog.degreeType}"
                                                data-dur="${prog.durationYears}"
                                                data-seats="${prog.availableSeats}"
                                                data-elig="${prog.eligibility}"
                                                data-fee-general="${prog.feeGeneral}"
                                                data-fee-obc="${prog.feeObc}"
                                                data-fee-sc="${prog.feeSc}"
                                                data-fee-st="${prog.feeSt}"
                                                data-fee-ews="${prog.feeEws}"
                                                data-fee-minority="${prog.feeMinority}"
                                                data-fee-y1="${prog.feeYear1}"
                                                data-fee-y2="${prog.feeYear2}"
                                                data-fee-y3="${prog.feeYear3}"
                                                data-fee-y4="${prog.feeYear4}"
                                                ${prog.availableSeats == 0 ? 'disabled' : ''}>
                                            [${prog.degreeType}] ${prog.name}
                                            ${prog.availableSeats == 0 ? '— FULL' : ''}
                                        </option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i>
                                    <div>No programs available. <a href="${pageContext.request.contextPath}/ApplicationServlet?action=applyForm">View all programs</a></div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Degree Type</label>
                        <input type="text" id="degreeTypeDisplay" class="form-control" readonly placeholder="Auto-filled" style="background:#f8fafc">
                    </div>
                </div>

                <!-- Program Info Box -->
                <div id="programInfoBox" style="display:none;margin-top:14px;background:#f0f9ff;border-radius:12px;padding:16px;border:1px solid #bae6fd">
                    <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:12px;text-align:center">
                        <div>
                            <div style="font-size:11px;color:#64748b;font-weight:600;margin-bottom:4px">DEPARTMENT</div>
                            <div id="pDept" style="font-weight:700;color:#1e293b;font-size:13px"></div>
                        </div>
                        <div>
                            <div style="font-size:11px;color:#64748b;font-weight:600;margin-bottom:4px">DURATION</div>
                            <div id="pDur" style="font-weight:700;color:#1e293b;font-size:13px"></div>
                        </div>
                        <div>
                            <div style="font-size:11px;color:#64748b;font-weight:600;margin-bottom:4px">SEATS AVAILABLE</div>
                            <div id="pSeats" style="font-weight:700;color:#059669;font-size:13px"></div>
                        </div>
                        <div>
                            <div style="font-size:11px;color:#64748b;font-weight:600;margin-bottom:4px">GENERAL FEE/YR</div>
                            <div id="pFee" style="font-weight:700;color:#1a4b8c;font-size:13px"></div>
                        </div>
                    </div>
                    <div style="margin-top:10px;font-size:12px;color:#64748b;padding-top:10px;border-top:1px solid #bae6fd"><strong>Eligibility:</strong> <span id="pElig"></span></div>
                </div>
            </div>
        </div>

        <!-- Personal Information -->
        <div class="card">
            <div style="background:linear-gradient(135deg,#eff6ff,#dbeafe);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#2563eb;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-user"></i></div>
                <div style="font-size:14px;font-weight:700;color:#1e293b">Personal Information</div>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">First Name <span style="color:#dc2626">*</span></label>
                        <input type="text" name="firstName" class="form-control" placeholder="First name" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Middle Name</label>
                        <input type="text" name="middleName" class="form-control" placeholder="Middle name (optional)">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Last Name <span style="color:#dc2626">*</span></label>
                        <input type="text" name="lastName" class="form-control" placeholder="Last name" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Date of Birth <span style="color:#dc2626">*</span></label>
                        <input type="date" name="dob" class="form-control" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Gender <span style="color:#dc2626">*</span></label>
                        <select name="gender" class="form-select" required>
                            <option value="">Select</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other / Transgender</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Nationality</label>
                        <select name="nationality" class="form-select">
                            <option value="INDIAN" selected>Indian</option>
                            <option value="NRI">NRI</option>
                            <option value="OCI">OCI</option>
                            <option value="FOREIGN">Foreign National</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Permanent Address</label>
                        <textarea name="address" class="form-control" rows="2" placeholder="Enter full permanent address"></textarea>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">City / Village</label>
                        <input type="text" name="city" class="form-control" placeholder="City">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">State <span style="color:#dc2626">*</span></label>
                        <select name="state" class="form-select" required>
                            <option value="">Select State</option>
                            <option>Andhra Pradesh</option><option>Arunachal Pradesh</option><option>Assam</option>
                            <option>Bihar</option><option>Chhattisgarh</option><option>Goa</option>
                            <option>Gujarat</option><option>Haryana</option><option>Himachal Pradesh</option>
                            <option>Jharkhand</option><option>Karnataka</option><option>Kerala</option>
                            <option>Madhya Pradesh</option><option>Maharashtra</option><option>Manipur</option>
                            <option>Meghalaya</option><option>Mizoram</option><option>Nagaland</option>
                            <option>Odisha</option><option>Punjab</option><option>Rajasthan</option>
                            <option>Sikkim</option><option>Tamil Nadu</option><option>Telangana</option>
                            <option>Tripura</option><option>Uttar Pradesh</option><option>Uttarakhand</option>
                            <option>West Bengal</option><option>Delhi</option><option>Jammu & Kashmir</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Pincode</label>
                        <input type="text" name="pincode" class="form-control" placeholder="6-digit PIN" maxlength="6">
                    </div>
                </div>
            </div>
        </div>

        <!-- Parent/Guardian Info -->
        <div class="card">
            <div style="background:linear-gradient(135deg,#fff7ed,#fed7aa);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#ea580c;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-users"></i></div>
                <div style="font-size:14px;font-weight:700;color:#1e293b">Parent / Guardian Information</div>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Parent / Guardian Name <span style="color:#dc2626">*</span></label>
                        <input type="text" name="parentName" class="form-control" placeholder="Full name" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Relationship</label>
                        <select name="parentRelation" class="form-select">
                            <option value="FATHER">Father</option>
                            <option value="MOTHER">Mother</option>
                            <option value="GUARDIAN">Guardian</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Mobile Number <span style="color:#dc2626">*</span></label>
                        <input type="text" name="parentPhone" class="form-control" placeholder="10-digit number" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Occupation</label>
                        <input type="text" name="parentOccupation" class="form-control" placeholder="e.g. Farmer, Government Employee">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Annual Family Income (Rs.)</label>
                        <input type="number" name="annualIncome" class="form-control" placeholder="e.g. 250000" min="0">
                        <div style="font-size:11px;color:#64748b;margin-top:3px">Required for scholarship and category fee concession</div>
                    </div>
                </div>
            </div>
        </div>

        <div style="display:flex;justify-content:flex-end">
            <button type="button" class="btn btn-primary" onclick="goStep(2)">
                Next: Academic Information <i class="fas fa-arrow-right"></i>
            </button>
        </div>
    </div>

    <!-- ===== STEP 2: ACADEMIC INFO ===== -->
    <div id="step2" style="display:none">
        <div class="card">
            <div style="background:linear-gradient(135deg,#fefce8,#fef9c3);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#d97706;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-graduation-cap"></i></div>
                <div style="font-size:14px;font-weight:700;color:#1e293b">10th Standard Details</div>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">10th Percentage <span style="color:#dc2626">*</span></label>
                        <input type="number" name="tenthMarks" id="marks10" class="form-control" required min="33" max="100" step="0.01" placeholder="e.g. 85.50" oninput="updateScoreDisplay()">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Board <span style="color:#dc2626">*</span></label>
                        <select name="tenthBoard" class="form-select" required>
                            <option value="">Select Board</option>
                            <option value="CBSE">CBSE</option>
                            <option value="ICSE">ICSE</option>
                            <option value="State Board">State Board</option>
                            <option value="NIOS">NIOS</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Year of Passing</label>
                        <input type="number" name="tenthYear" class="form-control" placeholder="e.g. 2022" min="2010" max="2024">
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div style="background:linear-gradient(135deg,#fefce8,#fef9c3);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#d97706;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-school"></i></div>
                <div style="font-size:14px;font-weight:700;color:#1e293b">12th Standard Details</div>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">12th Percentage <span style="color:#dc2626">*</span></label>
                        <input type="number" name="twelfthMarks" id="marks12" class="form-control" required min="33" max="100" step="0.01" placeholder="e.g. 78.00" oninput="updateScoreDisplay()">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Board <span style="color:#dc2626">*</span></label>
                        <select name="twelfthBoard" class="form-select" required>
                            <option value="">Select Board</option>
                            <option value="CBSE">CBSE</option>
                            <option value="ICSE">ICSE</option>
                            <option value="State Board">State Board</option>
                            <option value="NIOS">NIOS</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Stream <span style="color:#dc2626">*</span></label>
                        <select name="twelfthStream" class="form-select" required>
                            <option value="">Select Stream</option>
                            <option value="PCM">PCM (Physics-Chemistry-Maths)</option>
                            <option value="PCB">PCB (Physics-Chemistry-Biology)</option>
                            <option value="PCMB">PCMB (All four)</option>
                            <option value="Commerce">Commerce with Maths</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Year of Passing</label>
                        <input type="number" name="twelfthYear" class="form-control" placeholder="e.g. 2024" min="2010" max="2025">
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div style="background:linear-gradient(135deg,#fdf4ff,#fae8ff);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#7c3aed;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-trophy"></i></div>
                <div style="font-size:14px;font-weight:700;color:#1e293b">Entrance Exam Details</div>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Entrance Exam</label>
                        <select name="entranceExam" class="form-select">
                            <option value="">-- Select Exam --</option>
                            <option value="JEE_MAINS">JEE Mains</option>
                            <option value="JEE_ADVANCED">JEE Advanced</option>
                            <option value="MHT_CET">MHT-CET</option>
                            <option value="STATE_CET">State CET</option>
                            <option value="COLLEGE_EXAM">College Own Exam</option>
                            <option value="NONE">Not Applicable</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Score / Percentile</label>
                        <input type="number" name="entranceScore" id="entScore" class="form-control" min="0" step="0.01" placeholder="e.g. 95.40" oninput="updateScoreDisplay()">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">All India Rank</label>
                        <input type="number" name="entranceRank" class="form-control" min="1" placeholder="e.g. 12500">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Application / Roll No.</label>
                        <input type="text" name="entranceRollNo" class="form-control" placeholder="Exam roll number">
                    </div>
                </div>

                <!-- Score Summary -->
                <div style="margin-top:18px;display:grid;grid-template-columns:repeat(3,1fr);gap:12px">
                    <div style="background:linear-gradient(135deg,#eff6ff,#dbeafe);border-radius:12px;padding:16px;text-align:center">
                        <div style="font-size:28px;font-weight:800;color:#1a4b8c" id="disp10">—</div>
                        <div style="font-size:11px;color:#64748b;margin-top:4px;font-weight:600">10TH MARKS</div>
                    </div>
                    <div style="background:linear-gradient(135deg,#f0fdf4,#dcfce7);border-radius:12px;padding:16px;text-align:center">
                        <div style="font-size:28px;font-weight:800;color:#059669" id="disp12">—</div>
                        <div style="font-size:11px;color:#64748b;margin-top:4px;font-weight:600">12TH MARKS</div>
                    </div>
                    <div style="background:linear-gradient(135deg,#fdf4ff,#fae8ff);border-radius:12px;padding:16px;text-align:center">
                        <div style="font-size:28px;font-weight:800;color:#7c3aed" id="dispEnt">—</div>
                        <div style="font-size:11px;color:#64748b;margin-top:4px;font-weight:600">ENTRANCE SCORE</div>
                    </div>
                </div>
            </div>
        </div>

        <div style="display:flex;justify-content:space-between">
            <button type="button" class="btn btn-outline" onclick="goStep(1)"><i class="fas fa-arrow-left"></i> Back</button>
            <button type="button" class="btn btn-primary" onclick="goStep(3)">Next: Category & Fee <i class="fas fa-arrow-right"></i></button>
        </div>
    </div>

    <!-- ===== STEP 3: CATEGORY + FEE CALCULATION ===== -->
    <div id="step3" style="display:none">
        <div class="card">
            <div style="background:linear-gradient(135deg,#fdf4ff,#fae8ff);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#7c3aed;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-id-card"></i></div>
                <div>
                    <div style="font-size:14px;font-weight:700;color:#1e293b">Category / Religion Details</div>
                    <div style="font-size:11px;color:#64748b">Fee concession is applied based on your reservation category</div>
                </div>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Reservation Category <span style="color:#dc2626">*</span></label>
                        <select name="category" id="catSelect" class="form-select" required onchange="calcFee()">
                            <option value="GENERAL">General (No Reservation)</option>
                            <option value="OBC">OBC — Other Backward Class (25% off)</option>
                            <option value="SC">SC — Scheduled Caste (50% off)</option>
                            <option value="ST">ST — Scheduled Tribe (50% off)</option>
                            <option value="EWS">EWS — Economically Weaker Section (30% off)</option>
                            <option value="MINORITY">Minority (10% off)</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Religion <span style="color:#dc2626">*</span></label>
                        <select name="religion" class="form-select" required>
                            <option value="HINDU">Hindu</option>
                            <option value="MUSLIM">Muslim</option>
                            <option value="CHRISTIAN">Christian</option>
                            <option value="SIKH">Sikh</option>
                            <option value="BUDDHIST">Buddhist</option>
                            <option value="JAIN">Jain</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Caste</label>
                        <input type="text" name="caste" class="form-control" placeholder="Enter your caste (optional)">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Category Certificate Number</label>
                        <input type="text" name="categoryCertNo" class="form-control" placeholder="Caste certificate number if applicable">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Do you want to apply for Scholarship?</label>
                        <select name="scholarship" class="form-select">
                            <option value="NO">No</option>
                            <option value="YES_GOVT">Yes — Government Scholarship</option>
                            <option value="YES_MERIT">Yes — Merit Scholarship</option>
                            <option value="YES_SPORTS">Yes — Sports Quota</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- FEE BREAKDOWN CARD -->
        <div class="card">
            <div style="background:linear-gradient(135deg,#0a1628,#1a4b8c);padding:14px 22px;border-bottom:1px solid #1e3a8a;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:rgba(245,158,11,0.2);border:2px solid rgba(245,158,11,0.4);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:15px">💰</div>
                <div>
                    <div style="font-size:14px;font-weight:700;color:#fff">Fee Structure</div>
                    <div style="font-size:11px;color:#93c5fd">Based on your category and selected program</div>
                </div>
            </div>
            <div class="card-body">
                <div id="feeNoProg" style="text-align:center;padding:20px;color:#64748b">
                    <i class="fas fa-info-circle" style="font-size:24px;color:#94a3b8;margin-bottom:8px;display:block"></i>
                    Please select a program in Step 1 to see the fee structure.
                </div>
                <div id="feeContent" style="display:none">
                    <!-- Category Fee -->
                    <div style="background:linear-gradient(135deg,#1a4b8c,#2563eb);border-radius:14px;padding:20px;color:#fff;margin-bottom:20px">
                        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px">
                            <div>
                                <div style="font-size:11px;opacity:0.85;margin-bottom:4px">YOUR APPLICABLE FEE (Per Year)</div>
                                <div style="font-size:36px;font-weight:800" id="yourFee">₹0</div>
                                <div style="font-size:12px;opacity:0.8;margin-top:4px" id="yourFeeNote"></div>
                            </div>
                            <div style="text-align:right">
                                <div id="catBadge" style="background:rgba(255,255,255,0.2);padding:6px 14px;border-radius:20px;font-size:12px;font-weight:700;margin-bottom:6px">GENERAL</div>
                                <div id="discountText" style="font-size:11px;color:#86efac"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Year-wise fee breakdown table -->
                    <h4 style="font-size:14px;font-weight:700;color:#1e293b;margin-bottom:12px"><i class="fas fa-calendar-alt" style="color:#2563eb;margin-right:6px"></i>Year-wise Fee Payment Schedule</h4>
                    <div style="overflow-x:auto">
                        <table style="width:100%;border-collapse:collapse;font-size:13px">
                            <thead>
                                <tr style="background:#f8fafc">
                                    <th style="padding:10px 14px;text-align:left;font-size:11px;font-weight:700;color:#64748b;text-transform:uppercase;border-bottom:1px solid #e2e8f0">Year</th>
                                    <th style="padding:10px 14px;text-align:left;font-size:11px;font-weight:700;color:#64748b;text-transform:uppercase;border-bottom:1px solid #e2e8f0">Academic Year</th>
                                    <th style="padding:10px 14px;text-align:right;font-size:11px;font-weight:700;color:#64748b;text-transform:uppercase;border-bottom:1px solid #e2e8f0">Base Fee</th>
                                    <th style="padding:10px 14px;text-align:right;font-size:11px;font-weight:700;color:#64748b;text-transform:uppercase;border-bottom:1px solid #e2e8f0">Discount</th>
                                    <th style="padding:10px 14px;text-align:right;font-size:11px;font-weight:700;color:#64748b;text-transform:uppercase;border-bottom:1px solid #e2e8f0">Your Fee</th>
                                </tr>
                            </thead>
                            <tbody id="feeTableBody"></tbody>
                            <tfoot>
                                <tr style="background:linear-gradient(135deg,#eff6ff,#dbeafe)">
                                    <td colspan="4" style="padding:12px 14px;font-weight:700;color:#1e293b;border-top:2px solid #bfdbfe">TOTAL PROGRAM FEE</td>
                                    <td style="padding:12px 14px;font-weight:800;color:#1a4b8c;text-align:right;border-top:2px solid #bfdbfe;font-size:15px" id="totalFee">₹0</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <!-- Fee comparison across categories -->
                    <div style="margin-top:18px">
                        <div style="font-size:13px;font-weight:700;color:#1e293b;margin-bottom:10px">Fee Comparison by Category (Annual)</div>
                        <div id="feeComparison" style="display:grid;grid-template-columns:repeat(3,1fr);gap:10px"></div>
                    </div>
                </div>
            </div>
        </div>

        <div style="display:flex;justify-content:space-between">
            <button type="button" class="btn btn-outline" onclick="goStep(2)"><i class="fas fa-arrow-left"></i> Back</button>
            <button type="button" class="btn btn-primary" onclick="goStep(4)">Next: Upload Documents <i class="fas fa-arrow-right"></i></button>
        </div>
    </div>

    <!-- ===== STEP 4: DOCUMENTS ===== -->
    <div id="step4" style="display:none">
        <div class="card">
            <div style="background:linear-gradient(135deg,#f0fdf4,#dcfce7);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#059669;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-cloud-upload-alt"></i></div>
                <div>
                    <div style="font-size:14px;font-weight:700;color:#1e293b">Upload Documents</div>
                    <div style="font-size:11px;color:#64748b">PDF or image files only. Max 5MB each. Documents marked * are mandatory.</div>
                </div>
            </div>
            <div class="card-body">
                <div class="alert alert-info" style="margin-bottom:16px">
                    <i class="fas fa-info-circle"></i>
                    <div>You can submit the application and upload documents later from "My Applications" if not ready now.</div>
                </div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Passport Photo <span style="color:#dc2626">*</span></label>
                        <input type="file" name="doc_PHOTO" class="form-control" accept=".jpg,.jpeg,.png">
                        <div style="font-size:11px;color:#64748b;margin-top:3px">Recent color photograph (jpg/png)</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">10th Marksheet <span style="color:#dc2626">*</span></label>
                        <input type="file" name="doc_TENTH_MARKSHEET" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">12th Marksheet <span style="color:#dc2626">*</span></label>
                        <input type="file" name="doc_TWELFTH_MARKSHEET" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Entrance Exam Score Card</label>
                        <input type="file" name="doc_ENTRANCE_CERT" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                        <div style="font-size:11px;color:#64748b;margin-top:3px">JEE/GATE/CET score card</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Category / Caste Certificate</label>
                        <input type="file" name="doc_CATEGORY_CERT" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                        <div style="font-size:11px;color:#64748b;margin-top:3px">Required for SC/ST/OBC/EWS</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Income Certificate</label>
                        <input type="file" name="doc_INCOME_CERT" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                        <div style="font-size:11px;color:#64748b;margin-top:3px">For fee concession and scholarship</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Domicile Certificate</label>
                        <input type="file" name="doc_DOMICILE_CERT" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Aadhar Card / ID Proof <span style="color:#dc2626">*</span></label>
                        <input type="file" name="doc_ID_PROOF" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Migration Certificate</label>
                        <input type="file" name="doc_MIGRATION_CERT" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                        <div style="font-size:11px;color:#64748b;margin-top:3px">If from outside state</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Declaration -->
        <div class="card">
            <div style="background:linear-gradient(135deg,#f0fdf4,#dcfce7);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
                <div style="width:34px;height:34px;background:#059669;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px"><i class="fas fa-shield-alt"></i></div>
                <div style="font-size:14px;font-weight:700;color:#1e293b">Undertaking & Declaration</div>
            </div>
            <div class="card-body">
                <label style="display:flex;align-items:flex-start;gap:12px;cursor:pointer">
                    <input type="checkbox" required style="width:18px;height:18px;margin-top:2px;accent-color:#2563eb;flex-shrink:0">
                    <span style="font-size:13px;color:#374151;line-height:1.7">
                        I hereby solemnly declare that all information furnished in this application form is true, correct and complete.
                        I understand that my category/religion details are correct and I possess the required certificates.
                        I am aware that any false declaration regarding my category will lead to cancellation of admission and legal action.
                        I agree to abide by all rules, regulations and code of conduct of the institution.
                        I understand the applicable fee structure for my program and category.
                    </span>
                </label>
            </div>
        </div>

        <div style="display:flex;justify-content:space-between;align-items:center">
            <button type="button" class="btn btn-outline" onclick="goStep(3)"><i class="fas fa-arrow-left"></i> Back</button>
            <button type="submit" id="submitBtn" style="background:linear-gradient(135deg,#f59e0b,#f97316);color:#fff;border:none;padding:14px 36px;border-radius:10px;font-size:15px;font-weight:700;cursor:pointer;display:inline-flex;align-items:center;gap:10px;box-shadow:0 4px 16px rgba(245,158,11,0.4);transition:all 0.2s">
                <i class="fas fa-paper-plane"></i> Submit Engineering Application
            </button>
        </div>
    </div>
</form>

<script>
var cur = 1;
var totalSteps = 4;
var progData = null;

function onProgramChange(sel) {
    var opt = sel.options[sel.selectedIndex];
    if (!sel.value) { document.getElementById('programInfoBox').style.display='none'; progData=null; return; }
    document.getElementById('degreeTypeDisplay').value = opt.getAttribute('data-degree') || '';
    document.getElementById('pDept').textContent  = opt.getAttribute('data-dept') || '';
    document.getElementById('pDur').textContent   = opt.getAttribute('data-dur') + ' Years';
    document.getElementById('pSeats').textContent = opt.getAttribute('data-seats') + ' seats';
    document.getElementById('pFee').textContent   = '₹' + parseInt(opt.getAttribute('data-fee-general')).toLocaleString('en-IN');
    document.getElementById('pElig').textContent  = opt.getAttribute('data-elig') || '';
    document.getElementById('programInfoBox').style.display = 'block';
    progData = {
        name: opt.text.split('—')[0].trim().replace(/^\[.*?\]\s*/,''),
        dur:  parseInt(opt.getAttribute('data-dur')),
        fy1:  parseFloat(opt.getAttribute('data-fee-y1')) || 0,
        fy2:  parseFloat(opt.getAttribute('data-fee-y2')) || 0,
        fy3:  parseFloat(opt.getAttribute('data-fee-y3')) || 0,
        fy4:  parseFloat(opt.getAttribute('data-fee-y4')) || 0,
        general: parseFloat(opt.getAttribute('data-fee-general')) || 0,
        obc:     parseFloat(opt.getAttribute('data-fee-obc')) || 0,
        sc:      parseFloat(opt.getAttribute('data-fee-sc')) || 0,
        st:      parseFloat(opt.getAttribute('data-fee-st')) || 0,
        ews:     parseFloat(opt.getAttribute('data-fee-ews')) || 0,
        minority:parseFloat(opt.getAttribute('data-fee-minority')) || 0
    };
    calcFee();
}

function getCatFee(cat) {
    if (!progData) return 0;
    switch(cat) {
        case 'OBC':      return progData.obc;
        case 'SC':       return progData.sc;
        case 'ST':       return progData.st;
        case 'EWS':      return progData.ews;
        case 'MINORITY': return progData.minority;
        default:         return progData.general;
    }
}

function calcFee() {
    if (!progData) { document.getElementById('feeNoProg').style.display='block'; document.getElementById('feeContent').style.display='none'; return; }
    var cat = document.getElementById('catSelect').value;
    var catFee = getCatFee(cat);
    var genFee = progData.general;
    var discountPct = genFee > 0 ? Math.round(((genFee - catFee) / genFee) * 100) : 0;

    document.getElementById('feeNoProg').style.display = 'none';
    document.getElementById('feeContent').style.display = 'block';
    document.getElementById('yourFee').textContent = '₹' + catFee.toLocaleString('en-IN');
    document.getElementById('yourFeeNote').textContent = progData.name + ' • Per Year';
    document.getElementById('catBadge').textContent = cat;
    document.getElementById('discountText').textContent = discountPct > 0 ? discountPct + '% concession applied' : 'Standard fee (no concession)';

    // Year-wise table
    var acYears = ['2024-25','2025-26','2026-27','2027-28','2028-29'];
    var yFees = [progData.fy1, progData.fy2, progData.fy3, progData.fy4];
    var dur = progData.dur;
    var totalBase = 0, totalYours = 0;
    var rows = '';
    for (var y = 0; y < dur; y++) {
        var baseFeeY = yFees[y] || progData.general;
        var catRatio = genFee > 0 ? (catFee / genFee) : 1;
        var yourFeeY = Math.round(baseFeeY * catRatio);
        var disc = baseFeeY - yourFeeY;
        totalBase += baseFeeY; totalYours += yourFeeY;
        rows += '<tr style="border-bottom:1px solid #f1f5f9">' +
            '<td style="padding:11px 14px;font-weight:600">Year ' + (y+1) + '<br><span style="font-size:11px;color:#64748b;font-weight:400">Semester 1 &amp; 2</span></td>' +
            '<td style="padding:11px 14px;color:#64748b;font-size:13px">' + acYears[y] + '</td>' +
            '<td style="padding:11px 14px;text-align:right;color:#64748b">₹' + baseFeeY.toLocaleString('en-IN') + '</td>' +
            '<td style="padding:11px 14px;text-align:right;color:#dc2626;font-weight:600">' + (disc>0?'-₹'+disc.toLocaleString('en-IN'):'—') + '</td>' +
            '<td style="padding:11px 14px;text-align:right;font-weight:700;color:#1a4b8c">₹' + yourFeeY.toLocaleString('en-IN') + '</td>' +
            '</tr>';
    }
    document.getElementById('feeTableBody').innerHTML = rows;
    document.getElementById('totalFee').textContent = '₹' + totalYours.toLocaleString('en-IN');

    // Category comparison
    var cats = [
        {k:'GENERAL',l:'General',c:'#64748b'},
        {k:'OBC',l:'OBC',c:'#2563eb'},
        {k:'EWS',l:'EWS',c:'#7c3aed'},
        {k:'SC',l:'SC',c:'#059669'},
        {k:'ST',l:'ST',c:'#d97706'},
        {k:'MINORITY',l:'Minority',c:'#dc2626'}
    ];
    var comp = '';
    cats.forEach(function(ct) {
        var f = getCatFee(ct.k);
        var isCurrent = ct.k === cat;
        comp += '<div style="background:' + (isCurrent?'linear-gradient(135deg,#eff6ff,#dbeafe)':'#f8fafc') + ';border:' + (isCurrent?'2px solid #2563eb':'1px solid #e2e8f0') + ';border-radius:10px;padding:12px;text-align:center">' +
            '<div style="font-size:11px;font-weight:700;color:' + ct.c + ';margin-bottom:4px">' + ct.l + '</div>' +
            '<div style="font-size:16px;font-weight:800;color:#1e293b">₹' + f.toLocaleString('en-IN') + '</div>' +
            '<div style="font-size:10px;color:#64748b;margin-top:2px">per year</div>' +
            (isCurrent?'<div style="margin-top:4px;font-size:10px;font-weight:700;color:#2563eb">← YOUR CATEGORY</div>':'') +
            '</div>';
    });
    document.getElementById('feeComparison').innerHTML = comp;
}

function updateScoreDisplay() {
    var v10  = document.getElementById('marks10').value;
    var v12  = document.getElementById('marks12').value;
    var vEnt = document.getElementById('entScore').value;
    document.getElementById('disp10').textContent  = v10  ? v10  + '%' : '—';
    document.getElementById('disp12').textContent  = v12  ? v12  + '%' : '—';
    document.getElementById('dispEnt').textContent = vEnt ? vEnt      : '—';
}

function goStep(n) {
    if (n > cur) {
        var stepEl = document.getElementById('step' + cur);
        var inputs = stepEl.querySelectorAll('input[required],select[required],textarea[required]');
        for (var i = 0; i < inputs.length; i++) {
            if (!inputs[i].value || !inputs[i].value.toString().trim()) {
                inputs[i].focus();
                inputs[i].style.borderColor = '#dc2626';
                setTimeout(function(el){ el.style.borderColor = ''; }, 2000, inputs[i]);
                alert('Please fill all required fields before proceeding.');
                return;
            }
        }
    }
    document.getElementById('step' + cur).style.display = 'none';
    document.getElementById('step' + n).style.display = 'block';
    updateIndicators(n);
    cur = n;
    window.scrollTo({top: 0, behavior: 'smooth'});
}

function updateIndicators(n) {
    for (var i = 1; i <= totalSteps; i++) {
        var circle = document.getElementById('circle' + i);
        var label  = document.getElementById('label'  + i);
        if (!circle || !label) continue;
        if (i < n) {
            circle.style.background = '#2563eb'; circle.style.color = '#fff';
            circle.innerHTML = '&#10003;'; circle.style.boxShadow = '';
            label.style.color = '#2563eb'; label.style.fontWeight = '600';
        } else if (i === n) {
            circle.style.background = '#2563eb'; circle.style.color = '#fff';
            circle.textContent = i; circle.style.boxShadow = '0 0 0 4px rgba(37,99,235,0.15)';
            label.style.color = '#2563eb'; label.style.fontWeight = '700';
        } else {
            circle.style.background = '#e2e8f0'; circle.style.color = '#94a3b8';
            circle.textContent = i; circle.style.boxShadow = '';
            label.style.color = '#94a3b8'; label.style.fontWeight = '600';
        }
        if (i < totalSteps) {
            var line = document.getElementById('line' + i);
            if (line) line.style.width = i < n ? '100%' : '0%';
        }
    }
}

document.getElementById('applyForm').addEventListener('submit', function() {
    var btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting your application...';
});
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>