<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Admin</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TrangChu.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/index.css">

        <style>
            body { background-color: #f8f9fc; }
            .form-control-custom:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(234, 106, 71, 0.25);
            }
            .card-title-custom { font-family: var(--ff-heading); font-weight: 500; }
            .table-bordered th, .table-bordered td { border-color: #eaeaea; vertical-align: middle; }
        </style>
    </head>

    <body>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="../TrangChu">
                    <img src="./img/logo.png" alt="Logo" class="nav-logo">
                </a>

                <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-expanded="false">
                    <i class="fa-solid fa-caret-down fs-2 toggle-caret"></i>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto fw-bold">
                        <li class="nav-item"><a class="nav-link" href="index">Trang chủ</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="productDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">Món Ăn</a>
                            <ul class="dropdown-menu shadow border-0" aria-labelledby="productDropdown">
                                <li><a class="dropdown-item py-2" href="ViewProduct"><i class="fas fa-table-list me-2 text-success"></i>Xem Món</a></li>
                                <li><a class="dropdown-item py-2" href="AddProduct"><i class="fas fa-plus-square me-2 text-primary"></i>Thêm Món</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2" href="AddCategory"><i class="fas fa-list-ul me-2 text-warning"></i>Danh Mục</a></li>
                            </ul>
                        </li>

                        <li class="nav-item"><a class="nav-link" href="Orders">Đơn Hàng</a></li>
                        <li class="nav-item"><a class="nav-link" href="Users">Khách Hàng</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle active" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">Admin</a>
                            <ul class="dropdown-menu shadow border-0" aria-labelledby="adminDropdown">
                                <li><a class="dropdown-item py-2" href="AdminList"><i class="fas fa-users-cog me-2 text-primary"></i>Danh sách Admin</a></li>
                                <li><a class="dropdown-item py-2" href="AddAdmin"><i class="fas fa-user-plus me-2 text-primary"></i>Thêm Admin</a></li>
                            </ul>
                        </li>

                        <li class="nav-item"><a class="nav-link" href="Voucher">Voucher</a></li>
                        <li class="nav-item"><a class="nav-link" href="ViewFeedback">Phản Hồi</a></li>
                    </ul>

                    <div class="dropdown position-relative">
                        <a href="#" class="text-dark text-decoration-none d-flex align-items-center justify-content-center border border-2 border-primary rounded-circle"
                           id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 40px; height: 40px;">
                            <img src="https://ui-avatars.com/api/?name=Admin&background=0d6efd&color=fff" alt="Avatar" class="rounded-circle w-100 h-100" style="object-fit: cover;">
                        </a>
                        <ul class="dropdown-menu border-0 shadow-lg profile-dropdown" aria-labelledby="accountDropdown"
                            style="left: 50%; transform: translateX(-50%); margin-top: 10px; min-width: 170px;">
                            <li class="px-2 mb-1 mt-1">
                                <a class="dropdown-item profile-item d-flex align-items-center rounded py-2" href="Profile">
                                    <i class="fas fa-user-circle fs-5 me-2 text-primary" style="width: 24px; text-align: center;"></i>
                                    <span class="fw-semibold">Xem tài khoản</span>
                                </a>
                            </li>
                            <li class="px-2 mb-1">
                                <a class="dropdown-item profile-item d-flex align-items-center rounded text-danger py-2" href="./DangXuat">
                                    <i class="fas fa-sign-out-alt fs-5 me-2" style="width: 24px; text-align: center;"></i>
                                    <span class="fw-semibold">Thoát</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>

        <section class="admin-dashboard-section" style="margin-top: 140px; padding-bottom: 50px;">
            <div class="container-fluid px-4 px-lg-5">
                <div class="card shadow-sm border-0" style="border-radius: 4px;">
                    <div class="card-header bg-white text-center py-3" style="border-bottom: 1px solid #eaeaea;">
                        <h3 class="mb-0 card-title-custom text-dark">Danh Sách Admin</h3>
                    </div>

                    <div class="card-body p-4">
                        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                            <a href="index" class="text-decoration-none fw-bold" style="color: var(--primary-color); font-size: 1.05rem;">
                                <i class="fas fa-arrow-left me-1"></i> Quay Lại
                            </a>
                            <a href="AddAdmin" class="btn btn-custom px-4 rounded-0">
                                <i class="fas fa-user-plus me-2"></i>Thêm Admin
                            </a>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 text-start" style="border-top: 1px solid #dee2e6;">
                                <thead style="font-family: var(--ff-heading); font-size: 0.95rem;">
                                    <tr>
                                        <th scope="col" class="py-3">Id</th>
                                        <th scope="col" class="py-3">Ảnh</th>
                                        <th scope="col" class="py-3">Tên</th>
                                        <th scope="col" class="py-3">Email</th>
                                        <th scope="col" class="py-3">SĐT</th>
                                        <th scope="col" class="py-3">Địa Chỉ</th>
                                        <th scope="col" class="py-3">Tình Trạng</th>
                                        <th scope="col" class="py-3 text-center">Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty adminList}">
                                            <tr>
                                                <td colspan="8" class="text-center text-muted py-4">Không có admin nào.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="u" items="${adminList}">
                                                <tr>
                                                    <td class="fw-bold">${u.id}</td>
                                                    <td>
                                                        <div style="width: 80px; height: 80px; border: 1px solid #ddd; display: flex; align-items: center; justify-content: center; overflow: hidden; background-color: #f9f9f9;">
                                                            <img src="${not empty u.avatarUrl ? u.avatarUrl : '../img/user-icon.png'}"
                                                                 alt="Avatar"
                                                                 style="max-width: 100%; height: auto; opacity: ${not empty u.avatarUrl ? '1' : '0.6'};">
                                                        </div>
                                                    </td>
                                                    <td>${u.fullName}</td>
                                                    <td>${u.email}</td>
                                                    <td>${u.phone}</td>
                                                    <td>${not empty u.addressDetail ? u.addressDetail : 'Chưa cập nhật'}</td>
                                                    <td>
                                                        <span class="badge ${u.status == 1 ? 'bg-success' : 'bg-danger'} p-2">
                                                            ${u.status == 1 ? 'Đang hoạt động' : 'Đã khóa'}
                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <form action="UpdateUserStatus" method="POST" class="d-flex justify-content-center align-items-center gap-2 mb-0">
                                                            <input type="hidden" name="userId" value="${u.id}">
                                                            <button type="submit" name="status" value="1" class="btn btn-success btn-sm shadow-none"
                                                                    style="border-radius: 4px; min-width: 85px;" ${u.status == 1 ? 'disabled' : ''}>Active</button>
                                                            <button type="submit" name="status" value="0" class="btn btn-danger btn-sm shadow-none"
                                                                    style="border-radius: 4px; min-width: 85px;" ${u.status == 0 ? 'disabled' : ''}>Inactive</button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card-footer bg-white py-3 border-top" style="border-color: #eaeaea !important;">
                        <span class="text-muted fw-medium" style="font-size: 0.95rem;">
                            Tổng: ${adminList.size()} admin
                        </span>
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

        <a href="#" class="back-top-btn active" aria-label="Back to top" data-back-top-btn>
            <i class="fas fa-chevron-up"></i>
        </a>

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="../js/index.js"></script>
    </body>
</html>
