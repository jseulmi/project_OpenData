<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>1:1 문의 | 대기질 정보</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/myinfo.css">
  <script src="/js/banner.js"></script>
  <style>
    .inquiry-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    
    .inquiry-table thead {
      background-color: #F9FAFB;
    }
    
    .inquiry-table th {
      padding: 14px 16px;
      text-align: left;
      font-weight: 600;
      font-size: 13px;
      color: #374151;
      border-bottom: 2px solid #E5E7EB;
    }
    
    .inquiry-table td {
      padding: 16px;
      border-bottom: 1px solid #E5E7EB;
      font-size: 14px;
    }
    
    .inquiry-table tbody tr {
      transition: background-color 0.2s;
      cursor: pointer;
    }
    
    .inquiry-table tbody tr:hover {
      background-color: #F9FAFB;
    }
    
    .inquiry-table tbody tr:last-child td {
      border-bottom: none;
    }
    
    .status-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: 600;
    }
    
    .status-waiting {
      background-color: #FEF3C7;
      color: #92400E;
    }
    
    .status-completed {
      background-color: #D1FAE5;
      color: #065F46;
    }
    
    .btn-write {
      background-color: var(--brand, #4F46E5);
      color: white;
      padding: 10px 20px;
      border: none;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      font-size: 14px;
      cursor: pointer;
      transition: background-color 0.3s;
      display: inline-block;
    }
    
    .btn-write:hover {
      background-color: #1e4261;
    }
    
    .btn-delete {
      background: #EF4444;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 12px;
      font-weight: 600;
    }
    
    .btn-delete:hover {
      background: #DC2626;
    }
    
    .empty-state {
      text-align: center;
      padding: 60px 20px;
    }
    
    .empty-state h3 {
      font-size: 20px;
      font-weight: 700;
      margin: 0 0 8px;
      color: var(--text, #111827);
    }
    
    .empty-state p {
      font-size: 14px;
      color: var(--muted, #6B7280);
      margin: 0 0 24px;
    }
    
    .msg-alert {
      padding: 12px 16px;
      margin-bottom: 20px;
      border-radius: 8px;
      background-color: #D1FAE5;
      color: #065F46;
      border: 1px solid #A7F3D0;
      font-size: 14px;
    }
  </style>
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
	            <span class="user-name"><c:out value="${sessionScope.loginDisplayName}"/>님</span>
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
	        <a href="<c:url value='/inquiry'/>" class="nav-inquiry active">1:1 문의</a>
	      </div>
	    </div>
	  </div>
  <!-- 본문 -->
  <main class="page-wrap">
    <div class="page-container">
      <h1 class="page-title">1:1 문의</h1>

      <div class="content-card">
        <div class="card">
          <div class="card-head">
            <h3 class="card-title">내 문의 내역</h3>
            <div class="toolbar">
              <a href="<c:url value='/inquiry/write'/>" class="btn-write">문의하기</a>
            </div>
          </div>

          <div class="card-body">
            <c:if test="${not empty msg}">
              <div class="msg-alert">${msg}</div>
            </c:if>

            <c:choose>
              <c:when test="${empty inquiryList || inquiryList.size() == 0}">
                <div class="empty-state">
                  <h3>등록된 문의가 없습니다</h3>
                  <p>궁금한 사항이 있으시면 문의해주세요.</p>
                  <a href="<c:url value='/inquiry/write'/>" class="btn-write">문의하기</a>
                </div>
              </c:when>
              <c:otherwise>
                <div class="table-wrap">
                  <table class="inquiry-table" aria-describedby="inquiryCaption">
                    <caption id="inquiryCaption" class="visually-hidden" style="position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0,0,0,0);">문의 내역</caption>
                    <thead>
                      <tr>
                        <th scope="col" style="width: 10%;">번호</th>
                        <th scope="col" style="width: 50%;">제목</th>
                        <th scope="col" style="width: 15%;">상태</th>
                        <th scope="col" style="width: 15%;">작성일</th>
                        <th scope="col" style="width: 10%;">관리</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="inquiry" items="${inquiryList}">
                        <tr onclick="location.href='<c:url value='/inquiry/detail?inquiry_id=${inquiry.inquiry_id}'/>'" style="cursor: pointer;">
                          <td>${inquiry.inquiry_id}</td>
                          <td style="font-weight: 500;">${inquiry.title}</td>
                          <td>
                            <span class="status-badge ${inquiry.status == '답변완료' ? 'status-completed' : 'status-waiting'}">
                              ${inquiry.status}
                            </span>
                          </td>
                          <td>
                            <fmt:formatDate value="${inquiry.created_date}" pattern="yyyy-MM-dd" />
                          </td>
                          <td onclick="event.stopPropagation();">
                            <form action="<c:url value='/inquiry/delete'/>" method="post" 
                                  style="display: inline;" 
                                  onsubmit="return confirm('정말 삭제하시겠습니까?');">
                              <input type="hidden" name="inquiry_id" value="${inquiry.inquiry_id}">
                              <button type="submit" class="btn-delete">삭제</button>
                            </form>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>
  </main>

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
</body>
</html>
