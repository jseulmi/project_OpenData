<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>대기질 정보 – 지역별 미세먼지 농도</title>
  
  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  
  <!-- Kakao Map SDK -->
  <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=246b6a1fdd8897003813a81be5f97cd5&libraries=services,clusterer"></script>
  <script src="/js/banner.js"></script>
  <!-- ✅ CSS 파일 링크 -->
  <link rel="stylesheet" href="<c:url value='/css/main.css'/>">

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
      <div class="nav-right">
        <c:choose>
          <%-- 로그인 전 --%>
          <c:when test="${empty sessionScope.loginDisplayName or sessionScope.loginDisplayName == null}">
            <a href="<c:url value='/login'/>">로그인</a>
            <a href="<c:url value='/register'/>">회원가입</a>
            <a href="<c:url value='/admin/login'/>">관리자정보</a>
          </c:when>
          <%-- 로그인 후 --%>
		    <c:otherwise>
		      <c:if test="${sessionScope.isAdmin != true}">
		        <a href="<c:url value='/mypage'/>">마이페이지</a>
		      </c:if>
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
        <a href="<c:url value='/inquiry'/>" class="nav-inquiry">1:1 문의</a>
      </div>
    </div>
  </div>
  <main>
   <h2 class="section-title">실시간 대기질 정보</h2>
    <!-- 카카오 지도 섹션 (코드1의 고급 지도 기능) -->
   <section class="map-section">
     <div class="map-wrapper">
      <div id="kakao-map" style="width: 100%; height:1200px;"></div>
      <div id="loading" style="
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(255,255,255,0.9);
        padding: 20px 40px;
        border-radius: 10px;
        font-weight: bold;
        z-index: 1000;
        display: none;">
        데이터 로딩중...
      </div>
		
       <!-- 지도 위 오버레이 -->
       <div class="map-overlay">
         <div class="overlay-search">
           <input id="searchInput" type="text" placeholder="측정소명 또는 주소 검색 (예: 종로구)" />
           <button id="btnSearch">검색</button>
           <button id="btnMyPos">내 위치</button>
           <button id="btnRefresh">새로고침</button>
         </div>
		 
         <div class="overlay-left">
           <h3>대기질 등급</h3>
           <ul>
             <li><span class="dot dot-good"></span> 좋음 (0~15)</li>
             <li><span class="dot dot-normal"></span> 보통 (16~35)</li>
             <li><span class="dot dot-bad"></span> 나쁨 (36~75)</li>
             <li><span class="dot dot-verybad"></span> 매우 나쁨 (76 이상)</li>
           </ul>
         </div>

		 <div class="overlay-right">
		    <h3>우리동네 대기질 (<span id="my-station-name">-</span>)</h3>
		    
		    <div class="info-item">
		        <strong>미세먼지:</strong> 
		        <span id="my-pm10-val">-</span>㎍/㎥ 
		        <span id="my-pm10-grade" class="normal">-</span>
		    </div>

		    <div class="info-item">
		        <strong>초미세먼지:</strong> 
		        <span id="my-pm25-val">-</span>㎍/㎥ 
		        <span id="my-pm25-grade" class="normal">-</span>
		    </div>

		    <div class="info-item">
		        <strong>오존:</strong> 
		        <span id="my-o3-val">-</span>ppm 
		        <span id="my-o3-grade" class="good">-</span>
		    </div>
		 </div>
        <!-- 주요 도시 대기질 -->
        <div class="overlay-cities">
          <h3> 주요 도시 대기질</h2>
            
          <div class="city-list">
			<c:forEach var="city" items="${cityAverages}">
	        <div class="city-card">
	          <div class="city-header">
	            <h3 class="city-name">${city.stationName}</h3>

	            <c:choose>
					<c:when test="${city.khaiGrade <= 50}">
					    <span class="city-grade good">좋음</span>
					</c:when>
					<c:when test="${city.khaiGrade <= 100}">
					    <span class="city-grade normal">보통</span>
					</c:when>
					<c:when test="${city.khaiGrade <= 250}">
					    <span class="city-grade bad">나쁨</span>
					</c:when>
					<c:otherwise>
					    <span class="city-grade very-bad">매우나쁨</span>
					</span>
	              </c:otherwise>
	            </c:choose>
	          </div>

	          <div class="city-info">
	            <div class="city-info-item">
	              <span class="city-info-label">미세먼지</span>
	              <span class="city-info-value">${city.pm10Value} ㎍/㎥</span>
	            </div>
	            <div class="city-info-item">
	              <span class="city-info-label">초미세먼지</span>
	              <span class="city-info-value">${city.pm25Value} ㎍/㎥</span>
	            </div>
	          </div>
	        </div>
	      </c:forEach>
          </div>
        </div>

        <div class="overlay-tips">
          <h2>💡 대기질 개선을 위한 팁</h2> <!-- ✅ 제목 다시 추가 -->
          <div class="tip-row">
            <div class="tip-box">🚌 <b>대중교통 이용</b>으로 오염 줄이기</div>
            <div class="tip-box">🌿 <b>식물</b>로 실내 공기 정화</div>
            <div class="tip-box">🪟 <b>환기</b>는 공기질 좋은 시간대에</div>
          </div>
        </div>

		<!-- ✅ 새로 추가된 건강 정보 박스 -->
        <div class="overlay-health">
          <h2>🏥 건강 정보</h2>
          <div class="health-row">
            <div class="health-box">
              <span class="health-grade good">좋음</span>
              <span class="health-text">모든 활동 가능</span>
            </div>
            <div class="health-box">
              <span class="health-grade normal">보통</span>
              <span class="health-text">민감한 사람 주의</span>
            </div>
            <div class="health-box">
              <span class="health-grade bad">나쁨</span>
              <span class="health-text">외출 시 마스크 착용</span>
            </div>
            <div class="health-box">
              <span class="health-grade verybad">매우나쁨</span>
              <span class="health-text">외출 자제 권장</span>
            </div>
          </div>
        </div>
		
       </div>
     </div>
   </section>
   <div class="top-download-bar">
      <button id="btnCsv" class="download-btn">CSV 다운로드</button>
      <button id="btnExcel" class="download-btn">Excel 다운로드</button>
  </div>
    <!-- 대기질 등급 안내 섹션 -->
    <section class="grade-guide-section">
      <div class="grade-guide-container">
        <div class="grade-guide-grid">
         <div class="grade-guide-card">
           <div class="grade-guide-icon good">🌤️</div>
           <h3 class="grade-guide-title good">좋음</h3>
           <p class="grade-guide-desc">대기질이 양호하여 모든 활동에 적합합니다.</p>
         </div>
          <div class="grade-guide-card">
            <div class="grade-guide-icon normal">⚠️</div>
            <h3 class="grade-guide-title normal">보통</h3>
            <p class="grade-guide-desc">일반적으로 양호하나 민감한 사람은 주의가 필요합니다.</p>
          </div>
        <div class="grade-guide-card">
          <div class="grade-guide-icon bad">⛔</div>
          <h3 class="grade-guide-title bad">나쁨</h3>
          <p class="grade-guide-desc">장시간 실외 활동 시 주의가 필요합니다.</p>
        </div>
        <div class="grade-guide-card">
          <div class="grade-guide-icon very-bad">😷</div>
          <h3 class="grade-guide-title very-bad">매우 나쁨</h3>
          <p class="grade-guide-desc">실외 활동을 자제하고 외출 시 마스크를 착용하세요.</p>
        </div>
        </div>
      </div>
    </section>

  </main>
  <!-- 챗봇 플로팅 버튼 -->
         <div id="chatbot-float-btn">
           <button id="chatbotBtn" aria-label="챗봇 열기">
            <img src="/img/chatbot2.png" alt="챗봇 아이콘" style="width: 40px; height: 40px; bottom:20px;">
           </button>
         </div>

         <!-- 챗봇 창(초기 숨김) -->
         <div id="chatbotModal" class="chatbot-modal" style="display:none;">
           <div class="chatbot-window">

             <!-- 닫기 버튼 -->
             <button id="chatbotClose" class="chatbot-close">✕</button>

             <!-- 대화 내용 -->
             <div id="chatMessages" class="chat-messages"></div>

             <!-- 입력 영역 -->
             <div class="chat-input-box">
               <input id="chatInput" type="text" placeholder="메시지를 입력하세요" />
               <button id="sendBtn" class="chat-send-btn">전송</button>
             </div>

           </div>
         </div>
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
  /* =========================================================
     공통 유틸 / Toast / Loading / 지도 기본 설정
     ========================================================= */

  /* 🔔 커스텀 토스트 (두 번째 스크립트 스타일) */
  const toast = (t) => {
    let m = document.getElementById('custom-toast');

    if (!m) {
      m = document.createElement('div');
      m.id = 'custom-toast';
      m.style.cssText = `
        position: fixed;
        bottom: 70%;
        left: 50%;
        transform: translateX(-50%);
        background: rgba(0,0,0,0.75);
        color: #fff;
        padding: 12px 24px;
        border-radius: 30px;
        font-size: 14px;
        font-weight: bold;
        box-shadow: 0 4px 10px rgba(0,0,0,0.25);
        z-index: 9999;
        opacity: 0;
        transition: opacity 0.3s;
      `;
      document.body.appendChild(m);
    }

    m.textContent = t;
    m.style.display = 'block';
    setTimeout(() => { m.style.opacity = '1'; }, 10);

    setTimeout(() => {
      m.style.opacity = '0';
      setTimeout(() => { m.style.display = 'none'; }, 300);
    }, 2000);
  };

  /* ⏳ 로딩 표시 */
  const showLoading = (b) => {
    const l = document.getElementById('loading');
    if (l) l.style.display = b ? 'block' : 'none';
  };

  /* 🗺️ 지도 기본 설정 */
  const mapContainer = document.getElementById('kakao-map');
  const map = new kakao.maps.Map(mapContainer, {
    center: new kakao.maps.LatLng(37.5665, 126.9780),
    level: 7
  });
  const geocoder = new kakao.maps.services.Geocoder();

  /* 전역 상태 */
  let currentOverlay = null;
  let currentStationName = null;
  let globalStations = [];        // 거리 계산/우측 패널용
  const markers = [];             // 측정소 오버레이
  const polygons = [];            // 시·도 폴리곤
  let pmSidoAvg = {};             // 시도 평균 값 (JSP에서 주입)
  const isLoggedIn = ${not empty sessionScope.loginId};

  /* JSP에서 주입되는 시도 평균 JSON 파싱 */
  try {
    pmSidoAvg = JSON.parse('${sidoAvgJson}');
    console.log('시도 평균 데이터:', pmSidoAvg);
  } catch (e) {
    console.error('❌ 시도 평균 JSON 파싱 실패:', e);
  }

  /* 숫자 포맷팅 */
  function fmt(n) {
    const num = Number(n);
    return isNaN(num) ? '-' : Number(num.toFixed(3));
  }

  /* 미세먼지 등급 → 텍스트 / 클래스 */
  function getGradeText(g) {
    const t = { '1': '좋음', '2': '보통', '3': '나쁨', '4': '매우나쁨' };
    return t[g] || '-';
  }
  function getGradeClass(g) {
    const c = {
      '1': 'grade-good',
      '2': 'grade-normal',
      '3': 'grade-bad',
      '4': 'grade-very-bad'
    };
    return c[g] || '';
  }

  /* =========================================================
     즐겨찾기(하트) 관련 API
     ========================================================= */
  async function fetchFavoriteOne(stationName) {
    try {
      const res = await fetch('/api/favorites/one?stationName=' + encodeURIComponent(stationName));
      if (!res.ok) return false;
      const json = await res.json();
      return json.exists || false;
    } catch {
      return false;
    }
  }

  async function toggleFavorite(stationName, position, data) {
    const res = await fetch('/api/favorites/toggle', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        stationName,
        dmY: position.getLat(),
        dmX: position.getLng(),
        pm10Value: data.pm10Value,
        pm25Value: data.pm25Value,
        o3Value: data.o3Value,
        no2Value: data.no2Value,
        coValue: data.coValue,
        so2Value: data.so2Value
      })
    });

    if (!res.ok) throw new Error(await res.text());
    const json = await res.json();
    return json.favorited === true;
  }

  /* =========================================================
     측정소 전체 로드 + 마커 표시
     ========================================================= */
  async function loadAllStations() {
    showLoading(true);
    try {
      const response = await fetch('/api/air/stations');
      if (!response.ok) throw new Error('API 호출 실패 ' + response.status);

      const stations = await response.json();
      globalStations = stations;      // 거리 계산용
      window.allStations = stations;  // 검색용

      displayStations(stations);
      toast('측정소 ' + stations.length + '개 로드 완료');
    } catch (e) {
      console.error(e);
      toast('데이터 로드 실패: ' + e.message);
    } finally {
      showLoading(false);
    }
  }

  /* 줌 레벨에 따라 마커/폴리곤 보이기 */
  function updateVisibilityByZoom() {
    const level = map.getLevel();

    markers.forEach(marker => {
      marker.setMap(level <= 9 ? map : null);
    });

    polygons.forEach(poly => {
      poly.setMap(level <= 9 ? null : map);
    });
  }

  /* 측정소 마커 표시 */
  function displayStations(stations) {
    // 기존 제거
    markers.forEach(m => m.setMap(null));
    markers.length = 0;

    const isZoomedIn = map.getLevel() <= 9;

    stations.forEach(station => {
      if (!station.dmX || !station.dmY) return;

      const position = new kakao.maps.LatLng(station.dmY, station.dmX);
      const content = document.createElement('div');
      content.className = 'custom-marker marker-normal';
      content.textContent = station.stationName;

      const overlay = new kakao.maps.CustomOverlay({
        position,
        content,
        yAnchor: 1
      });

      overlay.setMap(isZoomedIn ? map : null);
      markers.push(overlay);

      content.addEventListener('click', (e) => {
        e.stopPropagation();
        loadStationDetail(station.stationName, position);
      });
    });
  }

  /* =========================================================
     측정소 상세 정보 로드 + 정보창 표시
     ========================================================= */
  async function loadStationDetail(stationName, position) {
    showLoading(true);
    try {
      const res = await fetch('/api/air/station/' + encodeURIComponent(stationName));
      if (!res.ok) throw new Error('상세 API 오류');

      const json = await res.json();
      const item = json.response.body.items[0];

      if (!item) {
        toast('측정 데이터를 불러올 수 없습니다');
        return;
      }

      showInfoWindow(stationName, item, position);
    } catch (e) {
      console.error(e);
      toast('데이터 로드 실패');
    } finally {
      showLoading(false);
    }
  }

  function showInfoWindow(stationName, data, position) {
    // 같은 측정소 클릭 시 토글
    if (currentOverlay && currentStationName === stationName) {
      currentOverlay.setMap(null);
      currentOverlay = null;
      currentStationName = null;
      return;
    }

    if (currentOverlay) currentOverlay.setMap(null);

    const content = document.createElement('div');
    content.className = 'info-window';

    // 이벤트 전파 차단
    content.addEventListener('click', (e) => e.stopPropagation());
    content.addEventListener('mousedown', (e) => e.stopPropagation());

    // 제목 + 하트
    const titleDiv = document.createElement('div');
    titleDiv.className = 'info-title';

    const titleSpan = document.createElement('span');
    titleSpan.textContent = '📍 ' + stationName;

    const favSpan = document.createElement('span');
    favSpan.className = 'favorite-icon';
    favSpan.title = '관심지역 추가';
    favSpan.textContent = '🤍';
    favSpan.style.cursor = 'pointer';
    favSpan.style.fontSize = '24px';

    favSpan.onclick = async function (e) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();

      if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
          window.location.href = '/login';
        }
        return false;
      }

      try {
        const nowFavorited = await toggleFavorite(stationName, position, data);
        favSpan.textContent = nowFavorited ? '❤️' : '🤍';
        toast(nowFavorited ? '관심지역에 추가했습니다' : '관심지역에서 삭제했습니다');
      } catch (err) {
        console.error('오류:', err);
        toast('요청 처리 중 오류 발생');
      }
      return false;
    };

    favSpan.onmousedown = function (e) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();
    };

    titleDiv.appendChild(titleSpan);
    titleDiv.appendChild(favSpan);
    content.appendChild(titleDiv);

    // 정보 row 생성 함수
    function createInfoItem(label, value, gradeClass) {
      const item = document.createElement('div');
      item.className = 'info-item';

      const labelSpan = document.createElement('span');
      labelSpan.className = 'info-label';
      labelSpan.textContent = label;

      const valueSpan = document.createElement('span');
      valueSpan.className = 'info-value ' + (gradeClass || '');
      valueSpan.textContent = value;

      item.appendChild(labelSpan);
      item.appendChild(valueSpan);
      return item;
    }

    content.appendChild(createInfoItem(
      '미세먼지(PM10)',
      fmt(data.pm10Value || '-') + '㎍/m³ (' + getGradeText(String(data.pm10Grade)) + ')',
      getGradeClass(String(data.pm10Grade))
    ));
    content.appendChild(createInfoItem(
      '초미세먼지(PM2.5)',
      fmt(data.pm25Value || '-') + '㎍/m³ (' + getGradeText(String(data.pm25Grade)) + ')',
      getGradeClass(String(data.pm25Grade))
    ));
    content.appendChild(createInfoItem(
      '오존(O₃)',
      fmt(data.o3Value || '-') + 'ppm (' + getGradeText(String(data.o3Grade)) + ')',
      getGradeClass(String(data.o3Grade))
    ));
    content.appendChild(createInfoItem(
      '이산화질소(NO₂)',
      fmt(data.no2Value || '-') + 'ppm (' + getGradeText(String(data.no2Grade)) + ')',
      getGradeClass(String(data.no2Grade))
    ));
    content.appendChild(createInfoItem(
      '일산화탄소(CO)',
      fmt(data.coValue || '-') + 'ppm',
      ''
    ));
    content.appendChild(createInfoItem(
      '아황산가스(SO₂)',
      fmt(data.so2Value || '-') + 'ppm',
      ''
    ));

    const timeDiv = document.createElement('div');
    timeDiv.style.marginTop = '10px';
    timeDiv.style.fontSize = '11px';
    timeDiv.style.color = '#999';
    timeDiv.textContent = '측정시간: ' + (data.dataTime || '-');
    content.appendChild(timeDiv);

    const compareBtn = document.createElement('button');
    compareBtn.className = 'compare-btn';
    compareBtn.textContent = '상세보기';
    compareBtn.onclick = () => {
      window.location.href = '/station/detail?name=' + encodeURIComponent(stationName);
    };
    content.appendChild(compareBtn);

    const overlay = new kakao.maps.CustomOverlay({
      position,
      content,
      yAnchor: 1.15,
      zIndex: 10,
      clickable: true
    });
    overlay.setMap(map);
    currentOverlay = overlay;
    currentStationName = stationName;

    // 초기 하트 상태
    (async () => {
      if (!isLoggedIn) {
        favSpan.textContent = '🤍';
        return;
      }
      try {
        const isFav = await fetchFavoriteOne(stationName);
        favSpan.textContent = isFav ? '❤️' : '🤍';
      } catch (err) {
        console.error('하트 상태 로드 실패:', err);
      }
    })();
  }

  /* =========================================================
     시·도 폴리곤 색상 / 변환 함수 (첫 번째 스크립트 버전)
     ========================================================= */
  function getColorByGrade(gradeText) {
    if (gradeText === '매우나쁨') return '#ff0000';
    if (gradeText === '나쁨') return '#ff7f00';
    if (gradeText === '보통') return '#52c41a';
    return '#3b82f6'; // 좋음
  }

  function getGradeTextByKhai(khaiGrade) {
    if (khaiGrade <= 50) return '좋음';
    if (khaiGrade <= 100) return '보통';
    if (khaiGrade <= 250) return '나쁨';
    return '매우나쁨';
  }

  /* GeoJSON의 CTP_KOR_NM → 우리 평균 맵 키로 변환 */
  function normalizeSido(name) {
    if (!name) return null;

    // 광역시
    if (name.includes('서울')) return '서울';
    if (name.includes('부산')) return '부산';
    if (name.includes('대구')) return '대구';
    if (name.includes('인천')) return '인천';
    if (name.includes('광주')) return '광주';
    if (name.includes('대전')) return '대전';
    if (name.includes('울산')) return '울산';
    if (name.includes('세종')) return '세종';

    // 도
    if (name.includes('경기도') || name.includes('경기')) return '경기';
    if (name.includes('강원')) return '강원';
    if (name.includes('충청북') || name.includes('충북')) return '충북';
    if (name.includes('충청남') || name.includes('충남')) return '충남';
    if (name.includes('전라북') || name.includes('전북')) return '전북';
    if (name.includes('전라남') || name.includes('전남')) return '전남';
    if (name.includes('경상북') || name.includes('경북')) return '경북';
    if (name.includes('경상남') || name.includes('경남')) return '경남';
    if (name.includes('제주')) return '제주';

    return null;
  }

  /* 시도 경계 그리기 */
  function drawSidoRegions(geojson) {
    geojson.features.forEach(feature => {
      const props = feature.properties;
      const sidoFull = props.CTP_KOR_NM;
      const sidoKey = normalizeSido(sidoFull);

      if (!sidoKey) return;

      const avgObj = pmSidoAvg[sidoKey];
      if (!avgObj) return;

      const gradeText = getGradeTextByKhai(avgObj.khaiGrade);
      const fillColor = getColorByGrade(gradeText);

      const geom = feature.geometry;
      const coords = geom.coordinates;
      const paths = [];

      if (geom.type === 'Polygon') {
        coords.forEach(poly => {
          paths.push(poly.map(c => new kakao.maps.LatLng(c[1], c[0])));
        });
      } else if (geom.type === 'MultiPolygon') {
        coords.forEach(multi => {
          multi.forEach(poly => {
            paths.push(poly.map(c => new kakao.maps.LatLng(c[1], c[0])));
          });
        });
      }

      const polygon = new kakao.maps.Polygon({
        map: map,
        path: paths,
        strokeWeight: 2,
        strokeColor: '#222',
        strokeOpacity: 1,
        fillColor: fillColor,
        fillOpacity: 0.55
      });

      polygons.push(polygon);

      kakao.maps.event.addListener(polygon, 'mouseover', () => {
        polygon.setOptions({ fillOpacity: 0.8 });
      });

      kakao.maps.event.addListener(polygon, 'mouseout', () => {
        polygon.setOptions({ fillOpacity: 0.55 });
      });

      kakao.maps.event.addListener(polygon, 'click', (mouseEvent) => {
        const clickPos = mouseEvent.latLng;
        console.log('시도 클릭:', sidoFull, '클릭좌표:', clickPos.getLat(), clickPos.getLng());

        // 축소 폴리곤 숨기고 마커 보이기
        polygons.forEach(p => p.setMap(null));
        markers.forEach(m => m.setMap(map));

        map.setCenter(clickPos);
        map.setLevel(9);

        toast(`${sidoFull} 지역으로 이동했습니다.`);
      });
    });

    // 초기에 줌 상태에 맞게 표시
    updateVisibilityByZoom();
  }

  /* GeoJSON 로딩 */
  fetch('/geo/TL_SCCO_CTPRVN.json')
    .then(res => res.json())
    .then(json => {
      console.log('시도 GeoJSON 로드 완료');
      // 저장된 줌이 없을 때만 초기 레벨 세팅
      const savedLevel = localStorage.getItem('savedLevel');
      if (!savedLevel) {
        map.setLevel(10);
      }
      drawSidoRegions(json);
    })
    .catch(err => console.error('❌ 시도 GeoJSON 로드 실패:', err));

  /* =========================================================
     지도 상태 저장 / 복원 + 줌에 따른 표시 처리
     ========================================================= */
  // 줌 변경 시: 마커/폴리곤 표시 + 줌 저장
  kakao.maps.event.addListener(map, 'zoom_changed', () => {
    updateVisibilityByZoom();
    localStorage.setItem('savedLevel', map.getLevel());
  });

  // 중심 이동 시: 좌표 저장
  kakao.maps.event.addListener(map, 'center_changed', () => {
    const c = map.getCenter();
    localStorage.setItem('savedLat', c.getLat());
    localStorage.setItem('savedLng', c.getLng());
  });

  // 저장된 상태 있으면 복원
  (function restoreMapState() {
    const savedLevel = localStorage.getItem('savedLevel');
    const savedLat = localStorage.getItem('savedLat');
    const savedLng = localStorage.getItem('savedLng');

    if (savedLevel && savedLat && savedLng) {
      map.setLevel(Number(savedLevel));
      map.setCenter(new kakao.maps.LatLng(Number(savedLat), Number(savedLng)));
    }
  })();

  // 첫 로드시 한 번 줌 상태에 맞게 표시
  window.addEventListener('load', () => {
    setTimeout(updateVisibilityByZoom, 50);
  });

  /* =========================================================
     내 위치 / 지도 클릭 시 동작 (두 번째 스크립트 방식)
     ========================================================= */

  // 내 위치 기준 가장 가까운 측정소 찾기
  function getNearestStation(lat, lng) {
    let nearest = null;
    let minDist = Infinity;

    globalStations.forEach(st => {
      if (!st.dmX || !st.dmY) return;
      const dist = (st.dmX - lng) ** 2 + (st.dmY - lat) ** 2;
      if (dist < minDist) {
        minDist = dist;
        nearest = st;
      }
    });
    return nearest;
  }

  // 우측 패널(있다면) 업데이트
  function updateMyNeighborhoodUI(station) {
    if (!station) return;

    const setText = (id, val) => {
      const el = document.getElementById(id);
      if (el) el.textContent = val;
    };
    const setGrade = (id, g) => {
      const el = document.getElementById(id);
      if (el) {
        el.textContent = getGradeText(String(g));
        el.className = getGradeClass(String(g));
      }
    };

    setText('my-station-name', station.stationName);
    setText('my-pm10-val', station.pm10Value);
    setGrade('my-pm10-grade', station.pm10Grade);

    setText('my-pm25-val', station.pm25Value);
    setGrade('my-pm25-grade', station.pm25Grade);

    const o3Val = document.getElementById('my-o3-val');
    const o3Grade = document.getElementById('my-o3-grade');
    if (o3Val) {
      if (station.o3Value === 0 || station.o3Value == null) {
        o3Val.textContent = '-';
        if (o3Grade) {
          o3Grade.textContent = '-';
          o3Grade.className = 'normal';
        }
      } else {
        o3Val.textContent = station.o3Value;
        if (o3Grade) {
          const g = station.o3Grade || 1;
          o3Grade.textContent = getGradeText(String(g));
          o3Grade.className = getGradeClass(String(g));
        }
      }
    }
  }

  // 내 위치 찾기 (버튼 눌렀을 때만 실행)
  function getMyLocation() {
    if (!navigator.geolocation) {
      toast('브라우저가 위치 기능을 지원하지 않습니다.');
      return;
    }

    showLoading(true);

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const lat = position.coords.latitude;
        const lng = position.coords.longitude;
        const latlng = new kakao.maps.LatLng(lat, lng);

        map.setCenter(latlng);
        map.setLevel(5);

        if (window.myMarker) {
          window.myMarker.setPosition(latlng);
        } else {
          const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
          const imageSize = new kakao.maps.Size(24, 35);
          const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

          window.myMarker = new kakao.maps.Marker({
            position: latlng,
            map: map,
            image: markerImage,
            draggable: false,
            title: '내 위치'
          });
        }

        if (globalStations.length > 0) {
          const nearest = getNearestStation(lat, lng);
          if (nearest) {
            updateMyNeighborhoodUI(nearest);
            toast('현재 위치 기준: ' + nearest.stationName);
          }
        }
        showLoading(false);
      },
      (err) => {
        showLoading(false);
        if (err.code === 1) {
          alert('위치 권한을 허용해야 이 기능을 사용할 수 있습니다.\n(브라우저 주소창 옆 자물쇠 버튼에서 권한을 허용해주세요)');
        } else {
          toast('위치를 가져올 수 없습니다.');
        }
      }
    );
  }

  /* 지도 클릭 시: 오버레이 닫기 + (필요시) 내 위치 마커 이동 */
  kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
    if (currentOverlay) {
      currentOverlay.setMap(null);
      currentOverlay = null;
      currentStationName = null;
      return;
    }

    if (window.myMarker) {
      const latlng = mouseEvent.latLng;
      window.myMarker.setPosition(latlng);

      if (globalStations.length > 0) {
        const nearest = getNearestStation(latlng.getLat(), latlng.getLng());
        if (nearest) {
          updateMyNeighborhoodUI(nearest);
          toast('설정된 측정소: ' + nearest.stationName);
        }
      }
    }
  });

  /* =========================================================
     검색 기능 (측정소명 → 없으면 주소 검색)
     ========================================================= */
  document.getElementById('btnSearch').addEventListener('click', () => {
    const query = document.getElementById('searchInput').value.trim();
    if (!query) return toast('검색어를 입력하세요');

    const lower = query.toLowerCase();
    const matches = (window.allStations || []).filter(s =>
      s.stationName && s.stationName.toLowerCase().includes(lower)
    );

    if (matches.length > 0) {
      const target = matches[0];
      const latlng = new kakao.maps.LatLng(target.dmY, target.dmX);
      map.setCenter(latlng);
      map.setLevel(6);
      loadStationDetail(target.stationName, latlng);

      // 내 위치 마커도 이동시키고 패널 갱신
      if (window.myMarker) {
        window.myMarker.setPosition(latlng);
      } else {
        const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
        const imageSize = new kakao.maps.Size(24, 35);
        const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

        window.myMarker = new kakao.maps.Marker({
          position: latlng,
          map: map,
          image: markerImage,
          draggable: false,
          title: '검색 위치'
        });
      }

      if (globalStations.length > 0) {
        const nearest = getNearestStation(target.dmY, target.dmX);
        if (nearest) {
          updateMyNeighborhoodUI(nearest);
          toast('검색 위치 기준: ' + nearest.stationName);
        }
      }

      return;
    }

    // 측정소 이름에 없으면 → 주소 검색
    geocoder.addressSearch(query, (res, status) => {
      if (status === kakao.maps.services.Status.OK) {
        const lat = res[0].y;
        const lng = res[0].x;
        const latlng = new kakao.maps.LatLng(lat, lng);

        map.setCenter(latlng);
        map.setLevel(6);

        if (window.myMarker) {
          window.myMarker.setPosition(latlng);
        } else {
          const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
          const imageSize = new kakao.maps.Size(24, 35);
          const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

          window.myMarker = new kakao.maps.Marker({
            position: latlng,
            map: map,
            image: markerImage,
            draggable: false,
            title: '검색 위치'
          });
        }

        if (globalStations.length > 0) {
          const nearest = getNearestStation(lat, lng);
          if (nearest) {
            updateMyNeighborhoodUI(nearest);
            toast('검색 위치 기준: ' + nearest.stationName);
          }
        }
      } else {
        toast('검색 결과가 없습니다');
      }
    });
  });

  // 검색 인풋 엔터 처리
  document.getElementById('searchInput').addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      document.getElementById('btnSearch').click();
    }
  });

  /* 버튼 핸들러 */
  if (document.getElementById('btnMyPos')) {
    document.getElementById('btnMyPos').addEventListener('click', getMyLocation);
  }
  if (document.getElementById('btnRefresh')) {
    document.getElementById('btnRefresh').addEventListener('click', async () => {
      await loadAllStations();
      updateVisibilityByZoom();
    });
  }
  if (document.getElementById('btnCsv')) {
    document.getElementById('btnCsv').addEventListener('click', () => {
      window.location.href = '/api/air/download/csv';
    });
  }
  if (document.getElementById('btnExcel')) {
    document.getElementById('btnExcel').addEventListener('click', () => {
      window.location.href = '/api/air/download/excel';
    });
  }

  /* 페이지 로드시 측정소 데이터 로드 */
  window.addEventListener('load', loadAllStations);

  /* =========================================================
     챗봇 (Gemini) – 첫 번째 스크립트 내용 포함
     ========================================================= */

	 window.addEventListener('DOMContentLoaded', function() {
	      initChatbot();
	    });
	    

	    // 타이핑 표시
	    function showTyping() {
	      const box = document.getElementById("chatMessages");
	      if (document.getElementById("typing-indicator")) return;

	      const wrapper = document.createElement("div");
	      wrapper.className = "chat-msg bot";
	      wrapper.id = "typing-indicator";
	      wrapper.innerHTML = `
	        <div class="msg-bubble typing-animation">
	          <span class="dot"></span>
	          <span class="dot"></span>
	          <span class="dot"></span>
	        </div>
	      `;
	      box.appendChild(wrapper);
	      box.scrollTop = box.scrollHeight;
	    }

	    // 타이핑 표시 숨기기
	    function hideTyping() {
	      const typing = document.getElementById("typing-indicator");
	      if (typing) typing.remove();
	    }

	    // 챗봇 관련 초기화
	    function initChatbot() {
	      const btnChatbotOpen = document.getElementById("chatbotBtn");
	      const btnChatbotClose = document.getElementById("chatbotClose");
	      const btnSend = document.getElementById("sendBtn");
	      const chatInput = document.getElementById("chatInput");

	      if (btnChatbotOpen) {
	        btnChatbotOpen.addEventListener("click", () => {
	          document.getElementById("chatbotModal").style.display = "block";
	        });
	      }

	      if (btnChatbotClose) {
	        btnChatbotClose.addEventListener("click", () => {
	          document.getElementById("chatbotModal").style.display = "none";
	        });
	      }

	      if (btnSend) {
	        btnSend.addEventListener("click", () => {
	          console.log('전송 버튼 클릭');
	          sendUserMessage(chatInput.value);
	        });
	      }

	      if (chatInput) {
	        chatInput.addEventListener("keydown", (e) => {
	          if (e.key === "Enter") {
	            console.log('엔터키 눌림');
	            sendUserMessage(chatInput.value);
	          }
	        });
	      }
	    }

	    // 메시지 전송 함수
	    function sendUserMessage(message) {
	      if (!message.trim()) return;

	      displayMessage(message, "user");
	      document.getElementById("chatInput").value = "";

	      showTyping();

	      fetch('/api/gemini', {
	        method: 'POST',
	        headers: { "Content-Type": "application/json" },
	        body: JSON.stringify({ message: message })
	      })
	        .then(resp => resp.json())
	        .then(data => {
	          hideTyping();
	          const botText = data.contents?.[0]?.parts?.[0]?.text || "응답이 없습니다";
	          displayMessage(botText, "bot");
	        })
	        .catch(err => {
	          hideTyping();
	          displayMessage("“지금 Gemini가 잠시 바쁨! 조금 뒤 다시 시도해줘 😊”", "bot");
	          console.error('Fetch error:', err);
	        });
	    }


	    // 화면에 메시지 출력
	    function displayMessage(text, sender = "bot") {
	      const box = document.getElementById("chatMessages");

	      const wrapper = document.createElement("div");
	      wrapper.className = sender === "user" ? "chat-msg user" : "chat-msg bot";

	      if (sender === "bot") {
	        const avatar = document.createElement("img");
	        avatar.className = "chat-avatar";
	        avatar.src = "/img/bot.png";
	        wrapper.appendChild(avatar);
	      }

	      const bubble = document.createElement("div");
	      bubble.className = "msg-bubble";
	      bubble.innerHTML = text;
	      wrapper.appendChild(bubble);

	      box.appendChild(wrapper);
	      box.scrollTop = box.scrollHeight;
	    }
  </script>


</body>
</html>
