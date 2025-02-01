CREATE TABLE people (
    id serial PRIMARY KEY,
    name varchar(30),
    age integer,
    occupation varchar(50)
);

INSERT INTO people 
            (name, age, occupation)
    VALUES ('Abby', 34, 'biologist'),
           ('Mu''nisah', 26, NULL),
           ('Mirabelle', 40, 'contractor');


SELECT * FROM people WHERE id = 2;
SELECT * FROM people LIMIT 1 OFFSET 1;
SELECT * FROM people WHERE name = 'Mu''nisa';

CREATE TABLE birds (
    name varchar(255),
    length numeric(10, 1),
    wingspan numeric(10, 1),
    family varchar(255),
    extinct boolean
);

INSERT INTO birds
    (name, length, wingspan, family, extinct)
    VALUES ('Spotted Towhee', 21.6, 26.7, 'Emberizidae', false),
           ('American Robin', 25.5, 36.0, 'Turdidae', false),
           ('Greater Koa Finch', 19.0, 24.0, 'Fringillidae', true),
           ('Carolina Parakeet', 33.0, 55.8, 'Psittacidae', true),
           ('Common Kestrel', 35.5, 73.5, 'Falconidae', false);


-- Birds 
-- not extinct
-- order by longest to shortest bird length

SELECT name, family FROM birds
    WHERE extinct = false
    ORDER BY length DESC;

SELECT round(avg(wingspan),1), min(wingspan), max(wingspan) FROM birds;


CREATE TABLE menu_items (
    item character varying(255),
    prep_time integer,
    ingredient_cost numeric(40, 2),
    sales integer,
    menu_price numeric(40, 2)
);

INSERT INTO menu_items
    (item, prep_time, ingredient_cost, sales, menu_price)
    VALUES ('omelette', 10, 1.50, 182, 7.99),
    ('tacos', 5, 2.00, 254, 8.99),
    ('oatmeal', 1, 0.50, 79, 5.99);


SELECT item, (menu_price - ingredient_cost) AS profit FROM menu_items
    ORDER BY profit DESC LIMIT 1;


SELECT item, menu_price, ingredient_cost,
    round((13.0 / 60) * prep_time, 2) AS labor, 
    menu_price - ingredient_cost - round(13.0 / 60 * prep_time, 2) AS profit 
  FROM menu_items
  ORDER BY profit DESC;



SELECT * FROM films;

SELECT * FROM films
WHERE length(title) < 12;

ALTER TABLE films
    ADD COLUMN 
        director character varying(50),
    ADD COLUMN 
        duration int;

ALTER TABLE films
    ALTER COLUMN director TYPE varchar(255);

UPDATE films
    SET director = 'John McTiernan',
        duration = 132
    WHERE title = 'Die Hard';

UPDATE films
    SET director = 'Michael Curtiz',
        duration = 102
    WHERE title = 'Casablanca';

    UPDATE films
    SET director = 'Francis Ford Coppola',
        duration = 113
    WHERE title = 'The Conversation';

INSERT INTO films (title, "year", genre, director, duration)
    VALUES ('1984',	1956, 'scifi', 'Michael Anderson', 90),
           ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127),
           ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);

DELETE FROM films
    WHERE title = '1984';
DELETE FROM films
    WHERE title = 'Tinker Tailor Soldier Spy';
DELETE FROM films
WHERE title = 'The Birdcage';

SELECT title, EXTRACT(YEAR FROM CURRENT_DATE) - "year" AS age
    FROM films 
    ORDER BY age;

SELECT title, duration 
    FROM films
    WHERE duration > 120
    ORDER by duration DESC;

SELECT title FROM films ORDER BY duration DESC LIMIT 1;



SELECT state, COUNT(id) AS count FROM people
    GROUP BY state
    ORDER BY count DESC
    LIMIT 10;
    

/*
list each domain in email address
split the email string at the @ symbol
get count of domains
Group by the domain 
Order in descending order
gmail.com | 100
yahoo.com | 50

*/

SELECT split_part(email, '@', 2) as domain, count(email) 
    FROM people 
    GROUP BY domain
    ORDER BY count DESC;

-- Also works 
SELECT substr(email, strpos(email, '@') + 1) as domain,
         COUNT(id)
  FROM people
  GROUP BY domain
  ORDER BY count DESC;


DELETE FROM people WHERE id = 3399;
SELECT * FROM people WHERE id = 3399;

DELETE FROM people
    WHERE state = 'CA';

UPDATE people
    SET given_name = upper(given_name)
    WHERE split_part(email, '@', 2) = 'teleworm.us';

-- also works
UPDATE people 
    SET given_name = UPPER(given_name) 
    WHERE email LIKE '%teleworm.us';

DELETE FROM people;

ALTER TABLE employees
    ALTER COLUMN department 
    SET DEFAULT 'unassigned'; 

ALTER TABLE employees
    ALTER COLUMN department 
    SET NOT NULL; 


CREATE TABLE temperatures (
    date date NOT NULL,
    low integer NOT NULL,
    high integer NOT NULL
    );

INSERT INTO temperatures 
        (date, low, high)
    VALUES  ('2016-03-01', 34, 43),
            ('2016-03-02', 32, 44),
            ('2016-03-03', 31, 47),
            ('2016-03-04', 33, 42),
            ('2016-03-05', 39, 46),
            ('2016-03-06', 32, 43),
            ('2016-03-07', 29, 32),
            ('2016-03-08', 23, 31),
            ('2016-03-09', 17, 28);


SELECT date, round((high + low) / 2.0, 1) AS average_temp
    FROM temperatures
    WHERE date BETWEEN '2016-03-02' AND '2016-03-08';

-- Could also have done this ((high + low) / 2.0)::decimal(3,1)

ALTER TABLE temperatures
    ADD COLUMN rainfall integer NOT NULL DEFAULT 0;

UPDATE temperatures
    SET rainfall = floor((high + low) / 2.0) % 35
    WHERE ((high + low) / 2.0) >= 36;

-- or this
UPDATE temperatures
   SET rainfall = (high + low) / 2 - 35
 WHERE (high + low) / 2 > 35;


 ALTER TABLE temperatures
    ALTER COLUMN rainfall TYPE decimal(4,3);

UPDATE temperatures
    SET rainfall = rainfall * 0.039;

ALTER TABLE temperatures
    RENAME TO weather;




ALTER TABLE films ALTER COLUMN title SET NOT NULL;
ALTER TABLE films ALTER COLUMN year SET NOT NULL;
ALTER TABLE films ALTER COLUMN genre SET NOT NULL;
ALTER TABLE films ALTER COLUMN director SET NOT NULL;
ALTER TABLE films ALTER COLUMN duration SET NOT NULL;


ALTER TABLE films ADD CONSTRAINT unique_title UNIQUE (title);

ALTER TABLE films DROP CONSTRAINT unique_title;


ALTER TABLE films
    ADD CONSTRAINT title_length CHECK (length(title) >= 1);

INSERT INTO films (title, year, genre, director, duration)
    VALUES ('', 2025, 'Thriller', 'Joe Joe', 120);


ALTER TABLE films DROP CONSTRAINT title_length;


ALTER TABLE films
    ADD CONSTRAINT film_year CHECK (year BETWEEN 1900 and 2100 );


ALTER TABLE films
    ADD CONSTRAINT director_name CHECK (length(director) >= 3 AND director LIKE '% %');


UPDATE films
    SET director = 'Johnny'
    WHERE title = 'Die Hard';


CHECK
DATA TYPE
UNIQUE
NOT NULL

CREATE TABLE honkey (
    pig varchar(10) NOT NULL DEFAULT NUll
);

INSERT INTO honkey
    (pig)
    VALUES ();

ALTER TABLE more_colors
    ADD COLUMN counter serial;

ALTER TABLE more_colors
    DROP COLUMN counter;

CREATE SEQUENCE counter;

nextval(counter)

INSERT INTO more_colors 
    (id, name)
    VALUES (5, nextval('counter'));
    
DROP SEQUENCE counter;

CREATE SEQUENCE counter INCREMENT 2 START 2;
-- same thing
CREATE SEQUENCE even_counter INCREMENT BY 2 MINVALUE 2;

ALTER TABLE films
    ADD COLUMN id serial PRIMARY KEY;

INSERT INTO films
    (title, year, genre, director, duration, id)
    VALUES ('Pigs', 2025, 'Thriller', 'Joe Joe', 120, 3);

UPDATE films
    SET id = 3 WHERE title = 'Die Hard';


ALTER TABLE films
    ADD COLUMN a_value serial PRIMARY KEY;

ALTER TABLE films
    DROP CONSTRAINT films_pkey;



INSERT INTO films (title, year, genre, director, duration)
    VALUES ('Wayne''s World', 1992, 'comedy', 'Penelope Spheeris', 95),
           ('Bourne Identity', 2002, 'espionage', 'Doug Liman', 118); 


SELECT genre FROM films
    GROUP BY genre;

SELECT DISTINCT genre FROM films;

SELECT ROUND(AVG(duration)) AS avg_duration FROM films;

SELECT genre, ROUND(AVG(duration)) AS avg_duration 
    FROM films
    GROUP BY genre;

SELECT decade, ROUND(AVG(duration)) AS avg_duration
    FROM (
        SELECT year, year / 10 * 10 as decade, duration FROM films) as duration_by_decade
    GROUP BY decade
    ORDER BY decade;

SELECT year / 10 * 10 as decade, ROUND(AVG(duration))
    FROM films
    GROUP BY decade
    ORDER BY decade;

SELECT * FROM films
    WHERE director LIKE 'John %';


SELECT genre, count(*)
    FROM films
    GROUP BY genre
    ORDER by count DESC;


SELECT year / 10 * 10 as decade, genre, string_agg(title, ', ') AS films
    FROM films
    GROUP by decade, genre
    ORDER by decade, genre;


SELECT genre, sum(duration) as total_duration FROM films
    GROUP BY genre
    ORDER BY total_duration, genre ASC;


CREATE TABLE names
    (id integer, name text);

INSERT INTO names
    VALUES (1, 'Abedi'),
(2, 'Allyssa'),
(3, 'amy'),
(4, 'ben'),
(5, 'Becky'),
(6, 'Christophe'),
(7, 'Camilla'),
(8, 'david'),
(9, 'Elsa'),
(10, 'frank'),
(11, 'Felipe');



SELECT count(*) FROM tickets;

SELECT count(DISTINCT customer_id) FROM tickets;

SELECT round( COUNT(DISTINCT tickets.customer_id)
            / COUNT(DISTINCT customers.id)::decimal * 100,
            2)
       AS percent
  FROM customers
  LEFT OUTER JOIN tickets
    ON tickets.customer_id = customers.id;


SELECT events.name, count(tickets.event_id) 
        AS popularity
    FROM tickets
    LEFT OUTER JOIN events
        ON tickets.event_id = events.id
    GROUP BY events.id
    ORDER BY popularity DESC;


SELECT c.id, c.email, COUNT(DISTINCT t.event_id) FROM customers AS c
    INNER JOIN tickets as t
        ON t.customer_id = c.id
    GROUP BY c.id
    HAVING COUNT(DISTINCT t.event_id) = 3;


SELECT events.name AS event, events.starts_at, sections.name AS section, seats.row, seats.number AS seat
    FROM events
    INNER JOIN tickets
        ON events.id = tickets.event_id
    INNER JOIN seats
        ON tickets.seat_id = seats.id
    INNER JOIN sections
        ON seats.section_id = sections.id
    INNER JOIN customers
        ON tickets.customer_id = customers.id
    WHERE customers.email = 'gennaro.rath@mcdermott.co';

SELECT events.name AS event, events.starts_at, sections.name AS section, seats.row, seats.number AS seat
    FROM tickets
    INNER JOIN events
        ON tickets.event_id = events.id
    INNER JOIN customers
        ON tickets.customer_id = customers.id
    INNER JOIN seats
        ON tickets.seat_id = seats.id
    INNER JOIN sections
        ON seats.section_id = sections.id
    WHERE customers.email = 'gennaro.rath@mcdermott.co';