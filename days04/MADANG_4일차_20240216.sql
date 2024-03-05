-- MADANG


SELECT MAX(saleprice)
FROM orders
WHERE custid = 3;

SELECT orderid, custid, saleprice
FROM orders
WHERE saleprice > ALL ( SELECT saleprice
                     FROM orders
                     WHERE custid = 3);
                    -- ALL이 들어가면 서브쿼리문에서 계산된 결과 모두와 비교를 한다. 6000, 12000, 13000원 모두보다 saleprice가 크니??


SELECT orderid, custid, saleprice
FROM orders
WHERE saleprice > ANY ( SELECT saleprice
                     FROM orders
                     WHERE custid = 3);     
                      -- ANY가 들어가면 서브쿼리문에서 계산된 결과 모두와 비교를 한다. 6000, 12000, 13000원 중에 하나라도 큰게 있니?
-- SOME, ANY : 최소한 한개라도 조건이 맞으면 출력된다.

-- ALL : 서브쿼리에 모든 결과와 비교 

-- EXISTS 질의 4-16
SELECT SUM(saleprice) sum , AVG(saleprice) avg, MAX(saleprice) max, MIN(saleprice) min
FROM orders;


SELECT custid
FROM customer
WHERE address LIKE '대한민국%';

SELECT sum(saleprice)
FROM orders
WHERE custid IN (2, 3, 5);

SELECT *
FROM customer;



