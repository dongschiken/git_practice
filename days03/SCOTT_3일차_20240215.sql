-- SCOTT

SELECT DISTINCT buseo
FROM insa
ORDER BY buseo ASC;

SELECT sal + NVL(comm, 0) PAY
FROM emp
WHERE sal + NVL(comm, 0) BETWEEN 2000 AND 4000
ORDER BY PAY DESC;


SELECT ename, empno, NVL( ''||mgr, 'ceo') mgr
FROM emp
WHERE mgr IS NULL;

-- insa 테이블에서 사원명, 주민등록번호, 생일 년도, 생일 월, 생일 일, 성별 출력

SELECT name, ssn, SUBSTR( ssn, 8, 1) gender
     , SUBSTR ( ssn, 1, 2) year
     , SUBSTR ( ssn, 3, 2) month
     , SUBSTR ( ssn, 5, 2) "DATE"
FROM insa;
--WHERE SUBSTR( ssn, 8, 1) = '1'

-- 문제
--SELECT name, CONCAT(SUBSTR( ssn, 1, 8), '******') rrn
SELECT name, SUBSTR( ssn, 1, 8) || '******' rrn
FROM insa
WHERE TO_NUMBER(SUBSTR(ssn, 1,2)) BETWEEN  70  AND  79
--WHERE SUBSTR(ssn, 1,1) = '7'
ORDER BY ssn ASC;

-- TO_DATE하고 'YY' 붙이기
select name, substr(ssn,0,8) || '******' rrn,
TO_DATE(SUBSTR(ssn, 0, 2), 'YY')
from insa
where extract (year from to_date(substr(ssn,0,6)) ) between 1970 and 1979 ;


SELECT *
FROM insa
WHERE EXTRACT( YEAR FROM TO_DATE(SUBSTR(ssn, 0, 6)) ) BETWEEN 1970 AND 1979;


-- 수도권이 아닌 사람을 출력
SELECT *
FROM insa
--WHERE city != '서울' AND city != '경기' AND city != '인천'
--WHERE NOT ( city = '서울' OR city = '경기' OR city = '인천' )
WHERE city NOT IN ('서울', '인천', '경기' )
ORDER BY city;

-- 입사일자가 81년도인 사원의 정보 출력
-- 오라클의 비교연산자는 숫자, 문자, 날짜를 모두 비교할 수 있다.
-- 1번 풀이
SELECT *
FROM emp
WHERE hiredate BETWEEN '81/01/01' AND '81/12/31';


-- 2번 풀이
SELECT ename, EXTRACT( year FROM hiredate )
FROM emp
--WHERE TO_CHAR( hiredate, 'YYYY') = '1981';
WHERE EXTRACT( YEAR FROM hiredate ) = '1981';




-- 3번 풀이
SELECT 'abcdefg'
    , SUBSTR ( 'abcdefg', 1, 2) -- 1도 첫 번째 문자 ab
    , SUBSTR ( 'abcdefg', 0, 2) -- 0도 첫 번째 문자 ab
    , SUBSTR ( 'abcdefg', 3)    -- 3번째 부터 끝까지 cdefg
    , SUBSTR ( 'abcdefg', -5, 3)   -- 뒤에서부터 다섯 번째 부터 3개 cde
    , SUBSTR ( 'abcdefg', -1, 1)   -- 뒤에서 첫 번째 부터 1개 g
FROM dual;

SELECT ename, EXTRACT( year FROM hiredate ) year
FROM emp
WHERE SUBSTR ( hiredate, 1, 2) = '81';

-- 오늘 날짜의 년/월/일 출력 : DATE( 초 ) , TIMESTAMP( 나노 세컨드 + 시간대 까지 )
-- dual은 날짜를 1번만 찍기위한 임시 테이블
-- SYSDATE는 ()가 없지만 함수이다. (자바랑 다른점)
SELECT SYSDATE, CURRENT_TIMESTAMP  
    , EXTRACT( YEAR from SYSDATE )  -- 숫자 형태로 출력        2024
    , TO_CHAR( SYSDATE, 'YYYY')     -- 문자열 형태로 날짜 출력 '2024'
    , TO_CHAR( SYSDATE, 'YY')
    , TO_CHAR( SYSDATE, 'YEAR')
FROM dual;


SELECT NVL(TO_CHAR(mgr), 'CEO') mgr
FROM emp
WHERE mgr IS NULL;


SELECT num, name, tel, NVL2(tel, 'O', 'X') telOX
FROM insa;


SELECT num, name, NVL2(tel, 'O', 'X') tel
FROM insa;


SELECT empno, ename, sal, NVL(comm, 0) comm, sal + NVL(comm, 0) pay
FROM emp;

SELECT DISTINCT buseo
FROM insa
ORDER BY buseo ASC;

SELECT deptno, ename, sal, comm, sal + NVL(comm, 0) pay
FROM emp
WHERE deptno = 30 AND comm IS NULL
ORDER BY pay DESC;


SELECT ename, empno, sal, comm, sal + NVL(comm, 0) pay, deptno
FROM emp
WHERE sal + NVL(comm, 0) >= 1000 AND sal + NVL(comm, 0) <= 3000 AND deptno != 30
ORDER BY ename ASC;


SELECT *
--FROM user_sys_privs; -- 시스템 권한 = UNLIMITED TABLESPACE
FROM user_role_privs; -- 유저가 가지고 있는 role = CONNECT, RESOURCE


SELECT ename, empno, sal, comm, sal + NVL(comm, 0) pay, deptno,
NVL2(comm, sal+comm, sal+0) pay2
FROM emp
--WHERE sal + NVL(comm, 0) >= 1000 AND sal + NVL(comm, 0) <= 3000 AND deptno != 30
WHERE sal + NVL(comm, 0) BETWEEN 1000 AND 3000 AND deptno != 30
ORDER BY ename ASC;    


SELECT ename, empno, sal, comm, sal + NVL(comm, 0) pay, deptno
FROM emp
WHERE sal + NVL(comm, 0) BETWEEN 1000 AND 3000 AND deptno != 30
ORDER BY ename ASC;   

-- 서브쿼리란?? SELECT(쿼리)문 안에 또다른 SELECT(쿼리)문이 있는 경우를 서브쿼리라 한다.
-- WHERE조건절에 서브 쿼리가 있으면 NESTED 서브쿼리문
-- FROM절 뒤에 서브 쿼리가 있으면 INLINE VIEW라고 한다.
? 자주 사용되는 query를 사용하기 전에 with 절로 미리 query block으로 정의한 후 사용한다.
? 서브쿼리문에서 sub query에 의해 실행된 결과에 의해 main query가 실행되기 때문에 서브쿼리문은 성능이 저하된다.
? With 절을 통해 서브쿼리를 보다 쉽고 간편하게 사용할 수 있게 한다.
? WITH 절은 여러 개의 sub query가 하나의 main query에서 사용될 때 생기는 복잡성을 보다 간결하게 정의하여 사용함으로써 서브쿼리에서 발생할 수 있는 성능저하 현상을 방지할 수 있다.
? 먼저, 하나의 main query에 정의될 sub query를 with 절과 함께 선언하고, 각각의 sub query가 정의될 때 sub query를 대신할 인라인 뷰의 이름을 사용자가 적절히 정의한다. 여러 개의 sub query가 사용된다면 순서대로 선언하면 된다.
? sub query의 선언이 끝나면, 실제로 실행될 main query절을 작성하는데, 필요한 sub query는 인라인 뷰의 이름으로 새로운 sub query를 작성하여 사용한다. 
【형식】
    WITH  query1이름 AS (subquery1),
          query2이름 AS (subquery2), ...

?? with절 속에 반드시 select 문이 있어야 함
?? query명과 기존의 테이블명이 동일하게 사용되는 경우, 쿼리 블럭명이 우선함
?? 하나의 with절에 여러 개의 query block 사용이 가능하다.
?? with절을 불러서 사용하는 body 영역에서는 block명이 우선되므로 테이블명은 사용할 수 없다.
?? with절 내에 또 다른 with절을 포함할 수 없다.
?? set operator를 사용한 쿼리에서는 사용할 수 없다.

-- 네스티드 서브 쿼리문
-- WITH절 이후의 쿼리문의 별칭을 temp로 두고 FROM 에서 temp를 가져와서 t라는 별칭으로 쓰겠다.
WITH temp AS 
    ( 
    SELECT deptno, ename, sal + NVL(comm, 0) pay
    FROM emp
    )
    
    
SELECT t.*
FROM temp t
WHERE t.pay BETWEEN 1000 AND 3000 AND t.deptno != 30
ORDER BY ename ASC;


-- 인라인 뷰
Inline view는 view를 이용하는데, create를 시키지 않고 바로 SQL안에 기술하여 사용하는 형식이다.
실제로 view를 create하여 놓으면, 자주 사용하여야 효용가치가 있는데,
 특정 DML(data manipulation language: select,insert,delete,update)에서
 한번만 쓰면 다시 쓰일 일이 거의 없는 경우를 생각해 보자. 
한번만 쓰여도 뷰를 만들어 놓는다면 뷰가 많아져서
  만들어진 뷰가 어떤 역할을 하기 위한 것인지 일일이 관리하고 기억해야 나중에 사용할 수 있다. 
뷰가 너무 많아진다면 그것 또한 문제가 된다는 것이다. 
이렇게 일회성으로 쓰이는 뷰를 SQL안으로 포함시켜서 편리하게 사용하자는 의도에서 inline view를 사용한다.
view안에서 또 다른 view를 필요로 하는 경우도 마찬가지이다.
 몇 번의 중첩만 일어나도 그것을 계속 create 시키면서 어떤 view에서 어떤 view를 이용하는지를 알아내는 것도 쉽지 않은 일이기 때문이다.
 다음은 inline view를 사용한 예제이다.

-- 인라인 뷰 서브쿼리문
-- FROM절 뒤에 오는 실행결과를 t로 두겠다.
SELECT t.*
FROM   
    ( 
    SELECT deptno, ename, sal + NVL(comm, 0) pay
    FROM emp
    ) t
WHERE t.pay BETWEEN 1000 AND 3000 AND t.deptno != 30
ORDER BY ename ASC;




SELECT *
FROM 
   (
    SELECT sal + NVL(comm, 0) pay
    FROM emp;
    ) t
WHERE t.pay BETWEEN 1000 AND 3000 AND t.deptno = 30;

SELECT num, name, NVL2(tel, 'O', 'X') tel
FROM insa
WHERE buseo = '개발부';

-- 문제 : insa 테이블에서 

SELECT name, ssn
FROM insa
WHERE ssn LIKE '7%';
-- 7로 시작하는 SSN 출력




SELECT name, ssn
FROM insa
--WHERE ssn LIKE '7_12%'; -- 70년대 생이면서 12월 생일인 사람들
WHERE ssn LIKE '__12%';
--WHERE EXTRACT( MONTH FROM TO_DATE( SUBSTR (ssn, 3, 2 ), 'MM')) = 12;
--WHERE SUBSTR( ssn, 3, 2) = 12;




-- 문제 : insa 테이블에서 김씨 성을 가진 사원 모두 출력

SELECT name, ssn
FROM insa
WHERE name NOT LIKE '김%'
--WHERE name LIKE '_김_'    => 가운데 문자가 '김'이면 출력
--WHERE name LIKE '%김_'  => 뒤에서 2번째 문자가 '김'이면 출력
--WHERE name LIKE '%김%'  => 이름속에 '김'이라는 문자가 있으면 전부 출력
ORDER BY ssn ASC;



출신도가 서울, 부산, 대구 이면서 전화번호에 5 또는 7이 포함된 자료 출력하되 부서명의 마지막 부는 출력되지 않도록함. (이름, 출신도, 부서명, 전화번호)

DESC insa;
--  SUBSTR(buseo, 1, LENGTH(buseo)- 1) => 부서의 길이 찾아와서 마지막 한글자 출력 X
SELECT name, city, SUBSTR(buseo, 1, LENGTH(buseo)- 1) buseo, tel
FROM insa
WHERE city IN ('서울', '부산', '대구') AND tel LIKE '%5%' OR tel LIKE '%7%';

-- 동적쿼리 : 내가 원하는 대로 쿼리의 길이를 늘리고 줄이는 쿼리

-- LIKE 연산자의 ESCAPE 옵션 설명
-- dept 테이블 구조 확인

DESC dept;

-- SQL 5가지 : DQL, DDL, DML(INSERT, DELETE, UPDATE) + COMMIT ROLLBACK, TCL, DCL
-- DML(INSERT) 사용해서 dept 부서 하나 추가

SELECT deptno,dname, loc
FROM dept;

INSERT INTO 테이블명 [( 컬럼명, 컬럼명...)] VALUES (값...);
COMMIT;


INSERT INTO dept VALUES ( 60, '한글_나라', 'COREA' );
-- deptno가 PK라서 50이 이미 있어서 들어갈 수 없다.
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated : 유일성 제약 조건 위배된다.
-- 1 행 이(가) 삽입되었습니다.



INSERT INTO dept VALUES ( 70, '영업부', 'KOREA');

SELECT *
FROM dept;

-- dept 테이블에서 부서명을 가지고 검색 하는데 부서명에 _이 있는 부서 정보를 조회

SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';

-- \가 붙은 와일드카드는 문자로 취급하겠다 ==> ESCAPE '\';

-- UPDATE
UPDATE [스키마].테이블명
SET 컬럼=값, 컬럼=값
[WHERE 조건절;] -- 만약 WHERE조건 안주면 모든 레코드(값) 수정

-- LOC를 전부 'XXX'로 업데이트 하고 다시 ROLLBACK
--UPDATE SCOTT.dept
--SET loc = 'XXX';
--ROLLBACK;

UPDATE SCOTT.dept
SET LOC = 'COREA', dname = '한글나라'
WHERE deptno = 60;
ROLLBACK;


-- 문제 : 30번 부서명, 지역명 -> 60번 부서명, 지역명으로 UPDATE
-- 여기는 괄호가 계속 문제 생기는 부분
UPDATE dept 
SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno = 30)
WHERE deptno = 60;
COMMIT;

SELECT *
FROM dept;


-- DELETE
DELETE FROM [스키마.]테이블명
[WHERE 조건절] WHERE 없으면 모든 레코드 삭제

DELETE FROM dept;
-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found : 무결성 제약조건에 위배된다.

DELETE FROM dept
WHERE deptno IN (50, 60);

-- 문제 : emp 테이블에서 sal의 10%를 인상해서 새로운 sal로 수정하세요

UPDATE SCOTT.emp
SET sal = (sal + sal/10);
--SET sal = sal * 1.1;

SELECT sal
FROM emp;


-- LIKE 연산자 : %와_ 와일드카드만 사용가능하다.
-- REGEXP_LIKE 함수 : 정규표현식 전부 사용가능
-- 문제 : insa테이블에서 성이 김씨, 이씨 만 사원 조회

SELECT *
FROM insa
WHERE REGEXP_LIKE (ssn, '^7[0-9]12');
WHERE REGEXP_LIKE (name, '^[^김이]');-- 김 또는 이로 이름이 시작하지 않는 사람
WHERE REGEXP_LIKE (name, '[경자]$'); -- 경 또는 자로 끝나는 사람
WHERE REGEXP_LIKE (name, '^(김|이)');
WHERE REGEXP_LIKE (name, '^[김이]');
WHERE name LIKE '김%' OR name LIKE '이%';
WHERE SUBSTR(name, 1, 1) IN ( '김', '이');
WHERE SUBSTR(name, 1, 1) = '김' OR SUBSTR(name, 1, 1) = '이';


-- 70년대 남자 사원만 조회
-- 오라클 나머지 구하는 함수 MOD()
SELECT *
FROM insa
--WHERE REGEXP_LIKE( ssn , '7[0-9]12') AND SUBSTR(ssn, 8,1) = 1; -- 주민등록 번호는 1, 3, 5, 7, 9일때 남자
--WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn, 8, 1), 2) = 1;
WHERE REGEXP_LIKE(ssn, '^7\d{5}-[13579]');