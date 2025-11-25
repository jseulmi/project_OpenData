// 댓글 관련 전역 변수
let currentBoardNo = null;
let currentNoticeNo = null;
let loginId = null;
let isAdmin = false;
let apiBaseUrl = '';
let currentPage = 1;
let totalPages = 1;
let pageSize = 10;

// 댓글 시스템 초기화 (게시판용)
function initBoardComment(boardNo, userId, admin) {
  currentBoardNo = boardNo;
  currentNoticeNo = null;
  loginId = userId;
  isAdmin = admin;
  apiBaseUrl = '/api/board/comments';
  currentPage = 1;
  loadComments(1, false); // 초기 진입 시 스크롤 없음
}

// 댓글 시스템 초기화 (공지사항용)
function initNoticeComment(noticeNo, userId, admin) {
  currentBoardNo = null;
  currentNoticeNo = noticeNo;
  loginId = userId;
  isAdmin = admin;
  apiBaseUrl = '/api/notice/comments';
  currentPage = 1;
  loadComments(1, false); // 초기 진입 시 스크롤 없음
}

// 댓글 목록 로드 (페이징)
function loadComments(page, shouldScroll = true) {
  if (page < 1) page = 1;
  currentPage = page;
  
  const targetNo = currentBoardNo || currentNoticeNo;
  const paramName = currentBoardNo ? 'boardNo' : 'noticeNo';
  
  fetch(`${apiBaseUrl}?${paramName}=${targetNo}&page=${page}&size=${pageSize}`)
    .then(response => response.json())
    .then(data => {
      console.log('댓글 데이터:', data); // 디버깅용
      
      if (data.success) {
        // 원댓글과 답글을 함께 가져오기
        const allComments = [];
        
        if (data.comments && data.comments.length > 0) {
          data.comments.forEach(item => {
            if (item.parent) {
              allComments.push(item.parent);
            }
            if (item.replies && item.replies.length > 0) {
              allComments.push(...item.replies);
            }
          });
        }
        
        const organizedComments = organizeComments(allComments);
        displayComments(organizedComments);
        
        const totalCount = data.totalCount || 0;
        updateCommentCount(totalCount);
        
        const totalPagesNum = data.totalPages || page;
        const currentPageNum = data.currentPage || page;
        
        console.log('페이징 정보:', { 
          currentPage: currentPageNum, 
          totalPages: totalPagesNum, 
          totalCount: totalCount,
          표시된댓글: organizedComments.length 
        });
        
        if (totalCount > pageSize && totalPagesNum > 1) {
          updatePagination(currentPageNum, totalPagesNum);
        } else {
          const paginationDiv = document.getElementById('commentPagination');
          if (paginationDiv) {
            paginationDiv.remove();
          }
        }
        
        // 2페이지 이상 + shouldScroll true일 때만 스크롤
        if (shouldScroll && page > 1) {
          setTimeout(() => {
            scrollToCommentSection();
          }, 100);
        }
      } else {
        updateCommentCount(0);
        const commentList = document.getElementById('commentList');
        if (commentList) {
          commentList.innerHTML = '<p class="comment-empty">댓글이 없습니다.</p>';
        }
        const paginationDiv = document.getElementById('commentPagination');
        if (paginationDiv) {
          paginationDiv.remove();
        }
      }
    })
    .catch(error => {
      console.error('Error:', error);
      showError('댓글을 불러오는데 실패했습니다.');
      updateCommentCount(0);
    });
}

// 댓글 섹션 상단으로 스크롤
function scrollToCommentSection() {
  const commentSection = document.querySelector('.comment-section');
  const commentHeader = document.getElementById('commentHeader');
  const commentCount = document.getElementById('commentCount');
  const commentList = document.getElementById('commentList');
  
  const target =
    commentSection ||
    commentHeader ||
    commentCount ||
    commentList;
  
  if (target) {
    window.scrollTo({
      top: target.offsetTop - 20,
      behavior: 'smooth'
    });
  }
}

// 댓글을 부모-자식 관계로 재구성 (최신순 - comment_no 기준)
function organizeComments(comments) {
  const commentMap = new Map();
  comments.forEach(comment => {
    commentMap.set(comment.commentNo, comment);
  });
  
  const result = [];
  const processed = new Set();
  
  const sortedComments = [...comments].sort((a, b) => {
    return (b.commentNo || 0) - (a.commentNo || 0);
  });
  
  sortedComments.forEach(comment => {
    if (processed.has(comment.commentNo)) return;
    
    if (!comment.parentCommentNo) {
      result.push(comment);
      processed.add(comment.commentNo);
      addReplies(comment.commentNo, result, commentMap, processed, sortedComments);
    }
  });
  
  return result;
}

// 재귀적으로 답글 추가
function addReplies(parentNo, result, commentMap, processed, sortedComments) {
  const directReplies = sortedComments
    .filter(c => c.parentCommentNo === parentNo && !processed.has(c.commentNo))
    .sort((a, b) => (b.commentNo || 0) - (a.commentNo || 0));
  
  directReplies.forEach(reply => {
    result.push(reply);
    processed.add(reply.commentNo);
    addReplies(reply.commentNo, result, commentMap, processed, sortedComments);
  });
}

// 댓글 표시
function displayComments(comments) {
  const commentList = document.getElementById('commentList');
  if (!commentList) return;
  
  commentList.innerHTML = '';
  
  if (comments.length === 0) {
    commentList.innerHTML = '<p class="comment-empty">댓글이 없습니다.</p>';
    return;
  }
  
  const commentBox = document.createElement('div');
  commentBox.className = 'comment-box';
  
  const commentGroups = [];
  let currentGroup = null;
  
  comments.forEach(comment => {
    if (!comment.parentCommentNo) {
      currentGroup = { parent: comment, replies: [] };
      commentGroups.push(currentGroup);
    } else if (currentGroup) {
      currentGroup.replies.push(comment);
    }
  });
  
  function isNestedReply(comment, allComments) {
    if (!comment.parentCommentNo) return false;
    const parent = allComments.find(c => c.commentNo === comment.parentCommentNo);
    return parent && parent.parentCommentNo !== null;
  }
  
  commentGroups.forEach((group, index) => {
    const parentDiv = createCommentElement(group.parent, comments, false);
    commentBox.appendChild(parentDiv);
    
    if (group.replies.length > 0) {
      const repliesContainer = document.createElement('div');
      repliesContainer.className = 'comment-replies';
      
      group.replies.forEach(reply => {
        const isNested = isNestedReply(reply, comments);
        const replyDiv = createCommentElement(reply, comments, isNested);
        repliesContainer.appendChild(replyDiv);
      });
      
      parentDiv.appendChild(repliesContainer);
    }
    
    if (index < commentGroups.length - 1) {
      const separator = document.createElement('div');
      separator.style.height = '1px';
      separator.style.background = '#f0f0f0';
      separator.style.margin = '20px 0';
      commentBox.appendChild(separator);
    }
  });
  
  commentList.appendChild(commentBox);
}

// 댓글 요소 생성
function createCommentElement(comment, allComments, isNested) {
  const isReply = comment.parentCommentNo != null;
  const isOwner = loginId === comment.userId;
  
  const commentDiv = document.createElement('div');
  let className = 'comment-item';
  if (isReply) {
    className += ' reply';
    if (isNested) {
      className += ' reply-nested';
    }
  }
  commentDiv.className = className;
  commentDiv.id = `comment-${comment.commentNo}`;
  
  commentDiv.innerHTML = `
    <div class="comment-header-info">
      <div>
        <span class="comment-author">${escapeHtml(comment.userNickname || comment.userId)}</span>
        <span class="comment-date">${comment.formattedDate || comment.commentDate || ''}</span>
      </div>
    </div>
    <div class="comment-content" id="content-${comment.commentNo}">${escapeHtml(comment.commentContent)}</div>
    <div class="comment-edit-form" id="edit-form-${comment.commentNo}">
      <textarea id="edit-content-${comment.commentNo}">${escapeHtml(comment.commentContent)}</textarea>
      <div class="comment-edit-actions">
        <button type="button" onclick="saveEdit(${comment.commentNo})">저장</button>
        <button type="button" onclick="cancelEdit(${comment.commentNo})">취소</button>
      </div>
    </div>
    <div class="comment-actions">
      ${loginId ? `<button type="button" class="btn-reply" onclick="showReplyForm(${comment.commentNo})">답글</button>` : ''}
      ${isOwner || isAdmin ? `
        <button type="button" class="btn-edit" onclick="showEditForm(${comment.commentNo})">수정</button>
        <button type="button" class="btn-delete" onclick="deleteComment(${comment.commentNo})">삭제</button>
      ` : ''}
    </div>
    <div class="reply-form" id="reply-form-${comment.commentNo}">
      <textarea id="reply-content-${comment.commentNo}" placeholder="답글을 입력하세요..."></textarea>
      <div class="reply-form-actions">
        <button type="button" onclick="writeReply(${comment.commentNo})">답글 작성</button>
        <button type="button" onclick="cancelReply(${comment.commentNo})">취소</button>
      </div>
    </div>
  `;
  
  return commentDiv;
}

// 댓글 개수 업데이트
function updateCommentCount(count) {
  const countElement = document.getElementById('commentCount');
  if (countElement) {
    countElement.textContent = `댓글 ${count}개`;
  }
}

// 페이징 UI 업데이트
function updatePagination(currentPageNum, totalPagesNum) {
  console.log('updatePagination 호출:', { currentPageNum, totalPagesNum });
  
  let paginationDiv = document.getElementById('commentPagination');
  if (paginationDiv) {
    paginationDiv.remove();
  }
  
  if (!totalPagesNum || totalPagesNum <= 1) {
    return;
  }
  
  paginationDiv = document.createElement('div');
  paginationDiv.id = 'commentPagination';
  paginationDiv.className = 'comment-pagination';
  
  const commentList = document.getElementById('commentList');
  const writeContainer = commentList ? commentList.closest('.write-container') : null;
  
  if (writeContainer) {
    writeContainer.appendChild(paginationDiv);
  } else if (commentList && commentList.parentNode) {
    commentList.parentNode.insertBefore(paginationDiv, commentList.nextSibling);
  } else {
    console.error('페이징을 삽입할 위치를 찾을 수 없습니다.');
    return;
  }
  
  let html = '';
  
  if (currentPageNum > 1) {
    html += `<a href="#" onclick="event.preventDefault(); loadComments(${currentPageNum - 1}); return false;" class="page-link">‹</a>`;
  }
  
  for (let i = 1; i <= totalPagesNum; i++) {
    if (i === currentPageNum) {
      html += `<span class="page-link active">${i}</span>`;
    } else {
      html += `<a href="#" onclick="event.preventDefault(); loadComments(${i}); return false;" class="page-link">${i}</a>`;
    }
  }
  
  if (currentPageNum < totalPagesNum) {
    html += `<a href="#" onclick="event.preventDefault(); loadComments(${currentPageNum + 1}); return false;" class="page-link">›</a>`;
  }
  
  paginationDiv.innerHTML = html;
  console.log('페이징 HTML 생성 완료:', html);
}

// 댓글 작성
function writeComment() {
  const content = document.getElementById('commentContent').value.trim();
  
  if (!content) {
    alert('댓글 내용을 입력하세요.');
    return;
  }
  
  if (!confirm('댓글을 작성하시겠습니까?')) {
    return;
  }
  
  const targetNo = currentBoardNo || currentNoticeNo;
  const body = currentBoardNo 
    ? { boardNo: targetNo, commentContent: content, parentCommentNo: null }
    : { noticeNo: targetNo, commentContent: content, parentCommentNo: null };
  
  fetch(apiBaseUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(body)
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      document.getElementById('commentContent').value = '';
      document.getElementById('commentForm').style.display = 'none';
      loadComments(1, false); // 작성 후 1페이지로 이동하되 스크롤 없음
    } else {
      handleApiError(data);
    }
  })
  .catch(error => {
    console.error('Error:', error);
    showError('댓글 작성에 실패했습니다.');
  });
}

// 답글 작성
function writeReply(parentCommentNo) {
  const content = document.getElementById('reply-content-' + parentCommentNo).value.trim();
  
  if (!content) {
    alert('답글 내용을 입력하세요.');
    return;
  }
  
  if (!confirm('답글을 작성하시겠습니까?')) {
    return;
  }
  
  const targetNo = currentBoardNo || currentNoticeNo;
  const body = currentBoardNo 
    ? { boardNo: targetNo, commentContent: content, parentCommentNo: parentCommentNo }
    : { noticeNo: targetNo, commentContent: content, parentCommentNo: parentCommentNo };
  
  fetch(apiBaseUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(body)
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      cancelReply(parentCommentNo);
      loadComments(currentPage); // 현재 페이지 유지, shouldScroll 기본 true
    } else {
      handleApiError(data);
    }
  })
  .catch(error => {
    console.error('Error:', error);
    showError('답글 작성에 실패했습니다.');
  });
}

// 수정 폼 보이기
function showEditForm(commentNo) {
  document.getElementById('content-' + commentNo).style.display = 'none';
  document.getElementById('edit-form-' + commentNo).style.display = 'block';
}

// 수정 취소
function cancelEdit(commentNo) {
  document.getElementById('content-' + commentNo).style.display = 'block';
  document.getElementById('edit-form-' + commentNo).style.display = 'none';
}

// 댓글 수정 저장
function saveEdit(commentNo) {
  const content = document.getElementById('edit-content-' + commentNo).value.trim();
  
  if (!content) {
    alert('댓글 내용을 입력하세요.');
    return;
  }
  
  fetch(`${apiBaseUrl}/${commentNo}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ commentContent: content })
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      loadComments(currentPage);
    } else {
      showError(data.error || '댓글 수정에 실패했습니다.');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    showError('댓글 수정에 실패했습니다.');
  });
}

// 댓글 삭제
function deleteComment(commentNo) {
  if (!confirm('댓글을 삭제하시겠습니까?')) {
    return;
  }
  
  fetch(`${apiBaseUrl}/${commentNo}`, { method: 'DELETE' })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      loadComments(currentPage);
    } else {
      showError(data.error || '댓글 삭제에 실패했습니다.');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    showError('댓글 삭제에 실패했습니다.');
  });
}

// 답글 폼 보이기
function showReplyForm(commentNo) {
  const form = document.getElementById('reply-form-' + commentNo);
  if (form) form.style.display = 'block';
}

// 답글 취소
function cancelReply(commentNo) {
  const form = document.getElementById('reply-form-' + commentNo);
  const textarea = document.getElementById('reply-content-' + commentNo);
  if (form) form.style.display = 'none';
  if (textarea) textarea.value = '';
}

// HTML 이스케이프
function escapeHtml(text) {
  if (!text) return '';
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// 에러 처리
function handleApiError(data) {
  if (data.error === '로그인이 필요합니다.') {
    alert('로그인이 필요합니다.');
    location.href = '/login';
  } else {
    showError(data.error || '작업에 실패했습니다.');
  }
}

// 에러 메시지 표시
function showError(message) {
  alert(message);
}
