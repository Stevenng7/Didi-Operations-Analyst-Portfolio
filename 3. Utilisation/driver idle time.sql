WITH ride_gaps AS (
    SELECT
        driver_id,
        ride_start_time,
        ride_end_time,
        LAG(ride_end_time) OVER (PARTITION BY driver_id ORDER BY ride_start_time) AS previous_ride_end
    FROM rides
)

SELECT
    driver_id,
    ROUND(AVG((JULIANDAY(ride_start_time) - JULIANDAY(previous_ride_end)) * 24 * 60), 2) AS avg_idle_minutes
FROM ride_gaps
WHERE previous_ride_end IS NOT NULL
GROUP BY driver_id
ORDER BY avg_idle_minutes ASC
LIMIT 10