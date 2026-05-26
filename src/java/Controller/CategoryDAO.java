/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import Model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ConMeowMeow
 */
public class CategoryDAO {

    // Khai báo Connection ở cấp độ class
    private final Connection conn;

    // Truyền Connection qua Constructor
    public CategoryDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        // Đảm bảo tên bảng là categories (số nhiều) nếu trong DB bạn đặt thế
        String sql = "SELECT * FROM categories";

        try ( PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setCategoryName(rs.getString("category_name"));
                cat.setStatus(rs.getString("status"));
                // SỬA TẠI ĐÂY: Phải là img_url giống trong ảnh bạn chụp
                cat.setImgUrl(rs.getString("img_url"));

                list.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateCategory(Category cat) {
        String sql = "UPDATE categories SET category_name = ?, status = ?, img_url = ? WHERE category_id = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cat.getCategoryName());
            ps.setString(2, cat.getStatus());
            ps.setString(3, cat.getImgUrl());
            ps.setInt(4, cat.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addCategory(Category cat) {
        // SỬA TẠI ĐÂY: Tên cột trong ngoặc phải là img_url
        String sql = "INSERT INTO categories(category_name, status, img_url) VALUES (?, ?, ?)";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cat.getCategoryName());
            ps.setString(2, cat.getStatus());
            ps.setString(3, cat.getImgUrl());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi Insert: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    // 1. Hàm lấy 1 Category theo ID (để tìm đường dẫn ảnh trước khi xóa)

    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("category_id"));
                    cat.setImgUrl(rs.getString("img_url"));
                    return cat;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countProductsByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
// 2. Hàm xóa Category trong Database

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // 1. Hàm đếm tổng số lượng danh mục đang có trong DB
    public int getTotalCategoryCount() {
        String sql = "SELECT COUNT(*) FROM categories";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Hàm lấy danh mục theo trang (Sử dụng LIMIT và OFFSET của MySQL)
    public List<Category> getCategoriesByPage(int offset, int limit) {
        List<Category> list = new ArrayList<>();
        // Giới hạn số lượng lấy ra để phân trang
        String sql = "SELECT * FROM categories LIMIT ?, ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category c = new Category();
                    c.setCategoryId(rs.getInt("category_id"));
                    c.setCategoryName(rs.getString("category_name"));
                    c.setStatus(rs.getString("status")); 
                    c.setImgUrl(rs.getString("img_url"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
