package com.groupware.user;

public interface UserService {
	// 로그인: 아이디로 사용자 정보 조회함. 
	UserVO selectUserById(String userId) throws Exception;
}
