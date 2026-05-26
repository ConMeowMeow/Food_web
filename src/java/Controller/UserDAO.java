package Controller;

import java.sql.*;
import Model.User;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection conn;

    public UserDAO() {
    }

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = Connect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPassword = rs.getString("password");
                    String hashedInputPassword = EncryptPass.convertToSHA256(password);
                    if (hashedInputPassword.equals(dbPassword)) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setFullName(rs.getString("fullname"));
                        user.setEmail(rs.getString("email"));
                        user.setPhone(rs.getString("phone"));
                        user.setGender(rs.getString("gender"));
                        user.setBirthday(rs.getString("birthday"));
                        user.setRole(rs.getString("role"));
                        user.setAvatarUrl(rs.getString("avatar_url"));
                        user.setStatus(rs.getByte("status"));
                        return user;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(int id, String name, String email, String phone, int addressId) {
        String sql = "UPDATE users SET fullname=?, email=?, phone=?, address_id=? WHERE id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, addressId);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update Error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateAvatar(int userId, String avatarUrl) {
        String sql = "UPDATE users SET avatar_url = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User signup(String email, String password, String fullname, String phone, String addressDetail) {
        String sqlUser = "INSERT INTO users (email, password, fullname, phone, role, status) VALUES (?, ?, ?, ?, 'user', 1)";
        String sqlCart = "INSERT INTO carts (user_id, status) VALUES (?, 'active')";
        String sqlAddress = "INSERT INTO addresses (user_id, recipient_name, phone, province, district, ward, address_detail, is_default) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 1)";

        try {
            conn.setAutoCommit(false);
            String hashedPassword = EncryptPass.convertToSHA256(password);

            try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, email);
                psUser.setString(2, hashedPassword);
                psUser.setString(3, fullname);
                psUser.setString(4, phone);
                psUser.executeUpdate();

                try (ResultSet rs = psUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newUserId = rs.getInt(1);

                        try (PreparedStatement psCart = conn.prepareStatement(sqlCart)) {
                            psCart.setInt(1, newUserId);
                            psCart.executeUpdate();
                        }

                        try (PreparedStatement psAddress = conn.prepareStatement(sqlAddress)) {
                            psAddress.setInt(1, newUserId);
                            psAddress.setString(2, fullname);
                            psAddress.setString(3, phone);
                            psAddress.setString(4, "Chưa nhập");
                            psAddress.setString(5, "Chưa nhập");
                            psAddress.setString(6, "Chưa nhập");
                            psAddress.setString(7, addressDetail);
                            psAddress.executeUpdate();
                        }

                        conn.commit();

                        User user = new User();
                        user.setId(newUserId);
                        user.setEmail(email);
                        user.setFullName(fullname);
                        user.setPhone(phone);
                        user.setRole("user");
                        return user;
                    }
                }
            }
        } catch (Exception e) {
            try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { conn.setAutoCommit(true); } catch (Exception ex) { ex.printStackTrace(); }
        }
        return null;
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET username=?, fullname=?, email=?, phone=?, gender=?, birthday=?, avatar_url=? WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getGender());
            ps.setString(6, user.getBirthday());
            ps.setString(7, user.getAvatarUrl());
            ps.setInt(8, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkOldPassword(int userId, String oldPassword) {
        String sql = "SELECT password FROM users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPassword = rs.getString("password");
                    String hashedOld = EncryptPass.convertToSHA256(oldPassword);
                    return dbPassword.equals(hashedOld);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, EncryptPass.convertToSHA256(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // FIX: LEFT JOIN default address so ${u.addressDetail} works in Users.jsp
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String query = "SELECT u.*, a.address_detail "
                + "FROM users u "
                + "LEFT JOIN addresses a ON a.user_id = u.id AND a.is_default = 1 "
                + "WHERE u.role = 'user' "
                + "ORDER BY u.id DESC";

        try (Connection conn = Connect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAvatarUrl(rs.getString("avatar_url"));
                u.setStatus(rs.getByte("status"));
                u.setAddressDetail(rs.getString("address_detail")); // populated from JOIN
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateUserStatus(int userId, byte newStatus) {
        String query = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = Connect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setByte(1, newStatus);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<User> getAllAdmins() {
        List<User> list = new ArrayList<>();
        String query = "SELECT u.*, a.address_detail "
                + "FROM users u "
                + "LEFT JOIN addresses a ON a.user_id = u.id AND a.is_default = 1 "
                + "WHERE u.role != 'user' "
                + "ORDER BY u.id DESC";

        try (Connection conn = Connect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAvatarUrl(rs.getString("avatar_url"));
                u.setStatus(rs.getByte("status"));
                u.setAddressDetail(rs.getString("address_detail"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

