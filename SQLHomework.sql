use sakila;

#1a. Display the first and last names of all 
#actors from the table actor 

select first_name, last_name
from actor;

#1b. Display the first and last name of each actor 
#in a single column in upper case letters. 
#Name the column Actor Name

select 
concat(first_name,' ', last_name) as Actor_Name
from actor;

#2a. You need to find the ID number, 
#first name, and last name of an actor, 
#of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?

select actor_id, 
     first_name,
     last_name
from actor
where first_name like 'Joe%';

#2b. Find all actors whose last name contain the letters GEN

select first_name, last_name
from actor
where last_name like '%GEN%';

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, 
#in that order

select first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name;

#2d. Using IN, display the country_id and country columns 
#of the following countries: Afghanistan, Bangladesh, and China

select country_id, country 
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

#3a. You want to keep a description of each actor. 
#You don't think you will be performing queries on a description, 
#so create a column in the table actor named description 
#and use the data type BLOB (Make sure to research the type BLOB

alter table actor
add column description blob not null;

#3b. Very quickly you realize that entering descriptions 
#for each actor is too much effort. 
#Delete the description column

alter table actor 
drop column description;

#4a. List the last names of actors, 
#as well as how many actors have that last name.

select distinct(last_name), count(last_name) as 'same_name'
from actor
group by last_name;

#4b. List last names of actors and the number of actors 
#who have that last name, but only for names that are shared by 
#at least two actors


select distinct(last_name), count(last_name) as 'same_name'
from actor
group by last_name
having same_name >=2;


select * from actor
WHERE last_name = 'WILLIAMS'; 

#4c. The actor HARPO WILLIAMS was accidentally entered 
#in the actor table as GROUCHO WILLIAMS. 
#Write a query to fix the record.
#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is 
#currently HARPO, change it to GROUCHO

UPDATE actor 
set first_name = 'HARPO'
WHERE actor_id = 172;

#Tried a different method from stackoverflow
     
start transaction;

UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND 
last_name = 'WILLIAMS';  

commit; 

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is 
#currently HARPO, change it to GROUCHO

UPDATE actor 
set first_name = 'GROUCHO'
WHERE actor_id = 172;

#5a. You cannot locate the schema of the address table. 
#Which query would you use to re-create it?
show create table address;
select * from address;

#6a. Use JOIN to display the first and last names, 
#as well as the address, of each staff member. 
#Use the tables staff and address:

 SELECT staff.first_name, staff.last_name, 
 address.address,
 city.city,
 country.country
 FROM staff 
 INNER JOIN address
 ON staff.address_id = address.address_id
 INNER JOIN city 
 ON address.city_id = city.city_id 
 INNER JOIN country
 ON city.country_id = country.country_id;
 
 #6b. Use JOIN to display the total amount rung up 
 #by each staff member in August of 2005. 
 #Use tables staff and payment
 
 select staff.first_name, staff.last_name, 
 sum(payment.amount) as total_Rung 
 from staff
 inner join payment 
 on staff.staff_id = payment.staff_id 
 where payment.payment_date like '2005-08%' 
 group by payment.staff_id;
 
 #6c. List each film and the number of actors 
 #who are listed for that film. 
 #Use tables film_actor and film. Use inner join.
 
 select title, 
 count(actor_id) as number_of_actors 
 from film 
 inner join film_actor 
 on film.film_id = film_actor.film_id 
 group by title;
 
 #6d. How many copies of the film 
 #Hunchback Impossible exist in the inventory system?
 
 select title,
 count(inventory_id) as total_copies
 from film
 inner join inventory
 on film.film_id = inventory.film_id
 where title =  'Hunchback Impossible';
 
 #6e. Using the tables payment and customer and 
 #the JOIN command, list the total paid by each customer. 
 #List the customers alphabetically by last name:
 
 
 select first_name,last_name, 
 sum(amount) as total_paid
 from payment
 inner join customer
 on customer.customer_id = payment.customer_id
 group by payment.customer_id 
 order by last_name asc;
 
 #7a. The music of Queen and Kris Kristofferson 
 #have seen an unlikely resurgence. 
 #As an unintended consequence, 
 #films starting with the letters K and Q 
 #have also soared in popularity. 
 #Use subqueries to display the titles of movies 
 #starting with the letters K and Q whose language is English
 
 select title 
 from film 
 where language_id in 
 (select language_id from language WHERE name = "English" ) 
 and (title LIKE "K%") OR (title LIKE "Q%");
 
 
#7b. Use subqueries to display all actors 
#who appear in the film Alone Trip

select first_name, last_name
from actor
where actor_id in 
(select actor_id from film_actor
where film_id in
(select film_id from film where title = "Alone Trip"));

#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses 
#of all Canadian customers. Use joins to retrieve 
#this information.

select first_name, last_name
from customer
inner join customer_list
on customer.customer_id = customer_list.ID
where customer_list.country = "canada";

#7d. Sales have been lagging among young families, 
#and you wish to target all family movies for a 
#promotion. Identify all movies categorized as family films.

select title 
from film 
where film_id in
(select film_id 
from film_category 
where category_id in 
(select category_id 
from category where name = 'Family'));

#7e. Display the most frequently rented movies 
#in descending order.

select film.title, rental.rental_id
from film
inner join inventory
on inventory.film_id = film.film_id
inner join rental
on inventory.inventory_id = rental.inventory_id
group by rental_id 
order by rental_id desc;
 

#7f. Write a query to display how much business, 
#in dollars, each store brought in.

select store.store_id, 
sum(amount) AS total_sales
from store 
inner join staff on
store.store_id = staff.store_id 
inner join payment on
payment.staff_id = staff.staff_id 
group by store.store_id;

#7g. Write a query to display for each store 
#its store ID, city, and country.

select store.store_id, 
city.city, 
country.country 
from store 
inner join address on 
store.address_id = address.address_id 
inner join city on 
address.city_id = city.city_id 
inner join country on 
city.country_id = country.country_id;

#7h. List the top five genres in gross revenue 
#in descending order. (Hint: you may need to use 
#the following tables: category, film_category, 
#inventory, payment, and rental.

select c.name,
sum(p.amount) as gross_revenue
from category c
inner join film_category fc on
fc.category_id = c.category_id
inner join inventory i on
i.film_id = fc.film_id
inner join rental r on
r.inventory_id = i.inventory_id
right join payment p on
p.rental_id = r.rental_id
group by name
order by gross_revenue desc limit 5;

#8a. In your new role as an executive, 
#you would like to have an easy way of viewing 
#the Top five genres by gross revenue.
#Use the solution from the problem above to create a view.
# If you haven't solved 7h, you can substitute another 
#query to create a view.

create view five_genres as
select c.name,
sum(p.amount) as gross_revenue
from category c
inner join film_category fc on
fc.category_id = c.category_id
inner join inventory i on
i.film_id = fc.film_id
inner join rental r on
r.inventory_id = i.inventory_id
right join payment p on
p.rental_id = r.rental_id
group by name
order by gross_revenue desc limit 5; 

#8b. How would you display the view that you created in 8a?

select * from five_genres;

#8c. You find that you no longer need the view 
#top_five_genres. Write a query to delete it.

drop view five_genres;


