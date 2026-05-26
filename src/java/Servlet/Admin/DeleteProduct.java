/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Admin;

import Controller.Connect;
import Controller.ProductDAO;
import Model.Product;
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
public class DeleteProduct extends HttpServlet {

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
            out.println("<title>Servlet DeleteProduct</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteProduct at " + request.getContextPath() + "</h1>");
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
            try (Connection conn = Connect.getConnection()) {
                ProductDAO dao = new ProductDAO(conn);
                int id = Integer.parseInt(idStr);

                // 1. Lấy thông tin sản phẩm để tiến hành xóa file ảnh vật lý trước
                Product p = dao.getProductById(id);
                if (p != null && p.getImageUrl() != null && !p.getImageUrl().isEmpty()) {
                    deletePhysicalFile(p.getImageUrl());
                }

                // 2. Tiến hành xóa dữ liệu trong DB
                boolean deleted = dao.deleteProduct(id);
                message = deleted ? "Xoa mon an thanh cong!" : "Loi he thong! Khong the xoa.";

            } catch (Exception e) {
                e.printStackTrace();
                message = "Co loi xay ra: " + e.getMessage();
            }
        }

        // Lưu thông báo vào Session và điều hướng quay lại trang danh sách
        request.getSession().setAttribute("msg", message);
        response.sendRedirect(request.getContextPath() + "/ViewProduct");
    }

    private void deletePhysicalFile(String imgPath) {
        // Tránh xóa nhầm ảnh hệ thống hoặc link ảnh online từ Unsplash
        if (imgPath.contains("default.png") || imgPath.startsWith("http")) return;

        try {
            // Xóa trong thư mục build chạy tạm thời của GlassFish
            String buildPath = getServletContext().getRealPath("/") + imgPath;
            File fileInBuild = new File(buildPath);
            if (fileInBuild.exists()) fileInBuild.delete();

            // Xóa trực tiếp trong thư mục mã nguồn gốc src của bạn
            String srcPath = "D:/Study/JavaWeb/FastFood/web/" + imgPath;
            File fileInSrc = new File(srcPath);
            if (fileInSrc.exists()) fileInSrc.delete();
        } catch (Exception e) {
            e.printStackTrace();
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
