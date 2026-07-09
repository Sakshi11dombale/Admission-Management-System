<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    request.setAttribute("pageTitle","Programs");
    request.setAttribute("currentPage","programs");
%>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i> Home</a>
    <span class="sep">/</span>
    <span class="current">Programs</span>
</div>

<c:if test="${not empty successMsg}">
    <div class="alert alert-success" data-auto-dismiss><i class="fas fa-check-circle"></i><div>${successMsg}</div></div>
</c:if>
<c:if test="${not empty errorMsg}">
    <div class="alert alert-danger" data-auto-dismiss><i class="fas fa-exclamation-circle"></i><div>${errorMsg}</div></div>
</c:if>

<div class="section-header">
    <h2 class="section-title"><i class="fas fa-book-open"></i> Engineering Programs</h2>
    <button class="btn btn-primary" onclick="openModal('addProgramModal')">
        <i class="fas fa-plus"></i> Add Program
    </button>
</div>

<!-- Filter by Degree Type -->
<div class="card" style="margin-bottom:20px">
    <div class="card-body" style="padding:14px 20px">
        <div style="display:flex;flex-wrap:wrap;gap:8px;align-items:center">
            <span style="font-size:13px;font-weight:600;color:#64748b;margin-right:4px">Filter:</span>
            <button onclick="filterPrograms('ALL')" id="btn-ALL"
                    style="padding:6px 16px;border-radius:20px;border:1.5px solid #2563eb;background:#2563eb;color:#fff;font-size:12px;font-weight:600;cursor:pointer">
                All Programs
            </button>
            <button onclick="filterPrograms('B.Tech')" id="btn-BTech"
                    style="padding:6px 16px;border-radius:20px;border:1.5px solid #e2e8f0;background:#fff;color:#64748b;font-size:12px;font-weight:600;cursor:pointer">
                B.Tech
            </button>
            <button onclick="filterPrograms('M.Tech')" id="btn-MTech"
                    style="padding:6px 16px;border-radius:20px;border:1.5px solid #e2e8f0;background:#fff;color:#64748b;font-size:12px;font-weight:600;cursor:pointer">
                M.Tech
            </button>
            <button onclick="filterPrograms('Diploma')" id="btn-Diploma"
                    style="padding:6px 16px;border-radius:20px;border:1.5px solid #e2e8f0;background:#fff;color:#64748b;font-size:12px;font-weight:600;cursor:pointer">
                Diploma
            </button>
        </div>
    </div>
</div>

<!-- Programs Grid -->
<div class="row g-4" id="programsGrid">
    <c:choose>
        <c:when test="${not empty programs}">
            <c:forEach var="prog" items="${programs}">
                <div class="col-lg-4 col-md-6 prog-card" data-degree="${prog.degreeType}">
                    <div class="card h-100" style="transition:all 0.25s">
                        <div style="background:linear-gradient(135deg,#0a1628,#1a4b8c);padding:16px 18px;display:flex;justify-content:space-between;align-items:flex-start">
                            <div>
                                <div style="display:flex;gap:6px;margin-bottom:8px;flex-wrap:wrap">
                                    <span style="background:rgba(245,158,11,0.2);border:1px solid rgba(245,158,11,0.4);color:#f59e0b;padding:3px 10px;border-radius:6px;font-size:11px;font-weight:700">${prog.code}</span>
                                    <span style="background:rgba(255,255,255,0.15);color:#fff;padding:3px 10px;border-radius:6px;font-size:11px;font-weight:600">${prog.degreeType}</span>
                                    <c:choose>
                                        <c:when test="${prog.active}"><span style="background:rgba(16,185,129,0.2);color:#34d399;padding:3px 8px;border-radius:6px;font-size:10px;font-weight:700">ACTIVE</span></c:when>
                                        <c:otherwise><span style="background:rgba(239,68,68,0.2);color:#fca5a5;padding:3px 8px;border-radius:6px;font-size:10px;font-weight:700">INACTIVE</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="color:#fff;font-size:14px;font-weight:700;line-height:1.3">${prog.name}</div>
                            </div>
                            <div style="display:flex;flex-direction:column;gap:4px;flex-shrink:0">
                                <button class="btn btn-outline btn-xs"
                                        style="background:rgba(255,255,255,0.1);border-color:rgba(255,255,255,0.3);color:#fff;font-size:11px"
                                        onclick="editProgram(${prog.id},'${prog.name}','${prog.code}','${prog.degreeType}',${prog.durationYears},${prog.totalSeats},'${prog.baseFee}','${prog.eligibility != null ? prog.eligibility.replace("'","") : ""}','${prog.description != null ? prog.description.replace("'","") : ""}',${prog.active})">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <form method="post" action="${pageContext.request.contextPath}/ProgramServlet" style="display:inline">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${prog.id}">
                                    <button type="submit" class="btn btn-danger btn-xs" style="font-size:11px"
                                            onclick="return confirm('Deactivate this program?')">
                                        <i class="fas fa-ban"></i>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <div class="card-body">
                            <!-- Department & Duration -->
                            <div style="display:flex;gap:10px;margin-bottom:14px;flex-wrap:wrap">
                                <span style="display:flex;align-items:center;gap:5px;font-size:12px;color:#64748b">
                                    <i class="fas fa-building" style="color:#2563eb"></i>
                                    ${prog.departmentName}
                                </span>
                                <span style="display:flex;align-items:center;gap:5px;font-size:12px;color:#64748b">
                                    <i class="fas fa-clock" style="color:#d97706"></i>
                                    ${prog.durationYears} Years
                                </span>
                            </div>

                            <!-- Fee Info -->
                            <div style="background:#f8fafc;border-radius:10px;padding:12px;margin-bottom:14px">
                                <div style="font-size:11px;font-weight:700;color:#64748b;margin-bottom:8px;text-transform:uppercase;letter-spacing:0.5px">Annual Fee by Category</div>
                                <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:6px;font-size:11px">
                                    <div style="text-align:center">
                                        <div style="color:#64748b;font-weight:600">General</div>
                                        <div style="font-weight:700;color:#1a4b8c">₹<fmt:formatNumber value="${prog.feeGeneral}" pattern="#,##,##0"/></div>
                                    </div>
                                    <div style="text-align:center">
                                        <div style="color:#64748b;font-weight:600">OBC</div>
                                        <div style="font-weight:700;color:#059669">₹<fmt:formatNumber value="${prog.feeObc}" pattern="#,##,##0"/></div>
                                    </div>
                                    <div style="text-align:center">
                                        <div style="color:#64748b;font-weight:600">SC/ST</div>
                                        <div style="font-weight:700;color:#7c3aed">₹<fmt:formatNumber value="${prog.feeSc}" pattern="#,##,##0"/></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Seat Progress -->
                            <div style="margin-bottom:10px">
                                <div style="display:flex;justify-content:space-between;margin-bottom:5px">
                                    <span style="font-size:12px;font-weight:600;color:#374151">Seats Filled</span>
                                    <span style="font-size:12px;font-weight:700;color:#1a4b8c">${prog.filledSeats} / ${prog.totalSeats}</span>
                                </div>
                                <div style="height:7px;background:#e2e8f0;border-radius:20px;overflow:hidden">
                                    <div style="height:100%;width:${prog.occupancyPercent}%;background:${prog.occupancyPercent >= 90 ? 'linear-gradient(90deg,#dc2626,#ef4444)' : prog.occupancyPercent >= 60 ? 'linear-gradient(90deg,#d97706,#f59e0b)' : 'linear-gradient(90deg,#2563eb,#3b82f6)'};border-radius:20px;transition:width 1s ease"></div>
                                </div>
                                <div style="font-size:11px;color:#94a3b8;margin-top:3px">${prog.availableSeats} seats available</div>
                            </div>

                            <!-- Eligibility -->
                            <div style="font-size:12px;color:#64748b;border-top:1px solid #f1f5f9;padding-top:10px">
                                <i class="fas fa-info-circle" style="color:#2563eb;margin-right:4px"></i>
                                ${prog.eligibility}
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="empty-state">
                            <i class="fas fa-book-open"></i>
                            <h3>No Programs Added</h3>
                            <p>Click "Add Program" to create the first engineering program.</p>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- ADD PROGRAM MODAL -->
<div class="modal-overlay" id="addProgramModal">
    <div class="modal-box" style="max-width:700px">
        <div class="modal-header">
            <h4><i class="fas fa-plus-circle"></i> Add New Engineering Program</h4>
            <button class="modal-close" onclick="closeModal('addProgramModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/ProgramServlet">
            <input type="hidden" name="action" value="create">
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-8">
                        <label class="form-label">Program Name *</label>
                        <input type="text" name="name" class="form-control" required
                               placeholder="e.g. B.Tech Computer Science & Engineering">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Program Code *</label>
                        <input type="text" name="code" class="form-control" required
                               placeholder="e.g. BTCSE">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Department *</label>
                        <select name="departmentId" class="form-select" required>
                            <option value="">-- Select Department --</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.id}">${dept.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Degree Type *</label>
                        <select name="degreeType" class="form-select" required>
                            <option value="B.Tech">B.Tech</option>
                            <option value="M.Tech">M.Tech</option>
                            <option value="B.E">B.E</option>
                            <option value="Diploma">Diploma</option>
                            <option value="MBA Tech">MBA Tech</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Duration (Years) *</label>
                        <select name="durationYears" class="form-select">
                            <option value="4">4 Years (B.Tech)</option>
                            <option value="2">2 Years (M.Tech)</option>
                            <option value="3">3 Years (Diploma)</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Total Seats *</label>
                        <input type="number" name="totalSeats" class="form-control" required min="1" placeholder="e.g. 60">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">General Fee/Year (₹) *</label>
                        <input type="number" name="baseFee" id="baseFeeInput" class="form-control" required
                               min="0" step="100" placeholder="e.g. 95000" oninput="autoCalcFees()">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">OBC Fee/Year (₹)</label>
                        <input type="number" name="feeObc" id="feeObc" class="form-control" min="0" step="100"
                               placeholder="Auto: 75% of General">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">SC Fee/Year (₹)</label>
                        <input type="number" name="feeSc" id="feeSc" class="form-control" min="0" step="100"
                               placeholder="Auto: 50% of General">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">ST Fee/Year (₹)</label>
                        <input type="number" name="feeSt" id="feeSt" class="form-control" min="0" step="100"
                               placeholder="Auto: 50% of General">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">EWS Fee/Year (₹)</label>
                        <input type="number" name="feeEws" id="feeEws" class="form-control" min="0" step="100"
                               placeholder="Auto: 70% of General">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Eligibility Criteria</label>
                        <input type="text" name="eligibility" class="form-control"
                               placeholder="e.g. 10+2 with PCM min 60% | JEE Mains qualified">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="2"
                                  placeholder="Brief program description"></textarea>
                    </div>
                </div>
                <div class="alert alert-info" style="margin-top:14px;margin-bottom:0">
                    <i class="fas fa-info-circle"></i>
                    <div>OBC/SC/ST/EWS fees are auto-calculated. You can override them manually.</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('addProgramModal')">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Program</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT PROGRAM MODAL -->
<div class="modal-overlay" id="editProgramModal">
    <div class="modal-box" style="max-width:600px">
        <div class="modal-header">
            <h4><i class="fas fa-edit"></i> Edit Program</h4>
            <button class="modal-close" onclick="closeModal('editProgramModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/ProgramServlet">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-8">
                        <label class="form-label">Program Name *</label>
                        <input type="text" name="name" id="editName" class="form-control" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Code *</label>
                        <input type="text" name="code" id="editCode" class="form-control" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Degree Type</label>
                        <select name="degreeType" id="editDegree" class="form-select">
                            <option value="B.Tech">B.Tech</option>
                            <option value="M.Tech">M.Tech</option>
                            <option value="B.E">B.E</option>
                            <option value="Diploma">Diploma</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Duration (Years)</label>
                        <input type="number" name="durationYears" id="editDur" class="form-control" min="1" max="6">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Total Seats</label>
                        <input type="number" name="totalSeats" id="editSeats" class="form-control" min="1">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">General Fee/Year (₹)</label>
                        <input type="number" name="baseFee" id="editFee" class="form-control" min="0" step="100">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Status</label>
                        <select name="isActive" id="editActive" class="form-select">
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Eligibility</label>
                        <input type="text" name="eligibility" id="editElig" class="form-control">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Description</label>
                        <textarea name="description" id="editDesc" class="form-control" rows="2"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('editProgramModal')">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update</button>
            </div>
        </form>
    </div>
</div>

<script>
// Auto-calculate category fees
function autoCalcFees() {
    var base = parseFloat(document.getElementById('baseFeeInput').value) || 0;
    document.getElementById('feeObc').value  = Math.round(base * 0.75);
    document.getElementById('feeSc').value   = Math.round(base * 0.50);
    document.getElementById('feeSt').value   = Math.round(base * 0.50);
    document.getElementById('feeEws').value  = Math.round(base * 0.70);
}

// Edit program
function editProgram(id, name, code, degree, dur, seats, fee, elig, desc, active) {
    document.getElementById('editId').value    = id;
    document.getElementById('editName').value  = name;
    document.getElementById('editCode').value  = code;
    document.getElementById('editDegree').value = degree;
    document.getElementById('editDur').value   = dur;
    document.getElementById('editSeats').value = seats;
    document.getElementById('editFee').value   = fee;
    document.getElementById('editElig').value  = elig;
    document.getElementById('editDesc').value  = desc;
    document.getElementById('editActive').value = active.toString();
    openModal('editProgramModal');
}

// Filter programs by degree type
function filterPrograms(type) {
    document.querySelectorAll('[id^="btn-"]').forEach(function(b) {
        b.style.background = '#fff'; b.style.color = '#64748b';
        b.style.borderColor = '#e2e8f0';
    });
    var btn = document.getElementById('btn-' + type.replace('.',''));
    if (btn) { btn.style.background = '#2563eb'; btn.style.color = '#fff'; btn.style.borderColor = '#2563eb'; }

    document.querySelectorAll('.prog-card').forEach(function(card) {
        if (type === 'ALL' || card.getAttribute('data-degree') === type) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>