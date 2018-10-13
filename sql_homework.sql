use sakila;

SELECT  
first_name, last_name
FROM sakila.actor;

SELECT  
concat(first_name,' ', last_name) `Actor Name`
FROM sakila.actor;


#2a. You need to find the ID number, first name, and last name of an actor, 
#of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT  
actor_id , concat(first_name,' ', last_name) `Actor Name`
FROM sakila.actor
where first_name = 'Joe';


SELECT  
actor_id , concat(first_name,' ', last_name) `Actor Name`
FROM sakila.actor
where last_name like '%gen%';


SELECT  
actor_id , concat(first_name,' ', last_name) `Actor Name`
FROM sakila.actor
where last_name like '%li%'
order by last_name,  first_name;

#* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select 
country_id
, country
from country
where country in('Afghanistan', 'Bangladesh', 'China');


ALTER TABLE sakila.actor
ADD  middle_name VARCHAR(255) AFTER first_name;

ALTER TABLE sakila.actor
modify column middle_name blob;

ALTER TABLE sakila.actor
drop column middle_name;

SELECT  
last_name
, count(actor_id) actors_with_name
FROM sakila.actor
group by last_name;

SELECT  
last_name
, count(actor_id) actors_with_name
FROM sakila.actor
group by last_name
having count(actor_id) > 1;

UPDATE sakila.actor
SET first_name = 'HARPO'
where first_name ='GROUCHO'
and last_name  =  'WILLIAMS';
 
UPDATE sakila.actor
SET first_name = CASE WHEN first_name = 'HARPO' THEN 'GROUCHO'ELSE 'MUCHO GROUCHO' END 
where  (first_name   = 'HARPO' OR first_name   = 'GROUCHO')
and last_name  =  'WILLIAMS'
;


CREATE TABLE IF NOT EXISTS  SAKILA.ADDRESS  (
ADDRESS_ID SMALLINT(5) unique
, ADDRESS VARCHAR(255)
, ADDRESS2 VARCHAR(255)
, DISTRICT VARCHAR(255)
, CITY_ID SMALLINT(5) unique
, POSTAL_CODE VARCHAR(10)
, PHONE VARCHAR(20)
, LOCATION geometry
, LAST_UPDATE timestamp
, primary key (ADDRESS_ID));

SELECT 
STAFF.FIRST_NAME
, STAFF.LAST_NAME 
, ADDRESS.ADDRESS
, ADDRESS.ADDRESS2
, ADDRESS.POSTAL_CODE
FROM
SAKILA.STAFF 
LEFT JOIN sakila.address 
ON ADDRESS.ADDRESS_ID = STAFF.ADDRESS_ID;

SELECT 
STAFF.FIRST_NAME
, STAFF.LAST_NAME 
, SUM(AMOUNT) AUGUST_TOTAL
FROM
SAKILA.STAFF 
LEFT JOIN sakila.PAYMENT
ON PAYMENT.STAFF_ID = STAFF.STAFF_ID
WHERE payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 00:00:00'
group by STAFF.FIRST_NAME
, STAFF.LAST_NAME 
;

select 
distinct
film.title
, count(film_actor.actor_id) actor_count
from 
SAKILA.film
left join sakila.film_actor
on film.film_id = film_actor.film_id
group by film.title;

select 
film.title
, count(distinct inventory.inventory_id) number_of_copies
from 
sakila.inventory
left join sakila.film
on film.film_id = inventory.film_id
where film.title = 'Hunchback Impossible'
group by film.title;

select 
customer.last_name
, customer.first_name
, sum(payment.amount) total_payment
from sakila.payment
left join sakila.customer
on payment.customer_id = customer.customer_id
group by customer.last_name
, customer.first_name;

select 
distinct
film.title
from 
sakila.film
left join sakila.language
on film.language_id = language.language_id
where (film.title like 'K%' or film.title like 'Q%')
and language.name = 'ENGLISH';

select 
actor.first_name
, actor.last_name
from sakila.actor 
left join sakila.film_actor 
on actor.actor_id = film_actor.actor_id
where film_actor.film_id in 
(
select film_id from sakila.film where film.title = 'Alone Trip'
);

SELECT
CUSTOMER.first_name
, CUSTOMER.last_name
, CUSTOMER.email
FROM
sakila.customer
left join sakila.address
on address.address_id = customer.address_id
LEFT JOIN SAKILA.CITY
ON CITY.CITY_ID = ADDRESS.CITY_ID
LEFT JOIN SAKILA.COUNTRY
ON COUNTRY.COUNTRY_ID = CITY.COUNTRY_ID
WHERE COUNTRY.COUNTRY = 'CANADA';


select 
film.* 
from 
sakila.film
left join sakila.film_category
on film.film_id = film_category.film_id
left join sakila.category
on category.category_id = film_category.category_id
where category.name = 'family';


SELECT
F.TITLE
, COUNT(DISTINCT RENTAL_ID) RENTALS
FROM
SAKILA.RENTAL R
LEFT JOIN SAKILA.inventory I
ON R.INVENTORY_ID = I.inventory_id
LEFT JOIN SAKILA.FILM F
ON F.FILM_ID = I.FILM_ID
GROUP BY F.TITLE
ORDER BY RENTALS DESC;

SELECT
S.STORE_ID
, SUM(P.amount) STORE_PAYMENT
FROM
SAKILA.store s
LEFT JOIN SAKILA.inventory I
ON S.STORE_ID = I.store_id
LEFT JOIN SAKILA.RENTAL R
ON R.INVENTORY_ID = I.INVENTORY_ID
LEFT JOIN SAKILA.FILM F
ON F.FILM_ID = I.FILM_ID
LEFT JOIN SAKILA.payment P
ON P.rental_id = R.RENTAL_ID
GROUP BY S.STORE_ID
ORDER BY STORE_PAYMENT DESC;


SELECT
distinct
s.store_id
, c.city
, co.country
FROM
SAKILA.store s
left join sakila.address a
on a.address_id = s.address_id
left join sakila.city c
on c.city_id and a.city_id
left join sakila.country co
on co.country_id = c.country_id;

SELECT
ca.name
, SUM(P.amount) GENRE_PAYMENT
FROM
SAKILA.store s
LEFT JOIN SAKILA.inventory I
ON S.STORE_ID = I.store_id
LEFT JOIN SAKILA.RENTAL R
ON R.INVENTORY_ID = I.INVENTORY_ID
LEFT JOIN SAKILA.FILM F
ON F.FILM_ID = I.FILM_ID
LEFT JOIN SAKILA.payment P
ON P.rental_id = R.RENTAL_ID
left join sakila.film_category fc
on f.film_id = fc.film_id
left join sakila.category ca
on ca.category_id = fc.category_id
GROUP BY ca.name
ORDER BY GENRE_PAYMENT DESC
LIMIT 5;

CREATE VIEW SAKILA.TOP_FIVE_GENRES AS(
SELECT
ca.name
, SUM(P.amount) GENRE_PAYMENT
FROM
SAKILA.store s
LEFT JOIN SAKILA.inventory I
ON S.STORE_ID = I.store_id
LEFT JOIN SAKILA.RENTAL R
ON R.INVENTORY_ID = I.INVENTORY_ID
LEFT JOIN SAKILA.FILM F
ON F.FILM_ID = I.FILM_ID
LEFT JOIN SAKILA.payment P
ON P.rental_id = R.RENTAL_ID
left join sakila.film_category fc
on f.film_id = fc.film_id
left join sakila.category ca
on ca.category_id = fc.category_id
GROUP BY ca.name
ORDER BY GENRE_PAYMENT DESC
LIMIT 5
);


SELECT * FROM SAKILA.TOP_FIVE_GENRES;

DROP VIEW SAKILA.TOP_FIVE_GENRES;