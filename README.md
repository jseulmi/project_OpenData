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
- 배포 URL : http://3.26.104.30:8484/main

---

### 👨‍💻 담당 역할

- 마이페이지
  - 회원정보 조회 : 로그인 사용자 기준 회원 정보 조회 및 화면 출력
  - 회원정보 수정 : 회원 정보 수정 기능 구현 및 입력값 유효성 검증 처리
  - 회원 탈퇴 : 회원 탈퇴 기능 구현 및 탈퇴 확인 로직 적용
  - 사용자가 작성한 게시판 조회 : 사용자가 작성한 게시글 목록 조회 기능 구현
  - 관심 지역 조회 및 삭제 : 관심 지역 조회 및 삭제 기능 구현으로 개인화 서비스 제공

---
### ✨ 주요 특징

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

<details>
<summary><strong>🔐 인증 / 회원 기능</strong></summary>

- 회원가입(약관 동의 포함)  
- 로그인 / 소셜 로그인(Naver, Google)  
- 관리자 로그인 시 OTP 2차 인증  
- 아이디·비밀번호 찾기  
- 마이페이지(조회, 수정, 삭제)  
- 탈퇴 회원 관리  
- 로그인 실패 횟수 제한 및 계정 잠금 처리  

</details>

<details>
<summary><strong>🧭 사용자 기능</strong></summary>

- 지역별 대기질 정보 조회  
- 미세먼지 등급 확인  
- 지도 기반 시각화(Kakao Map API)  
- 히트맵 기반 지역 오염도 표시  
- CSV / Excel 데이터 다운로드  

</details>

<details>
<summary><strong>💬 커뮤니티 기능</strong></summary>

- 사용자 게시판 (작성 / 수정 / 삭제 / 조회)  
- 공지사항 조회  
- 댓글 / 대댓글 기능  
- 1대1 문의 기능  

</details>

<details>
<summary><strong>🌐 공공데이터 기능</strong></summary>

- 공공데이터 API 연동(대기질 정보)  
- 실시간 미세먼지 정보 제공  
- 지도 기반 위치 시각화  
- 히트맵 구현  

</details>

<details>
<summary><strong>🛠 관리자 기능</strong></summary>

- **회원 관리** (회원 정보 조회, 상태 변경, 탈퇴 회원 관리)  
- **게시판 관리** (사용자 게시판·공지사항)  
- **문의 리스트 관리** (1대1 문의 조회 및 대응)  

</details>

<details>
<summary><strong>⚡ 성능 최적화 및 서버 기능</strong></summary>

- Redis 캐싱 처리  
- Spring Scheduler 기반 자동 데이터 업데이트  
- AWS EC2 서버 배포 및 환경 구성  

</details>

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

## 🔍 담당 기능

## 💬 마이페이지

🎥 마이페이지 시연영상 : [https://github.com/user-attachments/assets/b6460b8f-cad2-4be1-91ca-a687748cacbc
](https://youtu.be/zhXHyCuCd3Q)

**📌 설명**

로그인한 사용자가 마이페이지에 접근하면
세션에 저장된 로그인 정보를 기준으로 회원 정보를 조회하여
최신 회원 정보를 화면에 표시하도록 구현했습니다.

<details>
<summary><strong>🔎 회원정보 조회</strong></summary>
로그인 세션(loginId)을 기반으로 사용자 정보를 조회합니다.
DB의 최신 정보를 다시 불러와 화면과 세션 정보를 동기화합니다.

</details>

<details>
<summary><strong>✏️ 회원정보 수정</strong></summary>

사용자가 수정한 정보만 전달받아 DB에 반영합니다.
수정 완료 후 회원 정보를 재조회하여
세션 정보를 즉시 갱신함으로써 변경 사항이 바로 반영되도록 처리합니다.

</details>

<details>
<summary><strong>❌ 회원 탈퇴</strong></summary>

일반 로그인 / 소셜 로그인 사용자를 구분하여 탈퇴 로직 구현했습니다.
일반 로그인 사용자: 비밀번호 검증 후 탈퇴 처리했습니다.
소셜 로그인 사용자: 비밀번호 입력 없이 탈퇴 가능합니다.
탈퇴 완료 시 세션을 만료시켜 로그인 상태 즉시 해제합니다.

</details>

<details>
<summary><strong>📝 내가 작성한 게시글 조회</strong></summary>

로그인한 사용자 ID를 기준으로
본인이 작성한 게시글 목록만 조회하도록 구현했습니다.

마이페이지에서 최근 작성한 게시글을 한눈에 확인 가능합니다.

</details>

<details>
<summary><strong>📍 관심 지역 조회 및 삭제</strong></summary>

사용자가 등록한 관심 지역 목록 조회했습니다.
각 관심 지역에 대해 현재 미세먼지(PM10) 정보를 함께 제공합니다.
REST 방식의 DELETE 요청을 통해
관심 지역을 개별적으로 삭제할 수 있도록 구현했습니다.

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
