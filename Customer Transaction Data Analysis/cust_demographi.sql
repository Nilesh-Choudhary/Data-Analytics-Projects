-- Total Number of Customers:

select count(*) as total_customers
from cust_demographi;


-- Number of Customers by Gender:

select gender, count(*) as number_of_customers
from cust_demographi
group by gender;


-- Average Age of Customers by Gender:

select gender, avg(age) as average_age
from cust_demographi
group by gender;


-- Total Bike-Related Purchases in the Past 3 Years:

select sum(past_3_years_bike_related_purchases) as total_bike_purchases
from cust_demographi;


-- Number of Customers by Wealth Segment:

select wealth_segment, count(*) as number_of_customers
from cust_demographi
group by wealth_segment;


-- Average Tenure by Wealth Segment:

select wealth_segment, avg(tenure) as average_tenure
from cust_demographi
group by wealth_segment;


-- Count of Customers Owning Cars:

select owns_car, count(*) as number_of_customers
from cust_demographi
group by owns_car;


-- Number of Customers by Job Industry:

select job_industry_category, count(*) as number_of_customers
from cust_demographi
group by job_industry_category
order by number_of_customers desc;


-- Average Age of Customers by Job Title:

select job_title, avg(age) as average_age
from cust_demographi
group by job_title
order by average_age desc;


-- Number of Deceased Customers:

select deceased_indicator, count(*) as number_of_customers
from cust_demographi
group by deceased_indicator;


-- Average Age and Bike Purchases of Non-Deceased Customers:

select avg(age) as average_age, avg(past_3_years_bike_related_purchases) as average_bike_purchases
from cust_demographi
where deceased_indicator = 'N';


-- Distribution of Wealth Segments Among Car Owners:

select wealth_segment, count(*) as car_owners
from cust_demographi
where owns_car = 'Yes'
group by wealth_segment;


-- Most Common Job Titles among Customers

select job_title, count(*) as number_of_customers
from cust_demographi
group by job_title
order by number_of_customers desc
limit 10;


-- Average Tenure by Gender and Wealth Segment:

select gender, wealth_segment, avg(tenure) as average_tenure
from cust_demographi
group by gender, wealth_segment
order by gender, wealth_segment;


-- Number of Customers Owning Cars by Gender:

select gender, owns_car, count(*) as number_of_customers
from cust_demographi
group by gender, owns_car
order by gender, owns_car;


-- Distribution of Bike Purchases across Different Age Groups:

select     
case 
	when age < 20 then 'Below 20'
	when age between 20 and 30 then '20-30'
	when age between 30 and 40 then '30-40'
	when age between 40 and 50 then '40-50'
	when age between 50 and 60 then '50-60'
	when age > 60 then 'Above 60'
end as age_group,
avg(past_3_years_bike_related_purchases) as average_bike_purchases
from cust_demographi
group by age_group
order by age_group;


-- Top 5 Job Industries Contributing to High Net Worth Segment:

select job_industry_category, count(*) as high_net_worth_customers
from cust_demographi
where wealth_segment = 'High Net Worth'
group by job_industry_category
order by high_net_worth_customers desc
limit 5;


-- Percentage of Customers Who Own Cars within Each Wealth Segment:

select wealth_segment, 
	count(case when owns_car = 'Yes' then 1 end) * 100.0 / count(*) as percentage_owning_cars
from cust_demographi
group by wealth_segment;


-- Number of Customers with Missing Job Title by Wealth Segment:

select wealth_segment, count(*) as customers_with_missing_job_title
from cust_demographi
where job_title is null
group by wealth_segment;


-- Age Distribution of Deceased and Non-Deceased Customers:

select deceased_indicator, 
  min(age) as minimum_age, 
  max(age) as maximum_age, 
	avg(age) as average_age
from cust_demographi
group by deceased_indicator;


-- Customers with Longest Tenure by Wealth Segment:

select wealth_segment, max(tenure) as longest_tenure
from cust_demographi
group by wealth_segment;


-- Count of Customers by Gender, Wealth Segment, and Car Ownership:

select gender, wealth_segment, owns_car, count(*) as number_of_customers
from cust_demographi
group by gender, wealth_segment, owns_car
order by gender, wealth_segment, owns_car;


-- Top 5 Most Active Customers Based on Bike Purchases:

select name, past_3_years_bike_related_purchases
from cust_demographi
order by past_3_years_bike_related_purchases desc
limit 5;


-- Average Tenure and Number of Bike Purchases by Age Group:

select 
  case 
	when age < 20 then 'Below 20'
	when age between 20 and 30 then '20-30'
	when age between 30 and 40 then '30-40'
	when age between 40 and 50 then '40-50'
	when age between 50 and 60 then '50-60'
	when age > 60 then 'Above 60'
end as age_group,
avg(tenure) as average_tenure,
avg(past_3_years_bike_related_purchases) as average_bike_purchases
from cust_demographi
group by age_group
order by age_group;


-- Number of Customers by Job Industry and Wealth Segment:

select job_industry_category, wealth_segment, count(*) as number_of_customers
from cust_demographi
group by job_industry_category, wealth_segment
order by job_industry_category, wealth_segment;


-- Customers with Age Above 80 by Car Ownership:

select owns_car, count(*) as number_of_customers
from cust_demographi
where age > 80
group by owns_car;


-- Wealth Segment Distribution for Customers Below Age 30:

select wealth_segment, count(*) as number_of_customers
from cust_demographi
where age < 30
group by wealth_segment;