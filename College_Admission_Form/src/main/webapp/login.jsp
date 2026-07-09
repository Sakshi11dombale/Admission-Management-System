
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    if (session.getAttribute("loggedUser") != null) {
        response.sendRedirect(request.getContextPath() + "/DashboardServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - College Admission System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@500;600;700&display=swap">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { min-height:100vh; background:linear-gradient(135deg,#0a1628 0%,#1a4b8c 60%,#1e3a8a 100%); display:flex; align-items:center; justify-content:center; padding:20px; }
        .login-wrap { display:flex; gap:60px; align-items:center; max-width:960px; width:100%; }
        .login-left { flex:1; color:#fff; }
        .login-left h1 { font-family:'Poppins',sans-serif; font-size:38px; font-weight:700; line-height:1.2; margin-bottom:14px; }
        .login-left h1 span { color:#f59e0b; }
        .login-left p { font-size:14px; opacity:0.8; line-height:1.75; margin-bottom:28px; max-width:420px; }
        .feature-list { list-style:none; display:flex; flex-direction:column; gap:10px; }
        .feature-list li { display:flex; align-items:center; gap:10px; font-size:13.5px; opacity:0.85; }
        .feature-list li i { color:#f59e0b; font-size:16px; }
        .login-card { background:#fff; border-radius:20px; padding:36px 32px; width:100%; max-width:430px; box-shadow:0 24px 64px rgba(0,0,0,0.3); flex-shrink:0; }
        .login-logo { text-align:center; margin-bottom:24px; }
        .login-logo .icon { width:60px; height:60px; background:linear-gradient(135deg,#1a4b8c,#2563eb); border-radius:16px; display:inline-flex; align-items:center; justify-content:center; font-size:26px; color:#fff; margin-bottom:12px; box-shadow:0 8px 20px rgba(37,99,235,0.3); }
        .login-logo h2 { font-size:20px; font-weight:700; color:#1e293b; }
        .login-logo p { font-size:13px; color:#64748b; }
        .tab-row { display:flex; background:#f1f5f9; border-radius:12px; padding:4px; margin-bottom:24px; gap:4px; }
        .tab-btn { flex:1; padding:10px; border:none; background:transparent; border-radius:9px; font-size:13px; font-weight:600; cursor:pointer; color:#64748b; transition:all 0.2s; display:flex; align-items:center; justify-content:center; gap:6px; }
        .tab-btn.active { background:#fff; color:#2563eb; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        .form-label { font-size:13px; font-weight:600; color:#374151; margin-bottom:6px; display:block; }
        .form-control { width:100%; padding:10px 14px; border:1.5px solid #e2e8f0; border-radius:8px; font-size:13.5px; color:#1e293b; transition:all 0.2s; font-family:inherit; }
        .form-control:focus { outline:none; border-color:#2563eb; box-shadow:0 0 0 3px rgba(37,99,235,0.1); }
        .input-icon-wrap { position:relative; }
        .input-icon-wrap i { position:absolute; left:13px; top:50%; transform:translateY(-50%); color:#94a3b8; font-size:15px; }
        .input-icon-wrap .form-control { padding-left:40px; }
        .btn-login { width:100%; padding:12px; background:linear-gradient(135deg,#1a4b8c,#2563eb); color:#fff; border:none; border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; transition:all 0.2s; display:flex; align-items:center; justify-content:center; gap:8px; margin-top:6px; }
        .btn-login:hover { transform:translateY(-1px); box-shadow:0 6px 20px rgba(37,99,235,0.4); }
        .demo-info { background:#f0f9ff; border:1px solid #bae6fd; border-radius:8px; padding:10px 14px; margin-top:14px; font-size:12px; color:#0369a1; text-align:center; }
        .alert { padding:12px 16px; border-radius:8px; font-size:13px; margin-bottom:16px; display:flex; align-items:center; gap:8px; }
        .alert-danger { background:#fef2f2; color:#dc2626; border:1px solid #fecaca; }
        .alert-success { background:#f0fdf4; color:#16a34a; border:1px solid #bbf7d0; }
        .divider { display:flex; align-items:center; gap:12px; margin:18px 0; color:#94a3b8; font-size:12px; }
        .divider::before,.divider::after { content:''; flex:1; height:1px; background:#e2e8f0; }
        @media(max-width:768px){ .login-left{display:none} .login-card{max-width:100%} }
    </style>
</head>
<body>
<div class="login-wrap">
    <!-- LEFT PANEL -->
    <div class="login-left">
        <h1>Your Future Starts<br>Here at <span>University<br>of Excellence</span></h1>
        <p>Apply online for admission to our world-class programs. Track your application, upload documents, and get real-time updates — all in one place.</p>
        <ul class="feature-list">
            <li><i class="fas fa-check-circle"></i> Easy Online Application Form</li>
            <li><i class="fas fa-check-circle"></i> Real-time Application Tracking</li>
            <li><i class="fas fa-check-circle"></i> Secure Document Upload</li>
            <li><i class="fas fa-check-circle"></i> Instant Status Notifications</li>
            <li><i class="fas fa-check-circle"></i> Multiple Program Options</li>
            <li><i class="fas fa-check-circle"></i> 100% Online Process</li>
        </ul>
    </div>

    <!-- LOGIN CARD -->
    <div class="login-card">
        <div class="login-logo">
            <div class="icon"><i class="fas fa-graduation-cap"></i></div>
            <h2>Admission Portal</h2>
            <p>Sign in or create your account</p>
        </div>

        <!-- Tabs -->
        <div class="tab-row">
            <button class="tab-btn active" onclick="showTab('login',this)">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>
            <button class="tab-btn" onclick="showTab('register',this)">
                <i class="fas fa-user-plus"></i> Register
            </button>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i>${errorMsg}</div>
        </c:if>
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i>${successMsg}</div>
        </c:if>

        <!-- LOGIN FORM -->
        <form id="loginForm" action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div style="margin-bottom:16px">
                <label class="form-label">Username</label>
                <div class="input-icon-wrap">
                    <i class="fas fa-user"></i>
                    <input type="text" name="username" class="form-control" placeholder="Enter your username" required>
                </div>
            </div>
            <div style="margin-bottom:20px">
                <label class="form-label">Password</label>
                <div class="input-icon-wrap">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
                </div>
            </div>
            <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt"></i> Sign In
            </button>
            <div class="demo-info">
                <strong>Admin:</strong> admin / admin123 &nbsp;|&nbsp;
                <strong>Student:</strong> Register below
            </div>
        </form>

        <!-- REGISTER FORM -->
        <form id="registerForm" style="display:none" action="${pageContext.request.contextPath}/RegisterServlet" method="post">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:14px">
                <div>
                    <label class="form-label">First Name <span style="color:#dc2626">*</span></label>
                    <input type="text" name="firstName" class="form-control" placeholder="First" required>
                </div>
                <div>
                    <label class="form-label">Last Name <span style="color:#dc2626">*</span></label>
                    <input type="text" name="lastName" class="form-control" placeholder="Last" required>
                </div>
            </div>
            <div style="margin-bottom:14px">
                <label class="form-label">Email Address <span style="color:#dc2626">*</span></label>
                <div class="input-icon-wrap">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" class="form-control" placeholder="your@email.com" required>
                </div>
            </div>
            <div style="margin-bottom:14px">
                <label class="form-label">Mobile Number</label>
                <div class="input-icon-wrap">
                    <i class="fas fa-phone"></i>
                    <input type="text" name="phone" class="form-control" placeholder="10-digit number">
                </div>
            </div>
            <div style="margin-bottom:14px">
                <label class="form-label">Username <span style="color:#dc2626">*</span></label>
                <div class="input-icon-wrap">
                    <i class="fas fa-at"></i>
                    <input type="text" name="username" class="form-control" placeholder="Choose a username" required>
                </div>
            </div>
            <div style="margin-bottom:20px">
                <label class="form-label">Password <span style="color:#dc2626">*</span></label>
                <div class="input-icon-wrap">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" required minlength="6">
                </div>
            </div>
            <button type="submit" class="btn-login" style="background:linear-gradient(135deg,#059669,#10b981);box-shadow:0 6px 20px rgba(16,185,129,0.3)">
                <i class="fas fa-user-plus"></i> Create Student Account
            </button>
            <p style="text-align:center;font-size:12px;color:#64748b;margin-top:12px">
                By registering you agree to our <a href="#" style="color:#2563eb">Terms &amp; Conditions</a>
            </p>
        </form>
    </div>
</div>

<script>
function showTab(tab, btn) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('loginForm').style.display    = tab === 'login'    ? 'block' : 'none';
    document.getElementById('registerForm').style.display = tab === 'register' ? 'block' : 'none';
}
// Auto-show register tab if there's a success/error from registration
<c:if test="${not empty successMsg || (not empty errorMsg && param.from == 'register')}">
showTab('register', document.querySelectorAll('.tab-btn')[1]);
</c:if>
</script>
</body>
</html>