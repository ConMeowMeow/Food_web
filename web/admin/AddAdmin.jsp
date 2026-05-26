<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Quản Trị Viên</title>

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
            .form-control.is-invalid {
                transition: none !important;
            }
            .invalid-feedback {
                animation: none !important;
                transition: none !important;
            }

            .form-control-custom:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(234, 106, 71, 0.25);
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
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-7 col-md-9">

                    <div class="card shadow-sm border-0" style="border-radius: 4px;">
                        <div class="card-header bg-light text-center py-3" style="border-bottom: 1px solid #eaeaea;">
                            <h4 class="mb-0 fw-normal text-dark" style="font-family: var(--ff-heading);">Thêm Admin</h4>
                        </div>

                        <div class="card-body p-4">
                            <form id="addAdminForm" action="AddAdminServlet" method="POST" enctype="multipart/form-data" novalidate>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-dark small fw-bold">Tên</label>
                                        <input type="text" class="form-control form-control-custom rounded-0" id="fullname" name="fullname" required>
                                        <div class="invalid-feedback">Vui lòng nhập họ tên.</div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-dark small fw-bold">SĐT</label>
                                        <input type="tel" class="form-control form-control-custom rounded-0" id="mobile" name="mobile" required>
                                        <div class="invalid-feedback">Số điện thoại không hợp lệ.</div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-dark small fw-bold">Email</label>
                                    <input type="email" class="form-control form-control-custom rounded-0" id="email" name="email" required>
                                    <div class="invalid-feedback">Email không đúng định dạng.</div>
                                </div>

                                <div class="row">
                                    <div class="mb-3">
                                        <label class="form-label text-dark small fw-bold">Địa Chỉ</label>
                                        <input type="text" class="form-control form-control-custom rounded-0" id="address" name="address" required>
                                        <div class="invalid-feedback">Vui lòng nhập địa chỉ.</div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-dark small fw-bold">Mật Khẩu</label>
                                        <input type="password" class="form-control form-control-custom rounded-0" id="password" name="password" required>
                                        <div class="invalid-feedback">Mật khẩu tối thiểu 6 ký tự.</div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-dark small fw-bold">Nhập Lại Mật Khẩu</label>
                                        <input type="password" class="form-control form-control-custom rounded-0" id="confirmPassword" name="confirmPassword" required>
                                        <div class="invalid-feedback">Mật khẩu không khớp.</div>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-dark small fw-bold">Ảnh đại diện</label>

                                    <input class="form-control form-control-custom rounded-0" type="file" id="profileImg" name="profileImg" accept="image/*">

                                    <div class="mt-3 text-start d-none" id="imagePreviewContainer">
                                        <img id="imagePreview" src="" alt="Ảnh xem trước" 
                                             class="img-fluid shadow-sm border border-2 border-light" 
                                             style="width: 110px; height: 110px; object-fit: cover;">
                                    </div>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-custom py-2 rounded-0 fw-bold">Đăng Kí</button>
                                </div>

                            </form>
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

    <script>
        // ======================================================
        // 1. XỬ LÝ HIỂN THỊ ẢNH PREVIEW (HOẠT ĐỘNG ĐỘC LẬP)
        // ======================================================
        const profileImgInput = document.getElementById('profileImg');
        const imagePreviewContainer = document.getElementById('imagePreviewContainer');
        const imagePreview = document.getElementById('imagePreview');

        profileImgInput.addEventListener('change', function () {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    imagePreview.src = e.target.result;
                    imagePreviewContainer.classList.remove('d-none'); // Bật khung ảnh lên
                };
                reader.readAsDataURL(file);
            } else {
                imagePreview.src = "";
                imagePreviewContainer.classList.add('d-none');
            }
        });

        // ======================================================
        // 2. XỬ LÝ KIỂM TRA LỖI VÀ SUBMIT FORM
        // ======================================================
        document.getElementById('addAdminForm').addEventListener('submit', function (event) {
            event.preventDefault();

            let isValid = true;
            const fields = ['fullname', 'mobile', 'email', 'address', 'password', 'confirmPassword'];

            // Kiểm tra các trường không được để trống
            fields.forEach(id => {
                const input = document.getElementById(id);
                input.classList.remove('is-invalid');
                if (input.value.trim() === '') {
                    input.classList.add('is-invalid');
                    isValid = false;
                }
            });

            // Kiểm tra mật khẩu khớp nhau
            const pass = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            if (pass !== confirm) {
                document.getElementById('confirmPassword').classList.add('is-invalid');
                isValid = false;
            }

            // Nếu tất cả hợp lệ -> Xóa trắng form và ẩn ảnh
            if (isValid) {
                alert('Đã thêm quản trị viên mới!');
                this.reset();
                document.getElementById('imagePreview').src = "";
                document.getElementById('imagePreviewContainer').classList.add('d-none');
            }
        });
    </script>
</body>
</html>