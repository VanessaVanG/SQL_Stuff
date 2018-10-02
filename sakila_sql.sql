-- Van Gilder

USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
  FROM actor
;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
  FROM actor
;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
  FROM actor
  WHERE first_name = 'JOE'
;

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name
  FROM actor
  WHERE last_name 
    LIKE '%gen%'
;

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name
  FROM actor
  WHERE last_name 
    LIKE '%li%'
  ORDER BY last_name
    ,first_name
;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
  FROM country
  WHERE country 
    IN ('Afghanistan', 'Bangladesh', 'China')
;

-- 3a. Add a middle_name column to the table actor. 
-- Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
  ADD COLUMN middle_name VARCHAR(15)
  AFTER first_name;
  
-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the middle_name column to blobs.
ALTER TABLE actor
  MODIFY COLUMN middle_name blob;
  
-- 3c. Now delete the middle_name column.
ALTER TABLE actor
  DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(actor_id) AS '# of Actors w/ Surname'
  FROM actor
  GROUP BY last_name;
  
-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(actor_id) AS '# of Actors w/ Surname'
  FROM actor
  GROUP BY last_name
    HAVING COUNT(actor_id) >1;
    
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
  SET first_name = 'HARPO' 
    WHERE first_name = 'GROUCHO'
      AND last_name = 'WILLIAMS';

/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, 
change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
(Hint: update the record using a unique identifier.)*/
UPDATE actor
  SET first_name =
    CASE
      WHEN first_name = 'HARPO' AND last_name = 'WILLIAMS'
        THEN 'GROUCHO'
      WHEN first_name = 'GROUCHO' AND last_name = 'WILLIAMS'
        THEN 'MUCHO GROUCHO'
      ELSE first_name
  END
  ;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
 SHOW CREATE TABLE address;
 
-- 6a. Use JOIN to display the first and last names, 
-- as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
  FROM staff AS s
  INNER JOIN address AS a
    ON (s.address_id = a.address_id);
    
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT s.staff_id, s.first_name, s.last_name, sum(p.amount) AS 'Total Amount Rung Up'
  FROM staff AS s
  INNER JOIN payment AS p
    ON s.staff_id = p.staff_id
  WHERE MONTH(p.payment_date) = 08 
    AND YEAR(p.payment_date) = 2005
  GROUP BY s.staff_id;
  
-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(fa.actor_id) AS '# of Actors'
  FROM film as f
  INNER JOIN film_actor as fa
    ON f.film_id = fa.film_id
  GROUP BY f.film_id
;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(i.film_id) AS '# of Copies'
  FROM film as f
  INNER JOIN inventory as i
    ON f.film_id = i.film_id
  GROUP BY f.title
    HAVING f.title = 'HUNCHBACK IMPOSSIBLE'
;

-- 6e. Using the tables payment and customer 
-- and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total Paid'
  FROM payment AS p
  INNER JOIN customer AS c
    ON p.customer_id = c.customer_id
  GROUP BY c.customer_id
  ORDER BY c.last_name
;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title
  FROM film
  WHERE title LIKE 'K%' OR title LIKE 'Q%'
    AND language_id IN
(
SELECT language_id
  FROM language
  WHERE name = 'English'
);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
  FROM actor
  WHERE actor_id IN (
    SELECT actor_id
      FROM film_actor 
      WHERE film_id IN (
        SELECT film_id
          FROM film
          WHERE title = 'ALONE TRIP'
      )
    )
;

-- 7c. You want to run an email marketing campaign in Canada, for which you 
-- will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT cu.first_name, cu.last_name, cu.email
  FROM city as ci
  INNER JOIN country as co
    ON ci.country_id = co.country_id
  INNER JOIN address AS a
    ON a.city_id = ci.city_id
  INNER JOIN customer as cu
    ON cu.address_id = a.address_id
  WHERE co.country = 'Canada'
;

/* 7d. Sales have been lagging among young families, and you wish to target 
all family movies for a promotion. Identify all movies categorized as family films. */
SELECT f.title
  FROM film_category AS fc
  INNER JOIN category AS c
    ON fc.category_id = c.category_id
  INNER JOIN film AS f
    ON f.film_id = fc.film_id
  WHERE c.name = 'family'
;

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id)
  FROM rental AS r
  INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
  INNER JOIN film as f
    ON i.film_id = f.film_id
  GROUP BY f.film_id
  ORDER BY COUNT(r.rental_id) DESC
;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT sr.store_id, SUM(p.amount)
  FROM staff AS sf
  INNER JOIN store AS sr
    ON sf.store_id = sr.store_id
  INNER JOIN payment AS p
    ON p.staff_id = sf.store_id
  GROUP BY sr.store_id
;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, a.address, ci.city, co.country
  FROM store AS s
  INNER JOIN address AS a
    ON s.address_id = a.address_id
  INNER JOIN city AS ci
    ON a.city_id = ci.city_id
  INNER JOIN country AS co
    ON ci.country_id = co.country_id
;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(p.amount) AS 'Gross Revenue'
  FROM category AS c
  INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
  INNER JOIN inventory AS i
    ON fc.film_id = i.film_id
  INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
  INNER JOIN payment as p
    ON r.rental_id = p.rental_id
  GROUP BY c.name
  ORDER BY SUM(p.amount) DESC
  LIMIT 5  
;

/* 8a. In your new role as an executive, you would like to have an easy way of viewing 
the Top five genres by gross revenue. Use the solution from the problem above to create 
a view. If you haven't solved 7h, you can substitute another query to create a view. */
CREATE VIEW Top_Five_Genres AS
  SELECT c.name, SUM(p.amount) AS 'Gross Revenue'
    FROM category AS c
    INNER JOIN film_category AS fc
      ON c.category_id = fc.category_id
    INNER JOIN inventory AS i
      ON fc.film_id = i.film_id
    INNER JOIN rental AS r
      ON i.inventory_id = r.inventory_id
    INNER JOIN payment as p
      ON r.rental_id = p.rental_id
    GROUP BY c.name
    ORDER BY SUM(p.amount) DESC
    LIMIT 5  
;
 
-- 8b. How would you display the view that you created in 8a? 
SELECT * FROM Top_Five_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW Top_Five_Genres;
