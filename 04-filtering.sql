SELECT c.email
FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

SELECT c.email
FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) != '2005-06-14';

DELETE
FROM rental
WHERE YEAR(rental_date) = 2004;

DELETE
FROM rental
WHERE YEAR(rental_date) != 2005
  AND YEAR(rental_date) != 2006;

SELECT customer_id, rental_date
FROM rental
WHERE rental_date < '2005-05-25';

SELECT customer_id, rental_date
FROM rental r
WHERE r.rental_date <= '2005-06-16'
  AND r.rental_date >= '2005-06-14';

SELECT customer_id, rental_date
FROM rental r
WHERE r.rental_date BETWEEN '2005-06-14' AND '2005-06-16';

SELECT customer_id, rental_date
FROM rental r
WHERE r.rental_date >= '2005-06-16'
  AND rental_date <= '2005-06-14';

SELECT last_name, first_name
FROM customer c
WHERE c.last_name BETWEEN 'FA' AND 'FR';

SELECT last_name, first_name
FROM customer c
WHERE c.last_name BETWEEN 'FA' AND 'FRB';

SELECT title, rating
FROM film
WHERE rating = 'G'
   OR rating = 'PG';

SELECT title, rating
FROM film
WHERE rating IN ('G', 'PG');

SELECT title, rating
FROM film
WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');

SELECT title, rating
FROM film
WHERE rating NOT IN ('PG-13', 'R', 'NC-17');

SELECT last_name, first_name
FROM customer
WHERE LEFT(last_name, 1) = 'Q';

SELECT last_name, first_name
FROM customer c
WHERE c.last_name LIKE '_A_T%S';

SELECT last_name, first_name
FROM customer c
WHERE c.last_name LIKE 'Q%'
   OR c.last_name LIKE 'Y%';

SELECT last_name, first_name
FROM customer c
WHERE c.last_name REGEXP '^[QY]';

SELECT rental_id, customer_id
FROM rental r
WHERE r.return_date IS NULL;

SELECT rental_id, customer_id, return_date
FROM rental r
WHERE r.return_date IS NOT NULL;

-- WRONG
SELECT rental_id, customer_id, return_date
FROM rental r
WHERE r.return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

-- RIGHT
SELECT rental_id, customer_id, return_date
FROM rental r
WHERE r.return_date IS NULL
   OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

-- QUIZ 를 위한 서브셋 만들기
SELECT payment_id, c.customer_id, amount, DATE(payment_date)
FROM payment p
       INNER JOIN customer c ON p.customer_id = c.customer_id
WHERE p.payment_id BETWEEN 101 AND 120;

-- 다음 필터 조건에 반환되는 payment ID는 무엇 입니까?
-- customer_id <> 5 AND (amount > 8 OR date(payment_date) = '2005-08-23'
SELECT payment_id
FROM (SELECT payment_id, c.customer_id, amount, DATE(payment_date) AS payment_date
      FROM payment p
             INNER JOIN customer c ON p.customer_id = c.customer_id
      WHERE p.payment_id BETWEEN 101 AND 120) quiz
WHERE quiz.customer_id != 5 AND (amount > 8 OR quiz.payment_date = '2005-08-23');

-- customer_id = 5 AND NOT (amount > 6 OR date(payment_date) = '2005-06-19')
SELECT payment_id
FROM (SELECT payment_id, c.customer_id, amount, DATE(payment_date) AS payment_date
      FROM payment p
             INNER JOIN customer c ON p.customer_id = c.customer_id
      WHERE p.payment_id BETWEEN 101 AND 120) quiz
WHERE quiz.customer_id = 5 AND NOT (amount > 6 OR quiz.payment_date = '2005-06-19');

-- payments 테이블에서 금액이 1.98, 7.98 또는 9.98인 모든 행을 검색하는 쿼리를 작성하세요
SELECT amount
FROM payment p
WHERE p.amount IN (1.98, 7.98, 9.98);

-- 성(last name)의 두번쨰 위치에 A가 있고 A 다음에 W가 있는 모든 고객을 찾는 쿼리를 작성하세요
SELECT first_name, last_name
FROM customer c
WHERE c.last_name LIKE '_A%W%'

