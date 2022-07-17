-- tbl_board
INSERT INTO tbl_board(bno, title, content, writer) 
VALUES(seq_board.nextval, '테스트 제목', '테스트 내용', 'user00');
commit;

-- 테이블 재귀 호출
INSERT INTO tbl_board(bno, title,content, writer)
(SELECT seq_board.nextval, title, content, writer from tbl_board);


-- 오라클 힌트 사용
select /*+ FULL(tbl_board) */
rownum rn, bno, title, content from tbl_board where bno > 0;

select /*+ INDEX_DESC(tbl_board pk_board) */
rownum rn, bno, title, content from tbl_board where bno > 0;



SELECT bno, title, content, writer, regdate, updatedate
FROM (
    SELECT /*+ INDEX_DESC(tbl_board pk_board)*/
        ROWNUM rn, bno, title, content, writer, regdate, updatedate
    FROM tbl_board
    WHERE ROWNUM <= 30 )
WHERE RN > 20;


-- 페이징 1
SELECT bno, title, content, writer, regdate, updatedate
FROM (
    SELECT /*+ INDEX_DESC(tbl_board pk_board) */
        ROWNUM rn, bno, title, content, writer, regdate, updatedate
    FROM tbl_board
    WHERE
        (title LIKE '%테스트%' OR content LIKE '%테스트%')
        AND ROWNUM <= 20 )
WHERE rn > 10;

-- 페이징 2
SELECT bno, title, content, writer, regdate, updatedate
FROM (
    SELECT /*+ INDEX_DESC(tbl_board pk_board) */
        ROWNUM rn, bno, title, content, writer, regdate, updatedate
    FROM tbl_board
    WHERE
        title LIKE '%테스트%' OR content LIKE '%테스트%')
WHERE rn > 10 AND rn <= 20;



-- tbl_reply

-- 페이징
SELECT rno, bno, reply, replyer, replydate, updatedate
FROM (
    SELECT /*+ INDEX(tbl_reply idx_reply */
        ROWNUM rn, bno, rno, reply, replyer, replydate, updatedate
    FROM tbl_reply
    WHERE bno = 144 AND rno > 0
    )
WHERE rn > 5 AND rn <= 15;


-- 댓글 및 댓글 수 처리

alter table tbl_board add (replycnt number default  0);

alter table tbl_board drop column replycnt;

update tbl_board set replycnt = (
    SELECT count(rno) FROM tbl_reply
    WHERE tbl_board.bno = tbl_reply.bno);
    
-- 복구시킬 때
alter table tbl_board drop column replycnt;