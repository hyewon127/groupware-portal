# 🏢 사내 그룹웨어 포털 시스템 (Groupware Portal)

전자정부프레임워크(eGovFrame 4.3.1, Spring MVC) 기반으로 **공지사항 · 사내 게시판 · 일정 관리 · 쪽지 · 대시보드**를 통합한 사내 그룹웨어 포털입니다.
`COMPANY → TEAM → USER` 계층 구조로 조직을 관리하며, FullCalendar 기반의 캘린더 UI로 일정을 관리합니다.

| 항목 | 내용 |
|---|---|
| 개발자 | 차혜원 |
| 개발 기간 | 2026.06.22 ~ 2026.07.09 |
| 대상 | 사내 모든 직원 (일반 직원 / 팀장 / 관리자) |

---

## 🛠 기술 스택

| 구분 | 스택 |
|---|---|
| Backend | 전자정부프레임워크(eGovFrame) 4.3.1, Spring MVC, MyBatis |
| Language | Java 17 |
| Database | Oracle XE 21c (Docker) |
| Frontend | JSP, Bootstrap 5, jQuery, FullCalendar v6 |
| Build | Maven |
| IDE | eGovFrame Eclipse IDE (4.3.1) |
| Server | Apache Tomcat 9.0.x |
| 형상 관리 | GitHub (`main` / `develop` / `feature/*` 브랜치 전략) |

---

## 🧩 주요 기능

| 기능 | 설명 |
|---|---|
| 로그인/로그아웃 | ID/PW 기반 로그인, 세션 처리 |
| 메인 대시보드 | 최근 공지 3건, 안 읽은 쪽지 수, 오늘 일정 요약 카드 |
| 공지사항 | 등록/수정/삭제(관리자), 목록/상세 조회, **다중 파일 업로드/다운로드**, 읽음 확인 |
| 사내 게시판 | 팀별 게시판 탭 구분, 글 CRUD, 댓글 CRUD, 파일 첨부 |
| 일정 관리 | FullCalendar 월별 캘린더, 개인/팀 일정 구분, 날짜 클릭 시 일정 리스트, CRUD |
| 쪽지 | 수신자 검색 후 발송, 받은함/보낸함 조회, 읽음 처리 |
| 관리자 | 사용자 목록 조회/수정/삭제 |
| 마이페이지 | 프로필 수정, 비밀번호 변경 |

---

## 🗺 화면 구성 (사이트맵)

```
로그인
 └─ 메인 대시보드
     ├─ 공지사항 (목록 / 상세 / 등록 / 수정)
     ├─ 게시판 (팀별 탭 / 목록 / 상세 / 등록 / 수정 / 댓글)
     ├─ 일정 관리 (캘린더 / 날짜별 리스트 / 등록 / 수정)
     ├─ 쪽지 (받은함 / 보낸함 / 작성 / 상세)
     ├─ 마이페이지 (프로필 / 비밀번호 변경)
     └─ 관리자 (사용자 관리)
```

> 상세 화면 정의는 저장소 루트의 `docs/` 폴더 (기획서, 요구사항정의서, 테이블정의서, 화면정의서) 참고

---

## 📂 프로젝트 구조

```
groupware-portal/
├─ src/main/java/com/groupware/
│  ├─ user/       # 로그인, 회원가입, 프로필, 관리자
│  ├─ notice/     # 공지사항 (VO / Mapper / Service / Controller)
│  ├─ board/      # 사내 게시판 + 댓글
│  ├─ schedule/   # 일정 관리 (FullCalendar 연동)
│  ├─ message/    # 쪽지
│  └─ main/       # 대시보드
├─ src/main/resources/
│  ├─ egovframework/spring/   # DataSource, MyBatis, 트랜잭션 등 Spring 설정
│  └─ mappers/                # MyBatis Mapper XML (SQL)
├─ src/main/webapp/
│  ├─ WEB-INF/views/          # JSP (notice, board, schedule, message, user, main)
│  ├─ WEB-INF/config/         # dispatcher-servlet.xml, validator 설정
│  └─ WEB-INF/web.xml
├─ init/
│  └─ 01_create_tables.sql    # Oracle DDL + 시퀀스 + 테스트 데이터
├─ docker-compose.yml         # Oracle XE 컨테이너
└─ pom.xml
```

각 기능은 **VO → Mapper(XML) → Mapper(interface) → Service/ServiceImpl → Controller → JSP** 의 동일한 레이어 구조로 구성되어 있어, 하나의 기능(예: notice)을 이해하면 나머지 기능도 같은 패턴으로 읽을 수 있습니다.

---

## 🗄 ERD 개요

```
COMPANY 1─N TEAM 1─N USERS
USERS 1─N NOTICE 1─N NOTICE_READ (읽음 확인, unique(notice_id, user_id))
TEAM   1─N BOARD 1─N BOARD_COMMENT
USERS 1─N SCHEDULE (개인/팀 일정, type: PERSONAL/TEAM)
USERS 1─N MESSAGE (sender_id, receiver_id)
ATTACH_FILE (ref_type: NOTICE/BOARD, ref_id로 다형성 참조)
```

전체 DDL은 [`init/01_create_tables.sql`](./init/01_create_tables.sql) 참고 — 컨테이너 최초 기동 시 자동 실행됩니다.

---

## 🚀 시작하기 (Quick Start)

### 0. 사전 준비물

- Java 17 (JDK)
- Maven 3.8+
- Docker / Docker Compose
- eGovFrame Eclipse IDE 4.3.1 ([다운로드](https://www.egovframe.go.kr)) — 또는 일반 Eclipse + Spring/Maven 플러그인
- Oracle JDBC Driver(`ojdbc`) — 라이선스 문제로 Maven Central에 없음. [Oracle 공식 사이트](https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html)에서 직접 다운로드 후 `src/main/webapp/WEB-INF/lib`에 배치

### 1. 클론

```bash
git clone https://github.com/hyewon127/groupware-portal.git
cd groupware-portal
```

### 2. Oracle XE 실행 (Docker)

루트에 `.env` 파일 생성 후 관리자 비밀번호 지정:

```bash
# .env
ORACLE_PASSWORD=원하는_비밀번호
```

```bash
docker compose up -d
```

컨테이너가 처음 뜰 때 `init/01_create_tables.sql`이 자동 실행되어 `groupware` 스키마 계정과 테이블, 테스트 데이터가 생성됩니다. (`GRANT`, `CREATE USER`가 포함되어 있으므로 반드시 최초 1회만 실행되도록 두세요)

> DB 연결 정보 기본값: `groupware` / `1234` (`init/01_create_tables.sql` 상단 참고)

### 3. Spring 설정 파일 준비

`src/main/resources/egovframework/spring/context-datasource.xml`에서 Oracle 접속 정보를 확인/수정하세요:

```xml
<bean id="dataSource" class="org.apache.commons.dbcp2.BasicDataSource" destroy-method="close">
    <property name="driverClassName" value="oracle.jdbc.driver.OracleDriver"/>
    <property name="url" value="jdbc:oracle:thin:@localhost:1521/XEPDB1" />
    <property name="username" value="groupware"/>
    <property name="password" value="1234"/>
</bean>
```

MyBatis 연동(`context-mapper.xml`)은 `com.groupware` 패키지 전체를 스캔하도록 설정되어 있어 별도 매퍼 등록 없이 바로 동작합니다.

### 4. 이클립스에서 실행

1. eGovFrame Eclipse IDE에서 `Import > Maven > Existing Maven Projects`로 프로젝트 임포트
2. 프로젝트 우클릭 → `Run As > Run on Server` → Tomcat 9 선택
3. 브라우저에서 `http://localhost:8080/groupware-portal` 접속 → `index.jsp`가 자동으로 `/login.do`로 리다이렉트

### 5. 테스트 계정

| ID | PW | 권한 | 소속팀 |
|---|---|---|---|
| admin | 1234 | 관리자 | 개발팀 |
| user01 | 1234 | 일반 직원 | 개발팀 |
| user02 | 1234 | 일반 직원 | 디자인팀 |
| user03 | 1234 | 일반 직원 | 인사팀 |

---

## 📎 첨부파일 업로드 경로 관련 주의사항

`NoticeController` / `BoardController`는 `request.getServletContext().getRealPath("/upload/...")`를 사용해 업로드 파일을 저장합니다. 이 경로는 WAS(Tomcat)의 배포 임시 폴더(예: Eclipse의 `wtpwebapps`) 하위이기 때문에, **서버를 Clean/재배포하면 이전에 업로드한 실제 파일이 삭제됩니다** (DB의 첨부파일 레코드는 유지되어 다운로드 시 `FileNotFoundException` 발생 가능). 운영 환경에서는 웹앱 외부의 고정 경로(예: `C:/upload/` 또는 `/var/groupware/upload/`)로 변경해 사용하는 것을 권장합니다.

---

## 🌿 브랜치 전략

```
main       # 배포 브랜치
 └─ develop
     ├─ feature/notice
     ├─ feature/board
     ├─ feature/schedule
     ├─ feature/message
     └─ feature/dashboard
```

기능 단위 브랜치에서 작업 후 `develop`으로 병합, 최종적으로 `main`에 반영합니다.

---

## 📄 License

Apache License 2.0 (전자정부프레임워크 기본 라이선스 준용)
