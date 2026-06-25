package com.groupware.user;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface UserMapper {
	// 로그인: 아이디로 사용자 정보 조회함. 
	UserVO selectUserById(String userId) throws Exception;
}
