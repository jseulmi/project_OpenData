<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>문의 상세</title>
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background: rgb(224, 228, 233);
      margin: 0;
      padding: 0;
    }

    .container {
      width: 90%;
      margin: 70px auto;
      background: #ffffff;
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.18);
    }

    h2 {
      font-size: 30px;
      font-weight: 700;
      color: #3e2c1c;
      margin-bottom: 30px;
    }

    .detail-container {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
      margin-bottom: 30px;
    }

    .inquiry-section,
    .reply-section {
      background: #ffffff;
      padding: 24px;
      border-radius: 12px;
      border: 1px solid #2c5f8d;
    }

    .section-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      padding-bottom: 16px;
      border-bottom: 1px solid #2c5f8d;
    }

    .section-header h3 {
      font-size: 18px;
      font-weight: 600;
      color: #3e2c1c;
      margin: 0;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 5px 14px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
    }

    .status-waiting {
      background-color: #fef3c7;
      color: #92400e;
    }

    .status-completed {
      background-color: #d1fae5;
      color: #065f46;
    }

    .inquiry-meta {
      display: flex;
      flex-direction: column;
      gap: 8px;
      margin-bottom: 20px;
      color: #6b7280;
      font-size: 14px;
    }

    .inquiry-title {
      font-size: 20px;
      font-weight: 600;
      color: #3e2c1c;
      margin-bottom: 16px;
    }

    .inquiry-content {
      color: #4b3b2a;
      line-height: 1.8;
      white-space: pre-wrap;
      word-wrap: break-word;
      padding: 16px;
      background: #f8f9fa;
      border-radius: 8px;
      border: 1px solid #2c5f8d;
    }

    .existing-reply {
      background: #f0fdf4;
      border: 1px solid #bbf7d0;
      padding: 16px;
      border-radius: 8px;
      margin-bottom: 20px;
    }

    .existing-reply-content {
      color: #065f46;
      line-height: 1.8;
      white-space: pre-wrap;
      word-wrap: break-word;
      margin-bottom: 12px;
    }

    .existing-reply-meta {
      color: #047857;
      font-size: 13px;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      color: #4b3b2a;
      font-size: 15px;
    }

    .form-group textarea {
      width: 100%;
      padding: 14px 12px;
      border: 1px solid #2c5f8d;
      border-radius: 8px;
      background: #f8f9fa;
      font-size: 15px;
      font-family: 'Noto Sans KR', sans-serif;
      color: #4b3b2a;
      min-height: 150px;
      resize: vertical;
      box-sizing: border-box;
      outline: none;
      transition: 0.2s;
    }

    .form-group textarea:focus {
      border-color: rgb(156, 192, 224);
      background: #fff;
      box-shadow: 0 0 0 2px rgba(138, 107, 82, 0.2);
    }

    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      margin-top: 30px;
    }

    .btn {
      padding: 12px 26px;
      border: none;
      border-radius: 8px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      transition: 0.2s;
    }

    .btn-primary {
      background: #2c5f8d;
      color: white;
    }

    .btn-primary:hover {
      background: #1e4261;
    }

    .btn-back {
      background: #686868;
      color: white;
    }

    .btn-back:hover {
      background: rgb(76, 76, 76);
    }

    .msg-alert {
      padding: 12px 16px;
      margin-bottom: 20px;
      border-radius: 8px;
      background-color: #d1fae5;
      color: #065f46;
      border: 1px solid #a7f3d0;
    }

    .header-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header-actions">
      <h2>문의 상세</h2>
	  <button onclick="window.location.href='/admin/inquiryManagement'" class="btn btn-back">목록으로</button>
    </div>

    <c:if test="${not empty msg}">
      <div class="msg-alert">${msg}</div>
    </c:if>

    <div class="detail-container">
      <div class="inquiry-section">
        <div class="section-header">
          <h3>고객 문의</h3>
          <span class="status-badge ${inquiry.status == '답변완료' ? 'status-completed' : 'status-waiting'}">
            ${inquiry.status}
          </span>
        </div>
        
        <div class="inquiry-meta">
          <span><strong>작성자:</strong> ${inquiry.user_name} (${inquiry.user_id})</span>
          <span><strong>작성일:</strong> <fmt:formatDate value="${inquiry.created_date}" pattern="yyyy-MM-dd HH:mm" /></span>
        </div>

        <div class="inquiry-title">${inquiry.title}</div>
        <div class="inquiry-content">${inquiry.content}</div>
      </div>

      <div class="reply-section">
        <div class="section-header">
          <h3>답변 작성</h3>
        </div>

        <c:if test="${not empty inquiry.reply and not empty inquiry.reply.reply_content}">
          <div class="existing-reply" id="existingReplyBox">
            <div class="existing-reply-content" id="existingReplyContent">${inquiry.reply.reply_content}</div>
            <div class="existing-reply-meta">
              답변일: <fmt:formatDate value="${inquiry.reply.created_date}" pattern="yyyy-MM-dd HH:mm" />
            </div>
          </div>
        </c:if>

        <form id="replyForm" class="reply-form">
          <input type="hidden" name="inquiry_id" value="${inquiry.inquiry_id}">
          
          <div class="form-group">
            <label for="reply_content">답변 내용 *</label>
            <textarea id="reply_content" name="reply_content" required 
                      placeholder="고객 문의에 대한 답변을 작성해주세요."><c:if test="${not empty inquiry.reply and not empty inquiry.reply.reply_content}">${inquiry.reply.reply_content}</c:if></textarea>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn btn-primary" id="submitBtn">
              <c:choose>
                <c:when test="${not empty inquiry.reply and not empty inquiry.reply.reply_content}">답변 수정</c:when>
                <c:otherwise>답변 등록</c:otherwise>
              </c:choose>
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
	(function() {
	  function initReplyForm() {
	    const form = document.getElementById('replyForm');
	    if (!form) {
	      console.error('replyForm을 찾을 수 없습니다.');
	      return;
	    }

	    if (form._replyFormHandler) {
	      form.removeEventListener('submit', form._replyFormHandler);
	    }

	    form._replyFormHandler = function(e) {
	      e.preventDefault();
	      e.stopPropagation();
	      e.stopImmediatePropagation();

	      const formData = new FormData(this);
	      const inquiryId = formData.get('inquiry_id');
	      const replyContent = formData.get('reply_content');

	      if (!replyContent || replyContent.trim() === '') {
	        alert('답변 내용을 입력해주세요.');
	        return false;
	      }

		  fetch('/admin/reply', {
		    method: 'POST',
		    body: formData,
			credentials: 'include' // 이 옵션을 추가해 세션 쿠키 전달 보장
		  })
		  .then(res => {
		    if (!res.ok) {
		      throw new Error('HTTP error! status: ' + res.status);
		    }
		    return res.text();
		  })
		  .then(result => {
		    if (result.trim() === 'SUCCESS') {
		      alert('답변이 등록되었습니다.');
		      if (typeof loadPage === 'function') {
		        loadPage('/admin/inquiryManagement?t=' + new Date().getTime());
		      } else {
		        window.location.href = '/admin/inquiryManagement';
		      }
		    } else {
		      alert('답변 등록에 실패했습니다. 응답: ' + result);
		    }
		  })
		  .catch(err => {
		    console.error('에러:', err);
		    alert('오류가 발생했습니다: ' + err.message);
		  });

	      return false;
	    };

	    form.addEventListener('submit', form._replyFormHandler);
	  }

	  initReplyForm();
	  setTimeout(initReplyForm, 100);
	  setTimeout(initReplyForm, 500);
	})();
  </script>
</body>
</html>
