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