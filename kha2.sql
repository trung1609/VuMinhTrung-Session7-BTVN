CREATE TABLE kha2.customer
(
    customer_id SERIAL PRIMARY KEY,
    full_name   VARCHAR(100),
    email       VARCHAR(100),
    phone       VARCHAR(15)
);

CREATE TABLE kha2.orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES kha2.customer (customer_id),
    total_amount DECIMAL(10, 2),
    order_date   DATE
);

INSERT INTO kha2.customer (full_name, email, phone)
VALUES ('Alice Johnson', 'alice.johnson@example.com', '555-123-4567'),
       ('Bob Smith', 'bob.smith@example.com', '555-234-5678'),
       ('Charlie Brown', 'charlie.brown@example.com', '555-345-6789'),
       ('Diana Prince', 'diana.prince@example.com', '555-456-7890'),
       ('Ethan Hunt', 'ethan.hunt@example.com', '555-567-8901');

INSERT INTO kha2.orders (customer_id, total_amount, order_date)
VALUES (1, 120.50, '2025-01-15'),
       (2, 75.00, '2025-02-10'),
       (3, 220.99, '2025-03-22'),
       (1, 89.30, '2025-04-05'),
       (5, 340.00, '2025-05-18');

create view kha2.v_order_summary as
select c.full_name, o.total_amount as total, o.order_date
from kha2.customer c
         join kha2.orders o on c.customer_id = o.customer_id;

select *
from kha2.v_order_summary;

create view kha2.v_monthly_sales as
select to_char(order_date, 'YYYY-MM') as month, sum(o.total_amount) as total_revenue
from kha2.orders o
group by to_char(order_date, 'YYYY-MM');



