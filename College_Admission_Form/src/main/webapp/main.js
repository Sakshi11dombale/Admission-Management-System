document.addEventListener('DOMContentLoaded', function () {

    // Auto-dismiss alerts after 4 seconds
    document.querySelectorAll('.alert[data-auto-dismiss]').forEach(function (el) {
        setTimeout(function () {
            el.style.opacity = '0';
            el.style.transition = 'opacity 0.5s';
            setTimeout(function() { el.remove(); }, 500);
        }, 4000);
    });

    // Mobile sidebar toggle
    var toggleBtn = document.getElementById('sidebarToggle');
    var sidebar   = document.querySelector('.sidebar');
    if (toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('open');
        });
    }

    // Tab switcher on login page
    document.querySelectorAll('.tab-btn').forEach(function (tab) {
        tab.addEventListener('click', function () {
            document.querySelectorAll('.tab-btn').forEach(function(t) {
                t.classList.remove('active');
            });
            tab.classList.add('active');
            var target = tab.getAttribute('data-tab');
            document.querySelectorAll('.tab-form').forEach(function (f) {
                f.style.display = f.id === target ? 'block' : 'none';
            });
        });
    });

    // Modal open buttons
    document.querySelectorAll('[data-modal]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var modal = document.getElementById(btn.getAttribute('data-modal'));
            if (modal) modal.classList.add('show');
        });
    });

    // Close modal on overlay click
    document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) overlay.classList.remove('show');
        });
    });

    // Close modal button
    document.querySelectorAll('.modal-close').forEach(function (btn) {
        btn.addEventListener('click', function () {
            btn.closest('.modal-overlay').classList.remove('show');
        });
    });

    // Confirm dialogs
    document.querySelectorAll('[data-confirm]').forEach(function (el) {
        el.addEventListener('click', function (e) {
            if (!confirm(el.getAttribute('data-confirm'))) e.preventDefault();
        });
    });

    // Seat progress bar colors
    document.querySelectorAll('.seat-progress').forEach(function (bar) {
        var pct = parseFloat(bar.getAttribute('data-pct') || 0);
        var fill = bar.querySelector('.progress-bar-fill');
        if (fill) {
            fill.style.width = pct + '%';
            if (pct >= 90)      fill.classList.add('red');
            else if (pct >= 60) fill.classList.add('orange');
            else                fill.classList.add('green');
        }
    });

    // Mark active sidebar link
    var path = window.location.pathname;
    document.querySelectorAll('.sidebar nav a').forEach(function (a) {
        if (a.getAttribute('href') && path.indexOf(a.getAttribute('href').split('?')[0].replace(/^\/[^/]+/, '')) !== -1) {
            a.classList.add('active');
        }
    });
});

// Global modal functions
function openModal(id)  { document.getElementById(id).classList.add('show'); }
function closeModal(id) { document.getElementById(id).classList.remove('show'); }