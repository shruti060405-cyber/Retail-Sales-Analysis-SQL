CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2),
    cost_price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    payment_mode VARCHAR(30)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    discount_percent NUMERIC(5,2)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    return_reason VARCHAR(100),
    return_date DATE
);
