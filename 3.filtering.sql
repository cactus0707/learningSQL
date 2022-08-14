# 때로는 다음과 같이 테입르의 모든행에서 작업할 수 있다.
# - 새로운 데이터 웨어하우스 피드를 준비할 때 사용한 테이블에서 모든 데이터 제거
# - 새열이 추가된 후 테이블의 모든 행 수정
# - 메시지 큐 테이블에서 모든 행 검색
# 모든 SQL 데이터 문에는 (Insert 제외) SQL 문으로 수행되는 행 수를 제한하기 위해 하나 이상의 필터 조건을 포함하는 where 절이 선택적으로 포함됨
# 또한 SELECT 문에는 그룹화된 데이터의 필터조건을 포함하는 having 절이 포함됨

# - 가능한 표현식
#     - 숫자
#     - 테이블 또는 뷰의 열
#     - 'Maple Street 같은 문자열'
#     - cacat('Learning', ' ', 'SQL')과 같은 내장 함수
#     - 서브 쿼리
#     ('Boston', 'New York', 'Chicago')와 같은 표현식 목록
# -조건 내에서 사용하는 연산자
#     - =, !=, <, >, <>, like, in 및 between과 같은 비교 연산자
#     - +, -, * / 같은 산술 연산자

SELECT c.email
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14';

SELECT c.email
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) <> '2005-06-14';


#Trasaction - Manual, Do not Commit
DELETE FROM rental
WHERE year(rental_date) = 2004;

DELETE FROM rental
WHERE year(rental_date) <> 2005 AND year(rental_date) <> 2006;

SELECT customer_id, rental_date
FROM rental
WHERE rental_date < '2005-05-25';

SELECT customer_id, rental_date
FROM rental
WHERE rental_date <= '2005-06-16'
AND rental_date>='2005-06-14';

SELECT customer_id, rental_date
FROM rental
WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';

#앤드 조건 나누어서 쿼리 날라가기 때문에 비트윈 사이 앤드 는 작은값 큰 값 순서로.
SELECT customer_id, rental_date
FROM rental
WHERE return_date BETWEEN '2005-06-16' AND '2005-06-14';

SELECT customer_id, payment_date, amount
FROM payment
WHERE amount BETWEEN 10.0 AND 11.99;

SELECT  last_name, first_name
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FR';

SELECT last_name, first_name
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FRB';

SELECT title, rating
FROM film
WHERE rating = 'G' OR rating = 'PG';

SELECT title, rating
FROM film
WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');

SELECT title, rating
FROM film
WHERE rating NOT IN ('PG-13', 'R', 'NC-17');

SELECT last_name, first_name
FROM customer
WHERE left(last_name, 1) = 'Q';

# - 와일드 카드
#     - 특정 문자로 시작, 종료하는 문자열
#     - 부분 문자열(substring)로 시작 종료하는 문자열
#     - 문자열 내에 특정 문자를 포함하는 문자열
#     - 문자열 내에 내부 문자열을 포함하는 문자열
#     - 개별 문자에 관계없이 특정 형식의 문자열

# _ : 정확히 한 문자
# % : 개수에 상관없이 모든 문자 포함
SELECT last_name, first_name
FROM customer
WHERE last_name LIKE '_A_T%S';

SELECT last_name, first_name
FROM customer
WHERE last_name LIKE 'Q%' OR last_name LIKE 'Y%';

SELECT last_name, first_name
FROM customer
WHERE last_name REGEXP '^[QY]';

# NULL ?
# - 해당 사항 없음
# - 아직 알려지지 않은 값
# - 정의 되지 않은 값
# - Null 일 수는 있지만, null 과 같을 수는 없음
# - 두개의 null 은 서로 같지 않음
# -> NULl값 허용 여부는 항상 확인하지

SELECT rental_id, customer_id
FROM rental
WHERE return_date IS NULL;

# -> 반환값 없음. 널 체킹은 IS NULL 로 할 것.
SELECT rental_id, customer_id
FROM rental
WHERE return_date = NULL;

SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date IS NOT NULL;

#아직 반납 되지 않은 튜플은 검색 되지 않음.(NULL 도 포함? NULL 이 비지니스로직에서 의미를 가짐. 어떻게 처리 해야할까?)
SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

SELECT rental_id, customer_id, rental_id
FROM rental
WHERE return_date IS NULL OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

show tables ;
desc payment;

SELECT payment_id, customer_id, amount, date(payment_date)
FROM payment
WHERE date(payment_date) BETWEEN '2005-07-09' AND '2005-08-18'
ORDER BY payment_date DESC;

#Question1
SELECT payment_id, customer_id, amount, date(payment_date)
FROM payment
WHERE payment_id BETWEEN 100 AND 121
  AND (customer_id <> 5)
  AND (amount > 8 OR date(payment_date) = '2005-08-23')
ORDER BY payment_date DESC;

#Question2
SELECT payment_id, customer_id, amount, date(payment_date)
FROM payment
WHERE payment_id BETWEEN 100 AND 121
  AND customer_id = 5 AND NOT (amount > 6 OR date (payment_date) = '2005-06-19')
ORDER BY payment_date DESC;

#Question3
SELECT payment_id, customer_id, amount, date(payment_date)
FROM payment
WHERE amount IN(1.98, 7.98, 9.98)
ORDER BY payment_date DESC;

#Question4
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE '_A%W%';