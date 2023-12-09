use sakila;

-- Dropping the column picture from staff
alter table staff
drop column picture;

-- A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer.
	-- Looking at the column data needed to import from one table to the other
		select * from staff;
		select * from customer;

insert into staff (staff_id ,first_name, last_name, address_id, email, store_id, `active`, username, last_update)
select 3, first_name, last_name, address_id, email, store_id, 1, "Tammy", last_update
from customer
where first_name = "TAMMY" and last_name = "SANDERS";


-- Adding the rental for the movie Academy Dinosaur(F_ID 1, INV_ID ) by Charlotte Hunter (C_ID 130) made by Mike Hillyer(Stf_ID 1) in the Store 1:
	-- Getting the info on the IDs
	select film_id
    from film
    where title = "academy dinosaur";
    
    select inventory_id
    from inventory
    where film_id = 1 and store_id = 1;
    
    select customer_id
    from customer
    where first_name = "charlotte" and last_name = "hunter";
    
    select staff_id
    from staff
    where first_name = "mike" and last_name = "hillyer";

insert into rental (rental_date, inventory_id, customer_id, staff_id, return_date)
values (now(), 1, 130, 1, null);

	-- Checking the results:
	select *
	from rental
	order by rental_date desc;
    
-- Checking if there are innactive users and deleting them after saving their data in a new table:
-- Getting the innactive users by looking at those that didn't rent a movie during 2006:
select distinct customer_id
from rental
where year(rental_date) = 2005
except
select distinct customer_id
from rental
where year(rental_date) = 2006;

-- Creating the table deleted_users:
create table deleted_users (
    customer_id int,
    email varchar(255),
    deletion_date timestamp default current_timestamp
);

-- Storing the data in deleted_users:

insert into deleted_users (customer_id, email)
select customer.customer_id, customer.email
from customer
join (
    select distinct customer_id
    from rental
    where year(rental_date) = 2005
    except
    select distinct customer_id
    from rental
    where year(rental_date) = 2006
) as non_active_customers
on customer.customer_id = non_active_customers.customer_id;

-- Deleting active customers:
DELETE FROM customer
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM deleted_users
);

