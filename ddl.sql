CREATE TABLE stars (
    id serial PRIMARY KEY,
    name varchar(25) UNIQUE NOT NULL,
    distance integer NOT NULL CHECK (distance > 0),
    spectral_type char(1),
    companions integer NOT NULL CHECK (companions >= 0)
);



CREATE TABLE planets (
    id serial PRIMARY KEY,
    designation char(1) UNIQUE,
    mass integer
);

ALTER TABLE planets
    ADD CONSTRAINT designation_unique UNIQUE (designation);


ALTER TABLE planets
    ADD COLUMN star_id integer NOT NULL;
ALTER TABLE planets
    ADD CONSTRAINT planets_start_id_fkey FOREIGN KEY (star_id) REFERENCES stars (id);
    
-- better way
ALTER TABLE planets
ADD COLUMN star_id integer NOT NULL REFERENCES stars (id);

ALTER TABLE stars
    ALTER COLUMN name
    TYPE varchar(30);

ALTER TABLE stars
    ALTER COLUMN distance
    TYPE numeric;

ALTER TABLE stars
    ADD CONSTRAINT spectral_type_check CHECK (spectral_type SIMILAR TO '(O|B|A|F|G|K|M)');

ALTER TABLE stars
ADD CHECK (spectral_type IN ('O', 'B', 'A', 'F', 'G', 'K', 'M'))
ALTER COLUMN spectral_type SET NOT NULL;

ALTER TABLE stars
    DROP constraint stars_spectral_type_check;



ALTER TABLE stars
    DROP CONSTRAINT spectral_type_check;


INSERT INTO stars
    (name, distance, spectral_type, companions)
    VALUES ('star1', 33, 'O', 3)

UPDATE stars
    SET spectral_type = 'A' WHERE spectral_type IS NULL;

UPDATE stars
    set spectral_type = 'F' WHERE spectral_type = 'X';

ALTER TABLE stars
    DROP CONSTRAINT stars_spectral_type_check;

CREATE TYPE star_spectral_type AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');


ALTER TABLE planets
    ALTER COLUMN mass
    SET NOT NULL,
    ADD CHECK (mass >= 0);

ALTER TABLE planets
    ADD COLUMN semi_major_axis numeric NOT NULL;


ALTER TABLE planets
DROP COLUMN semi_major_axis;

DELETE FROM stars;
INSERT INTO stars (name, distance, spectral_type, companions)
           VALUES ('Alpha Centauri B', 4.37, 'K', 3);
INSERT INTO stars (name, distance, spectral_type, companions)
           VALUES ('Epsilon Eridani', 10.5, 'K', 0);

INSERT INTO planets (designation, mass, star_id)
           VALUES ('b', 0.0036, 13); -- check star_id; see note below
INSERT INTO planets (designation, mass, star_id)
           VALUES ('c', 0.1, 14); -- check star_id; see note below

UPDATE planets
    SET semi_major_axis = 0.04 WHERE star_id = 13;
UPDATE planets
    SET semi_major_axis = 40 WHERE star_id = 14;

ALTER TABLE planets
ADD COLUMN semi_major_axis numeric;

ALTER TABLE planets
    ALTER COLUMN semi_major_axis
    SET NOT NULL;




CREATE TABLE moons (
    id serial PRIMARY KEY,
    designation integer NOT NULL UNIQUE CHECK (designation > 0),
    semi_major_axis numeric CHECK (semi_major_axis > 0),
    mass numeric CHECK (mass > 0),
    planet_id integer REFERENCES planets(id) NOT NULL
);