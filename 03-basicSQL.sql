DESC sakila.customer;

SELECT actor_id
FROM film_actor
ORDER BY actor_id;
SELECT DISTINCT actor_id
FROM film_actor
ORDER BY actor_id;

SELECT CONCAT(cust.last_name, ', ', cust.first_name) full_name
FROM (SELECT first_name, last_name, email
      FROM customer
      WHERE first_name = 'JESSIE') cust;

CREATE TEMPORARY TABLE actors_j
(
  actor_id   SMALLINT(5),
  first_name VARCHAR(45),
  last_name  VARCHAR(45)
);

INSERT INTO actors_j
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE 'J%';

CREATE VIEW cust_vw AS
SELECT customer_id, first_name, last_name, active
FROM customer;

SELECT first_name, last_name
FROM cust_vw
WHERE active = 0;

SELECT customer.first_name, customer.last_name, TIME(rental.return_date) rental_time
FROM customer
       INNER JOIN rental
       ON customer.customer_id = rental.rental_id
WHERE DATE(rental.rental_date) = '2005-06-14';


SELECT c.first_name, c.last_name, TIME(r.rental_date) rental_time
FROM customer AS c
       INNER JOIN rental AS r
       ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

SELECT title
FROM film f
WHERE f.rating = 'G' AND rental_duration>=7;

SELECT title, rating, rental_duration
FROM film
WHERE (rating = 'G' AND rental_duration >=7)
OR (rating = 'PG-13' AND rental_duration < 4);

SELECT c.first_name, c.last_name, count(*)
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.first_name, c.last_name
HAVING count(*) >=40;

SELECT c.first_name, c.last_name, TIME(r.rental_date) rental_time
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE DATE (r.rental_date) = '2005-06-14'
ORDER BY c.last_name, c.last_name;

SELECT c.first_name, c.last_name, TIME(r.rental_date) rental_time
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE DATE (r.rental_date) = '2005-06-14'
ORDER BY time(r.rental_date) desc;

SELECT c.first_name, c.last_name, time(r.rental_date) rental_time
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE DATE (r.rental_date) = '2005-06-14'
ORDER BY 3 DESC;

-- QUESTION --
-- 모든 배우의 배우 ID, 이름 및 성을 검색합니다. 성 기준으로 정렬한 다음 이름 기준으로 정렬합니다.
SELECT actor_id, last_name, first_name
FROM actor
ORDER BY last_name, first_name;
-- 성이 'WILLIAMS' 또는 'DAVIS' 인 모든 배우의 배우 ID, 이름 및 성을 검색합니다.
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor.last_name='WILLIAMS' OR actor.last_name = 'DAVIS'

-- rental 테이블에서 2005년 7월 5일 영화를 대여한 고객의 ID를 반환하는 쿼리를 작성합니다.
SELECT rental_id
FROM rental
WHERE DATE (rental.rental_date) = '2005-07-05';
-- 빈칸 채우기 --
SELECT c.email, r.return_date
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE DATE (r.rental_date) = '2005-06-14'
ORDER BY r.return_date DESC;


