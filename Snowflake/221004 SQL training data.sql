/***************************************************
 Michigan Upper Peninsula Tourist Attraction Tables
***************************************************/
CREATE OR REPLACE TABLE t_county (
   county_id INTEGER,
   county_name VARCHAR(15),
   state CHAR(2));

CREATE OR REPLACE TABLE t_new_counties (
   county_id INTEGER,
   county_name VARCHAR(15),
   state CHAR(2));

CREATE OR REPLACE TABLE t_city (
   city_id INTEGER,
   city_name VARCHAR(16),
   county_id INTEGER);

CREATE OR REPLACE TABLE t_attraction (
   attraction_id INTEGER,
   attraction_name VARCHAR(35),
   attraction_url VARCHAR(40),
   government_owned CHAR(1),
   city_id INTEGER);

CREATE OR REPLACE TABLE t_alger_attractions (
   attraction_id INTEGER,
   attraction_name VARCHAR(35),
   attraction_url VARCHAR(40),
   government_owned CHAR(1),
   city_id INTEGER);

CREATE OR REPLACE TABLE t_marquette_attractions (
   attraction_id INTEGER,
   attraction_name VARCHAR(35),
   attraction_url VARCHAR(40),
   government_owned CHAR(1),
   city_id INTEGER);

CREATE OR REPLACE TABLE t_other_attractions (
   attraction_id INTEGER,
   attraction_name VARCHAR(35),
   attraction_url VARCHAR(40),
   government_owned CHAR(1),
   city_id INTEGER);

CREATE OR REPLACE TABLE t_attraction_urls (
   id INTEGER,
   url VARCHAR(40));

CREATE OR REPLACE TABLE t_attraction_names (
   id INTEGER,
   name VARCHAR(35));


CREATE OR REPLACE VIEW t_city_attractions
(city_name, attraction_name)
AS SELECT c.city_name, a.attraction_name
FROM t_city c INNER JOIN t_attraction a
     ON c.city_id = a.city_id;


INSERT INTO t_county VALUES (1,'Alger','MI');
INSERT INTO t_county VALUES (2,'Marquette','MI');
INSERT INTO t_county VALUES (3,'Chippewa','MI');
INSERT INTO t_county VALUES (4,'Mackinac','MI');
INSERT INTO t_county VALUES (5, 'Delta','MI');
INSERT INTO t_county VALUES (6, 'Luce','MI');
INSERT INTO t_county VALUES (7, 'Schoolcraft','MI');
INSERT INTO t_county VALUES (8, 'Menominee','MI');
INSERT INTO t_county VALUES (9, 'Dickenson','MI');
INSERT INTO t_county VALUES (10, 'Baraga','MI');
INSERT INTO t_county VALUES (11, 'Houghton','MI');
INSERT INTO t_county VALUES (12, 'Keweenaw','MI');
INSERT INTO t_county VALUES (13, 'Ontonagon','MI');
INSERT INTO t_county VALUES (14, 'Gogebic','MI');
INSERT INTO t_county VALUES (15, 'Iron','MI');
INSERT INTO t_county VALUES (16, 'Wane','MI');
INSERT INTO t_county VALUES (18, 'McComb','MI');

INSERT INTO t_new_counties VALUES (1,'Alger','MI');
INSERT INTO t_new_counties VALUES (2,'Marquette','MI');
INSERT INTO t_new_counties VALUES (3,'Chippewa','MI');
INSERT INTO t_new_counties VALUES (16,'Wayne','MI');
INSERT INTO t_new_counties VALUES (17,'Oakland','MI');
INSERT INTO t_new_counties VALUES (18,'Macomb','MI');

INSERT INTO t_city VALUES (1,'Munising',1);
INSERT INTO t_city VALUES (2,'St. Ignace',4);
INSERT INTO t_city VALUES (3,'Marquette',2);
INSERT INTO t_city VALUES (4,'Iron River',15);
INSERT INTO t_city VALUES (5,'Bessemer',14);
INSERT INTO t_city VALUES (6,'Silver City',13);
INSERT INTO t_city VALUES (7,'Copper Harbor',12);
INSERT INTO t_city VALUES (8,'Hancock',11);
INSERT INTO t_city VALUES (9,'L''Anse',10);
INSERT INTO t_city VALUES (10,'Vulcan',9);
INSERT INTO t_city VALUES (11,'Carbondale',8);
INSERT INTO t_city VALUES (12,'Germfask',7);
INSERT INTO t_city VALUES (13,'Newberry',6);
INSERT INTO t_city VALUES (14,'Gladstone',5);
INSERT INTO t_city VALUES (15,'Sault Ste. Marie',3);
INSERT INTO t_city VALUES (16,'Ishpeming',2);
INSERT INTO t_city VALUES (17,NULL,1);
INSERT INTO t_city VALUES (18,'Brimley',3);


/* Alger County */
INSERT INTO t_attraction VALUES (1, 'Pictured Rocks',
                               'www.nps.gov/piro/',
                               'Y', 1);
INSERT INTO t_attraction VALUES (2, 'Valley Spur',
                               'www.valleyspur.com',
                               'Y', 1);
INSERT INTO t_attraction VALUES (3, 'Shipwreck Tours',
                               'www.shipwrecktours.com',
                               'N', 1);

INSERT INTO t_attraction VALUES (23, 'Grand Sable Dunes',
                               NULL, NULL, NULL);

/* Marquette County */
INSERT INTO t_attraction VALUES (4, 'Ski Hall of Fame',
                               'www.skihall.com',
                               'N', 16);
INSERT INTO t_attraction VALUES (5, 'Da Yoopers Tourist Trap',
                               'www.dayoopers.com',
                               'N', 16);
INSERT INTO t_attraction VALUES (6, 'Marquette County Historical Museum',
                               'www.marquettecohistory.org',
                               'N', 3);
INSERT INTO t_attraction VALUES (7, 'Upper Peninsula Children''s Museum',
                               'www.upcmkids.org',
                               'N', 3);
INSERT INTO t_attraction VALUES (8, 'Marquette Maritime Museum',
                               'mqtmaritimemuseum.com',
                               'N', 3);

/* Chippewa County */
INSERT INTO t_attraction VALUES (9, 'Valley Camp',
                               'www.thevalleycamp.com',
                               'N', 15);

/* Mackinac County */
INSERT INTO t_attraction VALUES (10, 'Mackinac Bridge',
                               'www.mackinacbridge.org',
                               'Y', 2);

/* Delta County */
INSERT INTO t_attraction VALUES (11, 'Hoegh Pet Casket Company',
                               'hoegh.abka.com',
                               'N', 14);

/* Luce County */
/* Nothing for Luce County. This is on purpose, because
   I need one county with no attractions to demonstrate
   certain GROUP BY behavior. */

/* Schoolcraft County */
INSERT INTO t_attraction VALUES (12, 'Seney National Wildlife Refuge',
                               'midwest.fws.gov/seney/',
                               'Y', 12);

/* Menominee */
INSERT INTO t_attraction VALUES (13, 'Wells State Park',
                               NULL,'Y',NULL);

/* Dickenson */
/* Nothing for Dickenson either. */

/* Baraga */
INSERT INTO t_attraction VALUES (14, 'Bishop Baraga Shrine',
                               'www.baragashrine.com',
                               'N', 9);

INSERT INTO t_attraction VALUES (15, 'Mount Arvon',
                               NULL,NULL,NULL);

/* Houghton */
INSERT INTO t_attraction VALUES (16,'Quincy Steam Hoist',
                               'www.quincymine.com',
                               'N',8);
INSERT INTO t_attraction VALUES (17,'Temple Jacob',
                               'www.uahc.org/mi/mi010',
                               'N',8);
INSERT INTO t_attraction VALUES (18,'Finlandia University',
                               'www.finlandia.edu',
                               'N',8);

/* Keweenaw */
INSERT INTO t_attraction VALUES (19,'Fort Wilkins State Park',
                               NULL,'Y',7);

/* Ontonagon */
INSERT INTO t_attraction VALUES (20,'Porcupine Mountain Wilderness',
                               NULL,'Y',6);

/* Gogebic */
INSERT INTO t_attraction VALUES (21,'Copper Peak Ski Flying Hill',
                               'www.westernup.com/copperpeak/',
                               'N',5);

/* Iron */
INSERT INTO t_attraction VALUES (22,'Iron County Historical Museum',
                               'www.ironcountymuseum.com',
                               'N',4);

/*****************************************
 CD Tables
*****************************************/
CREATE OR REPLACE TABLE t_artist (
    name VARCHAR(15),
    website VARCHAR(25) DEFAULT 'no URL');

CREATE OR REPLACE TABLE t_cd (
    cd_id INTEGER,
    title VARCHAR(35),
    price NUMBER(4,2),
    total_time INTEGER,
    artist VARCHAR(15),
    first_track VARCHAR(36));

CREATE OR REPLACE TABLE t_song (
    cd_id INTEGER,
    track INTEGER,
    title VARCHAR(36),
    playing_time INTEGER,
    artist VARCHAR(15));

INSERT INTO t_artist VALUES ('Carl Behrend','www.GreatLakesLegends.com');
INSERT INTO t_artist VALUES ('Rondi Olson','www.milknhoney.org');
INSERT INTO t_artist VALUES ('Jenny Gennick','');

INSERT INTO t_cd VALUES (1,'Legends of the Great Lakes',17.95,0,'','');
INSERT INTO t_cd VALUES (2,'Nothing Less',10.00,0,'','');
INSERT INTO t_cd VALUES (3,'More Legends of the Great Lakes',17.95,0,'','');
INSERT INTO t_cd VALUES (4,'The Ballad of Seul Choix',17.95,0,'','');
INSERT INTO t_cd VALUES (5,'Seeing the Unseen',10,0,'','');

/* Legends of the Great Lakes */
INSERT INTO t_song VALUES (1,1,'The Christmas Ship',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,2,'Lake Superior Song',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,3,'Captain Bundy''s Gospel Ship',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,4,'Ballad of Seul Choix',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,5,'What Do You Do With a Drunken Sailor',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,6,'Dream on a Winters Night',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,7,'Porcupine Mountains Wilderness Song',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,8,'Just a Memory',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,9,'Wanda Fey',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,10,'What Would I Be Without Love',NULL,'Carl Behrend');
INSERT INTO t_song VALUES (1,11,'How Many Stars',NULL,'Carl Behrend');

/* Nothing Less */
INSERT INTO t_song VALUES (2,1,'Joyfully Lord',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,2,'Open My Heart',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,3,'Nothing Less',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,4,'Where You Want Me to Go',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,5,'Do You Love Me',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,6,'In the Light of the Cross',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,7,'Yeshua, Messiah',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,8,'Into the River',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,9,'Worthy to be Praised',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,10,'Michael Stand Up',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,11,'What You Saw',NULL,'Rondi Olson');
INSERT INTO t_song VALUES (2,12,'Listen',NULL,'Rondi Olson');

/* More Legends of the Great Lakes */
INSERT INTO t_song VALUES (3,1,'Dan Seavy the Great Lakes Pirate',296,'Carl Behrend');
INSERT INTO t_song VALUES (3,2,'The Captain and the Lady',313,'Carl Behrend');
INSERT INTO t_song VALUES (3,3,'Wreck of the Mary Ellen Carter',301,'Carl Behrend');
INSERT INTO t_song VALUES (3,4,'Three Sheets to the Wind',285,'Carl Behrend');
INSERT INTO t_song VALUES (3,5,'Face on the Rock',285,'Carl Behrend');
INSERT INTO t_song VALUES (3,6,'On the Boat Again',186,'Carl Behrend');
INSERT INTO t_song VALUES (3,7,'Great Lakes Fisherman',259,'Carl Behrend');
INSERT INTO t_song VALUES (3,8,'Wreck of the Edmund Fitzgerald',305,'Carl Behrend');
INSERT INTO t_song VALUES (3,9,'Lady Sing Your Songs Tonight',269,'Carl Behrend');
INSERT INTO t_song VALUES (3,10,'Grandma''s Feather Bed',189,'Carl Behrend');

CREATE OR REPLACE TABLE "Training CD Table" (
    "CD ID" INTEGER,
    "CD Title" VARCHAR(35),
    "Price" INTEGER,
    "Total Time" INTEGER,
    "Artist" VARCHAR(15),
    "First Track" VARCHAR(36));

INSERT INTO "Training CD Table"
   SELECT * FROM t_cd;

/*****************************************
 Spine Table
*****************************************/
CREATE OR REPLACE TABLE t_spine (
   x INTEGER
   );

INSERT INTO t_spine
SELECT huns.x+tens.x+ones.x FROM
  (SELECT 0 x
   UNION SELECT 1
   UNION SELECT 2
   UNION SELECT 3
   UNION SELECT 4
   UNION SELECT 5
   UNION SELECT 6
   UNION SELECT 7
   UNION SELECT 8
   UNION SELECT 9 ) ones,
  (SELECT 0 x
   UNION SELECT 10
   UNION SELECT 20
   UNION SELECT 30
   UNION SELECT 40
   UNION SELECT 50
   UNION SELECT 60
   UNION SELECT 70
   UNION SELECT 80
   UNION SELECT 90) tens,
  (SELECT 0 x
   UNION SELECT 100
   UNION SELECT 200
   UNION SELECT 300
   UNION SELECT 400
   UNION SELECT 500
   UNION SELECT 600
   UNION SELECT 700
   UNION SELECT 800
   UNION SELECT 900 ) huns;

/*****************************************
 Chemical Exposure tables
*****************************************/
CREATE OR REPLACE TABLE t_worker_location (
   worker_id INTEGER,
   building_number INTEGER,
   begin_date DATETIME,
   end_date DATETIME);

CREATE OR REPLACE TABLE t_building_exposure (
   building_number INTEGER,
   chemical VARCHAR(20),
   begin_date DATETIME,
   end_date DATETIME);

INSERT INTO t_worker_location VALUES (1,1,'15-Nov-2000','1-Jan-2002');
INSERT INTO t_worker_location VALUES (1,2,'2-Jan-2002',NULL);
INSERT INTO t_worker_location VALUES (2,1,'26-Dec-1995','4-Jul-1997');
INSERT INTO t_worker_location VALUES (2,2,'1-Jul-1997','31-Dec-2001');
INSERT INTO t_worker_location VALUES (2,3,'31-Dec-2001',NULL);

--The chemical names below come from the Online NIOSH
--Pocket Guide to Chemical Hazards. I just picked them
--at random from a list found at:
--
--    http://www.cdc.gov/niosh/npg/npgd0000.html

INSERT INTO t_building_exposure
   VALUES (1,'Acetaldehyde','1-Nov-1999','1-Mar-2001');
INSERT INTO t_building_exposure
   VALUES (1,'Unslaked lime','1-Dec-2000',NULL);
INSERT INTO t_building_exposure
   VALUES (1,'Tetrachloroethylene','1-Jan-2001','31-Dec-2001');
INSERT INTO t_building_exposure
   VALUES (1,'Prussic acid','1-Jan-1995','1-Jan-1997');

INSERT INTO t_building_exposure
   VALUES (2,'Osmium oxide','2-Feb-1996','13-Aug-1997');
INSERT INTO t_building_exposure
   VALUES (2,'Methyl iodide','27-Apr-1998','2-Jan-2002');
INSERT INTO t_building_exposure
   VALUES (2,'Slag wool','30-Sep-2000','31-Oct-2000');
INSERT INTO t_building_exposure
   VALUES (2,'Cement','1-Jan-2002',NULL);

INSERT INTO t_building_exposure
   VALUES (3,'Heptane','1-Jan-2002',NULL);
INSERT INTO t_building_exposure
   VALUES (3,'Tin powder','1-Oct-2001','31-Dec-2001');

/*****************************************
 Hierarchical bill-of-material tables
*****************************************/
CREATE OR REPLACE TABLE t_part (
    part_number       INTEGER,
    part_name         VARCHAR(23),
    manufactured_by   VARCHAR(30),
    current_inventory INTEGER);

/* Automobile parts */
INSERT INTO t_part VALUES (1001,'Piston','Munising Tool & Die',500);
INSERT INTO t_part VALUES (1002,'Air Filter','Germfask Filter Company', 200);
INSERT INTO t_part VALUES (1003,'Spark Plug','Pyro Plugs, Inc.',2000);
INSERT INTO t_part VALUES (1004,'Engine Block','Munising Tool & Die',100);
INSERT INTO t_part VALUES (1005,'Alternator','Pyro Plugs, Inc.',300);
INSERT INTO t_part VALUES (1006,'Two-year Battery','Low-flow Battery Corp.',250);
INSERT INTO t_part VALUES (1007,'Starter Motor','Pyro Plugs, Inc.',400);
INSERT INTO t_part VALUES (1008,'Sedan Roof','Shingleton Stamping',700);
INSERT INTO t_part VALUES (1017,'Left Door Frame','Shingleton Stamping',250);
INSERT INTO t_part VALUES (1018,'Left Window','Shards & Splinters Glass Fab',250);
INSERT INTO t_part VALUES (1019,'Car Door Lock','Grand Marais Motors',250);
INSERT INTO t_part VALUES (1020,'Right Door Frame','Shingleton Stamping',250);
INSERT INTO t_part VALUES (1021,'Right Window','Shards & Splinters Glass Fab',650);

/* Airplane parts */
INSERT INTO t_part VALUES (2001,'Full-width Cushion','Seney Seats',333);
INSERT INTO t_part VALUES (2002,'Cupholder Armrest','Seney Seats',444);
INSERT INTO t_part VALUES (2003,'Reclining Ergo-Seatback','Seney Seats',374);
INSERT INTO t_part VALUES (2004,'Extra-narrow Cushion','Seney Seats',432);
INSERT INTO t_part VALUES (2005,'Broken Armrest','Seney Seats',521);
INSERT INTO t_part VALUES (2006,'Hard, rigid Seatback','Seney Seats',978);

CREATE OR REPLACE TABLE t_bill_of_materials (
    assembly_id     INTEGER,
    assembly_name   VARCHAR(23),
    parent_assembly INTEGER,
    part_number     INTEGER,
    quantity        INTEGER);

/* Automobile */
INSERT INTO t_bill_of_materials VALUES (100,'Automobile',NULL,NULL,NULL);
INSERT INTO t_bill_of_materials VALUES (110,'Combustion Engine',100,NULL,1);
INSERT INTO t_bill_of_materials VALUES (120,'Body',100,NULL,1);
INSERT INTO t_bill_of_materials VALUES (130,'Interior',100,NULL,1);

/* Automobile/Combustion Engine */
INSERT INTO t_bill_of_materials VALUES (111,'Piston',110,1001,6);
INSERT INTO t_bill_of_materials VALUES (112,'Air Filter',110,1002,1);
INSERT INTO t_bill_of_materials VALUES (113,'Spark Plug',110,1003,6);
INSERT INTO t_bill_of_materials VALUES (114,'Block',110,1004,1);
INSERT INTO t_bill_of_materials VALUES (115,'Starter System',110,NULL,1);

/* Automobile/Compustion Engine/Starter System */
INSERT INTO t_bill_of_materials VALUES (116,'Alternator',115,1005,1);
INSERT INTO t_bill_of_materials VALUES (117,'Battery',115,1006,1);
INSERT INTO t_bill_of_materials VALUES (118,'Starter Motor',115,1007,1);

/* Automobile/Body */
INSERT INTO t_bill_of_materials VALUES (121,'Roof',120,1008,1);
INSERT INTO t_bill_of_materials VALUES (122,'Left Door',120,NULL,2);
INSERT INTO t_bill_of_materials VALUES (123,'Right Door',120,NULL,2);

/* Automobile/Body/Left Door */
INSERT INTO t_bill_of_materials VALUES (139,'Left Door Frame',122,1017,1);
INSERT INTO t_bill_of_materials VALUES (140,'Left Window',122,1018,1);
INSERT INTO t_bill_of_materials VALUES (141,'Lock',122,1019,1);

/* Automobile/Body/Right Door */
INSERT INTO t_bill_of_materials VALUES (142,'Right Door Frame',123,1020,1);
INSERT INTO t_bill_of_materials VALUES (143,'Right Window',123,1021,1);
INSERT INTO t_bill_of_materials VALUES (144,'Lock',123,1019,1);

/* Automobile/Interior */
INSERT INTO t_bill_of_materials VALUES (131,'Front Seat',130,NULL,2);
INSERT INTO t_bill_of_materials VALUES (132,'Back Seat',130,NULL,1);
INSERT INTO t_bill_of_materials VALUES (133,'Carpet',130,1011,1);

/* Automobile/Interor/Front Seat */
INSERT INTO t_bill_of_materials VALUES (134,'Seat Cushion',131,1012,1);
INSERT INTO t_bill_of_materials VALUES (135,'Seat Back',131,1013,1);
INSERT INTO t_bill_of_materials VALUES (136,'Headrest',131,1014,1);

/* Automobile/Interor/Back Seat */
INSERT INTO t_bill_of_materials VALUES (137,'Seat Cushion',132,1015,1);
INSERT INTO t_bill_of_materials VALUES (138,'Seat Back',132,1016,1);

/* Airplane */
INSERT INTO t_bill_of_materials VALUES (200,'Airplane',NULL,NULL,NULL);
INSERT INTO t_bill_of_materials VALUES (201,'Jet Engine',200,NULL,2);
INSERT INTO t_bill_of_materials VALUES (202,'Left Wing',200,NULL,1);
INSERT INTO t_bill_of_materials VALUES (203,'Right Wing',200,NULL,1);
INSERT INTO t_bill_of_materials VALUES (204,'Body',200,NULL,1);

/* Airplane/Body */
INSERT INTO t_bill_of_materials VALUES (205,'First-class Seat',204,NULL,12);
INSERT INTO t_bill_of_materials VALUES (206,'Coach Seat',204,NULL,300);

/* Airplane/Body/First-class Seat */
INSERT INTO t_bill_of_materials VALUES (207,'Full-width Cushion',205,2001,1);
INSERT INTO t_bill_of_materials VALUES (208,'Cupholder Armrest',205,2002,2);
INSERT INTO t_bill_of_materials VALUES (209,'Reclining Ergo-Seatback',205, 2003,1);

/* Airplane/Body/First-class Seat */
INSERT INTO t_bill_of_materials VALUES (210,'Extra-narrow Cushion',206,2004,1);
INSERT INTO t_bill_of_materials VALUES (211,'Broken Armrest',206,2005,1);
INSERT INTO t_bill_of_materials VALUES (212,'Hard, rigid Seatback',206, 2006,1);

/*****************************************
 Sales data
*****************************************/
CREATE OR REPLACE TABLE t_sales (
    customer_id     INTEGER,
    customer_name   VARCHAR(10),
    sale_month      INTEGER,
    sale_value      INTEGER);

INSERT INTO t_sales VALUES (1001, 'Alice',3, 2);
INSERT INTO t_sales VALUES (1001, 'Alice',4, 11);
INSERT INTO t_sales VALUES (1002, 'Bob',3, 3);
INSERT INTO t_sales VALUES (1002, 'Bob',4, 14);
INSERT INTO t_sales VALUES (1002, 'Bob',6, 7);
INSERT INTO t_sales VALUES (1002, 'Bob',9, 1);

/*****************************************
 Exam results data
*****************************************/
CREATE OR REPLACE TABLE t_exam_results (
    student         VARCHAR(10),
    subject         VARCHAR(10),
    grade           INTEGER);

INSERT INTO t_exam_results VALUES ('Alice', 'English', 70);
INSERT INTO t_exam_results VALUES ('Alice', 'Maths', 65);
INSERT INTO t_exam_results VALUES ('Brian', 'Maths', 60);
INSERT INTO t_exam_results VALUES ('Brian', 'Science', 90);
INSERT INTO t_exam_results VALUES ('Chloe', 'English', 80);
INSERT INTO t_exam_results VALUES ('Chloe', 'Maths', 70);
INSERT INTO t_exam_results VALUES ('Chloe', 'Science', 75);
INSERT INTO t_exam_results VALUES ('David', 'English', 60);
INSERT INTO t_exam_results VALUES ('David', 'Science', 70);
INSERT INTO t_exam_results VALUES ('Elsie', 'English', 50);
INSERT INTO t_exam_results VALUES ('Elsie', 'Maths', 85);
INSERT INTO t_exam_results VALUES ('Elsie', 'Science', 90);



SELECT
    attraction_id
    ,attraction_name
    ,attraction_url
FROM t_attraction;

SELECT
    cd_id
    ,track
    ,CONCAT(title, ' by ', artist) AS title_and_artist
FROM t_song;

SELECT
    cd_id
    ,track
    ,CONCAT(title, ' by ', artist) AS title_and_artist
    ,CURRENT_TIMESTAMP() AS date_now
    ,'Some static data' AS literal_value
FROM t_song;

SELECT *
FROM t_attraction
WHERE government_owned = 'Y';

SELECT *
FROM t_attraction
WHERE attraction_name LIKE '%Park%';

SELECT *
FROM t_attraction
WHERE (attraction_name LIKE '%Museum%'
    OR attraction_name LIKE '%Park%')
    AND government_owned = 'Y';
    
SELECT *
FROM t_attraction
WHERE attraction_name LIKE '%Museum%'
    OR (attraction_name LIKE '%Park%'
    AND government_owned = 'Y');
    
SELECT *
FROM t_attraction
WHERE attraction_name LIKE '%Museum%'
    OR (attraction_name LIKE '%Park%'
    AND government_owned = 'Y');
    
SELECT *
FROM t_attraction
WHERE attraction_name LIKE '%Museum%'
    OR attraction_name LIKE '%Park%'
    AND government_owned = 'Y';
    
SELECT *
FROM t_attraction
INNER JOIN t_city
    ON t_attraction.city_id = t_city.city_id
;

SELECT *
FROM t_attraction
LEFT OUTER JOIN t_city
    ON t_attraction.city_id = t_city.city_id
;

SELECT *
FROM t_attraction
LEFT OUTER JOIN t_city
    ON t_attraction.city_id = t_city.city_id
    AND t_attraction.government_owned = 'Y'
;

SELECT *
FROM t_attraction
LEFT OUTER JOIN t_city
    ON t_attraction.city_id = t_city.city_id
WHERE t_attraction.government_owned = 'Y'
;

SELECT *
FROM t_attraction
INNER JOIN t_city
    ON t_attraction.city_id = t_city.city_id
    AND t_attraction.government_owned = 'Y'
;

SELECT *
FROM t_attraction
INNER JOIN t_city
    ON t_attraction.city_id = t_city.city_id
WHERE t_attraction.government_owned = 'Y'
;




SELECT *
FROM t_county
INNER JOIN (t_city
    INNER JOIN t_attraction
         ON t_city.city_id = t_attraction.city_id)
    ON t_county.county_id = t_city.county_id
;


SELECT 
    customer_id
    ,customer_name
    ,sale_month
    ,sale_value
    ,ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY sale_value DESC)
        AS sale_row_number
FROM t_sales
;

SELECT 
    customer_id
    ,customer_name
    ,sale_month
    ,sale_value
    ,sale_month - LAG(sale_month) OVER(PARTITION BY customer_id ORDER BY sale_month)
        AS months
FROM t_sales
;





SELECT
    student
    ,subject
    ,grade
    ,DENSE_RANK() OVER (PARTITION BY subject ORDER BY grade ASC)
        AS rank_num
FROM t_exam_results;

SELECT
    student
    ,subject
    ,grade
FROM
(
    SELECT
        student
        ,subject
        ,grade
        ,DENSE_RANK() OVER (PARTITION BY subject ORDER BY grade DESC)
            AS rank_num
    FROM t_exam_results
) inner_select 
WHERE rank_num = 1
;

SELECT
    student
    ,subject
    ,grade
FROM t_exam_results
QUALIFY DENSE_RANK() OVER (PARTITION BY subject ORDER BY grade DESC) = 1
;


SELECT
    student
    ,subject
    ,grade
FROM t_exam_results
QUALIFY ROW_NUMBER() OVER (PARTITION BY subject ORDER BY grade DESC) = 1;




DROP TABLE SANDBOX.TIM_WILSON.CUSTOMERS
;

CREATE TABLE SANDBOX.TIM_WILSON.CUSTOMER
(
    C_CUSTKEY NUMBER(38,0)
    ,C_NAME VARCHAR(25)
    ,C_ADDRESS VARCHAR(40)
    ,C_NATIONKEY NUMBER(38,0)
    ,C_PHONE VARCHAR(15)
    ,C_ACCTBAL NUMBER(12,2)
    ,C_MKTSEGMENT VARCHAR(10)
    ,C_COMMENT VARCHAR(117)
)
;


SELECT COUNT(DISTINCT city_id)
    ,COUNT(ALL city_id)
FROM t_attraction;


SELECT
    CASE
        WHEN c.city_name IN ('Munising', 'Germfask')
            THEN 'Munising area'
        WHEN c.city_name IN ('Marquette', 'Ishpeming')
            THEN 'Marquette area'
        WHEN c.city_name IN ('Copper Harbor', 'Hancock', 'L''Anse')
            THEN 'Keweenaw area'
        ELSE 'Other areas'
    END AS area
    ,COUNT(*) AS attraction_count
FROM t_city AS c
INNER JOIN t_attraction AS a
    ON c.city_id = a.city_id
GROUP BY
    CASE
        WHEN c.city_name IN ('Munising', 'Germfask')
            THEN 'Munising area'
        WHEN c.city_name IN ('Marquette', 'Ishpeming')
            THEN 'Marquette area'
        WHEN c.city_name IN ('Copper Harbor', 'Hancock', 'L''Anse')
            THEN 'Keweenaw area'
        ELSE 'Other areas'
    END
;



SELECT
    attraction_name
    ,CASE government_owned
        WHEN 'Y' THEN 'Public'
        WHEN 'N' THEN 'Private'
        --ELSE 'No code'
    END AS case_government_owned
FROM t_attraction
;

SELECT
    a.attraction_name
    ,CASE
        WHEN c.city_name IN ('Munising', 'Germfask')
            THEN 'Munising area'
        WHEN c.city_name IN ('Marquette', 'Ishpeming')
            THEN 'Marquette area'
        WHEN c.city_name IN ('Copper Harbor', 'Hancock', 'L''Anse')
            THEN 'Keweenaw area'
        ELSE 'Other areas'
    END AS case_area
FROM t_city AS c
INNER JOIN t_attraction AS a
    ON c.city_id = a.city_id
;