package com.boot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.boot.dto.InquiryDTO;
import com.boot.dto.InquiryReplyDTO;

@Mapper
public interface InquiryDAO {
    // 문의 작성
    int insertInquiry(InquiryDTO inquiry);
    
    // 사용자별 문의 목록 조회
    List<InquiryDTO> selectInquiryByUserId(@Param("user_id") String userId);
    
    // 문의 상세 조회 (답변 포함)
    InquiryDTO selectInquiryById(@Param("inquiry_id") int inquiryId);
    
    // 관리자용: 전체 문의 목록 조회
    List<InquiryDTO> selectAllInquiries();
    
    // 관리자용: 답변 대기 중인 문의만 조회
    List<InquiryDTO> selectPendingInquiries();
    
    // 답변 작성
    int insertReply(InquiryReplyDTO reply);
    
    // 답변 수정 (reply_id로)
    int updateReply(InquiryReplyDTO reply);
    
    // inquiry_id로 답변 조회
    InquiryReplyDTO selectReplyByInquiryId(@Param("inquiry_id") int inquiryId);
    
    // 문의 상태 업데이트 (답변완료로 변경)
    int updateInquiryStatus(@Param("inquiry_id") int inquiryId, @Param("status") String status);
    
    // 문의 삭제
    int deleteInquiry(@Param("inquiry_id") int inquiryId);
    
    // 답변 삭제
    int deleteReply(@Param("reply_id") int replyId);
}
