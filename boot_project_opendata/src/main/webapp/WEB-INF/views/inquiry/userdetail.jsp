<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>문의 상세 | 책갈피</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/myinfo.css">
  <style>
    .inquiry-detail {
      max-width: 900px;
    }
    
    .inquiry-header-section {
      padding: 24px;
      border-bottom: 1px solid #E5E7EB;
    }
    
    .inquiry-header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16px;
    }
    
    .inquiry-title {
      font-size: 20px;
      font-weight: 600;
      color: #111827;
      margin: 0;
    }
    
    .status-badge {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 12px;
      font-size: 13px;
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
    
    .inquiry-meta {
      display: flex;
      gap: 20px;
      color: #6B7280;
      font-size: 14px;
    }
    
    .inquiry-content {
      padding: 24px;
      color: #374151;
      line-height: 1.8;
      white-space: pre-wrap;
      word-wrap: break-word;
      min-height: 150px;
    }
    
    .reply-section {
      background-color: #F9FAFB;
      border-top: 2px solid #E5E7EB;
      padding: 24px;
    }
    
    .reply-header {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 16px;
    }
    
    .reply-header h3 {
      font-size: 18px;
      color: #111827;
      margin: 0;
    }
    
    .reply-badge {
      background-color: var(--brand, #4F46E5);
      color: white;
      padding: 4px 10px;
      border-radius: 6px;
      font-size: 12px;
      font-weight: 600;
    }
    
    .reply-content {
      background: white;
      padding: 20px;
      border-radius: 8px;
      color: #374151;
      line-height: 1.8;
      white-space: pre-wrap;
      word-wrap: break-word;
      border: 1px solid #E5E7EB;
    }
    
    .reply-meta {
      color: #6B7280;
      font-size: 13px;
      margin-top: 12px;
    }
    
    .no-reply {
      text-align: center;
      padding: 40px;
      color: #6B7280;
    }
    
    .no-reply p {
      margin: 0;
      font-size: 15px;
    }
    
    .btn-back {
      background-color: #E5E7EB;
      color: #374151;
      padding: 10px 20px;
      border: none;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      font-size: 14px;
      cursor: pointer;
      display: inline-block;
      transition: background-color 0.3s;
    }
    
    .btn-back:hover {
      background-color: #D1D5DB;
    }
  </style>
</head>
<body>
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

  <main class="page-wrap">
    <div class="page-container">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
        <h1 class="page-title">문의 상세</h1>
        <a href="<c:url value='/inquiry'/>" class="btn-back">목록으로</a>
      </div>

      <div class="content-card">
        <div class="card">
          <div class="inquiry-header-section">
            <div class="inquiry-header-row">
              <h2 class="inquiry-title">${inquiry.title}</h2>
              <span class="status-badge ${inquiry.status == '답변완료' ? 'status-completed' : 'status-waiting'}">
                ${inquiry.status}
              </span>
            </div>
            <div class="inquiry-meta">
              <span>작성자: ${inquiry.user_name}</span>
              <span>작성일: <fmt:formatDate value="${inquiry.created_date}" pattern="yyyy-MM-dd HH:mm" /></span>
            </div>
          </div>
          
          <div class="inquiry-content">${inquiry.content}</div>

          <div class="reply-section">
            <div class="reply-header">
              <h3>관리자 답변</h3>
              <c:if test="${inquiry.status == '답변완료'}">
                <span class="reply-badge">답변완료</span>
              </c:if>
            </div>
            
            <c:choose>
              <c:when test="${not empty inquiry.reply}">
                <div class="reply-content">${inquiry.reply.reply_content}</div>
                <div class="reply-meta">
                  답변일: <fmt:formatDate value="${inquiry.reply.created_date}" pattern="yyyy-MM-dd HH:mm" />
                </div>
              </c:when>
              <c:otherwise>
                <div class="no-reply">
                  <p>아직 답변이 등록되지 않았습니다.<br>빠른 시일 내에 답변드리겠습니다.</p>
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