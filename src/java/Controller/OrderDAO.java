/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import Model.Order;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ConMeowMeow
 */
public class OrderDAO {

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 1. Hàm lấy danh sách toàn bộ đơn hàng
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        // Đã sửa order_date thành created_at để khớp với MySQL
        String query = "SELECT * FROM orders ORDER BY created_at DESC";

        try {
            conn = Connect.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();

                // Map chính xác với các cột trong bảng orders hiện tại
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setCreatedAt(rs.getTimestamp("created_at")); // Fix lỗi Unknown column
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setDiscountAmount(rs.getDouble("discount_amount"));
                o.setFinalAmount(rs.getDouble("final_amount"));
                o.setStatus(rs.getString("status"));
                o.setPaymentStatus(rs.getString("payment_status"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setPromotionId(rs.getInt("promotion_id"));
                o.setAddressId(rs.getInt("address_id"));

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
        return list;
    }

    // 2. Hàm cập nhật trạng thái đơn hàng
    public void updateOrderStatus(int orderId, String newStatus) {
        String query = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try {
            conn = Connect.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }
}
