-- Загружаем сырые данные
raw = LOAD '/user/student/project/crop_yield.csv'
      USING PigStorage(',')
      AS (Region:chararray,
          Soil_Type:chararray,
          Crop:chararray,
          Rainfall_mm:chararray,
          Temperature_Celsius:chararray,
          Fertilizer_Used:chararray,
          Irrigation_Used:chararray,
          Weather_Condition:chararray,
          Days_to_Harvest:chararray,
          Yield_tons_per_hectare:chararray);
 
-- Удаляем заголовок
no_header = FILTER raw BY Region != 'Region';
 
-- Преобразуем типы
typed = FOREACH no_header GENERATE
    Region,
    Soil_Type,
    Crop,
    (double)Rainfall_mm       AS Rainfall,
    (double)Temperature_Celsius AS Temperature,
    (Fertilizer_Used == 'True' ? 1 : 0) AS Fertilizer,
    (Irrigation_Used == 'True' ? 1 : 0) AS Irrigation,
    Weather_Condition,
    (int)Days_to_Harvest      AS DaysToHarvest,
    (double)Yield_tons_per_hectare AS Yield;
 
-- Удаляем строки с null или отрицательными значениями
cleaned = FILTER typed BY 
    Rainfall IS NOT NULL AND Rainfall >= 0.0 AND
    Temperature IS NOT NULL AND Temperature >= 0.0 AND
    DaysToHarvest IS NOT NULL AND DaysToHarvest >= 0 AND
    Yield IS NOT NULL AND Yield >= 0.0;
 
-- Сохраняем очищенные данные
SET default_parallel 4;
STORE cleaned
    INTO '/user/student/project/cleaned_crop_yield'
    USING PigStorage(',');
