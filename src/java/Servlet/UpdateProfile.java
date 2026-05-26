/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Controller.Connect;
import Controller.UserDAO;
import jakarta.servlet.annotation.MultipartConfig;
import java.sql.*;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;

/**
 *
 * @author ConMeowMeow
 */
@WebServlet(name = "UpdateProfile", urlPatterns = {"/UpdateProfile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB (Kích thước bộ nhớ đệm)
        maxFileSize = 1024 * 1024 * 10, // 10MB (Kích thước tối đa 1 file)
        maxRequestSize = 1024 * 1024 * 50 // 50MB (Kích thước tối đa của toàn bộ request)
)
public class UpdateProfile extends HttpServlet {

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
            out.println("<title>Servlet UpdateProfile</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProfile at " + request.getContextPath() + "</h1>");
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

        String username = request.getParameter("tenDangNhap");
        String fullName = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String phone = request.getParameter("sdt");
        String gender = request.getParameter("gioiTinh");
        String birthday = request.getParameter("ngaySinh");

        // Xử lý upload avatar
        Part filePart = request.getPart("avatarInput");
        String avatarPath = user.getAvatarUrl();

        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String fileExtension = "";
            int lastDot = submittedFileName.lastIndexOf('.');
            if (lastDot >= 0) {
                fileExtension = submittedFileName.substring(lastDot);
            }

            // Đặt tên file theo định dạng: userID.extension (Ví dụ: 3.png)
            String fileName = user.getId() + fileExtension;

            // 1. Lưu vào thư mục BUILD chạy runtime
            String uploadBuildPath = getServletContext().getRealPath("./img/avt");
            File buildDir = new File(uploadBuildPath);
            if (!buildDir.exists()) {
                buildDir.mkdirs();
            }
            String fileBuildLocation = uploadBuildPath + File.separator + fileName;
            java.io.InputStream is = filePart.getInputStream();
            java.nio.file.Files.copy(is, new java.io.File(fileBuildLocation).toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);

            // 2. Sao lưu vào thư mục gốc SRC chống Clean & Build mất ảnh
            try {
                String uploadSrcPath = uploadBuildPath.replace("build" + File.separator + "web", "web")
                        .replace("target" + File.separator + "classes", "src" + File.separator + "main" + File.separator + "webapp");

                File srcDir = new File(uploadSrcPath);
                if (!srcDir.exists()) {
                    srcDir.mkdirs();
                }

                File fileInBuild = new File(fileBuildLocation);
                File fileInSrc = new File(uploadSrcPath + File.separator + fileName);

                java.nio.file.Files.copy(
                        fileInBuild.toPath(),
                        fileInSrc.toPath(),
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING
                );

                // Chỉ cập nhật path mới nếu quá trình lưu file hoàn toàn thành công
                avatarPath = "./img/avt/" + fileName;

            } catch (Exception e) {
                System.err.println("Lưu bản sao vào thư mục src thất bại: " + e.getMessage());
                // Không đổi avatarPath nếu việc copy dự phòng lỗi để tránh mất dấu ảnh cũ
            }
        }

        // Cập nhật thuộc tính của object user hiện tại trên Session
        user.setUsername(username);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setGender(gender);
        user.setBirthday(birthday);
        user.setAvatarUrl(avatarPath);

        // Lưu thông tin thay đổi xuống Database (Áp dụng try-with-resources để tự đóng Connection)
        try ( Connection conn = Connect.getConnection()) {
            if (conn != null) {
                UserDAO udao = new UserDAO(conn);
                boolean updated = udao.updateProfile(user);

                if (updated) {
                    // Đồng bộ lại dữ liệu mới lên Session sau khi DB cập nhật thành công
                    session.setAttribute("userAccount", user);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối hoặc cập nhật Database: " + e.getMessage());
        }

        // Điều hướng ngược lại trang Profile cá nhân
        response.sendRedirect("Profile");
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
