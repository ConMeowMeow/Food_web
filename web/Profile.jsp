<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="Model.Address" %>
<%@ page import="Controller.AddressDAO" %>
<%@ page import="Model.User" %>
<%@ page import="Model.CartItem" %>
<%@ page import="Controller.CartDAO" %>
<%
    User sessionUser = (User) session.getAttribute("userAccount");
    if (sessionUser == null) {
        response.sendRedirect("DangNhap");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Cá Nhân - Foodie</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" />
        <link rel="stylesheet" href="./css/TrangChu.css">
        <link rel="stylesheet" href="./css/Profile.css">
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
                            <%
                                User user = (User) session.getAttribute("userAccount");
                                boolean isLogged = (user != null);

                                String displayName = "Khách";
                                String avatar = "";
                                String username = "";
                                String email = "";
                                String phone = "";
                                String gender = "";
                                String birthday = "";

                                List<CartItem> cartList = new ArrayList<>();
                                double totalCartPrice = 0;
                                int cartSize = 0;

                                boolean hasItemsInCart = false;

                                if (isLogged) {

                                    displayName = user.getFullName();
                                    username = user.getUsername();
                                    email = user.getEmail();
                                    phone = user.getPhone();
                                    gender = user.getGender();
                                    birthday = user.getBirthday();
                                    
                                    if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) {
                                        avatar = user.getAvatarUrl();
                                    }

                                    CartDAO cdao = new CartDAO();

                                    cartList = cdao.getCartItems(user.getId());

                                    cartSize = cartList.size();

                                    hasItemsInCart = cartSize > 0;

                                    for (CartItem item : cartList) {
                                        totalCartPrice += item.getPrice() * item.getQuantity();
                                    }
                                }
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
                                        <a href="DangNhap" class="btn btn-outline-custom btn-sm w-50">Đăng nhập</a>
                                        <a href="DangKy" class="btn btn-custom btn-sm w-50 text-decoration-none">Đăng ký</a>
                                    </div>
                                </div>
                                <% } else if (!hasItemsInCart) { %>
                                <div class="cart-empty-user text-center py-4">
                                    <i class="fas fa-shopping-basket fs-1 text-muted mb-3 d-block"></i>
                                    <p class="text-muted mb-3">Giỏ hàng của bạn đang trống!</p>
                                    <a href="#menu" class="btn btn-custom w-100 text-decoration-none">Đặt món ngay</a>
                                </div>
                                <% } else { %>
                                <div class="cart-has-items"> 
                                    <h6 class="fw-bold mb-3 border-bottom pb-2">Giỏ hàng của bạn</h6>
                                    <div class="cart-items-list mb-3 scrollable-list">
                                        <div class="d-flex align-items-center mb-3">
                                            <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=50&q=80" alt="Burger" class="rounded object-fit-cover" style="width: 50px; height: 50px;">
                                            <div class="ms-3 flex-grow-1">
                                                <h6 class="mb-0 fs-6 fw-bold">Beef Burger Classic</h6>
                                                <span class="text-primary-custom fw-bold">125.000đ</span> <span class="text-muted small">x 1</span>
                                            </div>
                                            <button class="btn btn-link text-danger p-0 ms-2"><i class="fas fa-trash-alt"></i></button>
                                        </div>
                                        <div class="d-flex align-items-center mb-3">
                                            <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=50&q=80" alt="Pizza" class="rounded object-fit-cover" style="width: 50px; height: 50px;">
                                            <div class="ms-3 flex-grow-1">
                                                <h6 class="mb-0 fs-6 fw-bold">Tasty Buzzed Pizza</h6>
                                                <span class="text-primary-custom fw-bold">99.000đ</span> <span class="text-muted small">x 2</span>
                                            </div>
                                            <button class="btn btn-link text-danger p-0 ms-2"><i class="fas fa-trash-alt"></i></button>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between border-top pt-2 mb-3 fw-bold">
                                        <span>Tổng cộng:</span>
                                        <span class="text-primary-custom">323.000đ</span>
                                    </div>
                                    <a href="ThanhToan" class="btn btn-custom w-100 text-center text-decoration-none">Thanh toán ngay</a>
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
                                <li><a class="dropdown-item py-2 fw-semibold" href="./DangNhap"><i class="fas fa-sign-in-alt me-2 text-muted"></i> Đăng nhập</a></li>
                                <li><a class="dropdown-item py-2 fw-semibold" href="./DangKy"><i class="fas fa-user-plus me-2 text-muted"></i> Đăng ký</a></li>
                            </ul>
                            <% } else { %>
                            <a href="#" class="text-dark text-decoration-none d-flex align-items-center justify-content-center border border-2 border-primary rounded-circle icon-wrap-profile" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="<%= avatar%>" alt="Avatar" class="rounded-circle w-100 h-100 object-fit-cover">
                            </a>
                            <ul class="dropdown-menu dropdown-menu-center border-0 shadow-lg profile-dropdown" aria-labelledby="accountDropdown">
                                <div class="profile-header mx-2 my-1 p-2 rounded d-flex align-items-center">
                                    <img src="https://ui-avatars.com/api/?name=Ngo+Phuong+Anh&background=ea6a47&color=fff" alt="Avatar" class="rounded-circle icon-wrap-circle">
                                    <div class="ms-3">
                                        <h6 class="mb-0 fw-bold fs-6"><%=displayName%></h6>
                                    </div>
                                </div>
                                <div class="px-2 mb-2">
                                    <a href="./Profile" class="btn w-100 fw-bold text-primary-custom bg-light border-0">Xem tất cả trang cá nhân</a>
                                </div>
                                <li><hr class="dropdown-divider mb-2"></li>
                                <li class="px-2">
                                    <a class="dropdown-item profile-item d-flex align-items-center" href="#">
                                        <div class="icon-wrap"><i class="fas fa-clipboard-list"></i></div>
                                        <span class="fw-semibold">Đơn hàng của tôi</span>
                                    </a>
                                </li>
                                <li class="px-2">
                                    <a class="dropdown-item profile-item d-flex align-items-center" href="DangXuat">
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

        <section class="profile-section py-5">
            <div class="container">
                <div class="row g-4">

                    <div class="col-lg-3">
                        <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                            <img src="<%= avatar%>" alt="Avatar" class="rounded-circle border avatar-sm">
                            <div class="ms-3">
                                <div class="fw-bold text-dark"><%= user.getUsername() %></div>
                            </div>
                        </div>

                        <div class="profile-sidebar">
                            <div class="mb-3">
                                <a href="#collapseAccount" data-bs-toggle="collapse" role="button" aria-expanded="true" class="list-group-item d-flex align-items-center text-secondary fw-semibold mb-2 text-decoration-none border-0 bg-transparent p-0">
                                    <div><i class="far fa-user text-primary-custom me-2 sidebar-icon"></i>Tài khoản của tôi</div>
                                </a>

                                <div class="collapse show" id="collapseAccount">
                                    <div class="ms-4 ps-2 d-flex flex-column gap-2 mt-2">
                                        <a href="javascript:void(0)" class="list-group-item text-primary-custom active-custom text-decoration-none small border-0 bg-transparent p-0" data-target="tab-chi-tiet">Hồ sơ</a>
                                        <a href="javascript:void(0)" class="list-group-item text-secondary text-decoration-none small border-0 bg-transparent p-0" data-target="tab-dia-chi">Địa chỉ</a>
                                        <a href="javascript:void(0)" class="list-group-item text-secondary text-decoration-none small border-0 bg-transparent p-0" data-target="tab-mat-khau">Đổi mật khẩu</a>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3 mt-4">
                                <a href="javascript:void(0)" class="list-group-item d-flex align-items-center text-secondary fw-semibold mb-2 text-decoration-none border-0 bg-transparent p-0" data-target="tab-don-hang">
                                    <i class="fas fa-clipboard-list text-primary-custom me-2 sidebar-icon"></i> Đơn Mua
                                </a>
                            </div>

                            <div class="mb-3 mt-4">
                                <a href="javascript:void(0)" class="list-group-item d-flex align-items-center text-secondary fw-semibold text-decoration-none border-0 bg-transparent p-0" data-target="tab-yeu-thich">
                                    <i class="fas fa-heart text-primary-custom me-2 sidebar-icon"></i> Món ăn yêu thích
                                </a>
                            </div>

                            <div class="mb-3 mt-4">
                                <a href="javascript:void(0)" class="list-group-item d-flex align-items-center text-secondary fw-semibold text-decoration-none border-0 bg-transparent p-0" data-target="tab-voucher">
                                    <i class="fas fa-ticket-alt text-primary-custom me-2 sidebar-icon"></i> Kho Voucher
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-9">

                        <div id="tab-chi-tiet" class="profile-tab-content">
                            <div class="shopee-form-container">
                                <div class="border-bottom pb-3 mb-4">
                                    <h5 class="fw-bold mb-1 text-dark fs-5">Hồ Sơ Của Tôi</h5>
                                    <p class="text-muted mb-0 text-sm-custom">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                                </div>

                                <form action="UpdateProfile" method="POST" enctype="multipart/form-data">
                                    <div class="row">
                                        <div class="col-md-8 pe-md-4">
                                            <div class="row mb-4 align-items-center">
                                                <div class="col-sm-3 text-sm-end text-muted text-sm-custom">Tên đăng nhập</div>
                                                <div class="col-sm-9">
                                                    <input type="text" class="form-control shopee-input bg-white" name="tenDangNhap" value="<%=username%>" required>
                                                </div>
                                            </div>

                                            <div class="row mb-4 align-items-center">
                                                <div class="col-sm-3 text-sm-end text-muted text-sm-custom">Họ và tên</div>
                                                <div class="col-sm-9">
                                                    <input type="text" class="form-control shopee-input shadow-none" name="hoTen" value="<%=displayName%>" required>
                                                </div>
                                            </div>

                                            <div class="row mb-4 align-items-center">
                                                <div class="col-sm-3 text-sm-end text-muted text-sm-custom">Email</div>
                                                <div class="col-sm-9">
                                                    <input type="email" class="form-control shopee-input shadow-none" name="email" value="<%=email%>" required>
                                                </div>
                                            </div>

                                            <div class="row mb-4 align-items-center">
                                                <div class="col-sm-3 text-sm-end text-muted text-sm-custom">Số điện thoại</div>
                                                <div class="col-sm-9">
                                                    <input type="tel" class="form-control shopee-input shadow-none" name="sdt" value="<%=phone%>" required>
                                                </div>
                                            </div>

                                            <div class="row mb-4 align-items-center">
                                                <div class="col-sm-3 text-sm-end text-muted text-sm-custom">Giới tính</div>
                                                <div class="col-sm-9 d-flex gap-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input shadow-none cursor-pointer" type="radio" name="gioiTinh" id="genderMale" value="nam"<%= "nam".equalsIgnoreCase(gender) ? "checked" : "" %>>
                                                        <label class="form-check-label cursor-pointer" for="genderMale">Nam</label>
                                                    </div>
                                                    <div class="form-check">
                                                        <input class="form-check-input shadow-none cursor-pointer" type="radio" name="gioiTinh" id="genderFemale" value="nu" <%= "nu".equalsIgnoreCase(gender) ? "checked" : "" %>>
                                                        <label class="form-check-label cursor-pointer" for="genderFemale">Nữ</label>
                                                    </div>
                                                    <div class="form-check">
                                                        <input class="form-check-input shadow-none cursor-pointer" type="radio" name="gioiTinh" id="genderOther" value="khac"<%= "khac".equalsIgnoreCase(gender) ? "checked" : "" %>>
                                                        <label class="form-check-label cursor-pointer" for="genderOther">Khác</label>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row mb-4 align-items-center">
                                                <div class="col-sm-3 text-sm-end text-muted text-sm-custom">Ngày sinh</div>
                                                <div class="col-sm-9">
                                                    <input type="date" class="form-control shopee-input bg-white" name="ngaySinh" value="<%=birthday%>">
                                                </div>
                                            </div>

                                            <div class="row mt-4">
                                                <div class="col-sm-3"></div>
                                                <div class="col-sm-9">
                                                    <button type="submit" class="btn btn-primary-custom px-4 py-2">Lưu Thay Đổi</button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-4 border-start d-flex flex-column align-items-center justify-content-start pt-3">
                                            <img src="<%= avatar%>" alt="Avatar" class="rounded-circle mb-4 border avatar-lg" id="avatarPreview">
                                            <input type="file" id="avatarInput" name="avatarInput" class="d-none" accept="image/jpeg, image/png">

                                            <div class="d-flex gap-2 mb-3">
                                                <label for="avatarInput" class="shopee-upload-btn cursor-pointer">Chọn Ảnh</label>

                                                <%-- MỚI: Nút Xóa ảnh. Chỉ hiện khi ảnh hiện tại KHÔNG PHẢI là ảnh mặc định --%>
                                                <% if (!avatar.equals("/img/default_avatar.png")) { %>
                                                <button type="button" class="btn btn-outline-danger btn-sm rounded- pill px-3" 
                                                        onclick="document.getElementById('deleteAvatarForm').submit();">Xóa ảnh</button>
                                                <% } %>
                                            </div>

                                            <div class="text-muted text-center text-xs-custom">
                                                Dụng lượng file tối đa 1 MB<br>
                                                Định dạng: .JPEG, .PNG
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div id="tab-dia-chi" class="profile-tab-content d-none">
                            <div class="shopee-form-container p-0">
                                <div class="border-bottom px-4 py-3 d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0 text-dark fs-5 fw-medium">Địa Chỉ Của Tôi</h5>
                                    <button id="btn-show-add-address" class="btn btn-primary-custom px-3 py-2 shadow-none">
                                        <i class="fas fa-plus me-2"></i>Thêm địa chỉ mới
                                    </button>
                                </div>

                                <div class="p-4">
                                    <h6 class="mb-3 text-dark fw-medium fs-5">Địa chỉ</h6>

                                    <div id="address-list">
                                        <%
                                            AddressDAO addressDAO = new AddressDAO();
                                            List<Address> userAddresses = new ArrayList<>();
                                            if (isLogged) {
                                                userAddresses = addressDAO.getByUser(user.getId());
                                            }

                                            if (userAddresses.isEmpty()) {
                                        %>
                                        <div class="text-center text-muted py-4">
                                            <i class="fas fa-map-marker-alt fs-1 mb-3 empty-icon"></i>
                                            <p class="text-dark">Bạn chưa lưu địa chỉ giao hàng nào.</p>
                                        </div>
                                        <%
                                            } else {
                                                for (Address addr : userAddresses) {
                                        %>
                                        <div class="border-bottom pb-4 mb-4 position-relative address-item d-flex justify-content-between align-items-start">
                                            <div class="pe-3">
                                                <div class="mb-1">
                                                    <span class="addr-name fw-bold text-dark fs-6 border-end pe-2 me-2"><%= addr.getRecipientName() %></span> 
                                                    <span class="addr-phone text-muted"><%= addr.getPhone() %></span>
                                                </div>
                                                <div class="addr-detail text-muted mb-2 text-sm-custom">
                                                    <%= addr.getAddressDetail() %><br>
                                                    <%= addr.getWard() %>, <%= addr.getDistrict() %>, <%= addr.getProvince() %>
                                                </div>

                                                <%-- Chỉ hiển thị badge Mặc định nếu isDefault == 1 --%>
                                                <% if (addr.getIsDefault() == 1) { %>
                                                <span class="badge border border-danger text-danger bg-white rounded-1 fw-normal default-badge badge-default mt-1">Mặc định</span>
                                                <% } %>
                                            </div>

                                            <div class="d-flex flex-column justify-content-between align-items-end text-end address-actions">
                                                <div class="mb-2 d-flex align-items-center justify-content-end">
                                                    <a href="javascript:void(0)" class="text-primary text-decoration-none me-3" 
                                                       onclick="editAddress(<%= addr.getAddressId() %>, '<%= addr.getRecipientName() %>', '<%= addr.getPhone() %>', '<%= addr.getProvince() %>', '<%= addr.getDistrict() %>', '<%= addr.getWard() %>', '<%= addr.getAddressDetail() %>')">Cập nhật</a>

                                                    <form action="DeleteAddress" method="POST" class="m-0 p-0 d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">
                                                        <input type="hidden" name="id" value="<%= addr.getAddressId() %>">
                                                        <button type="submit" class="btn btn-link text-primary text-decoration-none p-0 border-0 shadow-none align-baseline">Xóa</button>
                                                    </form>
                                                </div>

                                                <%-- Nút thiết lập mặc định chỉ hiện khi địa chỉ này CHƯA PHẢI là mặc định (Bỏ class d-none) --%>
                                                <%-- Nút thiết lập mặc định --%>
                                                <% if (addr.getIsDefault() == 0) { %>
                                                <form action="SetDefaultAddress" method="POST" class="m-0 p-0">
                                                    <input type="hidden" name="addressId" value="<%= addr.getAddressId() %>">
                                                    <button type="submit" class="btn btn-outline-secondary bg-white text-dark rounded-1 px-3 py-1 btn-set-default btn-outline-custom-gray">Thiết lập mặc định</button>
                                                </form>
                                                <% } %>
                                            </div>
                                        </div>
                                        <%
                                                }
                                            }
                                        %>
                                    </div>

                                    <div id="form-add-address" class="mt-4 d-none p-4 border border-light rounded-3 shadow-sm bg-white">
                                        <h5 class="fw-bold mb-4 text-dark border-bottom pb-2" id="form-address-title">Thêm địa chỉ giao hàng</h5>
                                        <form action="AddAddress" method="POST">
                                            <div class="row g-4">
                                                <div class="col-md-6">
                                                    <label class="form-label small text-muted mb-0">Họ tên người nhận *</label>
                                                    <input type="text" name="recipientName" class="form-control form-control-line" placeholder="Vd: Ngô Phương Anh" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small text-muted mb-0">Số điện thoại *</label>
                                                    <input type="tel" name="phone" class="form-control form-control-line" placeholder="Vd: (+84) 388 319 505" required>
                                                </div>

                                                <div class="col-md-4">
                                                    <label class="form-label small text-muted mb-0">Tỉnh/Thành phố *</label>
                                                    <input type="text" name="province" class="form-control form-control-line" placeholder="Vd: Hà Nội" required>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label small text-muted mb-0">Quận/Huyện *</label>
                                                    <input type="text" name="district" class="form-control form-control-line" placeholder="Vd: Hai Bà Trưng" required>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label small text-muted mb-0">Phường/Xã *</label>
                                                    <input type="text" name="ward" class="form-control form-control-line" placeholder="Vd: Thanh Nhàn" required>
                                                </div>
                                                <div class="col-12">
                                                    <label class="form-label small text-muted mb-0">Địa chỉ cụ thể *</label>
                                                    <textarea name="addressDetail" class="form-control form-control-line" placeholder="F2, Khu Tập Thể Trần Hưng Đạo..." rows="2" required></textarea>
                                                </div>
                                                <div class="col-12 mt-4 d-flex gap-2">
                                                    <button type="submit" class="btn btn-primary-custom px-4 py-2">Hoàn thành</button>
                                                    <button type="button" id="btn-cancel-address" class="btn btn-light px-4 py-2 text-dark border rounded-1">Hủy thao tác</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="tab-mat-khau" class="profile-tab-content d-none">
                            <div class="shopee-form-container">
                                <div class="border-bottom pb-3 mb-4">
                                    <h5 class="fw-bold mb-1 text-dark fs-5">Đổi Mật Khẩu</h5>
                                    <p class="text-muted mb-0 text-sm-custom">Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác</p>
                                </div>
                                <form action="ChangePassword" method="POST" class="pass-form">
                                    <div class="row mb-4 align-items-center mt-4">
                                        <div class="col-sm-4 text-sm-end text-muted text-sm-custom">Mật khẩu hiện tại</div>
                                        <div class="col-sm-8"><input type="password" class="form-control shopee-input shadow-none" name="oldPass" required></div>
                                    </div>
                                    <div class="row mb-4 align-items-center">
                                        <div class="col-sm-4 text-sm-end text-muted text-sm-custom">Mật khẩu mới</div>
                                        <div class="col-sm-8"><input type="password" class="form-control shopee-input shadow-none" name="newPass" required></div>
                                    </div>
                                    <div class="row mb-4 align-items-center">
                                        <div class="col-sm-4 text-sm-end text-muted text-sm-custom">Xác nhận mật khẩu</div>
                                        <div class="col-sm-8"><input type="password" class="form-control shopee-input shadow-none" name="confirmPass" required></div>
                                    </div>
                                    <div class="row mt-4">
                                        <div class="col-sm-4"></div>
                                        <div class="col-sm-8"><button type="submit" class="btn btn-primary-custom px-5 py-2">Xác nhận</button></div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div id="tab-don-hang" class="profile-tab-content d-none">
                            <div class="shopee-form-container">
                                <div class="border-bottom pb-3 mb-4">
                                    <h5 class="fw-bold mb-1 text-dark fs-5">Đơn Hàng Của Tôi</h5>
                                    <p class="text-muted mb-0 text-sm-custom">Quản lý các đơn hàng bạn đã đặt mua</p>
                                </div>

                                <% boolean hasOrders = true; %>

                                <% if (hasOrders) { %>
                                <div class="card border border-light shadow-sm mb-4 rounded-3 overflow-hidden">
                                    <div class="card-header bg-transparent border-bottom pt-3 pb-2 d-flex justify-content-between align-items-center">
                                        <span class="fw-bold text-dark">Mã đơn: #DH1029</span>
                                        <span class="badge bg-success rounded-pill px-3 py-2">Đã giao thành công</span>
                                    </div>

                                    <a href="OrderStatus" class="text-decoration-none text-dark d-block order-card-link">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center">
                                                <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=80&q=80" alt="Burger" class="rounded border avatar-md">
                                                <div class="ms-3 flex-grow-1">
                                                    <h6 class="mb-1 fw-bold">Combo Burger Gà Giòn Cay</h6>
                                                    <small class="text-muted fw-semibold">Số lượng: 1</small>
                                                </div>
                                                <div class="ms-auto fw-bold text-primary-custom">125.000đ</div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                                <% } else { %>
                                <div class="empty-state text-center text-muted mt-5 d-flex flex-column align-items-center justify-content-center">
                                    <i class="fas fa-receipt mb-3 empty-icon"></i>
                                    <p class="text-dark">Chưa có đơn hàng</p>
                                </div>
                                <% } %>
                            </div>
                        </div>

                        <div id="tab-yeu-thich" class="profile-tab-content d-none">
                            <div class="shopee-form-container">
                                <div class="border-bottom pb-3 mb-4">
                                    <h5 class="fw-bold mb-1 text-dark fs-5">Món Ăn Yêu Thích</h5>
                                    <p class="text-muted mb-0 text-sm-custom">Danh sách các món ăn bạn đã lưu lại</p>
                                </div>

                                <% boolean hasFavorites = true; %>

                                <% if (hasFavorites) { %>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="card border border-light shadow-sm h-100 p-2 d-flex flex-row align-items-center wishlist-card">
                                            <a href="ChiTietMonAn" class="d-flex flex-row align-items-center flex-grow-1 text-decoration-none">
                                                <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=80&q=80" class="rounded border avatar-80" alt="Pizza">
                                                <div class="ms-3">
                                                    <h6 class="fw-bold mb-1 wishlist-title">Tasty Buzzed Pizza</h6>
                                                    <div class="fw-bold text-primary-custom">99.000đ</div>
                                                </div>
                                            </a>

                                            <button class="btn btn-light text-danger rounded-circle p-2 shadow-sm border ms-2 d-flex align-items-center justify-content-center wishlist-btn-remove" title="Bỏ yêu thích"
                                                    onclick="const icon = this.querySelector('i');
                                                            if (icon.classList.contains('fas')) {
                                                                icon.classList.replace('fas', 'far');
                                                            } else {
                                                                icon.classList.replace('far', 'fas');
                                                            }">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <% } else { %>
                                <div class="empty-state text-center text-muted mt-5 d-flex flex-column align-items-center justify-content-center">
                                    <i class="fas fa-heart-broken mb-3 empty-icon"></i>
                                    <p class="text-dark">Chưa có món ăn yêu thích</p>
                                </div>
                                <% } %>
                            </div>
                        </div>

                        <div id="tab-voucher" class="profile-tab-content d-none">
                            <div class="shopee-form-container p-0">
                                <div class="border-bottom px-4 py-3">
                                    <h5 class="fw-bold mb-1 text-dark fs-5">Kho Voucher</h5>
                                    <p class="text-muted mb-0 text-sm-custom">Danh sách các mã giảm giá và miễn phí vận chuyển bạn đã lưu</p>
                                </div>

                                <% boolean hasVouchers = true; %>

                                <div class="p-4 bg-light" style="min-height: 300px;">
                                    <% if (hasVouchers) { %>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <div class="card border-0 shadow-sm flex-row overflow-hidden voucher-card">
                                                <div class="text-white d-flex flex-column justify-content-center align-items-center voucher-left">
                                                    <i class="fas fa-utensils fs-3 mb-1"></i>
                                                    <span class="small fw-bold">Giảm Giá</span>
                                                </div>
                                                <div class="p-3 flex-grow-1 d-flex flex-column justify-content-center bg-white position-relative voucher-right">
                                                    <h6 class="fw-bold mb-1 text-dark text-truncate fs-6">Giảm 20K Cho Đơn...</h6>
                                                    <span class="text-muted mb-2 text-xxs-custom">Đơn Tối Thiểu 100K</span>
                                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                                        <span class="text-danger fw-medium text-xxs-custom">HSD: 30.05.2026</span>
                                                        <a href="ThucDon" class="text-primary-custom fw-bold text-decoration-none text-sm-custom">Dùng ngay</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <% } else { %>
                                    <div class="text-center text-muted d-flex flex-column align-items-center justify-content-center h-100 mt-4">
                                        <i class="fas fa-ticket-alt mb-3 empty-icon"></i>
                                        <p class="text-dark mb-1">Bạn chưa có mã giảm giá nào</p>
                                        <a href="KhuyenMai" class="text-primary-custom text-decoration-none small">Săn mã ngay</a>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="./js/index.js"></script>
        <script>
                                                        // Gom tất cả vào DOMContentLoaded để đảm bảo HTML tải xong 100% mới chạy code
                                                        document.addEventListener("DOMContentLoaded", function () {

                                                            // ==========================================
                                                            // 1. CHỨC NĂNG CHUYỂN TAB TỰ ĐỘNG (FIX LỖI VĂNG VỀ TRANG HỒ SƠ)
                                                            // ==========================================
                                                            const urlParams = new URLSearchParams(window.location.search);
                                                            if (urlParams.get('tab') === 'address') {
                                                                // Ẩn tất cả các tab
                                                                document.querySelectorAll('.profile-tab-content').forEach(tab => tab.classList.add('d-none'));
                                                                // Bỏ highlight tất cả menu
                                                                document.querySelectorAll('.list-group-item').forEach(item => item.classList.remove('active-custom', 'text-primary-custom'));

                                                                // Hiện tab địa chỉ và highlight menu
                                                                const tabDiaChi = document.getElementById('tab-dia-chi');
                                                                const menuDiaChi = document.querySelector('[data-target="tab-dia-chi"]');

                                                                if (tabDiaChi)
                                                                    tabDiaChi.classList.remove('d-none');
                                                                if (menuDiaChi)
                                                                    menuDiaChi.classList.add('active-custom', 'text-primary-custom');
                                                            }

                                                            // ==========================================
                                                            // 2. BẬT/TẮT FORM VÀ XỬ LÝ CẬP NHẬT ĐỊA CHỈ
                                                            // ==========================================
                                                            const btnShowAdd = document.getElementById("btn-show-add-address");
                                                            const btnCancelAdd = document.getElementById("btn-cancel-address");
                                                            const formAddContainer = document.getElementById("form-add-address");

                                                            if (btnShowAdd && btnCancelAdd && formAddContainer) {
                                                                const form = formAddContainer.querySelector("form");

                                                                // Nút "Thêm địa chỉ mới" -> Reset form về trạng thái Thêm
                                                                btnShowAdd.addEventListener("click", function () {
                                                                    document.getElementById("form-address-title").innerText = "Thêm địa chỉ giao hàng";
                                                                    form.action = "AddAddress";
                                                                    form.reset(); // Xóa sạch dữ liệu cũ

                                                                    // Xóa thẻ input ID ẩn (nếu có) từ lần bấm Cập nhật trước
                                                                    const idInput = form.querySelector('input[name="addressId"]');
                                                                    if (idInput)
                                                                        idInput.remove();

                                                                    formAddContainer.classList.remove("d-none");
                                                                });

                                                                btnCancelAdd.addEventListener("click", function () {
                                                                    formAddContainer.classList.add("d-none");
                                                                });
                                                            }

                                                            // Hàm được gọi khi bấm nút "Cập nhật" ở danh sách
                                                            window.editAddress = function (id, name, phone, province, district, ward, detail) {
                                                                const formAddContainer = document.getElementById("form-add-address");
                                                                const form = formAddContainer.querySelector("form");

                                                                // Đổi tiêu đề và Action của form
                                                                document.getElementById("form-address-title").innerText = "Cập nhật địa chỉ";
                                                                form.action = "UpdateAddress";

                                                                // Đổ dữ liệu vào các ô input
                                                                form.querySelector('input[name="recipientName"]').value = name;
                                                                form.querySelector('input[name="phone"]').value = phone;
                                                                form.querySelector('input[name="province"]').value = province;
                                                                form.querySelector('input[name="district"]').value = district;
                                                                form.querySelector('input[name="ward"]').value = ward;
                                                                form.querySelector('textarea[name="addressDetail"]').value = detail;

                                                                // Thêm input ẩn chứa ID để gửi lên Server
                                                                let idInput = form.querySelector('input[name="addressId"]');
                                                                if (!idInput) {
                                                                    idInput = document.createElement("input");
                                                                    idInput.type = "hidden";
                                                                    idInput.name = "addressId";
                                                                    form.appendChild(idInput);
                                                                }
                                                                idInput.value = id;

                                                                // Bật form và cuộn trang xuống
                                                                formAddContainer.classList.remove("d-none");
                                                                formAddContainer.scrollIntoView({behavior: 'smooth'});
                                                            };

                                                            // ==========================================
                                                            // 3. CẮT (CROP/ZOOM) VÀ PREVIEW ẢNH AVATAR
                                                            // ==========================================
                                                            let cropper = null;
                                                            const avatarInput = document.getElementById("avatarInput");
                                                            const avatarPreview = document.getElementById("avatarPreview");
                                                            const imageToCrop = document.getElementById("imageToCrop");

                                                            // Khởi tạo Modal của Bootstrap
                                                            const cropModalElement = document.getElementById('cropModal');
                                                            let cropModal;
                                                            if (cropModalElement) {
                                                                cropModal = new bootstrap.Modal(cropModalElement);
                                                            }

                                                            if (avatarInput && avatarPreview && imageToCrop) {
                                                                // Khi người dùng chọn file
                                                                avatarInput.addEventListener("change", function (e) {
                                                                    const file = e.target.files[0];
                                                                    if (file) {
                                                                        // Kiểm tra dung lượng (Cho phép chọn ảnh to hơn một chút để cắt)
                                                                        if (file.size > 1024 * 1024 * 5) {
                                                                            alert("Ảnh gốc tải lên không được vượt quá 5MB!");
                                                                            avatarInput.value = "";
                                                                            return;
                                                                        }

                                                                        // Đọc ảnh và mở Modal
                                                                        const reader = new FileReader();
                                                                        reader.onload = function (event) {
                                                                            imageToCrop.src = event.target.result;
                                                                            if (cropModal)
                                                                                cropModal.show();
                                                                        };
                                                                        reader.readAsDataURL(file);
                                                                    }
                                                                });

                                                                // Khi Modal mở lên hoàn toàn -> Bật Cropper
                                                                cropModalElement.addEventListener('shown.bs.modal', function () {
                                                                    cropper = new Cropper(imageToCrop, {
                                                                        aspectRatio: 1, // Ép tỷ lệ 1:1 (hình vuông để làm avatar tròn)
                                                                        viewMode: 1, // Không cho crop ra ngoài viền ảnh
                                                                        autoCropArea: 1,
                                                                        dragMode: 'move' // Cho phép kéo di chuyển ảnh
                                                                    });
                                                                });

                                                                // Khi Modal đóng lại -> Dọn dẹp bộ nhớ
                                                                cropModalElement.addEventListener('hidden.bs.modal', function () {
                                                                    if (cropper) {
                                                                        cropper.destroy();
                                                                        cropper = null;
                                                                    }
                                                                });

                                                                // Khi người dùng bấm nút "Cắt và Lưu"
                                                                document.getElementById('btnCrop').addEventListener('click', function () {
                                                                    if (!cropper)
                                                                        return;

                                                                    // Xuất ảnh đã cắt ra dạng Canvas (ép về 400x400 cho nét và nhẹ)
                                                                    const canvas = cropper.getCroppedCanvas({
                                                                        width: 400,
                                                                        height: 400,
                                                                    });

                                                                    // Chuyển Canvas thành file Blob (dạng file nhị phân)
                                                                    canvas.toBlob(function (blob) {
                                                                        // 1. Hiển thị ảnh đã cắt ra ngoài giao diện
                                                                        const url = URL.createObjectURL(blob);
                                                                        avatarPreview.src = url;

                                                                        // 2. THỦ THUẬT: Ép file vừa cắt ngược lại vào thẻ <input type="file">
                                                                        const croppedFile = new File([blob], "avatar_cropped.png", {type: "image/png"});
                                                                        const dataTransfer = new DataTransfer();
                                                                        dataTransfer.items.add(croppedFile);
                                                                        avatarInput.files = dataTransfer.files;

                                                                        // 3. Đóng Modal
                                                                        cropModal.hide();
                                                                    }, 'image/png'); // Tự động xuất ra đuôi .PNG
                                                                });
                                                            }
                                                        });
        </script>
        <form id="deleteAvatarForm" action="DeleteAvatar" method="POST" style="display:none;"></form>
        <div class="modal fade" id="cropModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header border-bottom-0 pb-0">
                        <h5 class="modal-title fw-bold text-dark">Chỉnh sửa ảnh đại diện</h5>
                        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center pt-2">
                        <div style="max-height: 400px; width: 100%; overflow: hidden; background-color: #f8f9fa;">
                            <img id="imageToCrop" src="" style="max-width: 100%; display: block;">
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary-custom" id="btnCrop">Cắt và Lưu</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>