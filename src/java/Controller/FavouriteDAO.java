/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ConMeowMeow
 */
public class FavouriteDAO {

    private Connection conn;
    // Tên bảng khớp với Database của bạn
    private final String TABLE_NAME = "user_favourite";

    public FavouriteDAO(Connection conn) {
        this.conn = conn;
    }

    /**
     * Thêm sản phẩm vào danh sách yêu thích
     */
    public void addToFavourite(int userId, int productId) {
        // Sử dụng TABLE_NAME đã khai báo
        String checkQuery = "SELECT id FROM " + TABLE_NAME + " WHERE user_id = ? AND product_id = ?";

        try ( PreparedStatement psCheck = conn.prepareStatement(checkQuery)) {
            psCheck.setInt(1, userId);
            psCheck.setInt(2, productId);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Nếu đã tồn tại, chỉ cập nhật thời gian updated_at
                String updateQuery = "UPDATE " + TABLE_NAME + " SET updated_at = ? WHERE user_id = ? AND product_id = ?";
                try ( PreparedStatement psUpdate = conn.prepareStatement(updateQuery)) {
                    psUpdate.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                    psUpdate.setInt(2, userId);
                    psUpdate.setInt(3, productId);
                    psUpdate.executeUpdate();
                }
            } else {
                // Nếu chưa tồn tại, thêm mới
                String insertQuery = "INSERT INTO " + TABLE_NAME + " (user_id, product_id, quantity, created_at, updated_at) "
                        + "VALUES (?, ?, ?, ?, ?)";
                try ( PreparedStatement psInsert = conn.prepareStatement(insertQuery)) {
                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    psInsert.setInt(1, userId);
                    psInsert.setInt(2, productId);
                    psInsert.setInt(3, 1); // Mặc định số lượng là 1
                    psInsert.setTimestamp(4, now);
                    psInsert.setTimestamp(5, now);
                    psInsert.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy danh sách ID sản phẩm user đã thích
     */
    public List<Integer> getFavouriteProductIds(int userId) {
        List<Integer> list = new ArrayList<>();
        String query = "SELECT product_id FROM " + TABLE_NAME + " WHERE user_id = ? ORDER BY created_at DESC";
        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("product_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Xóa sản phẩm khỏi danh sách yêu thích
     */
    public void removeFromFavourite(int userId, int productId) {
        String query = "DELETE FROM " + TABLE_NAME + " WHERE user_id = ? AND product_id = ?";
        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
