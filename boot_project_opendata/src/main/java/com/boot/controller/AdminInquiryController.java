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

    /** 
     * 모든 관리자 페이지 접근시 공통 세션 로그 출력 
     */
    private void logSessionStatus(HttpSession session, String action) {
        Object isAdmin = session.getAttribute("isAdmin");
        Object adminId = session.getAttribute("adminId");

        log.info("🔍 [{}] 세션 상태 확인 → isAdmin={}, adminId={}",
                action, isAdmin, adminId);
    }

    // ─────────────────────────────────────────────────────────────
    // 문의 목록 페이지
    // ─────────────────────────────────────────────────────────────
    @GetMapping("/inquiryManagement")
    public String list(HttpSession session, Model model) {

        logSessionStatus(session, "문의 목록 접근");

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

        if (isAdmin == null || !isAdmin) {
            log.warn("🚫 접근 차단: 관리자 세션 없음 (isAdmin={})", isAdmin);
            return "redirect:/admin/login";
        }

        List<InquiryDTO> inquiryList = inquiryService.getAllInquiries();
        model.addAttribute("inquiryList", inquiryList);

        log.info("📄 문의 목록 조회 완료 (총 {}개)", inquiryList.size());
        return "admin/inquiryManagement";
    }

    // ─────────────────────────────────────────────────────────────
    // 문의 상세 페이지
    // ─────────────────────────────────────────────────────────────
    @GetMapping("/inquiryDetail")
    public String detail(@RequestParam("inquiry_id") int inquiryId,
                         Model model, HttpSession session) {

        logSessionStatus(session, "문의 상세 접근");

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

        if (isAdmin == null || !isAdmin) {
            log.warn("🚫 상세 페이지 접근 차단: 관리자 아님 (isAdmin={})", isAdmin);
            return "redirect:/admin/login";
        }

        InquiryDTO inquiry = inquiryService.getInquiryById(inquiryId);
        model.addAttribute("inquiry", inquiry);

        log.info("📄 문의 상세 조회 완료 (inquiryId={})", inquiryId);

        return "admin/inquiryDetail";
    }

    // ─────────────────────────────────────────────────────────────
    // 문의 답변 등록 / 수정
    // ─────────────────────────────────────────────────────────────
    @PostMapping("/reply")
    @ResponseBody
    public String reply(@RequestParam("inquiry_id") int inquiryId,
                        @RequestParam("reply_content") String replyContent,
                        HttpSession session) {

        logSessionStatus(session, "문의 답변 요청");

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Long adminId = (Long) session.getAttribute("adminId");

        // 관리자 체크
        if (isAdmin == null || !isAdmin) {
            log.warn("🚫 답변 작성 차단: isAdmin 없음 → FAIL");
            return "FAIL";
        }

        if (adminId == null) {
            log.warn("🚫 답변 작성 차단: adminId 없음 → FAIL");
            return "FAIL";
        }

        log.info("📝 답변 처리 시작 → inquiryId={}, adminId={}, replyContent={}",
                inquiryId, adminId, replyContent);

        // 기존 답변 조회
        InquiryReplyDTO existingReply = inquiryService.getReplyByInquiryId(inquiryId);
        log.info("🔍 기존 답변 조회 결과: {}", existingReply);

        InquiryReplyDTO reply = new InquiryReplyDTO();
        reply.setInquiry_id(inquiryId);
        reply.setAdmin_id(String.valueOf(adminId));
        reply.setReply_content(replyContent);

        int result;

        if (existingReply != null && existingReply.getReply_id() > 0) {
            // 기존 답변 수정
            reply.setReply_id(existingReply.getReply_id());
            result = inquiryService.updateReply(reply);

            log.info("✏️ 답변 수정 완료: replyId={}, result={}", reply.getReply_id(), result);
        } else {
            // 신규 답변 등록
            result = inquiryService.createReply(reply);
            log.info("🆕 답변 등록 완료: inquiryId={}, result={}", inquiryId, result);
        }

        if (result > 0) {
            log.info("✅ 답변 처리 성공");
            return "SUCCESS";
        } else {
            log.warn("❌ 답변 처리 실패 (DB 업데이트 실패)");
            return "FAIL";
        }
    }
}
