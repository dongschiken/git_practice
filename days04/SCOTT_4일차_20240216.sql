-- SCOTT   

SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7[0-9]12\d-[13579]');

SELCECT *
FROM empl;

SELECT *
FROM insa;

SELECT *
FROM insa
WHERE EXTRACT( YEAR FROM TO_DATE(SUBSTR(ssn, 1, 6))) BETWEEN '1970' AND '1979';

SELECT DISTINCT BUSEO
FROM insa
ORDER BY buseo ASC;

SELECT ssn 
    , SUBSTR(ssn, 1, 2) YEAR
    , SUBSTR(ssn, 3, 2) MONTH
    , SUBSTR(ssn, 5, 2) "DATE"
    , SUBSTR(ssn, 8, 1) GENDER
FROM insa;


SELECT *
FROM emp;

SELECT ename, hiredate
    , TO_CHAR( hiredate, 'YYYY') YEAR
    , SUBSTR(hiredate, 4, 2) MONTH
    , SUBSTR(hiredate, 7, 2) "DATE"
    , TO_CHAR(hiredate, 'DD') "DATE2"
    , TO_CHAR(hiredate, 'DDD') "DATE3" -- 연중에 몇일 째?
    , TO_CHAR(hiredate, 'D') "DATE4"   -- 그 주에 몇일째?
FROM emp;


SELECT name, ssn
FROM insa
--WHERE ssn LIKE '7_12%'
WHERE REGEXP_LIKE( ssn, '^7?\d(12)')
ORDER BY ssn ASC;


SELECT *
FROM dept;

INSERT INTO dept VALUES( 50, 'QC', 'SEOUL' );

UPDATE dept
SET loc = 'POHANG', dname = dname || '2'
WHERE dname = 'QC';

SELECT name, ssn, 


SELECT *
FROM   (
    SELECT ename, sal + NVL(comm, 0) pay, deptno
    FROM emp
    ) t
WHERE t.pay BETWEEN 1000 AND 3000 AND t.deptno != 30;


SELECT name, ssn
    , MOD(SUBSTR(ssn, 8, 1), 2) GENDER
FROM insa
--WHERE ssn LIKE '7%' AND SUBSTR(ssn, 8, 1) IN (1, 3, 5, 7, 9);
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn, 8, 1), 2) = 1;


SELECT name, ssn
    , SUBSTR(ssn, 8, 1) || 'O' GENDER
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d*-[13579]');

SELECT ename
FROM emp
WHERE UPPER(ename) LIKE '%LA%';
--WHERE ename LIKE '%' || UPPER('la') || '%';

SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d*-[13579]');

SELECT *
FROM insa
WHERE CITY NOT IN ('서울', '경기', '인천');

SELECT temp.name, temp.ssn
    , REPLACE( REPLACE (temp.gender, 1, 'O'), 0, 'X') GENDER
FROM(
    SELECT name, ssn
    , MOD( SUBSTR (ssn, 8, 1), 2) GENDER
    FROM insa
) temp;

-- NULLIF(VALUE1, VALUE2)
-- VALUE1 == VALUE2 ==> NULL을 반환
-- VALUE1 != VALUE2 ==> 첫 값을 반환

SELECT ename,job
    ,lengthb(ename)
    ,lengthb(job),
NULLIF(lengthb(ename),lengthb(job)) nullif_result
FROM emp   
WHERE deptno=20;

SELECT name
    , LENGTH(name) -- 3
    , LENGTHB(name) -- 9 LENGTHB의 B는 바이트의 의미 (오라클에서 한글은 3바이트가 잡힌다)
FROM insa;

-- 함수들 많이 활용해 봐야한다.
SELECT name, ssn
    ,NVL2(NULLIF(MOD(SUBSTR(ssn, 8, 1), 2) , 1), 'O', 'X') GENDER
FROM insa;

SELECT *
FROM emp
WHERE REGEXP_LIKE(ename, 'king', 'i'); -- i의 의미 : 대소문자 상관없이

--
DESC insa;

SELECT name, ibsadate
    , TO_CHAR( ibsadate, 'YYYY.MM.DD') ibsadate2
    , TO_CHAR( ibsadate, 'YYYY') 
FROM insa
WHERE ibsadate >= '2000.01.01';
--WHERE TO_CHAR( ibsadate, 'YYYY') >= 2000;
WHERE EXTRACT( YEAR FROM ibsadate) >= 2000;

SELECT SYSDATE, CURRENT_TIMESTAMP
FROM dual;

DESC dual;

-- 산술 연산자
SELECT 5+3, 5-3, 5*3, 5/3, MOD(5,3)
-- SELECT 5/0 :  "divisor is equal to zero" 0으로 나눌 수 없다.
SELECT MOD(5,0)
FROM dual;


SELECT *
FROM emp;

-- SYNONYM 만드는 방법
-- ORA-00905: missing keyword
-- public SYNONYM은 DBA권한을 가진 스키마에서만 생성 가능하다.
CREATE PUBLIC SYNONYM scott.arirang
FOR scott.emp;

SELECT name, ssn
    ,CONCAT( SUBSTR( ssn, 1, 6) , SUBSTR( ssn, 8)) SSN
FROM insa;

-- REPLACE 함수 사용해서 바꾸기
SELECT name, ssn
--    ,CONCAT( SUBSTR( ssn, 1, 6) , SUBSTR( ssn, 8)) SSN
    ,REPLACE( ssn, '-', '') ssn
    ,REPLACE( ssn, '-') ssn -- 3번째 인자값 안주면 2번째 인자값 제거한다.
FROM insa;


SELECT 
     TO_DATE( '2024', 'YYYY')
    ,TO_DATE( '2024/03', 'YYYY/MM' )
    ,TO_DATE( '2024/05/21' )
FROM dual;

-- EX) 부서명 : QC100%T, 한글_나라

-- 18. insa 테이블에서 성이   김씨, 이씨 인 70년대 12월생의 사원만 조회.

SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE( name, '^[김이]') AND ssn LIKE '7_12%'; 

--WHERE dname LIKE '%\_%' ESCAPE '\';


-- 여기서 YY와 RR의 차이점
-- RR과 YY는 둘다 년도의 마지막 두자리를 출력해 주지만, 현재 system상의 세기와 나타내고자 하는 년도의 세기를 비교할 했을 때 출력되는 값이 다르다.
-- RR은 시스템상(1900년대)의 년도를 기준으로 하여 이전 50년도에서 이후 49년까지는 기준년도와 가까운 1850년도에서 1949년도까지의 값으로 표현하고, 
-- 이 범위를 벗아날 경우 다시 2100년을 기준으로 이전 50년도에서 이후 49년까지의 값을 출력한다.
-- YY는 무조건 system상의 년도를 따른다.

SELECT TO_CHAR( SYSDATE, 'CC') -- CC는 세기를 나타낸다 21세기
FROM dual;

SELECT
     TO_CHAR( TO_DATE('97/01/10', 'YY,MM.DD') , 'YYYY')  -- 2097
    ,TO_CHAR( TO_DATE('97/01/10', 'RR,MM.DD') , 'YYYY')  -- 1997
    ,TO_CHAR( TO_DATE('05/01/10', 'YY,MM.DD') , 'YYYY')  -- 2005
    ,TO_CHAR( TO_DATE('05/01/10', 'RR,MM.DD') , 'YYYY')  -- 2005
--SELECT TO_CHAR( '05/01/10', 'RR.MM.DD')
FROM dual;



SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
-- 1차적으로 ASC 정렬하고 그 후 PAY를 기준으로 내림차순 정렬 하겠다.
--ORDER BY 1 ASC , 3 DESC -- 1번 칼럼을 정렬 순서로 사용하겠다, 3번을 기준으로 DESC하겠다.
ORDER BY deptno ASC, pay DESC;

SELECT *
FROM emp
--WHERE sal >= null;
--WHERE sal != 1250;
--WHERE sal < 1250;
--WHERE sal <= 1250;
--WHERE sal > 1250;
--WHERE sal >= 1250;
WHERE sal = 1250;

ANY
SOME
ALL

-- emp 테이블에서 평균급여보다 많이 받는 사원들의 정보를 조회.
-- 1. emp 테이블의 평균 급여?

SELECT AVG( sal + NVL(comm, 0)) "AVG PAY"
FROM emp;

-- UNION을 통해 3개의 쿼리문을 합쳐서 출력
SELECT *
FROM emp
WHERE deptno = 10 AND sal + NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0)) avg_pay FROM emp WHERE deptno = 10)
UNION 
SELECT *
FROM emp
WHERE deptno = 20 AND sal + NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0)) avg_pay FROM emp WHERE deptno = 20)
UNION 
SELECT *
FROM emp
WHERE deptno = 30 AND sal + NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0)) avg_pay FROM emp WHERE deptno = 30);

     
-- [문제] 각 부서별 평균 급여보다 많이 받는 사원들의 정보를 조회

SELECT AVG( sal + NVL(comm, 0)) "10AVG PAY"
FROM emp
WHERE deptno = 10;  -- 2916.666666666666666666666666666666666667

SELECT AVG( sal + NVL(comm, 0)) "20AVG PAY"
FROM emp
WHERE deptno = 20;  -- 2258.333333333333333333333333333333333333

SELECT AVG( sal + NVL(comm, 0)) "30AVG PAY"
FROM emp
WHERE deptno = 30;  -- 1933.333333333333333333333333333333333333



-- ANY, ALL, SOME는 꼭 비교연산자와 함께 사용해야 한다.

-- 30번 부서의 최고 급여보다 많이 받는 사원들의 정보를 조회
SELECT *
FROM emp
WHERE sal + NVL(comm, 0) > ALL (SELECT sal + NVL(comm, 0) FROM emp WHERE deptno = 30);
WHERE sal + NVL(comm, 0) > (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 30);


SELECT ename,empno, deptno, job
FROM emp
WHERE deptno=10 AND job='CLERK';

SELECT ename,empno
FROM emp
WHERE deptno=10 OR job='CLERK';

SELECT ename,empno, deptno, job
FROM emp
WHERE deptno NOT IN(10,30);

WITH temp AS
    (
    SELECT sal + NVL(comm, 0) pay
    FROM emp
    ) 
SELECT MAX(t.pay), AVG(t.pay), SUM(t.pay), MIN(t.pay)
--FROM temp t; -- 네스티드 서브 쿼리
FROM ( SELECT sal + NVL(comm, 0) pay
       FROM emp) t -- 인라인 뷰
;

-- 상관 서브 쿼리
-- [문제] 사원 전체에서 최고 급여를 받는 사원의 정보를 조회  -  사원명, 사원번호, 급여액, 부서번호
SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
FROM emp
WHERE sal + NVL(comm, 0) ANY ( 
ORDER BY pay DESC;
-- [문제] 각 부서별 최고 급여를 받는 사원의 정보를 조회
-- 상관서브쿼리 : 서브쿼리가 메인쿼리에있는 값을 참조해서 사용하는 것
-- 10, 20, 30이 c에서 한개씩 참조되어서 max_pay를 출력해준다.
-- child와 parent의 관계로 c가 p를 참조하고 있는 상태 => p.deptno
SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
FROM emp p
WHERE sal + NVL(comm, 0) = ( SELECT MAX(sal + NVL(comm, 0) ) max_pay
                            FROM emp c
                            WHERE deptno = p.deptno);

SELECT *
FROM emp;

-- ******* not a single-group group function(중요한 에러메시지) : 단일행(일반 컬럼들 포함) 함수, 복수행(SUM(), COUNT(), AVG(), MOD())함수를 같이 사용했을 때 발생하는 오류
-- 스칼라 서브쿼리 SELECT deptno, ename, sal, ( SELECT AVG (sal) FROM emp WHERE deptno = t1.deptno) 사용해서 복수행 함수를 가져다 쓸 수 있다. 여기서도 관계서브 쿼리 이용해서 t1의 값을 대입해서 deptno에 따라 평균 출력
SELECT deptno, ename, sal, ( SELECT AVG (sal) FROM emp WHERE deptno = t1.deptno) deptno_avg_sal
FROM emp t1
WHERE sal > (SELECT avg(sal)
            FROM emp t2
            WHERE deptno = t1.deptno)
ORDER BY deptno ASC;


SELECT *
FROM insa;

-- ibsa날짜를 가져오기
WITH temp AS
    (
    SELECT TO_DATE(SUBSTR(ibsadate, 1, 2)) ibsadate FROM insa
    )
SELECT t.ibsadate
FROM temp t;


SELECT temp.ssn, CONCAT(ssn4, ssn3)
FROM 
    (
    SELECT ssn, SUBSTR(ssn, 1, 6) ssn3, SUBSTR(ssn, 8, 7) ssn4 FROM insa
    ) temp;


SELECT dname = temp.dname
FROM 
    (
    SELECT deptno, danme, loc FROM emp 
    WHERE  deptno = 20
    ) temp;


SELECT name, ibsadate
FROM insa
--WHERE TO_CHAR(ibsadate, 'YYYY') >= 2000
WHERE EXTRACT( YEAR FROM ibsadate) >= 2000
ORDER BY ibsadate ASC;





-- SSN으로 성별 찾아와서 남자는(1, 3, 5, 7, 9) O 여자는 X

SELECT temp.name ,REPLACE(REPLACE(temp.gender, 1, 'M'), 0, 'W') GENDER, temp.gender
FROM 
    (
    SELECT name, MOD(SUBSTR(ssn, 8, 1), 2) GENDER FROM insa
    ) temp
;
-- 18. insa 테이블에서 성이   김씨, 이씨 인 70년대 12월생의 사원만 조회.

SELECT *
FROM insa
WHERE REGEXP_LIKE( name, '^[김이]' ) AND REGEXP_LIKE( ssn, '^7\d12' );


-- emp 테이블에서 평균급여보다 많이 받는 사원들의 정보를 조회.
-- 1. emp 테이블의 평균 급여?

SELECT temp.avg_pay
FROM 
    (
    SELECT AVG( basicpay + sudang ) avg_pay FROM insa
    ) temp;

SELECT *
FROM insa p
WHERE basicpay > ( SELECT AVG(basicpay) max_pay FROM insa c WHERE buseo = p.buseo )
ORDER BY buseo ASC;

DESC insa;


-- ANY 어떤것 서브쿼리에서 여러개를 지정했을 때 그 조건을 비교할 때 하나라도 같은게 있다면 
-- ALL 모든것 서브쿼리에서 여러개를 지정했을 때 그 조건을 비교할 때 전부다 같으면 

-- ANY, ALL, SOME는 꼭 비교연산자와 함께 사용해야 한다.



-- [문제] 각 부서별 평균 급여보다 많이 받는 사원들의 정보를 조회

-- 30번 부서의 최고 급여보다 많이 받는 사원들의 정보를 조회



-- 서브 상관 쿼리
-- [문제] 사원 전체에서 최고 급여를 받는 사원의 정보를 조회  -  사원명, 사원번호, 급여액, 부서번호



-- [문제] 각 부서별 최고 급여를 받는 사원의 정보를 조회
-- 상관서브쿼리 : 서브쿼리가 메인쿼리에있는 값을 참조해서 사용하는 것
-- 10, 20, 30이 c에서 한개씩 참조되어서 max_pay를 출력해준다.
-- child와 parent의 관계로 c가 p를 참조하고 있는 상태 => p.deptno
