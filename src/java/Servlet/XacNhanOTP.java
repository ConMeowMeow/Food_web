/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import Model.*;
import Controller.*;
import java.util.Random;

/**
 *
 * @author ConMeowMeow
 */
public class XacNhanOTP extends HttpServlet {

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
            out.println("<title>Servlet OTP</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OTP at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("tempEmail");
        String otpAction = (String) session.getAttribute("otpAction");

        // Nếu không tìm thấy thông tin email tạm
        if (email == null || otpAction == null) {
            request.setAttribute("error", "Không tìm thấy thông tin yêu cầu gửi lại mã!");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        try {
            // 1. Tạo một mã OTP 6 số mới
            Random rnd = new Random();
            String newOtpCode = String.format("%06d", rnd.nextInt(999999));

            // 2. Gửi lại Email 
            EmailOTP emailHelper = new EmailOTP();
            emailHelper.sendOTP(email, newOtpCode);

            // 3. Gia hạn lại thời gian hết hạn mới (+15 phút)
            long newExpiryTime = System.currentTimeMillis() + (15 * 60 * 1000);

            // 4. Cập nhật lại Session
            session.setAttribute("savedOTP", newOtpCode);
            session.setAttribute("otpExpiryTime", newExpiryTime);

            // 5. Thông báo thành công và load lại trang OTP
            request.setAttribute("message", "Mã OTP mới đã được gửi thành công!");
            request.getRequestDispatcher("XacNhanOTP.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi gửi email: " + e.getMessage());
            request.getRequestDispatcher("XacNhanOTP.jsp").forward(request, response);
        }
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
        HttpSession session = request.getSession();
        String userOTP = request.getParameter("fullOTP");

        String savedOTP = (String) session.getAttribute("savedOTP");
        Long expiryTime = (Long) session.getAttribute("otpExpiryTime");
        String otpAction = (String) session.getAttribute("otpAction");

        // 1. Kiểm tra tính hợp lệ của Session
        if (savedOTP == null || expiryTime == null || otpAction == null) {
            request.setAttribute("error", "Phiên xác thực đã hết hạn hoặc không hợp lệ. Vui lòng thử lại!");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra thời gian hết hạn (15 phút)
        long currentTime = System.currentTimeMillis();
        if (currentTime > expiryTime) {
            request.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng quay lại và đăng ký lại.");
            // Xóa session dọn dẹp
            session.removeAttribute("savedOTP");
            request.getRequestDispatcher("XacNhanOTP.jsp").forward(request, response);
            return;
        }

        // 3. So sánh mã XacNhanOTP
        if (savedOTP.equals(userOTP)) {
            // Xác thực thành công

            if ("register".equals(otpAction)) {
                // Xử lý logic lưu Database cho việc Đăng ký
                String email = (String) session.getAttribute("tempEmail");
                String fullname = (String) session.getAttribute("tempFullname");
                String phone = (String) session.getAttribute("tempPhone");
                String password = (String) session.getAttribute("tempPassword");
                String address = (String) session.getAttribute("tempAddress");

                Connection conn = null;
                try {
                    conn = Connect.getConnection();
                    UserDAO dao = new UserDAO(conn);

                    User user = dao.signup(email, password, fullname, phone, address);

                    if (user != null) {
                        // Đăng ký thành công, xóa dữ liệu rác trong session
                        session.removeAttribute("tempEmail");
                        session.removeAttribute("tempFullname");
                        session.removeAttribute("tempPhone");
                        session.removeAttribute("tempPassword");
                        session.removeAttribute("tempAddress");
                        session.removeAttribute("savedOTP");
                        session.removeAttribute("otpExpiryTime");
                        session.removeAttribute("otpAction");

                        // Lưu session đăng nhập chính thức
                        session.setAttribute("userAccount", user);
                        response.sendRedirect("TrangChu");
                    } else {
                        request.setAttribute("error", "Lưu thông tin thất bại. Vui lòng thử lại!");
                        request.getRequestDispatcher("XacNhanOTP.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi DB: " + e.getMessage());
                    request.getRequestDispatcher("XacNhanOTP.jsp").forward(request, response);
                } finally {
                    try {
                        if (conn != null && !conn.isClosed()) {
                            conn.close();
                        }
                    } catch (Exception e) {
                    }
                }
            }
            // Bạn có thể dùng `else if ("delete_account".equals(otpAction))` ở đây cho tính năng khác

        } else {
            // Nhập sai XacNhanOTP
            request.setAttribute("error", "Mã OTP không chính xác!");
            request.getRequestDispatcher("XacNhanOTP.jsp").forward(request, response);
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
