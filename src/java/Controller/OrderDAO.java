/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import Model.Order;
import Model.OrderItem;
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

    // 3. Hàm tạo đơn hàng mới (Lưu vào bảng orders và order_items)
    // Hàm tạo đơn hàng mới (Đã sửa đổi để lưu trực tiếp Tên, SĐT, Địa chỉ)
    public boolean createOrder(Order order, List<OrderItem> items) {
        boolean result = false;

        // 1. Câu lệnh SQL cập nhật: loại bỏ address_id, thêm 3 cột nhận hàng mới
// Bắt buộc phải có chữ "note" và 11 dấu ? 
        String insertOrder = "INSERT INTO orders (user_id, total_amount, discount_amount, final_amount, status, payment_status, payment_method, recipient_name, phone, address_detail, note, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        String insertItem = "INSERT INTO order_items (order_id, product_id, quantity, price, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())";

        try {
            conn = Connect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction để an toàn dữ liệu

            // 2. Nạp dữ liệu vào bảng Orders
            ps = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, order.getUserId());
            ps.setDouble(2, order.getTotalAmount());
            ps.setDouble(3, order.getDiscountAmount());
            ps.setDouble(4, order.getFinalAmount());
            ps.setString(5, order.getStatus() != null ? order.getStatus() : "PENDING");
            ps.setString(6, order.getPaymentStatus() != null ? order.getPaymentStatus() : "UNPAID");
            ps.setString(7, order.getPaymentMethod());
            ps.setString(8, order.getRecipientName());  // Map cột recipient_name
            ps.setString(9, order.getPhone());          // Map cột phone
            ps.setString(10, order.getAddressDetail()); // Map cột address_detail
            ps.setString(11, order.getNote());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                // Lấy ID đơn hàng vừa tự động tăng trong DB
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int newOrderId = generatedKeys.getInt(1);

                    // 3. Nạp danh sách món ăn vào bảng order_items (Chốt chặn chống lỗi NullPointer)
                    if (items != null && !items.isEmpty()) {
                        PreparedStatement psItem = conn.prepareStatement(insertItem);
                        for (OrderItem item : items) {
                            psItem.setInt(1, newOrderId);
                            psItem.setInt(2, item.getProductId());
                            psItem.setInt(3, item.getQuantity());
                            psItem.setDouble(4, item.getPrice());
                            psItem.addBatch(); // Gom lệnh tối ưu hiệu năng
                        }
                        psItem.executeBatch();
                        psItem.close();
                    }

                    // Hoàn tất lưu toàn bộ dữ liệu hợp lệ
                    conn.commit();
                    result = true;
                }
            }
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback(); // Hoàn tác nếu xảy ra bất kỳ lỗi gì
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
            }
        }
        return result;
    }
}
