/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Admin;

import Controller.Connect;
import Controller.ProductDAO;
import Model.Product;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
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
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UpdateProduct extends HttpServlet {

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
            out.println("<title>Servlet UpdateProduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProduct at " + request.getContextPath() + "</h1>");
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

        try ( Connection conn = Connect.getConnection()) {
            ProductDAO dao = new ProductDAO(conn);

            // 1. Thu thập dữ liệu Text từ Modal Form
            String idStr = request.getParameter("editProductId");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.getSession().setAttribute("msg", "Lỗi: Không xác định được mã món ăn cần sửa!");
                response.sendRedirect(request.getContextPath() + "/ViewProduct");
                return;
            }

            int productId = Integer.parseInt(idStr);
            String title = request.getParameter("editTitle");
            int categoryId = Integer.parseInt(request.getParameter("editCategory"));
            double price = Double.parseDouble(request.getParameter("editPrice"));

            String discountStr = request.getParameter("editDiscount");
            double discount = (discountStr != null && !discountStr.isEmpty()) ? Double.parseDouble(discountStr) : 0.0;

            int stock = Integer.parseInt(request.getParameter("editStock"));
            String statusStr = request.getParameter("editStatusRadio");
            int status = (statusStr != null && statusStr.equals("active")) ? 1 : 0;

            // Lấy thông tin sản phẩm gốc từ CSDL để giữ lại link ảnh nếu admin không upload ảnh mới
            Product oldProduct = dao.getProductById(productId);
            String finalImageUrl = oldProduct.getImageUrl();

            // 2. Xử lý Upload Ảnh (Nếu admin có tải file mới lên)
            Part filePart = request.getPart("editImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                finalImageUrl = "img/products/" + uniqueFileName;

                // -- Đồng bộ thư mục --
                String buildDirPath = getServletContext().getRealPath("");
                File buildFile = new File(buildDirPath, finalImageUrl);

                File projectRootDir = new File(buildDirPath).getParentFile().getParentFile();
                File srcFile = new File(projectRootDir, "web" + File.separator + finalImageUrl);

                if (!buildFile.getParentFile().exists()) {
                    buildFile.getParentFile().mkdirs();
                }
                if (!srcFile.getParentFile().exists()) {
                    srcFile.getParentFile().mkdirs();
                }

                try ( InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, buildFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                Files.copy(buildFile.toPath(), srcFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // 3. Đóng gói dữ liệu vào Model và gọi DAO cập nhật
            Product p = new Product();
            p.setProductId(productId);
            p.setName(title);
            p.setCagetoryId(categoryId);
            p.setPrice(price);
            p.setDiscount(discount);
            p.setStock(stock);
            p.setImageUrl(finalImageUrl);
            p.setStatus(status);

            boolean isUpdated = dao.updateProduct(p);
            message = isUpdated ? "Cập nhật thành công món: " + title : "Lỗi hệ thống! Không thể cập nhật cơ sở dữ liệu.";

        } catch (Exception e) {
            e.printStackTrace();
            message = "Có lỗi xảy ra: " + e.getMessage();
        }

        // 4. Lưu thông báo và tải lại trang Xem Món
        request.getSession().setAttribute("msg", message);
        response.sendRedirect(request.getContextPath() + "/ViewProduct");
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
