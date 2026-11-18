CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category TEXT,
    price NUMERIC(10,2),
    stock_quantity INT,
    is_available BOOLEAN,
    added_on DATE
);

-- Creating Child Table: Orders
-- product_id is the Foreign Key

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    order_date DATE,
    customer_name VARCHAR(50),
    payment_method VARCHAR(50),
    CONSTRAINT fk_product FOREIGN KEY (product_id)
    REFERENCES products(product_id) ON DELETE CASCADE
);

-- VIEW TABLE DATA

-- Display all records from Products table

SELECT * FROM products;

-- Display all records from Orders table

SELECT * FROM orders;

-- 1. Show each order along with the product name and price.

SELECT
    orders.order_id,
    products.product_name,
    products.price
FROM products
INNER JOIN orders
ON products.product_id = orders.product_id;

-- 2. Show all products even if they were never ordered. 

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    o.order_id
FROM products AS p
LEFT JOIN orders AS o
ON p.product_id = o.product_id;

-- 3.Show orders for only ‘Electronics’ category.

SELECT
    o.order_id,
    o.customer_name,
    p.product_name,
    p.category,
    p.price,
    o.quantity
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id
WHERE p.category = 'Electronics';

-- 4.List all orders sorted by product price (high to low).

SELECT
    o.order_id,
    o.customer_name,
    p.product_name,
    p.price,
    o.quantity
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id
ORDER BY p.price DESC;

-- 5.Show number of orders placed for each product.

SELECT
    p.product_id,
    p.product_name,
    COUNT(o.order_id) AS total_orders
FROM products AS p
LEFT JOIN orders AS o
ON p.product_id = o.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_orders DESC;

-- 6.Show total revenue earned per product.

SELECT
    p.product_id,
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM products AS p
INNER JOIN orders AS o
ON p.product_id = o.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;

-- 7.Show products where total order revenue > ₹2000.

SELECT
    p.product_id,
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM products AS p
INNER JOIN orders AS o
ON p.product_id = o.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING SUM(p.price * o.quantity) > 2000
ORDER BY total_revenue DESC;

-- 8.Show unique customers who ordered ‘Fitness’ products.

SELECT DISTINCT
    o.customer_name
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id
WHERE p.category = 'Fitness'
ORDER BY o.customer_name;