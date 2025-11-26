package com.boot.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.boot.dao.InquiryDAO;
import com.boot.dto.InquiryDTO;
import com.boot.dto.InquiryReplyDTO;

@Service
public class InquiryServiceImpl implements InquiryService {

    @Autowired
    private InquiryDAO inquiryDAO;

    @Override
    @Transactional
    public int createInquiry(InquiryDTO inquiry) {
        return inquiryDAO.insertInquiry(inquiry);
    }

    @Override
    public List<InquiryDTO> getInquiryListByUserId(String userId) {
        return inquiryDAO.selectInquiryByUserId(userId);
    }

    @Override
    public InquiryDTO getInquiryById(int inquiryId) {
        return inquiryDAO.selectInquiryById(inquiryId);
    }

    @Override
    public List<InquiryDTO> getAllInquiries() {
        return inquiryDAO.selectAllInquiries();
    }

    @Override
    public List<InquiryDTO> getPendingInquiries() {
        return inquiryDAO.selectPendingInquiries();
    }

    @Override
    @Transactional
    public int createReply(InquiryReplyDTO reply) {
        // 답변 작성
        int result = inquiryDAO.insertReply(reply);
        
        // 문의 상태를 '답변완료'로 업데이트
        if (result > 0) {
            inquiryDAO.updateInquiryStatus(reply.getInquiry_id(), "답변완료");
        }
        
        return result;
    }

    @Override
    @Transactional
    public int updateReply(InquiryReplyDTO reply) {
        // 답변 수정 (reply_id로)
        int result = inquiryDAO.updateReply(reply);
        
        // 문의 상태를 '답변완료'로 유지
        if (result > 0) {
            inquiryDAO.updateInquiryStatus(reply.getInquiry_id(), "답변완료");
        }
        
        return result;
    }

    @Override
    public InquiryReplyDTO getReplyByInquiryId(int inquiryId) {
        return inquiryDAO.selectReplyByInquiryId(inquiryId);
    }

    @Override
    @Transactional
    public int deleteInquiry(int inquiryId) {
        return inquiryDAO.deleteInquiry(inquiryId);
    }
}
