CREATE DATABASE IF NOT EXISTS pim DEFAULT CHARACTER SET utf8	DEFAULT COLLATE utf8_general_ci;

CREATE USER IF NOT EXISTS 'pim'@'%' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'pim'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

USE pim;

drop table if exists order_details;
drop table if exists orders;
drop table if exists product;
drop table if exists product_information;
drop table if exists online_stores;
drop table if exists brands;
drop table if exists customers;

create table if not exists customers (
  customer_id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) not null,
  surname varchar(100) not null,
  country varchar(2) not null,
  email varchar(200) not null,
  username varchar(50) not null,
  create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  primary key (customer_id)
);

create table if not exists brands (
  brand_id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) not null,
  country varchar(2),
  is_active boolean default 0,
  create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  primary key (brand_id)
);

create table if not exists online_stores (
  online_store_id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) not null,
  country varchar(2) not null,
  primary key (online_store_id)
);

create table if not exists product_information (
  product_information_id int(11) NOT NULL AUTO_INCREMENT,
  brand_id int(11) NOT NULL,
  upc varchar(20) not null,
  rpc varchar(200) not null,
  product_name varchar(200) not null,
  product_description text not null,
  primary key (product_information_id),
  constraint brands_fk foreign key (brand_id) references brands (brand_id)
);

create table if not exists product (
  product_id int(11) NOT NULL AUTO_INCREMENT,
  brand_id int not null,
  online_store_id int not null,
  product_information_id int not null,
  category varchar(50),
  quantity int not null,
  primary key (product_id),
  constraint products_brands_fk foreign key (brand_id) references brands (brand_id),
  constraint online_stores_fk foreign key (online_store_id) references online_stores (online_store_id),
  constraint product_information_fk foreign key (product_information_id) references product_information (product_information_id)
);

create table if not exists orders (
  order_id int(11) NOT NULL AUTO_INCREMENT,
  online_store_id int(11) NOT NULL,
  customer_id int(11) NOT NULL,
  order_amount int(11),
  create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  primary key (order_id),
  constraint customers_fk foreign key (customer_id) references customers (customer_id),
  constraint orders_online_stores_fk foreign key (online_store_id) references online_stores (online_store_id)
);

create table if not exists order_details (
  order_details_id int(11) NOT NULL AUTO_INCREMENT,
  order_id int(11) NOT NULL,
  product_id int(11) NOT NULL,
  quantity int(11),
  unit_price int(11),
  total_amount int(11),
  primary key (order_details_id)
);