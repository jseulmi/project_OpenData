package com.boot.controller;

import com.boot.dto.Admin;
import com.boot.dto.UserDTO;
import com.boot.service.AdminService;
import com.boot.service.MailService;
import com.boot.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.HashMap;

@Controller
public class LoginController {
    
    private final MailService mailService;
    
    @Autowired
    private AdminService adminService;
    
    @Autowired
    private UserService userService;

    LoginController(MailService mailService) {
        this.mailService = mailService;
    }
    
    // 회원 로그인 페이지
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "message", required = false) String message,
                           Model model) {
        if (message != null && !message.isEmpty()) {
            try {
                String decodedMessage = URLDecoder.decode(message, StandardCharsets.UTF_8.toString());
                model.addAttribute("message", decodedMessage);
            } catch (Exception e) {
                model.addAttribute("message", message);
            }
        }
        return "login";
    }
    
    // 회원 로그인 처리
    @PostMapping("/login_yn")
    public String userLogin(@RequestParam("user_id") String username,
                            @RequestParam("user_pw") String password,
                            @RequestParam(value = "remember", required = false) String remember,
                            HttpSession session,
                            HttpServletResponse response,
                            Model model) {

        Map<String, String> param = new HashMap<>();
        param.put("user_id", username);
        param.put("user_pw", password);

        String userId = param.get("user_id");
        UserDTO user = userService.getUserById(userId);

     // 로그인 성공 시 세션 만료 시간 고정 저장 (30분 후)
        long expireAt = System.currentTimeMillis() + (30 * 60 * 1000);
        session.setAttribute("sessionExpireAt", expireAt);
        
        if (user == null) {
            model.addAttribute("login_err", "존재하지 않는 아이디입니다.");
            return "login";
        }

        // 로그인 실패 기록 초기화 체크
        if (user.getLast_fail_time() != null) {
            long diffMin = (System.currentTimeMillis() - user.getLast_fail_time().getTime()) / 1000 / 60;
            if (diffMin >= 5 && user.getLogin_fail_count() > 0) {
                userService.resetLoginFail(userId);
            }
        }

        // 로그인 5회 실패 잠금 체크
        if (user.getLogin_fail_count() >= 5 && user.getLast_fail_time() != null) {
            long diffSec = (System.currentTimeMillis() - user.getLast_fail_time().getTime()) / 1000;
            if (diffSec < 30) {
                model.addAttribute("login_err", "비밀번호 5회 이상 틀려 30초간 계정이 비활성화 됩니다.<br>잠시 후 다시 시도해주세요.");
                return "login";
            } else {
                userService.resetLoginFail(userId);
            }
        }

        boolean ok = userService.loginYn(param);

        if (ok) {
            userService.resetLoginFail(userId);
            session.setAttribute("loginId", userId);
            session.setAttribute("loginDisplayName", user.getUser_name());
            session.setAttribute("loginDisplayNickName", user.getUser_nickname());
            session.setAttribute("isAdmin", false);

            if ("on".equals(remember)) {
                Cookie cookie = new Cookie("remember-me", userId);
                cookie.setMaxAge(60 * 60 * 24 * 7);  // 7일
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                response.addCookie(cookie);
            } else {
                Cookie cookie = new Cookie("remember-me", null);
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
            }

            return "redirect:/main";
        } else {
            userService.updateLoginFail(userId);
            user = userService.getUserById(userId);

            if (user.getLogin_fail_count() >= 5) {
                model.addAttribute("login_err", "비밀번호를 5회 이상 틀리셨습니다.<br>계정이 30초간 계정이 잠깁니다.");
            } else {
                model.addAttribute("login_err", "아이디 또는 비밀번호가 잘못되었습니다. (" + user.getLogin_fail_count() + "/5)");
            }
            return "login";
        }
    }
    
    // 관리자 로그인 페이지
    @GetMapping("/admin/login")
    public String adminLoginPage(@RequestParam(value = "message", required = false) String message,
                                 Model model) {
        if (message != null && !message.isEmpty()) {
            try {
                String decodedMessage = URLDecoder.decode(message, StandardCharsets.UTF_8.toString());
                model.addAttribute("message", decodedMessage);
            } catch (Exception e) {
                model.addAttribute("message", message);
            }
        }
        return "adminLogin"; // 관리자 전용 로그인 JSP 페이지
    }
    
    // 관리자 로그인 처리
    @PostMapping("/admin/login_yn")
    public String adminLogin(@RequestParam("username") String username,
                             @RequestParam("password") String password,
                             HttpSession session,
                             Model model) {

        try {
            Admin adminUser = adminService.authenticate(username, password);

            if (adminUser != null) {

                // 1) OTP 생성
                int otp = (int)(Math.random() * 900000) + 100000; // 6자리
                
                long expireAt = System.currentTimeMillis() + (3 * 60 * 1000); // 3분
                session.setAttribute("adminOTPExpireAt", expireAt);

                // 2) 세션에 임시 저장 (로그인 확정 X)
                session.setAttribute("tempAdminId", adminUser.getId());
                session.setAttribute("tempAdminName", adminUser.getName());
                session.setAttribute("adminOTP", otp);
                session.setAttribute("tempAdminEmail", adminUser.getEmail());
                


                // 3) 이메일로 전송
                mailService.sendAdminOTP(adminUser.getEmail(), otp);


                // 4) OTP 입력 페이지로 이동
                return "redirect:/admin/otp";
            } else {
                model.addAttribute("login_err", "아이디 또는 비밀번호가 잘못되었습니다.");
                return "adminLogin";
            }

        } catch (Exception e) {
            model.addAttribute("login_err", "로그인 처리 중 오류 발생");
            return "adminLogin";
        }
    }
    
    // 관리자 로그아웃
    @GetMapping("/admin/logout")
    public String adminLogout(HttpSession session, HttpServletResponse response) {

        session.invalidate();

        // 쿠키 제거
        Cookie cookie = new Cookie("remember-me", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);

        return "redirect:/admin/login";
    }

    // 일반 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response) {

        session.invalidate();

        // 쿠키 제거
        Cookie cookie = new Cookie("remember-me", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);

        return "redirect:/main";
    }
    @GetMapping("/admin/otp")
    public String adminOTPPage() {
    	return "admin/adminOTP"; // adminOTP.jsp 로 이동
    }
    
    @PostMapping("/admin/otpCheck")
    public String adminOTPCheck(@RequestParam("otp") String otpInput,
                                HttpSession session,
                                Model model) {

        Object otpObj = session.getAttribute("adminOTP");
        Long expireAt = (Long) session.getAttribute("adminOTPExpireAt");

        // 🔥 OTP가 없거나 세션 만료된 경우
        if (otpObj == null || expireAt == null) {
            model.addAttribute("otp_err", "OTP 세션이 만료되었습니다. 다시 로그인해주세요.");
            return "adminLogin";
        }

        // 🔥 3분 만료 체크
        if (System.currentTimeMillis() > expireAt) {
            session.removeAttribute("adminOTP");
            session.removeAttribute("adminOTPExpireAt");

            model.addAttribute("otp_err", "OTP 유효시간(3분)이 만료되었습니다. 다시 로그인해주세요.");
            return "adminLogin";
        }

        int realOtp = (int) otpObj;

        // 🔥 OTP 틀림
        if (!otpInput.equals(String.valueOf(realOtp))) {
            model.addAttribute("otp_err", "OTP 번호가 일치하지 않습니다.");
            return "admin/adminOTP";
        }

        // 🔥 OTP 성공 → 관리자 정식 로그인 처리
        session.removeAttribute("adminOTP");
        session.removeAttribute("adminOTPExpireAt");

        session.setAttribute("userId", session.getAttribute("tempAdminId"));
        session.setAttribute("loginDisplayName", session.getAttribute("tempAdminName"));
        session.setAttribute("isAdmin", true);
        session.setAttribute("role", "ADMIN");

        session.removeAttribute("tempAdminId");
        session.removeAttribute("tempAdminName");

        return "redirect:/adminMain";
    }

    
    @PostMapping("/admin/resendOTP")
    @ResponseBody
    public Map<String, Object> resendOTP(HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        String email = (String) session.getAttribute("tempAdminEmail");

        if (email == null) {
            result.put("status", "expired");
            return result;
        }

        // 새 OTP
        int otp = (int)(Math.random() * 900000) + 100000;
        session.setAttribute("adminOTP", otp);

        // 새 유효시간 (3분)
        long expireAt = System.currentTimeMillis() + (3 * 60 * 1000);
        session.setAttribute("adminOTPExpireAt", expireAt);

        // 이메일 발송
        mailService.sendAdminOTP(email, otp);

        // 성공 응답 + 새 타이머 전달
        result.put("status", "success");
        result.put("expireAt", expireAt);

        return result;
    }
    
}
