create database pizzahut;


use pizzahut;

CREATE TABLE orders (
order_id int not null, 
order_date date not null, 
order_time time not null,
primary key (order_id) );

CREATE TABLE order_details (
order_details_id int not null, 
order_id int not null, 
pizza_id text not null,
quantity int not null,
primary key (order_details_id) );

-- Retrieve the total number of orders places.

select count(order_id) as total_order from orders;

-- Calculate the total revenue generate from pizza sales

SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
-- Identify the highest priced pizza 

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- identify the most common pizza size orders

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

-- List the top 5 most orders pizza type along with their quantities

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS pizza_type
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY pizza_type DESC limit 5;


-- join the necessary table to find the total quantity of each pizza category orderd

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY total_quantity DESC;

-- Determine the distribution of orders by hour of the day

SELECT 
    HOUR(order_time), COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY order_count DESC;

-- Join relevant table to find the category-wise distribution of pizza.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Detrmine the top 3 most orderd pizza type base on revenue

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas
    ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
    ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- Monthly revenue
SELECT 
    MONTHNAME(orders.order_date) AS month,
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS revenue
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY MONTH(orders.order_date), MONTHNAME(orders.order_date)
ORDER BY MONTH(orders.order_date);


-- Weekday-wise Revenue
SELECT 
    DAYNAME(orders.order_date) AS day_name,
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS revenue
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY DAYNAME(orders.order_date)
ORDER BY revenue DESC;

-- Top 5 Customers (by number of orders)
SELECT
    order_id,
    COUNT(*) AS total_items
FROM order_details
GROUP BY order_id
ORDER BY total_items DESC
LIMIT 5;

-- Revenue by Pizza Size
SELECT
    pizzas.size,
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS revenue
FROM pizzas
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY revenue DESC;

-- Weekday vs Weekend Orders

SELECT
    CASE
        WHEN DAYOFWEEK(order_date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY day_type;


