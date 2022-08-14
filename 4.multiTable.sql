#Catesian, crossJOIN
SELECT c.first_name, c.last_name, a.address
    FROM customer c JOIN address a;

#Inner Join
SELECT c.first_name, c.last_name, a.address
    FROM customer c JOIN address a
        ON c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
    FROM customer c INNER JOIN address a
        ON c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
FROM customer c
         INNER JOIN address a USING (address_id);

# - ANSI JOIN syntax
#     - 조인 조건과 필터조건은 이해하기 쉽게 두개의 각각 다른 절 ON 하위절과 where절 로 구분됨
#     - 각 테이블 쌍에대한 조인 조건이 on절에 포함되어 있으므로 조인 조건의 일부가 실수로 누락될 가능성이 낮음
#     - SQL92 조인 문법을 사용하는 쿼리는 표준화 되어 있으므로, 데이터베이스 서버간에 이식이 가능하지만, 예전 문법은 서버마다 약간씩 달라서 이식이 쉽지 않음

# Two table

SELECT c.first_name, c.last_name, a.address
FROM customer c, address a
WHERE c.address_id = a.address_id
AND a.postal_code = 52137;

SELECT c.first_name, c.last_name, a.address
FROM customer c INNER JOIN address a
    ON c.address_id = a.address_id
WHERE a.postal_code = 52137;

#Triple tabel
SELECT c.first_name, c.last_name, ct.city
FROM customer c
         INNER JOIN address a
                    ON c.address_id = a.address_id
         INNER JOIN city ct
                    ON a.city_id = ct.city_id;

EXPLAIN SELECT c.first_name, c.last_name, ct.city
FROM customer c
         INNER JOIN address a
                    ON c.address_id = a.address_id
         INNER JOIN city ct
                    ON a.city_id = ct.city_id;

## 조인 순서가 중요한가?
# SQL 은 비절차적 언어. 데이터베이스 객체에서 수집된 통계를 이용해서(CostBase), 서버는
# 셋 중 하나의 테이블 조인할 순서를 결정함. 따라서 from 절에 테이블이 나타나는 순서는 중요하지 않음
#     즉. 드라이빙 테이블 선택이 코스트 기반으로 데이터베이스에 의해 이루어짐
#     하지만, MySql 에서는 straight_join 키워드를 통해 특정 순서대로 조인을 할 수도 있음
# -> 튜닝 이슈가 아마도 있을 것. 드라이빙 테이블 선택시, 아우터와 비교 했을때, 풀스캔 여부 확인. (드라이빙 테이블의 튜플이 아우터의 튜플 포함 관계를 가지는게 루프 수를 줄임)
# -> 추가학습 튜닝에 대한 주제는 필요할때 하는 것이고 과도한 튜닝은 오버엔지니어링.
#  반면, 튜닝의 문제를 넘어, 데이터베이스 메모리 모델과 동작을 이해하는 추가 학습이 필요(트러블 슈팅과 장애대응에 이점이 있음)
# -> mySQL 8.0 을 읽어보고 동작을 이해하자. 결국 백엔드의 어느 레이어든 메모리 모델을 이해하는 것이 중요하다고 생각
# 언제 튜닝해야할까? 몇초 부터 레이지 쿼리 일까? 내가 알고 있는 룰은 유저에게 화면 딜리버리는 최대 4초를 넘지 말아야하는데, 어떻게 레이지 쿼리를 잡아 낼까?
# 4초씩이나 걸리는 페이지는 경험한적이 거의 없다. -> 서비스마다 다를 것. 팀의 규칙에 따르자

SELECT STRAIGHT_JOIN c.first_name, c.last_name, ct.city
FROM city ct
         INNER JOIN address a ON a.city_id = ct.city_id
         INNER JOIN customer c ON c.address_id = a.address_id;

# 하나 이상의 서브쿼리를 사용하는 쪽이 성능 및 가독성 측면에 유리할 수 있음.
SELECT c.first_name, c.last_name, addr.address, addr.city
FROM customer c
         INNER JOIN (SELECT a.address_id, a.address, ct.city
                     FROM address a
                              INNER JOIN city ct
                                         ON a.city_id = ct.city_id
                     WHERE a.district = 'California') addr
                    ON c.address_id = addr.address_id;

SELECT f.title
FROM film f
         INNER JOIN film_actor fa ON f.film_id = fa.film_id
         INNER JOIN actor a ON fa.actor_id = a.actor_id
WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN') OR (a.first_name = 'CUBA' AND a.last_name = 'BIRTH'));

SELECT f.title
FROM film f
         INNER JOIN film_actor fa1 ON f.film_id = fa1.film_id
         INNER JOIN actor a1 ON fa1.actor_id = a1.actor_id
         INNER JOIN film_actor fa2 ON f.film_id = fa2.film_id
         INNER JOIN actor a2 ON fa2.actor_id = a2.actor_id
WHERE (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
  AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH');

#Question1
SELECT c.first_name, c.last_name, a.address, ct.city
FROM customer c
         INNER JOIN address a
                    ON c.address_id = a.address_id
         INNER JOIN city ct
                    ON a.city_id = ct.city_id
WHERE a.district = 'California';


#Question2
desc actor;
desc film_actor;
desc film;

SELECT first_name, f.title
    FROM film_actor fa
        INNER JOIN actor a
        INNER JOIN film f ON f.film_id
WHERE first_name='JOHN';

#Question3
desc address;
select a1.address addr1, a2.address addr2, a1.city_id, a1.address_id, a2.address_id
from address a1 inner join address a2
where a1.city_id = a2.city_id
  and a1.address_id <> a2.address_id;





