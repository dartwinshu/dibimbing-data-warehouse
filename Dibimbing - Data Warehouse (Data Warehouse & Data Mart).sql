select * from actor;
select * from address;
select * from category;
select * from city;
select * from country;
select * from customer;
select * from film;
select * from film_actor;
select * from film_category;
select * from inventory;
select * from language;
select * from payment;
select * from rental;
select * from staff;
select * from store;


-- Pembuatan Tabel Data Warehouse Customer Segmentation

SELECT 
	c.customer_id, 
	r.rental_id, 
	r.inventory_id, 
	f.film_id, 
	a.actor_id, 
	ctg.category_id, 
	c.first_name ||' '|| c.last_name AS customer_name,
	f.title, 
	ctg.name AS category_name, 
	f.release_year, 
	a.first_name ||' '|| a.last_name AS actor_name
FROM customer c
	LEFT JOIN
	payment p
ON c.customer_id = p.customer_id
	LEFT JOIN
	rental r
ON p.rental_id = r.rental_id
	LEFT JOIN
	inventory i
ON r.inventory_id = i.inventory_id
	LEFT JOIN
	film f
ON i.film_id = f.film_id
 	LEFT JOIN
	film_actor fa
ON f.film_id = fa.film_id
	LEFT JOIN
	actor a
ON fa.actor_id = a.actor_id
 	LEFT JOIN
	film_category fctg
ON f.film_id = fctg.film_id
 	LEFT JOIN
	category ctg
ON fctg.category_id = ctg.category_id
ORDER BY customer_name ASC, f.title ASC, f.release_year DESC;

-- Pembuatan Tabel Data Warehouse Customer Transaction

SELECT
	c.customer_id,
	r.rental_id,
	p.payment_id,
	c.first_name ||' '|| c.last_name AS customer_name,
	r.rental_date,
	r.return_date,
	p.payment_date,
	p.amount
FROM customer c
	LEFT JOIN
	payment p
ON c.customer_id = p.customer_id
	LEFT JOIN
	rental r
ON p.rental_id = r.rental_id
ORDER BY p.amount DESC, customer_name ASC;

-- Pembuatan Tabel Data Mart Jumlah Customer untuk Setiap Kategori Film

SELECT 
	ctg.name AS category_name,
	count(c.customer_id) AS jumlah_customer
FROM customer c
	LEFT JOIN
	payment p
ON c.customer_id = p.customer_id
	LEFT JOIN
	rental r
ON p.rental_id = r.rental_id
	LEFT JOIN
	inventory i
ON r.inventory_id = i.inventory_id
	LEFT JOIN
	film f
ON i.film_id = f.film_id
 	LEFT JOIN
	film_actor fa
ON f.film_id = fa.film_id
	LEFT JOIN
	actor a
ON fa.actor_id = a.actor_id
 	LEFT JOIN
	film_category fctg
ON f.film_id = fctg.film_id
 	LEFT JOIN
	category ctg
ON fctg.category_id = ctg.category_id
GROUP BY ctg.name
ORDER BY jumlah_customer DESC;

-- Pembuatan Tabel Data Mart Jumlah Customer untuk Setiap Actor

SELECT 
	a.first_name ||' '|| a.last_name AS actor_name,
	count(c.customer_id) AS jumlah_customer
FROM customer c
	LEFT JOIN
	payment p
ON c.customer_id = p.customer_id
	LEFT JOIN
	rental r
ON p.rental_id = r.rental_id
	LEFT JOIN
	inventory i
ON r.inventory_id = i.inventory_id
	LEFT JOIN
	film f
ON i.film_id = f.film_id
 	LEFT JOIN
	film_actor fa
ON f.film_id = fa.film_id
	LEFT JOIN
	actor a
ON fa.actor_id = a.actor_id
 	LEFT JOIN
	film_category fctg
ON f.film_id = fctg.film_id
 	LEFT JOIN
	category ctg
ON fctg.category_id = ctg.category_id
GROUP BY actor_name
ORDER BY jumlah_customer DESC;

-- Pembuatan Tabel Data Mart Top 10 Film Jumlah Customer Terbanyak

SELECT 
	f.title,
	count(c.customer_id) AS jumlah_customer
FROM customer c
	LEFT JOIN
	payment p
ON c.customer_id = p.customer_id
	LEFT JOIN
	rental r
ON p.rental_id = r.rental_id
	LEFT JOIN
	inventory i
ON r.inventory_id = i.inventory_id
	LEFT JOIN
	film f
ON i.film_id = f.film_id
 	LEFT JOIN
	film_actor fa
ON f.film_id = fa.film_id
	LEFT JOIN
	actor a
ON fa.actor_id = a.actor_id
 	LEFT JOIN
	film_category fctg
ON f.film_id = fctg.film_id
 	LEFT JOIN
	category ctg
ON fctg.category_id = ctg.category_id
GROUP BY f.title
ORDER BY jumlah_customer DESC
LIMIT 10;

-- Pembuatan Tabel Data Mart top 100 Customer yang Melakukan Transaksi dengan Nilai Terbesar

SELECT DISTINCT
	c.first_name ||' '|| c.last_name AS customer_name,
	sum(p.amount) OVER (PARTITION BY c.first_name ||' '|| c.last_name ORDER BY c.first_name ||' '|| c.last_name) AS "jumlah_nilai_transaksi"
FROM customer c
	LEFT JOIN
	payment p
ON c.customer_id = p.customer_id
	LEFT JOIN
	rental r
ON p.rental_id = r.rental_id
ORDER BY jumlah_nilai_transaksi DESC, customer_name ASC
LIMIT 100;
