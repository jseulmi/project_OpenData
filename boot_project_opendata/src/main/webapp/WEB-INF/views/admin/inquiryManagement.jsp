<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>게시판 - 대기질 정보</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/css/board.css">
  <script src="/js/banner.js"></script>

  <style>
    /* 기존 게시판 스타일 유지 + 문의 관리 스타일 추가 */
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background: #f8f9fa;
      margin: 0;
      padding: 0;
    }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-bottom: 24px;
    }
    .stat-card {
      background: #ffffff;
      padding: 20px;
      border-radius: 16px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }
    .stat-card-title {
      font-size: 13px;
      color: #6b7280;
      margin-bottom: 8px;
    }
    .stat-card-value {
      font-size: 24px;
      font-weight: 700;
      color: #3e2c1c;
    }
    .inquiry-table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 10px 25px rgba(0,0,0,0.15);
      margin-top: 16px;
    }
    .inquiry-table thead {
      background-color: #2c5f8d;
    }
    .inquiry-table th, .inquiry-table td {
      padding: 14px 16px;
      text-align: center;
      font-weight: 600;
      color: white;
      font-size: 15px;
    }
    .inquiry-table td {
      color: #2c5f8d;
      font-weight: normal;
    }
    .inquiry-table tbody tr {
      cursor: pointer;
      transition: background-color 0.2s;
    }
    .inquiry-table tbody tr:hover {
      background-color: rgb(238, 240, 242);
    }
    .status-badge {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: 600;
      color: white;
    }
    .status-waiting {
      background-color: #fbbf24;
      color: #92400e;
    }
    .status-completed {
      background-color: #10b981;
      color: white;
    }
    .btn-view, .btn-edit {
      padding: 7px 18px;
      border: none;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      color: white;
      display: inline-block;
      transition: 0.2s;
    }
    .btn-view {
      background-color: #2c5f8d;
    }
    .btn-view:hover {
      background-color: #1e4261;
    }
    .btn-edit {
      background-color: #10b981;
    }
    .btn-edit:hover {
      background-color: #059669;
    }
	.board-filter label {
	      font-size: 15px;
	      font-weight: 500;
	      color: #374151;
	    }

	    .board-select {
	      padding: 6px 12px;
	      margin-left: 4px;
	      border: 1px solid #cbd5e1;
	      border-radius: 6px;
	      background-color: #f9fafb;
	      color: #1e3a8a;
	      font-weight: 500;
	      font-size: 14px;
	      outline: none;
	      transition: all 0.2s ease;
	      cursor: pointer;
	      box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
	    }

	    .board-select:hover {
	      border-color: #94a3b8;
	    }

	    .board-select:focus {
	      border-color: #2563eb;
	      box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.3);
	    }
  </style>
</head>
<body>
  <!-- 헤더 & 네비 (기존 코드 유지) -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/adminMain" class="brand">대기질 정보</a>
      <div class="nav-right">
        <c:choose>
          <c:when test="${empty sessionScope.loginDisplayName}">
            <a href="<c:url value='/login'/>">로그인</a>
            <a href="<c:url value='/register'/>">회원가입</a>
          </c:when>
          <c:otherwise>
            <a href="<c:url value='/adminMain'/>">관리자메인</a>
            <a href="<c:url value='/logout'/>">로그아웃</a>
            <span class="user-name">${sessionScope.loginDisplayName}님</span>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="city-banner-wrapper">
        <div class="city-slide" id="headerCitySlide">
          <c:forEach var="city" items="${cityAverages}">
            <div class="city-slide-item">
              ${city.stationName}:
              미세먼지(
              <strong class="<c:choose>
                                 <c:when test='${city.pm10Value <= 30}'>good</c:when>
                                 <c:when test='${city.pm10Value <= 80}'>normal</c:when>
                                 <c:when test='${city.pm10Value <= 150}'>bad</c:when>
                                 <c:otherwise>very-bad</c:otherwise>
                               </c:choose>">
                <c:choose>
                  <c:when test="${city.pm10Value <= 30}">좋음</c:when>
                  <c:when test="${city.pm10Value <= 80}">보통</c:when>
                  <c:when test="${city.pm10Value <= 150}">나쁨</c:when>
                  <c:otherwise>매우나쁨</c:otherwise>
                </c:choose>
              </strong>)
              초미세먼지(
              <strong class="<c:choose>
                                 <c:when test='${city.pm25Value <= 15}'>good</c:when>
                                 <c:when test='${city.pm25Value <= 35}'>normal</c:when>
                                 <c:when test='${city.pm25Value <= 75}'>bad</c:when>
                                 <c:otherwise>very-bad</c:otherwise>
                               </c:choose>">
                <c:choose>
                  <c:when test="${city.pm25Value <= 15}">좋음</c:when>
                  <c:when test="${city.pm25Value <= 35}">보통</c:when>
                  <c:when test="${city.pm25Value <= 75}">나쁨</c:when>
                  <c:otherwise>매우나쁨</c:otherwise>
                </c:choose>
              </strong>)
            </div>
          </c:forEach>
        </div>
      </div>
    </nav>
  </header>

  <!-- 상단 프로모션 -->
  <div class="promo" role="note" aria-label="프로모션">
    <div class="promo-content">
      <div class="promo-nav">
        <a href="/adminMain" class="nav-category">상세정보</a>
        <a href="/memberManagement" class="nav-board">회원관리</a>
        <a href="/boardManagement" class="nav-notice active">게시판관리</a>
        <a href="/qna" class="nav-qna">지역관리</a>
      </div>
    </div>
  </div>

  <!-- 1:1 문의 관리 섹션 -->
  <section class="board-section"">
    <div class="board-container">
      <!-- 제목 + 셀렉트 박스 -->
      <div class="board-header">
        <div style="display: inline-flex; align-items: center; gap: 8px;">
          <h1 class="board-title" style="margin: 0;">1:1 문의 관리</h1>
          <div class="board-filter">
            <select id="boardType" name="boardType" class="board-select" onchange="moveToBoardPage(this.value)">
              <option value="">선택하세요</option>
              <option value="board">게시판 관리</option>
              <option value="notice">공지사항 관리</option>
              <option value="inquiry" selected>1:1 문의 관리</option>
            </select>
          </div>
        </div>
      </div>

      <!-- 통계 cards -->
      <c:set var="totalCount" value="${inquiryList.size()}" />
      <c:set var="pendingCount" value="0" />
      <c:forEach var="inquiry" items="${inquiryList}">
        <c:if test="${inquiry.status == '대기중'}">
          <c:set var="pendingCount" value="${pendingCount + 1}" />
        </c:if>
      </c:forEach>

      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-card-title">전체 문의</div>
          <div class="stat-card-value">${totalCount}</div>
        </div>
        <div class="stat-card">
          <div class="stat-card-title">답변 대기</div>
          <div class="stat-card-value" style="color: #F59E0B;">${pendingCount}</div>
        </div>
        <div class="stat-card">
          <div class="stat-card-title">답변 완료</div>
          <div class="stat-card-value" style="color: #10B981;">${totalCount - pendingCount}</div>
        </div>
      </div>

      <!-- 문의 리스트 테이블 -->
      <table class="inquiry-table">
        <thead>
          <tr>
            <th style="width: 8%;">번호</th>
            <th style="width: 15%;">작성자</th>
            <th style="width: 40%;">제목</th>
            <th style="width: 12%;">상태</th>
            <th style="width: 15%;">작성일</th>
            <th style="width: 10%;">관리</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty inquiryList || inquiryList.size() == 0}">
              <tr>
                <td colspan="6" style="text-align: center; padding: 40px; color: #6B7280;">
                  등록된 문의가 없습니다.
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="inquiry" items="${inquiryList}">
                <tr class="inquiry-row" data-inquiry-id="${inquiry.inquiry_id}">
                  <td>${inquiry.inquiry_id}</td>
                  <td>${inquiry.user_name}</td>
                  <td style="font-weight: 500;">${inquiry.title}</td>
                  <td>
                    <span class="status-badge ${inquiry.status == '답변완료' ? 'status-completed' : 'status-waiting'}">
                      ${inquiry.status}
                    </span>
                  </td>
                  <td>
                    <fmt:formatDate value="${inquiry.created_date}" pattern="yyyy-MM-dd" />
                  </td>
                  <td class="action-cell" onclick="event.stopPropagation();">
                    <c:choose>
                      <c:when test="${inquiry.status == '답변완료'}">
                        <button class="btn-edit" data-inquiry-id="${inquiry.inquiry_id}">답변수정</button>
                      </c:when>
                      <c:otherwise>
                        <button class="btn-view" data-inquiry-id="${inquiry.inquiry_id}">답변</button>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </section>

  <!-- 푸터 (기존 코드 유지) -->
  <footer class="footer">
    <h2>대기질 정보 시스템</h2>
    <p>대기질 정보 시스템 | 데이터 출처: 공공데이터포털 (data.go.kr)</p>
    <p>환경부 실시간 대기질 정보 제공</p>
    <p>주소: 부산시 부산진구 범내골</p>
    <br>
    <a href="#">이용약관</a>
    <a href="#">개인정보처리방침</a>
  </footer>

  <script>
    // 페이지 이동 함수
    function moveToBoardPage(type) {
      if (type === "board") {
        location.href = "/boardManagement";
      } else if (type === "notice") {
        location.href = "/noticeManagement";
      } else if (type === "inquiry") {
        location.href = "/admin/inquiryManagement";
      }
    }
    // 문의 행 클릭 및 버튼 클릭 이벤트
    (function() {
      function goToDetail(inquiryId) {
        if (typeof loadInquiryDetail === 'function') {
          loadInquiryDetail(inquiryId);
        } else if (typeof loadPage === 'function') {
          loadPage('/admin/inquiryDetail?inquiry_id=' + inquiryId);
        } else {
          window.location.href = '/admin/inquiryDetail?inquiry_id=' + inquiryId;
        }
      }
      // 행 클릭 이벤트
      document.querySelectorAll('.inquiry-row').forEach(function(row){
        row.addEventListener('click', function(e){
          if (e.target.closest('button') || e.target.closest('.action-cell')) {
            return;
          }
          var inquiryId = this.getAttribute('data-inquiry-id');
          if(inquiryId) {
            goToDetail(inquiryId);
          }
        });
      });
      // 버튼 클릭 이벤트
      document.querySelectorAll('.btn-view, .btn-edit').forEach(function(btn){
        btn.addEventListener('click', function(e){
          e.stopPropagation();
          var inquiryId = this.getAttribute('data-inquiry-id');
          if (inquiryId) {
            goToDetail(inquiryId);
          }
        });
      });
    })();
  </script>

</body>
</html>
