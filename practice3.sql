-- Q1: List the orders and the largest total amount placed by each customer in 2023
with temp as
(
select customerid, Ordernumber, orderdate,totalamount, max(totalamount) over (partition by customerid) as max_
from Orders
where year(OrderDate) = 2013
order by customerid, totalamount
)

-- Q2: In 2013, list the customers with the highest total order amount.
select t.customerid, c.firstname, c.lastname,t.ordernumber, t.orderdate, t.totalamount
from temp as t join customers as c on t.customerid = c.id
where t.totalamount in (select max_ from temp);

-- Q3: In 2013, rank the orders in each month by total order amount in descending order.
with temp as 
(select ordernumber, month(orderdate) as month, totalamount, rank() over(partition by month(orderdate) order by totalamount DESC) as rk
from orders
where year(orderdate) = 2013
order by month(orderdate)
)
-- Q4: In 2013, list the top 3 orders with the highest total amount for each month.
select month, ordernumber, totalamount
from temp
where rk in (1,2,3);

-- Q5: In 2013, rank the products in each order of the customer with ID 10 by the quantity ordered in descending order.
with temp as 
(
select o.Ordernumber, p.productname, oi.quantity, rank() over(partition by o.ordernumber order by oi.quantity DESC) as rk
from orders o join orderitems oi on o.id = oi.orderid
				join products p on p.id = oi.productid
where o.customerid = 10 and year(o.Orderdate) = 2013
)

-- Q6: List the most ordered products in each order of the customer with ID 10 in 2013.
select ordernumber, productname, quantity
from temp
where rk = 1;


