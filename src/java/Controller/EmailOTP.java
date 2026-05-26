/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

/**
 *
 * @author ConMeowMeow
 */
public class EmailOTP {

    public void sendOTP(String recipientEmail, String otpCode) {

        String host = "smtp.gmail.com";
        String user = "fastfood.dhti@gmail.com"; //email
        String password = "dodv hker hqpc glrg"; //generated App Password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");

        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Mã Xác Thực OTP - FastFood", "UTF-8");
            String emailContent = "<p>Chào bạn,</p>"
                    + "<p>Mã xác thực (OTP) của bạn là: <b style='font-size: 18px; color: #ea6a47;'>" + otpCode + "</b></p>"
                    + "<p>Mã này có hiệu lực trong vòng 15 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>";

            message.setContent(emailContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("OTP successfully sent!");
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}
