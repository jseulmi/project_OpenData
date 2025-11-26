package com.boot.dto;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class InquiryReplyDTO {
    private int reply_id;
    private int inquiry_id;
    private String admin_id;
    private String reply_content;
    private Date created_date;
    
    // 조인용 필드
    private String admin_name;
}