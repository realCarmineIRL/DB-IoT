CREATE DATABASE IF NOT EXISTS datamart DEFAULT CHARACTER SET utf8	DEFAULT COLLATE utf8_general_ci;

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