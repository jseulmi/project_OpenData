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

- 개발 기간 : 1차: `2025.10.13 ~ 2025.10.19`, 2차: `2025.11.13 ~ 2025.11.20`
- 개발 인원 : `7명`  
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
| **Backend** | Spring Boot, Java 17, MyBatis |
| **Frontend** | Kakao Map API, JavaScript, AJAX, JSP |
| **Database** | Oracle 11g / 19c |
| **API** | 공공데이터 대기질 API, Kakao Geocoding API |
| **DevOps** | AWS EC2(Ubuntu), Nginx/Tomcat |
| **Tools** | SQL Developer, Postman, ERDCloud |

---

## ✨ 주요 기능

### 📍 1. 공공데이터 실시간 수집
- 공공데이터 API(대기질) 호출  
- JSON → DTO 매핑 → Oracle DB 저장  
- 예외 처리 / API 장애 대비

---

### 🗺️ 2. Kakao Geocode API로 주소 → 좌표 변환
- 측정소 주소를 Kakao 주소검색 API로 변환  
- 위도·경도 좌표를 Oracle DB에 저장  
- 좌표 변환 실패 시 재시도 처리

---

### 📊 3. 시·도별 미세먼지 평균값 계산
- Oracle SQL로 지역별 집계  
- Spring 내부에서 PM10/PM2.5 평균 계산  
- 지도 상단에 평균 정보 시각화

---

### 🧭 4. 카카오 지도 기반 시각화
- 전국 측정소 마커 표시  
- 미세먼지 등급(좋음/보통/나쁨/매우나쁨)에 따라 색상 변경  
- 마커 클릭 시 상세 정보창 표시  
- 지도 클릭 시 오버레이 자동 닫힘

---

### 🔍 5. 검색 및 지역 이동 기능 (선택)
- 지역명 검색 시 해당 좌표로 지도 이동  
- 특정 측정소 하이라이트

---

## 🧭 메뉴 구조도 (PDF)

📄 메뉴 구조도 보기  
👉 `/docs/menu-structure.pdf`

---

## 🖥 화면 설계서 (PDF)

📄 화면 기획서 보기  
👉 `/docs/ui-design.pdf`

---

## 🗂 ERD 및 테이블 명세서 (PDF)

📄 ERD  
➡ `/docs/erd.pdf`

📄 테이블 명세서  
➡ `/docs/table-definition.pdf`

---

## 🔍 핵심 구현 내용 (내가 담당한 기능)

### ✔ 1. 공공데이터 API 연동 + JSON 파싱
String url = api + serviceKey + "&returnType=json";
ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);


## 📬 프로젝트 구조

```plaintext
📦 boot_bookstore
├─ src/main/java/com.bookstore
│  ├─ controller
│  ├─ service
│  ├─ dao
│  ├─ dto
│  └─ config
├─ src/main/resources
│  ├─ mapper
│  ├─ static
│  └─ templates(JSP)
└─ docs
   ├─ menu-structure.pdf
   ├─ ui-design.pdf
   ├─ erd.pdf
   └─ table-definition.pdf
```

---

## 🚀 시연 영상 & 데모

아래 영상은 온라인 북스토어(BookShelf)의 주요 기능을 실제 화면과 함께 보여줍니다.  
각 기능별 동작 방식과 흐름을 직관적으로 확인할 수 있습니다.

### 📌 전체 시연 영상 (Full Demo)
🔗 YouTube 링크: https://youtu.be/your-video-url  
또는  
🎥 EC2 배포 버전 직접 테스트: http://your-ec2-ip

---

## ✨ 기능별 시연

### 🛒 1. 장바구니 기능
- 비로그인 장바구니 유지  
- 로그인 시 DB 장바구니와 병합  
- 수량 변경 / 삭제  
<img src="/docs/demo/cart.gif" width="600"/>

---

### 💳 2. Toss 결제 프로세스
- 결제 준비 → 승인 API 처리  
- 결제 성공 시 주문 자동 생성  
<img src="/docs/demo/payment.gif" width="600"/>

---

### 📦 3. 주문 생성 및 주문 내역 조회
- 주문 상세 페이지  
- 구매 이력 확인  
<img src="/docs/demo/order.gif" width="600"/>

---

### 🛍️ 4. 도서 검색 / 카테고리 조회
- 키워드 기반 검색  
- 카테고리 필터  
<img src="/docs/demo/search.gif" width="600"/>

---

### 🔐 5. 회원가입 / 로그인 / 로그아웃
- 아이디 중복 체크  
- 세션 기반 로그인 처리  
<img src="/docs/demo/login.gif" width="600"/>

---

### 🛠 6. 관리자 페이지
- 도서 등록 / 수정 / 삭제  
- 이미지 업로드  
- 재고 관리  
<img src="/docs/demo/admin.gif" width="600"/>

---
