-- 1 %TYPE형 변수
-- 2 %ROWTYPE형 변수
-- 3 RECORD형 변수



-- TYPE형 변수
DECLARE
    vdeptno dept.deptno%TYPE;
    vdname dept.dname%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vdeptno, vdname, vempno, vename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
--EXCEPTION
    
    DBMS_OUTPUT.PUT_LINE(vdeptno || ' ' || vdname || ' ' || vempno || ' ' || vename || ' ' || vpay );
END;

-- ROWTYPE형 변수
DECLARE
    vdrow dept%ROWTYPE;
    verow emp%ROWTYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
--EXCEPTION
    
    DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ' ' || vdrow.dname || ' ' || verow.empno || ' ' || verow.ename || ' ' || vpay );
END;


DECLARE 
    vdrow dept%ROWTYPE;
    verow emp%ROWTYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal
        INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vdrow.deptno || ' ' || vdrow.dname || ' ' || verow.empno || ' ' || verow.ename || ' ' || vpay);
END;


-- RECORD형 변수
DECLARE
   -- '부서번호, 부서명, 사원번호, 사원명, 급여' 새로운 하나의 자료형 선언
   -- 사용자 정의 구조체 타입 선언
   TYPE emp_dept_type IS RECORD
   (
    dname dept.dname%TYPE,
    deptno dept.deptno%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    vderow emp_dept_type;
BEGIN
    SELECT  dname, d.deptno, empno, ename, sal + NVL(comm, 0) pay
        INTO vderow
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
--EXCEPTION
    
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ' ' || vderow.dname || ' ' || vderow.empno || ' ' || vderow.ename || ' ' || vderow.pay );
END;


-- 4번
DECLARE
   -- '부서번호, 부서명, 사원번호, 사원명, 급여' 새로운 하나의 자료형 선언
   -- 사용자 정의 구조체 타입 선언
   TYPE emp_dept_type IS RECORD
   (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    vderow emp_dept_type;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vderow
--        INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
--EXCEPTION
    
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ' ' || vderow.dname || ' ' || vderow.empno || ' ' || vderow.ename || ' ' || vderow.pay );
END;

-- 커서 (CURSOR)
1) 커서란 ? PL/SQL의 실행블럭안에서 실행되는 : SELECT문 그 자체를 의미(여러개의 행을 실행할 수 있는 형태)
-- 묵시적 커서 : SELECT문의 실행결과가 1개인 경우, FOR문 SELECT문 (자동으로 커서가 생성된다.)
-- 명시적 커서 : SELECT문의 실행결과가 여러개인 경우
    ㄱ. CURSOR 선언 - 실행할 SELECT문 작성
    ㄴ. OPEN       - 작성된 SELECT문이 실행되는 과정 
    ㄷ. FETCH      - 커서로 부터 여러개의 레코드를 읽어와서 처리
       FETCH에서는 반복문이 반드시 사용
       이때는 커서의 속성을 사용 
       %ROWCOUNT
       %FOUND
       %NOTFOUND
       %ISOPEN
    ㄹ. CLOSE      
-- 예제) ;
-- 명시적 커서 + 익명프로시저 작성, 테스트
DECLARE
   TYPE emp_dept_type IS RECORD
   (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    vderow emp_dept_type;
    -- 1) 커서 선언
--    CURSOR 커서명 IS SELECT
    CURSOR emp_dept IS (
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    );
BEGIN
   -- 2) 커서 오픈
   OPEN emp_dept;
   LOOP
    FETCH emp_dept INTO vderow;
    EXIT WHEN emp_dept%NOTFOUND;
    DBMS_OUTPUT.PUT( emp_dept%ROWCOUNT || ' : ' ); 
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ' ' || vderow.dname || ' ' || vderow.empno 
    || ' ' || vderow.ename || ' ' || vderow.pay );
   
   END LOOP;
   
   -- 4) 커서 닫기
   CLOSE emp_dept;

--EXCEPTION
END;

DECLARE
    TYPE emp_dept IS RECORD
    (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    sal NUMBER
    );
    vderow emp_dept;
    CURSOR emp_dept_cursor IS (
        SELECT deptno, dname, empno, ename, sal
        FROM dept d JOIN emp e ON d.deptno = e.deptno
        );
BEGIN
    
    OPEN emp_dept_cursor;
    LOOP
    FETCH emp_dept_cursor INTO vderow;
    EXIT WHEN emp_dept_cursor%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ' ' || vderow.dname || ' ' || vderow.empno || ' ' || vderow.ename || ' ' || vderow.sal );
    END LOOP;
    
--EXCEPTION
END;



-- ㄱ. 암시적 커서
DECLARE
   TYPE emp_dept_type IS RECORD
   (
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
    );
    vderow emp_dept_type;
    -- 1) 커서 선언
--    CURSOR 커서명 IS SELECT
    CURSOR emp_dept IS (
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    );
BEGIN
   -- 2) 커서 오픈
  FOR
    vderow IN REVERSE emp_dept
   LOOP
--    FETCH emp_dept INTO vderow;
--    EXIT WHEN emp_dept%NOTFOUND;
    DBMS_OUTPUT.PUT( emp_dept%ROWCOUNT || ' : ' ); 
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ' ' || vderow.dname || ' ' || vderow.empno 
    || ' ' || vderow.ename || ' ' || vderow.pay );
   
   END LOOP;  
   -- 4) 커서 닫기
--   CLOSE emp_dept;

--EXCEPTION
END;



-- ㄴ. 암시적 커서

BEGIN
   -- 2) 커서 오픈
   -- FOR문에서 사용되는 vderow변수는 선언 안해도 된다.
  FOR
    vderow IN  (
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    )
   LOOP
--    DBMS_OUTPUT.PUT( vderow%ROWCOUNT || ' : ' ); 
    DBMS_OUTPUT.PUT_LINE( vderow.deptno || ' ' || vderow.dname || ' ' || vderow.empno 
    || ' ' || vderow.ename || ' ' || vderow.pay );
   
   END LOOP;
   

--EXCEPTION
END;


-- 저장 프로시저 ( STORED PROCEDURE )
CREATE OR REPLACE PROCEDURE 프로시저명
(
    매개변수( argument, parameter ),
    매개변수( argument, parameter ),
    p
)
IS
    v(변수);
    v(변수);
BEGIN
EXCEPTION
END;


-- 저장 프로시저를 실행하는 3가지 방법
--1) EXECUTE 문으로 실행
--2) 익명프로시저에서 호출해서 실행
--3) 또 다른 저장프로시저에서 호출해서 실행

CREATE TABLE tbl_emp
AS
(SELECT * FROM emp);

SELECT *
FROM tbl_emp;


DELETE FROM tbl_emp
WHERE empno = 9999;
-- 프리시저 선언할때 매개변수에서 크기는 붙이지 않는다. pempno NUMBER
-- 프리시저에서 매개변수는 ";"을 안찍는다.
CREATE OR REPLACE PROCEDURE up_deltblemp
(
--    pempno IN tbl_emp.empno%TYPE
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
    -- ROLLBACK;
END;
--Procedure UP_DELTBLEMP이(가) 컴파일되었습니다.
-- UP_DELTBLEMP(프로시저) 실행 방법
-- 1) EXECUTE 문으로 실행
--*Cause:    Usually a PL/SQL compilation error. : 매개변수를 달라.
EXECUTE up_deltblemp(7369);
EXECUTE up_deltblemp(pempno=>7499);

-- 2) 익명 프로시저에서 호출해서 실행
BEGIN
    up_deltblemp(7566);
END;

-- 3) 또다른 프로시저 만들어서 호출
CREATE OR REPLACE PROCEDURE up_deltblemp_test
AS
BEGIN
    up_deltblemp(7521);
END up_deltblemp_test;

EXEC up_deltblemp_test;
--ROLLBACK;

-- 문제 dept테이블 -> tbl_dept 테이블 생성

CREATE TABLE tbl_dept
AS (SELECT * FROM dept);

SELECT *
FROM tbl_dept;

-- 문제 tbl_dept 테이블에 deptno 컬럼에 제약조건 설정
ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tbl_deptno PRIMARY KEY(deptno);

-- 명시적 커서 + tbl_dept 테이블을 SELECT 저장 프로시저 생성
-- 실행
-- up_seltbldept
-- 매개변수 X, 변수는 명시적 커서 선언
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
   vdrow tbl_dept%ROWTYPE;
   CURSOR dcursor IS (
                         SELECT deptno, dname, loc
                         FROM tbl_dept
                       );
BEGIN 
   OPEN dcursor; 
   LOOP
     FETCH dcursor INTO vdrow; 
     EXIT WHEN dcursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( dcursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
      || ', ' ||  vdrow.loc);  
   END LOOP; 
   CLOSE dcursor;
--EXCEPTION
END;

EXEC UP_SELTBLDEPT;

-- seq_deptno 시퀀스 생성 50/ 10 / NOCYCLE / NO 캐시 / 90

CREATE SEQUENCE seq_deptno INCREMENT BY 10 START WITH 50 MAXVALUE 90 NOCYCLE NOCACHE;

CREATE OR REPLACE PROCEDURE upinstbldept
(
    pdname IN tbl_dept.dname%TYPE := NULL,
    ploc   IN tbl_dept.loc%TYPE DEFAULT NULL
)
IS
--    vdeptno tbl_dept.deptno%TYPE;
BEGIN
--    SELECT seq_deptno.NEXTVAR
--    SELECT MAX(deptno)+10 INTO vdeptno
--    FROM tbl_dept;
    
--    vdeptno = vdpeptno + 10;
    INSERT INTO tbl_dept ( deptno, dname, loc )
    
    VALUES ( seq_deptno.NEXTVAL, pdname, ploc );
    COMMIT;
--EXCEPTION
END;

SELECT *
FROM tbl_dept;

-- 문제 [ up_updtbldept ] 수정하고자하는 부서번호 집어넣으면 dname, loc를 
EXEC up_updtbldept( 50, 'X', 'Y' );
EXEC up_updtbldept( pdeptno => 50, pdname=> 'QC3' ); -- loc 수정 안하고 그대로 유지
EXEC up_updtbldept( pdeptno => 50, ploc=> 'SEOUL' ); -- 부서명은 수정안하고 그대로 유지

CREATE OR REPLACE PROCEDURE up_updtbldept
    
(
    pdeptno IN tbl_dept.deptno%TYPE DEFAULT NULL,
    pdname IN tbl_dept.dname%TYPE DEFAULT NULL,
    ploc   IN tbl_dept.loc%TYPE DEFAULT NULL
)
IS
BEGIN
    
    UPDATE tbl_dept
    SET dname = NVL(pdname, dname)
        , loc = CASE
                WHEN ploc IS NULL THEN loc
                ELSE ploc
                END
    WHERE deptno = pdeptno;
    COMMIT;
END;

-- 풀이) UP_SELTBLDEPT 모든 부서


CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_emp.deptno%TYPE := NULL,
    
    )
IS
   verow tbl_emp%ROWTYPE;
   CURSOR ecursor IS (
                         SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL(pdeptno, 10)
                       );
BEGIN 
   OPEN ecursor; 
   LOOP
     FETCH ecursor INTO verow; 
     EXIT WHEN ecursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( ecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP; 
   CLOSE ecursor;
--EXCEPTION
END;

-- ㄴ. 풀이 (커서 파라미터를 이용하는 방법)
CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_emp.deptno%TYPE := NULL
    
    )
IS
   verow tbl_emp%ROWTYPE;
   CURSOR ecursor IS (
                         SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL(pdeptno, 10)
                       );
BEGIN 
   OPEN ecursor; 
   LOOP
     FETCH ecursor INTO verow; 
     EXIT WHEN ecursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( ecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP; 
   CLOSE ecursor;
--EXCEPTION
END;

-- 3번 FOR문을 사용하는 프로시저
CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_emp.deptno%TYPE := NULL
    
    )
IS
BEGIN 
    FOR verow IN (
                    SELECT *
                    FROM tbl_emp
                    WHERE deptno = NVL(Pdeptno, 10)
                    )
                    
    LOOP
    DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
    || ', ' ||  verow.hiredate); 
    END LOOP;
--EXCEPTION
END;

-- 문제 tbl_dept테이블의 레코드를 삭제하는 up_deltbldept 저장
프로시저를 작성, 50, 60, 70, 80

CREATE OR REPLACE PROCEDURE up_deltbldept
    ( 
    pdeptno tbl_dept.deptno%TYPE := NULL
    )
IS
BEGIN
    DELETE tbl_dept
    WHERE deptno = pdeptno;
--EXCEPTION;
END;
EXEC up_deltbldept(80);
SELECT *
FROM tbl_dept;

EXEC up_updtbldept;
EXEC up_seltblemp(50);
EXEC up_updtbldept( pdname => 'QC');
EXEC UPINSTBLDEPT( ploc => 'SEOUL');
EXEC UPINSTBLDEPT;


-- 저장 프로시저
-- 입력용 매개변수 IN
-- 출력용 매개변수 OUT
-- 입출력용 매개변수 INOUT

SELECT num, name, ssn -- 770221-1*****
FROM insa
WHERE num = 1001;

CREATE OR REPLACE PROCEDURE up_selinsa
(
   pnum IN insa.num%TYPE 
   , pname OUT insa.name%TYPE
   , prrn OUT VARCHAR2
)
IS
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    
    SELECT name, ssn  INTO vname, vssn -- 770221-1*****
    FROM insa
    WHERE num = 1001;
    
    pname := vname;
    prrn := SUBSTR(vssn, 1, 8) || '******';
--EXCEPTION
END;
-- Procedure UP_SELINSA이(가) 컴파일되었습니다.
DECLARE 
    vname insa.name%TYPE;
    vrrn VARCHAR2(14);
BEGIN
    -- 1001번은 입력용
    -- vname, vrr은 출력용 매개변수로 사용된 경우
    up_selinsa(1001, vname, vrrn);
    DBMS_OUTPUT.PUT_LINE( vname || ' ' || vrrn );
--EXCEPTION
END;

-- 예) 주민등록번호 14자리를 입력용 매개변수로
-- 앞자리 6자리를 출력용 매개변수로 사용
CREATE OR REPLACE PROCEDURE up_rrn
(
    prrn IN OUT VARCHAR2 
)
IS
BEGIN
    prrn := SUBSTR(prrn, 1, 6);
--EXCEPTION
END;

DECLARE
    vrrn VARCHAR2(14) := '761230-1700001';
BEGIN
    up_rrn( vrrn );
    DBMS_OUTPUT.PUT_LINE(vrrn) ;
END;


CREATE OR REPLACE PROCEDURE 저장프로시저명
(
    P 파라미터,
    P 파라미터
)
RETURN 리턴 자료형
IS 
    v 변수명;
    v 변수명;
BEGIN
    
    
    RETURN(리턴값); 
    
EXCEPTION
END

-- 저장 함수 ( Stored Function )
CREATE OR REPLACE PROCEDURE 

-- 예제 1) 저장함수 ( 주민등록 번호를 매개변수로 남자/여자 문자열 반환하는 함수 )
SELECT num, name, ssn
    , DECODE(MOD(SUBSTR(ssn, -7, 1),2), 1, '남자', '여자') GENDER--주민등록번호를 사용해서 성별 출력
    , UF_GENDER(ssn) gender
    , SCOTT.UF_AGE(ssn, 0) 만나이
    , SCOTT.UF_AGE(ssn, 1) 세는나이
FROM insa;

-- up 유저 저장 프로시저
-- uf 유저 저장 함수
-- 함수 만들어서 사용가능
CREATE OR REPLACE FUNCTION uf_gender

(
    prrn IN VARCHAR2 
)

RETURN VARCHAR2

IS
    vgender VARCHAR2(2 CHAR);
BEGIN
    IF MOD(SUBSTR( prrn, -7, 1),2) = 1 THEN vgender := '남자' ;
    ELSE vgender := '여자' ;
    END IF;
    RETURN (vgender);

--EXCEPTION

END;


CREATE OR REPLACE FUNCTION uf_age

(
    prrn IN VARCHAR2
)

RETURN NUMBER

IS
    vage NUMBER(3);
BEGIN
       vage := TO_CHAR(SYSDATE, 'YYYY') -  CASE 
                                    WHEN SUBSTR(prrn, 8, 1) IN (1, 2, 5, 6) THEN 1900 
                                    WHEN SUBSTR(prrn, 8, 1) IN (3, 4, 7, 9) THEN 2000
                                    ELSE 1800 + CASE 
                                    END + SUBSTR(prrn,1, 2)
                                                SIGN( TO_DATE(SUBSTR(prrn, 3, 4), 'MMDD') - TRUNC(SYSDATE) )
                                                WHEN 1 THEN -1
                                                ELSE 0
                                                END;
    RETURN (vage);
--EXCEPTION
END;



CREATE OR REPLACE FUNCTION uf_age
(
    prrn IN VARCHAR2
    , ptype IN NUMBER -- 1(세는나이) 0(만나이)
)
RETURN NUMBER
IS
    ㄱ NUMBER(4); -- 올해년도
    ㄴ NUMBER(4); -- 생일년도
    ㄷ NUMBER(1); -- 생일지남 여부 -1, 0, 1
    vcounting_age NUMBER(3); -- 세는나이
    vamerican_age NUMBER(3); -- 만 나이
    
BEGIN
    --만나이 계산 : 올해년도 - 생일년도 + 생일안지남 ( -1 ) 결정
    --세는 나이   : 올해년도 - 생일년도 + 1;
     ㄱ := TO_CHAR(SYSDATE, 'YYYY');
     ㄴ := CASE 
            WHEN SUBSTR(prrn, 8, 1) IN (1, 2, 5, 6) THEN 1900 
            WHEN SUBSTR(prrn, 8, 1) IN (3, 4, 7, 9) THEN 2000
            ELSE 1800
          END + SUBSTR(prrn, 1, 2);
     ㄷ := SIGN( TO_DATE(SUBSTR(prrn, 3, 4), 'MMDD') - TRUNC(SYSDATE) );
     
     vcounting_age := ㄱ-ㄴ+1;
--     vamerican_age := vcounting_age-1 + DECODE( ㄷ, 1, -1, 0);
     vamerican_age := vcounting_age-1 + CASE ㄷ
                                        WHEN 1 THEN-1
                                        ELSE 0
                                        END ;
     IF ptype = 1 THEN RETURN vcounting_age;
     ELSE RETURN vamerican_age;
     END IF;
--EXCEPTION

END;

-- 주민등록번호 -> 1998.01.20(화요일)

CREATE OR REPLACE FUNCTION uf_birth
(
    prrn VARCHAR2
)   
RETURN VARCHAR2

IS
    vcentry NUMBER(2); -- 19, 20 세기
    vbirth VARCHAR2(20); -- 1998.01.20(화)
BEGIN
    vbirth := SUBSTR( prrn, 1, 6 );
    vcentry := CASE 
               WHEN SUBSTR( prrn, -7, 1 ) IN( 1, 2, 5, 6 ) THEN 19
               WHEN SUBSTR( prrn, -7, 1 ) IN(3, 4, 7, 8 ) THEN 20
               ELSE 18
               END;
    vbirth := vcentry || vbirth;
    vbirth := TO_CHAR(TO_DATE( vbirth, 'YYYYMMDD'), 'YYYY.MM.DD(DY)');
    RETURN vbirth;
--EXCEPTINO
END;
-- Function UF_BIRTH이(가) 컴파일되었습니다.
SELECT name, ssn
    , SCOTT.UF_BIRTH( ssn )
FROM insa;

SELECT POWER(2,3), POWER(2,-3)
    , SCOTT.UF_POWER(2,10)
    , SCOTT.UF_POWER(2,-3)
FROM dual;


CREATE OR REPLACE FUNCTION uf_power
(
    pnum1 NUMBER,
    pnum2 NUMBER
)
RETURN NUMBER
IS
    vnum1 NUMBER;
    vnum2 NUMBER;
BEGIN
    
    vnum1 := pnum1;
    vnum2 := ABS(pnum2);
        FOR i IN 1..vnum2-1
        LOOP
        vnum1 := vnum1 * pnum1;
    END LOOP;
    IF pnum2 < 0 
    THEN RETURN 1/vnum1;
    ELSE RETURN vnum1;
    END IF;
--EXCEPTION
END;


SELECT t.name, t.ssn
        , t.올해년도 - t.생일년도 + CASE 생일체크
                                    WHEN 1 THEN -1
                                    ELSE 0
                                  END E
FROM(
    SELECT name, ssn
        , TO_CHAR(SYSDATE, 'YYYY') 올해년도 
    --    , SUBSTR(ssn, 8, 1)  성별
    --    , SUBSTR(ssn, 1, 2)  생일년도
        , CASE 
            WHEN SUBSTR(ssn, 8, 1) IN (1, 2, 5, 6) THEN 1900 
            WHEN SUBSTR(ssn, 8, 1) IN (3, 4, 7, 9) THEN 2000
            ELSE 1800
          END + SUBSTR(ssn, 1, 2) 생일년도
        , SIGN( TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE) ) 생일체크
    FROM insa
    ) t;


-- IN/OUT 입출력용 파라미터(매개변수)
-- 저장함수 ( Stored Function )
-- 문제