CREATE EXTERNAL TABLE crop_yield_cleaned (
region STRING,
soil_type STRING,
crop STRING,
rainfall DOUBLE,
temperature DOUBLE,
fertilizer INT,
irrigation INT,
weather_condition STRING,
days_to_harvest INT,
yield DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/student/project/cleaned_crop_yield';
--#################################################--
SELECT
region,
COUNT (*) AS total_records,
AVG(rainfall) AS avg_rainfall,
AVG(temperature) AS avg_temperature,
AVG(fertilizer) AS fert_rate,
AVG(irrigation) AS irrig_rate,
AVG(yield) AS avg_yield
FROM crop_yield_cleaned
GROUP BY region
ORDER BY avg_yield DESC;
--#################################################--
SELECT * FROM crop_yield_cleaned LIMIT 10;
--#################################################--
SELECT
weather_condition,
fertilizer,
irrigation,
COUNT (*) AS count,
AVG(yield) AS avg_yield
FROM crop_yield_cleaned
GROUP BY weather_condition, fertilizer, irrigation
ORDER BY avg_yield DESC;
--#################################################--
SELECT
ROUND (CORR(rainfall, yield), 3) AS corr_rainfall,
ROUND (CORR(temperature, yield), 3) AS corr_temp
FROM crop_yield_cleaned;
--#################################################--
SELECT
fertilizer,
irrigation,
COUNT (*) AS count,
ROUND (AVG(yield), 2) AS avg_yield
FROM crop_yield_cleaned
GROUP BY fertilizer, irrigation
ORDER BY avg_yield DESC;
--#################################################--
SELECT
soil_type,
ROUND (AVG(yield), 5) AS avg_yield
FROM crop_yield_cleaned
GROUP BY soil_type
ORDER BY avg_yield DESC;
--#################################################--
SELECT
region,
COUNT (*) AS total_records,
AVG(rainfall) AS avg_rainfall,
AVG(temperature) AS avg_temperature,
AVG(fertilizer) AS fert_rate,
AVG(irrigation) AS irrig_rate,
AVG(yield) AS avg_yield
FROM crop_yield_cleaned
GROUP BY region
ORDER BY avg_yield DESC;
--#################################################--
SELECT
weather_condition,
CONCAT(CAST(fertilizer AS STRING), '_', CAST(irrigation AS STRING)) AS fert_irrig_combo,
ROUND (AVG(yield), 5) AS avg_yield
FROM crop_yield_cleaned
GROUP BY weather_condition, CONCAT(CAST(fertilizer AS STRING), '_', CAST(irrigation AS STRING))
ORDER BY weather_condition, fert_irrig_combo;
--#################################################--
CREATE TABLE crop_yield_features AS
SELECT
region,
soil_type,
crop,
rainfall,
temperature,
fertilizer,
irrigation,
days_to_harvest,
yield
FROM crop_yield_cleaned;
--#################################################--
