use olist_ecommerce;
show tables;
select * from olist_order_items_dataset limit 5;
select * from olist_customers_dataset limit 5;
select * from olist_products_dataset limit 5;
select * from olist_orders_dataset limit 5;
select * from product_category_name_translation limit 5;

-- Order Status Breakdown
select order_status, count(*) as total_orders from olist_orders_dataset
group by order_status
order by total_orders desc;

-- Order Category Breakdown
select
case  when order_status = 'delivered' then 'Completed'
	when order_status in ('canceled', 'unavailable') then 'Unsuccessful'
    else 'In Progress'
    end as order_category,
    count(*) as total_orders from
olist_orders_dataset
group by order_category
order by total_orders desc;

-- Total Revenue generated
select round(sum(price)) as Total_Revenue
from olist_order_items_dataset;

-- Top 10 Product Categories by Revenue
select c.product_category_name_english, round(sum(i.price),2) as Revenue 
from olist_order_items_dataset i
join olist_products_dataset p
 on i.product_id = p.product_id
join product_category_name_translation c 
on p.product_category_name = c.product_category_name
group by c.product_category_name_english
order by Revenue desc limit 10;

-- Total Orders per Month
select substring(order_purchase_timestamp, 1,7) as Month,
count(*) as Total_Orders
from olist_orders_dataset
group by Month 
order by Total_Orders desc;

-- Average Order Value 
select round(avg(price),2) as Average_order_value
from olist_order_items_dataset;

-- Top 10 Customers Cities by Orders
select c.customer_city, count(o.order_id) as total_orders
from olist_customers_dataset c
join olist_orders_dataset o 
on c.customer_id = o.customer_id
group by customer_city
order by total_orders
desc limit 10;

-- Top 10 Products by Quantity Sold
select c.product_category_name_english, count(o.order_id) as total_quantity
from olist_order_items_dataset o
join olist_products_dataset i
on o.product_id = i.product_id
join product_category_name_translation c
on c.product_category_name = i.product_category_name
group by product_category_name_english
order by total_quantity desc
limit 10;

-- Revenue by Year
select substring(o.order_purchase_timestamp,1,4) as year, round(sum(i.price),2) as revenue
from olist_orders_dataset o
join olist_order_items_dataset i
on o.order_id = i.order_id
group by year
order by year;

-- Total Orders
select count(distinct order_id) as total_orders from olist_orders_dataset;

-- Total Products Sold
select count(order_item_id) as total_products_sold from olist_order_items_dataset;

-- KPIs values
select 
round(sum(price),2) as Total_Revenue,
count(distinct o.order_id) as total_orders,
count(oi.order_item_id) as total_products_sold,
round(avg(price),2) as avg_order_value
from olist_orders_dataset o
join olist_order_items_dataset oi
on o.order_id = oi.order_id;