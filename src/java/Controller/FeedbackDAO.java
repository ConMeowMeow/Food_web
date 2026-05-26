/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;
import java.sql.*;
/**
 *
 * @author ConMeowMeow
 */
public class FeedbackDAO {
    public void insertFeedback(
            int userId,
            String fullname,
            String email,
            String phone,
            String issueType,
            String message
    ) {

        try {
            Connection con = Connect.getConnection();

            String sql = "INSERT INTO feedbacks(user_id,fullname,email,phone,issue_type,message) VALUES(?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setString(2, fullname);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, issueType);
            ps.setString(6, message);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
