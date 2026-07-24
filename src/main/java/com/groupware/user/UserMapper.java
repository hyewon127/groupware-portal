package com.groupware.user;

import java.util.List;
import java.util.Map;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface UserMapper {
	// 로그인: 아이디로 사용자 정보 조회함.
		UserVO selectUserById(String userId);

	// 관리자: 전체 사용자 목록 조회
	List<UserVO> selectUserList();

	// 관리자: 사용자 팀/권한 변경
	// mapper 은 여러개의 파라미터를 못받기 때문에 map 으로 변경함. 
	void updateUserByAdmin(Map<String, Object> params);

	// 관리자: 사용자 비활성화(소프트 삭제)
	void deleteUser(String userId);
	
	// 내 프로필: 이름/이메일 수정
	void updateProfile(Map<String, Object> params);
	
	// 내 프로필: 비밀번호 재설정
	void resetPassword(Map<String, Object> params);
	
	// 회원가입: 아이디 중복 확인
	// service: boolean isUserIdAvailable(String userId);
	// 0 이면 사용 가능, 1이면 이미 존재로 하기 위해 int
	int countByUserId(String userId);
	
	// 회원가입: 신규 사용자 등록 
	void insertUser(UserVO userVO);
}