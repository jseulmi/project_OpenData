<div align="center">

# 🌫️ 전국 미세먼지 실시간 지도 서비스  
### 공공데이터 API + Kakao Map + Spring Boot + Oracle 통합 프로젝트

<br>

<img src="https://img.shields.io/badge/Java-17-007396?logo=java">
<img src="https://img.shields.io/badge/SpringBoot-2.7-6DB33F?logo=springboot">
<img src="https://img.shields.io/badge/MyBatis-000000">
<img src="https://img.shields.io/badge/Oracle-F80000?logo=oracle">
<img src="https://img.shields.io/badge/KakaoMapAPI-FFCD00">
<img src="https://img.shields.io/badge/PublicData-0052CC">
<img src="https://img.shields.io/badge/AWS-232F3E?logo=amazonaws">

<br><br>
</div>

---

## 📖 프로젝트 개요

공공데이터 포털의 전국 미세먼지 측정소 데이터를 수집하고  
카카오 지도 API와 좌표 변환을 활용하여  
**“전국 대기질 정보의 실시간 시각화”**를 구현한 프로젝트입니다.

- 개발 기간 : 1차: `2025.11.03 ~ 2025.11.10`, 2차: `2025.11.24 ~ 2025.11.30`
- 개발 인원 : `7명`

---

### 👨‍💻 담당 역할

- 🧑‍🏫 **팀장** — 일정 관리, 업무 분배, 코드 리뷰 및 프로젝트 총괄
- 🔐 **사용자 기능** — 로그인 페이지, 회원가입 페이지 UI 및 백엔드 구현
- 🛠 **관리자 기능** — 관리자 게시판 구축, 공지사항 CRUD 기능 개발
- 🗂 **DB 설계** — 유저 테이블 구조 설계
- 🌐 **공공데이터 연동** — 대기질 공공데이터 API 연동 및 JSON 파싱
- 🗺️ **지도 시각화** — Kakao Map 기반 히트맵 구현 및 좌표 변환 처리
- ⚡ **성능 최적화** — Redis 캐싱, 스케줄러 기반 데이터 자동 업데이트
- 🚀 **서버 배포** — AWS EC2 기반 서버 구성 및 프로젝트 배포

- 주요 특징  
  - 🔐 **Spring Security + 관리자 전용 OTP 적용**  
    → 일반 회원은 세션 기반 로그인 / 관리자 로그인 시 OTP 2차 인증 적용
  
  - 🌐 **공공데이터 API 연동**  
    → 대기질 데이터를 수집·가공하여 지도·히트맵 기반 시각화 제공
  
  - 📊 **데이터 시각화 및 다운로드 기능**  
    → 지도 API, 히트맵, 미세먼지 등급 시각화, CSV/Excel 다운로드 지원
  
  - 🛠 **관리자 페이지 구축**  
    → 회원 관리, 게시판·공지사항 관리, 문의 리스트
  
  - 💬 **커뮤니티 기능 강화**  
    → 사용자 게시판, 댓글·대댓글, 공지사항, 1대1 문의 기능 제공
  
  - ⚡ **Redis + 스케줄러 기반 성능 최적화**  
    → 캐싱 처리 및 자동 데이터 업데이트 수행
  
  - 🤖 **Google Gemini 기반 챗봇 기능**  
    → 사용자 질문 응답, AI 상호작용 기능 지원
  
  - 🚀 **AWS EC2 기반 서버 배포**  
    → 서비스 운영 환경 구성 및 지속적인 유지보수

---

## 🛠 기술 스택

| 분야 | 기술 |
|------|-------|
| **Frontend** | <img src="https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white"> <img src="https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white"> <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black"> <img src="https://img.shields.io/badge/jQuery-0769AD?style=flat-square&logo=jquery&logoColor=white"> |
| **Backend** | <img src="https://img.shields.io/badge/JSP-FF4000?style=flat-square"> <img src="https://img.shields.io/badge/Java-007396?style=flat-square&logo=java&logoColor=white"> <img src="https://img.shields.io/badge/Spring%20Boot-6DB33F?style=flat-square&logo=springboot&logoColor=white"> <img src="https://img.shields.io/badge/Lombok-ED1C24?style=flat-square"> <img src="https://img.shields.io/badge/MyBatis-000000?style=flat-square"> |
| **Database** | <img src="https://img.shields.io/badge/Oracle%20Database-F80000?style=flat-square&logo=oracle&logoColor=white"> |
| **Infra / Server** | <img src="https://img.shields.io/badge/AWS%20EC2%20(Ubuntu)-FF9900?style=flat-square&logo=amazonaws&logoColor=white"> <img src="https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=flat-square&logo=apachetomcat&logoColor=black"> |
| **API / External Services** | <img src="https://img.shields.io/badge/공공데이터%20대기질%20API-008FC7?style=flat-square"> <img src="https://img.shields.io/badge/Kakao%20Map%20API-FFCD00?style=flat-square&logo=kakao&logoColor=black"> |
| **Build Tool** |  <img src="https://img.shields.io/badge/Gradle-02303A?style=flat-square&logo=gradle&logoColor=white"> |
| **Tools** | <img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/STS-6DB33F?style=flat-square&logo=spring&logoColor=white"> <img src="https://img.shields.io/badge/Figma-F24E1E?style=flat-square&logo=figma&logoColor=white"> <img src="https://img.shields.io/badge/SourceTree-0052CC?style=flat-square&logo=sourcetree&logoColor=white"> |


---

## ✨ 주요 기능

### 🔐 인증 / 회원 기능
- 회원가입(약관 동의 포함)
- 로그인 / 소셜 로그인(Naver, Google)
- 관리자 로그인 시 OTP 2차 인증
- 아이디·비밀번호 찾기
- 마이페이지(조회, 수정, 삭제)
- 탈퇴 회원 관리
- 로그인 실패 횟수 제한 및 계정 잠금 처리

### 🧭 사용자 기능
- 지역별 대기질 정보 조회
- 미세먼지 등급 확인
- 지도 기반 시각화(Kakao Map API)
- 히트맵 기반 지역 오염도 표시  
- CSV / Excel 데이터 다운로드


### 💬 커뮤니티 기능
- 사용자 게시판 (작성 / 수정 / 삭제 / 조회)
- 공지사항 조회
- 댓글 / 대댓글 기능
- 1대1 문의 기능


### 🌐 공공데이터 기능
- 공공데이터 API 연동(대기질 정보)
- 실시간 미세먼지 정보 제공
- 지도 기반 위치 시각화
- 히트맵 구현


### 🛠 관리자 기능
- **회원 관리** (회원 정보 조회, 상태 변경, 탈퇴 회원 관리)
- **게시판 관리** (사용자 게시판·공지사항)
- **문의 리스트 관리** (1대1 문의 조회 및 대응)


### ⚡ 성능 최적화 및 서버 기능
- Redis 캐싱 처리
- Spring Scheduler 기반 자동 데이터 업데이트
- AWS EC2 서버 배포 및 환경 구성

---

## 🧭 메뉴 구조도 (PDF)

📄 메뉴 구조도 보기  
👉 [menu-structure-opendata.pdf](https://github.com/user-attachments/files/24016774/menu-structure-opendata.pdf)

---

## 🖥 화면 설계서 (PDF)

📄 화면 기획서 보기  
👉 [ui-design-opendata.pdf](https://github.com/user-attachments/files/24016796/ui-design-opendata.pdf)

---

## 🗂 ERD 및 테이블 명세서 (PDF)

📄 ERD  
</details> <details> <summary><strong>ERD 다이어그램</strong> </summary>
  
<img width="1256" height="1110" alt="image" src="https://github.com/user-attachments/assets/0f7df47b-a454-498e-87ec-5de1a9bd6295" />

</details>

📄 테이블 명세서  
➡ [table-definition-opendata.ods](https://github.com/user-attachments/files/24016807/table-definition-opendata.ods)

---

## 🔍 핵심 구현 내용 (내가 담당한 기능)

🔐 인증 / 회원 기능
<details> <summary><strong>회원가입(이용약관 제외)</strong> </summary>
  

https://github.com/user-attachments/assets/b6460b8f-cad2-4be1-91ca-a687748cacbc


📌 설명

사용자가 회원 정보를 입력하면
중복 여부를 확인한 후 회원 계정을 생성하도록 구현했습니다.

회원 가입 이후 로그인 시
세션 기반 인증 방식을 통해 인증 상태를 유지하며,
로그아웃 시에는 세션을 만료시켜
인증 정보가 즉시 해제되도록 처리했습니다.

</details> 
<details> <summary><strong>로그인 / 소셜 로그인(Kakao · Naver · Google)</strong> </summary>
  

https://github.com/user-attachments/assets/f97c4558-39a1-4a84-ad1c-219ca3b1f80c


📌 설명

일반 로그인과 함께
카카오, 네이버, 구글 OAuth2 기반 소셜 로그인을 구현했습니다.

소셜 로그인은
인증 요청 → 액세스 토큰 발급 → 사용자 정보 조회 흐름으로 동작하며,
전달받은 이메일을 기준으로 기존 회원 여부를 확인합니다.

이미 동일한 이메일로 가입된 계정이 존재하는 경우에는
중복 계정 생성을 방지하기 위해 소셜 로그인을 제한하며,
로그인 이후에는 세션을 생성하여 인증 상태를 관리합니다.

</details> 
<details> <summary><strong>아이디·비밀번호 찾기</strong> </summary>
  

https://github.com/user-attachments/assets/6a2e609e-06a8-4e50-8fb7-e4aa0b904993


📌 설명

아이디 찾기는 가입 시 등록한 이메일을 입력받아
해당 이메일에 연결된 계정 정보를 조회하는 방식으로 구현했습니다.

비밀번호 재설정은
아이디와 이메일 정보를 함께 입력받아 사용자를 검증한 후,
이메일로 인증 코드를 발송하여
정상적으로 확인된 경우에만 비밀번호 변경이 가능하도록 처리했습니다.

인증 코드 오류, 만료, 잘못된 요청에 대한 예외 처리를 포함하여
계정 복구 과정이 안전하게 동작하도록 구성했습니다.

</details>
<details> <summary><strong>탈퇴 회원 관리 및 계정 상태 관리</strong> </summary>


https://github.com/user-attachments/assets/d365a481-4a78-4656-9f28-fa7e0df854b0


📌 설명

회원 탈퇴 시 실제 데이터 삭제가 아닌
계정 상태 값을 변경하는 방식으로 처리했습니다.

탈퇴된 계정은 로그인 및 서비스 이용이 제한되며,
인증 단계에서 계정 상태를 확인하여
비활성화된 계정은 접근할 수 없도록 구현했습니다.

이를 통해 탈퇴 회원과 활성 회원을 구분하여
계정 상태를 기준으로 서비스 접근을 제어했습니다.

</details>
🧭 사용자 기능
<details> <summary><strong>지역 데이터 기반 히트맵 시각화 및 CSV / Excel 다운로드 기능</strong> </summary>


https://github.com/user-attachments/assets/073a4ec9-f05a-411a-a58e-99cc3a832ef9


  
📌 설명
공공데이터 포털의 대기질 정보를 활용하여
지역별 데이터를 시각화한 히트맵 화면을 구현했습니다.

대기질 수치에 따라 색상이 자동으로 변경되며,
사용자는 대기질 데이터를
CSV 및 Excel 파일로 다운로드할 수 있도록 구성했습니다.

</details>
🛠 관리자 기능
<details> <summary><strong>게시판 관리(공지사항·사용자게시판)</strong> </summary>

https://github.com/user-attachments/assets/615a5af3-017a-463b-9a19-702cc39b9d67

📌 설명

관리자 전용 공지사항 작성, 수정, 삭제 기능을 구현했습니다.

사용자 게시판의 게시글을
관리자 권한으로 조회 및 관리할 수 있도록 구성하여,
운영 관점에서 게시판을 관리할 수 있도록 했습니다.
</details>
⚡ 성능 / 서버 기능
<details> <summary><strong>Redis 기반 캐싱 처리</strong> </summary>
  

https://github.com/user-attachments/assets/231b740e-3b4a-4050-a53b-2690e559d5c7


📌 설명

공공데이터 API를 통해 대기질 정보를 조회할 때
Redis를 활용하여 조회 결과를 캐싱하도록 구현했습니다.

동일 조건의 요청이 반복될 경우
Redis에 저장된 데이터를 우선 반환하여
외부 공공데이터 API 호출 횟수를 줄이도록 처리했습니다.

</details> <details> <summary><strong>Spring Scheduler 기반 자동 업데이트</strong> </summary>
📌 설명

Spring Scheduler를 활용하여
공공데이터 API를 주기적으로 호출하고,
해당 결과를 Redis 캐시에 갱신하도록 구현했습니다.

이를 통해 사용자가 요청할 때마다
외부 API를 호출하지 않도록 구성하였으며,
일정 주기마다 최신 데이터가 반영되도록 처리했습니다

</details> <details> <summary><strong>AWS EC2 / 서버 배포</strong> </summary>
  

https://github.com/user-attachments/assets/47f7486c-4c2f-4b3f-9670-5192d88b1f9e


📌 설명

AWS EC2(Ubuntu) 환경에 서버를 배포하고,
Tomcat을 연동하여 서비스를 운영했습니다.

외부에서 서비스에 접근할 수 있도록
배포 및 실행 환경을 구성했습니다.

</details>

---

## 📬 프로젝트 구조

```plaintext
📦 boot_project_opendata
├─ src/main/java
│  ├─ com.boot.client
│  ├─ com.boot.config
│  ├─ com.boot.controller
│  ├─ com.boot.dao
│  ├─ com.boot.dto
│  ├─ com.boot.scheduler
│  ├─ com.boot.security
│  ├─ com.boot.service
│  └─ com.boot.util
│
├─ src/main/resources
│  ├─ mybatis.mappers
│  ├─ static
│  ├─ application.properties
│  └─ mybatis-config.xml
│ 
└─ src/main/webapp/WEB-INF
   └─ views
      ├─ admin
      ├─ board
      ├─ inquiry
      └─ notice
```

---

## 🚀 시연 영상 & 데모

아래 영상은 지역별 미세농도(대기질 정보)의 주요 기능을 실제 화면과 함께 보여줍니다.  
각 기능별 동작 방식과 흐름을 직관적으로 확인할 수 있습니다.

### 📌 전체 시연 영상
🔗 YouTube 링크: https://youtu.be/Hnlj6WZI0oQ (사용자)<br>
🔗 YouTube 링크: https://youtu.be/cv0jVy17Loc (관리자)

또는  
🎥 EC2 배포 버전 직접 테스트: [http://3.26.104.30:8484/main](http://3.26.104.30:8484/main)

---

