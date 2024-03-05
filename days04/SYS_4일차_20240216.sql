-- SYS

SELECT *
FROM dba_tables
WHERE owner = 'SCOTT';

-- 본인 소유가 아닌 테이블을 접근하고 싶을때는 꼭 스키마 명을 붙여줘야한다.
-- scott.emp : SCOTT의 emp테이블을 사용하겠다.
SELECT *
FROM arirang;

-- SYNONYM ARIRANG이(가) 생성되었습니다.
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

-- SYNONYM 삭제
DROP PUBLIC SYNONYM arirang;

SELECT *
FROM all_SYNONYMS
WHERE synonym_name = 'ARIRANG';

SELECT *
FROM dept;   