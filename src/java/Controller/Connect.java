/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author ConMeowMeow
 */
public class Connect {
    private static final String URL = "jdbc:mysql://localhost:3306/nhahang";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("Không tìm thấy MySQL Driver!");
        } catch (SQLException e) {
            System.out.println("Lỗi kết nối CSDL!");
            System.out.println(e.getMessage());
        }
        return null;
    }
}
