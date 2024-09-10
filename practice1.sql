-- Q1: List the customers who have never placed an order
select * from Customers
where id not in (select CustomerId from Orders);

-- Q2: Identify the customer of the order with the highest total amount
select * from customers
where id = (select CustomerId from Orders 
			where TotalAmount = (select max(TotalAmount) from Orders));

-- Q3: List the products that have never been ordered.
select * 
from Products
where id not in (select ProductId from OrderItems);

-- Q4: List the orders with the highest and lowest total amounts.
select * 
from Orders
where TotalAmount = ( select max(TotalAmount) from Orders) or
	 TotalAmount =  (select min(TotalAmount) from Orders);
     
-- Q5: List the orders placed in 2014 with a total amount less than the average total amount for orders in 2014.
select *
from Orders 
where TotalAmount < (select avg(TotalAmount)
					from Orders
                    where YEAR(OrderDate) = 2014)
AND YEAR(OrderDate) = 2014
order by TotalAmount DESC
limit 10;

-- Q6: List the products that were ordered on Sundays and are currently discontinued.
select *
from Products
where IsDiscontinued = 1 
and id in ( select ProductId from OrderItems
			where OrderId in (select id from Orders where WEEKDAY(OrderDate) = 6))
order by Id;