/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Admin;

import Controller.CategoryDAO;
import Controller.Connect;
import Controller.ProductDAO;
import Model.Category;
import Model.Product;
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
import java.util.List;

/**
 *
 * @author ConMeowMeow
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB - Bộ nhớ đệm tạm thời
        maxFileSize = 1024 * 1024 * 10, // 10MB - Kích thước tối đa của 1 file
        maxRequestSize = 1024 * 1024 * 50 // 50MB - Kích thước tối đa của toàn bộ form
)
public class AddProduct extends HttpServlet {

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
            out.println("<title>Servlet AddProduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddProduct at " + request.getContextPath() + "</h1>");
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
        try ( Connection conn = Connect.getConnection()) {
            CategoryDAO categoryDAO = new CategoryDAO(conn);
            List<Category> categoryList = categoryDAO.getAllCategories();

            // Gắn danh sách vào request để truyền sang JSP
            request.setAttribute("categoryList", categoryList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Chuyển hướng sang trang JSP (Lưu ý: URL truy cập bây giờ phải là /AddProductServlet)
        request.getRequestDispatcher("/admin/AddProduct.jsp").forward(request, response);
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

        try {
            // 1. Thu thập dữ liệu Form
            String title = request.getParameter("productTitle");
            String desc = request.getParameter("productDesc");
            int categoryId = Integer.parseInt(request.getParameter("productCategory"));
            double price = Double.parseDouble(request.getParameter("productPrice"));
            int stock = Integer.parseInt(request.getParameter("productStock"));
            double discount = 0.0;
            String statusStr = request.getParameter("productStatus");
            int status = (statusStr != null && statusStr.equals("active")) ? 1 : 0;

            // 2. Xử lý File Ảnh (Gộp chung logic lưu ảnh)
            Part filePart = request.getPart("productImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String relativePath = "img/products/" + uniqueFileName;

            // -- Lấy đường dẫn thư mục Build đang chạy --
            String buildDirPath = getServletContext().getRealPath("");
            File buildFile = new File(buildDirPath, relativePath);

            // -- Lùi về thư mục gốc để tìm thư mục Source (web/) --
            File projectRootDir = new File(buildDirPath).getParentFile().getParentFile();
            File srcFile = new File(projectRootDir, "web" + File.separator + relativePath);

            // Tự động tạo thư mục img/products nếu chưa tồn tại
            if (!buildFile.getParentFile().exists()) {
                buildFile.getParentFile().mkdirs();
            }
            if (!srcFile.getParentFile().exists()) {
                srcFile.getParentFile().mkdirs();
            }

            // Ghi file ảnh vào thư mục Build để load lên trình duyệt ngay lập tức
            try ( InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, buildFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // Copy file vừa lưu sang thư mục Source để không bị mất khi Clean & Build
            Files.copy(buildFile.toPath(), srcFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

            System.out.println("Đã lưu ảnh (Build): " + buildFile.getAbsolutePath());
            System.out.println("Đã lưu ảnh (Source): " + srcFile.getAbsolutePath());

            // 3. Kết nối CSDL và lưu dữ liệu
            try ( Connection conn = Connect.getConnection()) {
                ProductDAO dao = new ProductDAO(conn);

                Product p = new Product();
                p.setName(title);
                p.setDescription(desc);
                p.setPrice(price);
                p.setDiscount(discount);
                p.setStock(stock);
                p.setCagetoryId(categoryId);
                p.setImageUrl(relativePath);
                p.setStatus(status);

                boolean success = dao.insertProduct(p);
                message = success ? "Thêm món ăn '" + title + "' thành công!" : "Lỗi hệ thống! Không thể lưu sản phẩm.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            message = "Có lỗi xảy ra: " + e.getMessage();
        }

        // 4. Trả về thông báo và chuyển hướng
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
