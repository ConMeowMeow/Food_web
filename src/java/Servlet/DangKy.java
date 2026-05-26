/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Controller.*;
import Controller.UserDAO;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.util.Random;

/**
 *
 * @author ConMeowMeow
 */
public class DangKy extends HttpServlet {

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
            out.println("<title>Servlet DangKy</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DangKy at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("DangKy.jsp").forward(request, response);
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
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String addressDetail = request.getParameter("address");

        // VALIDATE
        if (email == null || email.trim().isEmpty()
                || fullname == null || fullname.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || addressDetail == null || addressDetail.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = Connect.getConnection();
            UserDAO dao = new UserDAO(conn);

            // Kiểm tra email tồn tại trong DB chưa
            if (dao.checkEmailExists(email)) {
                request.setAttribute("error", "Email đã tồn tại!");
                request.getRequestDispatcher("DangKy.jsp").forward(request, response);
                return;
            }

            // 1. Sinh mã OTP ngẫu nhiên 6 số
            Random rnd = new Random();
            int number = rnd.nextInt(999999);
            String otpCode = String.format("%06d", number);

            // 2. Gửi mã OTP qua email
            EmailOTP emailOTP = new EmailOTP();
            emailOTP.sendOTP(email, otpCode);

            // 3. Tính thời gian hết hạn (15 phút)
            long expiryTime = System.currentTimeMillis() + (15 * 60 * 1000);

            // 4. Mã hóa mật khẩu trước khi lưu tạm
            String encryptedPassword = EncryptPass.convertToSHA256(password);

            // 5. Lưu tất cả thông tin vào Session để chờ xác thực
            HttpSession session = request.getSession();
            session.setAttribute("tempEmail", email);
            session.setAttribute("tempFullname", fullname);
            session.setAttribute("tempPhone", phone);
            session.setAttribute("tempPassword", encryptedPassword);
            session.setAttribute("tempAddress", addressDetail);

            session.setAttribute("savedOTP", otpCode);
            session.setAttribute("otpExpiryTime", expiryTime);

            // Phân biệt mục đích sử dụng OTP (Đăng ký, Đổi mật khẩu, Xóa tài khoản)
            session.setAttribute("otpAction", "register");

            // 6. Chuyển hướng sang trang xác nhận OTP
            response.sendRedirect("XacNhanOTP");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống khi gửi email: " + e.getMessage());
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
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
