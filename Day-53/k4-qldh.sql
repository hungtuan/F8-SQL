-- Tạo database
CREATE DATABASE database_02_tuank4

-- Tạo bảng customers
CREATE TABLE customers(
  id BIGSERIAL NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(50) NOT NULL,
  status boolean DEFAULT true NOT NULL,
  created_at timestamptz DEFAULT NOW() NOT NULL,
  updated_at timestamptz DEFAULT NOW() NOT NULL
);

-- Tạo bảng products
CREATE TABLE products(
  id BIGSERIAL NOT NULL PRIMARY KEY,
  quantity integer NOT NULL,
  price real NOT NULL,
  created_at timestamptz DEFAULT NOW() NOT NULL,
  updated_at timestamptz DEFAULT NOW() NOT NULL
);

ALTER TABLE products
ADD COLUMN name VARCHAR(50) NOT NULL;

-- Tạo bảng orders
CREATE TABLE orders(
  id BIGSERIAL PRIMARY KEY NOT NULL,
  customer_id BIGINT REFERENCES customers(id),
  product_quantity integer NOT NULL,
  total_amount DECIMAL(12, 2) NOT NULL,
  status VARCHAR(50) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
);

-- Tạo bảng order_detail
CREATE TABLE order_detail(
  id BIGSERIAL NOT NULL PRIMARY KEY,
  order_id BIGINT REFERENCES orders(id),
  product_id BIGINT REFERENCES products(id),
  quantity INT NOT NULL,
  item_amount DECIMAL(12, 2) NOT NULL
);


-- Thêm dữ liệu ...

-- Danh sách đơn hàng
CREATE VIEW orders_view AS
SELECT
    customers.name AS customer_name,
    customers.email AS customer_email,
    customers.phone AS customer_phone,
    orders.product_quantity AS total_quantity,
    orders.total_amount,
    orders.status AS order_status,
    orders.created_at AS order_date
FROM orders 
JOIN customers ON orders.customer_id = customers.id;

SELECT * FROM orders_view;

-- Chi tiết đơn hàng
CREATE VIEW order_detail_view AS
SELECT
    customers.name AS customer_name,
    customers.email AS customer_email,
    customers.phone AS customer_phone,
    products.name AS product_name,
    products.id AS product_id,
    products.price AS product_price,
    order_detail.quantity,
    order_detail.item_amount,
    orders.status AS order_status,
    orders.created_at AS order_date,
    orders.updated_at AS last_updated
FROM order_detail
JOIN orders ON order_detail.order_id = orders.id
JOIN customers ON orders.customer_id = customers.id
JOIN products ON order_detail.product_id = products.id;
SELECT * FROM order_detail_view;
