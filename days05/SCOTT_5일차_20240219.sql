-- SCOTT

-- 차집합
-- 교집합
-- 개발부 이면서 인천인 사원들을 파악

--[SET] 집합 연산자를 사용할 때 주의할 점
-- "expression must have same datatype as corresponding expression" : 수식은 동일한 자료형을 가져야한다.(두 칼럼을 비교할때 자료형이 다르면 오류가 발생)
-- ORA-01789: query block has incorrect number of result columns : 집합 연산자 사용할때 위의 SELECT 칼럼 수와 , 밑의 SELECT 칼럼 수가 달라서 발생하는 오류
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
UNION ALL
SELECT name, city --, jikwi--basicpay
FROM insa
WHERE city = '인천';

--[4]번 풀이 (합집합 연산자 사용) UNION : 17 , UNION ALL : 23
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
--UNION
UNION ALL
SELECT name, city, buseo
FROM insa
WHERE city = '인천';

--[3]번 풀이 (차집합 연산자 사용) MINUS : 9
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
MINUS
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
MINUS
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부';

--[2]번 풀이 (교집합 연산자 사용) INTERSECT : 6
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city = '인천';

--[1]번 풀이
SELECT *
FROM insa
WHERE buseo = '개발부' AND city = '인천';



-- insa 테이블의 사원정보 + emp 테이블의 사원 정보 모두 출력
SELECT buseo, num, name, ibsadate, basicpay, sudang
FROM insa
UNION ALL
SELECT TO_CHAR(deptno), empno, ename, hiredate, sal, comm
FROM emp;


-- 계층적 질의 연산자
-- PRIOR, CONNECT, BY_ROOT

-- 연결 연산자 ||

-- 산술 연산자 
-- +  -  /  *  
-- 나머지 구하는 연산자는 X
-- 나머지 구하는 함수는 
-- MOD(5, 3) 
-- REMAINDER(5, 3)


SELECT --10/0 -- ORA-01476: divisor is equal to zero
       --'A'/2 -- ORA-01722: invalid number
       MOD(10/0) -- ORA-00909: invalid number of arguments
FROM dual;

-- 오라클 함수
-- 1. 복잡한 쿼리문을 간단하게 해주고 데이터의 값을 조작하는데 사용되는 것
-- 2. 종류 : 단일행 함수, 복수행 함수
-- 단일행 함수 : 하나의 레코드 마다 한개의 결과값이 처리되는 함수
-- 복수행 함수 : 여러개의 레코드가 들어가도 한개의 결과값이 처리되는 함수

-- 집계함수는 일반 레코드와 함께 사용할 수 없다. => GROUP BY절 사용하면 집계함수와 일반 레코드 함께 사용할 수 있다.
-- 숫자 함수
-- 1) ROUND(number) 숫자값을 특정 위치에서 반올림하여 리턴한다. 
SELECT 3.141592
    , ROUND(3.141592)  -- 특정위치 index안주면 소수점 첫번째 자리에서 반올림
    , ROUND(3.141592, 0) -- 0을 주면 숫자 안준 상태와 같다
    , ROUND(3.141592, 2) -- 소수점 3번째 자리에서 반올림
    , ROUND(1234.5678, 2) d
    , ROUND(1234.5678, -1) e
    , ROUND(1234.5678, -2) f
    , ROUND(1234.5678, -3) g
FROM dual;

-- ORA-00937: not a single-group group function
--SELECT emp.*
--    , sal + NVL(comm, 0) pay
--    , COUNT(*)  사원수
--FROM emp

SELECT emp.*, (SELECT COUNT(*) FROM emp) cnt
            , (SELECT SUM(sal + NVL(comm, 0)) FROM emp)total_pay
            -- 평균 급여 계산해서 소수점 2자리까지 출력
            , (SELECT ROUND(AVG(sal + NVL(comm, 0)),2) FROM emp) AVG_PAY
FROM emp;

SELECT COUNT(*) -- NULL값을 포함한 갯수를 COUNT한다.
    , COUNT(empno)  --12
    , COUNT(deptno) --12
    , COUNT(sal)    --12
    , COUNT(hiredate) 
    , COUNT(comm) --4  null값이 포함된 컬럼은 null의 갯수는 체크되지 않는다. 
FROM emp;


-- 평균 comm이 얼마인지??
SELECT AVG(comm) -- 550 null인 값들은 포함하지 않고 평균계산
SELECT SUM(comm)/COUNT(*) -- 183.3333 null값들도 포함시켜서 평균계산
FROM emp;

-- 2) 절삭 함수 : TRUNC(날짜, 숫자), FLOOR(숫자) 
--TRUNC(number) 숫자값을 특정 위치에서 절삭하여 리턴한다. 
-- TRUNC : 날짜와 숫자 모두에서 절삭가능
--FLOOR 숫자값을 소숫점 첫째자리에서 절삭하여 정수값을 리턴한다. 
-- FLOOR : 숫자만 절삭가능
-- 차이점 1 : TRUNC(날짜, 숫자), FLOOR(숫자) 절삭 가능하다.
-- 차이점 2 : TRUNC()는 특정 위치에서 절삭이 가능하고, FLOOR()함수는 소수점 첫 째 자리에서 절삭가능하다.
SELECT 3.141592
    , TRUNC(3.141592)    -- 소수점 첫 번째 자리에서 절삭
    , TRUNC(3.141592, 0) -- 소수점 첫 번째 자리에서 절삭
    , TRUNC(3.141592, 3)
    , TRUNC(3.141592, -1)
    , FLOOR(3.141592 * 1000) / 1000 -- 소수점 세 번째 자리에서 절삭할 수 있는 방법
FROM dual;


-- CEIL 숫자값을 소숫점 첫째자리에서 올림하여 정수값을 리턴한다. 
-- 3) 절상 함수 : CELI() : 소수점 첫 번째 자리에서 올림(절상)하는 함수
SELECT CEIL(3.14), CEIL(3.54)
FROM dual;

-- 3.141592를 CEIL을 사용해서 소수점 세 번째 자리에서 올림하자.
SELECT CEIL( 3.141592 *100 ) / 100 ceil
FROM dual;

-- 게시판에서 총 페이지 수를 계산할 때 CEIL()함수를 사용한다.
-- 총 게시글(사원) 수
SELECT COUNT(*)
FROM emp;
-- emp 테이블에서 총 사원수에 다른 페이지 수 계산
-- 2.4 총 페이지 수를 계산했는데 소수점이면 올림 처리 해버린다. => 3
SELECT CEIL((SELECT COUNT(*) FROM emp) / 5)
FROM dual;


MOD 나머지값을 리턴한다. 

-- 4) ABS() 숫자값의 절대값을 리턴한다. 
SELECT ABS(100), ABS(-100)
FROM dual;


-- SIGN() : 숫자값의 부호에 따라 (양수)1, (0)0, (음수)-1의 값으로 리턴한다. 
SELECT SIGN(100), SIGN(-100), SIGN(0)
FROM dual;

-- 문제 : emp 테이블의 평균 급여를 구해서 각 사원의 급여(pay)가 평균 급여보다 많으면 '평균급여보다 많다'라고 출력 적으면 '평균급여보다 적다'라고 출력
SELECT AVG(sal+NVL(comm, 0))
FROM emp;

-- [3]
SELECT  ename, pay, avg_pay
        ,NVL2(NULLIF(SIGN(pay - avg_pay), 1 ), '적다' , '많다')
FROM (
    SELECT ename, sal+NVL(comm, 0) pay
            , (SELECT AVG( sal + NVL(comm, 0)) avg_pay FROM emp) avg_pay
            FROM emp
    );


-- [2]
SELECT ename, sal+NVL(comm, 0) pay
       , REPLACE(REPLACE( SIGN(sal+NVL(comm, 0) - (SELECT AVG(sal+NVL(comm, 0)) FROM emp)), -1, '적다'), 1, '많다') SIGN_PAY
FROM emp;

-- [1]
SELECT s.*, '많다'
FROM emp s
WHERE sal + NVL(comm, 0) > (SELECT AVG(sal+NVL(comm, 0)) FROM emp)
UNION
SELECT s.*, '적다'
FROM emp s
WHERE sal + NVL(comm, 0) < (SELECT AVG(sal+NVL(comm, 0)) FROM emp);

-- POWER(n1,n2) n1^n2한 지수곱값을 리턴한다. 
SELECT POWER(2,3), POWER(2, -3)
FROM dual;

SQRT(n) n의 제곱근 값을 리턴한다. 
SELECT SQRT(8)
FROM dual;


-- [문자 함수] --
-- INSTR() : 1번 문자열 속에서 2번 문자열이 포함된 INDEX값을 돌려준다.
SELECT INSTR('Corea','e') e
FROM dual;


SELECT INSTR('corporate floor','or')      -- 2 (가장 처음 만나는 or의 index값)
        -- 2번째 or이 들어있는 위치값을 찾아온다.
    ,  INSTR('corporate floor','or',3,2)  -- 14( 앞에서 3번재부터 2번째 or의 index값)
    ,  INSTR('corporate floor','or',-3,2) -- 2 ( 뒤에서 3번재부터 2번째 or의 index값)
FROM dual;


SELECT '010-1234-5678' hp
     , SUBSTR( '02-1234-5678', 1, INSTR('02-1234-5678', '-') -1) a
     , SUBSTR( '02-1234-5678', INSTR('02-1234-5678', '-')+1, INSTR('02-1234-5678', '-', -1) - INSTR('02-1234-5678', '-')+1) b
     , SUBSTR( '02-1234-5678', INSTR('02-1234-5678', '-', -1)+1, 4) c
FROM dual;

DESC tbl_tel;

SELECT *
FROM tbl_tel;

SELECT SUBSTR( tel, 1, INSTR(tel, ')')-1) a
    , INSTR(tel, ')')-1
    , INSTR(tel, '-')
    , SUBSTR(tel, INSTR(tel, ')')+1, INSTR(tel, '-') - INSTR(tel, ')')-1) b
    , SUBSTR(tel, INSTR(tel, '-')+1) c
FROM tbl_tel;

INSERT INTO tbl_tel (tel, name) VALUES ('063)469-4567', '큰삼촌');
INSERT INTO tbl_tel VALUES ('052)1456-2367', '둘째삼촌');
COMMIT;

-- RPAD() / LPAD()
-- PAD == 덧 대는 것, 메워 넣은 것, 패드 // 남은 공백자리를 내가 원하는 문자로 채우겠다.
-- 형식 ) RPAD(expr1, n, [expr2])
-- pay를 10자리 확보하고 남은 공간은 *로 채워넣기
SELECT ename, pay
    , RPAD(pay, 10, '*')
    , LPAD(pay, 10, '*')
FROM (
    SELECT ename, sal + NVL(comm, 0) pay    
    FROM emp    
    ) t;
    
-- RTRIM() : 오른쪽 공백 제거 / LTRIM() : 왼쪽 공백 제거 / TRIM() : 공백 전부 제거
-- 형식 ) RTRIM(char [, set])


SELECT '    admin    '
    , '[' || ' admin   ' || ']'
    , '[' || RTRIM(' admin   ') || ']'
    , '[' || LTRIM(' admin   ') || ']'
    , '[' || TRIM(' admin   ') || ']'
FROM dual;

-- TRIM()를 사용하면 양쪽의 공백만을 제거할 수 있다.(문자열은 삭제 불가능) 
-- RTRIM사용하면 왼쪽 오른쪽에 있는 'xy'와 같은 문자열도 삭제 가능하다.
SELECT RTRIM('BROWINGyxXxy', 'xy')
    ,  RTRIM('BROWINGyxXxyxyxy', 'xy')
    ,  LTRIM('xyBROWINGyxXxyxyxy', 'xy')
    ,  RTRIM(LTRIM('xyBROWINGyxXxyxyxy', 'xy'), 'xy') -- 양쪽의 xy를 제거하고 싶으면 두번 사용해야한다.
--    ,  TRIM('xyBROWINGyxXxyxyxy', 'xy') 이렇게 하면 오류 발생
FROM dual;


SELECT ename
    , ASCII( SUBSTR(ename, 1, 1) ) -- 아스키 코드값 가져올때 사용하는 함수 
    , CHR(ASCII( SUBSTR(ename, 1, 1) )) -- 아스키 코드값을 문자값으로 변환하는 함수
FROM emp;

SELECT ASCII('0'), ASCII('A'), ASCII('a')
FROM dual;


-- 가장 큰 값 GREATEST() / 가장 작은 값 LEAST()
SELECT GREATEST(3, 5, 2, 4, 1)
     , GREATEST('R','A','Z','X')
     , LEAST(3, 5, 2, 4, 1)
     , LEAST('R','A','Z','X')
FROM dual;

-- VSIZE() BYTE값을 돌려주는 함수
SELECT ename
    , VSIZE(ename)  
    , VSIZE('홍길동') -- 9 byte
    , VSIZE('a')
    , VSIZE('한')
FROM emp;

-- 날짜 반환 함수
SELECT SYSDATE, CURRENT_TIMESTAMP -- 24/02/19
    , ROUND(SYSDATE) -- 정오를 기준으로 날짜를 반올림 한다. -- 24/02/20
    , ROUND(SYSDATE, 'DD') b
    , ROUND(SYSDATE, 'MONTH') c -- 그 달의 15일을 기준으로 15일 이상이면 다음달로 바뀐값을 출력 2 / 15일 -> 3월 1일
    , ROUND(SYSDATE, 'YEAR') d  -- 그 연도를 기준으로 6월이 넘으면 다음해를 리턴해준다. 6월 넘지 ㅇ않으면 이번연도를 출력
FROM dual;


SELECT SYSDATE
    , TO_CHAR( SYSDATE, 'YYYY.MM.DD.HH.MI.SS') A -- 2024.02.19.03.41.17
    , TRUNC(SYSDATE) -- 24/02/19
    , TO_CHAR( TRUNC(SYSDATE), 'YYYY.MM.DD.HH.MI.SS')  B -- 2024.02.19.12.00.00
    , TRUNC( SYSDATE, 'MONTH') C -- 24/02/01
    , TRUNC( SYSDATE, 'YEAR') D  --- 24/01/01
FROM dual;


-- 날짜 + 숫자 날짜 날짜에 일수를 더하여 날짜 계산
SELECT SYSDATE + 100 
FROM dual;


-- 문제 : 입사한 날짜 부터 오늘 날짜까지 근무한 일수 몇일?
SELECT ename
    , hiredate
    , SYSDATE
    ,  TRUNC(SYSDATE+1) - TRUNC(HIREDATE) --입사 날짜 부터 오늘날짜 까지 의 날짜 계산
FROM emp;

SELECT SYSDATE
    , TO_CHAR( SYSDATE + 1, 'YYYY/MM/DD HH24:MI:SS')
    -- SYSDATE + 2/24 => 현재날짜 + 2시간을 나타낸다.
    , TO_CHAR( SYSDATE + 2/24, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

-- 24년 2월 마지막 날짜 몇일까지 있는지??

SELECT SYSDATE -- 24/02/19
    ,TRUNC( SYSDATE, 'DD') -- 24/02/19 시간, 분, 초 절삭
    ,TRUNC( SYSDATE, 'MONTH') -- 24/02/01 : 월 밑으로 즉 일, 시간, 분, 초 절삭
    -- 1달 더하기
    ,ADD_MONTHS( TRUNC( SYSDATE, 'MONTH'), -1) A -- 24/01/01 1달을 뺀 값을 반환
    ,ADD_MONTHS( TRUNC( SYSDATE, 'MONTH'), 1) B -- 24/03/01 1달을 더한 값을 반환
    -- 1달을 더한 뒤에 -1을 통해 하루 빼고 'DD'하면 29일이 나온다.
    ,TO_CHAR(ADD_MONTHS( TRUNC( SYSDATE, 'MONTH'), 1) -1, 'DD') C -- 2월의 마지막 날짜를 반환 29일
    ,ADD_MONTHS( SYSDATE, 12) D -- 25/02/19 1년을 더한 날짜
FROM dual;

-- [문제] 개강일로부터 오늘날짜까지 일수?
-- 2023.12.29 개강

SELECT CEIL( SYSDATE - TO_DATE('2023/12/29' , 'YYYY.MM.DD') ) "DATE"
FROM dual;

-- [문제] 오늘날짜부터 수료일까지 남은 일수?
-- 2024.06.14 수료
SELECT CEIL( TO_DATE(' 2024.06.14 ' , 'YYYY.MM.DD') - SYSDATE ) "DATE1"
    , ABS(CEIL( SYSDATE - TO_DATE(' 2024.06.14 ' , 'YYYY.MM.DD') ) ) "DATE2"
FROM dual;

SELECT SYSDATE
    , LAST_DAY(SYSDATE) -- 24/02/29 마지막 날짜 가져와주는 함수 LAST_DAT()
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD') -- 29 마지막 날짜만 출력
FROM dual;


-- NEXT_DAY() 함수 : 2번째 매개변수로 준 요일이 돌아오는 가장 최근 날짜를 반환하는 함수
SELECT SYSDATE
    , TO_CHAR( SYSDATE, 'YYYY/MM/DD (DY)') A  -- DY = 월
    , TO_CHAR( SYSDATE, 'YYYY/MM/DD (DAY)') B -- DAY = 월요일
    , NEXT_DAY( SYSDATE , '금') C  --24/02/23
    , NEXT_DAY( SYSDATE , '월') D  --24/02/26
FROM dual;

--[문제] 4월 첫 번째 화요일 만나자 ( 약속 )
-- SELECT TO_DATE( '2024.04.01') 이렇게 시작하니까 가장 최근 월요일이 24/04/08 다음주 월요일로 나오는 문제가 생겨서 -1을 통해 3월 마지막 날짜부터 시작하도록 로직 구성
-- NEXT_DAY()는 현재날짜는 포함 X
SELECT TO_DATE( '2024.04.01')
    , NEXT_DAY( TO_DATE( '2024.04.01')-1 , '화') -- 24/04/02
    , NEXT_DAY( TO_DATE( '2024.04.01')-1 , '월')
FROM dual;

-- MONTH_BETWEEN() 두 날짜사이의 개월 수를 반환 하는 함수

SELECT ename, hiredate
    , SYSDATE
    , CEIL( ABS( hiredate - SYSDATE ) ) "WORK_DATE" -- 근무 일 수
    , CEIL( MONTHS_BETWEEN( SYSDATE, hiredate) ) "WORK_MONTH" -- 근무 개월 수
    , ROUND (MONTHS_BETWEEN( SYSDATE, hiredate)/12, 2) "WORK_YEAR" -- 근무 년 수
FROM emp;


SELECT SYSDATE
    , CURRENT_DATE
    , CURRENT_TIMESTAMP
FROM dual;



-- TO_CHAR(날짜, 숫자)
-- [문제] insa 테이블에서 pay를 세자리마다 콤마를 출력하고 앞에 통화기호를 붙이자
SELECT num, name
    , basicpay
    , sudang
--    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang, '9,999,999L') pay
FROM insa;


SELECT 12345
    , TO_CHAR( 12345 )  -- 12345
    , TO_CHAR( 12345, '99,999') --  12,345
    , TO_CHAR( 12345, '99,999.00') --  12,345.00
    , TO_CHAR( 12345.123, '99,999.00') --  12,345.12
    , TO_CHAR( -100, 'S9999')
FROM dual;