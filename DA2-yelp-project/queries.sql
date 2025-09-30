-- loading raw data into staging

CREATE OR REPLACE DATABASE YELP_DATABASE;
USE DATABASE YELP_DATABASE;

CREATE OR REPLACE SCHEMA STAGING;

CREATE OR REPLACE SCHEMA ODS;

CREATE OR REPLACE SCHEMA DWH;

USE WAREHOUSE COMPUTE_WH;
USE DATABASE YELP_DATABASE;
USE SCHEMA STAGING;

CREATE OR REPLACE TABLE covid (v VARIANT);

CREATE OR REPLACE TABLE tip (v VARIANT);

CREATE OR REPLACE TABLE user (v VARIANT);

CREATE OR REPLACE TABLE review (v VARIANT);

CREATE OR REPLACE TABLE business (v VARIANT);

CREATE OR REPLACE TABLE checkin (v VARIANT);

CREATE OR REPLACE TABLE precipitation (date VARCHAR, precipitation STRING, precipitation_normal FLOAT);
	
CREATE OR REPLACE TABLE temperature (date VARCHAR, min FLOAT, max FLOAT, normal_min FLOAT, normal_max FLOAT);
	
CREATE OR REPLACE STAGE STAGE_ENV;

PUT file://./raw_data/yelp_academic_dataset_covid_features.json @STAGE_ENV AUTO_COMPRESS=FALSE;
PUT file://./raw_data/yelp_academic_dataset_business.json @STAGE_ENV AUTO_COMPRESS=FALSE;
PUT file://./raw_data/yelp_academic_dataset_checkin.json @STAGE_ENV AUTO_COMPRESS=FALSE;
PUT file://./raw_data/yelp_academic_dataset_review.json @STAGE_ENV AUTO_COMPRESS=FALSE;
PUT file://./raw_data/yelp_academic_datasetip.json @STAGE_ENV AUTO_COMPRESS=FALSE;
PUT file://./raw_data/yelp_academic_dataset_user.json @STAGE_ENV AUTO_COMPRESS=FALSE;
PUT file://./raw_data/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv @STAGE_ENV AUTO_COMPRESS=FALSE;
PUT file://./raw_data/usw00023169-temperature-degreef.csv @STAGE_ENV AUTO_COMPRESS=FALSE;

COPY INTO covid FROM @STAGE_ENV/yelp_academic_dataset_covid_features.json file_format=(type=JSON);

COPY INTO tip FROM @STAGE_ENV/yelp_academic_datasetip.json file_format=(type=JSON);

COPY INTO user FROM @STAGE_ENV/yelp_academic_dataset_user.json file_format=(type=JSON);

COPY INTO review FROM @STAGE_ENV/yelp_academic_dataset_review.json file_format=(type=JSON);

COPY INTO business FROM @STAGE_ENV/yelp_academic_dataset_business.json file_format=(type=JSON);

COPY INTO checkin FROM @STAGE_ENV/yelp_academic_dataset_checkin.json file_format=(type=JSON);

COPY INTO precipitation FROM @STAGE_ENV/USW00023169-LAS_VEGAS_MCCARRAN_INTL_AP-precipitation-inch.csv file_format=(type=csv);

COPY INTO temperature FROM @STAGE_ENV/USW00023169-temperature-degreeF.csv file_format=(type=csv);

UPDATE PRECIPITATION SET precipitation = NULL WHERE precipitation = 'T';

-- staging to ODS

USE SCHEMA ODS;

CREATE TABLE precipitation (
	date DATE,
	precipitation FLOAT,
	precipitation_normal FLOAT);
	
	
INSERT INTO precipitation(date, precipitation, precipitation_normal)
SELECT TO_DATE(date,'YYYYMMDD'), 
CAST(precipitation AS FLOAT), 
CAST(precipitation_normal AS FLOAT) FROM "YELP_DATABASE"."STAGING".precipitation;

CREATE TABLE temperature (
	date DATE,
	min INT,
	max INT,
	normal_min FLOAT,
	normal_max FLOAT);
	
INSERT INTO temperature(date, min, max, normal_min, normal_max)
SELECT TO_DATE(date, 'YYYYMMDD'),
CAST(min AS INT),
CAST(max AS INT),
CAST(normal_min AS FLOAT),
CAST(normal_max AS FLOAT) FROM "YELP_DATABASE"."STAGING".temperature;


CREATE TABLE tip (
	user_id STRING,
	business_id STRING,
	text STRING,
	date STRING,
	compliment_count INTEGER);
	
INSERT INTO tip(user_id, business_id, text, date, compliment_count) 
SELECT parse_json($1):user_id,
			parse_json($1):business_id,
			parse_json($1):text,
			parse_json($1):date,
			parse_json($1):compliment_count
	FROM "YELP_DATABASE"."STAGING".tip;
	
	
CREATE TABLE business (
	business_id VARCHAR(200),
	name VARCHAR(100),
	address VARCHAR(200),
	city VARCHAR(100),
	state VARCHAR(10),
	postal_code VARCHAR(20),
	latitude FLOAT,
	longitude FLOAT,
	stars FLOAT,
	review_count NUMBER(38,0),
	is_open NUMBER(38,0),
	attribute OBJECT,
	categories VARCHAR,
	hours VARIANT);
	
	
INSERT INTO business(business_id,name, address, city, state, postal_code, latitude,longitude,stars, review_count, is_open, attribute, categories, hours)
SELECT parse_json($1):business_id,
			parse_json($1):name,
			parse_json($1):address,
			parse_json($1):city,
			parse_json($1):state,
			parse_json($1):postal_code,
			parse_json($1):latitude,
			parse_json($1):longitude,
			parse_json($1):stars,
			parse_json($1):review_count,
			parse_json($1):is_open,
			parse_json($1):attribute,
			parse_json($1):categories,
			parse_json($1):hours
	FROM "YELP_DATABASE"."STAGING".business;
	
	
CREATE TABLE user (
        user_id VARCHAR,
        name VARCHAR,
        review_count INTEGER,
        yelping_since DATE,
        friends VARCHAR,
        useful INTEGER,
        funny INTEGER,
        cool INTEGER,
        fans INTEGER,
        elite VARCHAR,
        average_stars FLOAT,
        compliment_hot INTEGER,
        compliment_more INTEGER,
        compliment_profile INTEGER,
        compliment_cute INTEGER,
        compliment_list INTEGER,
        compliment_note INTEGER,
        compliment_plain INTEGER,
        compliment_cool INTEGER,
        compliment_funny INTEGER,
        compliment_writer INTEGER,
        compliment_photos INTEGER
    );
	

INSERT INTO user(
    user_id, name, review_count, yelping_since, friends, useful, funny, cool, fans, elite, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos
)
SELECT
    parse_json($1):user_id,
    parse_json($1):name,
    parse_json($1):review_count,
    parse_json($1):yelping_since,
    parse_json($1):friends,
    parse_json($1):useful,
    parse_json($1):funny,
    parse_json($1):cool,
    parse_json($1):fans,
    parse_json($1):elite,
    parse_json($1):average_stars,
    parse_json($1):compliment_hot,
    parse_json($1):compliment_more,
    parse_json($1):compliment_profile,
    parse_json($1):compliment_cute,
    parse_json($1):compliment_list,
    parse_json($1):compliment_note,
    parse_json($1):compliment_plain,
    parse_json($1):compliment_cool,
    parse_json($1):compliment_funny,
    parse_json($1):compliment_writer,
    parse_json($1):compliment_photos
FROM "YELP_DATABASE"."STAGING".user;
	
	
CREATE TABLE review (
        business_id VARCHAR,
        review_id VARCHAR,
        user_id VARCHAR,
        date DATE,
        stars FLOAT,
        cool INTEGER,
        funny INTEGER,
        useful INTEGER,
        text VARCHAR
    );

INSERT INTO review 
(
    business_id, review_id, user_id, date, stars, cool, funny, useful, text
)
SELECT
    parse_json($1):business_id,
    parse_json($1):review_id,
    parse_json($1):user_id,
    parse_json($1):date,
    parse_json($1):stars,
    parse_json($1):cool,
    parse_json($1):funny,
    parse_json($1):useful,
    parse_json($1):text FROM "YELP_DATABASE"."STAGING".review
	
	
CREATE TABLE checkin(
	business_id VARIANT,
	date STRING);
	
INSERT INTO checkin(business_id, date)
SELECT parse_json($1):business_id,
		parse_json($1):date 
		FROM "YELP_DATABASE"."STAGING".checkin;
		
		
CREATE TABLE covid (
        business_id VARCHAR(100),
        cal_to_action_enabled VARIANT,
        covid_banner VARIANT,
        grubhub_enabled VARIANT,
        request_a_quote_enabled VARIANT,
        temporary_closed_until VARIANT,
        virtual_services_offered VARIANT,
        delivery_or_takeout VARIANT,
        highlights VARIANT

    );

INSERT INTO covid 
(
    business_id, cal_to_action_enabled, covid_banner, grubhub_enabled, request_a_quote_enabled, temporary_closed_until, virtual_services_offered, delivery_or_takeout, highlights
)
SELECT
    parse_json($1):business_id,
    parse_json($1):"Call To Action enabled",
    parse_json($1):"Covid Banner",
    parse_json($1):"Grubhub enabled",
    parse_json($1):"Request a Quote Enabled",
    parse_json($1):"Temporary Closed Until",
    parse_json($1):"Virtual Services Offered",
    parse_json($1):"delivery or takeout",
    parse_json($1):"highlights" FROM "YELP_DATABASE"."STAGING".covid;
    
    
-- ODS to DWH

USE SCHEMA DWH; 

CREATE TABLE dwh.business_dim (
    business_key INT IDENTITY(1,1) PRIMARY KEY,
    business_id VARCHAR(200),
    name VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(10),
    postal_code VARCHAR(20),
    latitude FLOAT,
    longitude FLOAT,
    stars FLOAT,
    review_count NUMBER(38,0),
    is_open NUMBER(38,0),
    attribute OBJECT,
    categories VARCHAR,
    hours VARIANT
);

CREATE TABLE dwh.user_dim (
    user_key INT IDENTITY(1,1) PRIMARY KEY,
    user_id VARCHAR,
    name VARCHAR,
    review_count INTEGER,
    yelping_since DATE,
    friends VARCHAR,
    useful INTEGER,
    funny INTEGER,
    cool INTEGER,
    fans INTEGER,
    elite VARCHAR,
    average_stars FLOAT,
    compliment_hot INTEGER,
    compliment_more INTEGER,
    compliment_profile INTEGER,
    compliment_cute INTEGER,
    compliment_list INTEGER,
    compliment_note INTEGER,
    compliment_plain INTEGER,
    compliment_cool INTEGER,
    compliment_funny INTEGER,
    compliment_writer INTEGER,
    compliment_photos INTEGER
);

CREATE TABLE dwh.date_dim (
    date_key INT PRIMARY KEY,
    date DATE,
    year INT,
    quarter INT,
    month INT,
    day INT,
    day_of_week INT
);

INSERT INTO dwh.date_dim (date_key, date, year, quarter, month, day, day_of_week)
SELECT ROW_NUMBER() OVER (ORDER BY date) AS date_key, date, 
    EXTRACT(YEAR FROM date) AS year, 
    EXTRACT(QUARTER FROM date) AS quarter, 
    EXTRACT(MONTH FROM date) AS month, 
    EXTRACT(DAY FROM date) AS day, 
    EXTRACT(DOW FROM date) AS day_of_week
FROM (SELECT DISTINCT date FROM ods.precipitation UNION 
      SELECT DISTINCT date FROM ods.temperature UNION 
      SELECT DISTINCT date FROM ods.review) AS all_dates;

CREATE TABLE dwh.review_fact (
    review_id VARCHAR PRIMARY KEY,
    business_key INT,
    user_key INT,
    date_key INT,
    stars FLOAT,
    cool INTEGER,
    funny INTEGER,
    useful INTEGER,
    text VARCHAR,
    FOREIGN KEY (business_key) REFERENCES dwh.business_dim(business_key),
    FOREIGN KEY (user_key) REFERENCES dwh.user_dim(user_key),
    FOREIGN KEY (date_key) REFERENCES dwh.date_dim(date_key)
);


INSERT INTO dwh.business_dim (business_id, name, address, city, state, postal_code, latitude, longitude, stars, review_count, is_open, attribute, categories, hours)
SELECT business_id, name, address, city, state, postal_code, latitude, longitude, stars, review_count, is_open, attribute, categories, hours
FROM ods.business;

INSERT INTO dwh.user_dim (user_id, name, review_count, yelping_since, friends, useful, funny, cool, fans, elite, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos)
SELECT user_id, name, review_count, yelping_since, friends, useful, funny, cool, fans, elite, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos
FROM ods.user;

INSERT INTO dwh.review_fact (review_id, business_key, user_key, date_key, stars, cool, funny, useful, text)
SELECT r.review_id, 
       b.business_key, 
       u.user_key, 
       d.date_key, 
       r.stars, r.cool, r.funny, r.useful, r.text
FROM ods.review r
JOIN dwh.business_dim b ON r.business_id = b.business_id
JOIN dwh.user_dim u ON r.user_id = u.user_id
JOIN dwh.date_dim d ON r.date = d.date;

-- generate report
SELECT 
    b.name AS business_name,
    t.max AS max_temperature,
    t.min AS min_temperature,
    p.precipitation AS precipitation,
    p.precipitation_normal AS precipitation_normal,
    AVG(r.stars) AS average_rating
FROM 
    dwh.review_fact r
JOIN 
    dwh.business_dim b ON r.business_key = b.business_key
JOIN 
    dwh.date_dim d ON r.date_key = d.date_key
LEFT JOIN 
    ods.temperature t ON d.date = t.date
LEFT JOIN 
    ods.precipitation p ON d.date = p.date
GROUP BY 
    b.name, t.max, t.min, p.precipitation, p.precipitation_normal
ORDER BY 
    b.name;

