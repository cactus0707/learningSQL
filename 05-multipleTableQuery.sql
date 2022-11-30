SELECT c.first_name, c.last_name, a.address
FROM customer c
       JOIN address a;

SELECT c.first_name, c.last_name, a.address
FROM customer c
       JOIN address a ON c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
FROM customer c
       INNER JOIN address a ON c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
FROM customer c
       INNER JOIN address a USING (address_id);

SELECT c.first_name, c.last_name, a.address
FROM customer c,
     address a
WHERE c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
FROM customer c,
     address a
WHERE c.address_id = a.address_id
  AND a.postal_code = 52137;

SELECT c.first_name, c.last_name, a.address
FROM customer c
       INNER JOIN address a ON c.address_id = a.address_id
WHERE a.postal_code = 52137;
