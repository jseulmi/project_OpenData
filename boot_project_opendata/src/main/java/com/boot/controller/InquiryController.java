package com.boot.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boot.dto.InquiryDTO;
import com.boot.dto.InquiryReplyDTO;
import com.boot.service.InquiryService;

@Controller
@RequestMapping("/inquiry")
public class InquiryController {

    @Autowired
    private InquiryService inquiryService;

    // 사용자용: 문의 목록 페이지
    @GetMapping
    public String inquiryList(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            return "redirect:/login";
        }

        List<InquiryDTO> inquiryList = inquiryService.getInquiryListByUserId(loginId);
        model.addAttribute("inquiryList", inquiryList);
        
        return "inquiry/userlist";
    }

    // 문의 작성 페이지
    @GetMapping("/write")
    public String inquiryWrite(HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            return "redirect:/login";
        }
        return "inquiry/userwrite";
    }

    // 문의 작성 처리
    @PostMapping("/write")
    public String inquiryWriteOk(
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            return "redirect:/login";
        }

        InquiryDTO inquiry = new InquiryDTO();
        inquiry.setUser_id(loginId);
        inquiry.setTitle(title);
        inquiry.setContent(content);

        int result = inquiryService.createInquiry(inquiry);
        
        if (result > 0) {
            redirectAttributes.addFlashAttribute("msg", "문의가 등록되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("msg", "문의 등록에 실패했습니다.");
        }

        return "redirect:/inquiry";
    }

    // 문의 상세 보기
    @GetMapping("/detail")
    public String inquiryDetail(
            @RequestParam("inquiry_id") int inquiryId,
            HttpSession session,
            Model model) {
        
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            return "redirect:/login";
        }

        InquiryDTO inquiry = inquiryService.getInquiryById(inquiryId);
        
        // 본인 문의만 조회 가능
        if (inquiry == null || !inquiry.getUser_id().equals(loginId)) {
            return "redirect:/inquiry";
        }

        model.addAttribute("inquiry", inquiry);
        return "inquiry/userdetail";
    }

    // 문의 삭제
    @PostMapping("/delete")
    public String inquiryDelete(
            @RequestParam("inquiry_id") int inquiryId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            return "redirect:/login";
        }

        InquiryDTO inquiry = inquiryService.getInquiryById(inquiryId);
        
        // 본인 문의만 삭제 가능
        if (inquiry != null && inquiry.getUser_id().equals(loginId)) {
            inquiryService.deleteInquiry(inquiryId);
            redirectAttributes.addFlashAttribute("msg", "문의가 삭제되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("msg", "삭제 권한이 없습니다.");
        }

        return "redirect:/inquiry";
    }
}
