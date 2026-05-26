/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import Model.Address;
import java.sql.*;
import java.util.*;

/**
 *
 * @author ConMeowMeow
 */
public class AddressDAO {

    public List<Address> getByUser(int userId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, created_at DESC";

        try ( Connection con = Connect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Address a = new Address();
                    a.setAddressId(rs.getInt("address_id"));
                    a.setUserId(rs.getInt("user_id"));
                    a.setRecipientName(rs.getString("recipient_name"));
                    a.setPhone(rs.getString("phone"));
                    a.setProvince(rs.getString("province"));
                    a.setDistrict(rs.getString("district"));
                    a.setWard(rs.getString("ward"));
                    a.setAddressDetail(rs.getString("address_detail"));
                    a.setIsDefault(rs.getShort("is_default"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    a.setUpdatedAt(rs.getTimestamp("updated_at"));

                    list.add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. THÊM ĐỊA CHỈ MỚI
    public boolean addAddress(Address address) {
        String sql = "INSERT INTO addresses (user_id, recipient_name, phone, province, district, ward, address_detail, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection con = Connect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getRecipientName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getProvince());
            ps.setString(5, address.getDistrict());
            ps.setString(6, address.getWard());
            ps.setString(7, address.getAddressDetail());
            ps.setShort(8, address.getIsDefault());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. XÓA ĐỊA CHỈ
    public boolean deleteAddress(int addressId, int userId) {
        String sql = "DELETE FROM addresses WHERE address_id = ? AND user_id = ?";

        try ( Connection con = Connect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. CẬP NHẬT ĐỊA CHỈ
    public boolean updateAddress(Address address) {
        String sql = "UPDATE addresses SET recipient_name = ?, phone = ?, province = ?, district = ?, ward = ?, address_detail = ?, updated_at = CURRENT_TIMESTAMP WHERE address_id = ? AND user_id = ?";

        try ( Connection con = Connect.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, address.getRecipientName());
            ps.setString(2, address.getPhone());
            ps.setString(3, address.getProvince());
            ps.setString(4, address.getDistrict());
            ps.setString(5, address.getWard());
            ps.setString(6, address.getAddressDetail());
            ps.setInt(7, address.getAddressId());
            ps.setInt(8, address.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. THIẾT LẬP ĐỊA CHỈ MẶC ĐỊNH (Sử dụng Transaction để đảm bảo chỉ có 1 địa chỉ mặc định)
    public boolean setDefaultAddress(int addressId, int userId) {
        String sqlUnsetDefault = "UPDATE addresses SET is_default = 0 WHERE user_id = ?";
        String sqlSetDefault = "UPDATE addresses SET is_default = 1 WHERE address_id = ? AND user_id = ?";

        Connection con = null;
        try {
            con = Connect.getConnection();
            con.setAutoCommit(false); // Bật chế độ transaction

            // Bước 1: Bỏ mặc định tất cả địa chỉ cũ của user này
            try ( PreparedStatement ps1 = con.prepareStatement(sqlUnsetDefault)) {
                ps1.setInt(1, userId);
                ps1.executeUpdate();
            }

            // Bước 2: Thiết lập mặc định cho địa chỉ được chọn
            int rowsAffected = 0;
            try ( PreparedStatement ps2 = con.prepareStatement(sqlSetDefault)) {
                ps2.setInt(1, addressId);
                ps2.setInt(2, userId);
                rowsAffected = ps2.executeUpdate();
            }

            con.commit(); // Hoàn thành transaction
            return rowsAffected > 0;

        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

}
