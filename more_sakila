-- MySQL

USE sakila;

SELECT * 
  FROM rental
  WHERE rental_date < CURDATE();
  
SELECT CURDATE();

SELECT DATE_SUB(CURDATE(), INTERVAL 7 DAY);

SELECT DATE_ADD('1979-07-09', INTERVAL 39 YEAR);

SELECT * 
  FROM rental
  WHERE rental_date < CURDATE();
  
SELECT *
  FROM rental
  WHERE rental_date 
    BETWEEN DATE_SUB('2005-08-22', INTERVAL 1 DAY)
    AND CURDATE()
;

SELECT *
  , DATE_FORMAT(rental_date, '%d/%m/%Y') AS 'UK Date'
  FROM rental
  LIMIT 55;
  
SELECT COUNT(rental_date) AS rental
  , COUNT(return_date) AS 'return'
FROM rental;

SELECT COUNT(*)
FROM rental;
