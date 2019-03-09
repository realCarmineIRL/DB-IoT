CREATE DATABASE IF NOT EXISTS pim DEFAULT CHARACTER SET utf8	DEFAULT COLLATE utf8_general_ci;

CREATE USER 'pim'@'%' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'pim'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

USE pim;

drop table if exists product_hist;
drop table if exists product;
drop table if exists availability_status;
drop table if exists product_attribute;
drop table if exists product_information;
drop table if exists online_store;
drop table if exists customers;

create table if not exists customers (
  customer_id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) not null,
  is_active boolean default 0,
  create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  primary key (customer_id)
);

create table if not exists online_store (
  online_store_id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) not null,
  country varchar(100) not null,
  primary key (online_store_id)
);

create table if not exists product_information (
  product_information_id int(11) NOT NULL AUTO_INCREMENT,
  upc varchar(20) not null,
  rpc varchar(200) not null,
  primary key (product_information_id)
);

create table if not exists product_attribute (
  product_attribute_id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(200) not null,
  start_date date not null,
  end_date date default null,
  primary key (product_attribute_id)
);

create table if not exists product (
  product_id int(11) NOT NULL AUTO_INCREMENT,
  customer_id int not null,
  online_store_id int not null,
  product_information_id int not null,
  product_attribute_id int not null,
  primary key (product_id),
  constraint customer_fk foreign key (customer_id) references customers (customer_id),
  constraint online_store_fk foreign key (online_store_id) references online_store (online_store_id),
  constraint product_information_fk foreign key (product_information_id) references product_information (product_information_id),
  constraint product_attribute_fk foreign key (product_attribute_id) references product_attribute (product_attribute_id)
);

create table availability_status (
  availability_status_id int not null AUTO_INCREMENT,
  name varchar(50) not null,
  description varchar(200),
  primary key (availability_status_id)
);

create table if not exists product_hist (
  product_hist_id bigint not null auto_increment,
  report_date date not null,
  product_id int not null,
  availability_status int not null,
  primary key (product_hist_id, report_date),
  constraint product_fk foreign key (product_id) references product (product_id),
  constraint availability_status_fk foreign key (availability_status) references availability_status (availability_status_id)
);

insert into customers (name, is_active)
values ('colgate', 1),
       ('lg', 1),
       ('nintendo', 1),
       ('samsung', 0),
       ('apple', 1);

insert into online_store (name, country)
values ('amazon', 'UK'),
       ('boots','UK'),
       ('argos','IE'),
       ('currys','IE'),
       ('gamestop','IE');

insert into product_information (upc, rpc)
values ('UP04242352', 'RP423545BX42432'),
       ('UP04242353', 'RP423545BX42433'),
       ('UP04242354', 'RP423545BX42434'),
       ('UP04242355', 'RP423545BX42435'),
       ('UP04242356', 'RP423545BX42436');

insert into product_attribute (name, start_date, end_date)
values ('iPhone', '2019-02-01', null),
       ('Nintendo Switch', '2019-02-01', null),
       ('Galaxy Note 7', '2016-09-15', '2017-12-31'),
       ('Oled 55inch 4k', '2019-01-01', null),
       ('Smart Toothbrush', '2019-01-15', null);

insert into availability_status (name)
values ('In Stock'),
       ('Out of Stock'),
       ('Marketplace'),
       ('Void');

insert into product (customer_id, online_store_id, product_information_id, product_attribute_id)
values (1,2,1,5),
       (2,3,3,4),
       (3,5,2,2),
       (4,1,4,3),
       (5,4,5,1);

insert into product_hist (report_date, product_id, availability_status)
values ('2019-03-09', 1, 1),
       ('2019-03-09', 2, 1),
       ('2019-03-09', 3, 2),
       ('2019-03-09', 4, 3),
       ('2019-03-09', 5, 1);