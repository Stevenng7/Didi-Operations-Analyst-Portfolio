WITH utilisation AS (
    SELECT
        CAST(STRFTIME('%H', ride_start_time) AS INTEGER) AS hour_of_day,
        COUNT(ride_id) AS total_rides,
        COUNT(DISTINCT driver_id) AS active_drivers
    FROM rides
    GROUP BY hour_of_day
)

SELECT
    hour_of_day,
    total_rides,
    active_drivers,
    ROUND(CAST(total_rides AS FLOAT) / active_drivers, 2) AS rides_per_driver
FROM utilisation
ORDER BY hour_of_day