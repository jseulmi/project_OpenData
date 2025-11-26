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
  <style>
	.compare-btn {
	  width: 100%;
	  background: #2563eb;
	  color: white;
	  padding: 8px 0;
	  margin-top: 12px;
	  border-radius: 6px;
	  border: none;
	  cursor: pointer;
	  font-weight: 600;
	}

	.compare-btn:hover {
	  background: #1d4ed8;
	}
	.compare-panel {
	  position: fixed;
	  bottom: 20px;
	  right: 20px;
	  width: 350px;
	  background: white;
	  border-radius: 12px;
	  box-shadow: 0 4px 12px rgba(0,0,0,0.25);
	  padding: 15px;
	  z-index: 9999;
	}

	.compare-header {
	  display: flex;
	  justify-content: space-between;
	  font-weight: bold;
	  margin-bottom: 12px;
	  font-size: 16px;
	}

	.compare-header button {
	  border: none;
	  background: none;
	  cursor: pointer;
	  font-size: 18px;
	}

	.compare-table {
	  width: 100%;
	  border-collapse: collapse;
	}

	.compare-table th,
	.compare-table td {
	  padding: 6px 4px;
	  border-bottom: 1px solid #eee;
	  text-align: right;
	}

	.compare-table th {
	  text-align: left;
	  font-weight: 600;
	  color: #333;
	}

	.highlight-good { color: #22c55e; font-weight: bold; }
	.highlight-bad  { color: #ef4444; font-weight: bold; }

	.compare-select-info {
	  font-size: 13px;
	  margin-bottom: 10px;
	  color: #666;
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
       <div id="kakao-map"></div>
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
		 <button id="btnPolygonMode">폴리곤 모드</button>
		 <button id="btnNormalMode" style="display:none;">일반 모드</button>
		 
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
           <h3>우리동네 대기질</h3>
           <div class="info-item"><strong>초미세먼지:</strong> 26㎍/㎥ <span class="normal">보통</span></div>
           <div class="info-item"><strong>미세먼지:</strong> 45㎍/㎥ <span class="normal">보통</span></div>
           <div class="info-item"><strong>오존:</strong> 0.0054ppm <span class="good">좋음</span></div>
         
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

  <script src="/js/main.js"></script>
  <script>
    const toast = (t)=>{ const m=document.getElementById('msg'); m.textContent=t; m.style.display='block'; setTimeout(()=>m.style.display='none',2500); };
    const showLoading = (b)=>{ document.getElementById('loading').style.display = b ? 'block' : 'none'; };

    const mapContainer = document.getElementById('kakao-map');
    const map = new kakao.maps.Map(mapContainer, { center: new kakao.maps.LatLng(37.5665, 126.9780), level: 7 });
    const geocoder = new kakao.maps.services.Geocoder();
    let currentOverlay = null, currentStationName = null;
    const markers = [];

   

    // ✅ 지도 클릭 이벤트 등록 (정보창 닫기)
    kakao.maps.event.addListener(map, 'click', function() {
      if (currentOverlay) {
        currentOverlay.setMap(null);
        currentOverlay = null;
        currentStationName = null;
      }
    });

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
        headers: {'Content-Type': 'application/json'},
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

    async function loadAllStations() {
      showLoading(true);
      try {
        const response = await fetch('/api/air/stations');
        if (!response.ok) throw new Error('API 호출 실패 ' + response.status);
		const stations = await response.json();   // 🚀 리스트 직접 받기!
		window.allStations = stations;
        displayStations(stations);
        toast('측정소 ' + stations.length + '개 로드 완료');
      } catch(e) {
        console.error(e);
        toast('데이터 로드 실패: ' + e.message);
      } finally {
        showLoading(false);
      }
    }

	function displayStations(stations) {
	  // 기존 마커 제거
	  markers.forEach(m => m.setMap(null));
	  markers.length = 0;

	  // 🔥 지금 줌 레벨 기준
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

	    // 🔥 확대 상태일 때만 마커를 지도에 올리기
	    overlay.setMap(isZoomedIn ? map : null);

	    markers.push(overlay);

	    content.addEventListener('click', (e) => {
	      e.stopPropagation();
	      loadStationDetail(station.stationName, position);
	    });
	  });
	}

	async function loadStationDetail(stationName, position) {
	  showLoading(true);
	  try {

	    const res = await fetch('/api/air/station/' + encodeURIComponent(stationName));
	    if (!res.ok) throw new Error("상세 API 오류");

	    const json = await res.json();
	    const item = json.response.body.items[0];

	    if (!item) { toast('측정 데이터를 불러올 수 없습니다'); return; }

	    showInfoWindow(stationName, item, position);
	  } catch(e) {
	    console.error(e);
	    toast('데이터 로드 실패');
	  } finally {
	    showLoading(false);
	  }
	}
    function getGradeText(grade) {
      const grades = { '1': '좋음', '2': '보통', '3': '나쁨', '4': '매우나쁨' };
      return grades[grade] || '-';
    }

    function getGradeClass(grade) {
      const classes = { '1': 'grade-good', '2': 'grade-normal', '3': 'grade-bad', '4': 'grade-very-bad' };
      return classes[grade] || '';
    }

   function showInfoWindow(stationName, data, position) {
     if (currentOverlay && currentStationName === stationName) {
       currentOverlay.setMap(null);
       currentOverlay = null;
       currentStationName = null;
       return;
     }

     if (currentOverlay) currentOverlay.setMap(null);

     const content = document.createElement('div');
     content.className = 'info-window';

     // ✅ 정보창 전체 클릭 시 이벤트 전파 차단
     content.addEventListener('click', (e) => {
       e.stopPropagation();
     });
     
     // ✅ mousedown도 차단
     content.addEventListener('mousedown', (e) => {
       e.stopPropagation();
     });

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
     
     // ✅ 하트 클릭 이벤트 (여러 단계로 차단)
     favSpan.onclick = async function(e) {
       e.preventDefault();
       e.stopPropagation();
       e.stopImmediatePropagation();  // ✅ 추가
       
       console.log('🎯 하트 클릭됨!');
       
       if (!isLoggedIn) {
         if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
           window.location.href = '/login';
         }
         return false;  // ✅ 추가
       }
       
       try {
         const nowFavorited = await toggleFavorite(stationName, position, data);
         favSpan.textContent = nowFavorited ? '❤️' : '🤍';
         toast(nowFavorited ? '관심지역에 추가했습니다' : '관심지역에서 삭제했습니다');
       } catch (err) {
         console.error('오류:', err);
         toast('요청 처리 중 오류 발생');
       }
       
       return false;  // ✅ 추가
     };
	 
     // ✅ mousedown도 차단
     favSpan.onmousedown = function(e) {
       e.preventDefault();
       e.stopPropagation();
       e.stopImmediatePropagation();
     };
     
     titleDiv.appendChild(titleSpan);
     titleDiv.appendChild(favSpan);
     content.appendChild(titleDiv);
	
     function createInfoItem(label, value, gradeClass) {
       const item = document.createElement('div');
       item.className = 'info-item';
       
       const labelSpan = document.createElement('span');
       labelSpan.className = 'info-label';
       labelSpan.textContent = label;
       
       const valueSpan = document.createElement('span');
       valueSpan.className = 'info-value ' + gradeClass;
       valueSpan.textContent = value;
       
       item.appendChild(labelSpan);
       item.appendChild(valueSpan);
       return item;
     }

     content.appendChild(createInfoItem('미세먼지(PM10)', fmt(data.pm10Value || '-') + '㎍/m³ (' + getGradeText(data.pm10Grade) + ')', getGradeClass(data.pm10Grade)));
     content.appendChild(createInfoItem('초미세먼지(PM2.5)', fmt(data.pm25Value || '-') + '㎍/m³ (' + getGradeText(data.pm25Grade) + ')', getGradeClass(data.pm25Grade)));
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
     content.appendChild(createInfoItem('일산화탄소(CO)', fmt(data.coValue || '-') + 'ppm', ''));
     content.appendChild(createInfoItem('아황산가스(SO₂)', fmt(data.so2Value || '-') + 'ppm', ''));

     const timeDiv = document.createElement('div');
     timeDiv.style.marginTop = '10px';
     timeDiv.style.fontSize = '11px';
     timeDiv.style.color = '#999';
     timeDiv.textContent = '측정시간: ' + (data.dataTime || '-');
     content.appendChild(timeDiv);
	
	 const compareBtn = document.createElement("button");
	 compareBtn.className = "compare-btn";
	 compareBtn.textContent = "상세보기";
	 compareBtn.onclick = () => addToCompare(stationName, data);

	 content.appendChild(compareBtn);
	 
     const overlay = new kakao.maps.CustomOverlay({
       position, 
       content, 
       yAnchor: 1.15, 
       zIndex: 10,
       clickable: true  // ✅ 중요: 클릭 가능하도록 설정
     });
     overlay.setMap(map);
     currentOverlay = overlay;
     currentStationName = stationName;

     // 초기 하트 상태 로드
     (async () => {
       if (!isLoggedIn) {
         favSpan.textContent = '🤍';
         return;
       }
       
       try {
         const isFav = await fetchFavoriteOne(stationName);
         favSpan.textContent = isFav ? '❤️' : '🤍';
         console.log(stationName, '관심지역 여부:', isFav);
       } catch (err) {
         console.error('하트 상태 로드 실패:', err);
       }
     })();

     console.log('✅ showInfoWindow 완료');
   }

   document.getElementById('btnSearch').addEventListener('click', async () => {
       const query = document.getElementById('searchInput').value.trim();
       if (!query) return toast('검색어를 입력하세요');

       // 1️⃣ 측정소 이름 부분 검색
       const lower = query.toLowerCase();
       const matches = window.allStations?.filter(s =>
           s.stationName.toLowerCase().includes(lower)
       );

       if (matches && matches.length > 0) {
           // 가장 첫 번째 관측소로 이동
           const target = matches[0];
           
           const latlng = new kakao.maps.LatLng(target.dmY, target.dmX);
           map.setCenter(latlng);
           map.setLevel(6);

           loadStationDetail(target.stationName, latlng);
           return;
       }

       // 2️⃣ 관측소 이름에 없으면 → 주소 검색 fallback
       geocoder.addressSearch(query, (res, status) => {
           if (status === kakao.maps.services.Status.OK) {
               const latlng = new kakao.maps.LatLng(res[0].y, res[0].x);
               map.setCenter(latlng);
               map.setLevel(6);
           } else {
               toast('검색 결과가 없습니다');
           }
       });
   });
   document.getElementById('searchInput').addEventListener('keydown', (e) => {
       if (e.key === 'Enter') {
           e.preventDefault(); // 폼 제출 방지
           document.getElementById('btnSearch').click(); // 검색 버튼 클릭과 같은 동작
       }
   });

   document.getElementById('btnMyPos').addEventListener('click', () => {
        // ✅ 고정 좌표 지정
        const fixedLat = 35.1487052773634;
        const fixedLng = 129.058893902842;

        const latlng = new kakao.maps.LatLng(fixedLat, fixedLng);
        map.setCenter(latlng);
        map.setLevel(4); // 지도 확대 레벨 (원하면 조절 가능)

        // 마커 표시 (기존 마커 있으면 재사용)
        if (window.myMarker) {
          window.myMarker.setPosition(latlng);
        } else {
          window.myMarker = new kakao.maps.Marker({
            position: latlng,
            map: map
          });
        }

        toast('내 위치로 이동했습니다');
      });

	document.getElementById('btnRefresh').addEventListener('click', async () => {
	    await loadAllStations();
	    // 혹시 모를 상태 꼬임 방지용
	    const level = map.getLevel();
	    markers.forEach(m => m.setMap(level <= 9 ? map : null));
	    polygons.forEach(p => p.setMap(level <= 9 ? null : map));
	});
    window.addEventListener('load', loadAllStations);
	
	document.getElementById("btnCsv").addEventListener("click", () => {
	    window.location.href = "/api/air/download/csv";
	});

	document.getElementById("btnExcel").addEventListener("click", () => {
	    window.location.href = "/api/air/download/excel";
	});
	
<!--	숫자 포맷팅 함수 -->
	function fmt(n) {
	    const num = Number(n);
	    return isNaN(num) ? '-' : Number(num.toFixed(3));
	}

	let pmSidoAvg = {};
	try {
	    pmSidoAvg = JSON.parse('${sidoAvgJson}');
	    console.log("시도 평균 데이터:", pmSidoAvg);
	} catch (e) {
	    console.error("❌ 시도 평균 JSON 파싱 실패:", e);
	}


	/* =========================================================
	   2) 시도 등급 → 색상 변환
	   ========================================================= */
	function getColorByGrade(grade) {
	    if (grade === "매우나쁨") return "#ff0000";   // 빨강
	    if (grade === "나쁨") return "#ff7f00";       // 주황
	    if (grade === "보통") return "#52c41a";       // 초록
	    return "#3b82f6";                             // 파랑 (좋음)
	}


	/* =========================================================
	   3) GeoJSON 시도명 → 평균맵 키 변환
	      (서울특별시 → 서울, 경상북도 → 경북)
	   ========================================================= */
	function normalizeSido(name) {
	    if (!name) return null;

		// 광역시
	    if (name.includes("서울특별시") || name.includes("서울")) return "서울";
	    if (name.includes("부산광역시") || name.includes("부산")) return "부산";
	    if (name.includes("대구광역시") || name.includes("대구")) return "대구";
	    if (name.includes("인천광역시") || name.includes("인천")) return "인천";
	    if (name.includes("광주광역시") || name.includes("광주")) return "광주";
	    if (name.includes("대전광역시") || name.includes("대전")) return "대전";
	    if (name.includes("울산광역시") || name.includes("울산")) return "울산";
	    if (name.includes("세종특별자치시") || name.includes("세종")) return "세종";

	    // 도
	    if (name.includes("경기도") || name.includes("경기")) return "경기";
	    if (name.includes("강원도") || name.includes("강원")) return "강원";

	    if (name.includes("충청북도") || name.includes("충북")) return "충북";
	    if (name.includes("충청남도") || name.includes("충남")) return "충남";

	    if (name.includes("전라북도") || name.includes("전북")) return "전북";
	    if (name.includes("전라남도") || name.includes("전남")) return "전남";

	    if (name.includes("경상북도") || name.includes("경북")) return "경북";
	    if (name.includes("경상남도") || name.includes("경남")) return "경남";

	    if (name.includes("제주특별자치도") || name.includes("제주")) return "제주";

	    return null;
	}

	function getGradeTextByKhai(khaiGrade) {
	    if (khaiGrade <= 50) return "좋음";
	    if (khaiGrade <= 100) return "보통";
	    if (khaiGrade <= 250) return "나쁨";
	    return "매우나쁨";
	}
	/* =========================================================
	   4) 시도 경계 GeoJSON 받아서 폴리곤 그리기
	   ========================================================= */
	const polygons = [];
	function drawSidoRegions(geojson) {

	    geojson.features.forEach(feature => {

	        const props = feature.properties;
	        const sidoFull = props.CTP_KOR_NM;       // GeoJSON 시도이름 (예: 서울특별시)
	        const sidoKey = normalizeSido(sidoFull); // 평균값 키 (예: 서울)

	        if (!sidoKey) return;

	        const avgObj = pmSidoAvg[sidoKey];
	        if (!avgObj) return;

			const grade = getGradeTextByKhai(avgObj.khaiGrade);
			const fillColor = getColorByGrade(grade);

	        const geom = feature.geometry;
	        const coords = geom.coordinates;
	        const paths = [];

	        // polygon
	        if (geom.type === "Polygon") {
	            coords.forEach(poly => {
	                paths.push(poly.map(c => new kakao.maps.LatLng(c[1], c[0])));
	            });
	        }
	        // multipolygon
	        else if (geom.type === "MultiPolygon") {
	            coords.forEach(multi => {
	                multi.forEach(poly => {
	                    paths.push(poly.map(c => new kakao.maps.LatLng(c[1], c[0])));
	                });
	            });
	        }

	        // 실제 폴리곤 생성
	        const polygon = new kakao.maps.Polygon({
	            map: map,
	            path: paths,
	            strokeWeight: 2,
	            strokeColor: "#222",
	            strokeOpacity: 1,
	            fillColor: fillColor,
	            fillOpacity: 0.55
	        });
			polygon.setMap(map);
	        polygons.push(polygon);
	        // 마우스 효과
	        kakao.maps.event.addListener(polygon, "mouseover", () => {
	            polygon.setOptions({ fillOpacity: 0.8 });
	        });

	        kakao.maps.event.addListener(polygon, "mouseout", () => {
	            polygon.setOptions({ fillOpacity: 0.55 });
	        });

			kakao.maps.event.addListener(polygon, "click", (mouseEvent) => {
			    // 1) 클릭한 실제 좌표
			    const clickPos = mouseEvent.latLng;

			    console.log("시도 클릭:", sidoFull, "클릭좌표:", clickPos.getLat(), clickPos.getLng());

			    // 2) 폴리곤은 숨기고 마커는 보이게
			    polygons.forEach(p => p.setMap(null));
			    markers.forEach(m => m.setMap(map));

			    // 3) 클릭한 지점으로 이동 + 관측소가 잘 보이는 레벨로 확대
			    map.setCenter(clickPos);
			    map.setLevel(9);  // 🔥 조절 가능: 7~9 추천

			    toast(`${sidoFull} 지역으로 이동했습니다.`);
			});
	    });
	}


	/* =========================================================
	   5) GeoJSON 로딩 시작
	   ========================================================= */
	fetch("/geo/TL_SCCO_CTPRVN.json")
	    .then(res => res.json())
	    .then(json => {
	        console.log("시도 GeoJSON 로드 완료");
	        map.setLevel(10); // 시도 단위 잘 보이도록
	        drawSidoRegions(json);
	    })
	    .catch(err => console.error("❌ 시도 GeoJSON 로드 실패:", err));
	// 6) 폴리곤 & 마커 ON/OFF 처리
	kakao.maps.event.addListener(map, 'zoom_changed', function () {
	    const level = map.getLevel();

	    // 마커 표시: 확대일 때만
	    markers.forEach(marker => {
	        if (level <= 9) marker.setMap(map);
	        else marker.setMap(null);
	    });

	    // 폴리곤 표시: 축소일 때만
	    polygons.forEach(poly => {
	        if (level <= 9) poly.setMap(null);   // 시도 폴리곤 숨김 (확대 시)
	        else poly.setMap(map);               // 축소 시 다시 보임
	    });
	});
	// GeoJSON paths(엄청 깊은 배열) → bounds 로 넣어주는 재귀 함수
	function addBoundsFromPaths(arr, bounds) {
	  if (!arr) return;

	  arr.forEach(item => {
	    // LatLng 객체
	    if (item instanceof kakao.maps.LatLng) {
	      bounds.extend(item);
	    }
	    // [lng, lat] 숫자 배열
	    else if (
	      Array.isArray(item) &&
	      item.length === 2 &&
	      typeof item[0] === "number" &&
	      typeof item[1] === "number"
	    ) {
	      const latlng = new kakao.maps.LatLng(item[1], item[0]);
	      bounds.extend(latlng);
	    }
	    // 더 깊은 배열
	    else if (Array.isArray(item)) {
	      addBoundsFromPaths(item, bounds);
	    }
	  });
	}
	// 지도 줌 변경 시 저장
	kakao.maps.event.addListener(map, 'zoom_changed', () => {
	    localStorage.setItem("savedLevel", map.getLevel());
	});

	// 지도 이동 시 저장
	kakao.maps.event.addListener(map, 'center_changed', () => {
	    const c = map.getCenter();
	    localStorage.setItem("savedLat", c.getLat());
	    localStorage.setItem("savedLng", c.getLng());
	});
	// 저장된 지도 상태가 있으면 복원
	const savedLevel = localStorage.getItem("savedLevel");
	const savedLat = localStorage.getItem("savedLat");
	const savedLng = localStorage.getItem("savedLng");

	if (savedLevel && savedLat && savedLng) {
	    map.setLevel(Number(savedLevel));
	    map.setCenter(new kakao.maps.LatLng(Number(savedLat), Number(savedLng)));
	}
	function updateVisibilityByZoom() {
	    const level = map.getLevel();

	    markers.forEach(marker => {
	        marker.setMap(level <= 9 ? map : null);
	    });

	    polygons.forEach(poly => {
	        poly.setMap(level <= 9 ? null : map);
	    });
	}
	window.addEventListener("load", () => {
	    setTimeout(updateVisibilityByZoom, 50);
	});
  </script>
</body>
</html>
