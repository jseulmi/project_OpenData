// /js/sessionTimer.js

(function () {
  // 🔹 전역에 이미 설정해둔 값 사용
  const expireAt = Number(window.sessionExpireAt || 0);
  const loggedIn = !!window.isLoggedIn; // true / false로 강제 변환

  // 로그인 안 되어 있거나, 만료 시간이 없으면 아무것도 안 함
  if (!loggedIn || !expireAt) {
    return;
  }

  function startSessionTimer() {
    const el = document.getElementById('session-timer');
    if (!el) return; // span 없으면 그냥 종료

    function update() {
      const diff = expireAt - Date.now();

      if (diff <= 0) {
        el.textContent = '세션 만료';
        alert('로그인 시간이 만료되었습니다. 다시 로그인해주세요.');
        // 서버 로그아웃 호출
        window.location.href = '/logout';
        return;
      }

      const min = Math.floor(diff / 60000);
      const sec = Math.floor((diff % 60000) / 1000);

      el.textContent =
        '남은 시간: ' +
        min +
        ':' +
        (sec < 10 ? '0' + sec : sec);
    }

    // 즉시 한 번 업데이트하고
    update();
    // 1초마다 갱신
    setInterval(update, 1000);
  }

  // DOM이 준비된 뒤에만 실행
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', startSessionTimer);
  } else {
    startSessionTimer();
  }
})();
