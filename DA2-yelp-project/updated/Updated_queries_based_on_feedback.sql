--query to show the integration
SELECT 
    r.business_id,
    r.review_id,
    r.user_id,
    r.date,
    r.stars,
    r.cool,
    r.funny,
    r.useful,
    r.text,
    t.min AS temp_min,
    t.max AS temp_max,
    t.normal_min AS temp_normal_min,
    t.normal_max AS temp_normal_max,
    p.precipitation,
    p.precipitation_normal
FROM
    review r
JOIN
    temperature t ON r.date = t.date
JOIN
    precipitation p ON r.date = p.date;
    
-- query for sizes of raw, staging and ODS data
WITH STAGING AS (
    SELECT
        TABLE_NAME,
        SUM(ROW_COUNT) AS ROW_COUNT,
        SUM(BYTES) AS TABLE_SIZE
    FROM 
        INFORMATION_SCHEMA.TABLES
    WHERE 
        TABLE_SCHEMA = 'STAGING'
        AND TABLE_NAME IN ('COVID', 'TIP', 'BUSINESS', 'REVIEW', 'USER', 'CHECKIN', 'PRECIPITATION', 'TEMPERATURE')
    GROUP BY 
        TABLE_NAME
),
ODS AS (
    SELECT
        TABLE_NAME,
        SUM(ROW_COUNT) AS ROW_COUNT,
        SUM(BYTES) AS TABLE_SIZE
    FROM 
        INFORMATION_SCHEMA.TABLES
    WHERE 
        TABLE_SCHEMA = 'ODS'
        AND TABLE_NAME IN ('COVID', 'TIP', 'BUSINESS', 'REVIEW', 'USER', 'CHECKIN', 'PRECIPITATION', 'TEMPERATURE')
    GROUP BY 
        TABLE_NAME
)
SELECT
    COALESCE(STAGING.TABLE_NAME, ODS.TABLE_NAME) AS TABLE_NAME,
    STAGING.ROW_COUNT AS ROW_COUNT_IN_STAGING,
    STAGING.TABLE_SIZE AS SIZE_IN_STAGING,
    ODS.ROW_COUNT AS ROW_COUNT_IN_ODS,
    ODS.TABLE_SIZE AS SIZE_IN_ODS
FROM
    STAGING
FULL OUTER JOIN
    ODS
ON
    STAGING.TABLE_NAME = ODS.TABLE_NAME
ORDER BY
    TABLE_NAME;

LIST @STAGE_ENV;
