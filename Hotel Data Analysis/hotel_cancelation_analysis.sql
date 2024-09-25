show databases;

use hotel_db;

show tables;

select * from bookings limit 5;

select * from market_segment;

select * from meal_cost;

alter table bookings rename hotel;

select * from hotel limit 5;

SELECT COUNT(*) AS Total_Cancellations
FROM bookings
WHERE reservation_status = 'Canceled';


-- Cancellations by Customer Type
SELECT customer_type, COUNT(*) AS Number_of_Cancellations
FROM hotel
WHERE reservation_status = 'Canceled'
GROUP BY customer_type
ORDER BY Number_of_Cancellations DESC;


-- 1. Overall Cancellation Rate
-- Calculate the overall cancellation rate across the dataset:

SELECT 
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS total_cancellations,
    (SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS cancellation_rate_percentage
FROM 
    hotel;

select count(*) as total_booking,
sum(is_canceled) as total_cancellations,
(sum(is_canceled)/count(*))*100 as cancellation_rate_percentage
from hotel;


SELECT 
    arrival_date_year,
    arrival_date_month,
count(*) as total_booking,
sum(is_canceled) as total_cancellations,
(sum(is_canceled)/count(*))*100 as cancellation_rate_percentage
FROM 
    hotel
GROUP BY 
    arrival_date_year,
    arrival_date_month
ORDER BY 
        arrival_date_year,
    arrival_date_month;
   
   
-- Cancellation rate by market segment:    

SELECT 
    market_segment, 
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
where market_segment != "Undefined"
GROUP BY market_segment
ORDER BY cancellation_rate DESC;

-- Average daily rate (ADR) by country and room type:

SELECT 
    country, 
    assigned_room_type, 
    round(avg(adr), 2) as avg_adr
FROM hotel
GROUP BY country, assigned_room_type
ORDER BY avg_adr DESC;


-- Cancellation rate by lead time:

SELECT 
    CASE 
        WHEN lead_time < 30 THEN 'Short'
        WHEN lead_time >= 30 AND lead_time < 60 THEN 'Medium'
        ELSE 'Long'
    END AS lead_time_category,
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY lead_time_category
ORDER BY cancellation_rate DESC;

-- Total revenue and average daily rate by arrival date:
SELECT 
    arrival_date_year, 
    arrival_date_month, 
    sum(adr * (stays_in_week_nights + stays_in_weekend_nights)) as total_revenue,
    round(avg(adr), 2) as avg_adr
FROM hotel
WHERE is_canceled = 0
GROUP BY arrival_date_year, arrival_date_month
ORDER BY arrival_date_year, arrival_date_month;

-- Repeat guest analysis:

SELECT 
    is_repeated_guest, 
    count(*) as num_bookings,
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY is_repeated_guest
ORDER BY is_repeated_guest;

-- Impact of special requests on cancellation rate:

SELECT 
    total_of_special_requests, 
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY total_of_special_requests
ORDER BY total_of_special_requests;

-- Cancellation rate by arrival day of the week:
SELECT 
    DAYNAME(reservation_status_date) AS reservation_day,
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY reservation_day
ORDER BY cancellation_rate DESC;


-- Cancellation rate by meal plan:

SELECT 
    meal, 
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY meal
ORDER BY cancellation_rate DESC;

-- Relationship between deposit type and cancellation rate:

SELECT 
    deposit_type, 
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY deposit_type
ORDER BY cancellation_rate DESC;


-- Correlation between previous bookings and cancellations:

SELECT 
    previous_bookings_not_canceled, 
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY previous_bookings_not_canceled
ORDER BY previous_bookings_not_canceled;


-- Cancellation rate by distribution channel:

SELECT 
    distribution_channel, 
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY distribution_channel
ORDER BY cancellation_rate DESC;


-- Analysis of booking changes:

SELECT 
    booking_changes, 
    round(100.0 * sum(case when is_canceled = 1 then 1 else 0 end) / count(*), 2) as cancellation_rate
FROM hotel
GROUP BY booking_changes
ORDER BY booking_changes;



 