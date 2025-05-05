Use [Gold Analysis 1];

SELECT * 
FROM [Gold Analysis 1].[dbo].[gold.fact_sales]


-- 1)
Select	order_date,
	    Sum(sales_amount) As Total_Sales,
	    SUM(quantity) As Total_quantity,
	    count(DISTINCT(customer_key)) As CountOFCustomers
from dbo.[fact]
Where order_date Is Not Null
Group By order_date
-- Having order_date Is Not Null
Order By order_date;



-- 2)
Select	Year(order_date) As Year,
		Month(order_date) As Month, 
	    Sum(sales_amount) As Total_Sales,
	    SUM(quantity) As Total_quantity,
	    count(DISTINCT(customer_key)) As CountOFCustomers
from dbo.[fact]
Where order_date Is Not Null
Group By Year(order_date), Month(order_date)
-- Having order_date Is Not Null
Order By Year(order_date), Month(order_date);



-- 3)
SELECT DATEADD(month, DATEDIFF(month, 0, order_date), 0) AS TruncatedToMonth, -- such as DATETRUNC Focus on Sequence of Month and Year Without Focus on Days
--	   Year(order_date) As Year,
--	   Month(order_date) As Month,
	   SUM(sales_amount) AS Total_Sales,
       SUM(quantity) AS Total_Quantity,
       COUNT(DISTINCT customer_key) AS CountOfCustomers
FROM dbo.[fact]
WHERE order_date IS NOT NULL
GROUP BY DATEADD(month, DATEDIFF(month, 0, order_date), 0)
-- Having order_date Is Not Null
ORDER BY TruncatedToMonth;



-- 4)
SELECT DATEADD(Year, DATEDIFF(Year, 0, order_date), 0) AS TruncatedToYear, -- such as DATETRUNC Focus on Sequence of Year Without Focus on Month and Days 
--	   Year(order_date) As Year,
--	   Month(order_date) As Month,
	   SUM(sales_amount) AS Total_Sales,
       SUM(quantity) AS Total_Quantity,
       COUNT(DISTINCT customer_key) AS CountOfCustomers
FROM dbo.[fact]
WHERE order_date IS NOT NULL
GROUP BY DATEADD(Year, DATEDIFF(Year, 0, order_date), 0)
-- Having order_date Is Not Null
ORDER BY TruncatedToYear;



-- 5)
select TruncatedToMonth,
	   Total_Sales,
	   SUM(Total_Sales) over(ORDER BY TruncatedToMonth) As Runing_Sales -- Add old date to New date to get Total sales From start till Now
from
(
SELECT DATEADD(month, DATEDIFF(month, 0, order_date), 0) AS TruncatedToMonth, -- such as DATETRUNC Focus on Sequence of Month and Year Without Focus on Days
--	   Year(order_date) As Year,
--	   Month(order_date) As Month,
	   SUM(sales_amount) AS Total_Sales,
       SUM(quantity) AS Total_Quantity,
       COUNT(DISTINCT customer_key) AS CountOfCustomers
FROM dbo.[fact]
WHERE order_date IS NOT NULL
GROUP BY DATEADD(month, DATEDIFF(month, 0, order_date), 0)
-- Having order_date Is Not Null
) t



-- 6)
select TruncatedToMonth,
	   Total_Sales,
	   SUM(Total_Sales) over(ORDER BY TruncatedToMonth) As Runing_Sales,
	   SUM(Total_Sales) over(Partition By Year(TruncatedToMonth) ORDER BY TruncatedToMonth) As Runing_Sales_Yearly  -- Add old date to New date to get Total sales From start till Now to each year
from
(
SELECT DATEADD(month, DATEDIFF(month, 0, order_date), 0) AS TruncatedToMonth, -- such as DATETRUNC Focus on Sequence of Month and Year Without Focus on Days
--	   Year(order_date) As Year,
--	   Month(order_date) As Month,
	   SUM(sales_amount) AS Total_Sales,
       SUM(quantity) AS Total_Quantity,
       COUNT(DISTINCT customer_key) AS CountOfCustomers
FROM dbo.[fact]
WHERE order_date IS NOT NULL
GROUP BY DATEADD(month, DATEDIFF(month, 0, order_date), 0)
-- Having order_date Is Not Null
) t