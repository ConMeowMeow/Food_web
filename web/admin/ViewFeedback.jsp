<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem Phản Hồi</title>

        <link rel="icon" href="../img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <link rel="stylesheet" href="../css/TrangChu.css">
        <link rel="stylesheet" href="../css/admin/index.css">

        <style>
            body {
                background-color: #f8f9fc;
            }

            .form-control-custom:focus {
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

            .rating-stars {
                color: #ffb703;
                font-size: 0.9rem;
            }
        </style>
    </head>

    <body>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="../TrangChu.jsp">
                    <img src="../img/logo.png" alt="Logo" class="nav-logo">
                </a>

                <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-expanded="false">
                    <i class="fa-solid fa-caret-down fs-2 toggle-caret"></i>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto fw-bold">
                        <li class="nav-item"><a class="nav-link" href="index.jsp">Trang chủ</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="productDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Món Ăn
                            </a>
                            <ul class="dropdown-menu shadow border-0" aria-labelledby="productDropdown">
                                <li><a class="dropdown-item py-2" href="ViewProduct.jsp"><i class="fas fa-table-list me-2 text-success"></i>Xem Món</a></li>
                                <li><a class="dropdown-item py-2" href="AddProduct.jsp"><i class="fas fa-plus-square me-2 text-primary"></i>Thêm Món</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2" href="AddCategory.jsp"><i class="fas fa-list-ul me-2 text-warning"></i>Danh Mục</a></li>
                            </ul>
                        </li>

                        <li class="nav-item"><a class="nav-link" href="Orders.jsp">Đơn Hàng</a></li>
                        <li class="nav-item"><a class="nav-link" href="Users.jsp">Khách Hàng</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Admin
                            </a>
                            <ul class="dropdown-menu shadow border-0" aria-labelledby="adminDropdown">
                                <li><a class="dropdown-item py-2" href="AdminList.jsp"><i class="fas fa-users-cog me-2 text-primary"></i>Danh sách Admin</a></li>
                                <li><a class="dropdown-item py-2" href="AddAdmin.jsp"><i class="fas fa-user-plus me-2 text-primary"></i>Thêm Admin</a></li>
                            </ul>
                        </li>

                        <li class="nav-item"><a class="nav-link" href="Voucher.jsp">Voucher</a></li>
                        <li class="nav-item"><a class="nav-link" href="ViewFeedback.jsp">Phản Hồi</a></li>
                    </ul>

                    <div class="dropdown position-relative">
                        <a href="#" class="text-dark text-decoration-none d-flex align-items-center justify-content-center border border-2 border-primary rounded-circle" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 40px; height: 40px;">
                            <img src="https://ui-avatars.com/api/?name=Admin&background=0d6efd&color=fff" alt="Avatar" class="rounded-circle w-100 h-100 icon-wrap-profile" style="object-fit: cover;">
                        </a>

                        <ul class="dropdown-menu border-0 shadow-lg profile-dropdown" aria-labelledby="accountDropdown" style="left: 50%; transform: translateX(-50%); margin-top: 10px; min-width: 170px;">
                            <li class="px-2 mb-1 mt-1">
                                <a class="dropdown-item profile-item d-flex align-items-center rounded py-2" href="Profile.jsp">
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

    <section class="admin-dashboard-section" style="margin-top: 140px; padding-bottom: 50px;">
        <div class="container-fluid px-4 px-lg-5">
            <div class="card shadow-sm border-0" style="border-radius: 4px;">
                <div class="card-header bg-white text-center py-3" style="border-bottom: 1px solid #eaeaea;">
                    <h3 class="mb-0 card-title-custom text-dark">Quản Lý Liên Hệ & Thắc Mắc</h3>
                </div>

                <div class="card-body p-4">
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                        <a href="./index.jsp" class="text-decoration-none fw-bold" style="color: var(--primary-color); font-size: 1.05rem;">
                            <i class="fas fa-arrow-left me-1"></i> Quay Lại
                        </a>

                        <form action="SearchProductServlet" method="GET" class="d-flex flex-nowrap" style="width: 100%; max-width: 400px;">
                            <input type="text" class="form-control form-control-custom me-2 rounded-0 w-100" name="keyword" placeholder="Tìm kiếm sản phẩm...">
                            <button type="submit" class="btn btn-custom px-4 rounded-0 text-nowrap flex-shrink-0">Tìm Kiếm</button>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle mb-0">
                            <thead class="bg-light text-dark text-center" style="font-family: var(--ff-heading); font-size: 0.95rem;">
                                <tr>
                                    <th scope="col" class="py-3">Id</th>
                                    <th scope="col" class="py-3 text-start">Thông Tin</th>
                                    <th scope="col" class="py-3 text-start">Vấn Đề</th>
                                    <th scope="col" class="py-3 text-start" style="width: 30%;">Nội Dung Phản Hồi</th>
                                    <th scope="col" class="py-3">File Đính Kèm</th>
                                    <th scope="col" class="py-3">Trạng Thái</th>
                                    <th scope="col" class="py-3">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-bold text-center">1</td>
                                    <td>
                                        <div class="fw-bold">Ngô Phương Anh</div>
                                        <div class="small text-muted"><i class="fas fa-envelope me-1"></i>nguyenvana@gmail.com</div>
                                        <div class="small text-muted"><i class="fas fa-phone-alt me-1"></i>0912345678</div>
                                    </td>
                                    <td class="fw-medium text-danger">Đơn hàng</td>
                                    <td>
                                        <p class="mb-1" style="white-space: pre-wrap; word-break: break-word;">Tôi đã đặt món nhưng đột nhiên bị hủy</p>
                                        <small class="text-muted d-block"><i>Gửi lúc: 06/05/2026 14:30</i></small>
                                    </td>
                                    <td class="text-center">
                                        <a href="#" class="text-decoration-none text-primary" title="Xem ảnh bill_momo.jpg">
                                            <i class="fas fa-file-image fs-4"></i>
                                        </a>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Chưa xử lý</span>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-sm text-white" style="background-color: var(--primary-color); border-radius: 4px;" data-bs-toggle="modal" data-bs-target="#replyModal">
                                                <i class="fas fa-reply me-1"></i>Trả lời
                                            </button>
                                            <button class="btn btn-danger btn-sm" style="border-radius: 4px;"><i class="fas fa-trash-alt"></i></button>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="fw-bold text-center">2</td>
                                    <td>
                                        <div class="fw-bold">Vũ Ngọc Hương Giang</div>
                                        <div class="small text-muted"><i class="fas fa-envelope me-1"></i>thibtran99@gmail.com</div>
                                        <div class="small text-muted"><i class="fas fa-phone-alt me-1"></i>0987654321</div>
                                    </td>
                                    <td class="fw-medium text-info">Chất lượng món ăn</td>
                                    <td>
                                        <p class="mb-1" style="white-space: pre-wrap; word-break: break-word;">Gà rán hôm nay giao đến bị nguội</p>
                                        <small class="text-muted d-block"><i>Gửi lúc: 05/05/2026 19:15</i></small>
                                    </td>
                                    <td class="text-center text-muted">
                                        Không có
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-success px-3 py-2 rounded-pill">Đã phản hồi</span>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-sm btn-outline-secondary" style="border-radius: 4px;" data-bs-toggle="modal" data-bs-target="#replyModal">
                                                <i class="fas fa-eye me-1"></i>Xem lại
                                            </button>
                                            <button class="btn btn-danger btn-sm" style="border-radius: 4px;"><i class="fas fa-trash-alt"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="modal fade" id="replyModal" tabindex="-1" aria-labelledby="replyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-light border-bottom-0">
                    <h5 class="modal-title fw-bold" id="replyModalLabel" style="color: var(--primary-color);">
                        <i class="fas fa-envelope-open-text me-2"></i>Chi Tiết Phản Hồi & Trả Lời
                    </h5>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="bg-light p-3 rounded mb-4 border">
                        <div class="row mb-2">
                            <div class="col-sm-3 text-muted fw-semibold">Người gửi:</div>
                            <div class="col-sm-9 fw-bold">Nguyễn Văn A (0912345678)</div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-sm-3 text-muted fw-semibold">Chủ đề:</div>
                            <div class="col-sm-9 text-danger fw-medium">Đơn hàng & Thanh toán</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3 text-muted fw-semibold">Nội dung:</div>
                            <div class="col-sm-9">
                                Tôi đã thanh toán qua Momo nhưng đơn hàng vẫn báo chưa thanh toán. Trừ tiền rồi nhưng không thấy đơn ở đâu. Nhờ shop kiểm tra gấp!
                            </div>
                        </div>
                    </div>

                    <form id="sendReplyForm">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Gửi đến Email:</label>
                            <input type="email" class="form-control rounded-0 bg-light" value="nguyenvana@gmail.com" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Tiêu đề Email:</label>
                            <input type="text" class="form-control form-control-custom rounded-0" value="[Fast Food] Phản hồi về vấn đề Đơn hàng & Thanh toán">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Nội dung trả lời:</label>
                            <textarea class="form-control form-control-custom rounded-0" rows="5" placeholder="Nhập nội dung email phản hồi cho khách hàng..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary rounded-0 px-4" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn text-white rounded-0 px-4" style="background-color: var(--primary-color);">
                        <i class="fas fa-paper-plane me-2"></i>Gửi Phản Hồi
                    </button>
                </div>
            </div>
        </div>
    </div>

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

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>