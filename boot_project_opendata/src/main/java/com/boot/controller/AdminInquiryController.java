package com.boot.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.InquiryDTO;
import com.boot.dto.InquiryReplyDTO;
import com.boot.service.InquiryService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin")
public class AdminInquiryController {

    private final InquiryService inquiryService;

    @GetMapping("/inquiryManagement")
    public String list(HttpSession session, Model model) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            log.warn("🚫 접근 차단: 관리자 세션 없음");
            return "redirect:/admin/login";  // 공지사항과 일치
        }
        List<InquiryDTO> inquiryList = inquiryService.getAllInquiries();
        model.addAttribute("inquiryList", inquiryList);
        return "admin/inquiryManagement";
    }

    @GetMapping("/inquiryDetail")
    public String detail(@RequestParam("inquiry_id") int inquiryId, Model model, HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            return "redirect:/admin/login";
        }
        InquiryDTO inquiry = inquiryService.getInquiryById(inquiryId);
        model.addAttribute("inquiry", inquiry);
        return "admin/inquiryDetail";
    }

    @PostMapping("/reply")
    @ResponseBody
    public String reply(@RequestParam("inquiry_id") int inquiryId,
                        @RequestParam("reply_content") String replyContent,
                        HttpSession session) {

      Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
      if (isAdmin == null || !isAdmin) {
          log.warn("관리자 권한 없음 or 로그인 필요");
          return "FAIL";
      }
      
      String adminId = (String) session.getAttribute("loginId");
      log.info("reply() 호출 - inquiryId: {}, replyContent: {}, adminId: {}, isAdmin: {}", inquiryId, replyContent, adminId, isAdmin);

      if (adminId == null || adminId.isEmpty()) {
          log.warn("관리자 로그인 필요 - adminId 없음");
          return "FAIL";
      }
    	
        // adminId 세션 대신 고정값 할당
//        String adminId = "system";

        log.info("reply() 호출 - inquiryId: {}, replyContent: {}, adminId: {}", inquiryId, replyContent, adminId);

        // 기존 답변 조회
        InquiryReplyDTO existingReply = inquiryService.getReplyByInquiryId(inquiryId);
        log.info("기존 답변 조회: {}", existingReply);

        InquiryReplyDTO reply = new InquiryReplyDTO();
        reply.setInquiry_id(inquiryId);
        reply.setAdmin_id(adminId);
        reply.setReply_content(replyContent);

        int result;
        if (existingReply != null && existingReply.getReply_id() > 0) {
            reply.setReply_id(existingReply.getReply_id());
            result = inquiryService.updateReply(reply);
            log.info("답변 수정: reply_id={}, result={}", reply.getReply_id(), result);
        } else {
            result = inquiryService.createReply(reply);
            log.info("답변 등록: inquiry_id={}, result={}", inquiryId, result);
        }

        if (result > 0) {
            log.info("답변 처리 성공");
            return "SUCCESS";
        } else {
            log.warn("답변 처리 실패 - 반환값 0 또는 음수");
            return "FAIL";
        }
    }

}
