/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Admin;

import Controller.CategoryDAO;
import Model.Category;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.sql.*;

/**
 *
 * @author ConMeowMeow
 */
public class DeleteCategory extends HttpServlet {

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
            out.println("<title>Servlet DeleteCategory</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteCategory at " + request.getContextPath() + "</h1>");
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
        String idStr = request.getParameter("id");
        String message = "";

        if (idStr != null) {
            try ( Connection conn = Controller.Connect.getConnection()) {
                CategoryDAO dao = new CategoryDAO(conn);
                int id = Integer.parseInt(idStr);

                // CÁCH 1: Kiểm tra ràng buộc dữ liệu
                int productCount = dao.countProductsByCategory(id);

                if (productCount > 0) {
                    message = "Khong the xoa! Danh muc nay dang co " + productCount + " san pham.";
                } else {
                    // Tiến hành xóa file ảnh vật lý trước khi xóa DB
                    Category cat = dao.getCategoryById(id);
                    if (cat != null && cat.getImgUrl() != null) {

                        String imgPath = cat.getImgUrl();

                        // =========================
                        // XÓA FILE TRONG BUILD
                        // =========================
                        String buildPath = getServletContext()
                                .getRealPath("/") + imgPath;

                        File buildFile = new File(buildPath);

                        if (buildFile.exists()) {
                            buildFile.delete();
                            System.out.println("Deleted BUILD file: " + buildFile.getAbsolutePath());
                        }

                        // =========================
                        // XÓA FILE TRONG SRC
                        // =========================
                        try {

                            String srcPath = buildPath.replace(
                                    "build" + File.separator + "web",
                                    "web"
                            );

                            File srcFile = new File(srcPath);

                            if (srcFile.exists()) {
                                srcFile.delete();
                                System.out.println("Deleted SRC file: " + srcFile.getAbsolutePath());
                            }

                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    boolean deleted = dao.deleteCategory(id);
                    message = deleted ? "Xóa thành công!" : "L?i h? th?ng!";
                }

            } catch (Exception e) {
                e.printStackTrace();
                message = "Có l?i x?y ra: " + e.getMessage();
            }
        }

        // Gửi thông báo về trang danh sách (Sử dụng Session để thông báo sau khi Redirect)
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
