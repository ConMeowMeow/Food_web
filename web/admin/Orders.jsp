<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Đơn Hàng</title>

        <link rel="icon" href="${pageContext.request.contextPath}/img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TrangChu.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/index.css">

        <style>
            body {
                background-color: #f8f9fc;
            }

            .form-control-custom:focus, .form-select-custom:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(234, 106, 71, 0.25);
            }

            .pagination-custom .page-link {
                color: var(--primary-color);
                border-color: #dee2e6;
            }
            .pagination-custom .page-link:hover {
                background-color: var(--bg-color);
                color: var(--primary-hover);
            }
            .pagination-custom .page-item.active .page-link {
                z-index: 3;
                color: #fff;
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .card-title-custom {
                font-family: var(--ff-heading);
                font-weight: 500;
            }

            .table-bordered th, .table-bordered td {
                border-color: #eaeaea;
                vertical-align: middle;
            }

            .deliver-details p, .product-details p, .price-details p, .payment-details p {
                margin-bottom: 0.2rem;
                font-size: 0.9rem;
            }
        </style>
    </head>

    <body>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="./TrangChu">
                    <img src="./img/logo.png" alt="Logo" class="nav-logo">
                </a>

                <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-expanded="false">
                    <i class="fa-solid fa-caret-down fs-2 toggle-caret"></i>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto fw-bold">
                        <li class="nav-item"><a class="nav-link" href="index">Trang chủ</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="productDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Món Ăn
                            </a>
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
                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Admin
                            </a>
                            <ul class="dropdown-menu shadow border-0" aria-labelledby="adminDropdown">
                                <li><a class="dropdown-item py-2" href="AdminList"><i class="fas fa-users-cog me-2 text-primary"></i>Danh sách Admin</a></li>
                                <li><a class="dropdown-item py-2" href="AddAdmin"><i class="fas fa-user-plus me-2 text-primary"></i>Thêm Admin</a></li>
                            </ul>
                        </li>

                        <li class="nav-item"><a class="nav-link" href="Voucher">Voucher</a></li>
                        <li class="nav-item"><a class="nav-link" href="ViewFeedback">Phản Hồi</a></li>
                    </ul>

                    <div class="dropdown position-relative">
                        <a href="#" class="text-dark text-decoration-none d-flex align-items-center justify-content-center border border-2 border-primary rounded-circle" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 40px; height: 40px;">
                            <img src="https://ui-avatars.com/api/?name=Admin&background=0d6efd&color=fff" alt="Avatar" class="rounded-circle w-100 h-100 icon-wrap-profile" style="object-fit: cover;">
                        </a>

                        <ul class="dropdown-menu border-0 shadow-lg profile-dropdown" aria-labelledby="accountDropdown" style="left: 50%; transform: translateX(-50%); margin-top: 10px; min-width: 170px;">
                            <li class="px-2 mb-1 mt-1">
                                <a class="dropdown-item profile-item d-flex align-items-center rounded py-2" href="Profile">
                                    <i class="fas fa-user-circle fs-5 me-2 text-primary" style="width: 24px; text-align: center;"></i>
                                    <span class="fw-semibold">Xem tài khoản</span>
                                </a>
                            </li>
                            <li class="px-2 mb-1">
                                <a class="dropdown-item profile-item d-flex align-items-center rounded text-danger py-2" href="#">
                                    <i class="fas fa-sign-out-alt fs-5 me-2" style="width: 24px; text-align: center;"></i>
                                    <span class="fw-semibold">Thoát</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="offcanvas offcanvas-start border-0 shadow" tabindex="-1" id="offcanvasLeftMenu" aria-labelledby="offcanvasLeftMenuLabel" style="width: 320px;">

        <div class="offcanvas-header border-bottom position-relative d-flex justify-content-end align-items-center" style="height: 75px;">
            <div class="d-flex justify-content-center mt-auto position-absolute start-50 translate-middle d-flex" style="gap: 8px;">
                <div style="width: 18px; height: 40px; background-color: var(--primary-color);"></div>
                <div style="width: 18px; height: 40px; background-color: var(--primary-color);"></div>
                <div style="width: 18px; height: 40px; background-color: var(--primary-color);"></div>
            </div>
            <button type="button" class="btn-close shadow-none" data-bs-dismiss="offcanvas" aria-label="Close" style="z-index: 1;"></button>
        </div>

        <div class="offcanvas-body px-0 custom-scrollbar d-flex flex-column pb-0">

            <div class="side-menu-group px-4 mb-2 mt-2">
                <h5 class="fw-bold text-dark mb-3 text-uppercase">Danh Mục Món Ăn</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="side-menu-link">Ưu Đãi <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Món Mới <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Combo 1 Người <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Combo Nhóm <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Gà Rán - Gà Quay <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Burger - Cơm - Mì Ý <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Thức Ăn Nhẹ <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Thức Uống & Tráng Miệng <i class="fas fa-chevron-right"></i></a></li>
                </ul>
            </div>

            <hr class="border-secondary opacity-10 mx-3 my-3">

            <div class="side-menu-group px-4 mb-2">
                <h5 class="fw-bold text-dark mb-3 text-uppercase">Hỗ Trợ Khách Hàng</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="side-menu-link">Theo Dõi Đơn Hàng <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Liên Hệ Với Chúng Tôi <i class="fas fa-chevron-right"></i></a></li>
                </ul>
            </div>

            <hr class="border-secondary opacity-10 mx-3 my-3">

            <div class="side-menu-group px-4 mb-3">
                <h5 class="fw-bold text-dark mb-3 text-uppercase">Chính Sách</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="side-menu-link">Chính Sách Hoạt Động <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Chính Sách & Quy Định <i class="fas fa-chevron-right"></i></a></li>
                    <li><a href="#" class="side-menu-link">Chính Sách Bảo Mật Thông Tin <i class="fas fa-chevron-right"></i></a></li>
                </ul>
            </div>

            <hr class="border-secondary opacity-10 mx-3 my-3">

            <div class="d-flex justify-content-center mt-auto" style="gap: 8px;">
                <div style="width: 18px; height: 40px; background-color: var(--primary-color);"></div>
                <div style="width: 18px; height: 40px; background-color: var(--primary-color);"></div>
                <div style="width: 18px; height: 40px; background-color: var(--primary-color);"></div>
            </div>
        </div>
    </div>   

    <section class="admin-dashboard-section" style="margin-top: 140px; padding-bottom: 50px;">
        <div class="container-fluid px-4 px-lg-5">
            <div class="card shadow-sm border-0" style="border-radius: 4px;">
                <div class="card-header bg-white text-center py-3" style="border-bottom: 1px solid #eaeaea;">
                    <h3 class="mb-0 card-title-custom text-dark">Tất Cả Đơn Hàng</h3>
                </div>

                <div class="card-body p-4">
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                        <a href="./index" class="text-decoration-none fw-bold" style="color: var(--primary-color); font-size: 1.05rem;">
                            <i class="fas fa-arrow-left me-1"></i> Quay Lại
                        </a>

                        <form action="SearchProductServlet" method="GET" class="d-flex flex-nowrap" style="width: 100%; max-width: 400px;">
                            <input type="text" class="form-control form-control-custom me-2 rounded-0 w-100" name="keyword" placeholder="Tìm kiếm sản phẩm...">
                            <button type="submit" class="btn btn-custom px-4 rounded-0 text-nowrap flex-shrink-0">Tìm Kiếm</button>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle mb-0 text-start">
                            <thead class="bg-light text-dark" style="font-family: var(--ff-heading); font-size: 0.95rem;">
                                <tr>
                                    <th scope="col" class="py-3">Id</th>
                                    <th scope="col" class="py-3">Thông Tin</th>
                                    <th scope="col" class="py-3">Ngày</th>
                                    <th scope="col" class="py-3">Chi Tiết Đơn</th>
                                    <th scope="col" class="py-3">Giá</th>
                                    <th scope="col" class="py-3">Thanh Toán</th>
                                    <th scope="col" class="py-3">Tình Trạng</th>
                                    <th scope="col" class="py-3 text-center" style="width: 250px;">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="o" items="${orderList}">
                                <tr>
                                    <td class="fw-bold">${o.orderId}</td>
                                    <td class="deliver-details">
                                        <p>Name: ${o.recipientName}</p>
                                        <p>Mobile: ${o.phone}</p>
                                        <p>Address: ${o.addressDetail}</p>
                                    </td>
                                    <td>${o.createdAt}</td>
                                    <td>...</td> 
                                    <td><fmt:formatNumber value="${o.finalAmount}" type="currency" currencySymbol="đ" /></td>
                                <td>${o.paymentStatus}</td>
                                <td>${o.status}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/UpdateOrderStatusServlet" method="POST" class="d-flex gap-2">
                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                        <select class="form-select form-select-sm" name="status">
                                            <option value="pending" ${o.status == 'pending' ? 'selected' : ''}>Pending</option>
                                            <option value="confirmed" ${o.status == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                            <option value="shipping" ${o.status == 'shipping' ? 'selected' : ''}>Shipping</option>
                                            <option value="completed" ${o.status == 'completed' ? 'selected' : ''}>Completed</option>
                                            <option value="cancelled" ${o.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn btn-custom btn-sm">Cập Nhật</button>
                                    </form>
                                </td>
                                </tr>
                            </c:forEach>
                            </tbody>  
                        </table>
                    </div>
                </div>

                <div class="card-footer bg-white d-flex flex-column flex-md-row justify-content-between align-items-center py-3 border-top" style="border-color: #eaeaea !important;">
                    <span class="text-muted fw-medium mb-3 mb-md-0" style="font-size: 0.95rem;">Tổng: 4</span>

                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-custom mb-0">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>

            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container text-center">
            <h4 class="footer-title mb-4">Các thành viên trong nhóm:</h4>

            <div class="d-flex flex-column align-items-center gap-3">

                <div class="member-item">
                    <div class="member-name">1. Ngô Phương Anh - 09/05/2005</div>
                </div>

                <div class="member-item">
                    <div class="member-name">2. Phùng Ngọc Bảo - 13/12/2005</div>
                </div>

                <div class="member-item">
                    <div class="member-name">3. Vũ Ngọc Hương Giang - 25/12/2005</div>
                </div>
            </div>
        </div>
    </footer>

    <a href="#" class="back-top-btn active" aria-label="Back to top" data-back-top-btn>
        <i class="fas fa-chevron-up"></i>
    </a>

    <div class="toast-container position-fixed top-0 end-0 p-3 mt-5 pt-4" style="z-index: 1055;">
        <div id="wishlistToast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">

                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/index.js"></script>
</body>
</html>