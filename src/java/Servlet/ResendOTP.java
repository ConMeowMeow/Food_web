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

/**
 *
 * @author ConMeowMeow
 */
public class ResendOTP extends HttpServlet {

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
            out.println("<title>Servlet ResendOTP</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ResendOTP at " + request.getContextPath() + "</h1>");
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
        response.sendRedirect("TrangChu");
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

        // 1. Kiểm tra session có tồn tại dữ liệu OTP không
        if (savedOTP == null || expiryTime == null || otpAction == null) {
            request.setAttribute("error", "Phiên xác thực không hợp lệ hoặc đã hết hạn!");
            request.getRequestDispatcher("DangKy.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra thời gian hết hạn 15 phút
        if (System.currentTimeMillis() > expiryTime) {
            request.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng thực hiện lại quy trình.");
            session.removeAttribute("savedOTP");
            request.getRequestDispatcher("XacNhanOTP.jsp").forward(request, response);
            return;
        }

        // 3. Đối chiếu mã OTP người dùng nhập
        if (savedOTP.equals(userOTP)) {
            // Khớp mã OTP -> Phân luồng hành động dựa trên hành vi (otpAction)
            if ("register".equals(otpAction)) {
                String email = (String) session.getAttribute("tempEmail");
                String fullname = (String) session.getAttribute("tempFullname");
                String phone = (String) session.getAttribute("tempPhone");
                String password = (String) session.getAttribute("tempPassword");
                String address = (String) session.getAttribute("tempAddress");

                Connection conn = null;
                try {
                    conn = Connect.getConnection();
                    UserDAO dao = new UserDAO(conn);

                    // Lưu chính thức vào SQL Server
                    User user = dao.signup(email, password, fullname, phone, address);

                    if (user != null) {
                        // Dọn dẹp session tạm thời ngay lập tức
                        session.removeAttribute("tempEmail");
                        session.removeAttribute("tempFullname");
                        session.removeAttribute("tempPhone");
                        session.removeAttribute("tempPassword");
                        session.removeAttribute("tempAddress");
                        session.removeAttribute("savedOTP");
                        session.removeAttribute("otpExpiryTime");
                        session.removeAttribute("otpAction");

                        // Lưu session đăng nhập chính thức cho người dùng
                        session.setAttribute("userAccount", user);
                        response.sendRedirect("TrangChu");
                    } else {
                        request.setAttribute("error", "Lỗi tạo tài khoản hệ thống. Thử lại sau!");
                        request.getRequestDispatcher("XacNhanOTP.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
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
            // Mở rộng thêm logic xóa tài khoản hoặc đổi mật khẩu tại đây bằng các block else if tương tự
        } else {
            request.setAttribute("error", "Mã xác thực OTP không chính xác!");
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
