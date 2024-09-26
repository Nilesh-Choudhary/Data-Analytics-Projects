--  Use the created database
use ecommerce;

-- show all tables in the 'ecommerce' database
show tables;

-- count the number of orders per year
select year(order_purchase_timestamp), count(order_id) 
from orders 
group by year(order_purchase_timestamp) 
order by year(order_purchase_timestamp) asc;

-- calculate total sales by product category
select upper(products.product_category) as category, 
round(sum(payments.payment_value), 2) as sales
from products 
join order_items on products.product_id = order_items.product_id
join payments on payments.order_id = order_items.order_id
group by category
order by sales desc;

-- percentage of orders paid in installments
select ((sum(case when payment_installments >= 1 then 1 else 0 end) / count(*)) * 100) as orders_pays_in_installment 
from payments;

-- count customers by state
select customer_state, count(customer_id) 
from customers 
group by customer_state;

-- count orders by month in 2018
select monthname(order_purchase_timestamp) as months, count(order_id) as order_count 
from orders 
where year(order_purchase_timestamp) = 2018 
group by months;

-- average number of orders per city
with count_per_order as (
select orders.order_id, orders.customer_id, count(order_items.order_id) as oc 
from orders 
join order_items on orders.order_id = order_items.order_id 
group by orders.order_id, orders.customer_id
)
select customers.customer_city, round(avg(count_per_order.oc), 2) as average_orders 
from customers 
join count_per_order on customers.customer_id = count_per_order.customer_id 
group by customers.customer_city 
order by average_orders desc;

-- sales percentage by product category
select upper(products.product_category) as category, 
round((sum(payments.payment_value) / (select sum(payment_value) from payments)) * 100, 2) as sales_percentage 
from products 
join order_items on products.product_id = order_items.product_id 
join payments on payments.order_id = order_items.order_id 
group by category 
order by sales_percentage desc;

-- total payments by payment type
select payment_type, count(*) as total_payments 
from payments 
group by payment_type;

-- calculate delivery delays for orders
select order_id, 
datediff(order_delivered_customer_date, order_estimated_delivery_date) as delivery_delay_days 
from orders;

-- top 10 products by purchase count
select product_id, count(*) as total_purchases 
from order_items 
group by product_id 
order by total_purchases desc 
limit 10;

-- revenue ranking by seller
select *, dense_rank() over(order by revenue desc) as rn 
from (
select order_items.seller_id, sum(payments.payment_value) as revenue 
from order_items 
join payments on order_items.order_id = payments.order_id 
group by order_items.seller_id
) as revenue;

-- total orders by customer city
select c.customer_city, count(o.order_id) as total_orders 
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_city 
order by total_orders desc;

-- total orders and average freight by seller
select seller_id, count(order_id) as total_orders, avg(freight_value) as avg_freight 
from order_items 
group by seller_id;

-- top 5 products by order count
select product_id, count(order_item_id) as product_count 
from order_items 
group by product_id 
order by product_count desc 
limit 5;

-- average delivery time by seller
select oi.seller_id, avg(datediff(o.order_delivered_customer_date, oi.shipping_limit_date)) as avg_delivery_time_days 
from order_items oi 
join orders o on oi.order_id = o.order_id 
group by oi.seller_id 
limit 10;

-- total freight and average price by product category
select p.product_category, sum(o.freight_value) as total_freight, avg(o.price) as avg_price 
from order_items o 
join products p on o.product_id = p.product_id 
group by p.product_category 
limit 10;

-- count of on-time deliveries
select count(*) as on_time_deliveries 
from order_items oi 
join orders o on oi.order_id = o.order_id 
where o.order_delivered_customer_date <= oi.shipping_limit_date;

-- average payment value by payment type
select payment_type, avg(payment_value) as avg_payment_value 
from payments 
group by payment_type 
order by avg_payment_value desc;

-- total orders by city (top 5)
select c.customer_city, count(o.order_id) as total_orders 
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_city 
order by total_orders desc 
limit 5;

-- identify late deliveries
select * 
from orders 
where order_delivered_customer_date > order_estimated_delivery_date;

-- count of products by category
select product_category, count(product_id) as total_products 
from products 
group by product_category 
order by total_products desc;

-- moving average payment per customer
select customer_id, order_purchase_timestamp, payment, 
avg(payment) over(partition by customer_id order by order_purchase_timestamp 
rows between 2 preceding and current row) as mov_avg 
from (
select orders.customer_id, orders.order_purchase_timestamp, payments.payment_value as payment 
from payments 
join orders on payments.order_id = orders.order_id
) as a;

-- cumulative sales by year and month
select years, months, payment, sum(payment) over(order by years, months) as cumulative_sales 
from (
select year(orders.order_purchase_timestamp) as years, 
month(orders.order_purchase_timestamp) as months, 
round(sum(payments.payment_value), 2) as payment 
from orders 
join payments on orders.order_id = payments.order_id 
group by years, months 
order by years, months
) as a;

-- yearly growth rate in revenue
with a as (
select year(orders.order_purchase_timestamp) as years, 
round(sum(payments.payment_value), 2) as payment 
from orders 
join payments on orders.order_id = payments.order_id 
group by years 
order by years
)
select years, 
    ((payment - lag(payment, 1) over(order by years)) / lag(payment, 1) over(order by years)) * 100 
from a;

-- top 3 customers by payment per year
select years, customer_id, payment, d_rank 
from (
select year(orders.order_purchase_timestamp) as years, 
orders.customer_id, 
sum(payments.payment_value) as payment, 
dense_rank() over(partition by year(orders.order_purchase_timestamp) 
order by sum(payments.payment_value) desc) as d_rank 
from orders 
join payments on payments.order_id = orders.order_id 
group by year(orders.order_purchase_timestamp), orders.customer_id
) as a 
where d_rank <= 3;

-- top 5 products by revenue within each category
select category, product_id, total_revenue 
from (
select upper(p.product_category) as category, oi.product_id, 
sum(oi.price) as total_revenue, 
rank() over(partition by p.product_category order by sum(oi.price) desc) as rank_num 
from products p 
join order_items oi on p.product_id = oi.product_id 
group by p.product_category, oi.product_id
) as ranked_products 
where rank_num <= 5 and category is not null;

-- customer lifetime value
select c.customer_id, sum(p.payment_value) as lifetime_value 
from customers c 
join orders o on c.customer_id = o.customer_id 
join payments p on o.order_id = p.order_id 
group by c.customer_id 
order by lifetime_value desc;

-- total orders by payment type in 2018
select p.payment_type, count(*) as total_orders 
from payments p 
join orders o on p.order_id = o.order_id 
where year(o.order_purchase_timestamp) = 2018 
group by p.payment_type;

-- total freight by shipping limit date
select oi.shipping_limit_date, sum(oi.freight_value) as total_freight 
from order_items oi 
join orders o on oi.order_id = o.order_id 
group by oi.shipping_limit_date 
order by total_freight desc;

-- monthly sales by seller
select s.seller_id, year(o.order_purchase_timestamp) as year, 
month(o.order_purchase_timestamp) as month, 
sum(p.payment_value) as monthly_sales 
from sales s 
join order_items oi on s.seller_id = oi.seller_id 
join orders o on oi.order_id = o.order_id 
join payments p on o.order_id = p.order_id 
group by s.seller_id, year, month 
order by monthly_sales desc 
limit 10;

-- products that were never ordered
select product_id, product_name 
from products 
where product_id not in (select distinct product_id from order_items);

-- total payments by year and month
select year(order_purchase_timestamp) as year, month(order_purchase_timestamp) as month, 
sum(payment_value) as total_payments 
from payments 
join orders on payments.order_id = orders.order_id 
group by year, month;

-- customers with more than X orders
select customer_id, count(order_id) as order_count 
from orders 
group by customer_id 
having order_count > X;

-- products with the highest average review score
select product_id, avg(review_score) as average_review_score 
from reviews 
group by product_id 
order by average_review_score desc 
limit 10;

-- order status distribution
select order_status, count(order_id) as total_orders 
from orders 
group by order_status;
