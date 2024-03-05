-- SCOTT

-- 1 insa 테이블에서 각 부서별 사원 수 조회


DESC insa;

SELECT DISTINCT buseo
FROM insa;

SELECT COUNT(*)
FROM insa
WHERE buseo LIKE '총무부'
UNION
SELECT COUNT(*)
FROM insa
WHERE buseo LIKE '영업부'
UNION
SELECT COUNT(*)
FROM insa
WHERE buseo LIKE '개발부'
UNION
SELECT COUNT(*)
FROM insa
WHERE buseo LIKE '기획부'
UNION
SELECT COUNT(*)
FROM insa
WHERE buseo LIKE '인사부'
UNION
SELECT COUNT(*)
FROM insa
WHERE buseo LIKE '자재부'
UNION
SELECT COUNT(*)
FROM insa
WHERE buseo LIKE '홍보후';


SELECT buseo, COUNT(*) CNT
FROM insa
GROUP BY buseo;


-- [2] 문제 : emp 테이블에서 급여의 순서(rank)
WITH t AS
    (
    SELECT ename, deptno, empno, sal+NVL(comm, 0)
    ,RANK() OVER(ORDER BY sal+NVL(comm, 0) DESC) rank
    FROM emp 
    )
SELECT t.*
FROM t
WHERE rank <= 3;


SELECT e.*
FROM (
    SELECT ename, deptno, empno, sal+NVL(comm, 0)
    ,RANK() OVER(ORDER BY sal+NVL(comm, 0) DESC) rank
    FROM emp 
    ) e
WHERE rank BETWEEN 3 AND 5;
WHERE rank <= 3;


SELECT 
    (SELECT COUNT(*)+1 FROM emp c WHERE c.sal+NVL(comm, 0) > p.sal+NVL(p.comm, 0)) pay_rank
    , p.*
FROM emp p
ORDER BY pay_rank;

-- TOP N 방식
SELECT ROWNUM ,e.*
FROM (
    SELECT *
    FROM emp
    ORDER BY sal+NVL(comm, 0) DESC
)e
WHERE ROWNUM <= 3;

-- [3] insa 테이블에서 남자사원수, 여자사원수 조회
SELECT DECODE(MOD(SUBSTR(ssn, 8, 1),2), 1, '남자사원수', 0, '여자사원수') GENDER
    , COUNT(*) CNT
FROM insa
GROUP BY MOD(SUBSTR(ssn, 8, 1),2)
UNION
SELECT '전체사원수',COUNT(*)
FROM insa;

-- [4] emp 테이블 각 부서별 사원 수 조회
SELECT e.deptno, ename, dname, hiredate
FROM dept d JOIN emp e ON d.deptno = e.deptno;


SELECT d.dname, COUNT(*)
FROM dept d JOIN emp e ON e.deptno = d.deptno
GROUP BY d.dname
--ORDER BY dname  ORA-00933: SQL command not properly ended : 문법적 오류 // ORDER BY절은 항상 UNION의 마지막에 와야한다.
UNION ALL
SELECT 'OPERATIONS', COUNT(*)
FROM emp 
WHERE deptno = 40;



SELECT dname, COUNT(empno)
FROM  dept d LEFT OUTER JOIN emp e  ON d.deptno = e.deptno
GROUP BY dname;

SELECT COUNT(*)
    , COUNT(empno)
    , COUNT(comm)
    , COUNT(hiredate)
FROM emp;


-- [3] insa 테이블에서 남자사원수, 여자사원수 조회
-- DECODE에 1이 아닌 사람은 NULL로 처리되고 COUNT에서 NULL값은 제외되니까 남자인 사원만 나온다.
SELECT COUNT(*)
    , COUNT( DECODE ( MOD( SUBSTR ( ssn, 8, 1), 2), 1, '남자') ) "남자 사원수"
    , COUNT( DECODE ( MOD( SUBSTR ( ssn, 8, 1), 2), 0, '여자') ) "여자 사원수"
FROM insa;



SELECT COUNT(*)
    , COUNT( DECODE ( deptno, 10, 'o') ) "10번 사원수"
    , COUNT( DECODE ( deptno, 20, 'o') ) "20번 사원수"
    , COUNT( DECODE ( deptno, 30, 'o') ) "30번 사원수"
    , COUNT( DECODE ( deptno, 40, 'o') ) "40번 사원수"
FROM emp;

-- [5] 문제 : insa 테이블에서 생일 후, 생일 전, 오늘이 생일인 사람

WITH t AS(
    SELECT TO_CHAR(SUBSTR(ssn, 3, 4), 'MMDD') ssn
    FROM insa
    )
SELECT t.*
FROM t;

SELECT SYSDATE
    , TO_CHAR( SYSDATE, 'MMDD')
FROM dual;


UPDATE insa
SET ssn = SUBSTR(ssn, 1, 2) || TO_CHAR( SYSDATE, 'MMDD') || SUBSTR(ssn, 7)
WHERE num IN (1001, 1002);
COMMIT;

SELECT num, name, ssn
    , SIGN(TO_DATE(SUBSTR (ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)) s
    , DECODE(SIGN(TO_DATE(SUBSTR (ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)), 1, '생일전', 0, '오늘생일', '생일후') r
    , CASE SIGN(TO_DATE(SUBSTR (ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)) WHEN 1 THEN '생일전'
        WHEN 0 THEN '생일'
        ELSE '생일후'
        END c
    , CASE 
        WHEN SIGN(TO_DATE(SUBSTR (ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)) > 0 THEN '생일전'
        WHEN SIGN(TO_DATE(SUBSTR (ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)) = 0 THEN '생일'
        ELSE '생일후'
        END 별칭1
FROM insa;


-- [5-2] emp 테이블에서 10번 부서원 sal 10%인상, 20번 부서원, 15%d인상, 그외 5%인상

WITH t AS
    (
    SELECT ename, empno, deptno, sal, comm, sal + NVL(comm, 0) pay
    FROM emp
    )   
SELECT t.ename, t.empno, t.deptno, t.pay
    , CASE t.deptno
        WHEN 10 THEN t.pay*1.1
        WHEN 20 THEN t.pay*1.15
        ELSE t.pay*1.05
        END s
    , DECODE( deptno, 10, t.pay*1.1, 20, t.pay*1.15, t.pay*1.05) r
    , t.sal * DECODE( deptno, 10, 1.1, 20, 1.15, 1.05) t
FROM t;


-- [문제] insa 테이블에서 총사원수, 생일전사원수, 오늘생일, 생일 지난 사원수


    
SELECT 
     COUNT(DECODE(SIGN(TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)), 0, '생일')) "생일인 사원"
     ,COUNT(DECODE(SIGN(TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)), 1, '생일전')) "생일전 사원"
     ,COUNT(DECODE(SIGN(TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)), -1, '생일후')) "생일후 사원"
     ,COUNT(ssn) "총사원 수"
FROM insa;


SELECT COUNT(*)
    , COUNT( DECODE(s, 1, 'o')) "생일전 사원수"
    , COUNT( DECODE(s, 0, 'o')) "생일사원수"
    , COUNT( DECODE(s, -1, 'o')) "생일후 사원수"
FROM (
    SELECT num, name, ssn
        , SIGN( TO_DATE( SUBSTR( ssn, 3, 4) , 'MMDD') - TRUNC(SYSDATE)) S
        FROM insa
    ) t;
    
    
    
SELECT
    CASE S
        WHEN 1 THEN '생일전'
        WHEN 0 THEN '생일'
        ELSE '생일후'
    END 생일체크
    , COUNT(*) 사원수
FROM (
    SELECT num, name, ssn
        , SIGN( TO_DATE( SUBSTR( ssn, 3, 4) , 'MMDD') - TRUNC(SYSDATE)) S
        FROM insa
    ) t
GROUP BY s;


-- [문제] emp 테이블에서 평균 pay 보다 같거나 많은 사원들의 급여합을 출력

WITH a AS 
    (
    SELECT TO_CHAR(AVG(sal + NVL(comm, 0)), '9999.00') AVG_PAY
    FROM emp
    )
    , b AS
    (
    SELECT empno, ename, sal + NVL(comm, 0) pay
    FROM emp
    )
SELECT SUM(a.AVG_PAY) -- 평균 급여보다 많이 받는 사람들의 급여합
FROM a, b
WHERE b.pay > a.AVG_PAY; 


SELECT 
    SUM (DECODE ( SIGN ( pay - avg_pay )  , 1 , pay )) s
    , SUM (
        CASE
            WHEN  pay - avg_pay > 0 THEN pay
            ELSE NULL
        END 
        ) e
FROM (
    SELECT empno, ename, sal + NVL(comm, 0) pay
        , (SELECT ROUND( AVG(sal+NVL(comm, 0)), 2) FROM emp) avg_pay
        FROM emp
    );

-- [문제] emp , dept 테이블을 사용해서
-- 부서원이 존재하지 않는 부서의 부서번호와 부서명 출력


SELECT dname, d.deptno 
FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
--FROM emp e INNER JOIN dept d ON d.deptno = e.deptno -- JOIN에 아무것도 안주면 INNER JOIN이 default값
WHERE e.deptno IS NULL;


SELECT t.*
FROM (
    SELECT  dname , d.deptno ,COUNT(empno) cnt
    FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno , dname
    ORDER BY d.deptno ASC
    ) t
WHERE t.cnt = 0;


WITH t AS   (
    SELECT deptno
    FROM dept
    MINUS
    SELECT DISTINCT deptno
    FROM emp
    )
SELECT dname, d.deptno
FROM t JOIN dept d ON d.deptno = t.deptno;

SELECT *
FROM dept d JOIN (
    SELECT deptno
    FROM dept
    MINUS
    SELECT DISTINCT deptno
    FROM emp
    ) t ON t.deptno = d.deptno;

SELECT p.deptno, p.dname
FROM dept p
WHERE NOT EXISTS ( SELECT empno FROM emp WHERE deptno = p.deptno) ;
WHERE ( SELECT COUNT(*) FROM emp WHERE deptno = p.deptno) = 0 ;


--WITH
--SELECT 
--FROM
--WHERE
--GROUP BY
--HAVING
--ORDER BY

SELECT d.deptno, d.dname, COUNT(empno) cnt
FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno
 -- WHERE cnt = 0  -- ORA-00904: "CNT": invalid identifier
GROUP BY d.deptno, d.dname
HAVING COUNT(empno) = 0
ORDER BY d.deptno;

-- [문제] insa 테이블에서 각 부서별 여자사원수를 파악해서 5명 이상인 부서 정보 출력
-- 영업부 7
-- 총무부 5





SELECT buseo, COUNT(*) cnt
FROM insa
WHERE MOD(SUBSTR (ssn, 8, 1) , 2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5
ORDER BY cnt DESC;



SELECT *
FROM insa;


-- emp 테이블에서 부서별, job별 사원의 급여 총합을 조회

SELECT deptno , job , SUM(sal + NVL(comm, 0)) deptno_pay_sum
    , COUNT(*) cnt
    , AVG(sal + NVL(comm, 0))
    , MAX(sal + NVL(comm, 0))
FROM emp
GROUP BY deptno, job
ORDER BY deptno, deptno_pay_sum;


-- ( 암기 ) PARTITION OUTER JOIN 구문
-- PARTITION BY(deptno) : 부서정보로 파티션 나눠서 모든 부서가 전부 나오도록 출력
WITH t AS (
            SELECT DISTINCT job
            FROM emp
          )
SELECT deptno, t.job, NVL(SUM(sal+NVL(comm, 0)),0) pay_sum
FROM t LEFT OUTER JOIN emp e PARTITION BY(deptno) ON t.job = e.job
GROUP BY deptno, t.job
ORDER BY deptno;


SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno

SELECT job, COUNT(*)
FROM emp
GROUP BY job;

-- GROUPING SETS 절
SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY GROUPING SETS(deptno, job);

SELECT ename
FROM emp
WHERE deptno = 10;

SELECT ename
FROM emp
WHERE deptno = 20;

SELECT ename
FROM emp
WHERE deptno = 30;

-- [ LISTAGG 함수 ]
-- 암기 해두기
SELECT d.deptno, COUNT(ename)
    , NVL(LISTAGG(ename, ',') WITHIN GROUP ( ORDER BY ename ), '사원이 없습니다') "SAWON"
FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno;

SELECT ename, sal
    , CASE 
        WHEN sal BETWEEN 700 AND 1200 THEN 1
        WHEN sal BETWEEN 1201 AND 1400 THEN 2
        WHEN sal BETWEEN 1401 AND 2000 THEN 3
        WHEN sal BETWEEN 2001 AND 3000 THEN 4
        WHEN sal BETWEEN 3001 AND 9999 THEN 5
      END grade
FROM emp;

SELECT *
FROM salgrade;

SELECT ename, sal, grade, losal ||'~'|| hisal
FROM emp , salgrade 
WHERE sal BETWEEN losal AND hisal;
-- NON EQUL JOIN + INNER JOIN ( 둘 다 해당하는 JOIN구문)
SELECT ename, sal, grade, losal || '~' || hisal
FROM emp  JOIN salgrade ON sal BETWEEN losal AND hisal;


SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d12*-\d*');
WHERE ssn LIKE '7%' ;



-- 순위 함수 
-- 1) RANK() : 같은값이 2명이상 있을 경우 등수가 같고 그 다음등수가 그 등수 많큼 +되어서 출력된다. 9 9 11
-- 2) DENSE_RANK() : 같은 값이 2명 이상 있을경우 등수가 같고 그 다음등수가 그냥 출력된다. 9 9 10
-- 3) PERCENT_RANK() 
-- 4) ROW_NUMBER() : 같은값이 2명 이상 있어도 등수가 다르게 나온다 9 10 11
-- 5) FIRST()/LAST()

-- [문제] emp 테이블에서 sal 순위 매겨보자,

SELECT empno, ename, sal
    , RANK() OVER( ORDER BY sal DESC) r_rank
    , DENSE_RANK() OVER(ORDER BY sal DESC) d_rank
    , ROW_NUMBER()  OVER(ORDER BY sal DESC) rn_rank
    , PERCENT_RANK() OVER(ORDER BY sal DESC) p_rank
FROM emp;

-- partition by 구문 사용하면 각 부서별로 등수 매겨준다.
SELECT empno, ename, sal
    , RANK() OVER( PARTITION BY deptno ORDER BY sal DESC) r_rank
    , DENSE_RANK() OVER( PARTITION BY deptno ORDER BY sal DESC) d_rank
    , ROW_NUMBER()  OVER( PARTITION BY deptno ORDER BY sal DESC) rn_rank
    , PERCENT_RANK() OVER( PARTITION BY deptno ORDER BY sal DESC) p_rank
FROM emp;

-- [ 문제 ] emp 테이블에서
-- 각 사원의 급여를 전체 순위, 부서내 순위를 출력,

SELECT deptno, empno, ename, sal
    , DENSE_RANK() OVER( ORDER BY sal DESC) all_rank
    , DENSE_RANK() OVER( PARTITION BY deptno ORDER BY sal DESC) dept_rank
FROM emp
ORDER BY deptno;

-- ROLLUP / CUBE 연산자
-- insa 테이블에서 
-- 남자 사원수 : 31명
-- 여자 사원수 : 29명
-- 전체 사원수 : 60명

WITH t AS
    (
    SELECT MOD(SUBSTR(ssn, 8, 1),2) GENDER FROM insa
    )
SELECT 
      COUNT(DECODE( t.GENDER , 1 , 'O')) "남자사원수"
    , COUNT(DECODE( t.GENDER , 0 , 'O')) "여자사원수"
    , COUNT(t.GENDER) "전체사원수"
FROM t;

SELECT
     DECODE(MOD(SUBSTR(ssn, 8, 1),2), 1 , '남자' ,'여자') GENDER 
    , COUNT(DECODE( MOD(SUBSTR(ssn, 8, 1),2), 1, '남자사원수', '여자사원수')) 사원수
FROM insa t
GROUP BY MOD(SUBSTR(ssn, 8, 1),2)
UNION 
SELECT DISTINCT '전체', (SELECT COUNT(*) FROM insa)
FROM insa;



SELECT
     DECODE( MOD(SUBSTR(ssn, 8, 1),2), 1, '남자', 0, '여자', '전체')||'사원수' GENDER
    , COUNT(*) "사원수"
FROM insa
GROUP BY CUBE(MOD(SUBSTR(ssn, 8, 1),2));
GROUP BY ROLLUP(MOD(SUBSTR(ssn, 8, 1),2));


-- 예제

SELECT buseo, jikwi
    , COUNT(*) cnt
    , SUM ( basicpay)
FROM insa
GROUP BY buseo, ROLLUP(jikwi)
--GROUP BY ROLLUP(buseo, jikwi)
--GROUP BY CUBE(buseo, jikwi)
ORDER BY buseo;


-- emp 테이블에서 가장 빨리 입사한 사원과 가장 늦게 입사한 사원의 정보


SELECT  
      MAX(hiredate) max
    , MIN(hiredate) min
    , MIN(hiredate) - MAX(hiredate)  "DATE"
FROM emp;



SELECT ename, hiredate 
FROM emp
ORDER BY hiredate DESC;


-- 문제 insa 테이블에서 각 사원들의 만 나이를 계산해서 출력
-- 1) 만나이 = 올해년도 - 생일년도 (생일 지나지 x -1)
--         ㄱ. 생일 지났는지 여부
--         ㄴ. 981012-xxxxxxx
--              12 1900, 34 2000, 89 1800


