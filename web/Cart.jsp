<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.sql.Connection, java.sql.SQLException" %>
<%@ page import="java.text.DecimalFormat" %>
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
    
    // Biến lưu thông tin user để dùng ở dưới (thay thế JSTL attribute)
    String displayName = "";
    String avatar = "";

    // Bộ định dạng tiền tệ (thay cho <fmt:formatNumber>)
    DecimalFormat df = new DecimalFormat("#,###");

    Connection conn = null;
    try {
        conn = Connect.getConnection();
        // 1. Lấy toàn bộ sản phẩm
        ProductDAO pdao = new ProductDAO(conn);
        productList = pdao.getAllProducts();

        if (isLogged) {
            displayName = user.getFullName();
            avatar = user.getAvatarUrl();

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
        // Đảm bảo đóng kết nối thủ công ngay khi hoàn thành tải trang
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ Hàng</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
        <link rel="stylesheet" href="./css/TrangChu.css">
        <link rel="stylesheet" href="./css/Cart.css"/>
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
                        <li class="nav-item"><a class="nav-link" href="./TrangChu">Trang chủ</a></li>
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
                                    <a href="YeuThich" class="btn btn-custom w-100 text-center text-decoration-none">Xem chi tiết</a>
                                </div>
                            </ul>
                        </div>

                        <div class="dropdown ms-2 position-relative" id="cartDropdownContainer">
                            <a href="Cart" class="text-primary-custom text-dark fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center icon-wrap-circle" id="cartDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                                <i class="fas fa-shopping-cart"></i> 
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge custom-badge-pos">
                                    <%= (isLogged && cartList != null) ? cartList.size() : 0 %>
                                </span>
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end border-0 cart-dropdown-menu p-3 shadow" aria-labelledby="cartDropdown" style="min-width: 320px;">
                                <li>
                                <% if (!isLogged) { %>
                                    <div class="cart-empty-guest text-center py-4">
                                        <i class="fas fa-shopping-basket fs-1 text-muted mb-3 d-block"></i>
                                        <p class="text-muted mb-3">Giỏ hàng trống. Đăng nhập để tiếp tục!</p>
                                        <div class="d-flex gap-2 justify-content-center">
                                            <a href="DangNhap" class="btn btn-outline-custom btn-sm w-50">Đăng nhập</a>
                                            <a href="DangKy" class="btn btn-custom btn-sm w-50 text-decoration-none">Đăng ký</a>
                                        </div>
                                    </div>
                                <% } else if (cartList == null || cartList.isEmpty()) { %>
                                    <div class="cart-empty-user text-center py-4">
                                        <i class="fas fa-shopping-basket fs-1 text-muted mb-3 d-block"></i>
                                        <p class="text-muted mb-3">Giỏ hàng của bạn đang trống!</p>
                                        <a href="ThucDon" class="btn btn-custom w-100 text-decoration-none">Đặt món ngay</a>
                                    </div>
                                <% } else { %>
                                    <div class="cart-has-items"> 
                                        <h6 class="fw-bold mb-3 border-bottom pb-2">Giỏ hàng của bạn</h6>
                                        <div class="cart-items-list mb-3 scrollable-list" style="max-height: 250px; overflow-y: auto;">
                                            <% for (CartItem item : cartList) { 
                                                String imgSrc = (item.getImageUrl() != null && !item.getImageUrl().isEmpty()) ? request.getContextPath() + "/" + item.getImageUrl() : "./img/default.png";
                                            %>
                                                <div class="d-flex align-items-center mb-3">
                                                    <img src="<%= imgSrc %>" class="rounded object-fit-cover" style="width: 50px; height: 50px;">
                                                    <div class="ms-3 flex-grow-1">
                                                        <h6 class="mb-0 fs-6 fw-bold text-truncate" style="max-width: 150px;"><%= item.getProductName() %></h6>
                                                        <span class="text-primary-custom fw-bold"><%= df.format(item.getPrice()) %>đ</span> <span class="text-muted small">x <%= item.getQuantity() %></span>
                                                    </div>
                                                    <a href="RemoveFromCart?productId=<%= item.getProductId() %>" class="btn btn-link text-danger p-0 ms-2"><i class="fas fa-trash-alt"></i></a>
                                                </div>
                                            <% } %>
                                        </div>
                                        <div class="d-flex justify-content-between border-top pt-2 mb-3 fw-bold">
                                            <span>Tổng cộng:</span>
                                            <span class="text-primary-custom"><%= df.format(totalCartPrice) %>đ</span>
                                        </div>
                                    </div>
                                <% } %>
                                </li>
                            </ul>
                        </div>

                        <div class="dropdown ms-2 position-relative">
                            <% if (!isLogged) { %>
                                <a href="#" class="text-dark fs-4 text-decoration-none icon-action d-flex align-items-center justify-content-center icon-wrap-circle" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user-circle"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-center border-0 shadow profile-dropdown-menu" aria-labelledby="accountDropdown">
                                    <li><a class="dropdown-item py-2 fw-semibold" href="./DangNhap"><i class="fas fa-sign-in-alt me-2 text-muted"></i> Đăng nhập</a></li>
                                    <li><a class="dropdown-item py-2 fw-semibold" href="./DangKy"><i class="fas fa-user-plus me-2 text-muted"></i> Đăng ký</a></li>
                                </ul>
                            <% } else { 
                                String fallbackAvatar = "https://ui-avatars.com/api/?name=" + (displayName != null ? displayName.replace(" ", "+") : "U") + "&background=ea6a47&color=fff";
                                String currentAvatar = (avatar != null && !avatar.trim().isEmpty()) ? avatar : fallbackAvatar;
                            %>
                                <a href="#" class="text-dark text-decoration-none d-flex align-items-center justify-content-center border border-2 border-primary rounded-circle icon-wrap-profile" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <img src="<%= currentAvatar %>" alt="Avatar" class="rounded-circle w-100 h-100 object-fit-cover">
                                </a>
                                <ul class="dropdown-menu dropdown-menu-center border-0 shadow-lg profile-dropdown" aria-labelledby="accountDropdown">
                                    <div class="profile-header mx-2 my-1 p-2 rounded d-flex align-items-center">
                                        <img src="<%= currentAvatar %>" alt="Avatar" class="rounded-circle icon-wrap-circle">
                                        <div class="ms-3">
                                            <h6 class="mb-0 fw-bold fs-6"><%= displayName %></h6>
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
                <div class="d-flex justify-content-center mt-auto position-absolute start-50 translate-middle d-flex" style="gap: 8px;">
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
                <div class="d-flex justify-content-center mt-auto" style="gap: 8px;">
                    <div class="menu-deco-line"></div>
                    <div class="menu-deco-line"></div>
                    <div class="menu-deco-line"></div>
                </div>
            </div>
        </div>        

        <section class="hero-section hero-spacing" id="home">
            <div class="hero-banner-slider">
                <div class="position-relative">
                    <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80" alt="Banner Burger" class="w-100 hero-banner-img">
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
                    <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80" alt="Banner Pizza" class="w-100 hero-banner-img">
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
                    <img src="https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80" alt="Banner Fresh" class="w-100 hero-banner-img">
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

        <section class="cart-page position-relative cart-page-spacing">
            <div class="container mb-4">
                <div class="cart-header-row bg-white shadow-sm rounded-1 d-flex flex-wrap align-items-center px-3 px-lg-4 py-3 mb-3 text-muted small fw-bold mx-0">
                    <div class="col-12 col-lg-4 d-flex align-items-center mb-2 mb-lg-0">
                        <input class="form-check-input custom-checkbox me-3 pointer-cursor" type="checkbox" id="selectAllTop">
                        <label for="selectAllTop" class="pointer-cursor">Món Ăn</label>
                    </div>
                    <div class="col-12 col-lg-8 d-none d-lg-block">
                        <div class="row w-100 mx-0">
                            <div class="col-3 text-center">Đơn Giá</div>
                            <div class="col-3 text-center">Số Lượng</div>
                            <div class="col-3 text-center">Số Tiền</div>
                            <div class="col-3 text-center">Thao Tác</div>
                        </div>
                    </div>
                </div>

                <div class="cart-shop-group bg-white shadow-sm rounded-1 mb-3">
                    <% if (cartList != null) { 
                        for (CartItem item : cartList) { 
                            String imgSrc = (item.getImageUrl() != null && !item.getImageUrl().isEmpty()) ? request.getContextPath() + "/" + item.getImageUrl() : "./img/default.png";
                    %>
                        <div class="cart-item-row row align-items-center py-4 border-bottom bg-white position-relative z-index-2 mx-0 px-3 px-lg-4">
                            <div class="col-12 col-lg-4 d-flex align-items-start mb-3 mb-lg-0">
                                <div class="d-flex align-items-center h-100 me-2 mt-4 pt-2">
                                    <input class="form-check-input custom-checkbox pointer-cursor" type="checkbox" checked>
                                </div>
                                <a href="ChiTietMonAn?id=<%= item.getProductId() %>" class="d-block me-3 shrink-0">
                                    <img src="<%= imgSrc %>" alt="<%= item.getProductName() %>" class="item-img border rounded" style="width: 80px; height: 80px; object-fit: cover;">
                                </a>
                                <div class="d-flex flex-column pt-1">
                                    <a href="ChiTietMonAn?id=<%= item.getProductId() %>" class="fw-medium text-dark text-decoration-none mb-1 item-name"><%= item.getProductName() %></a>
                                </div>
                            </div>

                            <div class="col-12 col-lg-8">
                                <div class="row align-items-center w-100 mx-0">
                                    <div class="col-6 col-sm-3 col-lg-3 text-lg-center mb-3 mb-sm-0">
                                        <span class="d-block d-lg-none text-muted small fw-bold mb-1">Đơn Giá</span>
                                        <span class="text-dark fw-medium"><%= df.format(item.getPrice()) %>đ</span>
                                    </div>

                                    <div class="col-6 col-sm-3 col-lg-3 d-flex justify-content-end justify-content-lg-center mb-3 mb-sm-0">
                                        <div class="qty-control-box d-flex align-items-center border rounded-1">
                                            <a href="UpdateCart?action=decrease&productId=<%= item.getProductId() %>" class="btn-qty border-end text-dark text-decoration-none d-flex align-items-center justify-content-center" style="width: 30px; height: 30px;"><i class="fas fa-minus fa-xs"></i></a>
                                            <input type="text" class="qty-val text-center border-0" value="<%= item.getQuantity() %>" readonly style="width: 40px; outline: none; background: transparent;">
                                            <a href="UpdateCart?action=increase&productId=<%= item.getProductId() %>" class="btn-qty border-start text-dark text-decoration-none d-flex align-items-center justify-content-center" style="width: 30px; height: 30px;"><i class="fas fa-plus fa-xs"></i></a>
                                        </div>
                                    </div>

                                    <div class="col-6 col-sm-3 col-lg-3 text-lg-center text-primary-custom fw-semibold">
                                        <span class="d-block d-lg-none text-dark small fw-bold mb-1">Số Tiền</span>
                                        <%= df.format(item.getPrice() * item.getQuantity()) %>đ
                                    </div>

                                    <div class="col-6 col-sm-3 col-lg-3 text-end text-lg-center d-flex flex-column align-items-end align-items-lg-center justify-content-center gap-1">
                                        <a href="RemoveFromCart?productId=<%= item.getProductId() %>" class="btn-action text-danger text-decoration-none fw-bold pointer-cursor mb-1">Xóa</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <%  } 
                       } %>
                </div>

                <div class="px-4 py-3 bg-light d-flex align-items-center border-bottom">
                    <i class="fas fa-truck text-success me-2"></i>
                    <span class="small text-dark">Giảm <span class="fw-bold">15.000đ</span> phí vận chuyển cho đơn hàng từ 150.000đ. <a href="#" class="text-primary-custom text-decoration-none ms-1">Tìm hiểu thêm</a></span>
                </div>
            </div>

            <div class="bg-white shadow-sm p-3 mb-2 d-flex justify-content-between align-items-center position-relative dropdown voucher-dropdown-wrapper">
                <div class="d-flex align-items-center me-auto">
                    <i class="fas fa-ticket-alt text-primary-custom fs-5 me-2"></i>
                    <span class="text-dark fw-bold">FastFood Voucher</span>
                </div>
                <a href="#" class="text-primary-custom text-decoration-none small fw-bold" id="cartVoucherDropdown" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                    Chọn Hoặc Nhập Mã <i class="fas fa-chevron-down ms-1"></i>
                </a>

                <div class="dropdown-menu dropdown-menu-end border-0 shadow-lg p-0 voucher-dropdown-menu" aria-labelledby="cartVoucherDropdown">
                    <div class="p-3 border-bottom bg-white">
                        <div class="d-flex bg-white p-1 border voucher-input-box voucher-box">
                            <input type="text" class="form-control border-0 shadow-none bg-transparent px-2 voucher-input-text" placeholder="Nhập mã voucher (vd: SALE50)...">
                            <button type="button" class="btn px-4 fw-bold rounded-0 btn-voucher-save">Lưu</button>
                        </div>
                    </div>
                    <div class="p-3 voucher-list-scroll">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex bg-white rounded border position-relative voucher-item-card">
                                <div class="p-2 d-flex flex-column justify-content-center align-items-center text-white text-center position-relative voucher-left-brand">
                                    <div class="voucher-circle-top"></div>
                                    <div class="voucher-circle-bottom"></div>
                                    <div class="d-flex justify-content-center align-items-center mb-2 voucher-icon-box">
                                        <i class="fas fa-shopping-bag text-white fs-5"></i>
                                    </div>
                                    <div class="text-white text-center lh-1 mt-1">
                                        <div class="fw-bold mb-1 voucher-text-brand">FOODIE</div>
                                        <div class="fw-bold voucher-text-brand">MALL</div>
                                    </div>
                                </div>
                                <div class="p-3 flex-grow-1 d-flex justify-content-between align-items-center">
                                    <div class="pe-2">
                                        <h6 class="fw-bold mb-1 voucher-title">Giảm 15%</h6>
                                        <p class="text-muted mb-1 voucher-min-spend">Đơn Tối thiểu 650k</p>
                                        <p class="text-danger small mb-0 d-flex align-items-center fw-medium voucher-exp">
                                            <i class="far fa-clock me-1"></i> Hết hạn: 1 ngày
                                        </p>
                                    </div>
                                    <div>
                                        <input class="form-check-input custom-checkbox rounded-circle m-0 max-1-checkbox voucher-checkbox" type="checkbox" name="voucherSelect">
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex bg-white rounded border position-relative voucher-item-card">
                                <div class="p-2 d-flex flex-column justify-content-center align-items-center text-white text-center position-relative voucher-left-freeship">
                                    <div class="voucher-circle-top"></div>
                                    <div class="voucher-circle-bottom"></div>
                                    <div class="d-flex justify-content-center align-items-center mb-2 voucher-icon-box">
                                        <i class="fas fa-truck text-white fs-5"></i>
                                    </div>
                                    <div class="text-white text-center lh-1 mt-1">
                                        <div class="fw-bold mb-1 voucher-text-brand">FREE</div>
                                        <div class="fw-bold voucher-text-brand">SHIP</div>
                                    </div>
                                </div>
                                <div class="p-3 flex-grow-1 d-flex justify-content-between align-items-center">
                                    <div class="pe-2">
                                        <h6 class="fw-bold mb-1 voucher-title">Giảm 15k phí VC</h6>
                                        <p class="text-muted mb-1 voucher-min-spend">Đơn Tối thiểu 150k</p>
                                        <p class="text-muted small mb-0 d-flex align-items-center voucher-exp">
                                            <i class="far fa-clock me-1"></i> Có hiệu lực sau 10 tiếng
                                        </p>
                                    </div>
                                    <div>
                                        <input class="form-check-input custom-checkbox rounded-circle m-0 max-1-checkbox voucher-checkbox" type="checkbox" name="voucherSelect">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="p-3 border-top bg-white d-flex justify-content-end gap-2 shadow-sm">
                        <button class="btn btn-light border px-2 fw-bold text-muted pointer-cursor" data-bs-dismiss="dropdown">QUAY LẠI</button>
                        <button class="btn btn-custom px-2 fw-bold pointer-cursor" data-bs-dismiss="dropdown">OK</button>
                    </div>
                </div>
            </div>

            <div id="checkout-wrapper" class="w-100 position-relative mt-4">
                <div id="checkout-bar" class="checkout-bar fixed-bottom checkout-bar-z">
                    <div class="container">
                        <div class="bg-white shadow-sm border px-3 px-md-4 py-3 d-flex flex-wrap justify-content-between align-items-center gap-3">
                            <div class="d-flex align-items-center gap-3 gap-md-4">
                                <div class="d-flex align-items-center pointer-cursor">
                                    <input class="form-check-input custom-checkbox me-2 pointer-cursor" type="checkbox" id="selectAllBottom" checked>
                                    <label for="selectAllBottom" class="text-dark fw-bold pointer-cursor">Tất Cả <span class="d-none d-sm-inline">(<%= cartSize %>)</span></label>
                                </div>
                                <button class="btn-action text-dark d-none d-lg-block pointer-cursor">Xóa</button>
                                <button class="btn-action text-primary-custom d-none d-lg-block pointer-cursor">Lưu vào Yêu thích</button>
                            </div>
                            <div class="d-flex align-items-center gap-3 ms-auto">
                                <div class="text-end d-none d-lg-block">
                                    <div class="d-flex align-items-center">
                                        <span class="text-dark me-2 fs-6">Tổng thanh toán:</span>
                                        <span class="text-primary-custom fw-bold fs-3"><%= df.format(totalCartPrice) %>đ</span>
                                    </div>
                                    <div class="small text-muted text-end">Tiết kiệm: <span class="text-primary-custom">25.000đ</span></div>
                                </div>
                                <div class="text-end d-block d-lg-none">
                                    <div class="text-dark small fw-bold">Tổng:</div>
                                    <span class="text-primary-custom fw-bold fs-5"><%= df.format(totalCartPrice) %>đ</span>
                                </div>
                                <a href="ThanhToan" class="btn btn-checkout text-decoration-none pointer-cursor">Thanh Toán</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="suggested-food py-5 mt-4">
            <div class="container">
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h3 class="fw-bold mb-0 ff-heading">Có Thể Bạn Sẽ Thích</h3>
                    </div>
                    <a href="ThucDon" class="text-primary-custom fw-bold text-decoration-none d-flex align-items-center suggested-see-more">
                        Xem thêm <i class="fas fa-chevron-right ms-2 fs-6"></i>
                    </a>
                </div>
                <div class="row g-4">
                    <div class="col-6 col-md-6 col-lg-3">
                        <div class="food-card position-relative h-100 border border-danger border-opacity-25 bg-white"> 
                            <span class="badge bg-danger position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">-15%</span>
                            <button class="btn btn-wishlist position-absolute top-0 end-0 m-3 p-2 border-0 bg-transparent shadow-none z-index-5 pointer-cursor">
                                <i class="far fa-heart fs-4 text-secondary"></i>
                            </button>
                            <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" alt="Beef Burger" class="food-img rounded-circle shadow-sm">
                            <h4 class="fw-bold fs-5 mb-1">
                                <a href="ChiTietMonAn" class="text-dark text-decoration-none stretched-link food-title">Beef Burger Classic</a>
                            </h4>
                            <p class="text-muted small mb-3">Thịt bò, Phô mai, Rau thơm</p>
                            <div class="d-flex justify-content-between align-items-end">
                                <span class="price text-start">
                                    <del class="text-muted fs-6 me-2">150.000đ</del><br>
                                    <span class="text-danger fw-bold">125.000đ</span>
                                </span>
                                <button class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2 fs-6 pointer-cursor">
                                    Thêm <i class="fas fa-cart-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-6 col-lg-3">
                        <div class="food-card position-relative h-100 border border-danger border-opacity-25 bg-white"> 
                            <span class="badge bg-danger position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">HOT</span>
                            <button class="btn btn-wishlist position-absolute top-0 end-0 m-3 p-2 border-0 bg-transparent shadow-none z-index-5 pointer-cursor">
                                <i class="far fa-heart fs-4 text-secondary"></i>
                            </button>
                            <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" alt="Pizza" class="food-img rounded-circle shadow-sm">
                            <h4 class="fw-bold fs-5 mb-1">
                                <a href="ChiTietMonAn" class="text-dark text-decoration-none stretched-link food-title">Tasty Buzzed Pizza</a>
                            </h4>
                            <p class="text-muted small mb-3">Đế mỏng, ngập ngụa phô mai</p>
                            <div class="d-flex justify-content-between align-items-end">
                                <span class="price text-start">
                                    <del class="text-muted fs-6 me-2 opacity-0">&nbsp;</del><br>
                                    <span class="text-danger fw-bold">99.000đ</span>
                                </span>
                                <button class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2 fs-6 pointer-cursor">
                                    Thêm <i class="fas fa-cart-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-6 col-lg-3">
                        <div class="food-card position-relative h-100 border border-danger border-opacity-25 bg-white"> 
                            <button class="btn btn-wishlist position-absolute top-0 end-0 m-3 p-2 border-0 bg-transparent shadow-none z-index-5 pointer-cursor">
                                <i class="far fa-heart fs-4 text-secondary"></i>
                            </button>
                            <img src="https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=300&q=80" alt="Burger Gà" class="food-img rounded-circle shadow-sm">
                            <h4 class="fw-bold fs-5 mb-1">
                                <a href="ChiTietMonAn" class="text-dark text-decoration-none stretched-link food-title">Burger Gà Giòn</a>
                            </h4>
                            <p class="text-muted small mb-3">Gà rán xù, sốt Mayo béo ngậy</p>
                            <div class="d-flex justify-content-between align-items-end">
                                <span class="price text-start">
                                    <del class="text-muted fs-6 me-2 opacity-0">&nbsp;</del><br>
                                    <span class="text-danger fw-bold">65.000đ</span>
                                </span>
                                <button class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2 fs-6 pointer-cursor">
                                    Thêm <i class="fas fa-cart-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-6 col-lg-3">
                        <div class="food-card position-relative h-100 border border-danger border-opacity-25 bg-white"> 
                            <span class="badge bg-success position-absolute top-0 start-0 m-3 p-2 shadow-sm fs-6">NEW</span>
                            <button class="btn btn-wishlist position-absolute top-0 end-0 m-3 p-2 border-0 bg-transparent shadow-none z-index-5 pointer-cursor">
                                <i class="far fa-heart fs-4 text-secondary"></i>
                            </button>
                            <img src="https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=300&q=80" alt="Gà rán" class="food-img rounded-circle shadow-sm">
                            <h4 class="fw-bold fs-5 mb-1">
                                <a href="ChiTietMonAn" class="text-dark text-decoration-none stretched-link food-title">Gà Rán (1 Miếng)</a>
                            </h4>
                            <p class="text-muted small mb-3">Lớp vỏ giòn tan, thịt mọng nước</p>
                            <div class="d-flex justify-content-between align-items-end">
                                <span class="price text-start">
                                    <del class="text-muted fs-6 me-2 opacity-0">&nbsp;</del><br>
                                    <span class="text-danger fw-bold">36.000đ</span>
                                </span>
                                <button class="btn btn-add-cart action-btn btn-outline-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2 fs-6 pointer-cursor">
                                    Thêm <i class="fas fa-cart-plus"></i>
                                </button>
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

        <a href="#" class="back-top-btn active" aria-label="Back to top" data-back-top-btn style="z-index: 1999;">
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
                const wrapper = document.getElementById('checkout-wrapper');
                const bar = document.getElementById('checkout-bar');

                if (wrapper && bar) {
                    function updateBarPosition() {
                        const barHeight = bar.offsetHeight;
                        wrapper.style.height = barHeight + 'px';

                        const rect = wrapper.getBoundingClientRect();
                        if (rect.top <= window.innerHeight - barHeight) {
                            bar.classList.remove('fixed-bottom');
                            bar.style.position = 'absolute';
                            bar.style.bottom = '0';
                        } else {
                            bar.classList.add('fixed-bottom');
                            bar.style.position = 'fixed';
                            bar.style.bottom = '0';
                        }
                    }

                    window.addEventListener('scroll', updateBarPosition);
                    window.addEventListener('resize', updateBarPosition);
                    setTimeout(updateBarPosition, 100);
                }

                document.querySelectorAll('.voucher-item-card').forEach(card => {
                    card.addEventListener('click', function (event) {
                        const cb = this.querySelector('input[type=checkbox]');
                        if (event.target !== cb) {
                            cb.checked = !cb.checked;
                            cb.dispatchEvent(new Event('change'));
                        }
                    });
                });
            });
        </script>
    </body>
</html>