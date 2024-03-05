-- 주석처리
-- 모든 사용자 계정 조회
-- 라인 마다 절 별로 코딩하면 가독성, 유지보수가 좋다??
-- keyword는 대문자로 입력되는것이 권장된다.
-- 테이블명, 컬럼명은 소문자 사용이 권장된다.
-- 가독성을 위해서 tab키 또는 줄맞춤 사용이 권장된다.
SELECT   * 
FROM     all_users; -- Ctrl + Enter 또는 f5 : 쿼리문 실행

select * 
fRom ALL_users;    

-- 수업중에 사용할 계정을 생성, 수정, 삭제 --
-- 1) SCOTT 계정 유무 확인

SELECT *
FROM all_users;

-- 2) SCOTT 계정을 생성
CREATE USER SCOTT IDENTIFIED BY tiger;


-- 3) SCOTT 계정의 비밀번호를 1234로 수정
-- ALTER USER SCOTT IDENTIFIED BY 1234;

DROP USER SCOTT CASCADE;

-- 4)최고관리자 계정이 SCOTT 계정에 CREATE SESSION 데이터베이스에 접속 시스템 권한을 부여한다.
--GRANT CREATE SESSION TO SCOTT;
-- student_role로 ROLE을 만들고 SCOTT에 그 ROLE을 넘겨서 시스템 권한을 부여한방법
GRANT CREATE SESSION TO student_role;
GRANT student_role TO SCOTT;

GRANT CONNECT, RESOURCE TO SCOTT;

-- CREATE USER, DROP USER, ALTER USER;
-- CREATE TABLESPACE, DROP TABLESPACE, ALTER TABLESPACE;
-- CREATE ROLE, DROP ROLE, ALTER ROLE;

-- 문제 : 오라클 설치시에 미리 정의된 롤(role)을 확인하는 쿼리 작성하시오 (32개의 기본 role 조회됨)
SELECT *
FROM dba_roles;


SELECT grantee,privilege 
FROM DBA_SYS_PRIVS 
WHERE grantee = 'CONNECT'; 

-- C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin  // SCOTT 샘플파일
SP2-0157: unable to CONNECT to ORACLE after 3 attempts, exiting SQL*Plus

C:\Users\user>sqlplus sys/ss123$@localhost:1521/XE AS SYSDBA

SQL*Plus: Release 11.2.0.2.0 Production on 화 2월 13 15:24:21 2024

Copyright (c) 1982, 2014, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

-- SCOTT으로 접속하기 위해 비밀번호 tiger로 바꾸고 cmd창에서 SYS로 로그인 한 후에 
-- 파일 끌어다 써서 SCOTT으로 다시 재 로그인
--SQL> C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql
--SP2-0024: Nothing to change.
--SQL> @C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql
--SQL> SHOW USER
--USER is "SCOTT"
--SQL> SHOW USER
--USER is "SCOTT"
--SQL>

-- 문제 sys가 아니라 SCOTT으로 접속 후에 SCOTT.SQL 실행해서 만들어진 테이블 확인
SELECT *
FROM tabs;

SELECT *
FROM dba_tables;

-- 데이터를 가지고 있는 사전
SELECT COUNT(*) -- 2551개
SELECT *
FROM dictionary;

CREATE USER madang IDENTIFIED BY madang DEFAULT TABLESPACE users TEMPORARY
TABLESPACE temp PROFILE DEFAULT;
GRANT CONNECT, RESOURCE TO madang;
GRANT CREATE VIEW, CREATE SYNONYM TO madang;
GRANT UNLIMITED TABLESPACE TO madang;


SELECT *
FROM dba_users;

--CREATE USER SCOTT IDENTIFIED BY tiger;

ALTER USER HR IDENTIFIED BY lion;

-- HR 계정 확인 --
-- 1) HR 계정의 비밀번호를 lion으로 수정하고 접속
-- 2) HR 계정이 소요하고 있는 테이블 목록을 조회...