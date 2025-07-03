create database duplicate;
create schema records;

-- Step 1: Create the Ocean_Animals table
CREATE TABLE Ocean_Animals (
    ID INT,
    Animal_Name VARCHAR(50),
    Species VARCHAR(50),
    Habitat VARCHAR(100),
    Size VARCHAR(20),
    Diet VARCHAR(100)
);

-- Step 2: Insert 6 unique rows
INSERT INTO Ocean_Animals VALUES
(1, 'Blue Whale', 'Mammal', 'Open Ocean', '30 meters', 'Krill'),
(2, 'Clownfish', 'Fish', 'Coral Reefs', '11 cm', 'Algae, Zooplankton'),
(3, 'Great White Shark', 'Fish', 'Coastal Waters', '6 meters', 'Seals, Fish'),
(4, 'Giant Squid', 'Cephalopod', 'Deep Ocean', '13 meters', 'Fish, Shrimp'),
(5, 'Sea Turtle', 'Reptile', 'Tropical Oceans', '1.5 meters', 'Jellyfish'),
(6, 'Dolphin', 'Mammal', 'Continental Shelf', '2.6 meters', 'Fish, Squid');

-- Step 3: Insert 20 duplicate rows
INSERT INTO Ocean_Animals VALUES
(1, 'Blue Whale', 'Mammal', 'Open Ocean', '30 meters', 'Krill'),
(1, 'Blue Whale', 'Mammal', 'Open Ocean', '30 meters', 'Krill'),
(2, 'Clownfish', 'Fish', 'Coral Reefs', '11 cm', 'Algae, Zooplankton'),
(2, 'Clownfish', 'Fish', 'Coral Reefs', '11 cm', 'Algae, Zooplankton'),
(3, 'Great White Shark', 'Fish', 'Coastal Waters', '6 meters', 'Seals, Fish'),
(3, 'Great White Shark', 'Fish', 'Coastal Waters', '6 meters', 'Seals, Fish'),
(4, 'Giant Squid', 'Cephalopod', 'Deep Ocean', '13 meters', 'Fish, Shrimp'),
(4, 'Giant Squid', 'Cephalopod', 'Deep Ocean', '13 meters', 'Fish, Shrimp'),
(5, 'Sea Turtle', 'Reptile', 'Tropical Oceans', '1.5 meters', 'Jellyfish'),
(5, 'Sea Turtle', 'Reptile', 'Tropical Oceans', '1.5 meters', 'Jellyfish'),
(6, 'Dolphin', 'Mammal', 'Continental Shelf', '2.6 meters', 'Fish, Squid'),
(6, 'Dolphin', 'Mammal', 'Continental Shelf', '2.6 meters', 'Fish, Squid'),
(1, 'Blue Whale', 'Mammal', 'Open Ocean', '30 meters', 'Krill'),
(2, 'Clownfish', 'Fish', 'Coral Reefs', '11 cm', 'Algae, Zooplankton'),
(3, 'Great White Shark', 'Fish', 'Coastal Waters', '6 meters', 'Seals, Fish'),
(4, 'Giant Squid', 'Cephalopod', 'Deep Ocean', '13 meters', 'Fish, Shrimp'),
(5, 'Sea Turtle', 'Reptile', 'Tropical Oceans', '1.5 meters', 'Jellyfish'),
(6, 'Dolphin', 'Mammal', 'Continental Shelf', '2.6 meters', 'Fish, Squid'),
(1, 'Blue Whale', 'Mammal', 'Open Ocean', '30 meters', 'Krill'),
(2, 'Clownfish', 'Fish', 'Coral Reefs', '11 cm', 'Algae, Zooplankton');


select * from ocean_animals;

select distinct * from ocean_animals;

SELECT DISTINCT Animal_Name, Species, Habitat, Size, Diet
FROM ocean_animals;



-- with cte as (
--     SELECT *, ROW_NUMBER() OVER(partition ID, 
--     Animal_Name, 
--     Species, 
--     Habitat, 
--     Size,
--     Diet 
--     order by id
--     )
--     as rnk
--     from ocean_animals
-- ) 
-- delete from cte 
--         where rnk > 1;


-- Assuming your table is named 'marine_animals'
SELECT DISTINCT * FROM ocean_animals;

-- Or if you want to be more explicit about which columns to consider for uniqueness: --> step 1
 SELECT id, Animal_Name, habitat, size, diet
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY id, Animal_Name, habitat, size, diet ORDER by id ) AS row_num
    FROM ocean_animals
) AS ranked
WHERE row_num = 1
order by id;

-- Or if you want to create a new table with only distinct rows: --> step 2 ------
CREATE or replace TABLE distinct_Ocean_Animals (
    ID INT,
    Animal_Name VARCHAR(50),
    Species VARCHAR(50),
    Habitat VARCHAR(100),
    Size VARCHAR(20),
    Diet VARCHAR(100)
);

-----------------------------------------------------------------------
CREATE TABLE distinct_Ocean_Animals AS
SELECT DISTINCT * FROM ocean_animals;

INSERT INTO DISTINCT_OCEAN_ANIMALS (id, Animal_Name,Species, habitat, size, diet)
SELECT DISTINCT id, Animal_Name, Species, habitat, size, diet
FROM ocean_animals
ORDER BY id;

select * from DISTINCT_OCEAN_ANIMALS;



        