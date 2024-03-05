-- MADNAG

SELECT *
FROM orders;



SELECT EXTRACT(month FROM orderdate) "month", -- 3. 그룹화 시킨 월별로 주문한 횟수 체크 
COUNT(orderdate) "Orders"
FROM orders -- 1. 주문테이블에서
GROUP BY EXTRACT(month FROM orderdate) -- 2. orderdate를 월로 바꿔서 월별로 그룹지어라
ORDER BY 'Orders' DESC; -- 4. 주문 횟수 별로 desc


DESC orders;

