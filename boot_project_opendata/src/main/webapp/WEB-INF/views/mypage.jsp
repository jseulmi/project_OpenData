<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>마이페이지 - 대기질 정보</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/mypage.css">
  <script src="/js/banner.js"></script>
</head>
<body>
<script>
	  		      window.sessionExpireAt = ${sessionScope.sessionExpireAt == null ? 0 : sessionScope.sessionExpireAt};
	  		      window.isLoggedIn = ${not empty sessionScope.loginId};
	  		  </script>

	  		  <script src="/js/sessionTimer.js"></script>

  <!-- 헤더 & 네비 -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/main" class="brand">대기질 정보</a>
      <!-- 로그인 전/후 분기 -->
      <div class="nav-right">
        <c:choose>
          <%-- 로그인 전 --%>
          <c:when test="${empty sessionScope.loginDisplayName}">
            <a href="<c:url value='/login'/>">로그인</a>
            <a href="<c:url value='/register'/>">회원가입</a>
          </c:when>
          <%-- 로그인 후 --%>
          <c:otherwise>
            <a href="<c:url value='/mypage'/>">마이페이지</a>
            <a href="<c:url value='/logout'/>">로그아웃</a>
            <span class="user-name">${sessionScope.loginDisplayName}님</span>
			<!-- ⏱ 세션 타이머 -->
			         <c:if test="${not empty sessionScope.loginId}">
			             <span id="session-timer" style="margin-left:15px; font-weight:bold; font-size:16px; color:#333;">
			             </span>
			         </c:if>

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
	            </strong>
	          )
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
	            </strong>
	          )
	        </div>
	      </c:forEach>
	    </div>
	  </nav>
  </header>

  <!-- 상단 프로모션 -->
  <div class="promo" role="note" aria-label="프로모션">
    <div class="promo-content">
      <div class="promo-nav">
        <a href="/main" class="nav-category">상세정보</a>
        <a href="/board/list" class="nav-board">게시판</a>
        <a href="/notice" class="nav-notice">공지사항</a>
        <a href="<c:url value='/inquiry'/>" class="nav-inquiry">1:1 문의</a>
      </div>
    </div>
  </div>

  <!-- 마이페이지 섹션 -->
  <section class="mypage-section">
    <div class="mypage-container">
      <div class="mypage-header">
        <h1 class="mypage-title">마이페이지</h1>
        <p class="mypage-subtitle">회원 정보를 관리하고 내 활동을 확인하세요</p>
      </div>

      <!-- 회원 정보 조회/수정/삭제 섹션 -->
      <div class="mypage-card">
        <div class="card-header">
          <h2 class="card-title">
            <span class="card-title-icon">👤</span>
            회원 정보 조회/수정/삭제
          </h2>
          <div class="card-action">
            <a href="<c:url value='/mypage/edit'/>" class="btn btn-primary">수정</a>
<!--        <a href="<c:url value='/mypage/delete'/>" class="btn btn-danger" onclick="return confirm('정말 탈퇴하시겠습니까?');">탈퇴</a>-->
			<a href="<c:url value='/mypage/withdraw'/>" class="btn btn-danger">탈퇴</a>
          </div>
        </div>
        <div class="info-grid">
          <div class="info-item">
            <span class="info-label">아이디</span>
            <span class="info-value">${sessionScope.loginId}</span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.id}</span> --%>
          </div>
          <div class="info-item">
            <span class="info-label">이름</span>
            <span class="info-value">${sessionScope.loginDisplayName}</span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.name}</span> --%>
          </div>
          <div class="info-item">
            <span class="info-label">이메일</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${not empty sessionScope.userEmail}">${sessionScope.userEmail}</c:when>
                <c:otherwise><span class="empty">등록된 이메일이 없습니다</span></c:otherwise>
              </c:choose>
            </span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.email}</span> --%>
          </div>
          <div class="info-item">
            <span class="info-label">전화번호</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${not empty sessionScope.userPhone}">${sessionScope.userPhone}</c:when>
                <c:otherwise><span class="empty">등록된 전화번호가 없습니다</span></c:otherwise>
              </c:choose>
            </span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.phone}</span> --%>
          </div>
		  <div class="info-item">
		    <span class="info-label">가입일</span>
		    <span class="info-value">
		      <c:choose>
		        <c:when test="${not empty sessionScope.userRegDate}">
		          <fmt:formatDate value="${sessionScope.userRegDate}" pattern="yyyy-MM-dd (E)" />
		        </c:when>
		        <c:otherwise><span class="empty">-</span></c:otherwise>
		      </c:choose>
		    </span>
		  </div>
        </div>
      </div>

	  <!-- 게시판 목록 조회 섹션 -->
	        <div class="mypage-card">
	          <div class="card-header">
	            <h2 class="card-title">
	              <span class="card-title-icon">📝</span>
	              게시판 목록 조회
	            </h2>
	            <div class="card-action">
	              <a href="/board/list" class="btn btn-secondary">전체 목록 보기</a>
	            </div>
	          </div>
	          <div class="board-list">
	            <c:choose>
	              <c:when test="${not empty myBoardList}">
	                <c:forEach var="board" items="${myBoardList}">
	                  <div class="board-list-item">
	                    <div class="board-list-info">
	                      <h3 class="board-list-title">
	                        <a href="/board/detail?boardNo=${board.boardNo}">${board.boardTitle}</a>
	                      </h3>
	                      <div class="board-list-meta">
	                        <span>작성일: ${board.boardDate.year}-${String.format("%02d", board.boardDate.monthValue)}-${String.format("%02d", board.boardDate.dayOfMonth)} 
	                              ${String.format("%02d", board.boardDate.hour)}:${String.format("%02d", board.boardDate.minute)}</span>
	                        <span>조회수: ${board.boardHit}</span>
	                      </div>
	                    </div>
	                  </div>
	                </c:forEach>
	              </c:when>
	              <c:otherwise>
	                <div class="empty-message">
	                  작성한 게시글이 없습니다.
	                </div>
	              </c:otherwise>
	            </c:choose>
	          </div>
	        </div>


      <!-- 관심 지역 조회 섹션 -->
      <div class="mypage-card">
        <div class="card-header">
          <h2 class="card-title">
            <span class="card-title-icon">📍</span>
            관심 지역 조회
          </h2>
<!--          <div class="card-action">-->
<!--            <a href="<c:url value='/mypage/region/add'/>" class="btn btn-primary">지역 추가</a>-->
<!--          </div>-->
        </div>
        <div class="region-grid">
			<c:choose>
			    <c:when test="${not empty favorites}">
					<c:forEach var="region" items="${favorites}">
					    <div class="region-card">
					        <!-- stationName으로 정확히 호출 -->
					        <h3 class="region-name">${region.stationName}</h3>
					        <span class="region-grade 
					            ${region.pm10Value <= 30 ? 'good' :
					              region.pm10Value <= 80 ? 'normal' :
					              region.pm10Value <= 150 ? 'bad' : 'very-bad'}">
					            <c:choose>
					                <c:when test="${region.pm10Value <= 30}">좋음</c:when>
					                <c:when test="${region.pm10Value <= 80}">보통</c:when>
					                <c:when test="${region.pm10Value <= 150}">나쁨</c:when>
					                <c:otherwise>매우 나쁨</c:otherwise>
					            </c:choose>
					        </span>
					        <div style="margin-top: 12px; font-size: 14px; color: var(--muted);">
					            미세먼지: ${region.pm10Value} ㎍/㎥
					        </div>
					        <!-- 삭제 버튼: favoriteId로 호출 -->
					        <button class="region-remove" onclick="removeRegion(${region.favoriteId})">삭제</button>
					    </div>
					</c:forEach>
			    </c:when>
			    <c:otherwise>
			        <div class="empty-message" style="grid-column: 1 / -1;">
			            등록된 관심 지역이 없습니다. 지역을 추가해보세요.
			        </div>
			    </c:otherwise>
			</c:choose>
        </div>
      </div>
    </div>
  </section>
  
  <c:if test="${not empty msg}">
  <script>
      alert("${msg}");
  </script>
  </c:if>


  <!-- 푸터 -->
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
  function removeRegion(regionId) {
      if (confirm('이 관심 지역을 삭제하시겠습니까?')) {
          fetch('/mypage/region/' + regionId, {
              method: 'DELETE',
              headers: {
                  'Content-Type': 'application/json'
              }
          })
          .then(response => response.json())
          .then(data => {
              alert(data.message);  // 서버에서 보내준 메시지 표시
              location.reload();    // 삭제 후 새로고침
          })
          .catch(err => {
              console.error(err);
              alert('삭제 중 오류가 발생했습니다.');
          });
      }
  }
  </script>

</body>
</html>
