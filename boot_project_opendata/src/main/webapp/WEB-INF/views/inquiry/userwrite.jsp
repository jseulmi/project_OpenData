<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>문의 작성 | 대기질 정보</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/myinfo_edit.css">
  <style>
    /* 모든 기본 스타일 초기화 */
    .card-body {
      padding: 0 !important;
      margin: 0 !important;
    }
    
    /* 통일된 컨테이너 */
    .inquiry-form-container {
      padding: 24px !important;
      margin: 0 !important;
      width: 100% !important;
      box-sizing: border-box !important;
    }
    
    .inquiry-form {
      margin: 0 !important;
      padding: 0 !important;
      width: 100% !important;
      box-sizing: border-box !important;
    }
    
    /* 모든 요소를 동일한 너비로 */
    .inquiry-form-container > *,
    .inquiry-form > * {
      width: 100% !important;
      box-sizing: border-box !important;
      margin-left: 0 !important;
      margin-right: 0 !important;
    }
    
    .form-group {
      margin-bottom: 28px;
      width: 100% !important;
      box-sizing: border-box !important;
    }
    
    .form-group label {
      display: block;
      margin-bottom: 10px;
      font-weight: 600;
      color: #374151;
      font-size: 15px;
    }
    
    .form-group input[type="text"] {
      width: 100% !important;
      padding: 14px 16px;
      border: 1px solid #D1D5DB;
      border-radius: 8px;
      font-size: 14px;
      font-family: inherit;
      box-sizing: border-box !important;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    
    .form-group input[type="text"]:focus {
      outline: none;
      border-color: var(--brand, #4F46E5);
      box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }
    
    .form-group textarea {
      width: 100% !important;
      padding: 14px 16px;
      border: 1px solid #D1D5DB;
      border-radius: 8px;
      font-size: 14px;
      font-family: inherit;
      box-sizing: border-box !important;
      min-height: 300px;
      resize: vertical;
      line-height: 1.6;
      transition: border-color 0.2s, box-shadow 0.2s;
      white-space: pre-wrap;
      word-wrap: break-word;
      overflow-wrap: break-word;
    }
    
    .form-group textarea:focus {
      outline: none;
      border-color: var(--brand, #4F46E5);
      box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }
    
    .form-group textarea::placeholder {
      color: #9CA3AF;
      line-height: 1.6;
      white-space: pre-line;
    }
    
    .char-count {
      text-align: right;
      color: #6B7280;
      font-size: 12px;
      margin-top: 6px;
    }
    
    .char-count.warning {
      color: #F59E0B;
    }
    
    .char-count.danger {
      color: #EF4444;
    }
    
    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      margin-top: 32px;
      padding-top: 24px;
      border-top: 1px solid #E5E7EB;
    }
    
    .btn {
      padding: 12px 28px;
      border: none;
      border-radius: 8px;
      font-weight: 600;
      cursor: pointer;
      font-size: 14px;
      transition: all 0.3s;
    }
    
    .btn-primary {
      background-color: var(--brand, #4F46E5);
      color: white;
    }
    
    .btn-primary:hover {
      background-color: #1e4261;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
    }
    
    .btn-secondary {
      background-color: #E5E7EB;
      color: #374151;
    }
    
    .btn-secondary:hover {
      background-color: #D1D5DB;
    }
    
    /* 안내 박스 */
    .info-box {
      background-color: #F0F9FF;
      border: 1px solid #BAE6FD;
      border-radius: 8px;
      padding: 16px;
      margin: 0 0 24px 0 !important;
      width: 100% !important;
      box-sizing: border-box !important;
    }
    
    .info-box-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-weight: 600;
      color: #0369A1;
      font-size: 14px;
      margin-bottom: 8px;
    }
    
    .info-box-title svg {
      width: 18px;
      height: 18px;
      fill: #0369A1;
    }
    
    .info-box-content {
      color: #075985;
      font-size: 13px;
      line-height: 1.6;
      margin: 0;
    }
    
    .info-box-content ul {
      margin: 8px 0 0 0;
      padding-left: 20px;
    }
    
    .info-box-content li {
      margin-bottom: 4px;
    }
    
    /* 카테고리 선택 */
    .category-select {
      margin: 0 0 24px 0 !important;
      width: 100% !important;
      box-sizing: border-box !important;
    }
    
    .category-select label {
      display: block;
      margin-bottom: 10px;
      font-weight: 600;
      color: #374151;
      font-size: 15px;
    }
    
    .category-select select {
      width: 100% !important;
      padding: 14px 16px;
      border: 1px solid #D1D5DB;
      border-radius: 8px;
      font-size: 14px;
      font-family: inherit;
      background-color: white;
      cursor: pointer;
      transition: border-color 0.2s;
      box-sizing: border-box !important;
    }
    
    .category-select select:focus {
      outline: none;
      border-color: var(--brand, #4F46E5);
      box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }
    
    /* 작성 가이드 */
    .guide-section {
      background-color: #F9FAFB;
      border-radius: 8px;
      padding: 20px;
      margin: 24px 0 0 0 !important;
      border: 1px solid #E5E7EB;
      box-sizing: border-box !important;
      width: 100% !important;
    }
    
    .guide-section h4 {
      font-size: 14px;
      font-weight: 600;
      color: #374151;
      margin: 0 0 12px 0;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    
    .guide-section h4 svg {
      width: 16px;
      height: 16px;
      fill: #6B7280;
    }
    
    .guide-section ul {
      margin: 0;
      padding-left: 20px;
      color: #6B7280;
      font-size: 13px;
      line-height: 1.8;
    }
    
    .guide-section li {
      margin-bottom: 6px;
    }
    
    /* 예시 텍스트 영역 */
    .example-box {
      background-color: #F9FAFB;
      border: 1px dashed #D1D5DB;
      border-radius: 6px;
      padding: 12px 14px;
      margin-top: 8px;
      font-size: 13px;
      color: #6B7280;
      line-height: 1.6;
      box-sizing: border-box !important;
      width: 100% !important;
    }
    
    .example-box strong {
      color: #374151;
      font-weight: 600;
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
      <h1 class="page-title">문의 작성</h1>
      <p style="color: #6B7280; font-size: 14px; margin-bottom: 30px;">궁금한 사항을 남겨주시면 빠르게 답변드리겠습니다.</p>

      <div class="content-card">
        <div class="card">
          <div class="card-head">
            <h3 class="card-title">문의 내용</h3>
          </div>
          <div class="card-body">
            <div class="inquiry-form-container">
              <form action="<c:url value='/inquiry/write'/>" method="post" class="inquiry-form">
                <!-- 안내 박스 -->
                <div class="info-box">
                  <div class="info-box-title">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <circle cx="12" cy="12" r="10"></circle>
                      <line x1="12" y1="16" x2="12" y2="12"></line>
                      <line x1="12" y1="8" x2="12.01" y2="8"></line>
                    </svg>
                    문의 작성 안내
                  </div>
                  <div class="info-box-content">
                    <p style="margin: 0 0 8px 0;">문의하시기 전에 아래 사항을 확인해주세요.</p>
                    <ul>
                      <li>주문/배송 관련 문의는 주문번호를 함께 적어주시면 더 빠른 답변이 가능합니다.</li>
                      <li>답변은 평일 기준 1-2일 내에 이메일로 발송됩니다.</li>
                      <li>비밀번호, 개인정보 등은 문의 내용에 포함하지 마세요.</li>
                    </ul>
                  </div>
                </div>

                <!-- 카테고리 선택 -->
                <div class="category-select">
                  <label for="category">문의 유형 (선택사항)</label>
                  <select id="category" name="category">
                    <option value="">선택해주세요</option>
                    <option value="대기질 데이터 오류">대기질 데이터 오류</option>
                    <option value="지도 및 위치 정보">지도 및 위치 정보</option>
                    <option value="회원정보">회원정보</option>
                    <option value="기타">기타</option>
                  </select>
                </div>

                <div class="form-group">
                  <label for="title">제목 *</label>
                  <input type="text" id="title" name="title" required 
                         placeholder="문의 제목을 입력해주세요" maxlength="200">
                  <div class="char-count" id="title-count-wrapper">
                    <span id="title-count">0</span>/200
                  </div>
                </div>

                <div class="form-group">
                  <label for="content">내용 *</label>
                  <textarea id="content" name="content" required 
                            placeholder="문의 내용을 상세히 입력해주세요."></textarea>
                  <div class="example-box">
                    <strong>작성 예시:</strong><br>
                    주문번호: (주문번호를 입력해주세요)<br>
                    문의 내용: (상세히 작성해주세요)
                  </div>
                  <div class="char-count" id="content-count-wrapper">
                    <span id="content-count">0</span>자
                  </div>
                </div>

                <div class="guide-section">
                  <h4>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                      <polyline points="14 2 14 8 20 8"></polyline>
                      <line x1="16" y1="13" x2="8" y2="13"></line>
                      <line x1="16" y1="17" x2="8" y2="17"></line>
                      <polyline points="10 9 9 9 8 9"></polyline>
                    </svg>
                    작성 가이드
                  </h4>
                  <ul>
                    <li>문의 내용을 구체적으로 작성해주시면 더 정확한 답변을 드릴 수 있습니다.</li>
                    <li>주문 관련 문의는 주문번호를 반드시 포함해주세요.</li>
                    <li>개인정보(주민등록번호, 계좌번호 등)는 입력하지 마세요.</li>
                    <li>욕설, 비방, 광고성 내용은 삭제될 수 있습니다.</li>
                  </ul>
                </div>

                <div class="form-actions">
                  <button type="button" class="btn btn-secondary" 
                          onclick="location.href='<c:url value='/inquiry'/>'">취소</button>
                  <button type="submit" class="btn btn-primary">등록하기</button>
                </div>
              </form>
            </div>
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

  <script>
    // 글자 수 카운트 및 경고 표시
    const titleInput = document.getElementById('title');
    const contentTextarea = document.getElementById('content');
    const titleCount = document.getElementById('title-count');
    const contentCount = document.getElementById('content-count');
    const titleCountWrapper = document.getElementById('title-count-wrapper');
    const contentCountWrapper = document.getElementById('content-count-wrapper');

    titleInput.addEventListener('input', function() {
      const length = this.value.length;
      titleCount.textContent = length;
      
      titleCountWrapper.classList.remove('warning', 'danger');
      if (length > 180) {
        titleCountWrapper.classList.add('danger');
      } else if (length > 150) {
        titleCountWrapper.classList.add('warning');
      }
    });

    contentTextarea.addEventListener('input', function() {
      const length = this.value.length;
      contentCount.textContent = length;
      
      contentCountWrapper.classList.remove('warning', 'danger');
      if (length > 1000) {
        contentCountWrapper.classList.add('warning');
      }
    });

    // 폼 제출 전 검증
    document.querySelector('form').addEventListener('submit', function(e) {
      const title = titleInput.value.trim();
      const content = contentTextarea.value.trim();
      
      if (title.length < 5) {
        e.preventDefault();
        alert('제목을 5자 이상 입력해주세요.');
        titleInput.focus();
        return false;
      }
      
      if (content.length < 10) {
        e.preventDefault();
        alert('내용을 10자 이상 입력해주세요.');
        contentTextarea.focus();
        return false;
      }
    });
  </script>
</body>
</html>