create database QUANLYBANHANG;
create table products(
product_id varchar(4) primary key not null,
name varchar(255) not null,
description TEXT,
price DOUBLE not null,
status BIT(1) 
);
create table customers(
customer_id varchar(4) primary key not null,
name varchar (100) not null,
email varchar(100) not null,
phone varchar(25) not null,
address varchar (255) not null

);
create table orders (
order_id varchar(4) primary key not null,
customer_id varchar(4) not null,
order_date DATE not null,
total_amount DOUBLE not null

);
create table orders_details(
order_id varchar(4) not null,
product_id varchar(4) not null,
quantity int(11) not null,
price DOUBLE not null
);
ALTER TABLE orders
ADD CONSTRAINT orders
FOREIGN KEY (customer_id)
REFERENCES Customers (customer_id);
ALTER TABLE orders_details
ADD CONSTRAINT fk_orders_details
FOREIGN KEY (product_id)
REFERENCES products (product_id);
ALTER TABLE orders_details
ADD CONSTRAINT fk_orders
FOREIGN KEY (order_id)
REFERENCES orders (order_id);

-- Bài 2: Thêm dữ liệu [20 điểm]:
-- Thêm dữ liệu vào các bảng như sau :
-- - Bảng CUSTOMERS [5 điểm] :


insert into customers() values("C001","Nguyễn truung manh","manhnt@gmail.com",984756322,"Cầu giấy,Hà Nội"),
("C002","Hồ Hải Nam","namhh@gmail.com",984875296,"Ba vì,Hà Nội"),
("C003","Tô Ngọc vũ","vutn@gmail.com",904725784,"Mộc châu ,Sơn La"),
("C004","Phạm ngọc Anh","anhpn@gmail.com",984635365,"Cầu giấy,Hà Nội"),
("C005","Trương Minh cường","cuongtm@gmail.com",989735624,"hai bà trưng,Hà Nội");

-- - Bảng PRODUCTS [5 điểm]:

insert into products(product_id, name, description, price) values 
	("P001",'iphone 13 Promax','Bản 512,xanh lá',22999999),
    ("P002",'Dell Vostro V3510','oreI5, RAM 8g',14999999),
    ("P003",'Mac book pro M2','8CPU 10GPU8GB 256GB',28999999),
    ("P004",'Apple Watch Untra','Titanium Alpine Loop Small',18999999),
    ("P005",'Airpod 2 2022','Spatial Audio',4090000)
;
-- + bảng ORDERS [5 điểm]:
INSERT INTO orders (order_id, customer_id, total_amount, order_date) VALUES
  ('H001', 'C001', 52999997, '2023-02-22'),
  ('H002', 'C001', 80999997, '2023-03-11'),
  ('H003', 'C002', 54359998, '2023-01-22'),
  ('H004', 'C003', 102999995, '2023-03-14'),
  ('H005', 'C003', 80999997, '2023-03-12'),
  ('H006', 'C004', 110449994, '2023-02-01'),
  ('H007', 'C004', 79999996, '2023-03-29'),
  ('H008', 'C005', 52999997, '2023-02-14'),
  ('H009', 'C005', 29999998, '2023-01-10'),
  ('H010', 'C005', 149999994, '2023-04-01');

-- + bảng Orders_details[5 điểm]:

insert into orders_details(order_id, product_id, price, quantity) values
 ('H001', 'P002', 14999999, 1),
 ('H001', 'P004', 18999999, 2),
 ('H002', 'P001', 22999999, 1),
 ('H002', 'P003', 28999999, 2),
 ('H003', 'P004', 18999999, 2),
('H003', 'P005', 4090000, 4),
 ('H004', 'P002', 14999999, 3),
 ('H004', 'P003', 28999999, 2),
 ('H005', 'P001', 22999999, 1),
 ('H005', 'P003', 28999999, 2),
 ('H006', 'P005', 4090000, 5),
 ('H006', 'P002', 14999999, 6),
 ('H007', 'P004', 18999999, 3),
 ('H007', 'P001', 22999999, 1),
 ('H008', 'P002', 14999999, 2),
 ('H009', 'P003', 28999999, 1),
 ('H010', 'P003', 28999999, 2),
 ('H010', 'P001', 22999999, 4);
 
--  Bài 3: Truy vấn dữ liệu [30 điểm]:
-- Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
-- [4 điểm] 

select c.name,c.email,c.phone,c.address 
from customers c;


-- Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
-- thoại và địa chỉ khách hàng). [4 điểm]
SELECT c.name, c.phone, c.address
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN orders_details od ON o.order_id = od.order_id
WHERE o.order_date >= '2023-03-01' AND o.order_date <= '2023-03-31'
GROUP BY c.customer_id;

-- Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
-- tháng và tổng doanh thu ). [4 điểm]
SELECT MONTH(order_date) AS month, SUM(total_amount) AS total_revenue
FROM orders
WHERE YEAR(order_date) = 2023
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);


-- Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại). [4 điểm]
SELECT c.name, c.address, c.email, c.phone
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND MONTH(o.order_date) = 2 AND YEAR(o.order_date) = 2023
WHERE o.order_id IS NULL;


-- Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
SELECT p.product_id, p.name, SUM(od.quantity) AS "tổng số lượng bán ra"
FROM orders_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN orders o ON od.order_id = o.order_id
WHERE MONTH(o.order_date) = 3 AND YEAR(o.order_date) = 2023
GROUP BY p.product_id, p.name;

-- Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
SELECT c.customer_id, c.name, SUM(od.price*od.quantity) AS total
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN orders_details od ON o.order_id = od.order_id
WHERE YEAR(o.order_date) = 2023
GROUP BY c.customer_id, c.name
ORDER BY total DESC;
-- Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]


SELECT c.name , SUM(od.price * od.quantity) AS total_amount, o.order_date, SUM(od.quantity) AS total_quantity
FROM orders o
INNER JOIN orders_details od ON o.order_id = od.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY  c.name, o.order_date
HAVING total_quantity >= 5;



-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn . [3 điểm]
CREATE VIEW order_infor AS
SELECT c.name , c.phone, c.address, SUM(od.price * od.quantity) AS total_amount, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN orders_details od ON o.order_id = od.order_id
GROUP BY  c.name, c.phone, c.address, o.order_date;
SELECT * FROM order_infor;

-- Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt. [3 điểm]


CREATE VIEW CUSTOMER_VIEW as
SELECT c.name , c.address ,c.phone, count(o.order_id) as 'Tổng số đơn'
FROM CUSTOMERS c
JOIN ORDERS  o ON o.customer_id = c.customer_id
GROUP BY c.name, c.address, c.phone;
SELECT * FROM CUSTOMER_VIEW;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm.[3 điểm]

CREATE VIEW product_info AS
SELECT p.name, p.description, p.price, SUM(od.quantity) AS "tổng số lượng bán ra"
FROM products p
inner JOIN orders_details od ON p.product_id = od.product_id
GROUP BY  name, p.description, p.price;
Select* from product_info ;

-- Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]
ALTER TABLE customers
ADD INDEX index_phone (phone),
ADD INDEX index_email (email);


-- Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
DELIMITER //

CREATE PROCEDURE GetCustomer(IN customer_id VARCHAR(4))
BEGIN
    SELECT *
    FROM customers
    WHERE customer_id = customer_id;
END //

DELIMITER ;
call GetCustomer("P001");


-- Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
DELIMITER //

CREATE PROCEDURE GetProducts()
BEGIN
    SELECT *
    FROM products;
END //

DELIMITER ;

call GetProducts();

-- Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]

DELIMITER //

CREATE PROCEDURE GetOrdersByCustomer(IN customer_id VARCHAR(4))
BEGIN
    SELECT *
    FROM orders
    INNER JOIN customers ON orders.customer_id = customers.customer_id
    WHERE customers.customer_id = customer_id;
END //

DELIMITER ;

call GetOrdersByCustomer('C001');

-- Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]

DELIMITER //
CREATE PROCEDURE CreateOders (IN customerId VARCHAR(4), total_amount DOUBLE, date DATE)
BEGIN
	DECLARE last_id INT;
    DECLARE new_id VARCHAR(4);

	SET last_id = (
    SELECT CAST(SUBSTRING(order_id, 2, 4) AS SIGNED)
    FROM ORDERS
    ORDER BY SUBSTRING(order_id, 2, 4) DESC
    LIMIT 1
	);
    
	SET new_id = (CASE
		WHEN (last_id + 1) < 10 THEN CONCAT('H00', (last_id + 1))
        WHEN (last_id + 1) < 100 THEN CONCAT('H0', (last_id + 1))
        ELSE CONCAT('H', (last_id + 1))
        END
	);
    
	INSERT INTO ORDERS(order_id, customer_id, total_amount, order_date) VALUES 
    (new_id, customerId, total_amount, date);
    
    SELECT new_id;
END //
DELIMITER ;
CALL CreateOders('C001', 1499999, '2023-11-23');





