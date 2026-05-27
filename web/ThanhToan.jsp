<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="Model.*, Controller.*" %>
<%
    // 1. Kiểm tra đăng nhập
    User user = (User) session.getAttribute("userAccount");
    if (user == null) {
        response.sendRedirect("DangNhap.jsp");
        return; 
    }

    boolean isLogged = true;
    request.setAttribute("isLogged", isLogged);
    String displayName = user.getFullName() != null ? user.getFullName() : "";
    request.setAttribute("displayName", displayName);
    String avatar = user.getAvatarUrl();
    request.setAttribute("avatar", avatar);

    // 2. KHAI BÁO CÁC BIẾN CHO FORM THANH TOÁN
    String defaultName = displayName;
    String defaultPhone = user.getPhone() != null ? user.getPhone() : ""; 
    String defaultAddress = "";

    List<CartItem> cartList = new ArrayList<>();
    double totalCartPrice = 0;
    Connection conn = null;

    try {
        conn = Connect.getConnection();
        
        // 3. LOGIC LẤY ĐỊA CHỈ MẶC ĐỊNH
        String sqlAddress = "SELECT recipient_name, phone, address_detail, ward, district, province FROM addresses WHERE user_id = ? AND is_default = 1";
        try (PreparedStatement psAddr = conn.prepareStatement(sqlAddress)) {
            psAddr.setInt(1, user.getId());
            ResultSet rsAddr = psAddr.executeQuery();
            if (rsAddr.next()) {
                defaultName = rsAddr.getString("recipient_name");
                defaultPhone = rsAddr.getString("phone");
                String detail = rsAddr.getString("address_detail");
                String ward = rsAddr.getString("ward");
                String district = rsAddr.getString("district");
                String province = rsAddr.getString("province");
                
                // Format lại địa chỉ
                defaultAddress = detail;
                if (ward != null && !ward.equals("Chưa nhập")) defaultAddress += ", " + ward;
                if (district != null && !district.equals("Chưa nhập")) defaultAddress += ", " + district;
                if (province != null && !province.equals("Chưa nhập")) defaultAddress += ", " + province;
            }
        }

        // 4. Lấy dữ liệu Giỏ hàng & Tính toán tiền
        CartDAO cdao = new CartDAO();
        cartList = cdao.getCartItems(user.getId());
        if (cartList != null) {
            for (CartItem item : cartList) {
                totalCartPrice += item.getPrice() * item.getQuantity();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    request.setAttribute("cartList", cartList);
    request.setAttribute("totalCartPrice", totalCartPrice);

    double shippingFee = 15000;
    double voucherDiscount = 0; // Thay đổi tùy logic của bạn sau này
    double finalPrice = totalCartPrice + shippingFee - voucherDiscount;
    
    request.setAttribute("shippingFee", shippingFee);
    request.setAttribute("voucherDiscount", voucherDiscount);
    request.setAttribute("finalPrice", finalPrice);
%>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán - FastFood</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <link rel="stylesheet" href="./css/TrangChu.css">
        <link rel="stylesheet" href="./css/ThanhToan.css">
    </head>

    <body class="checkout-page-bg">
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container align-items-center">
                <a class="navbar-brand logo" href="./TrangChu.jsp">
                    <img src="./img/logo.png" alt="Logo" class="nav-logo">
                </a>
                <div class="ms-auto d-flex gap-3">
                    <a href="Cart.jsp" class="btn btn-outline-secondary fw-bold rounded-pill px-4">Giỏ Hàng</a>
                </div>
            </div>
        </nav>

        <section class="checkout-section" style="margin-top: 100px;">
            <div class="container">

                <form id="checkoutForm" action="ThanhToan" method="POST" novalidate>

                    <div class="checkout-card p-0 overflow-hidden">
                        <div class="address-border"></div>
                        <div class="px-4 pb-4">
                            <div class="section-title fw-bold mt-3">
                                <i class="fas fa-map-marker-alt me-2 fs-5 text-danger"></i> Địa Chỉ Nhận Đơn
                            </div>
                            <div class="row g-3 px-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-muted">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullname" name="fullname" value="<%= defaultName %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-muted">Số điện thoại <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="phone" name="phone" value="<%= defaultPhone %>" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small fw-semibold text-muted">Địa chỉ cụ thể <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="address" name="address" value="<%= defaultAddress %>" placeholder="Tên đường, Số nhà, Xã/Phường..." required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="checkout-card p-0 mt-3">
                        <div class="cart-header-row d-none d-md-flex row m-0 align-items-center bg-light py-2">
                            <div class="col-6 fw-bold text-dark fs-6">Sản phẩm</div>
                            <div class="col-2 text-center fw-bold">Đơn giá</div>
                            <div class="col-2 text-center fw-bold">Số lượng</div>
                            <div class="col-2 text-end fw-bold">Thành tiền</div>
                        </div>

                        <c:forEach var="item" items="${cartList}">
                            <div class="cart-item-row row m-0 align-items-center py-3 border-bottom">
                                <div class="col-md-6 d-flex align-items-center mb-3 mb-md-0">
                                    <img src="${not empty item.imageUrl ? pageContext.request.contextPath.concat('/').concat(item.imageUrl) : './img/default.png'}" class="item-img rounded" style="width: 70px; height: 70px; object-fit: cover;">
                                    <div class="ms-3">
                                        <span class="fw-medium text-dark d-block">${item.productName}</span>
                                    </div>
                                </div>
                                <div class="col-4 col-md-2 text-md-center text-muted"><fmt:formatNumber value="${item.price}" pattern="#,###"/>đ</div>
                                <div class="col-4 col-md-2 text-center fw-bold">${item.quantity}</div>
                                <div class="col-4 col-md-2 text-end text-dark fw-medium"><fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/>đ</div>
                            </div>
                        </c:forEach>

                        <div class="px-4 py-3 bg-light d-flex flex-wrap align-items-center border-top">
                            <div class="col-md-5 d-flex align-items-center mb-3 mb-md-0">
                                <span class="text-nowrap me-3 fw-bold">Lời nhắn:</span>
                                <input type="text" class="form-control" name="note" placeholder="Lưu ý cho quán (ít cay, nhiều tương...)">
                            </div>
                            <div class="col-md-7 d-flex justify-content-md-end align-items-center text-muted small">
                                <i class="fas fa-truck text-success me-2"></i> Đơn vị vận chuyển: <span class="text-dark fw-medium ms-1">Giao Tiêu Chuẩn</span>
                                <span class="ms-3 text-dark fw-bold"><fmt:formatNumber value="${shippingFee}" pattern="#,###"/>đ</span>
                            </div>
                        </div>
                    </div>

                    <div class="checkout-card mt-3">
                        <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                            <h5 class="fw-bold text-dark mb-0 me-4">Phương thức thanh toán</h5>
                            <div class="d-flex gap-3 flex-wrap">
                                <div>
                                    <input type="radio" name="paymentMethod" id="payCOD" value="COD" class="d-none payment-method-input" checked>
                                    <label class="payment-method-box mb-0 text-center fw-medium" for="payCOD">Tiền mặt (COD)</label>
                                </div>
                                <div>
                                    <input type="radio" name="paymentMethod" id="payTransfer" value="TRANSFER" class="d-none payment-method-input">
                                    <label class="payment-method-box mb-0 text-center fw-medium" for="payTransfer">Chuyển khoản</label>
                                </div>
                            </div>
                        </div>

                        <div class="row align-items-stretch mb-2">
                            <div class="col-lg-7 mb-4 mb-lg-0 pe-lg-4">
                                <div class="payment-details-container h-100">
                                    <div id="codDetails" class="bg-light p-4 rounded-1 border payment-detail-box h-100 d-flex align-items-center justify-content-center text-center">
                                        <p class="mb-0 text-muted small fw-bold">
                                            <i class="fas fa-info-circle me-2 text-primary-custom"></i>Thanh toán bằng tiền mặt khi nhận hàng.
                                        </p>
                                    </div>
                                    <div id="transferDetails" class="bg-light p-4 rounded-1 border payment-detail-box d-none h-100">
                                        <div class="d-flex flex-column align-items-center justify-content-center h-100">
                                            <p class="fw-bold mb-2 text-dark">Quét mã QR để thanh toán</p>
                                            <img src="https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg" alt="QR" class="img-fluid mb-2" style="width: 120px;">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-5 custom-border-start ps-lg-4">
                                <div class="d-flex flex-column justify-content-between h-100">
                                    <div>
                                        <div class="d-flex justify-content-between mb-2 text-muted fw-bold">
                                            <span>Tổng tiền hàng</span>
                                            <span><fmt:formatNumber value="${totalCartPrice}" pattern="#,###"/>đ</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2 text-muted fw-bold">
                                            <span>Phí vận chuyển</span>
                                            <span><fmt:formatNumber value="${shippingFee}" pattern="#,###"/>đ</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2 text-muted fw-bold">
                                            <span>Voucher giảm giá</span>
                                            <span class="text-danger">-<fmt:formatNumber value="${voucherDiscount}" pattern="#,###"/>đ</span>
                                        </div>
                                    </div>

                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center mb-3 pt-3 border-top">
                                            <span class="text-dark fw-bold fs-5">Tổng thanh toán</span>
                                            <span class="fw-bold text-danger fs-3"><fmt:formatNumber value="${finalPrice}" pattern="#,###"/>đ</span>
                                        </div>
                                        <button type="submit" class="btn btn-danger fw-bold shadow-sm w-100 py-3 fs-5">ĐẶT HÀNG NGAY</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const paymentRadios = document.querySelectorAll('.payment-method-input');
                const codDetails = document.getElementById('codDetails');
                const transferDetails = document.getElementById('transferDetails');

                paymentRadios.forEach(radio => {
                    radio.addEventListener('change', function () {
                        if (this.id === 'payCOD') {
                            codDetails.classList.remove('d-none');
                            transferDetails.classList.add('d-none');
                        } else {
                            codDetails.classList.add('d-none');
                            transferDetails.classList.remove('d-none');
                        }
                    });
                });
            });
        </script>
    </body>
</html>