/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Controller.CartDAO;
import Controller.Connect;
import Controller.OrderDAO;
import Controller.ProductDAO;
import Controller.SendMail;
import Model.CartItem;
import Model.Order;
import Model.OrderItem;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ConMeowMeow
 */
public class ThanhToan extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ThanhToan</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ThanhToan at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("ThanhToan.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect("DangNhap.jsp");
            return;
        }

        // 1. Lấy dữ liệu từ form người dùng nhập
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod"); // COD hoặc TRANSFER
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "COD"; // Mặc định là COD
        }
        try {
            // 2. Lấy giỏ hàng hiện tại của user
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.getCartItems(user.getId());

            if (cartItems == null || cartItems.isEmpty()) {
                response.sendRedirect("Cart.jsp");
                return;
            }

            // 3. Tính toán tiền
            double totalAmount = 0;
            for (CartItem item : cartItems) {
                totalAmount += item.getPrice() * item.getQuantity();
            }
            double shippingFee = 15000;
            double discountAmount = 20000;
            double finalAmount = totalAmount + shippingFee - discountAmount;

            // 4. Khởi tạo đối tượng Order
            Order order = new Order();
            order.setUserId(user.getId());
            order.setTotalAmount(totalAmount);
            order.setDiscountAmount(discountAmount);
            order.setFinalAmount(finalAmount);
            order.setStatus("PENDING"); // Đơn mới chờ duyệt
            order.setPaymentStatus(paymentMethod.equals("COD") ? "UNPAID" : "PENDING");
            order.setPaymentMethod(paymentMethod);

            // Nếu bạn muốn lưu tên, sđt, địa chỉ vào Order, class Order của bạn đã có sẵn các trường này
            order.setRecipientName(fullname);
            order.setPhone(phone);
            order.setAddressDetail(address);
            order.setNote(note);

            // 5. Chuyển CartItem thành OrderItem
            List<OrderItem> orderItemsList = new ArrayList<>();
            for (CartItem c : cartItems) {
                OrderItem oi = new OrderItem();
                oi.setProductId(c.getProductId());
                oi.setQuantity(c.getQuantity());
                oi.setPrice(c.getPrice());
                orderItemsList.add(oi);
            }

            // 6. Gọi DAO để lưu vào DB
            OrderDAO orderDAO = new OrderDAO();
            boolean isSuccess = orderDAO.createOrder(order, orderItemsList);

            if (isSuccess) {
                // SỬA: Dùng đúng tên biến là cartDAO
                CartDAO cartDAO_clear = new CartDAO(); 
                cartDAO_clear.clearCart(user.getId());

                // ===== THÊM ĐOẠN GỬI MAIL NÀY =====
                String subject = "Xác nhận đơn hàng #" + order.getOrderId() + " từ FastFood";

                StringBuilder body = new StringBuilder();
                body.append("<h2>Cảm ơn ").append(order.getRecipientName()).append(" đã đặt hàng!</h2>");
                body.append("<p>Mã đơn hàng: <b>#").append(order.getOrderId()).append("</b></p>");
                body.append("<p>Địa chỉ nhận: ").append(order.getAddressDetail()).append("</p>");
                body.append("<hr>");
                body.append("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                body.append("<tr style='background-color: #f2f2f2;'><th>Món ăn</th><th>Số lượng</th><th>Đơn giá</th></tr>");

                // SỬA: Dùng orderItemsList thay vì items
                for (OrderItem item : orderItemsList) { 
                    String productName = new ProductDAO(Connect.getConnection()).getProductById(item.getProductId()).getName();
                    
                    body.append("<tr>");
                    body.append("<td style='padding: 8px;'>").append(productName).append("</td>");
                    body.append("<td style='padding: 8px; text-align: center;'>").append(item.getQuantity()).append("</td>");
                    body.append("<td style='padding: 8px; text-align: right;'>").append(String.format("%,.0f", item.getPrice())).append(" đ</td>");
                    body.append("</tr>");
                }
                body.append("</table>");
                body.append("<p style='font-size: 16px;'>Tổng thanh toán: <b style='color: red;'>")
                    .append(String.format("%,.0f", order.getFinalAmount())).append(" VNĐ</b></p>");
                body.append("<p>Đơn hàng sẽ được giao trong 30-45 phút. Chúc bạn ngon miệng!</p>");

                // 3. Gửi mail
                SendMail.sendEmail(user.getEmail(), subject, body.toString());
                // ==================================

                response.sendRedirect("OrderSuccess.jsp");
            } else {
                response.getWriter().println("<h1>Đã xảy ra lỗi khi tạo đơn hàng!</h1>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h1>Lỗi Server!</h1>");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
