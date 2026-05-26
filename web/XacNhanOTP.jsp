<%-- 
    Document   : XacNhanOTP
    Created on : May 25, 2026, 9:02:50 AM
    Author     : ConMeowMeow
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận mã OTP - FastFood</title>

        <link rel="icon" href="./img/logo.png" type="image/png">
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Montserrat:wght@500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="./css/TrangChu.css">

        <style>
            body {
                background-color: #f8f9fa;
            }
            .otp-card {
                max-width: 450px;
                margin: 100px auto;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            }
            .otp-input {
                width: 45px;
                height: 55px;
                font-size: 24px;
                font-weight: 700;
                text-align: center;
                border: 2px solid #dee2e6;
                border-radius: 10px;
                margin: 0 5px;
                transition: all 0.2s ease;
            }
            .otp-input:focus {
                border-color: var(--primary-color, #ea6a47); /* Dùng màu chủ đạo của dự án */
                box-shadow: 0 0 0 0.25rem rgba(234, 106, 71, 0.25);
                outline: none;
            }
            .timer {
                font-family: 'Montserrat', sans-serif;
                font-size: 1.5rem;
                font-weight: 700;
                color: #dc3545;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card otp-card border-0 p-4 p-md-5">
                <div class="text-center mb-4">
                    <img src="./img/logo.png" alt="Logo" width="80" class="mb-3">
                    <h3 class="fw-bold text-dark" style="font-family: 'Be Vietnam Pro', sans-serif;">Xác Thực OTP</h3>
                    <p class="text-muted small">
                        Mã xác thực 6 số đã được gửi đến email của bạn. Vui lòng nhập mã để hoàn tất thủ tục.
                    </p>
                </div>

                <form action="VerifyOTP" method="POST" id="otpForm">
                    <div class="d-flex justify-content-center mb-4" id="otp-container">
                        <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required autofocus>
                        <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                        <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                        <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                        <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                        <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                    </div>

                    <input type="hidden" name="fullOTP" id="fullOTP">

                    <div class="text-center mb-4">
                        <p class="mb-1 text-muted small">Mã OTP sẽ hết hạn sau:</p>
                        <div class="timer" id="countdown">10:00</div>
                    </div>

                    <button type="submit" class="btn btn-custom w-100 py-2 fw-bold" style="border-radius: 8px;">Xác Nhận</button>
                </form>

                <div class="text-center mt-4">
                    <p class="text-muted mb-0 small">Chưa nhận được mã? 
                        <a href="ResendOTP" class="text-decoration-none fw-bold" style="color: var(--primary-color, #ea6a47);">Gửi lại</a>
                    </p>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const inputs = document.querySelectorAll('.otp-input');
                const form = document.getElementById('otpForm');
                const timerElement = document.getElementById('countdown');
                const submitBtn = document.querySelector('button[type="submit"]');

                // 1. Xử lý tự động chuyển focus khi nhập ô OTP
                inputs.forEach((input, index) => {
                    input.addEventListener('input', (e) => {
                        e.target.value = e.target.value.replace(/[^0-9]/g, '');
                        if (e.target.value.length === 1 && index < inputs.length - 1) {
                            inputs[index + 1].focus();
                        }
                    });

                    input.addEventListener('keydown', (e) => {
                        if (e.key === 'Backspace' && e.target.value === '' && index > 0) {
                            inputs[index - 1].focus();
                        }
                    });
                });

                // 2. Gộp 6 ô thành chuỗi trước khi gửi
                if (form) {
                    form.addEventListener('submit', function (e) {
                        let otpStr = '';
                        inputs.forEach(input => otpStr += input.value);
                        document.getElementById('fullOTP').value = otpStr;
                    });
                }

                // 3. Logic đếm ngược 10 phút (900 giây) bảo vệ nghiêm ngặt
                let timeLeft = 10 * 60;

                const countdownTimer = setInterval(() => {
                    let minutes = Math.floor(timeLeft / 60);
                    let seconds = timeLeft % 60;

                    minutes = minutes < 10 ? '0' + minutes : minutes;
                    seconds = seconds < 10 ? '0' + seconds : seconds;

                    if (timerElement) {
                        timerElement.textContent = minutes + ":" + seconds;
                    }

                    if (timeLeft <= 0) {
                        clearInterval(countdownTimer);
                        if (timerElement) {
                            timerElement.textContent = "00:00";
                            timerElement.style.color = "#6c757d";
                        }
                        // Vô hiệu hóa form khi hết giờ
                        inputs.forEach(input => input.disabled = true);
                        if (submitBtn) {
                            submitBtn.disabled = true;
                            submitBtn.classList.add('opacity-50');
                        }
                    }
                    timeLeft -= 1;
                }, 1000);
            });
        </script>
    </body>
</html>
