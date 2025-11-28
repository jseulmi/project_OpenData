<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>회원 탈퇴 - 대기질 정보</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <style>
    :root{
      --brand: #2c5f8d;
      --danger: #dc3545;
      --danger-dark: #c82333;
    }
    *{box-sizing:border-box; margin:0; padding:0;}
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background: #f8f9fa;
      line-height: 1.5;
    }
    
    header{ 
      background:#fff; 
      border-bottom:1px solid #eee; 
      padding: 14px 20px;
    }
    .nav{
      max-width:1100px; 
      margin:0 auto;
      display:flex; 
      align-items:center; 
      justify-content:space-between;
    }
    .brand{
      font-weight:800; 
      color:var(--brand); 
      text-decoration:none;
      font-size: 20px;
    }
    .nav-right{ 
      display:flex; 
      gap:18px; 
      font-size:.95rem; 
    }
    .nav-right a{ 
      color:#333; 
      text-decoration:none; 
    }

    .withdraw-section {
      padding: 60px 20px;
      min-height: calc(100vh - 200px);
    }
    .withdraw-container {
      max-width: 700px;
      margin: 0 auto;
    }
    .withdraw-card {
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 10px 30px rgba(0,0,0,.08);
      padding: 50px;
    }
    .withdraw-title {
      font-size: 36px;
      font-weight: 700;
      color: var(--danger);
      margin: 0 0 20px;
      text-align: center;
    }
    .warning-box {
      background: #fff3cd;
      border: 2px solid #ffc107;
      border-radius: 10px;
      padding: 20px;
      margin: 30px 0;
    }
    .warning-box h3 {
      color: #856404;
      margin: 0 0 15px;
      font-size: 18px;
      font-weight: 600;
    }
    .warning-box ul {
      margin: 0;
      padding-left: 20px;
      color: #856404;
      line-height: 1.8;
    }
    .warning-box li {
      margin-bottom: 8px;
    }
    .error-message {
      background: #f8d7da;
      color: #721c24;
      padding: 12px 16px;
      border-radius: 8px;
      margin-bottom: 20px;
      text-align: center;
      border: 1px solid #f5c6cb;
    }
    .form-group {
      margin-bottom: 24px;
    }
    .form-label {
      display: block;
      font-size: 15px;
      font-weight: 600;
      color: #1c1c1c;
      margin-bottom: 10px;
    }
    .form-input {
      width: 100%;
      padding: 14px 16px;
      border: 1px solid #ddd;
      border-radius: 10px;
      font-size: 15px;
      font-family: 'Noto Sans KR', sans-serif;
    }
    .form-input:focus {
      outline: none;
      border-color: var(--danger);
      box-shadow: 0 0 0 3px rgba(220,53,69,.1);
    }
    .btn-group {
      display: flex;
      justify-content: center;
      gap: 12px;
      margin-top: 40px;
      padding-top: 30px;
      border-top: 1px solid #eee;
    }
    .btn {
      padding: 14px 32px;
      border: none;
      border-radius: 10px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all .3s ease;
      text-decoration: none;
      display: inline-block;
      font-family: 'Noto Sans KR', sans-serif;
    }
    .btn-danger {
      background: var(--danger);
      color: #fff;
    }
    .btn-danger:hover {
      background: var(--danger-dark);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(220,53,69,.3);
    }
    .btn-secondary {
      background: #f5f5f5;
      color: #1c1c1c;
    }
    .btn-secondary:hover {
      background: #e8e8e8;
    }

    @media (max-width: 768px){
      .withdraw-card{ padding: 30px 20px; }
      .btn-group{ flex-direction: column; }
      .btn{ width: 100%; }
    }
  </style>
</head>
<body>
  <header>
    <nav class="nav">
      <a href="/main" class="brand">대기질 정보</a>
      <div class="nav-right">
        <c:if test="${not empty sessionScope.loginDisplayName}">
          <a href="<c:url value='/mypage'/>">마이페이지</a>
          <a href="<c:url value='/logout'/>">로그아웃</a>
        </c:if>
      </div>
    </nav>
  </header>

  <section class="withdraw-section">
    <div class="withdraw-container">
      <div class="withdraw-card">
        <h1 class="withdraw-title">회원 탈퇴</h1>

        <div class="warning-box">
          <h3>⚠️ 회원 탈퇴 전 주의사항</h3>
          <ul>
            <li>탈퇴 시 모든 회원 정보가 삭제됩니다.</li>
            <li>작성한 게시글과 댓글은 삭제되지 않습니다.</li>
            <li>관심 지역 설정 정보가 모두 삭제됩니다.</li>
            <li>탈퇴 후 동일한 아이디로 재가입이 불가능할 수 있습니다.</li>
            <li>탈퇴 처리는 즉시 완료되며 복구할 수 없습니다.</li>
          </ul>
        </div>

        <!-- 에러 메시지 -->
        <c:if test="${not empty error}">
          <div class="error-message">${error}</div>
        </c:if>

        <!-- 🔥 소셜 로그인 판단: LOCAL이 아닐 때만 true -->
        <c:set var="isSocial" value="${user.login_type ne 'LOCAL'}" />

        <form method="post" action="/mypage/withdraw" onsubmit="return confirmWithdraw()">

          <c:choose>
            <c:when test="${isSocial}">
              <div class="info-box" style="margin-bottom:20px;">
                <p>소셜 로그인 회원은 비밀번호 입력 없이 즉시 탈퇴할 수 있습니다.</p>
              </div>
            </c:when>

            <c:otherwise>
              <div class="form-group">
                <label class="form-label">비밀번호 확인</label>
                <input type="password"
                       name="user_pw"
                       class="form-input"
                       placeholder="본인 확인을 위해 비밀번호를 입력하세요"
                       required>
              </div>
            </c:otherwise>
          </c:choose>

          <div class="btn-group">
            <button type="submit" class="btn btn-danger">탈퇴하기</button>
            <a href="/mypage" class="btn btn-secondary">취소</a>
          </div>

        </form>

      </div>
    </div>
  </section>

  <script>
    function confirmWithdraw() {
      return confirm('정말로 탈퇴하시겠습니까?\n\n탈퇴 후에는 복구할 수 없습니다.');
    }
  </script>
</body>
</html>
