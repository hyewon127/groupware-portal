package com.groupware.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service // Spring이 이 클래스를 Service Bean으로 등록
public class UserServiceImpl implements UserService {
	
	@Autowired //DB 조회 기능 필수 !  Spring이 UserMapper 구현체를 자동으로 주입해줌
	private UserMapper userMapper; 
	
	@Override // UserService 인터페이스의 메서드를 구현
	public UserVO selectUserById(String userId) throws Exception{
		// Mapper한테 SQL 실행 위임하고 결과 그대로 반환
		return userMapper.selectUserById(userId);
	}
}
   