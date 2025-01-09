-- Total Number of Unique Customers in Address Dataset:

select count(distinct customer_id) as unique_customers 
from cust_address;


-- Number of Customers by State:

select state, count(*) as number_of_customers
from cust_address
group by state;


-- Average Property Valuation by State:

select state, avg(property_valuation) as average_property_valuation
from cust_address
group by state;


-- Number of Customers by Property Valuation Score:

select property_valuation, count(*) as number_of_customers
from cust_address
group by property_valuation
order by property_valuation;


-- Top 5 Most Populated Postal Codes:

select postcode, count(*) as number_of_customers
from cust_address
group by postcode
order by number_of_customers desc
limit 5;


-- Average Property Valuation by Postal Code:

select postcode, avg(property_valuation) as average_property_valuation
from cust_address
group by postcode
order by average_property_valuation desc;


-- Distribution of Customers by Country:

select country, count(*) as number_of_customers
from cust_address
group by country;
-- Since the dataset might have only one country ("Australia"), this query confirms and counts unique countries.


-- Number of Customers for Each Property Valuation Score:

select property_valuation, count(*) as number_of_customers
from cust_address
group by property_valuation
order by property_valuation;
-- Analyzes how many customers fall into each property valuation score.


-- Top 5 States with the Lowest Average Property Valuation:

select state, avg(property_valuation) as average_property_valuation
from cust_address
group by state
order by average_property_valuation asc
limit 5;
-- This query reveals which states have the lowest average property valuation scores.


-- Postal Codes with the Highest Number of Customers:

select postcode, count(*) as number_of_customers
from cust_address
group by postcode
order by number_of_customers desc
limit 5;
-- Identifies the postal codes that have the most customers.


-- Top 3 States with Highest Average Property Valuation:

select state, avg(property_valuation) as average_property_valuation
from cust_address
group by state
order by average_property_valuation desc
limit 3;
-- Identifies the top 3 states with the highest average property valuation.


-- Average Property Valuation by Postal Code:

select postcode, avg(property_valuation) as average_property_valuation
from cust_address
group by postcode
order by average_property_valuation desc;
-- Analyzes property valuation across different postal codes.


-- Total Number of Customers Grouped by State and Postal Code:

select state, postcode, count(*) as number_of_customers
from cust_address
group by state, postcode
order by state, postcode;
-- Provides a detailed view of customer distribution across state and postal code combinations.


-- States with the Most Unique Postal Codes:

select state, count(distinct postcode) as unique_postal_codes
from cust_address
group by state
order by unique_postal_codes desc;
-- Shows which states have the highest diversity in postal codes.


-- Top 5 States with the Highest Number of Properties with a Valuation Above 8:

select state, count(*) as high_valuation_properties
from cust_address
where property_valuation > 8
group by state
order by high_valuation_properties desc
limit 5;
-- Lists states with the highest number of properties having a valuation score above 8.


-- Total Number of Customers per State with Postal Code Prefix Analysis:

select state, 
	substring(postcode, 1, 2) as postcode_prefix,
	count(*) as number_of_customers
from cust_address
group by state, postcode_prefix
order by state, postcode_prefix;
-- This query extracts and analyzes customers based on the first two digits of the postal code, grouped by state.


-- Top 5 Postal Codes with the Highest Property Valuation:

select postcode, max(property_valuation) as max_property_valuation
from cust_address
group by postcode
order by max_property_valuation desc
limit 5;
-- Identifies postal codes with the highest maximum property valuation scores.


-- Average Property Valuation for Each Country:

select country, avg(property_valuation) as average_property_valuation
from cust_address
group by country;
-- While the data may show only "Australia," this confirms and provides insight into the valuation score distribution.


-- Count of Unique Postal Codes by Property Valuation:

select property_valuation, count(distinct postcode) as unique_postal_codes
from cust_address
group by property_valuation
order by unique_postal_codes desc;
-- Shows how many unique postal codes fall under each property valuation score.


-- Top 5 Postal Codes with Highest Average Property Valuation:

select postcode, avg(property_valuation) as average_property_valuation
from cust_address
group by postcode
order by average_property_valuation desc
limit 5;
-- Lists postal codes with the highest average property valuation.


-- Number of Properties in Each State with a Valuation Below 5:

select state, count(*) as low_valuation_properties
from cust_address
where property_valuation < 5
group by state
order by low_valuation_properties desc;
