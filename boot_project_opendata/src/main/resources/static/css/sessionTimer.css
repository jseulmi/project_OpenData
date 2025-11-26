console.log("sessionTimer.js loaded");

const expireAt = window.sessionExpireAt;
const isLoggedIn = window.isLoggedIn;

if (isLoggedIn && expireAt > 0) {
    function updateSessionTimer() {
        const now = Date.now();
        const diff = expireAt - now;

        if (diff <= 0) {
            window.location.href = "/logout";
            return;
        }

        const min = Math.floor(diff / 1000 / 60);
        const sec = Math.floor((diff / 1000) % 60);

        const timer = document.getElementById("session-timer");
        if (timer) timer.textContent = `${min}:${sec < 10 ? "0"+sec : sec}`;
    }

    updateSessionTimer();
    setInterval(updateSessionTimer, 1000);
}
