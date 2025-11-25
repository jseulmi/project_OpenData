package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.BoardCommentDTO;

@Mapper
public interface BoardCommentDAO {
    
    /** ✅ 댓글 등록 */
    int insert(BoardCommentDTO dto);
    
    /** ✅ 게시글별 댓글 목록 조회 (부모 댓글 먼저, 대댓글은 부모 아래) */
    List<BoardCommentDTO> selectByBoardNo(@Param("boardNo") Long boardNo);
    
    /** ✅ 게시글별 원댓글 목록 조회 (페이징) */
    List<BoardCommentDTO> selectParentCommentsByBoardNo(
        @Param("boardNo") Long boardNo,
        @Param("offset") int offset,
        @Param("limit") int limit
    );
    
    /** ✅ 게시글별 전체 댓글 목록 조회 (페이징, 최신순) */
    List<BoardCommentDTO> selectAllCommentsByBoardNo(
        @Param("boardNo") Long boardNo,
        @Param("offset") int offset,
        @Param("limit") int limit
    );
    
    /** ✅ 게시글별 원댓글 개수 */
    int countParentCommentsByBoardNo(@Param("boardNo") Long boardNo);
    
    /** ✅ 특정 원댓글의 모든 답글 조회 */
    List<BoardCommentDTO> selectRepliesByParentNo(@Param("parentCommentNo") Long parentCommentNo);
    
    /** ✅ 댓글 단건 조회 */
    BoardCommentDTO find(@Param("commentNo") Long commentNo);
    
    /** ✅ 댓글 수정 */
    int update(BoardCommentDTO dto);
    
    /** ✅ 댓글 삭제 (소프트 삭제) */
    int delete(@Param("commentNo") Long commentNo);
    
    /** ✅ 게시글별 댓글 개수 */
    int countByBoardNo(@Param("boardNo") Long boardNo);
    
    /** ✅ 댓글 작성자 확인 */
    String getUserIdByCommentNo(@Param("commentNo") Long commentNo);
}
