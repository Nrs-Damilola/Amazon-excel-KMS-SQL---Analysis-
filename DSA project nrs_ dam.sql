create database dammy_db


Select * from [dbo].[KMS Sql Case Study]

select * from [dbo].[Order_Status]

------JOIN TABLES------ AND CREATING VIEW-------

Create view KMS_ORDER
		AS
SELECT  [dbo].[KMS Sql Case Study].ORDER_ID,
       [KMS Sql Case Study].Order_Quantity,
	   [KMS Sql Case Study].Unit_Price,
	   [KMS Sql Case Study].Discount,
	   [KMS Sql Case Study].Product_Base_Margin,
        [KMS Sql Case Study].Order_Date,
		[KMS Sql Case Study].Ship_Date,
		[KMS Sql Case Study].Customer_Name,
		[KMS Sql Case Study].Customer_Segment,
		[KMS Sql Case Study].Province,
		[KMS Sql Case Study].Region,
		[KMS Sql Case Study].Order_Priority,
		[KMS Sql Case Study].Sales,
		[KMS Sql Case Study].Profit,
		[KMS Sql Case Study].Ship_Mode,
		[KMS Sql Case Study].Shipping_Cost,
	    [KMS Sql Case Study].Product_Container,
		[KMS Sql Case Study].Product_Category,
		[KMS Sql Case Study].Product_Sub_Category,
		[KMS Sql Case Study].Product_Name,
		[dbo].[Order_Status].[Status]
		from [KMS Sql Case Study]
		JOIN [dbo].[Order_Status]
		On[dbo].[Order_Status].Order_Id=[KMS Sql Case Study].Order_ID
		

		SELECT * FROM KMS_ORDER


		UPDATE [dbo].[KMS_ORDER]
SET [Product_Base_Margin] = COALESCE([Product_Base_Margin], 0.00)
WHERE [Product_Base_Margin] IS NULL

---Question 1: Which product category had the highest sales?
		
----answer----
-----HIGHEST PRODUCT CATEGORY-----

select top 1 Product_Category,
sum(sales) As total_sales
from  KMS_ORDER
GROUP BY Product_Category
ORDER BY total_sales DESC

---Answer: Product Category = (Technology) --- Sales = $605,426.04

-----Select View------
Select * From KMS_ORDER


----Question 2: What are the top 3 and bottom 3 regions in terms of sales------

------answer-----
-----TOP 3 and BOTTTOM 3 REGION IN TERMS OF SALES---

--Top 3

Select top 3 Region,
sum(sales) As Total_sales
from KMS_ORDER
group by region
order by total_sales desc

 ----Top 3 Regions; Ontario = $471,161.63, West = $375,122.37, Prarie = $296,732.24
 
 --Bottom 3

SELECT top 3 Region,
MIN(SALES) AS Total_sales
from KMS_ORDER
group by region
order by total_sales desc
----Nunavut $228.41, Northwest Territories $35.17, Quebec $16.35----

-----Select View------
Select * From KMS_ORDER


----Question 3: What were the total sales of appliances in Ontario?

-------answer------
------TOTAL SALES OF APPLIANCES IN ONTARIO-----

SELECT Region,
    SUM(Sales) AS Total_Sales
FROM KMS_ORDER
WHERE Region = 'Ontario'
  And Product_Sub_Category = 'appliances'
Group By Region

---Total sale of appliances in Ontario is $17648.37

-----Select View------
Select * From KMS_ORDER

----- Question 4: Advise the management of KMS on what to do to increase the revenue from the bottom 10 customer

Select Top 10
      Customer_Name,
	  Sum(Sales) As Total_Revenue
From KMS_ORDER
Group by Customer_Name
Order by Total_Revenue Asc

---Answer: MY ADVISE TO THE MANAGEMENT OF KMS................
--will be to create a targeted discounts for these customers to make more purchase or upgrade their services

--------- BOTTOM 10 CUSTOMERS-----------------------
--Customer Name          Total Sales

--John Grady       =     $5.06
--Frank Atkinson   =     $10.48
--Sean Wendt       =     $12.80
--Sandra Glassco   =     $16.24
--Katherine Hughes =     $17.77 
--Bobby Elias      =     $22.56
--Noel Staavos     =     $24.91
--Thomas Boland    =     $28.01
--Brad Eason       =     $43.17
--Theresa Swint    =     $38.51

-----Select View------
Select * From KMS_ORDER

---Question 5: KMS incurred the most shipping cost using which shipping method?
---answer

Select Top 1
      Order_Priority, Ship_Mode,
	  Sum(Shipping_Cost) As Total_Cost
From KMS_ORDER
Group by Order_Priority, Ship_Mode
Order by Total_Cost Desc

----Order_Priority = (Low) / Shiping Method = Delevery Struck / Shipping Cost = $1,659.14

-----Select View------
Select * From KMS_ORDER

---Question 6: Who are the most valuable customers, and what products or services do they typically purchase?
----ANSWER

WITH CustomerRevenue AS (
    SELECT
        Customer_Name,
        Customer_Segment,
        SUM(Sales) AS Total_Revenue
    FROM KMS_ORDER
    GROUP BY Customer_Name, Customer_Segment
),
CustomerProductRevenue AS (
    SELECT 
        Customer_Name,
        Product_Name,
		Order_Quantity,
        SUM(Sales) AS Product_Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_Name 
            ORDER BY SUM(Sales) DESC, Product_Name DESC
        ) AS Product_Rank
    FROM KMS_ORDER
    GROUP BY Customer_Name, Product_Name, Order_Quantity
)
SELECT TOP 5
    cr.Customer_Name,
    cr.Customer_Segment,
    cpr.Product_Name AS Top_Product,
	cpr.Order_Quantity,
    cr.Total_Revenue
FROM CustomerRevenue cr
JOIN CustomerProductRevenue cpr 
    ON cr.Customer_Name = cpr.Customer_Name 
    AND cpr.Product_Rank = 1
ORDER BY cr.Total_Revenue DESC


---These are the Top 5 valuable customers, and their purchased product (top product that are being purchased are as follow:

------Customer_Name       Customer_Segment    Top_Product																	Order_Quantity           Total_Revenue              

---1---John Lucas          Small Business      Chromcraft Bull-Nose Wood 48" x 96" Rectangular Conference Tables				42					 $37,919.43
---2---Lycoris Saunders    Corporate           Bretford CR8500 Series Meeting Room Furniture				                   	45					 $30,948.18
---3---Grant Carroll	   Small Business	   Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind		18					 $26,485.12
---4---Erin Creighton	   Corporate	       Polycom VoiceStation 100															24					 $26,443.02
---5---Peter Fuller	       Corporate	       Panasonic KX-P3626 Dot Matrix Printer

-----Select View------
Select * From KMS_ORDER


---Question 7: Which (Small business customer) had the highest sales?

WITH CustomerRevenue AS (
    SELECT 
        Customer_Name,
        Customer_Segment,
        SUM(Sales) AS Total_Revenue
    FROM KMS_ORDER
	Where Customer_Segment = 'Small Business'
    GROUP BY Customer_Name, Customer_Segment
),
CustomerProductRevenue AS (
    SELECT 
        Customer_Name,
        Product_Name,
		Order_Quantity,
        SUM(Sales) AS Product_Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_Name 
            ORDER BY SUM(Sales) DESC, Product_Name DESC
        ) AS Product_Rank
    FROM KMS_ORDER
    GROUP BY Customer_Name, Product_Name, Order_Quantity
)
SELECT TOP 1
    cr.Customer_Name,
    cr.Customer_Segment,
    cpr.Product_Name AS Top_Product,
	cpr.Order_Quantity,
    cr.Total_Revenue
FROM CustomerRevenue cr
JOIN CustomerProductRevenue cpr 
    ON cr.Customer_Name = cpr.Customer_Name 
    AND cpr.Product_Rank = 1
ORDER BY cr.Total_Revenue DESC


-------The Custormer_Segment = (Small Business) / Customer_Name = (John Lucas) / Total_Revenue = $37,91943

-----Select View------
Select * From KMS_ORDER


----Question 8: Which (Corporate Customer) placed the most (number of orders) in (2009 – 2012)?

-----answer

SELECT TOP 1
   Customer_Segment, Customer_Name,
    SUM(Order_Quantity) AS Total_Orders
FROM KMS_ORDER
WHERE Customer_Segment = 'Corporate'
    AND Ship_Date BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY Customer_Segment, Customer_Name
ORDER BY Total_Orders DESC

--- The corporate customer with the most placed order in 2009 - 2012 Is;; Customer_Name = Erin Creighton Customer, Total_Orders = 261

-----Select View------
Select * From KMS_ORDER

---Question 9: Which (Consumer customer) was the (most profitable one)?
----answer

SELECT TOP 1
    Customer_Segment, Customer_Name,
    SUM(Sales) AS Total_Revenue
FROM KMS_ORDER
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Segment, Customer_Name
ORDER BY Total_Revenue Desc

---Answer: The most profitable (Consumer Customer); Customer_Name = Darren Budd / Profitability = $23,034.35

-----Select View------
Select * From KMS_ORDER

---Question 10: Which customer returned items? And what segment do they belong to?
----answer

SELECT TOP 872
   Customer_Name, Customer_Segment,
    max([Status]) AS Total_Returned_Items
FROM KMS_ORDER
GROUP BY Customer_Segment, Customer_Name, [Status]
ORDER BY Total_Returned_Items Desc


----All customers returned their items, and they belong to the customer_segement-------

-----Select View------
Select * From KMS_ORDER

-----Question 11---If the delivery truck is the most economical but the slowest shipping method and 
---Express Air is the fastest but the most expensive one, do you think the company 
---appropriately spent shipping costs based on the Order Priority? (Explain your answer)
---answer


-------------Based on Order Priority				Ship Mode					Total Cost

---------		Low									Delivery Truck				$1,659.14
---------		High								Delivery Truck				$1,274.98
---------		Not	Specified						Delivery Truck				$1,040.76
---------		Medium								Delivery Truck				$925.25
--------		Critical							Delivery Truck				$829.01
--------		Low									Express Air					$289.95
--------		Not	Specified						Express Air					$257.40
--------		Critical							Express Air					$195.19
--------		Medium								Express Air					$167.27
--------		High								Express Air					$108.92

------Was shipping cost appropriately spent based on Order Priority?
----a- Appropriate spending depends on matching high-priority orders with fast (Express Air) shipping and low-priority orders with economical (Delivery Truck) methods.
----b- If there are mismatches (e.g., urgent items shipped via Delivery Truck), the spending is inappropriate.
----c- A proper audit of the data would confirm alignment.