package Controller;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class SendMail {

    private static final String MY_EMAIL = "fastfood.dhti@gmail.com";
    private static final String MY_PASSWORD = "dodv hker hqpc glrg";

    public static boolean sendEmail(String toEmail, String subject, String body) {
        boolean test = false;
        Properties p = new Properties();
        p.put("mail.smtp.auth", "true");
        p.put("mail.smtp.starttls.enable", "true");
        p.put("mail.smtp.host", "smtp.gmail.com");
        p.put("mail.smtp.port", "587");
        p.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        p.put("mail.smtp.ssl.protocols", "TLSv1.2");
        Session session = Session.getInstance(p, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(MY_EMAIL, MY_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(MY_EMAIL));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
            message.setContent(body, "text/html; charset=UTF-8"); // Định dạng HTML để mail đẹp hơn

            Transport.send(message);
            test = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return test;
    }
}
