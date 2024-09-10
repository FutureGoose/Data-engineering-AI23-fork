{{
  config(
    materialized = "incremental"
  )
}}

SELECT modified_timestamp,
       TIMESTAMP_SECONDS(SAFE_CAST(JSON_VALUE(JSON_EXTRACT(data, '$.time_epoch')) AS INT64)) AS temp_timestamp,
       SAFE_CAST(JSON_VALUE(JSON_EXTRACT(data, '$.temp_c')) AS NUMERIC) AS temp_c
FROM {{ source('weather_data', 'raw_weatherapp') }}
QUALIFY ROW_NUMBER() OVER (PARTITION BY temp_timestamp ORDER BY modified_timestamp DESC) = 1


-- PARSE_TIMESTAMP('%Y-%m-%d %H:%M', JSON_VALUE(JSON_EXTRACT(data, '$.time')))