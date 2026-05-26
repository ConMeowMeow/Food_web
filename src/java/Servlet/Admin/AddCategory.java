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
import java.util.List;
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
public class AddCategory extends HttpServlet {

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
            out.println("<title>Servlet AddCategory</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddCategory at " + request.getContextPath() + "</h1>");
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

            // --- BẮT ĐẦU THUẬT TOÁN PHÂN TRANG ---
            int page = 1; // Trang mặc định là 1
            int recordsPerPage = 4; // Cấu hình: Hiển thị 4 danh mục trên 1 trang (bạn có thể tự đổi)

            // Nếu người dùng có click vào số trang (VD: ?page=2), thì lấy số đó
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            // Tính toán các thông số
            int totalRecords = categoryDAO.getTotalCategoryCount(); // Tổng danh mục
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage); // Tổng số trang
            int offset = (page - 1) * recordsPerPage; // Vị trí bắt đầu cắt dữ liệu

            // Lấy danh sách danh mục TƯƠNG ỨNG VỚI TRANG ĐÓ
            List<Category> categoryList = categoryDAO.getCategoriesByPage(offset, recordsPerPage);

            // Gắn toàn bộ dữ liệu vào Request để đẩy sang JSP
            request.setAttribute("listCategories", categoryList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalRecords", totalRecords);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Chuyển hướng sang giao diện JSP
        request.getRequestDispatcher("/admin/AddCategory.jsp").forward(request, response);
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
        response.setCharacterEncoding("UTF-8");

        // 1. Lấy thông tin text từ form
        String categoryName = request.getParameter("categoryName");
        String categoryStatus = request.getParameter("categoryStatus");

        // 2. Xử lý upload file ảnh (PHẢI khai báo biến Part ở đây)
        Part part = request.getPart("categoryImage");
        String imgUrl = ""; // Khai báo biến lưu đường dẫn để dùng cho DB

        // Lấy đường dẫn đến thư mục build (thư mục đang chạy)
        String uploadPathBuild = getServletContext().getRealPath("/img/categories");
        File dirBuild = new File(uploadPathBuild);
        if (!dirBuild.exists()) {
            dirBuild.mkdirs();
        }

        // Lấy đường dẫn động đến thư mục src (dành cho môi trường dev)
        String contextPath = getServletContext().getRealPath("/");
        File projectRoot = new File(contextPath).getParentFile().getParentFile();

        String uploadPathSrc = projectRoot.getAbsolutePath() + File.separator + "web"
                + File.separator + "img" + File.separator + "categories";
        File dirSrc = new File(uploadPathSrc);
        // Lưu ý: Không nên tự mkdirs cho src nếu nó không tồn tại (để tránh lỗi khi deploy thật)

        // --- Tiến hành lưu file ---
        if (part != null && part.getSize() > 0) {
            String originalName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            String fileName = System.currentTimeMillis() + "_" + originalName;

            File fileBuild = new File(dirBuild, fileName);

            // Lưu vào Build trước
            try ( InputStream input = part.getInputStream()) {
                Files.copy(input, fileBuild.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // Nếu thư mục src tồn tại (môi trường NetBeans) thì copy từ Build sang Src
            if (dirSrc.exists()) {
                File fileSrc = new File(dirSrc, fileName);
                Files.copy(fileBuild.toPath(), fileSrc.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            imgUrl = "img/categories/" + fileName;
        }

        // 3. Tạo đối tượng Category và lưu vào DB
        Category newCat = new Category();
        newCat.setCategoryName(categoryName);
        newCat.setStatus(categoryStatus);
        newCat.setImgUrl(imgUrl);

        try ( java.sql.Connection conn = Controller.Connect.getConnection()) {
            CategoryDAO dao = new CategoryDAO(conn);
            dao.addCategory(newCat);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 4. Reload lại trang
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
