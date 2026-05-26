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
public class AddAddress extends HttpServlet {

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
            out.println("<title>Servlet AddAdress</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddAdress at " + request.getContextPath() + "</h1>");
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

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("DangNhap");
            return;
        }

        // Lấy dữ liệu từ form JSP
        String recipientName = request.getParameter("recipientName"); 
        String phone = request.getParameter("phone");
        String addressDetail = request.getParameter("addressDetail");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");

        // Tạo đối tượng Address và set giá trị
        Address newAddress = new Address();
        newAddress.setUserId(user.getId());
        newAddress.setRecipientName(recipientName);
        newAddress.setPhone(phone);
        newAddress.setProvince(province);
        newAddress.setDistrict(district);
        newAddress.setWard(ward);

        newAddress.setAddressDetail(addressDetail);
        newAddress.setIsDefault((short) 0); // Mặc định không phải địa chỉ chính (0)

        // Gọi DAO để lưu vào DB
        AddressDAO dao = new AddressDAO();
        boolean isSuccess = dao.addAddress(newAddress);

        if (isSuccess) {
            // (Tùy chọn) Có thể set một biến session để hiển thị thông báo thành công ở trang JSP
            session.setAttribute("msgSuccess", "Thêm địa chỉ thành công!");
        } else {
            session.setAttribute("msgError", "Đã xảy ra lỗi khi thêm địa chỉ!");
        }

        // Điều hướng về lại trang cá nhân
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
