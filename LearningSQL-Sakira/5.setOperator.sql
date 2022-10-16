desc customer;
desc city;

# Set Operator
#     - 두 데이터셋 모두 같은 수의 열을 가져야 한다.
#     - 두 데이터 셋의 각 열의 자료형은 서로 동일 해야한다(또는 서버가 서로 변환할 수 있어야 한다.)

#union, union all
select 'CUST' typ, c.first_name, c.last_name
from customer c
union all
select 'ACTR' typ, a.first_name, a.last_name
from actor a;

select 'ACTR' typ, a.first_name, a.last_name
from actor a
union all
select 'ACTR' typ,  a.first_name, a.last_name
from actor a;

select c.first_name, c.last_name
from customer c
where c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
union all
select a.first_name, a.last_name
    from actor a
where a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

select c.first_name, c.last_name
from customer c
where c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
union
select a.first_name, a.last_name
    from actor a
where a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

# mysql 8.0 -> intersection, except 지원 안함

#복합 쿼리의 결과 정렬
select a.first_name fname, a.last_name lname
from actor a
where a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
union all
select c.first_name, c.last_name
from customer c
where c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
order by lname, fname;

#집합 연산의 순서
select a.first_name, a.last_name
from actor a
where a.first_name like 'J%' and a.last_name like 'D%'
UNION ALL
select a.first_name, a.last_name
from actor a
where a.first_name like 'M%' and a.last_name like 'T%'
UNION
select c.first_name, c.last_name
from customer c
where c.first_name like 'J%' and c.last_name like 'D%';


select a.first_name, a.last_name
from actor a
where a.first_name like 'J%' and a.last_name like 'D%'
union
select a.first_name, a.last_name
from actor a
where a.first_name like 'M%' and a.last_name like 'T%'
union all
select c.first_name, c.last_name
from customer c
where c.first_name like 'J%' and c.last_name like 'D%';

desc actor;
desc customer;
#Question2
select first_name, last_name
from actor
where last_name like 'L%'
UNION
select first_name, last_name
from customer
where last_name like 'L%';

#Question3
select first_name, last_name
from actor
where last_name like 'L%'
union
select first_name, last_name
from customer
where last_name like 'L%'
order by last_name;