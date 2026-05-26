<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.User" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>

        <link rel="icon" href="${pageContext.request.contextPath}/img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TrangChu.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/index.css">

        <style>
            .admin-dashboard-title {
                font-size: 1.8rem;
                font-family: var(--ff-body);
                font-weight: 700;
                color: #212529;
            }
            .summary-card {
                transition: transform 0.2s ease, box-shadow 0.2s ease;
                border-radius: 0 !important;
            }
            .summary-icon {
                font-size: 2.5rem;
                opacity: 0.8;
            }

            .navbar-nav .nav-link {
                font-size: 0.95rem;
                padding-left: 0.8rem !important;
                padding-right: 0.8rem !important;
            }
        </style>
    </head>

    <body>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="./">
                    <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" class="nav-logo">
                </a>

                <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-expanded="false">
                    <i class="fa-solid fa-caret-down fs-2 toggle-caret"></i>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto fw-bold">
                        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/AdminDashboard">Trang chủ</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="productDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Món Ăn
                            </a>
                            <ul class="dropdown-menu shadow border-0" aria-labelledby="productDropdown">
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/ViewProduct"><i class="fas fa-table-list me-2 text-success"></i>Xem Món</a></li>
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/AddProduct"><i class="fas fa-plus-square me-2 text-primary"></i>Thêm Món</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/AddCategory"><i class="fas fa-list-ul me-2 text-warning"></i>Danh Mục</a></li>
                            </ul>
                        </li>

                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/Orders">Đơn Hàng</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/Users">Khách Hàng</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Admin
                            </a>
                            <ul class="dropdown-menu shadow border-0" aria-labelledby="adminDropdown">
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/AdminList"><i class="fas fa-users-cog me-2 text-primary"></i>Danh sách Admin</a></li>
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/AddAdmin"><i class="fas fa-user-plus me-2 text-primary"></i>Thêm Admin</a></li>
                            </ul>
                        </li>

                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/Voucher">Voucher</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/ViewFeedback">Phản Hồi</a></li>
                    </ul>
                    <%
                        // Lấy thông tin admin đang đăng nhập từ Session
                        User adminUser = (User) session.getAttribute("userAccount");
                        // Xử lý chuỗi "./img/..." thành "/img/..." để ghép chuẩn với Context Path
                        String avatarPath = (adminUser != null && adminUser.getAvatarUrl() != null) 
                                            ? adminUser.getAvatarUrl().replace("./", "/") 
                                            : "/img/avt/default.png";
                        String adminName = (adminUser != null) ? adminUser.getFullName() : "Admin";
                    %>
                    <div class="dropdown position-relative">
                        <a href="#" class="text-dark text-decoration-none d-flex align-items-center justify-content-center border border-2 border-primary rounded-circle" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 40px; height: 40px;">
                            <img src="${pageContext.request.contextPath}<%= avatarPath %>" alt="Avatar" class="rounded-circle w-100 h-100 icon-wrap-profile" style="object-fit: cover;">
                        </a>

                        <ul class="dropdown-menu border-0 shadow-lg profile-dropdown" aria-labelledby="accountDropdown" style="left: 50%; transform: translateX(-50%); margin-top: 10px; min-width: 170px;">
                            <li class="px-2 mb-1 mt-1">
                                <a class="dropdown-item profile-item d-flex align-items-center rounded py-2" href="${pageContext.request.contextPath}/Profile">
                                    <i class="fas fa-user-circle fs-5 me-2 text-primary" style="width: 24px; text-align: center;"></i>
                                    <span class="fw-semibold">Xem tài khoản</span>
                                </a>
                            </li>
                            <li class="px-2 mb-1">
                                <a class="dropdown-item profile-item d-flex align-items-center rounded text-danger py-2" href="${pageContext.request.contextPath}/DangXuat">
                                    <i class="fas fa-sign-out-alt fs-5 me-2" style="width: 24px; text-align: center;"></i>
                                    <span class="fw-semibold">Thoát</span>
                                </a>
                            </li>

                        </ul>
                    </div>
                </div>
            </div>
        </nav>

        <section class="admin-dashboard-section" style="margin-top: 120px; margin-bottom: 80px; min-height: 55vh;">
            <div class="container">
                <h2 class="admin-dashboard-title mb-4">Tổng Quan</h2>

                <div class="row g-4 mb-5">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="card summary-card bg-primary text-dark border-0 h-100 p-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-1 fw-semibold">Doanh Thu Hôm Nay</p>
                                    <h3 class="mb-0 fw-bold"><%= request.getAttribute("todayRevenue") != null ? request.getAttribute("todayRevenue") : "0₫" %></h3>
                                </div>
                                <i class="fas fa-wallet summary-icon"></i>
                            </div>
                            <div class="card-footer bg-transparent border-0 pt-0">
                                <small>Cập nhật trực tuyến từ hệ thống</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="card summary-card bg-success text-white border-0 shadow-sm h-100 p-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-1 fw-semibold">Đơn Hàng Mới</p>
                                    <h3 class="mb-0 fw-bold"><%= request.getAttribute("newOrders") != null ? request.getAttribute("newOrders") : "0" %> Đơn</h3>
                                </div>
                                <i class="fas fa-shopping-bag summary-icon"></i>
                            </div>
                            <div class="card-footer bg-transparent border-0 pt-0">
                                <small><%= request.getAttribute("pendingOrders") != null ? request.getAttribute("pendingOrders") : "0" %> đơn đang chờ xử lý</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="card summary-card bg-warning text-dark border-0 shadow-sm h-100 p-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-1 fw-semibold">Khách Hàng</p>
                                    <h3 class="mb-0 fw-bold"><%= request.getAttribute("totalCustomers") != null ? request.getAttribute("totalCustomers") : "0" %></h3>
                                </div>
                                <i class="fas fa-users summary-icon"></i>
                            </div>
                            <div class="card-footer bg-transparent border-0 pt-0">
                                <small>Tài khoản khách hàng đã đăng ký</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="card summary-card bg-danger text-white border-0 shadow-sm h-100 p-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-1 fw-semibold">Đánh Giá & Phản Hồi</p>
                                    <h3 class="mb-0 fw-bold"><%= request.getAttribute("avgRating") != null ? request.getAttribute("avgRating") : "0.0" %> <i class="fas fa-star fs-5"></i></h3>
                                </div>
                                <i class="fas fa-comments summary-icon"></i>
                            </div>
                            <div class="card-footer bg-transparent border-0 pt-0">
                                <small>Tổng số <%= request.getAttribute("totalFeedbacks") != null ? request.getAttribute("totalFeedbacks") : "0" %> phản hồi</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-12">
                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                <h5 class="mb-0 fw-bold text-dark">Biểu Đồ Doanh Thu 7 Ngày Qua</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="revenueChart" style="max-height: 400px; width: 100%;"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </section>

        <footer class="footer">
            <div class="container text-center">
                <h4 class="footer-title mb-4">Các thành viên trong nhóm:</h4>
                <div class="d-flex flex-column align-items-center gap-3">
                    <div class="member-item"><div class="member-name">1. Ngô Phương Anh - 09/05/2005</div></div>
                    <div class="member-item"><div class="member-name">2. Phùng Ngọc Bảo - 13/12/2005</div></div>
                    <div class="member-item"><div class="member-name">3. Vũ Ngọc Hương Giang - 25/12/2005</div></div>
                </div>
            </div>
        </footer>

        <a href="#" class="back-top-btn" aria-label="Back to top" data-back-top-btn>
            <i class="fas fa-chevron-up"></i>
        </a>

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="${pageContext.request.contextPath}/js/index.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const ctx = document.getElementById('revenueChart').getContext('2d');

                let gradient = ctx.createLinearGradient(0, 0, 0, 400);
                gradient.addColorStop(0, 'rgba(13, 110, 253, 0.4)');
                gradient.addColorStop(1, 'rgba(13, 110, 253, 0.0)');

                const revenueChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: <%= request.getAttribute("chartLabels") != null ? request.getAttribute("chartLabels") : "[]" %>,
                        datasets: [{
                                label: 'Doanh thu (VNĐ)',
                                data: <%= request.getAttribute("chartData") != null ? request.getAttribute("chartData") : "[]" %>,
                                backgroundColor: gradient,
                                borderColor: '#0d6efd',
                                borderWidth: 3,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#0d6efd',
                                pointBorderWidth: 2,
                                pointRadius: 5,
                                pointHoverRadius: 7,
                                fill: true,
                                tension: 0.4
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {display: false},
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        let label = context.dataset.label || '';
                                        if (label)
                                            label += ': ';
                                        if (context.parsed.y !== null) {
                                            label += new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(context.parsed.y);
                                        }
                                        return label;
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function (value) {
                                        if (value >= 1000000) {
                                            return (value / 1000000) + ' Tr';
                                        } else if (value >= 1000) {
                                            return (value / 1000) + ' K';
                                        }
                                        return value;
                                    }
                                }
                            }
                        }
                    }
                });
            });
        </script>
    </body>
</html>