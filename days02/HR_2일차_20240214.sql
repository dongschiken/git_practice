-- HR 계정이 소유하고 있는 테이블 정보를 조회
SELECT *
FROM tabs;







-- 1) REGIONS
DESC regions; -- "대륙 정보"를 가지고 있는 테이블
REGION_ID   NOT NULL NUMBER       숫자 not null
REGION_NAME          VARCHAR2(25) 문자열
SELECT *
FROM regions;


-- 2) COUNTRIES
DESC countries; -- "국가 정보"를 가지고 있는 테이블
COUNTRY_ID   NOT NULL CHAR(2)      국가 id
COUNTRY_NAME          VARCHAR2(40) 국가 명
REGION_ID             NUMBER       대륙 id값
SELECT *
FROM countries; 


-- 3) LOCATIONS -- "위치 정보"를 가지고 있는 테이블
DESC locations;
LOCATION_ID    NOT NULL NUMBER(4)    위치 번호 
STREET_ADDRESS          VARCHAR2(40) 주소
POSTAL_CODE             VARCHAR2(12) 우편 번호
CITY           NOT NULL VARCHAR2(30) 도시
STATE_PROVINCE          VARCHAR2(25) 주
COUNTRY_ID              CHAR(2)     국가 id
SELECT *
FROM locations;


-- 4) DEPARTMENTS -- "부서 정보"를 가지고 있는 테이블 (부서번호, 부서명, 관리자 id, 위치 id)
SELECT *
FROM departments;


-- 5) JOBS -- "직업 정보"를 가지고 있는 테이블 ( 직업 ID, 직업 이름, 최소 사원, 최대 사원)
SELECT *
FROM jobs;


-- 6) EMPLOYEES -- "사원 정보"를 가지고 있는 테이블 (사원 ID, 사원 성, 이름, 이메일 휴대폰 번호...)
SELECT *
FROM employees;


-- 7) JOB_HISTORY -- "직업 역사" 정보를 가지고 있는 테이블 
DESC job_history;
EMPLOYEE_ID   NOT NULL NUMBER(6)    사원 id
START_DATE    NOT NULL DATE         상태 날짜
END_DATE      NOT NULL DATE         끝나는 날짜
JOB_ID        NOT NULL VARCHAR2(10) 직업 id
DEPARTMENT_ID          NUMBER(4)    부서 id
SELECT *
FROM job_history;


SELECT *
FROM employees
WHERE employee_id = 101;

DESC employees;
--ORA-01722: invalid number
-- 오류 발생하면 어떤 부분에서 오류 났는지 팀원들한테 알려주기
-- 오라클 에서는 문자열 또는 날짜 앞에 ' ' 를 붙인다. (" " 사용 X)
-- 문자열 연결 연산자 : ||
-- 문자열 연결 함수 : CONCAT
SELECT  employee_id, 
--        first_name, last_name,
--        first_name || ' ' || last_name name,
        CONCAT (CONCAT(  first_name , ' ' ) ,last_name) AS "NAME",
        hire_date
FROM    employees;


SELECT '이름은'|| last_name || '이고, 직업은 ' || job_id || ' 이다.'
FROM employees;


SELECT *
FROM employees;
-- 위의 테이블에서 사원번호, 사원이름, 입사일자 컬럼만 출력

