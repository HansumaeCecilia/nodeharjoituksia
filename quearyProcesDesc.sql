-- Query all fields (columns) and organize results
-- according to the timestamp in descending order
SELECT * 
	FROM public.hourly_price
	ORDER BY timeslot DESC;