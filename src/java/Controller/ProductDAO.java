/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import Model.Product;
import Model.Topping;
import java.sql.*;
import java.util.*;

/**
 *
 * @author ConMeowMeow
 */
public class ProductDAO {

    private Connection conn;

    public ProductDAO() {
    }

    public ProductDAO(Connection conn) {
        this.conn = conn;
    }

    // 1. Lấy toàn bộ danh sách sản phẩm từ cơ sở dữ liệu
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY product_id DESC";
        try ( Connection conn = Connect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setDiscount(rs.getDouble("discount"));
                p.setStock(rs.getInt("stock"));

                // [MỚI] Đọc trạng thái từ DB
                p.setStatus(rs.getInt("status"));

                p.setCagetoryId(rs.getInt("category_id"));
                p.setImageUrl(rs.getString("image_url"));
                p.setCreateAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy thông tin 1 sản phẩm theo ID (phục vụ lấy link ảnh để xóa file vật lý)
    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setDiscount(rs.getDouble("discount"));
                    p.setStock(rs.getInt("stock"));

                    // [MỚI] Đọc trạng thái từ DB
                    p.setStatus(rs.getInt("status"));

                    p.setCagetoryId(rs.getInt("category_id"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setCreateAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Xóa sản phẩm khỏi DB
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Thêm Sản phẩm
    public boolean insertProduct(Product p) {
        // [MỚI] Thêm cột status vào câu lệnh SQL
        String sql = "INSERT INTO products (name, description, price, discount, stock, status, category_id, image_url, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setDouble(4, p.getDiscount());
            ps.setInt(5, p.getStock());

            // [MỚI] Truyền giá trị status vào Database
            ps.setInt(6, p.getStatus());

            ps.setInt(7, p.getCagetoryId());
            ps.setString(8, p.getImageUrl());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Cập nhật Sản phẩm
    public boolean updateProduct(Product p) {
        // [MỚI] Bổ sung update cột status
        String sql = "UPDATE products SET name = ?, category_id = ?, price = ?, discount = ?, stock = ?, status = ?, image_url = ?, updated_at = NOW() WHERE product_id = ?";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getCagetoryId());
            ps.setDouble(3, p.getPrice());
            ps.setDouble(4, p.getDiscount());
            ps.setInt(5, p.getStock());

            // [MỚI] Cập nhật giá trị status
            ps.setInt(6, p.getStatus());

            ps.setString(7, p.getImageUrl()); // Dịch chuyển vị trí tham số
            ps.setInt(8, p.getProductId());   // Dịch chuyển vị trí tham số

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Lấy ID danh mục bằng Tên
    public int getCategoryIdByName(String catName) {
        String sql = "SELECT category_id FROM categories WHERE LOWER(category_name) LIKE ? LIMIT 1";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + catName.toLowerCase() + "%");
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("category_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }

    public List<Topping> getToppingsByProductId(int productId) {
        List<Topping> list = new ArrayList<>();
        // Lưu ý: Thay "toppings" bằng tên bảng thực tế của bạn trong DB
        String sql = "SELECT * FROM toppings WHERE product_id = ?";

        try ( Connection conn = Connect.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId); // Gán product_id bạn muốn tìm vào dấu ?

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Topping t = new Topping();
                    t.setToppingId(rs.getInt("topping_id"));
                    t.setProductId(rs.getInt("product_id"));
                    t.setName(rs.getString("name"));
                    t.setPrice(rs.getDouble("price"));
                    t.setImageUrl(rs.getString("image_url"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
