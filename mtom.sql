CREATE TABLE customers (
    id serial PRIMARY KEY,
    name text NOT NULL,
    payment_token varchar(8) UNIQUE NOT NULL CHECK (payment_token SIMILAR TO '[A-Z]{8}')
);

-- OR 
payment_token varchar(8) UNIQUE NOT NULL CHECK (payment_token ~ '^[A-Z]{8}$')


ALTER TABLE customers
    DROP CONSTRAINT customers_payment_token_check;

ALTER TABLE customers
    ADD CHECK (payment_token SIMILAR TO '[A-Z]{8}');

CREATE TABLE services (
    id serial PRIMARY KEY,
    description text NOT NULL,
    price numeric(10, 2) NOT NULL CHECK (price >= 0.00)
);


INSERT INTO customers (name, payment_token)
VALUES 
    ('Pat Johnson', 'XHGOAHEQ'),
    ('Nancy Monreal', 'JKWQPJKL'),
    ('Lynn Blake', 'KLZXWEEE'),
    ('Chen Ke-Hua', 'KWETYCVX'),
    ('Scott Lakso', 'UUEAPQPS'),
    ('Jim Pornot', 'XKJEYAZA');

INSERT INTO services (description, price)
VALUES 
    ('Unix Hosting', 5.95),
    ('DNS', 4.95),
    ('Whois Registration', 1.95),
    ('High Bandwidth', 15.00),
    ('Business Support', 250.00),
    ('Dedicated Hosting', 50.00),
    ('Bulk Email', 250.00),
    ('One-to-one Training', 999.00);

CREATE TABLE customers_services (
    id serial PRIMARY KEY,
    customer_id int REFERENCES customers (id) ON DELETE CASCADE,
    service_id int REFERENCES services (id),
    UNIQUE (customer_id, service_id)
);

ALTER TABLE customers_services
    ALTER COLUMN customer_id
    SET NOT NULL;

ALTER TABLE customers_services
    ALTER COLUMN service_id
    SET NOT NULL;

INSERT INTO customers_services
    (customer_id, service_id)
VALUES (2, 1),
       (2, 2),
       (2, 3),
       (4, 1),
       (4, 2),
       (4, 3),
       (4, 4),
       (4, 5),
       (5, 1),
       (5, 4),
       (6, 1),
       (6, 2),
       (6, 6),
       (7, 1),
       (7, 6),
       (7, 7);


SELECT DISTINCT customers.id, customers.name, customers.payment_token FROM customers_services
    INNER JOIN customers ON customers_services.customer_id = customers.id;


SELECT DISTINCT customers.* FROM customers_services
    INNER JOIN customers 
            ON customers_services.customer_id = customers.id;

SELECT DISTINCT customers.* FROM customers
INNER JOIN customers_services
        ON customer_id = customers.id;



SELECT customers.* FROM customers
LEFT OUTER JOIN customers_services
        ON customer_id = customers.id
WHERE service_id IS NULL;


SELECT customers.*, services.* , customers_services.* FROM customers
FULL JOIN customers_services
       ON customer_id = customers.id
FULL JOIN services 
       ON customers_services.service_id = services.id
WHERE customer_id IS NULL OR service_id IS NULL;


SELECT * FROM services
    RIGHT OUTER JOIN customers_services
                  ON services.id = customers_services.service_id

SELECT services.description FROM customers_services
    RIGHT OUTER JOIN services
                  ON customers_services.service_id = services.id
WHERE service_id IS NULL;

SELECT c.name, string_agg(services.description, ', ') AS services FROM customers AS c
    LEFT OUTER JOIN customers_services 
                 ON c.id = customer_id
    LEFT OUTER JOIN services 
                 ON service_id = services.id
    GROUP BY c.id;

SELECT customers.name,
       lag(customers.name)
         OVER (ORDER BY customers.name)
         AS previous,
       services.description
FROM customers
LEFT OUTER JOIN customers_services
             ON customer_id = customers.id
LEFT OUTER JOIN services
             ON services.id = service_id
GROUP BY customers.id;


SELECT services.description, COUNT(services.id) FROM services
    LEFT OUTER JOIN customers_services ON services.id = service_id
    GROUP BY services.description
    HAVING COUNT(services.id) >= 3
    ORDER BY description; 


SELECT SUM(services.price) AS gross FROM services
    INNER JOIN customers_services 
            ON services.id = service_id;

INSERT INTO customers (name, payment_token)
    VALUES ('John Doe', 'EYODHLCN');

INSERT INTO customers_services (customer_id, service_id)
    VALUES 
        (9, 1),
        (9, 2),
        (9, 3);

SELECT SUM(services.price) FROM services
    INNER JOIN customers_services
            ON services.id = service_id
    WHERE services.price > 100;

SELECT SUM(services.price) FROM services
    WHERE services.price > 100;

SELECT services.id, services.description, services.price FROM services
    WHERE price > 100;

SELECT customers.name, string_agg(services.price::text, ', '), SUM(services.price)
    FROM customers
    INNER JOIN customers_services ON customers.id = customer_id
    INNER JOIN services ON service_id = services.id
    WHERE services.price < 100
    GROUP BY customers.id;

SELECT customers.name, string_agg(services.price::text, ', '), SUM(services.price)
    FROM customers
    LEFT OUTER JOIN customers_services ON customers.id = customer_id
    LEFT JOIN services ON service_id = services.id
    GROUP BY customers.id;

SELECT SUM(services.price) FROM services
    WHERE services.price > 100;



SELECT customers.id, SUM(services.price) as expected FROM customers
    INNER JOIN customers_services ON customers.id = customer_id
    INNER JOIN services ON service_id = services.id
    WHERE services.price < 100
    GROUP BY customers.id;
    
SELECT (expected + big_ticket) 
FROM (
    SELECT SUM(services.price) AS big_ticket
    FROM (SELECT customers.id, SUM(services.price) as expected_sum FROM customers
                    INNER JOIN customers_services ON customers.id = customer_id
                    INNER JOIN services ON service_id = services.id
                    WHERE services.price < 100
                    GROUP BY customers.id) as expected
        WHERE services.price > 100) AS big_ticket;



        FROM (
                
                SELECT customers.id, SUM(services.price) as expected_sum FROM customers
                    INNER JOIN customers_services ON customers.id = customer_id
                    INNER JOIN services ON service_id = services.id
                    WHERE services.price < 100
                    GROUP BY customers.id AS expected;


SELECT SUM(customer_sum.sum) FROM (
    SELECT (expected.sum + 1499 ) as sum
        FROM ( SELECT customers.id, COALESCE(SUM(services.price),0) as sum FROM customers
                LEFT OUTER JOIN customers_services 
                        ON customers.id = customer_id
                LEFT OUTER JOIN services 
                        ON service_id = services.id
                WHERE services.price < 100 OR services.price IS NULL
                GROUP BY customers.id) as expected
) as customer_sum;

DELETE FROM customers_services
    WHERE service_id = 7;

DELETE FROM services 
    WHERE description = 'Bulk Email';

DELETE FROM services 
    WHERE description = 'Bulk Email';

DELETE FROM customers
    WHERE name = 'Chen Ke-Hua';