SELECT
	start_location,
	COUNT(ride_id) AS total_rides,
	COUNT(DISTINCT driver_id) AS active_drivers,
	ROUND(CAST(COUNT(ride_id) AS FLOAT) / COUNT(DISTINCT driver_id), 2) AS rides_per_driver
FROM rides
GROUP BY start_location
ORDER BY total_rides DESC
LIMIT 10