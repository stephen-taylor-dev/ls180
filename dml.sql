CREATE TABLE devices (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    created_at timestamp NOT NULL DEFAULT NOW()
);

CREATE TABLE parts (
    id serial PRIMARY KEY,
    part_number integer NOT NULL UNIQUE,
    device_id integer REFERENCES devices (id)
);

ALTER TABLE devices
    ALTER COLUMN name TYPE text,
    ALTER COLUMN created_at
    DROP NOT NULL;


INSERT INTO devices (name)
    VALUES ('Accelerometer'),
            ('Gyroscope');

ALTER TABLE parts
ADD CHECK (part_number > 0);


INSERT INTO parts (part_number, device_id)
    VALUES (1, 1),
           (2, 1),
           (3, 1),
           (4, 2),
           (5, 2),
           (6, 2),
           (7, 2),
           (8, 2);

INSERT INTO parts (part_number)
    VALUES (9),
          (10),
          (11);

INSERT INTO parts (part_number, device_id)
    VALUES (31, 1);

SELECT devices.name, parts.part_number FROM devices
    INNER JOIN parts ON devices.id = parts.device_id;

SELECT * FROM parts
    WHERE part_number::text LIKE '3%';

SELECT name, count(parts.id) FROM devices
    LEFT OUTER JOIN parts ON devices.id = parts.device_id
    GROUP BY name;

SELECT devices.name AS name, COUNT(parts.device_id)
FROM devices
JOIN parts ON devices.id = parts.device_id
GROUP BY devices.name
ORDER BY devices.name DESC; 


SELECT part_number, device_id FROM parts
    WHERE device_id IS NOT NULL;

SELECT part_number, device_id FROM parts
    WHERE device_id IS NULL;

SELECT name, max(age(created_at)) FROM devices
GROUP BY name
HAVING max(age(created_at)) = age(created_at);


SELECT name FROM devices
    ORDER BY created_at
    LIMIT 1;

INSERT INTO devices (name, created_at)
    VALUES ('tazer', '2025-02-03 15:56:52.994168');

UPDATE parts
    SET device_id = 1
    WHERE id = 11;

UPDATE parts
    SET device_id = 1 
    WHERE id = 12;


UPDATE parts
    SET device_id = 1
    WHERE part_number = (SELECT min(part_number) FROM parts);

SELECT part_number FROM parts
WHERE part_number = (SELECT part_number FROM parts
                        ORDER BY part_number 
                        LIMIT 1);


ALTER TABLE parts
DROP CONSTRAINT parts_device_id_fkey,
ADD CONSTRAINT parts_device_id_fkey FOREIGN KEY (device_id)
REFERENCES devices(id) ON DELETE CASCADE;

DELETE FROM devices
    WHERE name = 'Accelerometer';