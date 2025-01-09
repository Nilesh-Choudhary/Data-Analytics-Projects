-- Customer Demographics and Transactions

select cd.customer_id, cd.name, cd.age, t.transaction_id, t.product_id, t.list_price, t.transaction_date
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id;


-- Customer Demographics and New Customer List

select cd.customer_id, cd.name, cd.age, cd.DOB, nc.first_name, nc.last_name, nc.wealth_segment
from cust_demographi cd
join newcustomer nc on cd.DOB = nc.DOB;


-- This query calculates the total amount spent by each customer based on their transactions.

select cd.customer_id, cd.name, sum(t.list_price) as total_spent
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
group by cd.customer_id, cd.name
order by total_spent desc;


-- This query helps identify the average age and the wealth segment of customers who have placed online orders.

select cd.wealth_segment, avg(cd.age) as avg_age, count(t.online_order) as total_online_orders
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
where t.online_order = 1
group by cd.wealth_segment;


-- This query identifies customers who own a car and have made at least one transaction.

select cd.customer_id, cd.name, cd.owns_car, count(t.transaction_id) as transaction_count
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
where cd.owns_car = 'Yes'
group by cd.customer_id, cd.name, cd.owns_car;


-- This query calculates the total revenue generated from each wealth segment.

select cd.wealth_segment, sum(t.list_price) as total_revenue
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
group by cd.wealth_segment
order by total_revenue desc;


-- This query provides insights into property valuation trends based on gender and age groups.

select nc.gender, 
    case 
        when timestampdiff(year, nc.DOB, CURDATE()) < 30 then 'Under 30'
        when timestampdiff(year, nc.DOB, CURDATE()) between 30 and 50 then '30-50'
        else 'above 50'
    end as age_group, 
    avg(nc.property_valuation) as avg_property_value
from newcustomer nc
group by nc.gender, age_group;


-- This query helps identify customers who have made the most purchases.

select cd.customer_id, cd.name, count(t.transaction_id) as transaction_count
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
group by cd.customer_id, cd.name
order by transaction_count desc
limit 10;


-- This query calculates the total revenue from each customer, grouped by their wealth segment.

select cd.wealth_segment, cd.customer_id, cd.name, sum(t.list_price) as total_revenue
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
group by cd.wealth_segment, cd.customer_id, cd.name
order by total_revenue desc;



-- This query lists customers from the customer demographics table who haven't made any purchases in the last year (assuming the current date is 2023-09-28).

select cd.customer_id, cd.name, max(t.transaction_date) as last_purchase_date
from cust_demographi cd
left join transaction t on cd.customer_id = t.customer_id
group by cd.customer_id, cd.name
having max(t.transaction_date) < '2022-09-28' or max(t.transaction_date) is null;


-- This query identifies customers who have placed the most number of online orders.

select cd.customer_id, cd.name, count(t.transaction_id) as online_order_count
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
where t.online_order = 1
group by cd.customer_id, cd.name
order by online_order_count desc;


-- This query determines the revenue contribution of customers based on their job industry category.

select cd.job_industry_category, sum(t.list_price) as total_revenue
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
group by cd.job_industry_category
order by total_revenue desc;


-- This query gives insights into the transactions made by customers who are listed in the new customer list.

select nc.DOB, nc.first_name, nc.last_name, sum(cd.tenure) as total_tenure
from newcustomer nc
join cust_demographi cd on nc.DOB = cd.DOB
group by nc.DOB, nc.first_name, nc.last_name
order by total_tenure desc;


-- This query helps compare the wealth segments of existing customers and new customers.

select 'Existing Customer' as customer_type, cd.wealth_segment, count(cd.name) as customer_count
from cust_demographi cd
group by cd.wealth_segment
union all
select 'New Customer' as customer_type, nc.wealth_segment, count(nc.first_name) as customer_count
from newcustomer nc
group by nc.wealth_segment
order by customer_count desc;


-- This query segments customers by age groups and calculates the revenue contribution for each group.

select 
case 
	when cd.age < 30 then 'Under 30'
	when cd.age between 30 and 50 then '30-50'
	when cd.age between 50 and 70 then '50-70'
	else 'Above 70'
end as age_group,
    sum(t.list_price) as total_revenue
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
group by age_group
order by total_revenue desc;


-- This query joins the customer demographics and transaction tables to find the total amount spent by customers, grouped by their job titles.

select cd.job_title, sum(t.list_price) as total_spent
from cust_demographi cd
join transaction t on cd.customer_id = t.customer_id
group by cd.job_title
order by total_spent desc; 


-- This query joins the customer demographics and new customer list using first_name, last_name, and DOB to identify common records based on names and birth dates.

select cd.name, nc.first_name, nc.last_name, cd.age, cd.gender, nc.state, nc.country
from cust_demographi cd
join newcustomer nc on cd.name = concat(nc.first_name, ' ', nc.last_name) and cd.DOB = nc.DOB;


-- This query compares the wealth segments of customers from both datasets based on the wealth_segment column.

select cd.wealth_segment as existing_customer_segment, nc.wealth_segment as new_customer_segment, count(*) as matching_customers
from cust_demographi cd
join newcustomer nc on cd.wealth_segment = nc.wealth_segment
group by cd.wealth_segment, nc.wealth_segment
order by matching_customers desc;


-- This query joins the two datasets based on the job_title and job_industry_category columns to see how many customers share similar employment attributes.

select cd.job_title, nc.job_title as new_customer_job_title, cd.job_industry_category, nc.job_industry_category, count(*) as matching_customers
from cust_demographi cd
join newcustomer nc on cd.job_title = nc.job_title and cd.job_industry_category = nc.job_industry_category
group by cd.job_title, nc.job_title, cd.job_industry_category, nc.job_industry_category
order by matching_customers desc;


-- The commonalities between new and existing customers who own cars.

select cd.name, nc.first_name, nc.last_name, cd.owns_car, nc.owns_car as new_customer_owns_car
from cust_demographi cd
join newcustomer nc on cd.owns_car = nc.owns_car
where cd.owns_car = 'Yes';


-- This query joins the two datasets based on first_name, last_name, and gender to identify common records.

select cd.name, nc.first_name, nc.last_name, cd.gender, nc.gender as new_customer_gender, cd.wealth_segment
from cust_demographi cd
join newcustomer nc on cd.name = concat(nc.first_name, ' ', nc.last_name) and cd.gender = nc.gender;


-- This query compares customers based on their job_industry_category and property_valuation.

select cd.name, nc.first_name, nc.last_name, cd.job_industry_category, nc.job_industry_category as new_customer_job_industry, cd.wealth_segment, nc.property_valuation
from cust_demographi cd
join newcustomer nc on cd.job_industry_category = nc.job_industry_category and cd.wealth_segment = nc.wealth_segment
order by nc.property_valuation desc;


 -- Find common customers between both datasets
select *
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country;


-- Find all customer addresses with corresponding information from the new customer list

select *
from cust_address ca
left join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country;


-- Find all entries from the new customer list and match corresponding addresses

select *
from cust_address ca
right join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country;


-- Get all records from both datasets with matching
select *
from cust_address ca
join newcustomer nc
  on ca.address = nc.address
  and ca.postcode = nc.postcode
  and ca.state = nc.state
  and ca.country = nc.country;


-- This query identifies customers who have high property valuations and have made a significant number of bike-related purchases. We can define a threshold for both metrics.

select nc.first_name, nc.last_name, nc.past_3_years_bike_related_purchases, ca.property_valuation
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
where nc.past_3_years_bike_related_purchases > 50
and ca.property_valuation > 8;


-- This query finds customers from the customer_address table that do not have a corresponding entry in the new_customer_list based on address matching.

select ca.*
from cust_address ca
left join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
where nc.address is null;

-- This query shows how many customers belong to different wealth segments in each state. The query uses group by with a join.

select nc.wealth_segment, ca.state, count(*) as customer_count
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
group by nc.wealth_segment, ca.state
order by ca.state, customer_count desc;

-- This query identifies customers who own a car and have a high property valuation.

select nc.first_name, nc.last_name, ca.property_valuation, nc.owns_car
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
where nc.owns_car = 'Yes'
and ca.property_valuation > 7;

-- This query computes the average property valuation for customers working in different industries by joining both tables.

select nc.job_industry_category, avg(ca.property_valuation) as avg_property_valuation
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
group by nc.job_industry_category;


-- This query identifies the top customers for bike-related purchases within each job title.

select nc.job_title, nc.first_name, nc.last_name, nc.past_3_years_bike_related_purchases
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
order by nc.past_3_years_bike_related_purchases desc
limit 10;

-- This query identifies affluent customers (customers classified under “Affluent Customer” in wealth_segment) from a particular state who have made significant bike-related purchases.

select nc.first_name, nc.last_name, nc.wealth_segment, ca.state, nc.past_3_years_bike_related_purchases
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
where nc.wealth_segment = 'Affluent Customer'
and ca.state = 'NSW'
and nc.past_3_years_bike_related_purchases > 20;


-- This query ranks states based on the number of bike-related purchases made by customers in those states.

select ca.state, sum(nc.past_3_years_bike_related_purchases) as total_bike_purchases
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
group by ca.state
order by total_bike_purchases desc
limit 5;


-- This query identifies deceased customers from specific states by checking the deceased_indicator.

select nc.first_name, nc.last_name, ca.state
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
where nc.deceased_indicator = 'Y'
and ca.state in ('NSW', 'VIC', 'QLD');


-- This query filters customers working in the financial services industry and with high property valuations.

select nc.first_name, nc.last_name, nc.job_title, ca.property_valuation
from cust_address ca
inner join newcustomer nc
on ca.address = nc.address
and ca.postcode = nc.postcode
and ca.state = nc.state
and ca.country = nc.country
where nc.job_industry_category = 'Financial Services'
and ca.property_valuation > 8;