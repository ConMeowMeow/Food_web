<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Món Yêu Thích - Foodie</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>

        <link rel="stylesheet" href="./css/TrangChu.css">
        <link rel="stylesheet" href="./css/YeuThich.css">
    </head>

    <body class="bg-theme-color">
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="./TrangChu.jsp">
                    <img src="./img/logo.png" alt="Logo" class="nav-logo">
                </a>

                <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-expanded="false">
                    <i class="fa-solid fa-caret-down fs-2 toggle-caret"></i>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto fw-bold">
                        <li class="nav-item"><a class="nav-link" href="./TrangChu.jsp">Trang chủ</a></li>
                        <li class="nav-item"><a class="nav-link" href="./ThucDon.jsp">Thực đơn</a></li>
                        <li class="nav-item"><a class="nav-link" href="./KhuyenMai.jsp">Khuyến mãi</a></li> 
                        <li class="nav-item"><a class="nav-link" href="./LienHe.jsp">Liên hệ</a></li>
                    </ul>

                    <div class="d-flex align-items-center flex-wrap justify-content-center gap-2 mt-3 mt-lg-0 pb-3 pb-lg-0">
                        <form class="d-flex position-relative" role="search" action="#" method="GET">
                            <input class="form-control rounded-pill shadow-none pe-5 search-input" type="search" placeholder="Tìm món ăn..." aria-label="Search">
                            <button class="btn position-absolute end-0 top-50 translate-middle-y border-0 text-muted hover-primary search-btn" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </form>

                        <div class="dropdown ms-2 position-relative" id="wishlistDropdownContainer">
                            <a href="#" class="text-primary-custom fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center icon-wrap-circle" id="wishlistDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                                <i class="far fa-heart"></i> 
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger wishlist-badge custom-badge-pos">0</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 cart-dropdown-menu p-3 shadow" aria-labelledby="wishlistDropdown">
                                <div class="wishlist-empty text-center py-4">
                                    <i class="far fa-heart fs-1 text-muted mb-3 d-block"></i>
                                    <p class="text-muted mb-3">Bạn chưa có món ăn yêu thích nào!</p>
                                    <a href="#menu" class="btn btn-custom w-100 text-decoration-none">Khám phá ngay</a>
                                </div>
                                <div class="wishlist-has-items d-none"> 
                                    <h6 class="fw-bold mb-3 border-bottom pb-2">Món ăn yêu thích (<span class="wishlist-count-text">0</span>)</h6>
                                    <div class="wishlist-items-list mb-3 scrollable-list"></div>
                                    <a href="YeuThich.jsp" class="btn btn-custom w-100 text-center text-decoration-none">Xem Chi Tiết</a>
                                </div>
                            </ul>
                        </div>

                        <div class="dropdown ms-2 position-relative" id="cartDropdownContainer">
                            <%
                                boolean isLogged = true;
                                boolean hasItemsInCart = true;
                                int cartSize = hasItemsInCart ? 3 : 0; 
                            %>
                            <a href="#" class="text-dark fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center icon-wrap-circle" id="cartDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                                <i class="fas fa-shopping-cart"></i> 
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge custom-badge-pos">
                                    <%= isLogged ? cartSize : 0 %>
                                </span>
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end border-0 cart-dropdown-menu p-3 shadow" aria-labelledby="cartDropdown">
                                <% if (!isLogged) { %>
                                <div class="cart-empty-guest text-center py-4">
                                    <i class="fas fa-shopping-basket fs-1 text-muted mb-3 d-block"></i>
                                    <p class="text-muted mb-3">Giỏ hàng trống. Đăng nhập để tiếp tục!</p>
                                    <div class="d-flex gap-2 justify-content-center">
                                        <a href="DangNhap.jsp" class="btn btn-outline-custom btn-sm w-50">Đăng nhập</a>
                                        <a href="DangKi.jsp" class="btn btn-custom btn-sm w-50 text-decoration-none">Đăng ký</a>
                                    </div>
                                </div>
                                <% } else { %>
                                <div class="cart-empty-user text-center py-4">
                                    <i class="fas fa-shopping-basket fs-1 text-muted mb-3 d-block"></i>
                                    <p class="text-muted mb-3">Giỏ hàng của bạn đang trống!</p>
                                    <a href="#menu" class="btn btn-custom w-100 text-decoration-none">Đặt món ngay</a>
                                </div>
                                <div class="cart-has-items d-none"> 
                                    <h6 class="fw-bold mb-3 border-bottom pb-2">Giỏ hàng của bạn</h6>
                                    <div class="cart-items-list mb-3 scrollable-list"></div>
                                    <div class="d-flex justify-content-between border-top pt-2 mb-3 fw-bold">
                                        <span>Tổng cộng:</span>
                                        <span class="text-primary-custom total-price-display">0đ</span>
                                    </div>
                                    <a href="Cart.jsp" class="btn btn-custom w-100 text-center text-decoration-none">Xem Chi Tiết</a>
                                </div>
                                <% } %>
                            </ul>
                        </div>

                        <div class="dropdown ms-2 position-relative">
                            <% if (!isLogged) { %>
                            <a href="#" class="text-dark fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center icon-wrap-circle" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle"></i>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-center border-0 shadow profile-dropdown-menu" aria-labelledby="accountDropdown">
                                <li><a class="dropdown-item py-2 fw-semibold" href="./DangNhap.jsp"><i class="fas fa-sign-in-alt me-2 text-muted"></i> Đăng nhập</a></li>
                                <li><a class="dropdown-item py-2 fw-semibold" href="./DangKi.jsp"><i class="fas fa-user-plus me-2 text-muted"></i> Đăng ký</a></li>
                            </ul>
                            <% } else { %>
                            <a href="#" class="text-dark text-decoration-none d-flex align-items-center justify-content-center border border-2 border-primary rounded-circle icon-wrap-profile" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="https://ui-avatars.com/api/?name=Ngo+Phuong+Anh&background=ea6a47&color=fff" alt="Avatar" class="rounded-circle w-100 h-100 object-fit-cover">
                            </a>
                            <ul class="dropdown-menu dropdown-menu-center border-0 shadow-lg profile-dropdown" aria-labelledby="accountDropdown">
                                <div class="profile-header mx-2 my-1 p-2 rounded d-flex align-items-center">
                                    <img src="https://ui-avatars.com/api/?name=Ngo+Phuong+Anh&background=ea6a47&color=fff" alt="Avatar" class="rounded-circle icon-wrap-circle">
                                    <div class="ms-3">
                                        <h6 class="mb-0 fw-bold fs-6">Ngô Phương Anh</h6>
                                    </div>
                                </div>
                                <div class="px-2 mb-2">
                                    <a href="./Profile.jsp" class="btn w-100 fw-bold text-primary-custom bg-light border-0">Xem tất cả trang cá nhân</a>
                                </div>
                                <li><hr class="dropdown-divider mb-2"></li>
                                <li class="px-2">
                                    <a class="dropdown-item profile-item d-flex align-items-center" href="#">
                                        <div class="icon-wrap"><i class="fas fa-clipboard-list"></i></div>
                                        <span class="fw-semibold">Đơn hàng của tôi</span>
                                    </a>
                                </li>
                                <li class="px-2">
                                    <a class="dropdown-item profile-item d-flex align-items-center" href="#">
                                        <div class="icon-wrap"><i class="fas fa-sign-out-alt"></i></div>
                                        <span class="fw-semibold">Đăng xuất</span>
                                    </a>
                                </li>
                            </ul>
                            <% } %>
                        </div>

                        <a class="text-dark fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center ms-2 icon-wrap-circle" data-bs-toggle="offcanvas" href="#offcanvasLeftMenu" role="button" aria-controls="offcanvasLeftMenu">
                            <i class="fa-solid fa-bars"></i>
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="offcanvas offcanvas-start border-0 shadow" tabindex="-1" id="offcanvasLeftMenu" aria-labelledby="offcanvasLeftMenuLabel" style="width: 320px;">
            <div class="offcanvas-header border-bottom position-relative d-flex justify-content-end align-items-center" style="height: 75px;">
                <div class="d-flex justify-content-center mt-auto position-absolute start-50 translate-middle d-flex gap-2">
                    <div class="menu-deco-line"></div>
                    <div class="menu-deco-line"></div>
                    <div class="menu-deco-line"></div>
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
                        <li><a href="./Policy.jsp" class="side-menu-link">Chính Sách Hoạt Động <i class="fas fa-chevron-right"></i></a></li>
                        <li><a href="./Policy.jsp" class="side-menu-link">Chính Sách & Quy Định <i class="fas fa-chevron-right"></i></a></li>
                        <li><a href="./Policy.jsp" class="side-menu-link">Chính Sách Bảo Mật Thông Tin <i class="fas fa-chevron-right"></i></a></li>
                    </ul>
                </div>

                <hr class="border-secondary opacity-10 mx-3 my-3">

                <div class="d-flex justify-content-center mt-auto gap-2">
                    <div class="menu-deco-line"></div>
                    <div class="menu-deco-line"></div>
                    <div class="menu-deco-line"></div>
                </div>
            </div>
        </div>

        <section class="wishlist-page position-relative wishlist-page-section">
            <div class="container mb-5">
                <div class="d-flex justify-content-between align-items-end mb-4 border-bottom pb-3">
                    <div>
                        <h2 class="fw-bold mb-0 text-uppercase">MÓN ĂN <span class="text-primary-custom">YÊU THÍCH</span></h2>
                        <p class="text-muted mt-2 mb-0">Lưu lại những hương vị bạn yêu thích nhất để dễ dàng đặt hàng bất cứ lúc nào.</p>
                    </div>
                </div>

                <%
                    // MOCK DATA: Đổi thành false để xem giao diện Trống
                    boolean hasFavorites = true; 
                %>

                <% if (hasFavorites) { %>
                <div class="row g-4">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="food-card position-relative h-100 border border-danger border-opacity-25 bg-white shadow-sm"> 
                            <span class="badge bg-danger position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">-15%</span>
                            <button class="btn btn-wishlist active position-absolute top-0 end-0 m-3 p-2 border-0 bg-transparent shadow-none">
                                <i class="fas fa-heart fs-4 text-danger"></i>
                            </button>
                            <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" alt="Beef Burger" class="food-img rounded-circle shadow-sm">
                            <h4 class="fw-bold fs-5 mb-1 mt-3">
                                <a href="ChiTietMonAn.jsp" class="text-dark text-decoration-none stretched-link food-title">Beef Burger Classic</a>
                            </h4>
                            <p class="text-muted small mb-3">Thịt bò, Phô mai, Rau thơm</p>
                            <div class="d-flex justify-content-between align-items-end">
                                <span class="price text-start">
                                    <del class="text-muted fs-6 me-2">150.000đ</del><br>
                                    <span class="text-danger fw-bold">125.000đ</span>
                                </span>
                                <button class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2">
                                    Thêm <i class="fas fa-cart-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="food-card position-relative h-100 border border-danger border-opacity-25 bg-white shadow-sm"> 
                            <span class="badge bg-danger position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">HOT</span>
                            <button class="btn btn-wishlist active position-absolute top-0 end-0 m-3 p-2 border-0 bg-transparent shadow-none">
                                <i class="fas fa-heart fs-4 text-danger"></i>
                            </button>
                            <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" alt="Pizza" class="food-img rounded-circle shadow-sm">
                            <h4 class="fw-bold fs-5 mb-1 mt-3">
                                <a href="ChiTietMonAn.jsp" class="text-dark text-decoration-none stretched-link food-title">Tasty Buzzed Pizza</a>
                            </h4>
                            <p class="text-muted small mb-3">Đế mỏng, ngập ngụa phô mai</p>
                            <div class="d-flex justify-content-between align-items-end">
                                <span class="price text-start">
                                    <del class="text-muted fs-6 me-2 price-spacer">&nbsp;</del><br>
                                    <span class="text-danger fw-bold">99.000đ</span>
                                </span>
                                <button class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2">
                                    Thêm <i class="fas fa-cart-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="food-card position-relative h-100 border border-danger border-opacity-25 bg-white shadow-sm"> 
                            <button class="btn btn-wishlist active position-absolute top-0 end-0 m-3 p-2 border-0 bg-transparent shadow-none">
                                <i class="fas fa-heart fs-4 text-danger"></i>
                            </button>
                            <img src="https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=300&q=80" alt="Burger Gà" class="food-img rounded-circle shadow-sm">
                            <h4 class="fw-bold fs-5 mb-1 mt-3">
                                <a href="ChiTietMonAn.jsp" class="text-dark text-decoration-none stretched-link food-title">Burger Gà Giòn</a>
                            </h4>
                            <p class="text-muted small mb-3">Gà rán xù, sốt Mayo béo ngậy</p>
                            <div class="d-flex justify-content-between align-items-end">
                                <span class="price text-start">
                                    <del class="text-muted fs-6 me-2 price-spacer">&nbsp;</del><br>
                                    <span class="text-danger fw-bold">65.000đ</span>
                                </span>
                                <button class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2">
                                    Thêm <i class="fas fa-cart-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="food-card position-relative h-100 border border-danger border-opacity-25 bg-white shadow-sm"> 
                            <span class="badge bg-success position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">NEW</span>
                            <button class="btn btn-wishlist active position-absolute top-0 end-0 m-3 p-2 border-0 bg-transparent shadow-none">
                                <i class="fas fa-heart fs-4 text-danger"></i>
                            </button>
                            <img src="https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=300&q=80" alt="Gà rán" class="food-img rounded-circle shadow-sm">
                            <h4 class="fw-bold fs-5 mb-1 mt-3">
                                <a href="ChiTietMonAn.jsp" class="text-dark text-decoration-none stretched-link food-title">Gà Rán (1 Miếng)</a>
                            </h4>
                            <p class="text-muted small mb-3">Lớp vỏ giòn tan, thịt mọng nước</p>
                            <div class="d-flex justify-content-between align-items-end">
                                <span class="price text-start">
                                    <del class="text-muted fs-6 me-2 price-spacer">&nbsp;</del><br>
                                    <span class="text-danger fw-bold">36.000đ</span>
                                </span>
                                <button class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2">
                                    Thêm <i class="fas fa-cart-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="text-center text-muted py-5 d-flex flex-column align-items-center justify-content-center empty-state-card">
                    <i class="fas fa-heart-broken mb-4 empty-state-icon"></i>
                    <h4 class="fw-bold text-dark mb-3">Chưa có món ăn yêu thích nào</h4>
                    <p class="text-muted mb-4 empty-state-text">Hãy dạo quanh thực đơn và thả tim cho những món bạn muốn thưởng thức nhé. Chúng sẽ được lưu lại tại đây!</p>
                    <a href="ThucDon.jsp" class="btn btn-custom rounded-pill px-5 py-3 fw-bold fs-6">Khám Phá Thực Đơn <i class="fas fa-arrow-right ms-2"></i></a>
                </div>
                <% } %>
            </div>
        </section>

        <footer class="footer mt-auto">
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

        <div class="toast-container position-fixed top-0 end-0 p-3 mt-5 pt-4 toast-custom-pos">
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
        <script src="./js/index.js"></script>
    </body>
</html>