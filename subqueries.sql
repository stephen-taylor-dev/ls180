CREATE TABLE bidders (
    id serial PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE items (
    id serial PRIMARY KEY,
    name text NOT NULL,
    initial_price numeric(6, 2) NOT NULL CHECK (initial_price >= 0.00 AND initial_price <= 1000.00),
    sales_price numeric(6, 2) CHECK (sales_price >= 0.00 AND sales_price <= 1000.00)
);

CREATE TABLE bids (
    id serial PRIMARY KEY,
    bidder_id int NOT NULL REFERENCES bidders (id) ON DELETE CASCADE,
    item_id int NOT NULL REFERENCES items (id) ON DELETE CASCADE,
    amount numeric(6, 2) NOT NULL CHECK (amount >= 0.00 AND amount <= 1000.00)
);

CREATE INDEX ON bids (bidder_id, item_id);

ALTER TABLE items
    DROP CONSTRAINT items_initial_price_check;

ALTER TABLE items
    ADD CHECK (initial_price BETWEEN 0.01 AND 1000.00);

ALTER TABLE items
    ADD CHECK (sales_price BETWEEN 0.01 AND 1000.00);

ALTER TABLE bids
    ADD CHECK (amount BETWEEN 0.01 AND 1000.00);

-- select item name from the query of all bids where item is in bid

SELECT name AS "Bid On Items" FROM items
    WHERE id IN ( SELECT DISTINCT item_id FROM bids);

SELECT name AS "Not Bid On" FROM items
    WHERE id NOT IN ( SELECT item_id FROM bids);

SELECT name FROM bidders
    WHERE EXISTS (SELECT DISTINCT bidder_id FROM bids);

SELECT name FROM bidders
    INNER JOIN bids ON bidder_id = bidders.id
    GROUP BY bidders.id
    ORDER BY bidders.id;

SELECT WHERE EXISTS (SELECT DISTINCT bidder_id FROM bids);

SELECT DISTINCT name
  FROM bidders
 INNER JOIN bids
         ON bidder_id = bidders.id
ORDER BY bidders.name;

SELECT name FROM bidders
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);


SELECT MAX(total_bids.count) FROM (
    SELECT COUNT(bids) FROM bids 
    GROUP BY bidder_id
) as total_bids;


SELECT name, 
       (SELECT COUNT(bids.id) FROM bids WHERE item_id = items.id)
FROM items;

SELECT name, count(bids.id) FROM items
    LEFT OUTER JOIN bids ON items.id = item_id
GROUP BY items.id
ORDER BY items.id;


SELECT i.id FROM items AS i
WHERE ROW(i.name, i.initial_price, i.sales_price) = ROW('Painting', 100.00, 250.00);

SELECT * from items

---------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=37.15..37.16 rows=1 width=8) (actual time=0.045..0.046 rows=1 loops=1)
   ->  HashAggregate  (cost=32.65..34.65 rows=200 width=12) (actual time=0.038..0.041 rows=6 loops=1)
         Group Key: bids.bidder_id
         Batches: 1  Memory Usage: 40kB
         ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=4) (actual time=0.012..0.016 rows=26 loops=1)
 Planning Time: 0.115 ms
 Execution Time: 0.087 ms
(7 rows)


---------------------------------------------------------------------------------------------------------------------
 Limit  (cost=35.65..35.65 rows=1 width=12) (actual time=0.067..0.068 rows=1 loops=1)
   ->  Sort  (cost=35.65..36.15 rows=200 width=12) (actual time=0.065..0.066 rows=1 loops=1)
         Sort Key: (count(bidder_id)) DESC
         Sort Method: top-N heapsort  Memory: 25kB
         ->  HashAggregate  (cost=32.65..34.65 rows=200 width=12) (actual time=0.036..0.039 rows=6 loops=1)
               Group Key: bidder_id
               Batches: 1  Memory Usage: 40kB
               ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=4) (actual time=0.011..0.015 rows=26 loops=1)
 Planning Time: 0.108 ms
 Execution Time: 0.103 ms
(10 rows)


----------------------------

                                                 QUERY PLAN
-------------------------------------------------------------------------------------------------------------
 Seq Scan on items  (cost=0.00..25455.20 rows=880 width=40) (actual time=0.062..0.104 rows=6 loops=1)
   SubPlan 1
     ->  Aggregate  (cost=28.89..28.91 rows=1 width=8) (actual time=0.010..0.010 rows=1 loops=6)
           ->  Seq Scan on bids  (cost=0.00..28.88 rows=8 width=4) (actual time=0.005..0.007 rows=4 loops=6)
                 Filter: (item_id = items.id)
                 Rows Removed by Filter: 22
 Planning Time: 0.143 ms
 Execution Time: 0.133 ms
(8 rows)


---------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=118.27..120.47 rows=880 width=44) (actual time=0.324..0.327 rows=6 loops=1)
   Sort Key: items.id
   Sort Method: quicksort  Memory: 25kB
   ->  HashAggregate  (cost=66.44..75.24 rows=880 width=44) (actual time=0.215..0.222 rows=6 loops=1)
         Group Key: items.id
         Batches: 1  Memory Usage: 49kB
         ->  Hash Right Join  (cost=29.80..58.89 rows=1510 width=40) (actual time=0.174..0.194 rows=27 loops=1)
               Hash Cond: (bids.item_id = items.id)
               ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=8) (actual time=0.046..0.049 rows=26 loops=1)
               ->  Hash  (cost=18.80..18.80 rows=880 width=36) (actual time=0.043..0.044 rows=6 loops=1)
                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                     ->  Seq Scan on items  (cost=0.00..18.80 rows=880 width=36) (actual time=0.019..0.022 rows=6 loops=1)
 Planning Time: 0.192 ms
 Execution Time: 0.399 ms
(14 rows)