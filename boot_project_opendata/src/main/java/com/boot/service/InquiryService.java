package com.boot.service;

import java.util.List;
import com.boot.dto.InquiryDTO;
import com.boot.dto.InquiryReplyDTO;

public interface InquiryService {
    // 문의 작성
    int createInquiry(InquiryDTO inquiry);
    
    // 사용자별 문의 목록 조회
    List<InquiryDTO> getInquiryListByUserId(String userId);
    
    // 문의 상세 조회
    InquiryDTO getInquiryById(int inquiryId);
    
    // 관리자용: 전체 문의 목록 조회
    List<InquiryDTO> getAllInquiries();
    
    // 관리자용: 답변 대기 중인 문의만 조회
    List<InquiryDTO> getPendingInquiries();
    
    // 답변 작성
    int createReply(InquiryReplyDTO reply);

    // 답변 수정 (reply_id로)
    int updateReply(InquiryReplyDTO reply);
    
    // inquiry_id로 답변 조회
    InquiryReplyDTO getReplyByInquiryId(int inquiryId);
    
    // 문의 삭제
    int deleteInquiry(int inquiryId);

}
