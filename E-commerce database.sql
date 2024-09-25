CREATE DATABASE shopdata;

USE shopdata;

-- 1. Find customer information for each order.

SELECT *
FROM
    olist_orders_dataset o
JOIN 
    olist_customers_dataset c ON o.customer_id = c.customer_id;


-- 2. Find all orders with status 'delivered'.

SELECT *
FROM 
   olist_orders_dataset
WHERE 
   order_status = 'delivered';


-- 3. Find all customers from franca with state sp .

SELECT *
FROM 
   olist_customers_dataset
WHERE 
   customer_city = 'franca';


-- 4. Retrieve the customer ID, city, and order status for customers from São Paulo, Tocós, and Franca who have orders with status 'delivered' or 'shipped' limited to 2000 results.

SELECT  ocd.customer_id,ocd.customer_city,ood.order_status 
FROM
    olist_customers_dataset AS ocd 
INNER JOIN 
    olist_orders_dataset AS ood ON  ocd.customer_id=ood.customer_id
WHERE 
    ood.order_status IN ('delivered' ,'shipped') AND ocd.customer_city IN ('sao paulo''tocos','franca')
GROUP BY
     customer_id,customer_city ,ood.order_status
LIMIT 2000 ;
 
 
-- 5. Find the average product weight and dimensions (length, height, width) for each product category.

SELECT p.product_category_name, 
   AVG(p.product_weight_g) AS avg_weight,
   AVG(p.product_length_cm) AS avg_length, 
   AVG(p.product_height_cm) AS avg_height, 
   AVG(p.product_width_cm) AS avg_width
FROM 
   olist_products_dataset p
GROUP BY
   p.product_category_name ;


-- 6. Identify the top 5 products with the highest sales revenue, along with their product categories.

SELECT opd.product_id, opd.product_category_name, SUM(oi.price) AS total_revenue
FROM 
   olist_order_items_dataset oi
JOIN 
   olist_products_dataset opd ON oi.product_id = opd.product_id
GROUP BY 
   opd.product_id,
   opd.product_category_name
ORDER BY 
   total_revenue DESC
LIMIT 2;


-- 7. Identify the payment types with average payment values above $50.

SELECT payment_type, AVG(payment_value) AS avg_payment
FROM
   olist_order_payments_dataset
GROUP BY
   payment_type
HAVING AVG(payment_value) > (SELECT AVG(payment_value) FROM olist_order_payments_dataset);


-- 8. Calculate the total orders and revenue for each seller in curitiba and arrange highest revenue first , along with seller information.

SELECT s.seller_id,  COUNT(o.order_id) AS num_orders, SUM(oi.price) AS total_revenue,s.seller_city
FROM 
   olist_order_items_dataset oi
JOIN 
   olist_sellers_dataset s ON oi.seller_id = s.seller_id
JOIN 
   olist_orders_dataset o ON oi.order_id = o.order_id
WHERE
   s.seller_city = 'curitiba'  
GROUP BY
   s.seller_id , s.seller_city 
ORDER BY 
   total_revenue DESC;


-- 9. Identify the top 5 products with the highest total revenue.Calculate the average payment value for each payment method with payment sequential greater than 1.

SELECT ooid.product_id, SUM(ooid.price) AS total_revenue, AVG(oopd.payment_value) AS avg_payment_value ,oopd.payment_type ,oopd.payment_sequential
FROM
    olist_order_items_dataset ooid
JOIN
    olist_order_payments_dataset oopd ON ooid.order_id =oopd.order_id 
GROUP BY 
    ooid.product_id,payment_type ,oopd.payment_sequential
HAVING 
   payment_sequential >1
ORDER BY 
   total_revenue  DESC
LIMIT 5;


-- 10. Analyze the distribution of orders by hour of day, day of week, and month.

SELECT 
  EXTRACT(HOUR FROM o.order_estimated_delivery_date) AS hour,
  EXTRACT(DAY FROM o.order_estimated_delivery_date) AS day,
  EXTRACT(MONTH FROM o.order_estimated_delivery_date) AS month,
  COUNT(*) AS num_orders
FROM 
  olist_orders_dataset o
GROUP BY 
  hour, day, month
ORDER BY 
  num_orders DESC
LIMIT 500;
  
  
--   11. Find orders with total value greater than the customer's average order value for order item id not less than 3 .

SELECT *
FROM
    olist_order_items_dataset o
WHERE price > (SELECT AVG(price) FROM olist_order_items_dataset 
WHERE
    o.order_item_id > 3
);


-- 12. find top 5 sellers and shipping limit greater than a specific date  using cte .

WITH top_sellers AS (
  SELECT seller_id, SUM(price) AS total_sales , shipping_limit_date
  FROM 
     olist_order_items_dataset
  GROUP BY
     seller_id ,shipping_limit_date
  HAVING 
     shipping_limit_date > '14-12-2017 12:10:31'
  ORDER BY 
     total_sales DESC
  LIMIT 5
)
SELECT * FROM top_sellers;


-- 13. limit Top 5 customers by total spending greater than specific price.

SELECT 
  c.customer_id,
  c.customer_city,
  c.customer_unique_id,
  SUM(oi.price) AS total_spending
FROM 
   olist_orders_dataset o
JOIN 
   olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN 
   olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY 
   c.customer_id,c.customer_city,c.customer_unique_id 
HAVING 
   SUM(oi.price) > 13000
ORDER BY 
   total_spending DESC
LIMIT 5;

















 



 
 

 




