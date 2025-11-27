<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.boot.dto.AirQualityDTO" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>대기질 정보 – 지역별 미세먼지 농도</title>
  
  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  
  <!-- Kakao Map SDK -->
  <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=246b6a1fdd8897003813a81be5f97cd5&libraries=services,clusterer"></script>
  <script src="/js/banner.js"></script>
  
  <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
  
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

  body {
    margin: 0;
    padding: 0;
    background: #fff;
    font-family: 'Noto Sans KR', sans-serif;
  }
  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
    box-sizing: border-box;
  }

  /* --- 상세 정보 컨테이너 디자인 개선 --- */
  .detail-container {
    /* max-width: 900px;  <- 이 부분을 */
    max-width: 1000px; /* ✅ 차트 박스 max-width와 동일하게 1000px로 변경 */
    margin: 30px auto;
    padding: 25px;
    border: 1px solid #e0e0e0; /* 연한 경계선 */
    border-radius: 12px;
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.05); /* 은은한 그림자 */
    background: #ffffff;
  }


  .detail-header h1 {
    font-size: 28px;
    font-weight: 700;
    color: #1f2937;
  }

  .detail-header p {
    font-size: 14px;
    color: #6b7280;
    margin-top: 5px;
  }

  /* --- 상세 항목 레이아웃 개선 (그리드) --- */
  .detail-content {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); /* 두 열 레이아웃 */
    gap: 15px 30px;
  }

  .detail-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px dashed #e5e7eb; /* 점선으로 변경 */
  }

  .detail-item:last-child {
    border-bottom: none;
  }

  .detail-item-label {
    font-weight: 500;
    color: #4b5563;
    font-size: 16px;
  }

  .detail-item-value {
    font-weight: 700;
    font-size: 16px;
    padding-left: 10px; /* 라벨과의 간격 확보 */
  }

  /* --- 등급 색상 정의 (main.css에 없을 경우 대비하여 명시) --- */
  .grade-1, .grade-good { color: #10b981; } /* 에메랄드 그린 */
  .grade-2, .grade-normal { color: #3b82f6; } /* 밝은 파랑 */
  .grade-3, .grade-bad { color: #f59e0b; } /* 호박색 주황 */
  .grade-4, .grade-verybad { color: #ef4444; } /* 빨강 */


  /* --- 차트 섹션 디자인 개선 --- */
  .chart-section {
     max-width: 1000px;
     margin: 30px auto;
     padding: 30px;
    /* background-color: #f7f9fc !important;  이 줄을 주석 처리하거나 아래처럼 변경 */
    background-color: #ffffff !important; /* 배경색을 흰색으로 변경 */
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
  }
  .chart-section h2 {
    font-size: 24px;
    color: #1f2937;
    border-bottom: 1px solid #ccc;
    padding-bottom: 10px;
    margin-bottom: 20px;
  }

  .chart-section h3 {
    font-size: 18px;
    color: #4b5563;
    margin-bottom: 15px;
  }

  /* --- 버튼 스타일 통일 및 개선 --- */
  .back-to-main-btn {
    display: inline-block;
    padding: 12px 25px;
    background: #3b82f6;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: 600;
    transition: background 0.2s;
    margin-top: 10px;
  }
  .back-to-main-btn:hover {
    background: #2563eb;
  }

  /* 추가된 main 태그 h1 스타일 (상단 제목) */
  /* 상단 측정소 제목 (세련된 라인 스타일) */
  main h1 {
    max-width: 1000px;
    margin: 10px auto 18px;   /* ⬅ 28px → 10px 등 원하는 값으로 축소 */
    font-size: 24px;
    font-weight: 700;
    color: #0f172a;
    display: flex;
    align-items: center;
    gap: 10px;
    position: relative;
    padding-bottom: 10px;
  }

  /* "측정소" 라벨 배지 */
  main h1::before {
    content: '측정소';
    font-size: 11px;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: #1d4ed8;
    background: #e0edff;
    padding: 3px 8px;
    border-radius: 999px;
  }

  /* 아래 파란 라인 */
  main h1::after {
    content: '';
    position: absolute;
    left: 0;
    bottom: 0;
    width: 100%;
    height: 2px;
    background: linear-gradient(90deg, #3b82f6 0%, #93c5fd 60%, transparent 100%);
  }



  .cai-card {
    max-width: 1000px;
    margin: 20px auto 0;
    padding: 18px 24px;
    border-radius: 14px;
    border: 1px solid #e5e7eb;
    background: linear-gradient(135deg, #eff6ff 0%, #ffffff 60%);
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-shadow: 0 8px 20px rgba(37, 99, 235, 0.08);
  }

  .cai-card-left {
    display: flex;
    flex-direction: column;
    gap: 4px;
  }

  .cai-card-title {
    font-size: 18px;
    font-weight: 600;
    color: #1f2937;
  }

  .cai-card-sub {
    font-size: 13px;
    color: #6b7280;
  }

  .cai-card-value {
    font-size: 32px;
    font-weight: 800;
    color: #111827;
  }

  .cai-card-badge {
    margin-left: 8px;
    padding: 4px 10px;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 600;
    background: rgba(255,255,255,0.9);
  }

  .cai-good  { color:#16a34a; }
  .cai-norm  { color:#2563eb; }
  .cai-bad   { color:#ea580c; }
  .cai-vbad  { color:#dc2626; }

    </style>
</head>
<body>
    <!-- 헤더 & 네비 -->
    <header>
      <nav class="nav" aria-label="주요 메뉴">
        <a href="/main" class="brand">대기질 정보</a>
        <div class="nav-right">
          <c:choose>
            <c:when test="${empty sessionScope.loginDisplayName or sessionScope.loginDisplayName == null}">
              <a href="<c:url value='/login'/>">로그인</a>
              <a href="<c:url value='/register'/>">회원가입</a>
              <a href="<c:url value='/admin/login'/>">관리자정보</a>
            </c:when>
            <c:otherwise>
              <c:if test="${sessionScope.isAdmin != true}">
                <a href="<c:url value='/mypage'/>">마이페이지</a>
              </c:if>
              <a href="<c:url value='/logout'/>">로그아웃</a>
              <span class="user-name"><c:out value="${sessionScope.loginDisplayName}"/>님</span>
            </c:otherwise>
          </c:choose>
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
          <a href="/qna" class="nav-qna">QnA</a>
        </div>
      </div>
    </div>
   <div class="container">
    <main>
<!--    	<h1>${stationName}</h1>-->

         <div class="detail-container">
           <div class="detail-header">
             <h1>${stationName} 상세 대기 정보</h1>
             <p>측정 시간: ${Data.dataTime}</p>
           </div>
           
         <c:set var="data" value="${detailData}" />
                 
         <div class="detail-content">

           <div class="detail-item">
             <span class="detail-item-label">미세먼지 (PM10)</span>
             <span class="detail-item-value grade-${data.pm10Grade}">
               <c:choose>
                 <c:when test="${data.pm10Value > 0}">${data.pm10Value} ㎍/m³</c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>
               (<c:choose>
                 <c:when test="${data.pm10Grade == 1}">좋음</c:when>
                 <c:when test="${data.pm10Grade == 2}">보통</c:when>
                 <c:when test="${data.pm10Grade == 3}">나쁨</c:when>
                 <c:when test="${data.pm10Grade == 4}">매우나쁨</c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>)
             </span>
           </div>
                   
           <div class="detail-item">
             <span class="detail-item-label">초미세먼지 (PM2.5)</span>
             <span class="detail-item-value grade-${data.pm25Grade}">
               <c:choose>
                 <c:when test="${data.pm25Value > 0}">${data.pm25Value} ㎍/m³</c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>
               (<c:choose>
                 <c:when test="${data.pm25Grade == 1}">좋음</c:when>
                 <c:when test="${data.pm25Grade == 2}">보통</c:when>
                 <c:when test="${data.pm25Grade == 3}">나쁨</c:when>
                 <c:when test="${data.pm25Grade == 4}">매우나쁨</c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>)
             </span>
           </div>
                   
           <div class="detail-item">
             <span class="detail-item-label">오존 (O₃)</span>
             <span class="detail-item-value grade-${data.o3Grade}">
               <c:choose>
                 <c:when test="${data.o3Value > 0.0}">
                   <fmt:formatNumber value="${data.o3Value}" pattern="0.000" /> ppm
                 </c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>
               (<c:choose>
                 <c:when test="${data.o3Grade == 1}">좋음</c:when>
                 <c:when test="${data.o3Grade == 2}">보통</c:when>
                 <c:when test="${data.o3Grade == 3}">나쁨</c:when>
                 <c:when test="${data.o3Grade == 4}">매우나쁨</c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>)
             </span>
           </div>
                   
           <div class="detail-item">
             <span class="detail-item-label">이산화질소 (NO₂)</span>
             <span class="detail-item-value grade-${data.no2Grade}">
               <c:choose>
                 <c:when test="${data.no2Value > 0.0}">
                   <fmt:formatNumber value="${data.no2Value}" pattern="0.000" /> ppm
                 </c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>
               (<c:choose>
                 <c:when test="${data.no2Grade == 1}">좋음</c:when>
                 <c:when test="${data.no2Grade == 2}">보통</c:when>
                 <c:when test="${data.no2Grade == 3}">나쁨</c:when>
                 <c:when test="${data.no2Grade == 4}">매우나쁨</c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>)
             </span>
           </div>
                   
           <div class="detail-item">
             <span class="detail-item-label">일산화탄소 (CO)</span>
             <span class="detail-item-value">
               <c:choose>
                 <c:when test="${data.coValue > 0.0}">
                   <fmt:formatNumber value="${data.coValue}" pattern="0.000" /> ppm
                 </c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>
             </span>
           </div>
                   
           <div class="detail-item">
             <span class="detail-item-label">아황산가스 (SO₂)</span>
             <span class="detail-item-value">
               <c:choose>
                 <c:when test="${data.so2Value > 0.0}">
                   <fmt:formatNumber value="${data.so2Value}" pattern="0.000" /> ppm
                 </c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>
             </span>
           </div>
                   
           <div class="detail-item">
             <span class="detail-item-label">통합대기환경지수 (CAI/CAI)</span>
             <span class="detail-item-value grade-${data.khaiGrade}">
               <c:choose>
                 <c:when test="${data.khaiValue > 0}">${data.khaiValue}</c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>
               (<c:choose>
                 <c:when test="${data.khaiGrade == 1}">좋음</c:when>
                 <c:when test="${data.khaiGrade == 2}">보통</c:when>
                 <c:when test="${data.khaiGrade == 3}">나쁨</c:when>
                 <c:when test="${data.khaiGrade == 4}">매우나쁨</c:when>
                 <c:otherwise>-</c:otherwise>
               </c:choose>)
             </span>
           </div>
                   
         </div>
         </div>
        
        <div class="detail-content">
          </div>

         <div class="chart-section" style="margin-top: 40px; padding: 20px; background-color: #ffffff !important; border-radius: 8px;">
                      <h2>📊 대기질 농도 시각화</h2>
                      
                      <div style="width: 75%; margin: 20px auto;">
                          <h3>주요 오염 물질 농도 (ppm 또는 ㎍/m³)</h3>
                          <canvas id="airQualityBarChart"></canvas>
                      </div>
                      
                      <div style="width: 75%; margin: 40px auto;"> 
                          <h3>통합 대기질 등급 (1:좋음 ~ 4:매우나쁨)</h3> 
                          <canvas id="airQualityGradeChart"></canvas>
                      </div>
                  </div>

        <div style="margin-top: 20px; text-align: center;">
          <a href="/main" style="padding: 10px 20px; background: #3b82f6; color: white; text-decoration: none; border-radius: 4px;">메인으로 돌아가기</a>
        </div>
       </main>
       
       <footer class="footer">
         </footer>
       <script src="/js/banner.js"></script>
      <script src="/js/banner.js"></script>
          
      <script>   
          // JSTL 변수를 JavaScript로 가져오기
          const dataTime = "${detailData.dataTime}";
          const stationName = "${stationName}";
          const pm10Value = parseFloat("${detailData.pm10Value}");
          const pm25Value = parseFloat("${detailData.pm25Value}");
          const o3Value = parseFloat("${detailData.o3Value}");
          const no2Value = parseFloat("${detailData.no2Value}");
          const coValue = parseFloat("${detailData.coValue}");
          const so2Value = parseFloat("${detailData.so2Value}");
          
          const pm10Grade = parseInt("${detailData.pm10Grade}");
          const pm25Grade = parseInt("${detailData.pm25Grade}");
          const o3Grade = parseInt("${detailData.o3Grade}");
          const no2Grade = parseInt("${detailData.no2Grade}");
          const khaiGrade = parseInt("${detailData.khaiGrade}");

          // 유효하지 않은 숫자 데이터를 0 또는 특정 값으로 처리
          const safePm10 = isNaN(pm10Value) || pm10Value < 0 ? 0 : pm10Value;
          const safePm25 = isNaN(pm25Value) || pm25Value < 0 ? 0 : pm25Value;
          const safeO3 = isNaN(o3Value) || o3Value < 0 ? 0 : o3Value;
          const safeNo2 = isNaN(no2Value) || no2Value < 0 ? 0 : no2Value;
          const safeCo = isNaN(coValue) || coValue < 0 ? 0 : coValue;
          const safeSo2 = isNaN(so2Value) || so2Value < 0 ? 0 : so2Value;

          // 등급 값을 1(좋음) ~ 4(매우나쁨) 척도로 변환. 없는 경우 0 (표시 안 함)
          const getChartGrade = (grade) => {
              return isNaN(grade) || grade === 0 ? 0 : grade; // 0 또는 NaN이면 0으로, 아니면 등급 그대로
          };

          const chartPm10Grade = getChartGrade(pm10Grade);
          const chartPm25Grade = getChartGrade(pm25Grade);
          const chartO3Grade = getChartGrade(o3Grade);
          const chartNo2Grade = getChartGrade(no2Grade);
          const chartKhaiGrade = getChartGrade(khaiGrade);

          // 등급에 따른 색상 정의 함수
          function getGradeColor(grade) {
              switch (grade) {
                  case 1: return 'rgba(34, 197, 94, 0.8)';   // 좋음 (초록)
                  case 2: return 'rgba(59, 130, 246, 0.8)';  // 보통 (파랑)
                  case 3: return 'rgba(234, 179, 8, 0.8)';   // 나쁨 (주황)
                  case 4: return 'rgba(239, 68, 68, 0.8)';   // 매우나쁨 (빨강)
                  default: return 'rgba(150, 150, 150, 0.8)'; // 데이터 없음 (회색)
              }
          }

          // --- 막대 차트 (Bar Chart) 설정 ---
          const barCtx = document.getElementById('airQualityBarChart').getContext('2d');
          new Chart(barCtx, {
              type: 'bar',
              data: {
                  labels: ['미세먼지(PM10)', '초미세먼지(PM2.5)', '오존(O₃)', '이산화질소(NO₂)', '일산화탄소(CO)', '아황산가스(SO₂)'],
                  datasets: [{
                      label: `현재 농도 (${dataTime || '데이터 없음'})`,
                      data: [safePm10, safePm25, safeO3, safeNo2, safeCo, safeSo2],
                      backgroundColor: [
                          getGradeColor(pm10Grade),
                          getGradeColor(pm25Grade),
                          getGradeColor(o3Grade),
                          getGradeColor(no2Grade),
                          'rgba(100, 100, 100, 0.8)', // CO는 등급이 없어 일반 색상
                          'rgba(100, 100, 100, 0.8)'  // SO2도 등급이 없어 일반 색상
                      ],
                      borderColor: [
                          getGradeColor(pm10Grade).replace('0.8', '1'),
                          getGradeColor(pm25Grade).replace('0.8', '1'),
                          getGradeColor(o3Grade).replace('0.8', '1'),
                          getGradeColor(no2Grade).replace('0.8', '1'),
                          'rgba(100, 100, 100, 1)',
                          'rgba(100, 100, 100, 1)'
                      ],
                      borderWidth: 1
                  }]
              },
              options: {
                  responsive: true,
                  plugins: {
                      title: {
                          display: true,
                          text: `${stationName} 주요 대기 오염 물질 농도`,
                          font: { size: 18, weight: 'bold',color: '#000' }
                      },
                      legend: {
                          display: false // 라벨 표시 안 함
                      },
                      tooltip: {
                          callbacks: {
                              label: function(context) {
                                  let label = context.dataset.label || '';
                                  if (label) {
                                      label += ': ';
                                  }
                                  const value = context.parsed.y;
                                  const unit = context.dataIndex < 2 ? '㎍/m³' : 'ppm'; // PM10, PM2.5는 ㎍/m³, 나머지는 ppm
                                  return label + value.toFixed(3) + unit;
                              }
                          }
                      }
                  },
               scales: {
                               y: {
                                   beginAtZero: true,
                                   // 틱(Y축 값) 색상 설정
                                   ticks: {
                                       color: '#333' 
                                   },
                                   title: {
                                       display: true,
                                       text: '농도 (단위: ㎍/m³ 또는 ppm)',
                                       color: '#333' // 축 제목 색상 설정
                                   }
                               },
                               x: {
                                   // 라벨(X축 항목 이름) 색상 설정
                                   ticks: {
                                       color: '#333' 
                                   },
                                   grid: {
                                       display: false
                                   }
                               }
                           }
              }
          });
         // --- ✅ 등급 막대 차트 (airQualityGradeChart) 설정 ---
             const gradeCtx = document.getElementById('airQualityGradeChart').getContext('2d');

             const gradeLabels = ['통합대기질', '미세먼지(PM10)', '초미세먼지(PM2.5)', '오존(O₃)', '이산화질소(NO₂)'];
             const gradeData = [chartKhaiGrade, chartPm10Grade, chartPm25Grade, chartO3Grade, chartNo2Grade];
             
             // 통합 대기질(첫 번째 막대) 색상 강조
             const gradeBackgroundColors = gradeData.map((grade, index) => {
                 if (index === 0) { // 통합 대기질은 강조된 색상 사용
                     return 'rgba(255, 99, 132, 0.9)'; // 빨간색 계열 강조
                 }
                 return getGradeColor(grade); // 개별 항목은 기존 등급 색상 사용
             });

             new Chart(gradeCtx, {
                 type: 'bar',
                 data: {
                     labels: gradeLabels,
                     datasets: [{
                         label: '등급 (1:좋음 ~ 4:매우나쁨)',
                         data: gradeData,
                         backgroundColor: gradeBackgroundColors,
                         borderWidth: 1,
                         borderColor: 'rgba(0, 0, 0, 0.5)'
                     }]
                 },
                 options: {
                     responsive: true,
                     plugins: {
                         title: {
                             display: true,
                             text: `${stationName} 대기질 등급 `,
                             font: { size: 18, weight: 'bold',color: '#000' }
                         },
                         legend: {
                             display: false
                         },
                         tooltip: {
                             callbacks: {
                                 // 등급 숫자 대신 텍스트로 표시
                                 label: function(context) {
                                     const value = context.parsed.y;
                                     let text = '등급: ';
                                     switch(value) {
                                         case 1: text += '좋음'; break;
                                         case 2: text += '보통'; break;
                                         case 3: text += '나쁨'; break;
                                         case 4: text += '매우나쁨'; break;
                                         default: text += '데이터 없음';
                                     }
                                     return text;
                                 }
                             }
                         }
                     },
                  scales: {
                                       y: {
                                           beginAtZero: true,
                                           max: 4, // ✅ Y축 최대값을 4로 고정 (등급 4까지)
                                           ticks: {
                                               color: '#000', // ✅ Y축 틱 색상을 검은색으로 강제 설정
                                               stepSize: 1, // ✅ Y축 단위를 1씩 증가하도록 설정
                                               font: { size: 12 },
                                               callback: function(value) {
                                                   // 틱 값(1, 2, 3, 4)에 따라 등급 텍스트 표시
                                                   switch(value) {
                                                       case 1: return '1.좋음';
                                                       case 2: return '2.보통';
                                                       case 3: return '3.나쁨';
                                                       case 4: return '4.매우나쁨';
                                                       default: return '';
                                                   }
                                               }
                                           },
                                           title: {
                                               display: true,
                                               text: '대기질 등급 (1~4)', 
                                               color: '#000', // ✅ Y축 제목 색상 검은색
                                               font: { size: 14 }
                                           }
                                       },
                                        x: {
                                            // 라벨(X축 항목 이름) 색상 설정
                                            ticks: {
                                                color: '#000', // ✅ X축 틱 색상을 검은색으로 강제 설정
                                                      font: { size: 12 }
                                            },
                                            grid: {
                                                display: false
                                            }
                                        }
                                    }
                 }
             });
          

          </script>
        </body>
        </html>
