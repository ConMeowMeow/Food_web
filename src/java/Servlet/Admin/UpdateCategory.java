/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Admin;

import Controller.CategoryDAO;
import Controller.Connect;
import Model.Category;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.*;
/**
 *
 * @author ConMeowMeow
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UpdateCategory extends HttpServlet {

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
            out.println("<title>Servlet UpdateCategory</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateCategory at " + request.getContextPath() + "</h1>");
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
        response.setContentType("text/html;charset=UTF-8");
        String message = "";

        try (Connection conn = Connect.getConnection()) {
            CategoryDAO dao = new CategoryDAO(conn);

            // 1. Lấy dữ liệu từ Form Modal
            int categoryId = Integer.parseInt(request.getParameter("editCategoryId"));
            String categoryName = request.getParameter("editCategoryName");
            String status = request.getParameter("editCategoryStatus"); // 'Active' hoặc 'Inactive'
            
            // Lấy danh mục cũ từ DB để dự phòng link ảnh
            Category oldCategory = dao.getCategoryById(categoryId);
            String finalImageUrl = oldCategory.getImgUrl(); 

            // 2. Xử lý File Ảnh (Nếu có chọn ảnh mới)
            Part filePart = request.getPart("editCategoryImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                finalImageUrl = "img/categories/" + uniqueFileName;

                // -- Đồng bộ ảnh vào Build và Source --
                String buildDirPath = getServletContext().getRealPath("");
                File buildFile = new File(buildDirPath, finalImageUrl);

                File projectRootDir = new File(buildDirPath).getParentFile().getParentFile();
                File srcFile = new File(projectRootDir, "web" + File.separator + finalImageUrl);

                if (!buildFile.getParentFile().exists()) buildFile.getParentFile().mkdirs();
                if (!srcFile.getParentFile().exists()) srcFile.getParentFile().mkdirs();

                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, buildFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                Files.copy(buildFile.toPath(), srcFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // 3. Cập nhật Model và lưu vào CSDL
            Category c = new Category();
            c.setCategoryId(categoryId);
            c.setCategoryName(categoryName);
            c.setStatus(status.equals("true") ? "Active" : "Inactive"); // Xử lý logic true/false từ form của bạn
            c.setImgUrl(finalImageUrl);

            boolean updated = dao.updateCategory(c);
            message = updated ? "Cập nhật danh mục thành công!" : "Lỗi hệ thống! Không thể cập nhật.";

        } catch (Exception e) {
            e.printStackTrace();
            message = "Có lỗi xảy ra: " + e.getMessage();
        }

        // 4. Trả về thông báo và quay lại trang
        request.getSession().setAttribute("msg", message);
        response.sendRedirect(request.getContextPath() + "/AddCategory");
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
