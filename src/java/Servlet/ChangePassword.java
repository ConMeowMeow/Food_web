/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Controller.Connect;
import Controller.UserDAO;
import Model.User;
import java.sql.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ConMeowMeow
 */
public class ChangePassword extends HttpServlet {

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
            out.println("<title>Servlet ChangePassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePassword at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
            response.sendRedirect("DangNhap");
            return;
        }

        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        // 1. Kiểm tra xác nhận mật khẩu
        if (!newPass.equals(confirmPass)) {
            session.setAttribute("msgError", "Mật khẩu xác nhận không khớp!");
            response.sendRedirect("Profile?tab=mat-khau");
            return;
        }

        // 2. Mở Connection và gọi DAO
        try ( Connection conn = Connect.getConnection()) {
            if (conn != null) {
                UserDAO udao = new UserDAO(conn);

                // 3. Kiểm tra mật khẩu cũ
                if (!udao.checkOldPassword(user.getId(), oldPass)) {
                    session.setAttribute("msgError", "Mật khẩu cũ không chính xác!");
                    response.sendRedirect("Profile?tab=mat-khau");
                    return;
                }

                // 4. Đổi sang mật khẩu mới
                boolean isUpdated = udao.updatePassword(user.getId(), newPass);

                if (isUpdated) {
                    session.setAttribute("msgSuccess", "Đổi mật khẩu thành công!");
                } else {
                    session.setAttribute("msgError", "Đã xảy ra lỗi hệ thống, vui lòng thử lại!");
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi đổi mật khẩu: " + e.getMessage());
        }

        // Đổi xong điều hướng về tab mật khẩu
        response.sendRedirect("Profile?tab=mat-khau");
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
