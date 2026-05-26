<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem Món</title>

        <link rel="icon" href="../img/logo.png" type="image/png">
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
        <div class="container-fluid px-4 px-lg-5">
            <div class="card shadow-sm border-0" style="border-radius: 4px;">
                <div class="card-header bg-white text-center py-3" style="border-bottom: 1px solid #eaeaea;">
                    <h3 class="mb-0 card-title-custom text-dark">Tất Cả Món Ăn</h3>
                </div>

                <div class="card-body p-4">
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                        <a href="./index" class="text-decoration-none fw-bold" style="color: var(--primary-color); font-size: 1.05rem;">
                            <i class="fas fa-arrow-left me-1"></i> Quay Lại
                        </a>

                        <form action="${pageContext.request.contextPath}/SearchProductServlet" method="GET" class="d-flex flex-nowrap" style="width: 100%; max-width: 400px;">
                            <input type="text" class="form-control form-control-custom me-2 rounded-0 w-100" name="keyword" value="${param.keyword}" placeholder="Tìm kiếm sản phẩm...">
                            <button type="submit" class="btn btn-custom px-4 rounded-0 text-nowrap flex-shrink-0">Tìm Kiếm</button>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle mb-0 text-center">
                            <thead class="bg-light text-dark" style="font-family: var(--ff-heading); font-size: 0.95rem;">
                                <tr>
                                    <th scope="col" class="py-3">Id</th>
                                    <th scope="col" class="py-3">Ảnh</th>
                                    <th scope="col" class="py-3 text-start">Tên</th>
                                    <th scope="col" class="py-3 text-start">Danh Mục</th>
                                    <th scope="col" class="py-3 text-start">Giá</th>
                                    <th scope="col" class="py-3 text-start">Giảm Giá</th>
                                    <th scope="col" class="py-3 text-start">Giá Sau Giảm</th>
                                    <th scope="col" class="py-3 text-start">Tình Trạng</th>
                                    <th scope="col" class="py-3 text-start">Số Lượng</th>
                                    <th scope="col" class="py-3">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${not empty sessionScope.msg}">
                                <div class="alert alert-warning alert-dismissible fade show m-2" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>${sessionScope.msg}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                                <c:remove var="msg" scope="session" />
                            </c:if>

                            <c:choose>
                                <c:when test="${not empty productList}">
                                    <c:forEach var="p" items="${productList}">
                                        <tr>
                                            <td class="fw-bold">${p.productId}</td>
                                            <td>
                                                <img src="${not empty p.imageUrl ? pageContext.request.contextPath.concat('/').concat(p.imageUrl) : 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd'}" 
                                                     alt="${p.name}" class="rounded shadow-sm" style="width: 60px; height: 60px; object-fit: cover;">
                                            </td>
                                            <td class="text-start fw-semibold">${p.name}</td>
                                            <td class="text-start">Mã DM: ${p.cagetoryId}</td> 

                                            <td class="text-start"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                                            <td class="text-start"><fmt:formatNumber value="${p.discount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                                            <td class="text-start fw-bold text-danger">
                                                <fmt:formatNumber value="${p.price - p.discount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            </td>

                                            <td class="text-start">
                                                <span class="badge ${p.status == 1 ? 'bg-success' : 'bg-danger'}">${p.status == 1 ? 'Đang bán' : 'Ngừng bán'}</span>
                                            </td>
                                            <td class="text-start">${p.stock}</td>
                                            <td>
                                                <div class="d-flex justify-content-center gap-2">
                                                    <button type="button" class="btn btn-sm text-white btn-edit-product" 
                                                            style="background-color: var(--primary-color); border-radius: 4px;" 
                                                            data-bs-toggle="modal" data-bs-target="#editProductModal"
                                                            data-id="${p.productId}"
                                                            data-name="${p.name}"
                                                            data-category="${p.cagetoryId}"
                                                            data-price="${p.price}"
                                                            data-discount="${p.discount}"
                                                            data-stock="${p.stock}"
                                                            data-status="${p.status}"
                                                            data-img="${not empty p.imageUrl ? pageContext.request.contextPath.concat('/').concat(p.imageUrl) : ''}">
                                                        <i class="fas fa-edit me-1"></i>Sửa
                                                    </button>

                                                    <form action="${pageContext.request.contextPath}/DeleteProduct" method="POST" onsubmit="return confirm('Bạn có chắc chắn muốn xóa món ăn này không?');" style="display:inline; margin:0;">
                                                        <input type="hidden" name="id" value="${p.productId}">
                                                        <button type="submit" class="btn btn-danger btn-sm" style="border-radius: 4px;">
                                                            <i class="fas fa-trash-alt me-1"></i>Xóa
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="10" class="text-center py-4 text-muted">Không tìm thấy món ăn nào trong hệ thống!</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card-footer bg-white d-flex flex-column flex-md-row justify-content-between align-items-center py-3 border-top" style="border-color: #eaeaea !important;">
                    <span class="text-muted fw-medium mb-3 mb-md-0" style="font-size: 0.95rem;">Tổng: ${productList.size()}</span>  

                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-custom mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}">&laquo;</a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}">&raquo;</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
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

    <div class="modal fade" id="editProductModal" tabindex="-1" aria-labelledby="editProductModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-light border-bottom-0">
                    <h5 class="modal-title card-title-custom fw-bold" id="editProductModalLabel" style="color: var(--primary-color);">
                        <i class="fas fa-edit me-2"></i>Chỉnh Sửa Thông Tin Món
                    </h5>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <form id="editProductForm" action="${pageContext.request.contextPath}/UpdateProduct" method="POST" enctype="multipart/form-data">
                    <div class="modal-body p-4">

                        <input type="hidden" name="editProductId" id="editProductId">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Tên món (Title)</label>
                                <input type="text" class="form-control form-control-custom rounded-0" id="editTitle" name="editTitle" placeholder="Nhập tên món" required>
                            </div>
                            <div class="col-md-6 mt-3 mt-md-0">
                                <label class="form-label fw-semibold">Danh mục (Category)</label>
                                <select class="form-select form-control-custom rounded-0" id="editCategory" name="editCategory" required>
                                    <option value="" disabled>-- Chọn Danh Mục --</option>
                                    <c:forEach items="${categoryList}" var="c">
                                        <option value="${c.categoryId}">${c.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Giá gốc (Price)</label>
                                <input type="number" class="form-control form-control-custom rounded-0" id="editPrice" name="editPrice" min="0" required>
                            </div>
                            <div class="col-md-4 mt-3 mt-md-0">
                                <label class="form-label fw-semibold">Giảm giá (%)</label>
                                <input type="number" class="form-control form-control-custom rounded-0" id="editDiscount" name="editDiscount" min="0" value="0">
                            </div>
                            <div class="col-md-4 mt-3 mt-md-0">
                                <label class="form-label fw-semibold">Số lượng (Stock)</label>
                                <input type="number" class="form-control form-control-custom rounded-0" id="editStock" name="editStock" min="0" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Hình ảnh (Chỉ chọn file nếu muốn đổi ảnh)</label>
                                <input type="file" class="form-control form-control-custom rounded-0" id="editImage" name="editImage" accept="image/*">

                                <div class="mt-3 text-start">
                                    <img id="imagePreview" src="" alt="Preview" class="img-thumbnail d-none shadow-sm" style="width: 100%; height: 250px; object-fit: cover; border-radius: 6px;">
                                </div>
                            </div>
                            <div class="col-md-6 mt-3 mt-md-0">
                                <label class="form-label fw-semibold d-block">Trạng thái (Status)</label>
                                <div class="d-flex align-items-center mt-2">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="editStatusRadio" id="statusActive" value="active" style="cursor: pointer;">
                                        <label class="form-check-label" for="statusActive">Đang bán</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="editStatusRadio" id="statusInactive" value="inactive" style="cursor: pointer;">
                                        <label class="form-check-label" for="statusInactive">Ngừng bán</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="button" class="btn btn-secondary rounded-0 px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn text-white rounded-0 px-4" style="background-color: var(--primary-color);">Lưu Thay Đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

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
    <script src="${pageContext.request.contextPath}/js/index.js"></script>

    <script>
                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            const editButtons = document.querySelectorAll('.btn-edit-product');
                                                            const imagePreview = document.getElementById('imagePreview');
                                                            const editImageInput = document.getElementById('editImage');

                                                            editButtons.forEach(button => {
                                                                button.addEventListener('click', function () {
                                                                    // Lấy dữ liệu an toàn từ data-* attributes thay vì DOM HTML
                                                                    document.getElementById('editProductId').value = this.dataset.id;
                                                                    document.getElementById('editTitle').value = this.dataset.name;
                                                                    document.getElementById('editCategory').value = this.dataset.category;

                                                                    // Ép kiểu Giá và Giảm giá sang số thực và làm tròn để loại bỏ đuôi ".0", tránh lỗi trắng Form
                                                                    const priceValue = parseFloat(this.dataset.price);
                                                                    const discountValue = parseFloat(this.dataset.discount);

                                                                    document.getElementById('editPrice').value = isNaN(priceValue) ? 0 : Math.round(priceValue);
                                                                    document.getElementById('editDiscount').value = isNaN(discountValue) ? 0 : Math.round(discountValue);

                                                                    // Xử lý Tồn kho
                                                                    let stock = parseInt(this.dataset.stock);
                                                                    document.getElementById('editStock').value = isNaN(stock) ? 0 : stock;

                                                                    // Xử lý Checkbox Trạng Thái độc lập (1 = Active, 0 = Inactive)
                                                                    let status = parseInt(this.dataset.status);
                                                                    if (status === 1) {
                                                                        document.getElementById('statusActive').checked = true;
                                                                    } else {
                                                                        document.getElementById('statusInactive').checked = true;
                                                                    }

                                                                    // Xử lý Hiển thị ảnh cũ
                                                                    const imgSrc = this.dataset.img;
                                                                    editImageInput.value = ''; // Reset file input
                                                                    if (imgSrc) {
                                                                        imagePreview.src = imgSrc;
                                                                        imagePreview.classList.remove('d-none');
                                                                    } else {
                                                                        imagePreview.classList.add('d-none');
                                                                    }
                                                                });
                                                            });

                                                            // Hiển thị ảnh xem trước khi người dùng chọn file mới
                                                            editImageInput.addEventListener('change', function (event) {
                                                                const file = event.target.files[0];
                                                                if (file) {
                                                                    const reader = new FileReader();
                                                                    reader.onload = function (e) {
                                                                        imagePreview.src = e.target.result;
                                                                        imagePreview.classList.remove('d-none');
                                                                    };
                                                                    reader.readAsDataURL(file);
                                                                }
                                                            });
                                                        });
    </script>
</body>
</html>