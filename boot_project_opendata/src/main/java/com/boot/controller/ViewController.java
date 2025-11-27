package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.service.AirQualityService;
import com.boot.service.UserService;
import com.boot.util.AirQualityCalculator;
import com.boot.util.ExcelReader;
import com.google.gson.Gson;
import com.boot.dto.AirQualityDTO;
import com.boot.dto.StationDTO;
import com.boot.dto.UserDTO;

import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@Controller
public class ViewController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private AirQualityCalculator airQualityCalculator;

    @Autowired
    private ExcelReader excelReader;
    
    @Autowired
    private AirQualityService airQualityService;
    
    // 메인 페이지
    @GetMapping("/")
    public String main() {
        return "main";
    }
    
    @GetMapping("/main")
    public String mainPage(Model model) {
    	// ✅ 전국 모든 측정소 데이터(API + Kakao 좌표 포함)
        List<AirQualityDTO> stations = airQualityService.getAllAirQuality();
        Map<String, AirQualityDTO> cityAverages = airQualityCalculator.calculateSidoAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
        String sidoAvgJson = new Gson().toJson(cityAverages);
        model.addAttribute("sidoAvgJson", sidoAvgJson);
        return "main";
    }
    
    // 회원가입 페이지
    @GetMapping("/register")
    public String register() {
        return "register";
    }
    
    // 회원가입 처리
    @PostMapping("/register_ok")
    public String registerOk(@RequestParam Map<String, String> param, Model model) {
        // 이메일 인증 값 기본 설정
        if (param.get("user_email_chk") == null || param.get("user_email_chk").equals("")) {
            param.put("user_email_chk", "N");
        }

        // 약관 동의 값 정리 (체크박스는 체크 시에만 넘어옴)
        String serviceYn = param.containsKey("terms_required_service") ? "Y" : "N";
        String privacyYn = param.containsKey("terms_required_privacy") ? "Y" : "N";
        String marketingYn = param.containsKey("terms_optional_marketing") ? "Y" : "N";

        // 필수 약관 서버 검증
        if (!"Y".equals(serviceYn) || !"Y".equals(privacyYn)) {
            model.addAttribute("msg", "필수 약관에 모두 동의해야 회원가입이 가능합니다.");
            return "register";
        }

        param.put("terms_required_service", serviceYn);
        param.put("terms_required_privacy", privacyYn);
        param.put("terms_optional_marketing", marketingYn);

        int result = userService.register(param);
        if (result == 1) {
            return "redirect:/login";
        } else {
            model.addAttribute("msg", "회원가입 실패. 다시 시도하세요.");
            return "register";
        }
    }
    
    // 아이디 중복 체크 (AJAX)
    @PostMapping("/checkId")
    @ResponseBody
    public String checkId(@RequestParam("user_id") String id) {
        int flag = userService.checkId(id);
        return (flag == 1) ? "Y" : "N";
    }

    
    // 회원 정보 수정 페이지
    @GetMapping("/mypage/edit")
    public String mypageEdit(HttpSession session, Model model) {
        List<AirQualityDTO> stations = airQualityService.getAllAirQuality();
        Map<String, AirQualityDTO> cityAverages = airQualityCalculator.calculateSidoAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
        // 로그인 체크
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null || loginId.isEmpty()) {
            try {
                String message = URLEncoder.encode("로그인 후 이용 가능합니다", StandardCharsets.UTF_8.toString());
                return "redirect:/login?message=" + message;
            } catch (Exception e) {
                return "redirect:/login";
            }
        }
        
        // 관리자는 접근 불가
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
            return "redirect:/adminMain";
        }
        
        // 사용자 정보 조회
        UserDTO user = userService.getUserById(loginId);
        if (user == null) {
            return "redirect:/mypage";
        }
        
        model.addAttribute("user", user);
        return "memberEdit";
    }
    
    // 회원 정보 수정 처리
    @PostMapping("/mypage/edit")
    public String mypageEditOk(@RequestParam Map<String, String> param, HttpSession session, Model model) {
        // 로그인 체크
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null || loginId.isEmpty()) {
            return "redirect:/login";
        }
        
        // 관리자는 접근 불가
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
            return "redirect:/adminMain";
        }
        
        // 사용자 ID 설정
        param.put("user_id", loginId);
        
        // 회원 정보 수정 처리
        int result = userService.updateUser(param);
        
        if (result == 1) {
            // 세션 정보 업데이트
            UserDTO user = userService.getUserById(loginId);
            if (user != null) {
                session.setAttribute("loginDisplayName", user.getUser_name());
            }
            return "redirect:/mypage";
        } else {
            // 수정 실패 시 기존 정보 다시 로드
            UserDTO user = userService.getUserById(loginId);
            if (user != null) {
                model.addAttribute("user", user);
            }
            model.addAttribute("error", "회원 정보 수정에 실패했습니다.");
            return "memberEdit";
        }
    }
    // 관리자 메인화면
    @GetMapping("/adminMain")
    public String adminMain(HttpSession session,Model model) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            return "redirect:/admin/login";
        }

        List<AirQualityDTO> stations = airQualityService.getAllAirQuality();
        Map<String, AirQualityDTO> cityAverages = airQualityCalculator.calculateSidoAverages(stations);

        model.addAttribute("cityAverages", cityAverages.values());
        model.addAttribute("sidoAvgJson", new Gson().toJson(cityAverages));

        return "admin/adminMain";
    }
}
