package Controller;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TestOTP {

    public static void main(String[] args) {
        // Configuration - Replace with your actual credentials
        String host = "smtp.gmail.com"; // e.g., Gmail SMTP
        final String user = "fastfood.dhti@gmail.com";
        final String password = "dodv hker hqpc glrg"; // Use an App Password, not your login password
        String recipient = "phungngocbao.98.2019@gmail.com";
        String otp = "552301";

        sendOTP(host, user, password, recipient, otp);
    }

    public static void sendOTP(String host, final String user, final String password, String recipientEmail, String otpCode) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");

        // Timeouts to prevent the app from hanging
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
            Message message = new MimeMessage(session);
            try {
                // "Tên Công Ty / Ứng Dụng" là tên sẽ hiển thị trong hộp thư người nhận
                message.setFrom(new InternetAddress(user, "Hệ thống OTP FastFood"));
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(TestOTP.class.getName()).log(Level.SEVERE, null, ex);
            }
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Your Login OTP Code");
            message.setText("Your One-Time Password (OTP) is: " + otpCode + ". It is valid for 5 minutes.");

            System.out.println("Attempting to send email...");
            Transport.send(message);
            System.out.println("OTP successfully sent to " + recipientEmail);

        } catch (MessagingException e) {
            System.err.println("Failed to send email. Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
