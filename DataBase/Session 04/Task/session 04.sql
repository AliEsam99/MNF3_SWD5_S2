use StoreDB

--1
select COUNT(*) As [Number Of Products]
from [production].[products]


--2
select MIN(list_price)AS Min_Price,MAX(list_price)As Max_Price,AVG(list_price)As Avg_Price
from [production].[products]


--3
select COUNT(*)AS [Number Of Products],category_id
from [production].[products]
Group By category_id
Order By category_id


--4
select COUNT(*)As [Total Numbers],store_id
from [sales].[orders]
Group By store_id
Order By store_id


--5
select Top 10 UPPER(first_name)As [First Name] , LOWER(last_name)As [Last Name]
from [sales].[customers]


--6
select top 10 LEN(product_name) As [Length Product], product_name
from [production].[products]


--7
select LEFT(phone , 3) AS [first 3 digits]
from [sales].[customers]
where customer_id Between 1 and 15

--8
select order_date , YEAR(order_date) As Year ,MONTH(order_date)As Month
from [sales].[orders]
where order_id Between 1 and 10

--9
select Top 10 PP.product_name ,PC.category_name
from [production].[products] PP , [production].[categories] PC
where PP.category_id = Pc.category_id


--10
select Top 10 (SC.first_name + ' ' + SC.last_name)As [Full Name] , SO.order_date
from [sales].[customers] SC ,[sales].[orders] SO
where SC.customer_id = SO.customer_id


--11
select PP.product_name , ISNULL(PB.brand_name,'No Brand') As [Brand Name]
from [production].[products] PP , [production].[brands] PB
where PP.brand_id = PB.brand_id


--12
select product_name,list_price 
from [production].[products]
Where list_price > (select AVG(list_price)
					from [production].[products])

--13
select customer_id, (first_name + ' ' + last_name) As [Full Name]
from [sales].[customers]
where Exists (select SC.first_name , SC.customer_id
		  from [sales].[customers] SC , [sales].[orders] SO , [sales].[order_items] SI
		  where SC.customer_id = SO.customer_id and SO.order_id = SI.order_id and quantity > 1)

--14
select (first_name+ ' '+last_name)As [Full Name]
from [sales].[customers] 
where Exists (select Sc.customer_id ,COUNT(quantity) AS [Number Of Orders]  from [sales].[customers] Sc,[sales].[orders] SO ,[sales].[order_items] SI
			  where SC.customer_id = SO.customer_id and SO.order_id = SI.order_id
			  Group By Sc.customer_id)

Go
--15
Create View easy_product_list AS 
select PP.product_name , PC.category_name , PP.list_price
	from [production].[products] PP , [production].[categories] PC
	where PP.category_id =PC.category_id and list_price>100
Go
Select * from easy_product_list 

Go
--16
create View customer_info As 
Select customer_id,(first_name+' '+last_name) As [Full Name] , email, (city + ', ' + state) AS location
	from [sales].[customers]
	where state like 'CA'

Go
Select * From customer_info

Go

--17
select product_name ,list_price
from [production].[products]
where list_price between 50 and 200
order By list_price 

--18
select state ,COUNT(*) [Number Of customers]
from [sales].[customers]
Group By state
Order By state Desc

--19
select Top 1 PP.product_name , PC.category_name ,PP.list_price
from [production].[products] PP , [production].[categories] PC
where PP.category_id =PC.category_id
Order By list_price Desc

--20
select SS.store_name ,SS.city , COUNT(*) as [Number Of Orders]
from [sales].[stores]SS, [sales].[orders]SO
where SS.store_id=SO.store_id
Group By SS.store_name ,SS.city