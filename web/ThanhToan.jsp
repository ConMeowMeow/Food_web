<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán - Foodie</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>

        <link rel="stylesheet" href="./css/TrangChu.css">
        <link rel="stylesheet" href="./css/ThanhToan.css">
    </head>

    <body class="checkout-page-bg">
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
                            <a href="#" class="text-dark fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center icon-wrap-circle" id="wishlistDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                                <i class="far fa-heart"></i> 
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger wishlist-badge custom-badge-pos">0</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 cart-dropdown-menu p-3 shadow" aria-labelledby="wishlistDropdown">
                                <div class="wishlist-empty text-center py-4">
                                    <i class="far fa-heart fs-1 text-muted mb-3 d-block"></i>
                                    <p class="text-muted mb-0">Bạn chưa có món ăn yêu thích nào!</p>
                                </div>
                                <div class="wishlist-has-items d-none"> 
                                    <h6 class="fw-bold mb-3 border-bottom pb-2">Món ăn yêu thích (<span class="wishlist-count-text">0</span>)</h6>
                                    <div class="wishlist-items-list mb-3 scrollable-list"></div>
                                    <a href="YeuThich.jsp" class="btn btn-custom w-100 text-center text-decoration-none">Xem chi tiết</a>
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
                                    <a href="ThanhToan.jsp" class="btn btn-custom w-100 text-center text-decoration-none">Thanh toán ngay</a>
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
                        <li><a href="#" class="side-menu-link">Chính Sách Hoạt Động <i class="fas fa-chevron-right"></i></a></li>
                        <li><a href="#" class="side-menu-link">Chính Sách & Quy Định <i class="fas fa-chevron-right"></i></a></li>
                        <li><a href="#" class="side-menu-link">Chính Sách Bảo Mật Thông Tin <i class="fas fa-chevron-right"></i></a></li>
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

        <section class="hero-section" id="home">
            <div class="hero-banner-slider">
                <div class="position-relative">
                    <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80" alt="Banner Burger" class="hero-banner-img">
                    <div class="hero-overlay d-flex align-items-center">
                        <div class="container text-center text-white">
                            <p class="section-subtitle text-warning mb-2 fs-5">Nhanh chóng & Ngon miệng</p>
                            <h1 class="display-3 fw-bold mb-4">Super Delicious <span class="text-primary-custom">Food!</span></h1>
                            <p class="lead mb-4 mx-auto hero-subtitle">Thưởng thức những món ăn nhanh nóng hổi, giòn rụm với hương vị bùng nổ. Giao hàng tận nơi trong vòng 30 phút.</p>
                            <a href="./ThucDon.jsp" class="btn btn-custom btn-lg rounded-pill px-5">Đi tới Thực đơn</a>
                        </div>
                    </div>
                </div>

                <div class="position-relative">
                    <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80" alt="Banner Pizza" class="hero-banner-img">
                    <div class="hero-overlay d-flex align-items-center">
                        <div class="container text-center text-white">
                            <p class="section-subtitle text-warning mb-2 fs-5">Hương vị Ý đích thực</p>
                            <h1 class="display-3 fw-bold mb-4">The Best <span class="text-primary-custom">Pizza!</span></h1>
                            <p class="lead mb-4 mx-auto hero-subtitle">Đế bánh giòn rụm, phô mai ngập tràn hòa quyện cùng các loại topping tươi ngon nhất. Đặt hàng ngay hôm nay!</p>
                            <a href="./ThucDon.jsp" class="btn btn-custom btn-lg rounded-pill px-5">Khám phá ngay</a>
                        </div>
                    </div>
                </div>

                <div class="position-relative">
                    <img src="https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80" alt="Banner Fresh" class="hero-banner-img">
                    <div class="hero-overlay d-flex align-items-center">
                        <div class="container text-center text-white">
                            <p class="section-subtitle text-warning mb-2 fs-5">Tươi ngon mỗi ngày</p>
                            <h1 class="display-3 fw-bold mb-4">Healthy & <span class="text-primary-custom">Fresh!</span></h1>
                            <p class="lead mb-4 mx-auto hero-subtitle">Nguyên liệu được chọn lọc kỹ càng, đảm bảo an toàn vệ sinh thực phẩm cho bạn và gia đình.</p>
                            <a href="./ThucDon.jsp" class="btn btn-custom btn-lg rounded-pill px-5">Xem thực đơn</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="checkout-section">
            <div class="container">

                <form id="checkoutForm" action="./OrderSuccess.jsp" method="POST" novalidate>
                    <div class="checkout-card p-0 overflow-hidden">
                        <div class="address-border"></div>
                        <div class="px-4 pb-4">
                            <div class="section-title fw-bold">
                                <i class="fas fa-map-marker-alt me-2 fs-5"></i> Địa Chỉ Nhận Đơn
                            </div>

                            <div class="row g-3 px-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-muted">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullname" placeholder="Nhập họ và tên" required>
                                    <div class="invalid-feedback">Vui lòng nhập họ và tên.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-muted">Số điện thoại <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="phone" placeholder="Nhập số điện thoại" required>
                                    <div class="invalid-feedback">Vui lòng nhập số điện thoại hợp lệ.</div>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small fw-semibold text-muted">Địa chỉ cụ thể <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="address" placeholder="Ví dụ: Tòa nhà, Tên đường, Phường/Xã..." required>
                                    <div class="invalid-feedback">Vui lòng nhập địa chỉ.</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="checkout-card p-0">
                        <div class="cart-header-row d-none d-md-flex row m-0 align-items-center bg-light">
                            <div class="col-6 fw-bold text-dark fs-6">Sản phẩm</div>
                            <div class="col-2 text-center">Đơn giá</div>
                            <div class="col-2 text-center">Số lượng</div>
                            <div class="col-2 text-end">Thành tiền</div>
                        </div>

                        <div class="cart-item-row row m-0 align-items-center">
                            <div class="col-md-6 d-flex align-items-center mb-3 mb-md-0">
                                <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=150&q=80" alt="Burger" class="item-img rounded">
                                <div class="ms-3">
                                    <span class="fw-medium text-dark d-block text-truncate item-name-truncate">Beef Burger Classic</span>
                                    <span class="text-muted small">Phân loại: Kèm Phô Mai, Nước</span>
                                </div>
                            </div>
                            <div class="col-4 col-md-2 text-md-center text-muted">125.000đ</div>
                            <div class="col-4 col-md-2 text-center text-muted">1</div>
                            <div class="col-4 col-md-2 text-end text-dark fw-medium">125.000đ</div>
                        </div>

                        <div class="cart-item-row row m-0 align-items-center">
                            <div class="col-md-6 d-flex align-items-center mb-3 mb-md-0">
                                <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?w=150&q=80" alt="Pizza" class="item-img rounded">
                                <div class="ms-3">
                                    <span class="fw-medium text-dark d-block text-truncate item-name-truncate">Tasty Buzzed Pizza</span>
                                    <span class="text-muted small">Phân loại: Đế mỏng</span>
                                </div>
                            </div>
                            <div class="col-4 col-md-2 text-md-center text-muted">99.000đ</div>
                            <div class="col-4 col-md-2 text-center text-muted">2</div>
                            <div class="col-4 col-md-2 text-end text-dark fw-medium">198.000đ</div>
                        </div>

                        <div class="border-top px-4 py-3 bg-light d-flex flex-wrap align-items-center">
                            <div class="col-md-5 d-flex align-items-center mb-3 mb-md-0">
                                <span class="text-nowrap me-3 fw-medium">Lời nhắn:</span>
                                <input type="text" class="form-control" placeholder="Lưu ý cho quán...">
                            </div>
                            <div class="col-md-7 d-flex justify-content-md-end align-items-center text-muted small">
                                <i class="fas fa-truck text-success me-2"></i> Đơn vị vận chuyển: <span class="text-dark fw-medium ms-1">Giao Hỏa Tốc</span>
                                <span class="ms-3 text-dark fw-medium">15.000đ</span>
                            </div>
                        </div>
                    </div>

                    <div class="checkout-card">
                        <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                            <h5 class="fw-medium text-dark mb-0 me-4">Phương thức thanh toán</h5>
                            <div class="d-flex gap-3 flex-wrap">
                                <div>
                                    <input type="radio" name="paymentMethod" id="payCOD" class="d-none payment-method-input" checked>
                                    <label class="payment-method-box mb-0 text-center fw-medium" for="payCOD">
                                        Thanh toán khi nhận đơn (COD)
                                    </label>
                                </div>
                                <div>
                                    <input type="radio" name="paymentMethod" id="payTransfer" class="d-none payment-method-input">
                                    <label class="payment-method-box mb-0 text-center fw-medium" for="payTransfer">
                                        Chuyển khoản ngân hàng
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="row align-items-stretch mb-2">
                            <div class="col-lg-7 mb-4 mb-lg-0 pe-lg-4">
                                <div class="payment-details-container h-100">
                                    <div id="codDetails" class="bg-light p-4 rounded-1 border payment-detail-box h-100 d-flex align-items-center justify-content-center text-center">
                                        <p class="mb-0 text-muted small text-nowrap">
                                            <i class="fas fa-info-circle me-2 text-primary-custom"></i>Phí thu hộ: ₫0 VNĐ. Thanh toán bằng tiền mặt khi nhận hàng.
                                        </p>
                                    </div>

                                    <div id="transferDetails" class="bg-light p-4 rounded-1 border payment-detail-box d-none h-100">
                                        <div class="d-flex flex-column align-items-center justify-content-center h-100">
                                            <div class="text-center w-100 pb-3 border-bottom border-dashed">
                                                <p class="fw-bold mb-2 text-dark">Quét mã QR để thanh toán</p>
                                                <img src="https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg" alt="Mock QR Code" class="img-fluid mb-2 qr-code-img qr-code-img-sm">
                                                <div class="d-flex justify-content-center gap-2 bank-logos mt-2">
                                                    <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-MoMo-Square.png" alt="MoMo">
                                                    <img src="https://rubicmarketing.com/wp-content/uploads/2022/11/y-nghia-logo-mb-bank-2.jpg" alt="MB Bank">
                                                    <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-VNPAY-QR-1.png" alt="VNPay">
                                                    <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-ZaloPay-Square.png" alt="ZaloPay">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-5 custom-border-start ps-lg-4">
                                <div class="d-flex flex-column justify-content-between h-100">
                                    <div>
                                        <div class="d-flex justify-content-between mb-2 text-muted small">
                                            <span>Tổng tiền hàng</span>
                                            <span>323.000đ</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2 text-muted small">
                                            <span>Phí vận chuyển</span>
                                            <span>15.000đ</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2 text-muted small">
                                            <span>Voucher giảm giá</span>
                                            <span class="text-primary-custom">-20.000đ</span>
                                        </div>
                                    </div>

                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center mb-3 pt-3 border-top">
                                            <span class="text-muted fw-medium">Tổng thanh toán</span>
                                            <span class="fw-bold text-primary-custom total-price-final">318.000đ</span>
                                        </div>
                                        <div class="d-flex flex-column align-items-end mt-2">
                                            <span class="small text-muted mb-3 text-end">Bằng cách nhấp vào "Đặt ngay", bạn đồng ý với <a href="./Policy.jsp" class="text-primary-custom text-decoration-none">Điều khoản Fast Food</a></span>
                                            <button type="submit" class="btn btn-order fw-bold shadow-sm w-100">Đặt ngay</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
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

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.getElementById('checkoutForm');

                form.addEventListener('submit', function (event) {
                    event.preventDefault();

                    let isValid = true;
                    const fullname = document.getElementById('fullname');
                    const phone = document.getElementById('phone');
                    const address = document.getElementById('address');
                    const phoneRegex = /^(0|\+84)[3|5|7|8|9][0-9]{8}$/;

                    const inputs = form.querySelectorAll('.form-control');
                    inputs.forEach(input => input.classList.remove('is-invalid'));

                    if (fullname.value.trim() === '') {
                        fullname.classList.add('is-invalid');
                        isValid = false;
                    }

                    if (phone.value.trim() === '' || !phoneRegex.test(phone.value.trim())) {
                        phone.classList.add('is-invalid');
                        isValid = false;
                    }

                    if (address.value.trim() === '') {
                        address.classList.add('is-invalid');
                        isValid = false;
                    }

                    if (isValid) {
                        window.location.href = "OrderSuccess.jsp";
                    }
                });

                const paymentRadios = document.querySelectorAll('.payment-method-input');
                const codDetails = document.getElementById('codDetails');
                const transferDetails = document.getElementById('transferDetails');

                paymentRadios.forEach(radio => {
                    radio.addEventListener('change', function () {
                        if (this.id === 'payCOD') {
                            codDetails.classList.remove('d-none');
                            transferDetails.classList.add('d-none');
                        } else if (this.id === 'payTransfer') {
                            codDetails.classList.add('d-none');
                            transferDetails.classList.remove('d-none');
                        }
                    });
                });
            });
        </script>
    </body>
</html>