Use [Gold Analysis 1];

SELECT * 
FROM dbo.[fact];

SELECT * 
FROM dbo.[products];


-- 1)
Select *
FROM fact f
left join products p
on f.product_key = p.product_key



-- 2)
Select  f.order_date,
		p.product_name,
		f.sales_amount
FROM fact f
left join products p
on f.product_key = p.product_key



-- 3)
Select  f.order_date,
		p.product_name,
		Sum(f.sales_amount) As Total_Sales
FROM fact f
left join products p
on f.product_key = p.product_key
Group By f.order_date , p.product_name



-- 4)
Select  Year(f.order_date) Years,
		p.product_name,
		Sum(f.sales_amount) As Total_Sales
FROM fact f
left join products p
on f.product_key = p.product_key
Where f.order_date Is Not Null
Group By Year(f.order_date) , p.product_name



-- 5)
With New_Table As (
Select  Year(f.order_date) Years,
		p.product_name,
		Sum(f.sales_amount) As Total_Sales
FROM fact f
left join products p
on f.product_key = p.product_key
Where f.order_date Is Not Null
Group By Year(f.order_date) , p.product_name
)

Select	Years,
		product_name,
		Total_Sales,
		AVG(Total_Sales) Over (partition by product_name) Avg_Sales
From New_Table



-- 6)
With New_Table As (
Select  Year(f.order_date) Years,
		p.product_name,
		Sum(f.sales_amount) As Total_Sales
FROM fact f
left join products p
on f.product_key = p.product_key
Where f.order_date Is Not Null
Group By Year(f.order_date) , p.product_name
)

Select	Years,
		product_name,
		Total_Sales,
		AVG(Total_Sales) Over (partition by product_name) Avg_Sales,
		Case
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) > 0 Then 'Above AVG'
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) < 0 Then 'Below AVG'
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) = 0 Then 'IN AVG'
		End Sales_Status
From New_Table



-- 7)
With New_Table As (
Select  Year(f.order_date) Years,
		p.product_name,
		Sum(f.sales_amount) As Total_Sales
FROM fact f
left join products p
on f.product_key = p.product_key
Where f.order_date Is Not Null
Group By Year(f.order_date) , p.product_name
)

Select	Years,
		product_name,
		Total_Sales,
		AVG(Total_Sales) Over (partition by product_name) Avg_Sales,
		Case
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) > 0 Then 'Above AVG'
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) < 0 Then 'Below AVG'
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) = 0 Then 'IN AVG'
		End Sales_Status,
		LAG(Total_Sales) Over (partition by product_name order by Years ) Yearly_Sales  -- LAG to get pervious Value of Total_Sales
																						-- partition by to Focus on each product_name alone
From New_Table



-- 8)
With New_Table As (
Select  Year(f.order_date) Years,
		p.product_name,
		Sum(f.sales_amount) As Total_Sales
FROM fact f
left join products p
on f.product_key = p.product_key
Where f.order_date Is Not Null
Group By Year(f.order_date) , p.product_name
)

Select	Years,
		product_name,
		Total_Sales,
		AVG(Total_Sales) Over (partition by product_name) Avg_Sales,
		Case
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) > 0 Then 'Above AVG'
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) < 0 Then 'Below AVG'
			When Total_Sales - 	AVG(Total_Sales) Over (partition by product_name) = 0 Then 'IN AVG'
		End Sales_Status,
		LAG(Total_Sales) Over (partition by product_name order by Years ) Yearly_Sales,  -- LAG to get pervious Value of Total_Sales
																						-- partition by to Focus on each product_name alone
		Case 
			When Total_Sales - 	LAG(Total_Sales) Over (partition by product_name order by Years ) > 0 Then 'Increase'
			When Total_Sales - 	LAG(Total_Sales) Over (partition by product_name order by Years ) < 0 Then 'Decrease'
			Else 'No Change'
		End Yearly_Progress
From New_Table