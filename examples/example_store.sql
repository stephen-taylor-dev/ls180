-- option for when not running script database for store
/*
DROP TABLE IF EXISTS customers CASCADE; 
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers_products;
*/

CREATE TABLE customers (
    id serial PRIMARY KEY,
    name text NOT NULL,
    birthdate date NOT NULL,
    email text NOT NULL UNIQUE CONSTRAINT correct_job_type CHECK (email LIKE '%@%')
);


-- CREATE TABLE customers (
--     id serial,
--     name text NOT NULL,
--     birthdate date NOT NULL,
--     email text,
--     -- Using custom name with constraint
--     CONSTRAINT custom_name CHECK (name LIKE '% %'),
--     UNIQUE (email),
--     CHECK (email LIKE '%@%'),
--     PRIMARY KEY (id)
-- );

CREATE TABLE products (
    id serial PRIMARY KEY,
    name text NOT NULL,
    type text NOT NULL DEFAULT 'merchandise',
    price numeric(6,2) NOT NULL DEFAULT 0.00
);


CREATE TABLE purchases (
    id serial PRIMARY KEY,
    customer_id integer NOT NULL CONSTRAINT c_p_fkey REFERENCES customers (id) ON DELETE CASCADE,
    product_id integer NOT NULL CONSTRAINT p_p_fkey REFERENCES products (id) ON DELETE CASCADE
);



-- CREATE TABLE purchases (
--     id serial PRIMARY KEY,
--     customer_id integer NOT NULL,
--     product_id integer NOT NULL,
--     CONSTRAINT c_p_fkey FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE,
--     CONSTRAINT p_p_fkey FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
-- );

-- CREATE TABLE blip (
--     id serial

-- );

-- ALTER TABLE products ALTER COLUMN price SET DEFAULT 9.99;

-- ALTER TABLE products ALTER COLUMN price DROP DEFAULT;

-- INSERT INTO blip VALUES (3);
-- INSERT INTO blip VALUES (3);


-- ALTER TABLE customers
--     DROP CONSTRAINT customers_email_key;
--     -- ALTER COLUMN email

-- ALTER TABLE purchases
--     ADD FOREIGN KEY (product_id) 
--     REFERENCES products (id) ON DELETE CASCADE;

-- ALTER TABLE purchases
--     ADD CONSTRAINT product_id_product_fkey 
--     FOREIGN KEY (product_id) 
--     REFERENCES products (id) ON DELETE CASCADE;

-- ALTER TABLE purchases
--     DROP CONSTRAINT product_id_product_fkey;

-- ALTER TABLE customers
--     ALTER COLUMN email
--     SET NOT NULL;

-- ALTER TABLE customers
--     ALTER COLUMN email
--     DROP NOT NULL;

-- ALTER TABLE customers
--     ALTER COLUMN email
--     SET DEFAULT 'foo@bar.com';

-- ALTER TABLE customers
--     ALTER COLUMN email
--     DROP DEFAULT;


-- ALTER TABLE customers
--     DROP CONSTRAINT customers_email_check;

-- ALTER TABLE customers
--     ADD CHECK (email LIKE '%@%'),
--     ADD CHECK (name LIKE '% %');

-- ALTER TABLE products
--     ADD CHECK (price BETWEEN 0.00 AND 5000.00);


-- ALTER TABLE products
--     ADD CONSTRAINT correct_job_type CHECK (price BETWEEN 0.00 AND 5000.00);

-- ALTER TABLE products
--     ALTER COLUMN price
--     TYPE real;


COPY customers (name, birthdate, email)
FROM '/Users/stephen/Developer/launchschool/ls180/examples/example_users.csv'
WITH HEADER CSV;

COPY products (name, type, price)
FROM '/Users/stephen/Developer/launchschool/ls180/examples/example_products.csv'
WITH HEADER CSV;

COPY purchases (customer_id, product_id)
FROM '/Users/stephen/Developer/launchschool/ls180/examples/example_customers_products.csv'
WITH HEADER CSV;

-- SELECT * FROM customers;
-- SELECT * FROM products;
-- SELECT * FROM purchases;


-- WHERE price < 100;
-- HAVING SUM(price) > 5

-- SELECT product_id FROM purchases;

-- SELECT type, SUM(price) AS prices FROM products
-- WHERE price > 1
-- GROUP BY type
-- HAVING SUM(price) IN (1,2,3,3.75, 3.32) 
-- ORDER BY type;


-- SELECT customers.name, products.name, products.price  FROM customers
--     RIGHT OUTER JOIN purchases 
--             ON customers.id = purchases.customer_id
--     RIGHT OUTER JOIN products
--             ON purchases.product_id = products.id
--     LIMIT 6
--     OFFSET 8;


-- SELECT customers.name, products.name FROM customers
--     CROSS JOIN products;


-- SELECT name FROM customers
--     WHERE customers.id IN (SELECT customer_id FROM purchases);

-- SELECT name FROM customers
--     WHERE customers.id NOT IN (SELECT customer_id FROM purchases);

-- SELECT name FROM customers
-- WHERE EXISTS (SELECT 1 FROM purchases WHERE purchases.customer_id = customers.id);


-- SELECT name, 
--     (SELECT COUNT(purchases.id) AS purchases
--         FROM purchases 
--         WHERE customer_id = customers.id)
--     FROM customers;

-- ALTER TABLE customers
--     RENAME TO users;

-- DROP TABLE users CASCADE;

-- SELECT name, email from customers;

-- INSERT INTO customers 
--     (name, birthdate, email)
--     VALUES ('Kyle Bob', '1993-03-23', 'kylebob@gmail.com');

-- INSERT INTO customers 
--     VALUES (6, 'Jesse James', '1993-05-23', 'jessejames@gmail.com');

-- INSERT INTO customers 
--     (name, birthdate, email)
--     VALUES ('Kyle Bob', '1993-03-23', 'kylebob@gmail.com'),
--     ('Jesse James', '1993-05-23', 'jessejames@gmail.com');


-- SELECT * FROM customers;
-- -- SELECT * FROM customers WHERE id = 1;
-- SELECT * FROM customers;

-- SELECT * FROM customers WHERE name = 'Kyle Bob';
-- SELECT * FROM customers WHERE birthdate = '1994-03-22';
-- SELECT * FROM customers WHERE email = 'johndoe@gmail.com';
-- SELECT * FROM products WHERE name = 'chips';


-- SELECT product_id, COUNT(product_id) 
--     FROM purchases 
--     GROUP BY product_id;

-- ALTER TABLE customers
--     ADD COLUMN weight numeric;

-- UPDATE customers
--     SET name = 'Bob Dylan', birthdate = '1964-09-24'
--     WHERE id = 3;

--    UPDATE customers
--    SET name = CASE
--                   WHEN name = 'John Doe' THEN 'Doe Boy'
--                   WHEN name = 'Phil Pill' THEN 'Philly Pilly'
--                   ELSE name
--                 END;


-- DELETE FROM purchases
--    USING products
--    WHERE purchases.product_id = products.id AND products.type = 'food';

-- SELECT * FROM customers;

-- DELETE FROM purchases
-- WHERE customer_id IN (SELECT id FROM customers WHERE name = 'John Doe');
-- SELECT * FROM customers;

-- UPDATE customers
-- SET customers.name = 'Big Buyer Boy'
-- FROM purchases p
-- WHERE p.customer_id = c.id AND purchases.product_id = 3;




-- ALTER TABLE purchases
--     ADD COLUMN total_amount numeric NOT NULL DEFAULT 0.00;

-- SELECT * FROM customers;



-- UPDATE purchases
-- SET total_amount = (SELECT price FROM products WHERE products.id = purchases.product_id);

-- SELECT * FROM purchases;
-- SELECT max(purchased_products.count) AS most_purchased_item FROM (
--     SELECT product_id, COUNT(product_id) 
--     FROM purchases 
--     GROUP BY product_id
-- ) AS purchased_products;
-- -- GROUP BY product_id;

-- CREATE SEQUENCE test_seq;
-- SELECT nextval('test_seq');
-- SELECT nextval('test_seq');
-- SELECT nextval('test_seq');

-- ALTER SEQUENCE test_seq INCREMENT by 4;
-- SELECT nextval('test_seq');


-- DELETE FROM customers name;
-- SELECT * FROM customers;

SELECT COUNT(purchases.id) AS purchases
        FROM purchases 
        WHERE customer_id = customers.id;

SELECT name, 
    (SELECT COUNT(purchases.id) AS purchases
        FROM purchases 
        WHERE customer_id = customers.id)
    FROM customers;