CREATE DATABASE IF NOT EXISTS datamart DEFAULT CHARACTER SET utf8	DEFAULT COLLATE utf8_general_ci;

drop table if exists datamart.transactions;

create table datamart.transactions as
-- select os.*, o.*, c.*, od.*, od.quantity * p.unit_price sub_total, p.*, pi.*, b.*
select concat(os.name,' ', os.country) online_store,
       o.order_id,
       c.customer_id,
       c.name,
       c.surname,
       c.username,
       c.country,
       c.email,
       o.create_date order_date,
       od.product_id,
       concat(b.name,' ',b.country) brand,
       pi.upc,
       pi.rpc,
       p.unit_price,
       od.quantity,
       p.quantity available_stock,
       round(od.quantity * p.unit_price,2) sub_total,
       round(o.order_amount,2) order_amount
from order_details od
join product p on (p.product_id = od.product_id)
join orders o on (o.order_id = od.order_id)
join online_stores os on (p.online_store_id = os.online_store_id)
join product_information pi on (p.product_information_id = pi.product_information_id)
join brands b on pi.brand_id = b.brand_id
join customers c on (c.customer_id = o.customer_id)
order by o.order_id;

-- 1. Show all transactions for a given week in your business
create view datamart.week40_transactions as
select * from datamart.transactions
where week(order_date) = 40;

select * from datamart.week40_transactions;

-- 3. Create a view of stock (by supplier) purchased by you
create view datamart.available_stock as
select brand, sum(available_stock) available_stock from datamart.transactions
group by brand;

select * from datamart.available_stock;

-- 4. Total stock sold to general public (by supplier) (A group by with roll-up
create view datamart.sold_items as
select brand, sum(quantity) sold_items from datamart.transactions
group by brand with rollup;

select * from datamart.sold_items;

-- 5. Detail and total transactions for the month-to-date. (A Group By with Roll-up)
-- NOTE: assuming you are looking for one month of transactions.
create view datamart.month10_tx_rollup as
select date(order_date), count(distinct order_id) from datamart.transactions
where month(date(order_date)) = 10
group by date(order_date)
with rollup;

select * from datamart.month10_tx_rollup;

-- 6. Detail and total revenue for the year-to-date. (A group By with Roll-up)
create view datamart.monthly_revenue_rollup as
select month(date(order_date)), sum(sub_total) from datamart.transactions
group by month(date(order_date)) with rollup;

select * from datamart.monthly_revenue_rollup;

-- 7. Detail and total transactions broken down on a monthly basis for 1 year. (A group By with Roll-up)
create view datamart.monthly_tx_rollup as
select month(date(order_date)), count(distinct order_id) from datamart.transactions
group by month(date(order_date)) with rollup;

select * from datamart.monthly_tx_rollup;

-- 8. Display the growth in sales/services (as a percentage) for your business, from the 1st month of opening until now.
create view datamart.growth_by_month as
select new_revenue.month
       , new_revenue.total
       ,round(((new_revenue.total - previous_revenue.total) / previous_revenue.total) * 100,2)
from
(select month(date(order_date)) month, sum(sub_total) total from datamart.transactions
group by month(date(order_date))) new_revenue
left join (select month(date(order_date)) + 1 month, sum(sub_total) total from datamart.transactions
group by month(date(order_date)) + 1) previous_revenue on new_revenue.month = previous_revenue.month;

select * from datamart.growth_by_month;