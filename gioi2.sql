CREATE TABLE gioi2.customer (
                          customer_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          region VARCHAR(50)
);

CREATE TABLE gioi2.orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT REFERENCES gioi2.customer(customer_id),
                        total_amount DECIMAL(10,2),
                        order_date DATE,
                        status VARCHAR(20)
);

CREATE TABLE gioi2.product (
                         product_id SERIAL PRIMARY KEY,
                         name VARCHAR(100),
                         price DECIMAL(10,2),
                         category VARCHAR(50)
);

CREATE TABLE gioi2.order_detail (
                              order_id INT REFERENCES gioi2.orders(order_id),
                              product_id INT REFERENCES gioi2.product(product_id),
                              quantity INT
);

INSERT INTO gioi2.customer (full_name, region) VALUES
                                             ('Nguyen Van A', 'Hanoi'),
                                             ('Tran Thi B', 'Ho Chi Minh City'),
                                             ('Le Van C', 'Da Nang'),
                                             ('Pham Thi D', 'Can Tho'),
                                             ('Do Van E', 'Hai Phong');

INSERT INTO gioi2.product (name, price, category) VALUES
                                                ('Laptop Dell XPS 13', 25000000.00, 'Electronics'),
                                                ('iPhone 15 Pro', 32000000.00, 'Mobile'),
                                                ('Logitech MX Master 3S Mouse', 2500000.00, 'Accessories'),
                                                ('Samsung 4K TV', 15000000.00, 'Electronics'),
                                                ('Sony WH-1000XM5 Headphones', 9000000.00, 'Audio');
INSERT INTO gioi2.orders (customer_id, total_amount, order_date, status) VALUES
                                                                       (1, 25000000.00, '2025-11-01', 'Completed'),
                                                                       (2, 32000000.00, '2025-11-03', 'Processing'),
                                                                       (3, 9000000.00, '2025-11-05', 'Shipped'),
                                                                       (4, 40000000.00, '2025-11-07', 'Pending'),
                                                                       (5, 15000000.00, '2025-11-09', 'Completed');

INSERT INTO gioi2.order_detail (order_id, product_id, quantity) VALUES
                                                              (1, 1, 1),
                                                              (2, 2, 1),
                                                              (3, 5, 1),
                                                              (4, 1, 1),
                                                              (5, 4, 1);

create view gioi2.v_revenue_by_region as
select c.region, sum(o.total_amount) as total_revenue
from gioi2.customer c
         join gioi2.orders o on c.customer_id = o.customer_id
group by c.region;

select v.region, v.total_revenue from v_revenue_by_region as v
order by v.total_revenue desc limit 3;

create materialized view gioi2.mv_monthly_sales as
select date_trunc('month', order_date) as month,
         sum(total_amount) as monthly_revenue, orders.status
from gioi2.orders
group by date_trunc('month', order_date), orders.status;

update gioi2.mv_monthly_sales set status = 'Shipped' where monthly_revenue = '40000000';


select *
from gioi2.v_revenue_by_region where total_revenue > (
select avg(total_revenue) as avg_revenue
                               from gioi2.v_revenue_by_region);
