-- Q1: List 10 orders
select OrderNumber, OrderDate, CustomerId, CONCAT(firstname, ' ', lastname) as Customer_name, TotalAmount
from Orders as o join Customers as c on o.CustomerId = c.Id
limit 10;

-- Q2: Identify the customer who placed the order with the highest total amount.
select c.*, o.OrderNumber, o.OrderDate, o.TotalAmount
from Customers as c join Orders as o on o.CustomerId = c.Id
where o.TotalAmount = (select MAX(TotalAmount) from Orders);

-- Q3: List 10 customers who placed orders with the highest total amount.
with temp as 
(
select CustomerID, sum(TotalAmount) as total 
from Orders 
group by CustomerId 
order by total DESC 
)

select c.Id, concat(c.firstname, ' ',c.lastname), temp.total
from Customers as c join temp on c.Id = temp.CustomerID
order by temp.total DESC
limit 10;

-- Q4: List the products supplied by companies in the U.S.
select p.ProductName,s.CompanyName, s.ContactName, s.City
from Products as p join Suppliers as s on p.SupplierId = s.Id
where s.Country = "USA";

-- CTE
with temp as 
(
	select * from Suppliers
    where Country = "USA"
)
select p.ProductName,t.CompanyName, t.ContactName, t.City
from Products as p join temp as t on p.SupplierId = t.Id;

-- Q5: Count the number of products from each supplier
with temp as 
(
	select supplierId, count(supplierId) as total
    from Products
    group by SupplierId
    order by total DESC
)
select concat(s.CompanyName, " - ", s.ContactName), t.total
from Suppliers as s join temp as t on s.Id = t.supplierId;

-- Q6: List orders and order details
-- Method 1
select o.OrderNumber, o.OrderDate, o.TotalAmount, 
		i.ProductId, i.Quantity, i.UnitPrice, (i.Quantity * i.UnitPrice) as Money,
		c.FirstName, c.Lastname
from Orders as o join OrderItems as i on o.Id = i.OrderId
				join Customers as c on o.CustomerId = c.Id
order by o.OrderNumber, Money DESC;
            
-- Method 2
select o.OrderNumber, o.OrderDate, o.TotalAmount, 
       i.ProductId, i.Quantity, i.UnitPrice, i.Money,
       c.FirstName, c.Lastname
from Orders as o 
join (
    select 
        i.OrderId, i.ProductId, i.Quantity, i.UnitPrice, 
        (i.Quantity * i.UnitPrice) as Money
    from OrderItems as i
    order by Money DESC
) as i on o.Id = i.OrderId
join Customers as c on o.CustomerId = c.Id
order by o.OrderNumber, i.Money DESC;

-- Q7: List the top 10 orders with the highest total amounts placed by customers in Germany.
select o.OrderNumber, o.OrderDate, o.TotalAmount, c.FirstName, c.LastName
from Orders as o join Customers as c on o.CustomerId = c.Id
where c.Country = "Germany"
order by o.TotalAmount DESC
limit 10;

-- Q8: In 2012, identify the orders with the highest total amount for each month.
-- Method 1
with monthly_max as (
    select *,
           rank() over (partition by month(OrderDate) 
                        order by TotalAmount DESC) as rk
    from Orders
    where year(OrderDate) = 2012
)

select Id, OrderDate, OrderNumber, TotalAmount, CustomerId
from monthly_max
where rk = 1
order by OrderDate;

-- Mehtod 2
with month_max as 
(
	select *, 
			row_number() over(partition by month(OrderDate) order by TotalAmount DESC) as num_row
    from Orders
    where year(OrderDate) = 2012
)

select Id, OrderDate, OrderNumber, CustomerId, TotalAmount
from month_max
where num_row = 1
order by OrderDate;

