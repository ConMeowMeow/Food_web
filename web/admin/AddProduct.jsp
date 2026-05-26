<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Món</title>

        <link rel="icon" href="${pageContext.request.contextPath}/img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TrangChu.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/index.css">

        <style>
            .form-control.is-invalid, .form-select.is-invalid {
                transition: none !important;
            }
            .invalid-feedback {
                animation: none !important;
                transition: none !important;
            }

            .form-control-custom:focus:not(.is-invalid), .form-select-custom:focus:not(.is-invalid) {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(234, 106, 71, 0.25);
            }
            .form-check-input-custom:checked {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }
        </style>
    </head>

    <body>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="../TrangChu">
                    <img src="../img/logo.png" alt="Logo" class="nav-logo">
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

    <section class="admin-dashboard-section" style="margin-top: 140px; padding-bottom: 50px;">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white text-center py-3" style="border-bottom: 1px solid #eaeaea;">
                            <h4 class="mb-0 fw-bold" style="font-family: var(--ff-heading); color: var(--primary-color);">Thêm Món</h4>
                        </div>

                        <div class="card-body p-4">
                            <form id="addProductForm" action="AddProduct" method="POST" enctype="multipart/form-data" novalidate>
                                <div class="mb-3">
                                    <label for="productTitle" class="form-label text-dark fw-medium" style="font-size: 0.95rem;">Tên Món</label>
                                    <input type="text" class="form-control form-control-custom" id="productTitle" name="productTitle" required>
                                    <div class="invalid-feedback">Vui lòng nhập tên sản phẩm.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="productDesc" class="form-label text-dark fw-medium" style="font-size: 0.95rem;">Mô Tả</label>
                                    <textarea class="form-control form-control-custom" id="productDesc" name="productDesc" rows="4" required></textarea>
                                    <div class="invalid-feedback">Vui lòng nhập mô tả sản phẩm.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="productCategory" class="form-label text-dark fw-medium" style="font-size: 0.95rem;">Danh Mục</label>
                                    <select class="form-select form-select-custom text-muted" id="productCategory" name="productCategory" required>
                                        <option value="" selected disabled>--Chọn--</option>

                                        <c:forEach items="${categoryList}" var="c">
                                            <option value="${c.categoryId}">${c.categoryName}</option>
                                        </c:forEach>

                                    </select>
                                    <div class="invalid-feedback">Vui lòng chọn danh mục.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="productPrice" class="form-label text-dark fw-medium" style="font-size: 0.95rem;">Giá</label>
                                    <input type="number" class="form-control form-control-custom" id="productPrice" name="productPrice" min="1000" required>
                                    <div class="invalid-feedback">Vui lòng nhập giá sản phẩm (tối thiểu 1000đ).</div>
                                </div>

                                <div class="row mb-4">

                                    <div class="col-md-6">
                                        <div class="mb-3"> <label class="form-label text-dark d-block fw-medium" style="font-size: 0.95rem;">Tình Trạng</label>
                                            <div class="form-check form-check-inline mb-1">
                                                <input class="form-check-input form-check-input-custom" type="radio" name="productStatus" id="statusActive" value="active" checked>
                                                <label class="form-check-label" for="statusActive">Còn Bán</label>
                                            </div>
                                            <div class="form-check form-check-inline d-block ms-0">
                                                <input class="form-check-input form-check-input-custom" type="radio" name="productStatus" id="statusInactive" value="inactive">
                                                <label class="form-check-label" for="statusInactive">Không Bán</label>
                                            </div>
                                        </div>

                                        <div>
                                            <label for="productStock" class="form-label text-dark fw-medium" style="font-size: 0.95rem;">Số Lượng</label>
                                            <input type="number" class="form-control form-control-custom" id="productStock" name="productStock" min="0" required>
                                            <div class="invalid-feedback">Vui lòng nhập số lượng (từ 0 trở lên).</div>
                                        </div>
                                    </div>

                                    <div class="col-md-6 d-flex flex-column justify-content-end" style="min-height: 145px;">
                                        <div id="inputWrapper" style="transition: all 0.3s ease;">
                                            <label for="productImage" class="form-label text-dark fw-medium" style="font-size: 0.95rem;">Ảnh</label>
                                            <input class="form-control form-control-custom" type="file" id="productImage" name="productImage" accept="image/*" style="font-size: 0.9rem;" required>
                                            <div class="invalid-feedback">Vui lòng chọn hình ảnh.</div>
                                        </div>

                                        <div class="mt-3 text-center d-none" id="imagePreviewContainer">
                                            <img id="imagePreview" src="" alt="Ảnh xem trước" class="img-fluid rounded shadow-sm border border-2 border-light" style="max-height: 180px; width: 100%; object-fit: cover;">
                                        </div>
                                    </div>

                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-custom py-2" style="font-size: 1.05rem; border-radius: 4px;">Xác Nhận</button>
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
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('addProductForm');

            form.addEventListener('submit', function (event) {
                event.preventDefault();

                let isValid = true;

                const title = document.getElementById('productTitle');
                const desc = document.getElementById('productDesc');
                const category = document.getElementById('productCategory');
                const price = document.getElementById('productPrice');
                const stock = document.getElementById('productStock');
                const image = document.getElementById('productImage');

                const inputs = form.querySelectorAll('.form-control, .form-select');
                inputs.forEach(input => input.classList.remove('is-invalid'));

                if (title.value.trim() === '') {
                    title.classList.add('is-invalid');
                    isValid = false;
                }

                if (desc.value.trim() === '') {
                    desc.classList.add('is-invalid');
                    isValid = false;
                }

                if (category.value === '') {
                    category.classList.add('is-invalid');
                    isValid = false;
                }

                if (price.value.trim() === '' || Number(price.value) < 1000) {
                    price.classList.add('is-invalid');
                    isValid = false;
                }

                if (stock.value.trim() === '' || Number(stock.value) < 0) {
                    stock.classList.add('is-invalid');
                    isValid = false;
                }

                if (image.files.length === 0) {
                    image.classList.add('is-invalid');
                    isValid = false;
                }

                if (isValid) {
                    form.submit();
                } else {
                    event.preventDefault();
                }
            });

            const imageInput = document.getElementById('productImage');
            const imagePreviewContainer = document.getElementById('imagePreviewContainer');
            const imagePreview = document.getElementById('imagePreview');

            imageInput.addEventListener('change', function () {
                const file = this.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        imagePreview.src = e.target.result;
                        imagePreviewContainer.classList.remove('d-none'); // Hiển thị khung ảnh
                    }
                    reader.readAsDataURL(file);
                } else {
                    imagePreview.src = "";
                    imagePreviewContainer.classList.add('d-none');
                }
            });
        });
    </script>
</body>
</html>