<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Category" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Danh Mục</title>

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
                color: #333;
                font-weight: 500;
            }
        </style>
    </head>

    <body>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="../TrangChu">
                    <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" class="nav-logo">
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
        <div class="container-xl">
            <%
    String msg = (String) session.getAttribute("msg");
    if (msg != null) {
            %>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <strong>Thông báo:</strong> <%= msg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%
                    session.removeAttribute("msg");
                }
            %>
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card shadow-sm border-0" style="border-radius: 4px;">
                        <div class="card-header bg-white text-center py-3" style="border-bottom: 1px solid #eaeaea;">
                            <h4 class="mb-0 card-title-custom">Thêm Danh Mục</h4>
                        </div>

                        <div class="card-body p-4">
                            <form id="addCategoryForm" action="${pageContext.request.contextPath}/AddCategory" method="POST" enctype="multipart/form-data" novalidate>
                                <div class="mb-3">
                                    <label for="categoryName" class="form-label text-dark" style="font-size: 0.95rem;">Tên Danh Mục</label>
                                    <input type="text" class="form-control form-control-custom" id="categoryName" name="categoryName" required>
                                    <div class="invalid-feedback">Vui lòng nhập tên danh mục.</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-dark d-block" style="font-size: 0.95rem;">Tình Trạng</label>
                                    <div class="form-check mb-1">
                                        <input class="form-check-input form-check-input-custom" type="radio" name="categoryStatus" id="statusActive" value="active" checked>
                                        <label class="form-check-label" for="statusActive">Hoạt Động</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input form-check-input-custom" type="radio" name="categoryStatus" id="statusInactive" value="inactive">
                                        <label class="form-check-label" for="statusInactive">Không Hoạt Động</label>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="categoryImage" class="form-label text-dark" style="font-size: 0.95rem;">Ảnh</label>
                                    <input class="form-control form-control-custom" type="file" id="categoryImage" name="categoryImage" accept="image/*" style="font-size: 0.9rem;" required>
                                    <div class="invalid-feedback">Vui lòng chọn hình ảnh danh mục.</div>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-custom py-2" style="font-size: 1.05rem; border-radius: 4px;">Save</button>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="card shadow-sm border-0" style="border-radius: 4px; height: 100%;">
                        <div class="card-header bg-white text-center py-3" style="border-bottom: 1px solid #eaeaea;">
                            <h4 class="mb-0 card-title-custom">Chi Tiết Danh Mục</h4>
                        </div>

                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="bg-light">
                                        <tr>
                                            <th scope="col" class="ps-4 py-3">Id</th>
                                            <th scope="col" class="py-3">Danh Mục</th>
                                            <th scope="col" class="py-3">Tình Trạng</th>
                                            <th scope="col" class="py-3">Ảnh</th>
                                            <th scope="col" class="pe-4 py-3">Hành Động</th>
                                        </tr>
                                    </thead>
                                    <tbody class="border-top-0">
                                        <% 
                                            // Lấy danh sách category từ Servlet đã được truyền vào request
                                            List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
        
                                            // Kiểm tra xem danh sách có dữ liệu không
                                            if (listCategories != null && !listCategories.isEmpty()) {
                                                // Duyệt qua từng đối tượng Category trong list
                                                for (Category cat : listCategories) {
                                        %>
                                        <tr>
                                            <td class="ps-4 fw-bold"><%= cat.getCategoryId() %></td>
                                            <td><%= cat.getCategoryName() %></td>
                                            <td><%= cat.getStatus() %></td>

                                            <td>
                                                <img src="${pageContext.request.contextPath}/<%= cat.getImgUrl() %>" 
                                                     alt="<%= cat.getCategoryName() %>" 
                                                     class="rounded shadow-sm" 
                                                     style="width: 50px; height: 50px; object-fit: cover;">
                                            </td>

                                            <td class="pe-4">
                                                <button type="button" class="btn btn-sm text-white me-1 btn-edit-category" 
                                                        style="background-color: var(--primary-color);" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#editCategoryModal">
                                                    <i class="fas fa-edit me-1"></i>Sửa
                                                </button>

                                                <form action="${pageContext.request.contextPath}/DeleteCategory" 
                                                      method="POST" 
                                                      style="display:inline;" 
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa? Nếu danh mục này có sản phẩm, yêu cầu sẽ bị từ chối.');">

                                                    <input type="hidden" name="id" value="<%= cat.getCategoryId() %>">

                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                        <i class="fas fa-trash-alt me-1"></i>Xóa
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% 
                                                } // Kết thúc vòng lặp for
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="5" class="text-center">Chưa có danh mục nào.</td>
                                        </tr>
                                        <% 
                                            } // Kết thúc if
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="card-footer bg-white d-flex justify-content-between align-items-center py-3 border-top" style="border-color: #eaeaea !important;">
                            <%
                                // Lấy thông số phân trang do Servlet truyền sang
                                Integer totalRecords = (Integer) request.getAttribute("totalRecords");
                                Integer totalPages = (Integer) request.getAttribute("totalPages");
                                Integer currentPage = (Integer) request.getAttribute("currentPage");
        
                                // Tránh lỗi NullPointerException nếu lần đầu load chưa có dữ liệu
                                if (totalRecords == null) totalRecords = 0;
                                if (totalPages == null) totalPages = 1;
                                if (currentPage == null) currentPage = 1;
                            %>

                            <span class="text-muted fw-medium" style="font-size: 0.95rem;">Tổng: <%= totalRecords %> danh mục</span>

                            <% if (totalPages > 1) { %>
                            <nav aria-label="Page navigation">
                                <ul class="pagination pagination-custom mb-0">

                                    <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                                        <a class="page-link" href="${pageContext.request.contextPath}/AddCategory?page=<%= currentPage - 1 %>" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>

                                    <% for (int i = 1; i <= totalPages; i++) { %>
                                    <li class="page-item <%= (currentPage == i) ? "active" : "" %>">
                                        <a class="page-link" href="${pageContext.request.contextPath}/AddCategory?page=<%= i %>"><%= i %></a>
                                    </li>
                                    <% } %>

                                    <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                                        <a class="page-link" href="${pageContext.request.contextPath}/AddCategory?page=<%= currentPage + 1 %>" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>

                                </ul>
                            </nav>
                            <% } %>
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

    <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-light border-bottom-0">
                    <h5 class="modal-title card-title-custom fw-bold" id="editCategoryModalLabel" style="color: var(--primary-color);">
                        <i class="fas fa-edit me-2"></i>Chỉnh Sửa Danh Mục
                    </h5>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <form id="editCategoryFormModal" action="${pageContext.request.contextPath}/UpdateCategory" method="POST" enctype="multipart/form-data">
                    <div class="modal-body p-4">
                        <input type="hidden" id="editCategoryId" name="editCategoryId">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Tên Danh Mục (Category Name)</label>
                            <input type="text" class="form-control form-control-custom rounded-0" id="editCategoryName" name="editCategoryName" placeholder="Nhập tên danh mục" required>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Hình ảnh (Chọn file mới nếu muốn đổi)</label>
                                <input type="file" class="form-control form-control-custom rounded-0" id="editCategoryImage" name="editCategoryImage" accept="image/*">

                                <div class="mt-3 text-start">
                                    <img id="categoryImagePreview" src="" alt="Preview" class="img-thumbnail d-none shadow-sm" style="width: 100%; height: 250px; object-fit: cover; border-radius: 6px;">
                                </div>
                            </div>
                            <div class="col-md-6 mt-3 mt-md-0">
                                <label class="form-label fw-semibold d-block">Trạng thái (Status)</label>
                                <div class="d-flex align-items-center mt-2">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="editCategoryStatus" id="editStatusActive" value="true" style="cursor: pointer;">
                                        <label class="form-check-label" for="editStatusActive">Active</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="editCategoryStatus" id="editStatusInactive" value="false" style="cursor: pointer;">
                                        <label class="form-check-label" for="editStatusInactive">Inactive</label>
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

                                                              // ==========================================
                                                              // 1. XỬ LÝ FORM "THÊM DANH MỤC"
                                                              // ==========================================
                                                              const addForm = document.getElementById('addCategoryForm');
                                                              addForm.addEventListener('submit', function (event) {
                                                                  let isValid = true;
                                                                  const name = document.getElementById('categoryName');
                                                                  const image = document.getElementById('categoryImage');
                                                                  const inputs = addForm.querySelectorAll('.form-control, .form-select');

                                                                  // Xóa các cảnh báo cũ
                                                                  inputs.forEach(input => input.classList.remove('is-invalid'));

                                                                  // Kiểm tra tên danh mục
                                                                  if (name.value.trim() === '') {
                                                                      name.classList.add('is-invalid');
                                                                      isValid = false;
                                                                  }

                                                                  // Kiểm tra ảnh
                                                                  if (image.files.length === 0) {
                                                                      image.classList.add('is-invalid');
                                                                      isValid = false;
                                                                  }

                                                                  // Nếu không hợp lệ thì chặn gửi form
                                                                  if (!isValid) {
                                                                      event.preventDefault();
                                                                  }
                                                                  // Nếu hợp lệ, trình duyệt tự động submit form (không cần event.preventDefault())
                                                              });

                                                              // ==========================================
                                                              // 2. XỬ LÝ FORM "SỬA DANH MỤC" (Đổ dữ liệu vào Modal)
                                                              // ==========================================
                                                              const editCategoryButtons = document.querySelectorAll('.btn-edit-category');
                                                              const categoryImagePreview = document.getElementById('categoryImagePreview');
                                                              const editCategoryImageInput = document.getElementById('editCategoryImage');

                                                              editCategoryButtons.forEach(button => {
                                                                  button.addEventListener('click', function () {
                                                                      const tr = this.closest('tr');

                                                                      // Lấy dữ liệu từ các cột tương ứng trong bảng
                                                                      const categoryId = tr.querySelector('td:nth-child(1)').innerText.trim(); // Lấy ID
                                                                      const categoryName = tr.querySelector('td:nth-child(2)').innerText.trim();
                                                                      const statusStr = tr.querySelector('td:nth-child(3)').innerText.trim();
                                                                      const imgSrc = tr.querySelector('td:nth-child(4) img').src;

                                                                      // ĐỔ DỮ LIỆU VÀO FORM MODAL (Khắc phục lỗi For input string "")
                                                                      document.getElementById('editCategoryId').value = categoryId;
                                                                      document.getElementById('editCategoryName').value = categoryName;

                                                                      // Xử lý Checkbox Trạng Thái
                                                                      if (statusStr === 'Active' || statusStr === 'true') {
                                                                          document.getElementById('editStatusActive').checked = true;
                                                                      } else {
                                                                          document.getElementById('editStatusInactive').checked = true;
                                                                      }

                                                                      // Reset input file và hiển thị ảnh cũ
                                                                      editCategoryImageInput.value = '';
                                                                      if (imgSrc) {
                                                                          categoryImagePreview.src = imgSrc;
                                                                          categoryImagePreview.classList.remove('d-none');
                                                                      } else {
                                                                          categoryImagePreview.classList.add('d-none');
                                                                      }
                                                                  });
                                                              });

                                                              // Xử lý xem trước ảnh khi chọn ảnh mới trong Modal
                                                              editCategoryImageInput.addEventListener('change', function (event) {
                                                                  const file = event.target.files[0];
                                                                  if (file) {
                                                                      const reader = new FileReader();
                                                                      reader.onload = function (e) {
                                                                          categoryImagePreview.src = e.target.result;
                                                                          categoryImagePreview.classList.remove('d-none');
                                                                      };
                                                                      reader.readAsDataURL(file);
                                                                  }
                                                              });

                                                          });
    </script>
</body>
</html>