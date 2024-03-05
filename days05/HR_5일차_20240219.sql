-- HR
SELECT commission_pct
FROM employees;
--
SELECT count(*) 
FROM employees 
WHERE commission_pct IS NOT NAN;

SELECT count(*) 
FROM employees 
WHERE commission_pct IS NOT NULL;


-- 문제 : 1000자리 마다 *한개씩 찍겠다.
SELECT last_name, RPAD(' ',ROUND(salary/1000)+1, '*') "Salary"
    , salary
    , salary/1000 a
FROM employees
WHERE department_id = 80
ORDER BY last_name, "Salary";


select last_name, employee_id, hire_date -- 이름, id, 입사날짜 컬럼 선택
    ,   EXTRACT(year FROM hire_date) hire_year
from employees -- 1. employees 테이블에서
where EXTRACT(year FROM hire_date) > 1998   -- 1998년 이후 입사한 사람 hire_date에서 year를 가져와서
order by hire_date;     -- hire_date를 기준으로 ASC정렬

SELECT '12'
    , TO_NUMBER('12')
    , 100 - '12'    -- 숫자에서 문자를 빼도 숫자로 변환
    , '100' - '12'  -- 문자에서 문자를 빼도 숫자로 변환
FROM dual;


