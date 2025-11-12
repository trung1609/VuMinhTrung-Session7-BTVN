-- Tạo bảng customers
CREATE TABLE xuatsac1.customers
(
    customer_id SERIAL PRIMARY KEY,
    full_name   VARCHAR(100),
    email       VARCHAR(100) UNIQUE,
    city        VARCHAR(50)
);

-- Tạo bảng products
CREATE TABLE xuatsac1.products
(
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category     TEXT[],
    price        NUMERIC(10, 2)
);

-- Tạo bảng orders
CREATE TABLE xuatsac1.orders
(
    order_id    SERIAL PRIMARY KEY,
    customer_id INT REFERENCES xuatsac1.customers (customer_id),
    product_id  INT REFERENCES xuatsac1.products (product_id),
    order_date  DATE,
    quantity    INT
);

-- Thêm dữ liệu cho bảng customers (5 khách hàng)
INSERT INTO xuatsac1.customers (full_name, email, city)
VALUES ('Nguyen Van A', 'vana@example.com', 'Ha Noi'),
       ('Tran Thi B', 'thib@example.com', 'Da Nang'),
       ('Le Van C', 'vanc@example.com', 'Ho Chi Minh'),
       ('Pham Thi D', 'thid@example.com', 'Can Tho'),
       ('Do Van E', 'vane@example.com', 'Hai Phong');

-- Thêm dữ liệu cho bảng products (5 sản phẩm)
INSERT INTO xuatsac1.products (product_name, category, price)
VALUES ('Laptop Dell Inspiron', ARRAY ['Electronics', 'Laptop'], 18500000.00),
       ('iPhone 15', ARRAY ['Electronics', 'Phone'], 29000000.00),
       ('Bàn phím cơ Keychron K2', ARRAY ['Electronics', 'Accessory'], 2300000.00),
       ('Tai nghe Sony WH-1000XM5', ARRAY ['Electronics', 'Audio'], 9500000.00),
       ('Chuột Logitech MX Master 3S', ARRAY ['Electronics', 'Accessory'], 2600000.00);

-- Thêm dữ liệu cho bảng orders (10 đơn hàng)
INSERT INTO xuatsac1.orders (customer_id, product_id, order_date, quantity)
VALUES (1, 1, '2025-11-01', 1),
       (1, 3, '2025-11-02', 2),
       (2, 2, '2025-11-03', 1),


       (2, 5, '2025-11-04', 1),
       (3, 4, '2025-11-05', 1),
       (3, 1, '2025-11-06', 1),
       (4, 3, '2025-11-07', 3),
       (4, 2, '2025-11-08', 1),
       (5, 5, '2025-11-09', 2),
       (5, 4, '2025-11-10', 1);

--Cau 2
create index idx_email on xuatsac1.customers (email);
create index idx_city on xuatsac1.customers using hash (city);
create index idx_category on xuatsac1.products using gin (category);
create index idx_price on xuatsac1.products using gist (price);

--Cau 3
explain analyse
select customers.customer_id, customers.email
from xuatsac1.customers
where email is not null;

explain analyse
select p.product_id, p.category
from xuatsac1.products p
where category @> ARRAY ['Electronics'];

explain analyse
select *
from xuatsac1.products p
where p.price between 5000000 and 10000000;

CREATE INDEX idx_order_date ON xuatsac1.orders(order_date);

cluster xuatsac1.orders using xuatsac1.idx_order_date;


