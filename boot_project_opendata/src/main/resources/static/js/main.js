// main.js

window.addEventListener('DOMContentLoaded', function() {
  initChatbot();
  initMap();
  initControls();
  initEvents();
});

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

// 간단 toast 메시지
function toast(t) {
  const m = document.getElementById('msg');
  m.textContent = t;
  m.style.display = 'block';
  setTimeout(() => m.style.display = 'none', 2500);
}

// 로딩 표시 토글
function showLoading(b) {
  document.getElementById('loading').style.display = b ? 'block' : 'none';
}

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

// 타이핑 표시 제거
function hideTyping() {
  const typing = document.getElementById("typing-indicator");
  if (typing) typing.remove();
}

// 로그인 상태 JSP에서 처리된 문자열로 받음
const isLoggedIn = "${not empty sessionScope.loginId}";
