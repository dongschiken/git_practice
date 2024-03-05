-- 문제 tabs란? : 접속자의 소유한 테이블 목록을 조회하는 쿼리문
-- user.tabs를 하면 SCOTT이 만든 테이블 목록 조회
-- all.tabs를 하면 자신과 다른사용자의 테이블 중에 권한이있는 목록조회
-- dba.tabs를 하면 db 전체에 포함되는 모든 테이블 목록 조회(권한이 없으면 볼 수 없다.)
SELECT *
FROM dba_tables; -- 데이터 사전, 뷰(view)
--FROM tabs; 위의 쿼리문은 tabs를 풀로 적은것

-- dept 테이블 정보를 조회하는 쿼리문
SELECT *
FROM dept;

SELECT *
FROM emp;

-- tabs? : 원래 스키마.tabs로 해야 하는데 현재 SCOTT이라는 스키마에 접속해 있어서 생략
-- 전체 테이블의 정보를 보여준다. 