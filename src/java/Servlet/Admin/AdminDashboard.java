/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Admin;

import Controller.DashboardDAO;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.DecimalFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ConMeowMeow
 */
public class AdminDashboard extends HttpServlet {

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
            out.println("<title>Servlet AdminDashboard</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDashboard at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userAccount");
        
        // Nhớ check quyền Admin ở đây nhé (Ví dụ: if(user == null || !user.getRole().equals("admin")))
        
        DashboardDAO dao = new DashboardDAO();
        DecimalFormat currencyFormat = new DecimalFormat("#,###₫");
        DecimalFormat ratingFormat = new DecimalFormat("#.0");

        // 1. Đẩy các số liệu tổng quan vào request
        request.setAttribute("todayRevenue", currencyFormat.format(dao.getTodayRevenue()));
        request.setAttribute("newOrders", dao.getTodayNewOrders());
        request.setAttribute("pendingOrders", dao.getPendingOrders());
        request.setAttribute("totalCustomers", dao.getTotalCustomers());
        
        double[] fbStats = dao.getFeedbackStats();
        request.setAttribute("avgRating", ratingFormat.format(fbStats[0]));
        request.setAttribute("totalFeedbacks", (int) fbStats[1]);

        // 2. Xử lý thuật toán làm mượt dữ liệu cho Biểu đồ (Luôn có đủ 7 ngày kể cả khi ngày đó doanh thu = 0)
        LocalDate today = LocalDate.now();
        Map<String, Double> revenueMap = dao.get7DaysRevenue();
        
        List<String> labels = new ArrayList<>();
        List<Double> data = new ArrayList<>();
        
        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            String dbDateStr = date.toString(); // Định dạng YYYY-MM-DD để lấy từ Map
            
            labels.add("'" + date.format(DateTimeFormatter.ofPattern("dd/MM")) + "'"); // Ví dụ: '15/05'
            data.add(revenueMap.getOrDefault(dbDateStr, 0.0));
        }

        // Ép List thành chuỗi JSON mảng: ['10/05', '11/05'] và [2100000, 0, ...]
        request.setAttribute("chartLabels", "[" + String.join(",", labels) + "]");
        
        List<String> dataStringList = new ArrayList<>();
        for(Double d : data) dataStringList.add(String.valueOf(d));
        request.setAttribute("chartData", "[" + String.join(",", dataStringList) + "]");

        // Chuyển hướng tới trang index của admin
        request.getRequestDispatcher("admin/index.jsp").forward(request, response);
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
