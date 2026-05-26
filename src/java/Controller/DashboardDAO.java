/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
/**
 *
 * @author ConMeowMeow
 */
public class DashboardDAO {
    // 1. Lấy Doanh thu hôm nay
    public double getTodayRevenue() {
        // Cần đổi 'total_price', 'orders', 'created_at' thành tên cột/bảng của bạn
        String sql = "SELECT SUM(total_price) FROM orders WHERE DATE(created_at) = CURDATE() AND status = 'completed'";
        try (Connection con = Connect.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 2. Đếm số đơn hàng mới hôm nay
    public int getTodayNewOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()";
        try (Connection con = Connect.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 3. Đếm số đơn hàng đang chờ xử lý
    public int getPendingOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'pending'"; // Thay 'pending' bằng trạng thái chờ của bạn
        try (Connection con = Connect.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 4. Lấy tổng số Khách hàng
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'user'";
        try (Connection con = Connect.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 5. Lấy điểm đánh giá trung bình & Tổng số phản hồi
    public double[] getFeedbackStats() {
        // Trả về mảng 2 phần tử: [0] = Điểm trung bình, [1] = Tổng số đánh giá
        String sql = "SELECT AVG(rating), COUNT(*) FROM feedback"; // Thay bằng bảng feedback của bạn
        try (Connection con = Connect.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new double[]{ rs.getDouble(1), rs.getDouble(2) };
            }
        } catch (Exception e) { e.printStackTrace(); }
        return new double[]{0, 0};
    }

    // 6. Lấy Doanh thu 7 ngày gần nhất để vẽ Biểu đồ Chart.js
    public Map<String, Double> get7DaysRevenue() {
        Map<String, Double> map = new HashMap<>();
        String sql = "SELECT DATE(created_at) as order_date, SUM(total_price) as total " +
                     "FROM orders " +
                     "WHERE created_at >= DATE(NOW()) - INTERVAL 6 DAY AND status = 'completed' " +
                     "GROUP BY DATE(created_at)";
        try (Connection con = Connect.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("order_date"), rs.getDouble("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }
}
