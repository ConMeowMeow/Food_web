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
import java.io.File;

/**
 *
 * @author ConMeowMeow
 */
public class DeleteAvatar extends HttpServlet {

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
            out.println("<title>Servlet DeleteAvatar</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteAvatar at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect("DangNhap");
            return;
        }

        String currentAvatar = user.getAvatarUrl();
        String defaultAvatar = "./img/avt/default.png"; // Đường dẫn ảnh mặc định chuẩn

        // 1. Thử xóa file ảnh cũ trên ổ cứng ở cả thư mục BUILD và SRC
        if (currentAvatar != null && !currentAvatar.contains("default.png")) {
            try {
                // A. Xóa file ở thư mục BUILD (chạy runtime)
                String buildPath = getServletContext().getRealPath(currentAvatar);
                if (buildPath != null) {
                    File fileInBuild = new File(buildPath);
                    if (fileInBuild.exists()) {
                        fileInBuild.delete();
                    }
                }

                // B. Xóa file ở thư mục gốc SRC
                String uploadBuildDir = getServletContext().getRealPath("./img/avt");
                String uploadSrcDir = uploadBuildDir.replace("build" + File.separator + "web", "web")
                        .replace("target" + File.separator + "classes", "src" + File.separator + "main" + File.separator + "webapp");

                // Cắt lấy đúng tên file (ví dụ từ "./img/avt/3_abc.png" -> "3_abc.png")
                String fileName = currentAvatar.substring(currentAvatar.lastIndexOf("/") + 1);
                File fileInSrc = new File(uploadSrcDir + File.separator + fileName);

                if (fileInSrc.exists()) {
                    fileInSrc.delete();
                }

            } catch (Exception e) {
                System.err.println("Lỗi khi xóa file ảnh vật lý: " + e.getMessage());
            }
        }

        // 2. Cập nhật Database về lại ảnh mặc định
        try ( Connection conn = Connect.getConnection()) {
            if (conn != null) {
                UserDAO udao = new UserDAO(conn);

                boolean isUpdated = udao.updateAvatar(user.getId(), defaultAvatar);

                if (isUpdated) {
                    // 3. Cập nhật lại Session
                    user.setAvatarUrl(defaultAvatar);
                    session.setAttribute("userAccount", user);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi cập nhật SQL khi xóa ảnh: " + e.getMessage());
        }

        // Điều hướng về lại tab Hồ sơ
        response.sendRedirect("Profile?tab=chi-tiet");
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
