package com.groupware.user;

import java.util.List;

public interface UserService {
	// 로그인: 아이디로 사용자 정보 조회함.
	UserVO selectUserById(String userId);

	// 관리자: 전체 사용자 목록 조회
	List<UserVO> selectUserList();

	// 관리자: 사용자 팀/권한 변경
	void updateUserByAdmin(String userId, int teamId, String role);

	// 관리자: 사용자 비활성화(소프트 삭제)
	void deleteUser(String userId);
	
	// 내 프로필: 이름/이메일 수정
	void updateProfile(String userId, String userName, String email);
	
	// 내 프로필: 비밀번호 재설정
	void resetPassword(String userId, String email, String newPw);
	
	// 회원가입: 아이디 중복 확인
	boolean isUserIdAvailable(String userId);
	
	// 회원가입: 신규 사용자 등록 
	void insertUser(UserVO userVO);
}