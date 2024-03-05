-- MADANG
SELECT *
FROM book;

SELECT *
FROM tabs;

DESC imported_book;
BOOKID       NUMBER       책 id
BOOKNAME     VARCHAR2(40) 책 이름
PUBLISHER    VARCHAR2(40) 출판인
PRICE        NUMBER(8)    가격 

SELECT *
FROM imported_book

DESC customer;

-- 여기서는 0으로 바꾸는것도 가능한게 0이 문자로 변환되어 들어가진다.
SELECT name "이름", NVL(phone, 0) "전화번호"
FROM customer;

