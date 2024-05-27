create database if not exists salesDataWalmart;
use salesDataWalmart;

Create table if not exists sales(
	invoice_id varchar (30) not null primary key,
	branch varchar(5) not null,
    city varchar(30) not null,
    cuctomer_id varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,2) not null,
    Total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9),
    gross_income decimal(12,4) not null,
    rating float(2,1) 
);


-- --------------------------------------------------------------------------------------------------------------
-- -------------------------------------FEATURE ENGINEERING -----------------------------------------------------

-- ----- time_of_day

SELECT 
time,
(CASE
	WHEN `time`	BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
    ELSE "EVENING"
    END
) AS time_of_date
 FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales 
SET time_of_day = (
CASE
	WHEN `time`	BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
    ELSE "EVENING"
END
);


-- ---------------- day_name
SELECT 
date,
dayname(date)
 from sales;
 
 ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = dayname(date);

SELECT date , monthname(date) from sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
SET month_name = monthname(date);
-- ----------------------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------Generic------------------------------------------------------------------------------
-- ---------------------HOW MANY UNIUE CITIES DOES THE DATA HAVE?------------------------
SELECT DISTINCT city from sales; 


-- ---------------------IN WHICH CITY IS EACH BRANCH?------------------------------------
SELECT DISTINCT branch from sales;

SELECT DISTINCT city , branch from sales;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------PRODUCT------------------------------------------------------------------------

-- ------------------------------HOW MANY UNIQUE PRODUCT LINE DOES THE DATA HAVE? ----------------------------
SELECT COUNT(DISTINCT product_line) from sales;

-- ------------------------------MOST COMMON PAYMENT METHOD?--------------------------------------------------
SELECT payment_method, count(payment_method) as Cnt
from sales
GROUP BY payment_method
ORDER BY Cnt DESC;

-- ------------------------------WHAT IS THE MOST SELLING PRODUCT LINE?---------------------------------------
SELECT product_line, count(product_line) as Cnt
FROM sales
group by product_line
Order by Cnt DESC;

-- ------------------------------WHAT IS THE TOTAL REVENUE BY MONTH?--------------------------------------------------------
SELECT month_name as Month , sum(Total) as Total_Revenue
FROM sales
GROUP BY month_name
ORDER BY Total_Revenue desc;

-- ------------------------------WHAT MONTH HAVE THE LARGEST COGS?---------------------------------------------------------
SELECT month_name as Month , sum(cogs) As Cogs
FROM sales
Group by Month
Order by Cogs desc;

-- ------------------------------WHAT PRODUCT LINE HAS THE LARGEST REVENUE?------------------------------------------------
SELECT product_line, sum(Total) as total_Revenue
from sales 
Group by product_line
Order by total_Revenue desc;

--  ------------------------------WHAT CITY HAS THE LARGEST REVENUE?----------------------------------------------------==
SELECT city , branch , sum(Total) as total_Revenue
from sales 
Group by city , branch
Order by total_Revenue desc;

-- -------------------------------WHAT product line has the largest VAT?------------------------------------------------------
SELECT product_line , avg(VAT) as VAT_AVG
from sales 
Group by product_line
Order by VAT_AVG desc;

-- ------------------------Which branch sold more products than average product sold?-------------------------------------------

Select branch, sum(quantity) as qty
 from sales
 group by branch
 having sum(quantity)>(select avg(quantity) from sales);
 
 -- ------------------What is the most common product line by gender?----------------------------------------------------
 
 Select gender,product_line,COUNT(gender)
 from sales
 group by gender,product_line
 order by COUNT(gender);

-- -------------------------What is the average rating of each product line?---------------------------------------------------

Select product_line , Round(avg(rating) , 2) as AVG_RATING
from sales
group by product_line
order by AVG_RATING DESC;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------- SALES ------------------------------------------------------------------------------------

-- --------------------------Number of sales made in each time of the day per weekday?-------------------------------------------------------------

select time_of_day , count(*) as Tot_count
from sales
where day_name = "Sunday"
group by time_of_day
order by Tot_count desc;

-- --------------Which of the customer types brings the most revenue?----------------------------------------
select cuctomer_id , sum(total) as tot_revenue 
from sales
group by cuctomer_id
order by tot_revenue desc;

-- ------------------Which city has the largest tax percent/ VAT (Value Added Tax)?---------------------------------

select city , avg(VAT) as AVG_VAT
from sales
group by city
order by AVG_VAT desc;

-- --------------Which customer type pays the most in VAT?---------------------------------

select cuctomer_id , avg(VAT) as AVG_VAT
from sales
group by cuctomer_id
order by AVG_VAT desc;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------CUSTOMERS---------------------------------------------------------------------------------------

-- -----------------------How many unique customer types does the data have?---------------------------------

select distinct cuctomer_id from sales;

-- ----------------------How many unique payment methods does the data have?---------------------------------

select distinct payment_method from sales;

-- ----------------------Which customer type buys the most? --------------------------------

select cuctomer_id , count(*) as Most
from sales
group by cuctomer_id
order by Most desc;

-- ------------------------What is the gender of most of the customers?---------------------------

select gender , count(*) as Most
from sales
group by gender
order by Most desc;

-- ------------------------What is the gender distribution per branch?----------------------------

select gender,branch,count(gender) as gender_count
from sales
group by gender , branch
order by gender_count;

-- -------------------------Which time of the day do customers give most ratings?-------------------------------

select time_of_day  , avg(rating) as AVG_RATING
from sales
group by time_of_day
order by AVG_RATING desc;

-- ---------------------------Which time of the day do customers give most ratings per branch?---------------------------------------

select time_of_day , branch , avg(rating) as AVG_RATING
from sales
group by time_of_day , branch
order by AVG_RATING desc;

-- ---------------------------Which day fo the week has the best avg ratings?-----------------------------------------------------------

select day_name, avg(rating) as AVG_RATING
from sales
group by day_name
order by AVG_RATING desc;

-- -----------------------Which day of the week has the best average ratings per branch?--------------------------------------------------

select day_name , branch , avg(rating) as AVG_RATING
from sales
group by day_name , branch
order by AVG_RATING desc;
