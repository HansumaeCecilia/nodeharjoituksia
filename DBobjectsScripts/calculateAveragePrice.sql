-- Calculates average electricity price of all data

SELECT round(cast(AVG (price) as numeric), 3) AS keskihinta
	FROM public.hourly_price;