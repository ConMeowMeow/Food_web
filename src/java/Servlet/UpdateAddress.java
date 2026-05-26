/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Controller.AddressDAO;
import Model.Address;
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
public class UpdateAddress extends HttpServlet {

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
            out.println("<title>Servlet UpdateAddress</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateAddress at " + request.getContextPath() + "</h1>");
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

        try {
            // Lấy ID địa chỉ được gửi ngầm từ JS
            int addressId = Integer.parseInt(request.getParameter("addressId"));

            Address updateAddr = new Address();
            updateAddr.setAddressId(addressId);
            updateAddr.setUserId(user.getId());
            updateAddr.setRecipientName(request.getParameter("recipientName"));
            updateAddr.setPhone(request.getParameter("phone"));
            updateAddr.setProvince(request.getParameter("province"));
            updateAddr.setDistrict(request.getParameter("district"));
            updateAddr.setWard(request.getParameter("ward"));
            updateAddr.setAddressDetail(request.getParameter("addressDetail"));

            AddressDAO dao = new AddressDAO();
            dao.updateAddress(updateAddr);

        } catch (NumberFormatException e) {
            System.err.println("Lỗi ID khi cập nhật: " + e.getMessage());
        }

        // Cập nhật xong nhảy về đúng tab Địa chỉ
        response.sendRedirect("Profile?tab=address");
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
