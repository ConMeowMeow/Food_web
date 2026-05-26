<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.sql.Connection, java.sql.SQLException" %>
<%@ page import="Model.*, Controller.*" %>
<%
    // Khởi tạo danh sách trống mặc định tránh lỗi NullPointerException khi render UI
    List<Product> productList = new ArrayList<>();
    List<CartItem> cartList = new ArrayList<>();
    List<Product> wishlist = new ArrayList<>();
    List<Integer> favIds = new ArrayList<>();
    double totalCartPrice = 0;
    int cartSize = 0;

    // Xử lý User Session
    User user = (User) session.getAttribute("userAccount");
    boolean isLogged = (user != null);
    request.setAttribute("isLogged", isLogged);

    Connection conn = null;
    try {
        conn = Connect.getConnection();
        
        // 1. Lấy toàn bộ sản phẩm
        ProductDAO pdao = new ProductDAO(conn);
        productList = pdao.getAllProducts();
        request.setAttribute("products", productList);

        if (isLogged) {
            request.setAttribute("displayName", user.getFullName());
            request.setAttribute("avatar", user.getAvatarUrl());

            // 2. Dữ liệu Giỏ Hàng
            CartDAO cdao = new CartDAO();
            cartList = cdao.getCartItems(user.getId());
            cartSize = cartList.size();
            for (CartItem item : cartList) {
                totalCartPrice += item.getPrice() * item.getQuantity();
            }

            // 3. Dữ liệu Yêu Thích
            FavouriteDAO fdao = new FavouriteDAO(conn);
            favIds = fdao.getFavouriteProductIds(user.getId());
            for(Product p : productList) {
                if(favIds.contains(p.getProductId())) {
                    wishlist.add(p);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Đảm bảo đóng kết nối thủ công ngay khi hoàn thành tải trang chủ
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    request.setAttribute("cartList", cartList);
    request.setAttribute("wishlist", wishlist);
    request.setAttribute("favIds", favIds); // Gửi danh sách ID đã thích lên giao diện hiển thị
    request.setAttribute("totalCartPrice", totalCartPrice);
%>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Chủ</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" />
        <link rel="stylesheet" href="./css/TrangChu.css">
    </head>

    <body>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="./">
                    <img src="./img/logo.png" alt="Logo" class="nav-logo">
                </a>

                <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-expanded="false">
                    <i class="fa-solid fa-caret-down fs-2 toggle-caret"></i>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto fw-bold">
                        <li class="nav-item"><a class="nav-link active" href="./TrangChu">Trang chủ</a></li>
                        <li class="nav-item"><a class="nav-link" href="./ThucDon">Thực đơn</a></li>
                        <li class="nav-item"><a class="nav-link" href="./KhuyenMai">Khuyến mãi</a></li>
                        <li class="nav-item"><a class="nav-link" href="./LienHe">Liên hệ</a></li>
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
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger wishlist-badge custom-badge-pos">
                                    ${isLogged and not empty wishlist ? fn:length(wishlist) : 0}
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 cart-dropdown-menu p-3 shadow" aria-labelledby="wishlistDropdown" style="min-width: 320px;">
                                <li>
                                    <c:choose>
                                        <c:when test="${not isLogged or empty wishlist}">
                                            <div class="wishlist-empty text-center py-3">
                                                <i class="far fa-heart fs-1 text-muted mb-3 d-block"></i>
                                                <p class="text-muted mb-3">${not isLogged ? 'Đăng nhập để xem mục yêu thích!' : 'Chưa có món ăn yêu thích!'}</p>
                                                <a href="${not isLogged ? 'DangNhap' : 'ThucDon'}" class="btn btn-custom w-100">${not isLogged ? 'Đăng nhập' : 'Khám phá ngay'}</a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="wishlist-has-items">
                                                <h6 class="fw-bold mb-3 border-bottom pb-2">Món yêu thích (${fn:length(wishlist)})</h6>
                                                <div class="wishlist-items-list mb-3 scrollable-list" style="max-height: 250px; overflow-y: auto;">
                                                    <c:forEach var="w" items="${wishlist}">
                                                        <div class="d-flex align-items-center mb-3">
                                                            <img src="${not empty w.imageUrl ? pageContext.request.contextPath.concat('/').concat(w.imageUrl) : '...'}" class="rounded" style="width: 50px; height: 50px; object-fit: cover;">
                                                            <div class="ms-3 flex-grow-1">
                                                                <h6 class="mb-1 text-truncate" style="max-width: 180px;">${w.name}</h6>
                                                                <span class="text-danger fw-bold"><fmt:formatNumber value="${w.price - w.discount}" pattern="#,###"/>đ</span>
                                                            </div>

                                                            <a href="RemoveFromFavourite?productId=${w.productId}" class="text-danger ms-2" title="Bỏ yêu thích">
                                                                <i class="fas fa-trash"></i>
                                                            </a>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <a href="YeuThich" class="btn btn-custom w-100 text-center">Xem Chi Tiết</a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                        </div>

                        <div class="dropdown ms-2 position-relative" id="cartDropdownContainer">
                            <a href="AddToCart" class="text-dark fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center icon-wrap-circle" id="cartDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge custom-badge-pos">
                                    ${isLogged ? fn:length(cartList) : 0}
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 cart-dropdown-menu p-3 shadow" aria-labelledby="cartDropdown" style="min-width: 320px;">
                                <li>
                                    <c:choose>
                                        <c:when test="${not isLogged}">
                                            <div class="cart-empty-guest text-center py-3">
                                                <i class="fas fa-shopping-basket fs-1 text-muted mb-3 d-block"></i>
                                                <p class="text-muted mb-3">Giỏ hàng trống. Đăng nhập để tiếp tục!</p>
                                                <div class="d-flex gap-2 justify-content-center">
                                                    <a href="DangNhap" class="btn btn-outline-custom btn-sm w-50">Đăng nhập</a>
                                                    <a href="DangKy" class="btn btn-custom btn-sm w-50">Đăng ký</a>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:when test="${empty cartList}">
                                            <div class="cart-empty-user text-center py-3">
                                                <i class="fas fa-shopping-basket fs-1 text-muted mb-3 d-block"></i>
                                                <p class="text-muted mb-3">Giỏ hàng của bạn đang trống!</p>
                                                <a href="#menu" class="btn btn-custom w-100">Đặt món ngay</a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="cart-has-items">
                                                <h6 class="fw-bold mb-3 border-bottom pb-2">Giỏ hàng của bạn</h6>
                                                <div class="cart-items-list mb-3 scrollable-list" style="max-height: 250px; overflow-y: auto;">
                                                    <c:forEach var="item" items="${cartList}">
                                                        <div class="d-flex align-items-center mb-3">

                                                            <img src="${not empty item.imageUrl ? pageContext.request.contextPath.concat('/').concat(item.imageUrl) : 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd'}" 
                                                                 class="rounded" style="width: 50px; height: 50px; object-fit: cover;" alt="Food">

                                                            <div class="ms-3 flex-grow-1">
                                                                <h6 class="mb-1 text-truncate" style="max-width: 170px;">${item.productName}</h6>
                                                                <span class="text-muted small">
                                                                    ${item.quantity} x <fmt:formatNumber value="${item.price}" pattern="#,###"/>đ
                                                                </span>
                                                            </div>

                                                            <a href="RemoveFromCart?productId=${item.productId}" class="text-danger ms-2" title="Xóa món này">
                                                                <i class="fas fa-trash fs-5"></i>
                                                            </a>

                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="d-flex justify-content-between border-top pt-2 mb-3 fw-bold">
                                                    <span>Tổng cộng:</span>
                                                    <span class="text-primary-custom"><fmt:formatNumber value="${totalCartPrice}" pattern="#,###"/>đ</span>
                                                </div>
                                                <a href="Cart" class="btn btn-custom w-100 text-center">Xem Chi Tiết</a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                        </div>

                        <div class="dropdown ms-2 position-relative">
                            <c:choose>
                                <c:when test="${not isLogged}">
                                    <a href="#" class="text-dark fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center icon-wrap-circle" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-user-circle"></i>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-center border-0 shadow profile-dropdown-menu" aria-labelledby="accountDropdown">
                                        <li><a class="dropdown-item py-2 fw-semibold" href="./DangNhap"><i class="fas fa-sign-in-alt me-2 text-muted"></i> Đăng nhập</a></li>
                                        <li><a class="dropdown-item py-2 fw-semibold" href="./DangKy"><i class="fas fa-user-plus me-2 text-muted"></i> Đăng ký</a></li>
                                    </ul>
                                </c:when>

                                <c:otherwise>
                                    <a href="#" class="text-dark text-decoration-none d-flex align-items-center justify-content-center border border-2 border-primary rounded-circle icon-wrap-profile" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <img src="${not empty avatar ? avatar : './img/default.png'}" 
                                             alt="Avatar" class="rounded-circle w-100 h-100" style="object-fit: cover;">
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-center border-0 shadow-lg profile-dropdown" aria-labelledby="accountDropdown">
                                        <div class="profile-header mx-2 my-1 p-2 rounded d-flex align-items-center">
                                            <img src="${not empty avatar ? avatar : './img/default.png'}" 
                                                 alt="Avatar" class="rounded-circle icon-wrap-circle" style="object-fit: cover;">
                                            <div class="ms-3">
                                                <h6 class="mb-0 fw-bold fs-6">${displayName}</h6>
                                            </div>
                                        </div>
                                        <div class="px-2 mb-2">
                                            <a href="./Profile" class="btn w-100 fw-bold text-primary-custom bg-light border-0">Xem trang cá nhân</a>
                                        </div>
                                        <li><hr class="dropdown-divider mb-2"></li>
                                        <li class="px-2">
                                            <a class="dropdown-item profile-item d-flex align-items-center" href="#">
                                                <div class="icon-wrap"><i class="fas fa-clipboard-list"></i></div>
                                                <span class="fw-semibold">Đơn hàng của tôi</span>
                                            </a>
                                        </li>
                                        <li class="px-2">
                                            <a class="dropdown-item profile-item d-flex align-items-center text-danger" href="DangXuat">
                                                <div class="icon-wrap"><i class="fas fa-sign-out-alt"></i></div>
                                                <span class="fw-semibold">Đăng xuất</span>
                                            </a>
                                        </li>
                                    </ul>
                                </c:otherwise>
                            </c:choose>
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
                <div class="d-flex justify-content-center mt-auto position-absolute start-50 translate-middle gap-2">
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
                        <li><a href="./Policy" class="side-menu-link">Chính Sách Hoạt Động <i class="fas fa-chevron-right"></i></a></li>
                        <li><a href="./Policy" class="side-menu-link">Chính Sách & Quy Định <i class="fas fa-chevron-right"></i></a></li>
                        <li><a href="./Policy" class="side-menu-link">Chính Sách Bảo Mật Thông Tin <i class="fas fa-chevron-right"></i></a></li>
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
                            <a href="./ThucDon" class="btn btn-custom btn-lg rounded-pill px-5">Đi tới Thực đơn</a>
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
                            <a href="./ThucDon" class="btn btn-custom btn-lg rounded-pill px-5">Khám phá ngay</a>
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
                            <a href="./ThucDon" class="btn btn-custom btn-lg rounded-pill px-5">Xem thực đơn</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="menu-section" id="menu">
            <div class="container">
                <div class="text-center mb-4">
                    <p class="section-subtitle">Thực Đơn Của Chúng Tôi</p>
                    <h2 class="display-5 fw-bold">Các Món Ăn <span class="text-primary-custom">Best Seller</span></h2>
                </div>

                <ul class="nav nav-pills justify-content-center mb-5 menu-tabs" id="menu-tab" role="tablist">
                    <li class="nav-item" role="presentation"><button class="nav-link active" type="button" role="tab">Tất cả</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" type="button" role="tab">Burger</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" type="button" role="tab">Pizza</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" type="button" role="tab">Đồ uống</button></li>
                </ul>

                <div class="tab-pane fade show active" id="pills-all" role="tabpanel">
                    <div class="position-relative px-2 px-md-4">
                        <button class="btn btn-custom-arrow menu-prev arrow-left"><i class="fas fa-chevron-left"></i></button>
                        <div class="menu-slider mx-n2">
                            <c:forEach var="p" items="${products}" end="5">
                                <div class="px-3 py-4">
                                    <div class="food-card position-relative h-100 border border-danger border-opacity-25">
                                        <c:if test="${p.discount > 0}">
                                            <span class="badge bg-danger position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">Giảm giá</span>
                                        </c:if>

                                        <form action="AddToFavourite" method="POST" class="position-absolute top-0 end-0 m-3" style="z-index: 5;">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <button type="submit" class="btn btn-wishlist p-2 border-0 bg-transparent shadow-none">
                                                <i class="${isLogged && favIds.contains(p.productId) ? 'fas fa-heart text-danger' : 'far fa-heart text-secondary'} fs-4"></i>
                                            </button>
                                        </form>

                                        <img src="${not empty p.imageUrl ? p.imageUrl : 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300'}" alt="${p.name}" class="food-img rounded-circle shadow-sm">

                                        <h4 class="fw-bold fs-5 mb-1">
                                            <a href="ChiTietMonAn?id=${p.productId}" class="text-dark text-decoration-none stretched-link food-title">${p.name}</a>
                                        </h4>
                                        <p class="text-muted small mb-3 text-truncate">${not empty p.description ? p.description : 'Đang cập nhật...'}</p>

                                        <div class="d-flex justify-content-between align-items-end">
                                            <span class="price text-start">
                                            </span>

                                            <form action="AddToCart" method="POST" style="display:inline;">
                                                <input type="hidden" name="productId" value="${p.productId}">
                                                <button type="submit" class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2">
                                                    Thêm <i class="fas fa-cart-plus"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <button class="btn btn-custom-arrow menu-next arrow-right"><i class="fas fa-chevron-right"></i></button>
                    </div>
                </div>
                <div class="text-center pt-3">
                    <a href="ThucDon" class="btn btn-outline-custom px-4 py-2 rounded-pill fw-bold fs-6">Xem Tất Cả<i class="fas fa-arrow-right ms-2"></i></a>
                </div>
            </div>
        </section>

        <section class="about-promo-section py-5" id="about">
            <div class="container">
                <div class="row align-items-center mb-5">
                    <div class="col-lg-6 text-center mb-5 mb-lg-0 px-lg-4">
                        <img src="https://images.unsplash.com/photo-1550547660-d9450f859349?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" alt="Về Chúng Tôi" class="about-img shadow-lg">
                    </div>
                    <div class="col-lg-6 ps-lg-5">
                        <p class="section-subtitle mb-2">Về Chúng Tôi</p>
                        <h2 class="display-5 fw-bold mb-4">Khám Phá Hương Vị Burger & Pizza <span class="text-primary-custom">Tuyệt Hảo Nhất!</span></h2>
                        <p class="text-muted mb-4 lead">Chúng tôi mang đến trải nghiệm ẩm thực độc đáo với các nguyên liệu tươi ngon nhất. Từ những chiếc burger đậm đà đến những khay pizza giòn rụm, tất cả đều được chế biến bằng cả đam mê.</p>
                        <ul class="dropdown-menu ...">
                            <li> <div class="cart-empty-guest"> ... nội dung ... </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="row g-4 justify-content-center">
                    <div class="col-lg-4 col-md-6">
                        <div class="promo-card d-flex align-items-center p-4 shadow-sm border-0">
                            <div class="rounded-circle d-flex justify-content-center align-items-center me-3 icon-box"><i class="fas fa-truck fs-3"></i></div>
                            <div><h4 class="fw-bold fs-5 mb-1">Giao Hàng Miễn Phí</h4><p class="text-muted mb-0 small">Cho đơn hàng trên 100k</p></div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="promo-card d-flex align-items-center p-4 shadow-sm border-0">
                            <div class="rounded-circle d-flex justify-content-center align-items-center me-3 icon-box"><i class="fas fa-utensils fs-3"></i></div>
                            <div><h4 class="fw-bold fs-5 mb-1">Thực Phẩm Tươi Sạch</h4><p class="text-muted mb-0 small">Cam kết an toàn 100%</p></div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="promo-card d-flex align-items-center p-4 shadow-sm border-0">
                            <div class="rounded-circle d-flex justify-content-center align-items-center me-3 icon-box"><i class="fas fa-headset fs-3"></i></div>
                            <div><h4 class="fw-bold fs-5 mb-1">Hỗ Trợ 24/7</h4><p class="text-muted mb-0 small">Sẵn sàng phục vụ bạn</p></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="banner-section text-center position-relative">
            <div class="banner-overlay-dark"></div>
            <div class="container position-relative" style="z-index: 1;">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <h2 class="display-4 fw-bold text-white mb-4">Chúng Tôi Có Những Chiếc Burger <span class="text-primary-custom">Chất Lượng Tuyệt Hảo Nhất!</span></h2>
                        <p class="text-light mb-5 fs-5">Hãy đến và chia sẻ những khoảnh khắc vui vẻ bên những món ăn ngon miệng cùng gia đình và người thân.</p>
                        <a href="./ThucDon" class="btn btn-custom btn-lg">Đặt Hàng Ngay <i class="fas fa-shopping-cart ms-2"></i></a>
                    </div>
                </div>
            </div>
        </section>

        <section class="flash-sale-section py-5 bg-white" id="promo">
            <div class="container">
                <div class="text-center mb-5">
                    <p class="section-subtitle text-danger"><i class="fas fa-fire me-2"></i>Khuyến Mãi Khủng</p>
                    <h2 class="display-5 fw-bold mb-0">Siêu <span class="text-danger">Giảm Giá</span></h2>
                </div>
                <div class="row g-4">
                    <c:set var="countDiscount" value="0" />
                    <c:forEach var="p" items="${products}">
                        <c:if test="${p.discount > 0 && countDiscount < 4}">
                            <div class="col-lg-3 col-md-6">
                                <div class="food-card position-relative h-100 border border-danger border-opacity-25">
                                    <span class="badge bg-danger position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">
                                        -<fmt:formatNumber value="${(p.discount / p.price) * 100}" maxFractionDigits="0"/>%
                                    </span>

                                    <form action="AddToFavourite" method="POST" class="position-absolute top-0 end-0 m-3" style="z-index: 5;">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <button type="submit" class="btn btn-wishlist p-2 border-0 bg-transparent shadow-none"><i class="${isLogged && favIds.contains(p.productId) ? 'fas fa-heart text-danger' : 'far fa-heart text-secondary'} fs-4"></i></button>
                                    </form>

                                    <img src="${not empty p.imageUrl ? pageContext.request.contextPath.concat('/').concat(p.imageUrl) : 'https://images.unsplash.com/photo-1513104890138-7c749659a591'}" class="food-img rounded-circle shadow-sm">
                                    <h4 class="fw-bold fs-5 mb-1"><a href="ChiTietMonAn?id=${p.productId}" class="text-dark text-decoration-none stretched-link food-title">${p.name}</a></h4>
                                    <p class="text-muted small mb-3 text-truncate">${not empty p.description ? p.description : 'Đang cập nhật'}</p>
                                    <div class="d-flex justify-content-between align-items-end">
                                        <span class="price text-start">
                                            <del class="text-muted fs-6 me-2"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</del><br>
                                            <span class="text-danger fw-bold"><fmt:formatNumber value="${p.price - p.discount}" pattern="#,###"/>đ</span>
                                        </span>
                                        <form action="AddToCart" method="POST" class="position-relative" style="z-index: 5;">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <button type="submit" class="btn btn-mua-ngay action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2">Thêm <i class="fas fa-cart-plus"></i></button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <c:set var="countDiscount" value="${countDiscount + 1}" />
                        </c:if>
                    </c:forEach>
                </div>
                <div class="text-center mt-5">
                    <a href="ThucDon" class="btn btn-outline-custom rounded-pill px-4 py-2 fw-bold fs-6">Xem Tất Cả <i class="fas fa-arrow-right ms-2"></i></a>
                </div>
            </div>
        </section>

        <section class="new-dish-section py-5" style="background-color: var(--bg-color);">
            <div class="container">
                <div class="text-center mb-5">
                    <p class="section-subtitle text-danger">Hương Vị Mới</p>
                    <h2 class="display-5 fw-bold">Món <span class="text-danger">Mới Ra Mắt</span></h2>
                </div>
                <div class="row g-4 justify-content-center">
                    <c:forEach var="p" items="${products}" begin="0" end="3">
                        <div class="col-lg-3 col-md-6">
                            <div class="food-card position-relative h-100 border border-danger border-opacity-25">
                                <span class="badge bg-success position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">NEW</span>

                                <form action="AddToFavourite" method="POST" class="position-absolute top-0 end-0 m-3" style="z-index: 5;">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button type="submit" class="btn btn-wishlist p-2 border-0 bg-transparent shadow-none"><i class="${isLogged && favIds.contains(p.productId) ? 'fas fa-heart text-danger' : 'far fa-heart text-secondary'} fs-4"></i></button>
                                </form>

                                <img src="${not empty p.imageUrl ? pageContext.request.contextPath.concat('/').concat(p.imageUrl) : 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd'}" class="food-img rounded-circle shadow-sm">
                                <h4 class="fw-bold fs-5 mb-1"><a href="ChiTietMonAn?id=${p.productId}" class="text-dark text-decoration-none stretched-link food-title">${p.name}</a></h4>
                                <p class="text-muted small mb-3 text-truncate">${not empty p.description ? p.description : 'Đang cập nhật...'}</p>
                                <div class="d-flex justify-content-between align-items-end">
                                    <span class="price text-start">
                                        <br><span class="text-danger fw-bold"><fmt:formatNumber value="${p.price - p.discount}" pattern="#,###"/>đ</span>
                                    </span>
                                    <form action="AddToCart" method="POST" class="position-relative" style="z-index: 5;">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <button type="submit" class="btn btn-mua-ngay action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2">Thêm <i class="fas fa-cart-plus"></i></button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="text-center mt-5">
                    <a href="ThucDon" class="btn btn-outline-custom rounded-pill px-4 py-2 fw-bold fs-6">Xem Tất Cả <i class="fas fa-arrow-right ms-2"></i></a>
                </div>
            </div>
        </section>

        <section class="coupon-section py-5">
            <div class="container">
                <div class="text-center mb-5">
                    <p class="section-subtitle text-danger"><i class="fas fa-star me-2"></i>Thưởng Thức Món Ngon</p>
                    <h2 class="display-5 fw-bold mb-0">Món Tuyệt Hảo & <span class="text-primary-custom">Coupon Hấp Dẫn</span></h2>
                </div>

                <div class="row g-4">
                    <div class="col-lg-6">
                        <div class="coupon-card large-coupon p-4 p-lg-5 position-relative overflow-hidden h-100 d-flex align-items-center">
                            <div class="position-relative z-1 coupon-text-large">
                                <h3 class="fw-bold text-white mb-2 fs-5">Burger Bò Mỹ Nướng Lửa</h3>
                                <h2 class="fw-bold text-white mb-3 lh-sm" style="font-size: 2.2rem;">Thịt Ẩm Mọng Nước,<br>Ngon Khó Cưỡng!</h2>
                                <p class="mb-4 text-white opacity-75">Hương vị bùng nổ trong từng miếng cắn. <strong>Tặng mã giảm 50%</strong> cho lần đầu đặt món.</p>
                                <a href="ThucDon" class="btn btn-coupon shadow-none px-4">Đặt Ngay Kẻo Lỡ</a>
                            </div>
                            <div class="position-absolute food-img-wrapper coupon-img-large">
                                <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" alt="Food" class="rounded-circle shadow-lg w-100 h-100" style="object-fit: cover;">
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="row g-4 h-100">
                            <div class="col-md-6">
                                <div class="coupon-card small-coupon red-bg p-4 position-relative overflow-hidden h-100">
                                    <div class="position-relative z-1 coupon-text-small">
                                        <h3 class="fw-bold text-white mb-1 fs-5">Pizza Hải Sản Phô Mai</h3>
                                        <p class="mb-3 text-white opacity-75 small">Hải sản tươi rói. <strong>Freeship 0đ</strong> cho đơn từ 150K</p>
                                        <a href="ThucDon" class="btn btn-coupon btn-sm px-3">Thử Ngay</a>
                                    </div>
                                    <div class="position-absolute food-img-wrapper coupon-img-small-1">
                                        <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" alt="Pizza" class="rounded-circle shadow w-100 h-100" style="object-fit: cover;">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="coupon-card small-coupon green-bg p-4 position-relative overflow-hidden h-100">
                                    <div class="position-relative z-1 coupon-text-small">
                                        <h3 class="fw-bold text-white mb-1 fs-5">Gà Rán Xốt Cay Hàn</h3>
                                        <p class="mb-3 text-white opacity-75 small">Lớp vỏ giòn tan. <strong>Mua 1 Tặng 1</strong> dịp cuối tuần</p>
                                        <a href="ThucDon" class="btn btn-coupon btn-sm px-3">Thử Ngay</a>
                                    </div>
                                    <div class="position-absolute food-img-wrapper coupon-img-small-2">
                                        <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" alt="Burger" class="rounded-circle shadow w-100 h-100" style="object-fit: cover;">
                                    </div>
                                </div>
                            </div>

                            <div class="col-12">
                                <div class="coupon-card medium-coupon black-bg p-4 position-relative overflow-hidden h-100 d-flex align-items-center">
                                    <div class="position-absolute food-img-wrapper coupon-img-medium">
                                        <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80" alt="Pizza" class="rounded-circle shadow-lg w-100 h-100" style="object-fit: cover;">
                                    </div>
                                    <div class="position-relative z-1 ms-auto text-start ps-4 coupon-text-medium">
                                        <span class="badge bg-danger mb-2">Mã Giảm 20% Toàn Menu</span>
                                        <h3 class="fw-bold text-white mb-2 fs-3 lh-sm">Pizza Xúc Xích Đút Lò</h3>
                                        <p class="mb-3 text-white opacity-75" style="font-size: 0.95rem;">Đế bánh viền phô mai thơm lừng, ngập tràn topping béo ngậy. Nhập mã: <strong>PIZZA20</strong></p>
                                        <a href="ThucDon" class="btn btn-coupon px-4">Đặt Món Nhận Ưu Đãi</a>
                                    </div>
                                </div>
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
                    <div class="member-item"><div class="member-name">1. Ngô Phương Anh - 09/05/2005</div></div>
                    <div class="member-item"><div class="member-name">2. Phùng Ngọc Bảo - 13/12/2005</div></div>
                    <div class="member-item"><div class="member-name">3. Vũ Ngọc Hương Giang - 25/12/2005</div></div>
                </div>
            </div>
        </footer>

        <a href="#" class="back-top-btn" aria-label="Back to top" data-back-top-btn>
            <i class="fas fa-chevron-up"></i>
        </a>

        <div class="toast-container position-fixed top-0 end-0 p-3 mt-5 pt-4 toast-custom-pos">
            <div id="wishlistToast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body"></div>
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