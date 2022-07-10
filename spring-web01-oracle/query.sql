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

SELECT bno, title, content
