-- =============================================
-- 사내 그룹웨어 포털 시스템 DDL
-- 생성일: 2026.06.24
-- =============================================

-- 사용자 계정 생성 (system 계정으로 실행)
CREATE USER groupware IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE, DBA TO groupware;

-- groupware 계정으로 전환 후 아래 실행
ALTER SESSION SET CURRENT_SCHEMA = groupware;

-- =============================================
-- 1. 조직 계층 테이블
-- =============================================

-- 회사 테이블
CREATE TABLE COMPANY (
    company_id    NUMBER          PRIMARY KEY,
    company_name  VARCHAR2(100)   NOT NULL,
    created_at    DATE            DEFAULT SYSDATE
);

-- 팀 테이블
CREATE TABLE TEAM (
    team_id       NUMBER          PRIMARY KEY,
    company_id    NUMBER          NOT NULL,
    team_name     VARCHAR2(100)   NOT NULL,
    created_at    DATE            DEFAULT SYSDATE,
    CONSTRAINT fk_team_company FOREIGN KEY (company_id) REFERENCES COMPANY(company_id)
);

-- 사용자 테이블
CREATE TABLE USERS (
    user_id       VARCHAR2(50)    PRIMARY KEY,
    team_id       NUMBER          NOT NULL,
    user_pw       VARCHAR2(200)   NOT NULL,
    user_name     VARCHAR2(50)    NOT NULL,
    email         VARCHAR2(100),
    role          VARCHAR2(20)    DEFAULT 'USER',  -- USER / TEAM_LEADER / ADMIN
    created_at    DATE            DEFAULT SYSDATE,
    deleted_at    DATE,
    CONSTRAINT fk_users_team FOREIGN KEY (team_id) REFERENCES TEAM(team_id)
);

-- =============================================
-- 2. 공지사항 테이블
-- =============================================

CREATE TABLE NOTICE (
    notice_id     NUMBER          PRIMARY KEY,
    writer_id     VARCHAR2(50)    NOT NULL,
    title         VARCHAR2(200)   NOT NULL,
    content       CLOB,
    view_cnt      NUMBER          DEFAULT 0,
    created_at    DATE            DEFAULT SYSDATE,
    deleted_at    DATE,
    CONSTRAINT fk_notice_writer FOREIGN KEY (writer_id) REFERENCES USERS(user_id)
);

-- 공지 읽음 확인 테이블 (브릿지 테이블)
CREATE TABLE NOTICE_READ (
    read_id       NUMBER          PRIMARY KEY,
    notice_id     NUMBER          NOT NULL,
    user_id       VARCHAR2(50)    NOT NULL,
    read_at       DATE            DEFAULT SYSDATE,
    CONSTRAINT fk_nread_notice FOREIGN KEY (notice_id) REFERENCES NOTICE(notice_id),
    CONSTRAINT fk_nread_user   FOREIGN KEY (user_id)   REFERENCES USERS(user_id),
    CONSTRAINT uq_notice_read  UNIQUE (notice_id, user_id)  -- 중복 읽음 방지
);

-- =============================================
-- 3. 게시판 테이블
-- =============================================

CREATE TABLE BOARD (
    board_id      NUMBER          PRIMARY KEY,
    team_id       NUMBER          NOT NULL,
    writer_id     VARCHAR2(50)    NOT NULL,
    title         VARCHAR2(200)   NOT NULL,
    content       CLOB,
    created_at    DATE            DEFAULT SYSDATE,
    deleted_at    DATE,
    CONSTRAINT fk_board_team   FOREIGN KEY (team_id)   REFERENCES TEAM(team_id),
    CONSTRAINT fk_board_writer FOREIGN KEY (writer_id) REFERENCES USERS(user_id)
);

-- 댓글 테이블
CREATE TABLE BOARD_COMMENT (
    comment_id    NUMBER          PRIMARY KEY,
    board_id      NUMBER          NOT NULL,
    writer_id     VARCHAR2(50)    NOT NULL,
    content       CLOB            NOT NULL,
    created_at    DATE            DEFAULT SYSDATE,
    deleted_at    DATE,
    CONSTRAINT fk_comment_board  FOREIGN KEY (board_id)  REFERENCES BOARD(board_id),
    CONSTRAINT fk_comment_writer FOREIGN KEY (writer_id) REFERENCES USERS(user_id)
);

-- =============================================
-- 4. 일정 테이블
-- ============================================= 

CREATE TABLE SCHEDULE (
    schedule_id   NUMBER          PRIMARY KEY,
    user_id       VARCHAR2(50)    NOT NULL,
    title         VARCHAR2(200)   NOT NULL,
    start_dt      DATE            NOT NULL,
    end_dt        DATE,
    color         VARCHAR2(20)    DEFAULT '#3788d8',
    type          VARCHAR2(10)    DEFAULT 'PERSONAL',  -- 'PERSONAL'=개인, 'TEAM'=팀
    team_id       NUMBER,                               -- 팀 일정일 때만 값 있음, 개인이면 NULL
    created_at    DATE            DEFAULT SYSDATE,
    deleted_at    DATE,
    CONSTRAINT fk_schedule_user FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    CONSTRAINT fk_schedule_team FOREIGN KEY (team_id) REFERENCES TEAM(team_id)
);

-- 시퀀스 생성
CREATE SEQUENCE seq_schedule START WITH 1 INCREMENT BY 1;

-- =============================================
-- 5. 쪽지 테이블
-- =============================================

CREATE TABLE MESSAGE (
    msg_id        NUMBER          PRIMARY KEY,
    sender_id     VARCHAR2(50)    NOT NULL,
    receiver_id   VARCHAR2(50)    NOT NULL,
    title         VARCHAR2(200)   NOT NULL,
    content       CLOB,
    is_read       CHAR(1)         DEFAULT 'N',  -- N: 안읽음 / Y: 읽음
    sent_at       DATE            DEFAULT SYSDATE,
    deleted_at    DATE,
    CONSTRAINT fk_msg_sender   FOREIGN KEY (sender_id)   REFERENCES USERS(user_id),
    CONSTRAINT fk_msg_receiver FOREIGN KEY (receiver_id) REFERENCES USERS(user_id)
);

-- =============================================
-- 6. 첨부파일 테이블 (공지 + 게시판 공통)
-- =============================================

CREATE TABLE ATTACH_FILE (
    file_id       NUMBER          PRIMARY KEY,
    ref_type      VARCHAR2(20)    NOT NULL,  -- 'NOTICE' 또는 'BOARD'
    ref_id        NUMBER          NOT NULL,
    orig_name     VARCHAR2(200)   NOT NULL,
    save_path     VARCHAR2(500)   NOT NULL,
    file_size     NUMBER,
    uploaded_at   DATE            DEFAULT SYSDATE,
    deleted_at    DATE
);

-- =============================================
-- 7. 시퀀스 (PK 자동 증가용)
-- =============================================

CREATE SEQUENCE seq_company    START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_team       START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_notice     START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_notice_read START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_board      START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_comment    START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_schedule   START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_message    START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_attach     START WITH 1 INCREMENT BY 1 NOCACHE; 


-- =============================================
-- 8. 테스트 데이터 추가
-- =============================================

-- 1. 회사 데이터
INSERT INTO COMPANY (company_id, company_name, created_at) 
VALUES (seq_company.NEXTVAL, 'kopo', SYSDATE);

-- 2. 팀 데이터
INSERT INTO TEAM (team_id, company_id, team_name, created_at) 
VALUES (seq_team.NEXTVAL, 1, '개발팀', SYSDATE); 

INSERT INTO TEAM (team_id, company_id, team_name) VALUES (2, 1, '기획팀');
INSERT INTO TEAM (team_id, company_id, team_name) VALUES (3, 1, '디자인팀');
INSERT INTO TEAM (team_id, company_id, team_name) VALUES (4, 1, '인사팀');
INSERT INTO TEAM (team_id, company_id, team_name) VALUES (5, 1, '회계팀');
INSERT INTO TEAM (team_id, company_id, team_name) VALUES (6, 1, '홍보팀');
INSERT INTO TEAM (team_id, company_id, team_name) VALUES (7, 1, '관리자');

COMMIT;

-- 3. 관리자 계정
INSERT INTO USERS (user_id, team_id, user_pw, user_name, email, role, created_at) 
VALUES ('admin', 1, '1234', '관리자', 'admin@test.com', 'ADMIN', SYSDATE);

-- 4. 일반 직원 계정
INSERT INTO USERS (user_id, team_id, user_pw, user_name, email, role, created_at) 
VALUES ('user01', 1, '1234', '홍길동', 'user01@test.com', 'USER', SYSDATE);

INSERT INTO USERS (user_id, team_id, user_pw, user_name, email, role, created_at) 
VALUES ('user02', 3, '1234', '고길동', 'user02@test.com', 'USER', SYSDATE);

INSERT INTO USERS (user_id, team_id, user_pw, user_name, email, role, created_at) 
VALUES('user03', 4, '1234', '박길동', 'user03@test.com', 'USER', SYSDATE);
 
 INSERT INTO USERS (user_id, team_id, user_pw, user_name, email, role, created_at) 
VALUES('user04', 5, '1234', '이길동', 'user04@test.com', 'USER', SYSDATE);

INSERT INTO USERS (user_id, team_id, user_pw, user_name, email, role, created_at) 
VALUES('user05', 6, '1234', '김길동', 'user05@test.com', 'USER', SYSDATE);

INSERT INTO USERS (user_id, team_id, user_pw, user_name, email, role, created_at) 
VALUES ('user06', 1, '1234', '정길동', 'user01@test.com', 'USER', SYSDATE);


-- 5. 저장!
COMMIT;

SELECT *
FROM ATTACH_FILE af 

SELECT *
FROM SCHEDULE s 