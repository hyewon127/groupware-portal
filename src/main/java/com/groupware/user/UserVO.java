package com.groupware.user;

import lombok.Data;
import lombok.ToString;
import java.util.Date;

// data 자동으로 getter/setter 만들어줌
// Tostring 자동으로 Tostring 넣어줌 

@Data 
@ToString
public class UserVO {
	private String userId;
	private int teamId;
	private String userPw;
	private String userName;
	private String email;
	private String role;
	private Date createdAt;
	private Date deletedAt;
}