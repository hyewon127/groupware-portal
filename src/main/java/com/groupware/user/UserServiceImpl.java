package com.groupware.user;

import java.util.Map;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service // Spring이 이 클래스를 Service Bean으로 등록
public class UserServiceImpl implements UserService {
	
	@Autowired //DB 조회 기능 필수 !  Spring이 UserMapper 구현체를 자동으로 주입해줌
	private UserMapper userMapper; 
	
	@Override 
	public UserVO selectUserById(String userId){
		// 로그인 아이디로 사용자 조회
		return userMapper.selectUserById(userId);
	}

	@Override
	public List<UserVO> selectUserList() {
		// 관리자 화면용 전체 사용자 목록 조회
		return userMapper.selectUserList();
	}

	@Override
	public void updateUserByAdmin(String userId, int teamId, String role) {
		// 사용자 팀,권한 변경
		// 개별 파라미터를 Map으로 묶어서 Mapper에 전달
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("teamId", teamId);
		params.put("role", role);
		userMapper.updateUserByAdmin(params);
		
	}

	@Override
	public void deleteUser(String userId) {
		// 사용자 비활성화(소프트삭제)
		userMapper.deleteUser(userId);
	}

	@Override
	public void updateProfile(String userId, String userName, String email) {
		// 내 프로필 수정
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("userName", userName);
		params.put("email", email);
		userMapper.updateProfile(params);
		
	}

	@Override
	public void resetPassword(String userId, String email, String newPw) {
		// 비밀번호 재설정
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("email", email);
		params.put("newPw", newPw);
		userMapper.resetPassword(params);
	}

	@Override
	public boolean isUserIdAvailable(String userId) {
		// 아이디 중복 확인
		// count가 0이면 사용 가능(true), 1 이상이면 이미 존재(false)
		int count = userMapper.countByUserId(userId);
		return count == 0;
	}

	@Override
	public void insertUser(UserVO userVO) {
		// 회원가입
		// SignupController 에서 role="USER" 고정 후 호출됨
		userMapper.insertUser(userVO);
		
	}
}


  