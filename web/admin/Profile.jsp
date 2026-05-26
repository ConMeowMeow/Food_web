<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem Tài Khoản</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <link rel="stylesheet" href="../css/TrangChu.css">
        <link rel="stylesheet" href="../css/admin/index.css">

        <style>
            .navbar-nav .nav-link {
                font-size: 0.95rem;
                padding-left: 0.8rem !important;
                padding-right: 0.8rem !important;
            }

            .profile-card {
                background: #fff;
                border-radius: 4px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }
            .form-label-bold {
                font-weight: 700;
                font-size: 0.95rem;
                color: var(--title-color, #212121);
            }

            .colon-align {
                float: right;
                margin-left: 10px;
            }

            .border-primary-custom {
                border-color: var(--primary-color) !important;
            }

            .was-validated .form-control:invalid {
                border-color: #dc3545;
            }
            .was-validated .form-control:valid {
                border-color: #198754;
            }
            .was-validated .form-control:focus {
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

    <section style="margin-top: 140px; margin-bottom: 80px; min-height: 70vh;">
        <div class="container">
            <div class="text-center mb-4">
                <div class="d-inline-block rounded-circle bg-white shadow-sm" style="width: 100px; height: 100px; border: 2px solid var(--primary-color); overflow: hidden; display: flex; align-items: center; justify-content: center;">
                    <img src="https://ui-avatars.com/api/?name=Admin&background=ea6a47&color=fff&size=100" alt="Avatar" class="img-fluid w-100">
                </div>
            </div>

            <div class="profile-card p-4 p-md-5 mx-auto mb-5" style="max-width: 900px;">
                <form id="updateProfileForm" action="#" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>

                    <div class="row mb-3 align-items-center">
                        <label class="col-sm-3 col-form-label form-label-bold">Tên <span class="colon-align">:</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control text-muted" name="name" value="Phuong Anh" required>
                            <div class="invalid-feedback">Vui lòng nhập họ và tên.</div>
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label class="col-sm-3 col-form-label form-label-bold">SÐT <span class="colon-align">:</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control text-muted" name="mobile" value="0388319505" required pattern="(84|0[3|5|7|8|9])+([0-9]{8})">
                            <div class="invalid-feedback">Vui lòng nhập số điện thoại hợp lệ (10 số, bắt đầu bằng 0).</div>
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label class="col-sm-3 col-form-label form-label-bold">Email <span class="colon-align">:</span></label>
                        <div class="col-sm-9">
                            <input type="email" class="form-control text-muted" name="email" value="phanhzu95@gmail.com" required>
                            <div class="invalid-feedback">Vui lòng nhập đúng định dạng email.</div>
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label class="col-sm-3 col-form-label form-label-bold">Địa Chỉ <span class="colon-align">:</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control text-muted" name="address" value="HBT" required>
                            <div class="invalid-feedback">Vui lòng nhập địa chỉ.</div>
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label class="col-sm-3 col-form-label form-label-bold">Ảnh <span class="colon-align">:</span></label>
                        <div class="col-sm-9">
                            <input type="file" class="form-control text-muted" name="image" accept="image/*">
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label class="col-sm-3 col-form-label form-label-bold">Role <span class="colon-align">:</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control text-muted" name="role" value="ROLE_ADMIN" readonly>
                        </div>
                    </div>

                    <div class="row mb-4 align-items-center">
                        <label class="col-sm-3 col-form-label form-label-bold">Trạng Thái Tài Khoản <span class="colon-align">:</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control text-muted" name="accountStatus" value="true" readonly>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-sm-3"></div>
                        <div class="col-sm-9">
                            <button type="submit" class="btn btn-custom px-4 py-2 rounded-0">Cập Nhật</button>
                        </div>
                    </div>
                </form>
            </div>

            <hr style="border-color: #dee2e6; margin-bottom: 40px;">

            <div class="text-center mb-4">
                <h3 style="color: var(--title-color); font-weight: 700; font-size: 1.8rem; font-family: var(--ff-heading);">Đổi Mật Khẩu</h3>
            </div>

            <div class="profile-card p-4 p-md-5 mx-auto" style="max-width: 800px;">
                <form id="changePasswordForm" action="#" method="POST" class="needs-validation" novalidate>
                    <div class="row mb-3 align-items-center">
                        <label class="col-sm-4 col-form-label form-label-bold">Mật Khẩu Hiện Tại</label>
                        <div class="col-sm-8">
                            <input type="password" class="form-control" name="currentPassword" required>
                            <div class="invalid-feedback">Vui lòng nhập mật khẩu hiện tại.</div>
                        </div>
                    </div>
                    <div class="row mb-3 align-items-center">
                        <label class="col-sm-4 col-form-label form-label-bold">Mật Khẩu Mới</label>
                        <div class="col-sm-8">
                            <input type="password" class="form-control" name="newPassword" id="newPassword" required minlength="6">
                            <div class="invalid-feedback">Mật khẩu mới phải có ít nhất 6 ký tự.</div>
                        </div>
                    </div>
                    <div class="row mb-4 align-items-center">
                        <label class="col-sm-4 col-form-label form-label-bold">Nhập Lại Mật Khẩu</label>
                        <div class="col-sm-8">
                            <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" required>
                            <div class="invalid-feedback">Mật khẩu xác nhận không khớp hoặc trống.</div>
                        </div>
                    </div>
                    <div class="row text-center mt-4">
                        <div class="col-12">
                            <button type="submit" class="btn btn-custom px-5 py-2 rounded-0" style="min-width: 150px;">Cập Nhật Mật Khẩu</button>
                        </div>
                    </div>
                </form>
            </div>

        </div>
    </section>

    <footer class="footer mt-5">
        <div class="container text-center">
            <h4 class="footer-title mb-3 fs-5" style="color: #e0e0e0;">Các thành viên trong nhóm:</h4>
            <div class="d-flex flex-column align-items-center gap-2">
                <div class="member-item"><div class="member-name">1. Ngô Phương Anh - 09/05/2005</div></div>
                <div class="member-item"><div class="member-name">2. Phùng Ngọc Bảo - 13/12/2005</div></div>
                <div class="member-item"><div class="member-name">3. Vũ Ngọc Hương Giang - 25/12/2005</div></div>
            </div>
        </div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        (function () {
            'use strict'

            var forms = document.querySelectorAll('.needs-validation')

            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {

                    if (form.id === 'changePasswordForm') {
                        var newPass = document.getElementById('newPassword');
                        var confirmPass = document.getElementById('confirmPassword');

                        if (newPass.value !== confirmPass.value) {
                            confirmPass.setCustomValidity('Mật khẩu không khớp');
                        } else {
                            confirmPass.setCustomValidity('');
                        }
                    }

                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }

                    form.classList.add('was-validated')
                }, false)

                if (form.id === 'changePasswordForm') {
                    var newPass = document.getElementById('newPassword');
                    var confirmPass = document.getElementById('confirmPassword');

                    confirmPass.addEventListener('input', function () {
                        if (newPass.value === confirmPass.value) {
                            confirmPass.setCustomValidity('');
                        } else {
                            confirmPass.setCustomValidity('Mật khẩu không khớp');
                        }
                    });

                    newPass.addEventListener('input', function () {
                        if (confirmPass.value !== '') {
                            if (newPass.value === confirmPass.value) {
                                confirmPass.setCustomValidity('');
                            } else {
                                confirmPass.setCustomValidity('Mật khẩu không khớp');
                            }
                        }
                    });
                }
            })
        })()
    </script>
</body>
</html>