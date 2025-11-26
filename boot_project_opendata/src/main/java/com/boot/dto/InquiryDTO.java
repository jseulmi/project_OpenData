package com.boot.dto;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class InquiryDTO {
    private int inquiry_id;
    private String user_id;
    private String title;
    private String content;
    private String status;  // '대기중', '답변완료'
    private Date created_date;
    private Date updated_date;
    
    // 조인용 필드
    private String user_name;  // 작성자 이름
    private InquiryReplyDTO reply;  // 답변 정보
}