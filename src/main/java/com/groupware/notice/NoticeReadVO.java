package com.groupware.notice;

import java.util.Date;
import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class NoticeReadVO {
    private int readId;       // read_id
    private int noticeId;     // notice_id
    private String userId;    // user_id
    private Date readAt;      // read_at
}