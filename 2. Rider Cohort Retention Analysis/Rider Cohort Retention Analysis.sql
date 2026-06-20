WITH first_rides AS (
	SELECT
		user_id,
		MIN(ride_start_time) AS first_ride_date
	FROM rides
	GROUP BY user_id
),

cohorts AS (
	SELECT
		user_id,
		first_ride_date,
		strftime('%Y-%W', first_ride_date) AS cohort_week
	FROM first_rides
),

rider_activity AS (
	SELECT
		r.user_id,
		c.cohort_week,
		STRFTIME('%Y-%W', r.ride_start_time) AS activity_week,
		CAST((JULIANDAY(r.ride_start_time) - JULIANDAY(c.first_ride_date)) / 7 AS INTEGER) AS week_number
	FROM rides r
	JOIN cohorts c ON r.user_id = c.user_id
),

retention AS (
	SELECT
		cohort_week,
		week_number,
		COUNT(DISTINCT user_id) AS active_riders
	FROM rider_activity
	GROUP BY cohort_week, week_number
)
SELECT 
	r.cohort_week,
	r.week_number,
	r.active_riders,
	first_week.active_riders as cohort_size,
	ROUND(CAST(r.active_riders AS FLOAT) / first_week.active_riders *100,1) AS retention_perc
FROM retention r
JOIN retention first_week
	on r.cohort_week = first_week.cohort_week
	AND first_week.week_number = 0
ORDER BY r.cohort_week, r.week_number

	