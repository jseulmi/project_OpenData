package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.boot.dto.NoticeCommentDTO;
import com.boot.service.NoticeCommentService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/notice/comments")
@RequiredArgsConstructor
@Slf4j
public class NoticeCommentRestController {

    private final NoticeCommentService commentService;

    /**
     * ✅ 댓글 목록 조회 (전체 댓글 기준 페이징)
     * GET /api/notice/comments?noticeNo=123&page=1&size=10
     */
    @GetMapping
    public ResponseEntity<?> getComments(
            @RequestParam("noticeNo") Long noticeNo,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        try {
            // 전체 댓글 개수 (삭제되지 않은 댓글만)
            int totalCount = commentService.getCommentCount(noticeNo);
            
            // 전체 페이지 수 계산 (올림 처리)
            int totalPages = totalCount > 0 ? (int) Math.ceil((double) totalCount / size) : 1;
            
            // 전체 댓글 목록 조회 (페이징, 최신순)
            List<NoticeCommentDTO> allComments = commentService.getAllCommentsByNoticeNo(noticeNo, page, size);
            
            // 선택된 댓글들의 부모 원댓글 번호 수집
            Set<Long> parentCommentNos = new HashSet<>();
            for (NoticeCommentDTO comment : allComments) {
                if (comment.getParentCommentNo() != null) {
                    // 답글인 경우 부모 원댓글 번호 찾기
                    Long parentNo = findRootParent(comment.getParentCommentNo(), allComments);
                    if (parentNo != null) {
                        parentCommentNos.add(parentNo);
                    }
                } else {
                    // 원댓글인 경우
                    parentCommentNos.add(comment.getCommentNo());
                }
            }
            
            // 부모 원댓글들의 모든 답글 포함하여 반환
            List<Map<String, Object>> commentsWithReplies = new ArrayList<>();
            for (Long parentNo : parentCommentNos) {
                NoticeCommentDTO parent = commentService.find(parentNo);
                if (parent != null && parent.getNoticeNo().equals(noticeNo) && !"Y".equals(parent.getIsDeleted())) {
                    Map<String, Object> commentData = new HashMap<>();
                    commentData.put("parent", parent);
                    
                    // 답글들 조회
                    List<NoticeCommentDTO> replies = commentService.getRepliesByParentNo(parentNo);
                    commentData.put("replies", replies);
                    
                    commentsWithReplies.add(commentData);
                }
            }
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "comments", commentsWithReplies,
                "totalCount", totalCount,
                "currentPage", page,
                "totalPages", totalPages,
                "size", size
            ));
        } catch (Exception e) {
            log.error("댓글 목록 조회 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "error", "댓글 목록을 불러오는데 실패했습니다."
            ));
        }
    }
    
    /**
     * 재귀적으로 최상위 부모 댓글 번호 찾기
     */
    private Long findRootParent(Long commentNo, List<NoticeCommentDTO> comments) {
        NoticeCommentDTO comment = comments.stream()
            .filter(c -> c.getCommentNo().equals(commentNo))
            .findFirst()
            .orElse(null);
        
        if (comment == null) {
            // DB에서 직접 조회
            comment = commentService.find(commentNo);
            if (comment == null) {
                return null;
            }
        }
        
        if (comment.getParentCommentNo() == null) {
            return comment.getCommentNo();
        }
        
        return findRootParent(comment.getParentCommentNo(), comments);
    }

    /**
     * ✅ 답글 조회 (개별 엔드포인트)
     * GET /api/notice/comments/replies/{parentCommentNo}
     */
    @GetMapping("/replies/{parentCommentNo}")
    public ResponseEntity<?> getReplies(@PathVariable Long parentCommentNo) {
        try {
            List<NoticeCommentDTO> replies = commentService.getRepliesByParentNo(parentCommentNo);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "replies", replies
            ));
        } catch (Exception e) {
            log.error("답글 조회 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "error", "답글을 불러오는데 실패했습니다.",
                "replies", new ArrayList<>()
            ));
        }
    }

    /**
     * ✅ 댓글 작성
     * POST /api/notice/comments
     * Body: { "noticeNo": 123, "commentContent": "댓글 내용", "parentCommentNo": null }
     */
    @PostMapping
    public ResponseEntity<?> writeComment(@RequestBody NoticeCommentDTO dto, HttpSession session) {
        try {
            String userId = (String) session.getAttribute("loginId");
            
            // 로그인 체크
            if (userId == null || userId.isBlank()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                    "success", false,
                    "error", "로그인이 필요합니다."
                ));
            }

            // 작성자 설정
            dto.setUserId(userId);
            
            // 댓글 작성
            Long commentNo = commentService.write(dto);
            
            // 작성된 댓글 조회 (닉네임 포함)
            NoticeCommentDTO savedComment = commentService.find(commentNo);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "댓글이 작성되었습니다.",
                "comment", savedComment
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of(
                "success", false,
                "error", e.getMessage()
            ));
        } catch (Exception e) {
            log.error("댓글 작성 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "error", "댓글 작성에 실패했습니다."
            ));
        }
    }

    /**
     * ✅ 댓글 수정
     * PUT /api/notice/comments/{commentNo}
     * Body: { "commentContent": "수정된 댓글 내용" }
     */
    @PutMapping("/{commentNo}")
    public ResponseEntity<?> updateComment(
            @PathVariable Long commentNo,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        try {
            String userId = (String) session.getAttribute("loginId");
            
            // 로그인 체크
            if (userId == null || userId.isBlank()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                    "success", false,
                    "error", "로그인이 필요합니다."
                ));
            }

            // 작성자 확인
            String commentUserId = commentService.getUserIdByCommentNo(commentNo);
            if (commentUserId == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                    "success", false,
                    "error", "댓글을 찾을 수 없습니다."
                ));
            }

            if (!userId.equals(commentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "error", "댓글 수정 권한이 없습니다."
                ));
            }

            // 댓글 수정
            NoticeCommentDTO dto = new NoticeCommentDTO();
            dto.setCommentNo(commentNo);
            dto.setCommentContent(body.get("commentContent"));
            commentService.update(dto);
            
            // 수정된 댓글 조회
            NoticeCommentDTO updatedComment = commentService.find(commentNo);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "댓글이 수정되었습니다.",
                "comment", updatedComment
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of(
                "success", false,
                "error", e.getMessage()
            ));
        } catch (Exception e) {
            log.error("댓글 수정 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "error", "댓글 수정에 실패했습니다."
            ));
        }
    }

    /**
     * ✅ 댓글 삭제
     * DELETE /api/notice/comments/{commentNo}
     */
    @DeleteMapping("/{commentNo}")
    public ResponseEntity<?> deleteComment(@PathVariable Long commentNo, HttpSession session) {
        try {
            String userId = (String) session.getAttribute("loginId");
            String role = (String) session.getAttribute("role");
            
            // 로그인 체크
            if (userId == null || userId.isBlank()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                    "success", false,
                    "error", "로그인이 필요합니다."
                ));
            }

            // 작성자 확인
            String commentUserId = commentService.getUserIdByCommentNo(commentNo);
            if (commentUserId == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                    "success", false,
                    "error", "댓글을 찾을 수 없습니다."
                ));
            }

            // 권한 체크 (작성자 또는 관리자)
            if (!userId.equals(commentUserId) && !"ADMIN".equals(role)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "error", "댓글 삭제 권한이 없습니다."
                ));
            }

            // 댓글 삭제
            commentService.delete(commentNo);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "댓글이 삭제되었습니다."
            ));
        } catch (Exception e) {
            log.error("댓글 삭제 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "error", "댓글 삭제에 실패했습니다."
            ));
        }
    }
}