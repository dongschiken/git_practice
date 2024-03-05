-- 1) 만나이 계산하는 예제
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
    ) t
;

-- 오라클에서 임의의 난수를 가져오는 dbms_random 패키지(서로 관련된 PL/SQL(프로시저, 함수)들의 묶음

SELECT 
--    SYS.dbms_random.value+1       -- 0.0 ~  < 1 실수
--    SYS.dbms_random.value(0, 100) -- 0.0 ~  < 100 실수
--      SYS.dbms_random.string('L', 5) --소문자 5개
--      SYS.dbms_random.string('U', 5) --대문자 5개
--      SYS.dbms_random.string('A', 5) -- 알파벳 5개
--      SYS.dbms_random.string('X', 5) -- 대문자 + 숫자 5개
      SYS.dbms_random.string('P', 5) -- 대문자 + 숫자 + 특수문자
FROM dual;



SELECT
    CEIL(SYS.dbms_random.value(0, 100)) "국어점수"
  , CEIL(SYS.dbms_random.value(0.1, 45)) "로또번호"
FROM dual;



-- [ pivot 설명 ] 
-- 사전적 의미 : 축을 중심으로 회전시킨다.
-- 모니터의 가로 / 세로 회전
-- 오라클 11g버전부터 제공하는 함수 // 행과 열을 뒤집는 함수
-- 피벗 형식
SELECT * 
FROM (피벗 대상 서브쿼리문)
PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN(피벗컬럼 값 AS 별칭...));

-- [ 1 ] 문제 각 job별로 사원수 조회
SELECT job, COUNT(*) count
FROM emp
GROUP BY ROLLUP(job);

-- [ 2 ] 피벗 함수 사용해서 1번 문제의 열과 행을 바꾸기
SELECT *
FROM (
    SELECT job
    FROM emp
    )
PIVOT(COUNT(job) FOR job IN('CLERK', 'SALESMAN', 'MANAGER', 'ANALYST', 'PRESIDENT' ) );


-- [ 3 ] 피벗 함수 사용하지 않고 행과 열을 바꿔서 출력
SELECT 
     COUNT(DECODE(job, 'CLERK', 'O')) "CLERK"
    ,COUNT(DECODE(job, 'SALESMAN', 'O')) "SALESMAN"
    ,COUNT(DECODE(job, 'MANAGER', 'O')) "MANAGER"
    ,COUNT(DECODE(job, 'ANALYST', 'O')) "ANALYST"
    ,COUNT(DECODE(job, 'PRESIDENT', 'O')) "PRESIDENT"
FROM emp;


-- [ 4 ] 월별 입사한 사원의 수를 파악
SELECT *
FROM (
    SELECT TO_CHAR(hiredate, 'MM') month
    FROM emp
    )
PIVOT(COUNT(month) FOR month IN('12' AS "12월",'11' AS "11월" ,'09' AS "9월",'06' AS "6월" ,'05' AS "5월" ,'04' AS "4월" ,'02' AS "2월" ,'01' AS "1월"));


-- [ 5 ] 년도별 월별 입사한 사원의 수를 파악
SELECT *
FROM (
    SELECT
    TO_CHAR(hiredate, 'YYYY') year    
   ,TO_CHAR(hiredate, 'MM') month
    FROM emp
    )
PIVOT(COUNT(month) FOR month IN('12' AS "12월",'11' AS "11월" ,'09' AS "9월",'06' AS "6월" ,'05' AS "5월" ,'04' AS "4월" ,'02' AS "2월" ,'01' AS "1월"));


-- [ 6 ] emp 테이블에서 각 부서별, job의 사원수를 조회


SELECT *
FROM emp;

SELECT deptno, job
    , COUNT(*)
FROM emp
GROUP BY deptno, job;


SELECT *
FROM (
    SELECT job, d.deptno , dname
    FROM emp RIGHT OUTER JOIN dept d ON d.deptno = emp.deptno
    ) 
PIVOT(COUNT(job) FOR job IN ('MANAGER', 'CLERK', 'SALESMAN', 'PRESIDENT', 'ANALYST'))
ORDER BY deptno;



SELECT *
FROM (
    SELECT 
        d.deptno
        ,dname
        ,job
    FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
    )
PIVOT( COUNT(job) FOR job IN ('CLERK', 'SALESMAN', 'MANAGER', 'ANALYST', 'PRESIDENT' ) ) 
ORDER BY deptno ASC;



-- 각 부서의 직업별 sal의 총합 구하기
SELECT *
FROM
    (
    SELECT sal, job, deptno
    FROM emp
    )
PIVOT(SUM(sal) FOR deptno IN('10', '20', '30'));

SELECT *
FROM 
    (
    SELECT sal, deptno, job
    FROM emp
    )
PIVOT(SUM(sal) AS sum_sal, MAX(sal) AS max_sal FOR deptno IN ('10', '20', '30'));





SELECT *
FROM 
    (  
    SELECT job, deptno, sal
    FROM emp
    )
PIVOT( SUM(sal) FOR deptno IN( '10', '20', '30'));



-- 
SELECT *
FROM 
    (  
    SELECT job, deptno, sal, ename
    FROM emp
    )
PIVOT( SUM(sal) AS 합계, MAX(sal) 최고액, MAX(ename) AS 최고연봉 FOR deptno IN( '10', '20', '30'));




-- 
SELECT 
    d.deptno
    ,dname
    ,job
FROM emp e, dept d
--WHERE e.deptno (+)= d.deptno;  --(+)기호의 의미 RIGHT OUTER JOIN을 하겠다는 의미
WHERE e.deptno = d.deptno(+) ;   --(+)기호의 의미 LEFT OUTER JOIN을 하겠다는 의미
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno



-- 문제 emp 테이블에서 sal가 상위 20%에 해당하는 사원의 정보를 조회


SELECT t.*
FROM 
    (
    SELECT ename, empno, deptno
        , RANK() OVER(ORDER BY sal) RANK_sal
    FROM emp
    ) t
WHERE t.rank_sal <= TRUNC((SELECT COUNT(*) FROM emp)*0.2);





--TRUNC(2.8)
SELECT t.ename, t.empno
FROM (
    SELECT ename, empno,
        RANK() OVER(ORDER BY sal DESC) rank
    FROM emp
    ) t
WHERE t.rank <= (SELECT COUNT(*) FROM emp)*0.2;


-- 문제 emp 에서 각 사원의 급여가 전체급여의 몇 %가 되는 지 조회.
--       ( %   소수점 3자리에서 반올림하세요 )
--            무조건 소수점 2자리까지는 출력.. 7.00%,  3.50%     








SELECT ename, sal
    , (SELECT SUM(sal) sal FROM emp) TOTAL_PAY
    , TO_CHAR(ROUND(sal/(SELECT SUM(sal) sal FROM emp)*100,2), '999.00') || '%' "sum_sal%"
FROM emp;


SELECT *
FROM insa;
--     [총사원수]      [남자사원수]      [여자사원수] [남사원들의 총급여합]  [여사원들의 총급여합] [남자-max(급여)] [여자-max(급여)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400                  2650000          2550000

WITH t AS
    (
    SELECT (SELECT COUNT(*) FROM insa) cnt
        , ssn
        ,  DECODE(MOD(SUBSTR(ssn, 8, 1),2), 0, 'O') "여자"
        ,  DECODE(MOD(SUBSTR(ssn, 8, 1),2), 1, 'O') "남자"
        , basicpay
    FROM insa
    )
SELECT t.cnt "총사원수"
        , COUNT(t."여자") "여자사원수" 
        , COUNT(t."남자") "남자사원수"
        , SUM(DECODE(t."여자", 'O' , basicpay)) "여사원의 총급여합"
        , SUM(DECODE(t."남자", 'O' , basicpay)) "남사원의 총급여합"
        , MAX(DECODE(t."여자", 'O' , basicpay)) "여자 급여 MAX"
        , MAX(DECODE(t."남자", 'O' , basicpay)) "남자 급여 MAX"
FROM t
GROUP BY t.cnt;


-- 문제 -- [문제] 순위(RANK) 함수 사용해서 풀기 
--   emp 에서 각 부서별 최고급여를 받는 사원의 정보 출력
--   
--    DEPTNO ENAME             PAY DEPTNO_RANK
------------ ---------- ---------- -----------
--        10 KING             5000           1
--        20 FORD             3000           1
--        30 BLAKE            2850           1
SELECT *
FROM (
    SELECT ename, deptno, sal+NVL(comm, 0),
        RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm, 0) DESC) rank
    FROM emp
    ORDER BY deptno
    )
WHERE rank = 1;



WITH t AS 
    (
    SELECT deptno
        , MAX(sal+NVL(comm,0)) max_pay
    FROM emp
    GROUP BY deptno
    )
SELECT t.*
FROM t;

CREATE TABLE DEPT
(
  DEPTNO  NUMBER(2),
  DNAME   VARCHAR2(14 BYTE),
  LOC     VARCHAR2(13 BYTE)
)
;
INSERT INTO DEPT VALUES(10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES(20, 'RESEARCH', 'DALLAS');
INSERT INTO DEPT VALUES(30, 'SALES', 'CHICAGO');
INSERT INTO DEPT VALUES(40, 'OPERATIONS', 'BOSTON');
COMMIT;







-- 문제 -- [문제] 순위(RANK) 함수 사용해서 풀기 
--   emp 에서 각 부서별 최고급여를 받는 사원의 정보 출력
SELECT t.deptno, e.ename, t.max_pay, 1 deptno_rank
FROM 
    (
    SELECT deptno
        , MAX(sal+NVL(comm,0)) max_pay
    FROM emp
    GROUP BY deptno
    ) t , emp e
WHERE t.deptno = e.deptno AND t.max_pay = (e.sal+NVL(e.comm, 0))
ORDER BY e.deptno ASC;



-- 문제 -- [문제] 순위(RANK) 함수 사용해서 풀기 
--   emp 에서 각 부서별 최고급여를 받는 사원의 정보 출력
SELECT t.deptno, t.ename, t.pay, t.pay_rank1, t.pay_rank2
FROM (
    SELECT deptno, ename
        , sal + NVL(comm, 0) pay
        , RANK() OVER(ORDER BY sal +NVL(comm, 0) DESC) pay_rank1
        , RANK() OVER(PARTITION BY deptno ORDER BY sal +NVL(comm, 0) DESC) pay_rank2
    FROM emp
    ORDER BY deptno
    ) t
WHERE t.pay_rank2 = 1
ORDER BY deptno;


-- 문제 emp 테이블에서 각 부서의 사원수, 부서 총급여합, 부서 평균급여
WITH s AS(
    SELECT d.deptno, t."부서원수", t."총급여합", t. "평균"
    FROM (
    SELECT deptno
        , COUNT(deptno) "부서원수"
        , SUM(sal+NVL(comm,0))  "총급여합"
        , ROUND(AVG(sal+NVL(comm,0)),2) "평균"
    FROM emp
    GROUP BY deptno
        ) t RIGHT OUTER JOIN dept d ON t.deptno = d.deptno
    )
SELECT
     s.deptno
    , NVL(s."평균", 0) "평균"
    , NVL(s."부서원수", 0) "부서원수"
    , NVL(s."총급여합", 0) "총급여합"
FROM s
ORDER BY s.deptno;



SELECT d.deptno
    , COUNT(*) 부서원수
    , NVL(SUM(sal+NVL(comm,0)),0)  "총급여합"
    , NVL(ROUND(AVG(sal+NVL(comm,0)),2),0) "평균"
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno
GROUP BY d.deptno
ORDER BY d.deptno ASC;
--FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
--GROUP BY d.deptno
--ORDER BY d.deptno ASC;


SELECT buseo, city, COUNT(*)
FROM insa
GROUP BY buseo, city
ORDER BY buseo;

SELECT t.city, t.buseo
FROM (
    SELECT DISTINCT city
        , buseo
    FROM insa
    ORDER BY city ASC
    ) t PARTITION BY(buseo) LEFT OUTER JOIN insa i  ON i.buseo = t.buseo
GROUP BY t.buseo, t.city
ORDER BY t.buseo;



WITH c AS 
    (
    SELECT DISTINCT city
    FROM insa
    )
SELECT buseo, c.city, COUNT(NUM)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN c  ON i.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;


-- 문제 


SELECT (SELECT COUNT(*) FROM insa) "총사원수" , COUNT(buseo) "부서사원수"
       , COUNT(DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '남자')) "남자 사원수"
       , COUNT(DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 0, '여자')) "여자 사원수"
       , 
FROM insa
GROUP BY buseo;




SELECT s.*
    , ROUND(s.부서사원수/s.총사원수 * 100, 2) || '%' " 부/전%"
    , ROUND(s.성별인원수/s.총사원수 * 100, 2) || '%' " 총/성%"
    , ROUND(s.성별인원수/s.부서사원수 * 100, 2) || '%' " 부/전%"
FROM (
SELECT t.buseo
    , (SELECT COUNT(*) FROM insa) "총사원수"
    , t.gender 성별
    , COUNT(t.gender) "성별인원수"
    , (SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) "부서사원수"
FROM (
SELECT buseo, name, ssn
    , DECODE(MOD(SUBSTR(ssn, 8, 1),2), 1, 'M', 'F') gender
FROM insa   
    ) t
GROUP BY buseo, gender
ORDER BY buseo, gender
    ) s;
    
-- 문제 SMS 인증번호 임의의 6자리 숫자 발생
SELECT CEIL(SYS.dbms_random.value(1, 6))
    , TRUNC(SYS.dbms_random.value(100000, 1000000)) SMS6자리
    , TRUNC(SYS.dbms_random.value(LPAD(10000, 6, 0), 1000000)) SMS6자리
    , TO_CHAR(TRUNC(SYS.dbms_random.value(10000, 1000000)), '099999') SMS6자리
FROM dual;


-- 문제 LISTAGG 함수S
SELECT d.deptno, NVL(t.list, '사원없음') list
FROM (
    SELECT LISTAGG(ename, '/') WITHIN GROUP(ORDER BY ename) list
    , deptno
    FROM emp
    GROUP BY deptno
    ) t RIGHT OUTER JOIN dept d ON d.deptno = t.deptno
ORDER BY d.deptno


-- LISTAGG 함수 기본 구조
SELECT LISTAGG(대상컬럼, '구분문자') WITHIN GROUP (ORDER BY 정렬기준컬럼) 
FROM TABLE명 ;

SELECT
    d.deptno
    ,NVL(LISTAGG(ename, '/') WITHIN GROUP(ORDER BY ename),0) list
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno;


-- 문제 emp 테이블에서 30번 부서의 최고, 최저 sal을 받는 사원의 정보 조회
SELECT deptno, ename,
    (SELECT MAX(sal) max FROM emp WHERE deptno = 30)
    ,(SELECT MIN(sal) min FROM emp WHERE deptno = 30)
FROM emp
WHERE deptno = 30 ;


SELECT e.ename, e.sal
FROM (
    SELECT deptno
        , MAX(sal) max
        , MIN(sal) min
    FROM emp
    WHERE deptno = 30
    GROUP BY deptno
    HAVING deptno = 30
    ) t  RIGHT OUTER JOIN emp e ON t.deptno = e.deptno
WHERE e.sal = t.max OR e.sal = t.min AND e.deptno = 30;


SELECT t.*
FROM (
    SELECT deptno, ename, hiredate, sal,
        RANK() OVER(PARTITION BY deptno ORDER BY sal ASC) min
        ,RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) max
    FROM emp
    WHERE deptno = 30
    ) t
WHERE t.max = 1 or t.min = 1;
--        ,RANK() OVER(PARTITION BY deptno ORDER BY ename DESC) max
--    , t.max
-- 출력할 컬럼 : deptno, ename, hiredate, sal




-- 마지막 문제 emp 테이블에서 사원수가 가장 작은 부서명과 사원수, 사원수가 가장 많은 부서명과 사원수
SELECT DISTINCT t.*
FROM (
    SELECT  
         MAX(COUNT(*)) "가장많은 부서"
        , MIN(COUNT(*)) "가장작은 부서"
    FROM emp
    GROUP BY deptno
    ) t , emp e
ORDER BY deptno ASC;


-- 마지막 문제 emp 테이블에서 사원수가 가장 작은 부서명과 사원수, 사원수가 가장 많은 부서명과 사원수
-- 중요한 지문 다시 풀어보기
-- MAX, MIN은 행이 한개라서 GROUP BY절에서 사용할 수 없는 문제가 있음
-- 그냥 COUNT만 해놓고 이후에 나오는 쿼리에서 처리해야한다.
WITH t AS (
        SELECT d.deptno, dname, COUNT(empno) cnt
        FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
        GROUP BY d.deptno, dname
    )
SELECT dname, cnt
FROM t
WHERE cnt IN ( (SELECT MAX(cnt) FROM t) , (SELECT MIN(cnt) FROM t))
ORDER BY cnt;


-- WITH 절 이해
WITH a AS (
        SELECT d.deptno, dname, COUNT(empno) cnt
        FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
        GROUP BY d.deptno, dname
    ) 
    , b AS (
    SELECT MIN(cnt) mincnt, MAX(cnt) maxcnt
    FROM a
    )
SELECT a.dname, a.cnt
FROM a, b 
WHERE a.cnt IN (b.mincnt, b.maxcnt)
ORDER BY cnt;



SELECT t.deptno, t.cnt
FROM (
SELECT d.deptno, COUNT(empno) cnt
    , RANK() OVER(ORDER BY COUNT(empno) ASC) cnt_rank
FROM dept d LEFT JOIN emp e ON e.deptno = d.deptno
GROUP BY d.deptno
    ) t
WHERE t.cnt_rank  IN (1, 5);




-- 분석함수 : FIRST, LAST
-- 집계함수 (COUNT, SUM, AVG, MAX, MIN)들과 같이 사용하여 주어진 그룹에 대해 내부적으로 순위를 매겨 결과를 산출하는 함수
-- 통으로 암기하기
WITH a AS (
        SELECT d.deptno, dname, COUNT(empno) cnt
        FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
        GROUP BY d.deptno, dname
    ) 
SELECT MAX(cnt)
    , MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt ASC) max_dname
    , MIN(cnt)
    , MIN(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt ASC) min_dname
FROM a;



-- 분석함수 중에 CUME_DIST() : 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
                        -- 분포도값(비율) 0 < ? <= 1

SELECT deptno, ename, sal
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal ASC) dept_dist
    , CUME_DIST() OVER(ORDER BY sal ASC) dept_dist
FROM emp ;


-- 분석함수 중에 PERCENT_RANK() : 해당 그룹 내의 백분율 순위
--                      0 < ? <=1
-- 백분위 순위? : 그룹 안에서 해당 행의 값보다 작은 값의 비율
SELECT deptno, ename, sal
    , PERCENT_RANK() OVER(ORDER BY sal) PERCENT
    , PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal) PERCENT -- 각 부서에서의 sal 비율
FROM emp;



-- NTILE(expr) N타일 : 파티션 별로 expr에 명시된 만큼 불한한 결과를 반환하는 함수
-- 분할하는 수를 버킷 이라고 한다
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal) ntiles
FROM emp;



SELECT buseo, name, basicpay
    , NTILE(2) OVER(PARTITION BY buseo ORDER BY basicpay) ntiles
FROM insa;


-- WIDTH_BUCKET(expr, minvalue, maxvalue, numbuckets) == NTILE() // 두 함수는 유사한 분석함수
-- 두 함수의 차이점 : 최대값, 최소값을 설정 가능

SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal) ntiles
    , WIDTH_BUCKET(sal, 0, 5000, 4) widthbuckets
FROM emp;


-- 함수(컬럼명) 가져올 행의 위치 (offset) , 값이 없을때 기본값(default_value)
-- LAG() expr, offset, default_value
-- LAG() : 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수, 선행 참조 (앞에 행)
-- LEAD() expr, offset, default_value
-- LEAD() : 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수, 후행 참조 (뒤에 행)


SELECT deptno, ename, hiredate, sal
    , LAG(sal, 1, 0)OVER(ORDER BY hiredate) pre_sal
--    , LAG(sal, 2, -1)OVER(ORDER BY hiredate) pre_sal
    , LEAD(sal, 1, -1) OVER(ORDER BY hiredate) next_sal
    , LEAD(sal, 1, -1) OVER(ORDER BY hiredate) next_sal
FROM emp
WHERE deptno = 30;




-------------------------------------------------------------------------------- 함수 끝
-- 오라클 자료형(Data Type) --
1) CHAR : 문자(열) 저장하는 자료형
-- CHAR[SIZE BYTE | CHAR]

CHAR(3 CHAR) : 3 문자를 저장하는 자료형 // 'ABC' , '세글자'
CHAR(3 BYTE) : 3 바이트의 문자를 저장하는 자료형 // 'abc' , '한'  // 한글은 3바이트가 잡히기때문에 한글자만 줄 수 있다.
CHAR(3) == CHAR(3, BYTE)
--CHAR == CHAR(1) == CHAR(1 BYTE)
--고정 길이의 문자 자료형 : 사용하는 예 - 주민등록번호(14자리), 우편번호(5자리) 등등 문자열의 길이가 항상 같은(고정된) 값을 저장할 때 사용된다.
CHAR(14)
1바이트 ~ 2000바이트 까지 저장 가능

-- DDL
CREATE TABLE tbl_char
(
    aa CHAR
    , bb CHAR(3)
    , cc CHAR(3 CHAR)
);
-- Table TBL_CHAR이(가) 생성되었습니다.

DROP TABLE tbl_char ;
-- Table TBL_CHAR이(가) 삭제되었습니다.

SELECT *
FROM tabs
WHERE table_name LIKE '%CHAR%';

DESC tbl_char
-- 새로운 레코드를 추가(행을 추가)
 INSERT INTO tbl_char (aa, bb, cc) VALUES('a','aaa','aaa');
 INSERT INTO tbl_char (aa, bb, cc) VALUES('a','한','우리');
 -- SQL 오류: ORA-12899: value too large for column "SCOTT"."TBL_CHAR"."BB" (actual: 6, maximum: 3) 값이 너무 크다 실제 기억공간이 3인데 6의 값이 들어와서 생긴 문제
 INSERT INTO tbl_char (aa, bb, cc) VALUES('a','우리','우리');
COMMIT;

SELECT VSIZE('우'), VSIZE('a')
FROM dual;

SELECT *
FROM tbl_char;



2) NCHAR : 
NCHAR[size] == N + CHAR[size] -- N은 유니코드


CREATE TABLE tbl_nchar
(
    aa CHAR(3)
    , bb CHAR(3 CHAR)
    , cc NCHAR(3)
);
-- Table TBL_NCHAR이(가) 생성되었습니다.

INSERT INTO tbl_nchar (aa, bb, cc) VALUES('홍','길동','홍길동');
INSERT INTO tbl_nchar (aa, bb, cc) VALUES('홍길동','홍길동','홍길동');
COMMIT;

SELECT *
FROM tbl_nchar;

DROP TABLE tbl_nchar ;
--Table TBL_NCHAR이(가) 삭제되었습니다.


char(5 byte)    [a][b][c][][]
varchar2(5 byte)[a][b][c] 가변 길이
varchar2 = varchar2(1) == varchar2(1 byte) | 4000byte


4) NVARCHAR2(size)
-- 가변 길이
NVARCHAR2 == NVARCHAR2(1) == '한' , 'a'
4000 byte 까지 저장 가능