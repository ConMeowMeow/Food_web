/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import Model.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ConMeowMeow
 */
public class CartDAO {

    private int getOrCreateCartId(int userId) throws SQLException {
        String findCart = "SELECT cart_id FROM carts WHERE user_id = ? AND status = 'active'";
        String createCart = "INSERT INTO carts (user_id, status, created_at, updated_at) VALUES (?, 'active', NOW(), NOW())";

        try ( Connection con = Connect.getConnection()) {
            try ( PreparedStatement ps = con.prepareStatement(findCart)) {
                ps.setInt(1, userId);
                try ( ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("cart_id");
                    }
                }
            }

            try ( PreparedStatement ps = con.prepareStatement(createCart, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
                try ( ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            // NẾU BẢNG CARTS SAI TÊN CỘT, LỖI SẼ BÁO Ở ĐÂY
            System.out.println("❌ LỖI SQL (BẢNG CARTS): " + e.getMessage());
        }
        return -1;
    }

    public void addToCart(int userId, int productId, int quantity) {
        String checkSql = "SELECT id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?";
        String updateSql = "UPDATE cart_items SET quantity = quantity + ?, updated_at = NOW() WHERE id = ?";
        String insertSql = "INSERT INTO cart_items (cart_id, product_id, quantity, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())";

        try {
            int cartId = getOrCreateCartId(userId);
            if (cartId == -1) {
                System.out.println("❌ LỖI: cartId = -1, Dừng thêm sản phẩm!");
                return;
            }

            try ( Connection con = Connect.getConnection();  PreparedStatement psCheck = con.prepareStatement(checkSql)) {

                psCheck.setInt(1, cartId);
                psCheck.setInt(2, productId);

                try ( ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        try ( PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                            psUpdate.setInt(1, quantity);
                            psUpdate.setInt(2, rs.getInt("id"));
                            psUpdate.executeUpdate();
                            System.out.println("✅ CẬP NHẬT số lượng món " + productId + " THÀNH CÔNG!");
                        }
                    } else {
                        try ( PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                            psInsert.setInt(1, cartId);
                            psInsert.setInt(2, productId);
                            psInsert.setInt(3, quantity);
                            psInsert.executeUpdate();
                            System.out.println("✅ THÊM MỚI món " + productId + " THÀNH CÔNG!");
                        }
                    }
                }
            }
        } catch (Exception e) {
            // NẾU BẢNG CART_ITEMS SAI TÊN CỘT HOẶC THIẾU KHÓA NGOẠI, LỖI SẼ BÁO Ở ĐÂY
            System.out.println("❌ LỖI SQL (BẢNG CART_ITEMS): " + e.getMessage());
        }
    }

    public List<CartItem> getCartItems(int userId) {
        List<CartItem> list = new ArrayList<>();

        // Đã trả lại đúng khóa chính là p.product_id và c.cart_id theo thiết kế của bạn
        String sql = "SELECT ci.*, p.name, p.image_url, p.price "
                + "FROM cart_items ci "
                + "JOIN products p ON ci.product_id = p.product_id "
                + "JOIN carts c ON ci.cart_id = c.cart_id "
                + "WHERE c.user_id = ? AND c.status = 'active'";

        try ( Connection con = Connect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new CartItem(
                            rs.getInt("id"), rs.getInt("cart_id"), rs.getInt("product_id"), rs.getInt("quantity"),
                            rs.getString("name"), rs.getString("image_url"), rs.getDouble("price"),
                            rs.getTimestamp("created_at"), rs.getTimestamp("updated_at")
                    ));
                }
                System.out.println("✅ ĐÃ LẤY THÀNH CÔNG: " + list.size() + " món từ DB lên giỏ hàng!");
            }
        } catch (Exception e) {
            // Lần này lỗi thực sự (nếu có) sẽ bị phơi bày ở đây
            System.out.println("❌ LỖI SQL LẤY GIỎ HÀNG THỰC SỰ LÀ: " + e.getMessage());
        }
        return list;
    }
    // 1. Hàm Xóa món ăn khỏi giỏ

    public void removeFromCart(int userId, int productId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = (SELECT cart_id FROM carts WHERE user_id = ? AND status = 'active') AND product_id = ?";
        try ( Connection con = Connect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

// 2. Hàm Tăng/Giảm số lượng món ăn
    public void updateCartItemQuantity(int userId, int productId, int changeAmount) {
        String sql = "UPDATE cart_items SET quantity = quantity + (?) WHERE cart_id = (SELECT cart_id FROM carts WHERE user_id = ? AND status = 'active') AND product_id = ?";
        try ( Connection con = Connect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, changeAmount); // Truyền +1 (tăng) hoặc -1 (giảm)
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            ps.executeUpdate();

            // Tự động xóa nếu số lượng tụt xuống <= 0
            String deleteSql = "DELETE FROM cart_items WHERE quantity <= 0";
            PreparedStatement psDelete = con.prepareStatement(deleteSql);
            psDelete.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
