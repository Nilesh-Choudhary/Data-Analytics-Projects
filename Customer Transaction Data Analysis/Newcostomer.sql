-- Customer Distribution by Gender:

select gender, count(*) as num_customers
from newcustomer
group by gender;


-- Number of Customers by Wealth Segment:

select wealth_segment, count(*) as num_customers
from newcustomer
group by wealth_segment;


-- Find customers with property valuation above a certain threshold.

select concat(first_name, last_name) as full_name, property_valuation
from newcustomer
where property_valuation > 10
group by property_valuation;


-- Using date of birth to calculate age.

select 
concat(first_name, last_name) as full_name, year(curdate()) - year(str_to_date(dob, '%Y-%m-%d')) as age
from newcustomer;


-- Customers who made more than a specified number of bike-related purchases.

select first_name , past_3_years_bike_related_purchases
from newcustomer
where past_3_years_bike_related_purchases > 50;


-- Customers Who Own Cars vs. Those Who Don't:

select owns_car, count(*) as num_customers
from newcustomer
group by owns_car;


-- Average Tenure of Customers by Wealth Segment:

select wealth_segment, avg(tenure) as avg_tenure
from newcustomer
group by wealth_segment;


-- Top 5 Job Titles by Number of Customers:

select job_title, count(*) as num_customers
from newcustomer
group by job_title
order by num_customers desc
limit 5;


-- State-Wise Customer Distribution:

select state, count(*) as num_customers
from newcustomer
group by state;



-- Customer Retention Analysis: Analyze the number of customers retained over the years.

select year(str_to_date(dob, '%Y-%m-%d')) as year, count(distinct first_name) as unique_customers
from newcustomer
group by year;


-- Determine the age distribution of customers and identify which age groups are more frequent buyers.

select 
    floor((year(curdate()) - year(str_to_date(dob, '%Y-%m-%d'))) / 10) * 10 as age_group, 
    count(*) as num_customers
from newcustomer
group by age_group
order by age_group;
-- Insight: This will help identify the primary age demographic, such as whether most customers fall within the 30-40 or 40-50 age group.


-- Analyze the relationship between wealth segments and bike purchases in the past three years.

select 
    wealth_segment, 
    avg(past_3_years_bike_related_purchases) as avg_bike_purchases
from newcustomer
group by wealth_segment
order by avg_bike_purchases desc;
-- Insight: Understand which wealth segments are more likely to purchase bike-related products, helping in targeting marketing campaigns.


-- Determine if there's a correlation between customers' wealth segments and their property valuation.

select 
    wealth_segment, 
    avg(property_valuation) as avg_property_value
from newcustomer
group by wealth_segment
order by avg_property_value desc;
-- Insight: This can highlight if the wealth segments correspond to actual property value, validating or refuting the wealth categorization.


-- Calculate profitability by wealth segment based on a custom metric (e.g., total spend or number of purchases).

select 
    wealth_segment, 
    sum(past_3_years_bike_related_purchases) * avg(property_valuation) as profitability_score
from newcustomer
group by wealth_segment
order by profitability_score desc;
-- Insight: Identify which customer segment is the most profitable, allowing the business to allocate resources accordingly.


-- Compare car ownership statistics between male and female customers.

select 
    gender, 
    owns_car, 
    count(*) as num_customers
from newcustomer
group by gender, owns_car
order by num_customers desc;
-- Insight: This analysis could reveal whether certain genders have a higher likelihood of owning a car, influencing marketing strategies for automobile-related products.


-- Analyze the average customer tenure across different states.

select 
    state, 
    avg(tenure) as avg_tenure
from newcustomer
group by state
order by avg_tenure desc;
-- Insight: Helps identify the states with the most loyal customer base, allowing targeted retention efforts in other states.


-- Categorize customers based on their job industry and wealth segment.

select 
    job_industry_category, 
    wealth_segment, 
    count(*) as num_customers
from transactions
group by job_industry_category, wealth_segment
order by num_customers desc;
-- Insight: This reveals which job industries align with different wealth segments, useful for cross-selling and upselling strategies.


-- Determine the relationship between age groups and their frequency of bike-related purchases.

select 
    floor((year(curdate()) - year(str_to_date(dob, '%Y-%m-%d'))) / 10) * 10 as age_group, 
    avg(past_3_years_bike_related_purchases) as avg_bike_purchases
from newcustomer
group by age_group
order by avg_bike_purchases desc;
-- Insight: This analysis can help determine which age groups are more likely to buy bike-related products, guiding product development and promotions.


-- Calculate an estimate of the customer lifetime value based on historical purchase data.

select 
    first_name, 
    sum(past_3_years_bike_related_purchases * property_valuation) / tenure as customer_lifetime_value
from newcustomer
group by first_name
order by customer_lifetime_value desc
limit 10;
-- Insight: Identify high-value customers for loyalty programs and special campaigns.


-- Track customer purchases over the past three years to see if there's a growing or declining trend.

select 
    year(str_to_date(dob, '%Y-%m-%d')) as year, 
    sum(past_3_years_bike_related_purchases) as total_purchases
from newcustomer
group by year
order by year;
-- Insight: This will show if customers are purchasing more or less over the years, indicating potential shifts in demand or customer behavior.


-- 1. Customer Distribution by Wealth Segment:

select wealth_segment, count(*) as customer_count
from newcustomer
group by wealth_segment
order by customer_count desc;


-- 2. Distribution of Customers by Age:

select case
	when timestampdiff(year, dob, curdate()) < 25 then 'Under 25'
	when timestampdiff(year, dob, curdate()) between 25 and 40 then '25-40'
	when timestampdiff(year, dob, curdate()) between 41 and 60 then '41-60'
	else 'Above 60'
end as age_group,
 count(*) as customer_count
from newcustomer
where dob is not null
group by age_group
order by customer_count desc;


-- 3. Tenure of Customers by Wealth Segment:

select wealth_segment, avg(tenure) as avg_tenure
from newcustomer
group by wealth_segment
order by avg_tenure desc;


-- 8. High-Value Customers by Purchase Frequency:

select first_name, last_name, sum(past_3_years_bike_related_purchases) as total_purchases
from newcustomer
group by first_name, last_name
order by total_purchases desc
limit 10;


-- 9. Sales by State and Region:

select state, count(*) as sales_count, avg(property_valuation) as avg_property_value
from newcustomer
group by state
order by sales_count desc;


-- This will help to understand the gender balance of the customers.

select gender, count(*) as customer_count
from newcustomer
group by gender
order by customer_count desc;


-- Analyzing how many customers own cars based on their wealth segment.

select wealth_segment, owns_car, count(*) as customer_count
from newcustomer
group by wealth_segment, owns_car
order by wealth_segment, customer_count desc;


-- This insight shows how property valuation varies across different wealth segments.

select wealth_segment, avg(property_valuation) as avg_property_valuation
from newcustomer
group by wealth_segment
order by avg_property_valuation desc;


-- This will give insight into the most common industries for each wealth segment.

select wealth_segment, job_industry_category, count(*) as industry_count
from newcustomer
where job_industry_category is not null
group by wealth_segment, job_industry_category
order by wealth_segment, industry_count desc;


-- Analyzing how customers are distributed across states and wealth segments.

select state, wealth_segment, count(*) as customer_count
from newcustomer
group by state, wealth_segment
order by state, customer_count desc;


-- This query will give the count of deceased customers, if any.

select deceased_indicator, count(*) as customer_count
from newcustomer
group by deceased_indicator;


-- Grouping customers by age group and seeing their tenure with the company.

select case
	when timestampdiff(year, dob, curdate()) < 25 then 'Under 25'
	when timestampdiff(year, dob, curdate()) between 25 and 40 then '25-40'
	when timestampdiff(year, dob, curdate()) between 41 and 60 then '41-60'
	  else 'Above 60'
    end as age_group,
	avg(tenure) as avg_tenure
from newcustomer
where dob is not null
group by age_group
order by avg_tenure desc;


-- This query will show which postcodes have the most customers.

select postcode, count(*) as customer_count
from newcustomer
group by postcode
order by customer_count desc
limit 10;


-- To find how many customers are missing job titles.

select count(*) as customers_without_job_titles
from newcustomer
where job_title is null;


-- This query shows the distribution of wealth segments across gender.

select gender, wealth_segment, count(*) as customer_count
from newcustomer
group by gender, wealth_segment
order by gender, customer_count desc;


-- List of customers with the highest property valuations.

select first_name, last_name, state, property_valuation
from newcustomer
order by property_valuation desc
limit 10;





