-- 문제 1 employees 테이블에서 사원의 성과 이름은 Name, 업무는 job, 급여는 연봉에 100 추가
SELECT first_name || last_name "Name" 
    , job_id job
    , salary
    , salary*12+100 "Increased Ann-Salary" 
    , salary+100 "Increased Salary"
FROM employees;

SELECT *
FROM employees;

-- 문제 2 employees 테이블에서 모든 사원의 성, 연봉을 성 : 1 Year Salary = $연봉 형식으로 출력 
SELECT last_name || ' : 1 Year Salary = $' || salary*12 "1 Year Salary"
FROM employees;


-- 문제 3 부서별로 담당하는 업무를 한번씩 출력
SELECT DISTINCT DEPARTMENT_ID, JOB_ID
FROM employees;


-- 문제 4 사원의 이름 중에 'e' 'o' 글자가 포함된 사원을 출력 별칭은 e and o Name
SELECT last_name
FROM employees
WHERE REGEXP_LIKE(last_name, '[eo]');
WHERE last_name LIKE '%e%' OR last_name LIKE '%o%';



-- 문제 5 날짜 함수 이용해서 2006년 05월 20일 부터 2007년 05월 20일 사이에 고용된 사원
SELECT first_name || ' ' || last_name  "Name"
    , job_id, hire_date
FROM employees
WHERE hire_date BETWEEN TO_DATE('2006-05-20', 'YYYY/MM/DD') AND TO_DATE('2007-05-20', 'YYYY/MM/DD')
ORDER BY hire_date ASC;



-- 문제 6 수당받는 모든 사원의 성과 이름, 급여, 업무, 수당률 출력 급여 많은 순서대로 -> 수당률 큰 순서대로 정렬
SELECT first_name || ' ' || last_name  "Name"
    , salary
    , job_id
    , commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;


-- 문제 7 성이 's'로 끝나는 사원의 이름과 업무이름과 성은 첫 자만 대문자 ( INITCAP() ) 업무는 모두 대문자
WITH t AS 
    (
    SELECT INITCAP(first_name) || ' ' || INITCAP(last_name) || ' is a ' || job_id "Employee JOBs" FROM employees
    )
SELECT t.*
FROM t;

-- 문제 8 보고서 작성 성, 이름, 급여, 수당, 수당이 있으면 sal + comm, 수당 없으면 sal only
SELECT  first_name || ' ' || last_name  "Name" 
        ,salary
        ,salary*12 "Annual Salary"
        ,salary*(1+NVL(commission_pct, 0))*12 "Annual Salary*commission"
        , CASE NVL(commission_pct, 0)
            WHEN 0 THEN 'salary only'
            ELSE 'salary + commission'
            END "commission ?"
FROM employees
ORDER BY "Annual Salary" DESC;


-- 문제 9 모든 사원의 성, 이름, 입사일, 입사 요일을 출력하시오 // 이때 주(week)의 시작인 일요일 부터 출력
SELECT  first_name || ' ' || last_name  "Name" 
    ,   hire_date
    ,   TO_CHAR(hire_date, 'day') "Day of the week"
FROM employees
ORDER BY "Day of the week" ASC;


-- 문제 10 각 사원의 부서별로 급여 합계, 급여 평균, 급여 최대값, 급여 최솟값을 집계 
SELECT department_id, TO_CHAR(SUM(salary), '$999,999.00') "Sum Salary"
    , TO_CHAR(AVG(salary), '$999,999.00') "Avg Salary"
    , TO_CHAR(MAX(salary), '$999,999.00') "Max Salary"
    , TO_CHAR(MIN(salary), '$999,999.00') "Min Salary"
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY department_id ASC;


-- 문제 11 업무별 전체 급여 평균이 $10,000 보다 큰 경우를 조회 업무와 급여 평균 조회
SELECT job_id, AVG(salary)
FROM employees
WHERE job_id NOT LIKE '%CLERK%'
GROUP BY job_id
HAVING AVG(salary) > 10000
ORDER BY AVG(salary) DESC;


-- 문제 12 employees, deparments 테이블의 구조 파악 후 사원수가 5명 이상인 부서의 부서명과 사원ㅅ ㅜ출력
SELECT e.department_id, COUNT(*)
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id
GROUP BY e.department_id
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC;


SELECT *
FROM job_grades;

SELECT *
FROM employees;

-- 문제 13 각 사원의 급여에 따른 급여 등급 출력
WITH t AS
    (
SELECT DISTINCT employee_id,  first_name || ' ' || last_name  "Name"
            , department_id, hire_date, salary
            , grade_level
FROM employees , job_grades
WHERE salary BETWEEN lowest_sal AND highest_sal
    )
SELECT t.*, department_name
FROM t t LEFT OUTER JOIN departments d ON t.department_id = d.department_id
ORDER BY t.grade_level ASC;


-- 문제 15 사원의 급여 정보 중 업무별 최소 급여를 받고 있는 사원의 성과 이름 출력
SELECT  
        ,  job_id
        ,  MIN(salary) salary
FROM employees
GROUP BY  job_id;

WITH t AS
    (
    SELECT  
          job_id
        ,  MIN(salary) salary
    FROM employees
    GROUP BY  job_id
    )
SELECT e.first_name || ' ' || e.last_name  "Name", t.job_id , t.salary
FROM t LEFT OUTER JOIN employees e ON t.job_id = e.job_id ;


-- 문제 16 소속부서의 평균 급여보다 많은 급여를 받는 사원의 이름과 성
WITH t AS
    (
    SELECT AVG(salary) pay FROM employees GROUP BY department_id
    )
SELECT DISTINCT e.first_name || ' ' || e.last_name  "Name", e.salary, e.department_id, e.job_id
FROM t, employees e
WHERE e.salary > t.pay;

-- 문제 17 사원들의 지역별 근무 현황을 조회하고자 한다, 도시 이름이 영문 'O'로 시작하는 지역에 살고있는 사원의 사번, 성과 이름 업무, 입사일을 출력



-- 문제 18  UNION ALL 해서 사번이 빠른 순서대로 출력
SELECT employee_id, job_id, department_id
FROM employees
UNION ALL
SELECT employee_id, job_id, department_id
FROM job_history
ORDER BY employee_id;


-- 문제 19 INTERSECT 사용
SELECT employee_id, job_id
FROM employees
INTERSECT
SELECT employee_id, job_id
FROM job_history
ORDER BY employee_id;


-- 문제 20 MINUS 사용
SELECT employee_id
FROM employees
MINUS
SELECT employee_id
FROM job_history;



-- 문제 21 부서별 급여 합계 
WITH t AS (
    SELECT department_id, SUM(salary) pay 
    FROM employees
    GROUP BY department_id
        )
SELECT t.department_id, t.pay,
    CASE 
    WHEN pay > 100000 THEN 'Excellent'
    WHEN pay > 50000 THEN 'Good'
    WHEN pay > 10000 THEN 'Medium'
    ELSE 'well'
    END "Department Grade Salary"
FROM t
ORDER BY "Department Grade Salary" ASC;


-- 문제 22 2005년 이전에 입사한 사원중 MGR이면 15%인상, MAN이면 20%인상
SELECT employee_id
    , first_name || ' ' || last_name  "Name"
    , job_id, hire_date
    , salary
    , salary * CASE SUBSTR(job_id, 4, 3)
        WHEN 'MGR' THEN 1.15
        WHEN 'MAN' THEN 1.2
        ELSE 1.25
      END "Department Grade Salary"
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') < '2005'
--WHERE hire_date < '2005.01.01'
ORDER BY hire_date

-- 문제 21
