# 서버가 사용자 이름과 비밀번호를 확인하고, 연결하면
# 쿼리가 서버로 전송될 때 마다 서버는 구문을 실행하기 전에 다음 사항을 확인함
# - 구문을 실행할 권한이 있는가? (permission)
# - 원하는 데이터에 엑세스 할 수 있는 권한 이있는가?
# - 구문 문법이 정확한가?
# 이 세 단계를 통과하면, 쿼리 실행 시 가장 효율적인 방법을 경정하는 쿼리 옵티마이저로 전달 됨.
# 이 옵티마이저는 from 절에 명명된 테이블에 조인할 순서 및 사용 가능한 인덱스를 확인한 다음,
# 서버가 쿼리 실행에 필요한 execution plan 을 선택함
# 추가 질문 ?
# (session id 반환->datagrip 에선 세션 id 어디서 확인하지? 쿼리 잘못치면 dba 한테 알려줘야하는데)
#
# 추가 학습 컨텐츠
# SQL Anti Patterns
# 오라클 성능 고도화 해법 1,2 OCP,OCM, 그랑케 DB management System or 지금 MIT DB 수업 도서와 handout, 데이터 중심 어플리케이션 설계
#

#Select절 -> 쿼리 문의 첫번째 절이지만, 데이터베이스 서버가 판단하는 마지막 절 중 하나임.
select * from category;
select * from language;
select language_id, name, last_update from language;
select name from language;

# 숫자 또는 문자열과 같은 리터럴
# transaction.amount * -1 과 같은 expression
# ROUND(transaction.amount, 2)와 같은 built-in function
# 사용자 정의 함수(user-defined function
select language_id,
       'COMMON' language_usage,
       language_id * 3.141592 lang_pi_value,
       upper(name) language_name
    from language;

#
select version(), user(), database();

#
SELECT DISTINCT actor_id FROM film_actor ORDER BY actor_id;

# from 절은 쿼리에 사용되는 테이블을 명시할 뿐만 아니라, 테이블을 서로 연결하는 수단도 함께 정의(1번과 2번 주제로 나눔)

# 1. 쿼리에 사용되는 테이블 명시

# - table
#     - 영구 테이블 permanent table
#     - 파생 테이블 derived table
#     - 임시 테이블 temporary table
#     - 가상 테이블 virtual table

# permanent
# derived table
    # from 절 내의 서브쿼리는 from 절에 명시된 다른 테이블과 상호작용할 수 있는 derived table 생성하는 역할을 함
SELECT concat(cust.last_name, ', ', cust.first_name) full_name
    FROM
        (SELECT first_name, last_name, email
             FROM customer
             WHERE first_name = 'JESSIE') cust;

# temporary table
    # 모든 관계형 데이터베이스는 휘발성의 임시 테이블을 정의할 수 있음.
    # 영구 테이블 처럼 보이지만, 임시테이블에 삽입된 데이터는 어느시점(보통 트랜잭션이 끝날 떄 또는 데이터베이스 세션이 닫힐 때) 사라짐

# 세션이 종료 될 때 테이블이 사라짐(메모리에 저장됨)
CREATE TEMPORARY TABLE actors_j(
    actor_id smallint(5),
    first_name varchar(45),
    last_name varchar(45)
);

INSERT INTO actors_j
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE 'J%';

SELECT * FROM actors_j;

#vitual table
# 데이터 딕셔너리에 저장된 쿼리.(딕셔너리 -> DB 메타데이터) 마치 테이블 처럼 동작하지만 뷰에 저장된 데이터가 존재하지 않음.
# 언제 쓸까? -> 사용자로부터 열을 숨기고, 복잡한 데이터베이스 설계를 단순화 하는 등의 이유로 뷰가 만들어짐.

# 추가 학습
# DB 서버의 메모리에 위치할 것 같은데,WAS 자원을 쓰는게 합리적인가? DB 자원을 쓰는게 합리적인가? Trade off 이므로 상황마다 다를 것 같음
# 어떻게 테스트 할까?
CREATE VIEW cust_vw AS
SELECT customer_id, first_name, last_name, active
FROM customer;

SELECT first_name, last_name
FROM cust_vw
WHERE active = 0;

#2.테이블 연결
# from 절에 둘 이상의 테이블이 있으면, 그 테이블을 연결(link)하는데 필요한 조건도 포함해야 한다는 의무사항 -> ANSI 승인사항, 모든 데이터베이스의 요구사항은 아님
# -> 데이터베이스 서버에서 가장 이식성이 뛰어난 방법.. 안시표준을 지켜라!
SELECT customer.first_name, customer.last_name, time(rental.rental_date) rental_time
FROM customer
         INNER JOIN rental
                    ON customer.customer_id = rental.customer_id
WHERE date(rental.rental_date) = '2005-06-14';

SELECT c.first_name,
       c.last_name,
       time(r.rental_date) rental_time
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14';

#Where 절
SELECT title
FROM film
WHERE rating = 'G'
  AND rental_duration >= 7;


#Group by, having
SELECT c.first_name, c.last_name
FROM customer c
         INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.first_name, c.last_name
HAVING count(*) >= 40;

#Order By
SELECT c.first_name, c.last_name, time(r.rental_date) rental_time
FROM customer c
         INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14';

SELECT c.first_name, c.last_name, time(r.rental_date) rental_time
FROM customer c
         INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY c.last_name;

SELECT c.first_name, c.last_name
FROM customer c
         INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY c.last_name, c.first_name;

SELECT c.first_name, c.last_name, time(r.rental_date) remtal_time
FROM customer c
         INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY time(r.rental_date) desc;




















