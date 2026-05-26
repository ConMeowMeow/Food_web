/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Controller.FavouriteDAO;
import Controller.*;
import Model.User;
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
public class YeuThich extends HttpServlet {

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
            out.println("<title>Servlet YeuThich</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet YeuThich at " + request.getContextPath() + "</h1>");
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
        String productId = request.getParameter("pid");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userAccount");

        // Kiểm tra nếu sản phẩm ID hợp lệ (tránh lỗi null)
        if (productId != null && !productId.isEmpty()) {
            if (user != null) {
                // 1. Đã đăng nhập: Lưu vào Database (gọi DAO)
                FavouriteDAO fdao = new FavouriteDAO(Connect.getConnection());
                fdao.addToFavourite(user.getId(), Integer.parseInt(productId));
            } else {
                // 2. Chưa đăng nhập: Lưu vào Session thay vì Cookie
                String favList = (String) session.getAttribute("favItems");

                if (favList == null || favList.isEmpty()) {
                    favList = productId;
                } else {
                    // Kiểm tra xem sản phẩm đã có trong chuỗi danh sách chưa để tránh trùng lặp
                    // Sử dụng regex hoặc split để kiểm tra chính xác ID (ví dụ tránh trùng "1" trong "11,12")
                    String[] items = favList.split(",");
                    boolean isExist = false;
                    for (String item : items) {
                        if (item.trim().equals(productId)) {
                            isExist = true;
                            break;
                        }
                    }
                    if (!isExist) {
                        favList += "," + productId;
                    }
                }
                // Cập nhật lại chuỗi danh sách vào session
                session.setAttribute("favItems", favList);
            }
        }

        response.sendRedirect("TrangChu.jsp");
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
        processRequest(request, response);
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
