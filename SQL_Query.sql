-- Homework 3
-- Jenny Yi Ran Wang 

-- Question One 

select country, count(customerid) as number_of_customers
from customers
group by country
order by 2 desc
limit(5)
-- top 5 countries with highest # of customers

-- Question Two

select c.categoryname, count(p.categoryid) as totalproducts
from categories c
join products p 
on p.categoryid = c.categoryid
group by c.categoryname;
-- total # of products in each category


-- Question Three 

select productid, productname
from products
where unitsinstock + unitsonorder <= reorderlevel
and discontinued = 0;
-- find units that need to be reordered (not discontinued)

-- Question Four 

select date_part('year', o.shippeddate) ship_year, count(*) total
from orders o
join shippers s
on o.shipvia = s.shipperid
where date_part('year', o.shippeddate) = '1997'  -- year 1997
and s.companyname = 'United Package' -- only by UP
group by date_part('year', o.shippeddate);
-- find total amount shipped 

-- Question Five 

select shipcountry, avg(o.freight) as freight_avg
from orders o 
where date_part('year', shippeddate) = '1996'  -- year 1996
group by o.shipcountry -- find the countries
order by freight_avg desc -- order by avg freight
limit(3);

-- Question Six 

with q6 as (
	select e.lastname, e.firstname, count(*) totalorders -- find employees with late orders
	from orders o 
	join employees e 
	on o.employeeid = e.employeeid
	where o.requireddate <= o.shippeddate -- where already required and not yet shipped 
	group by e.lastname, e.firstname
)
select lastname, firstname, totalorders
from q6
where totalorders >=5 -- find more than 5 late orders

-- Question Seven
select c.companyname, q7.orderid, q7.unitprice * q7.quantity total_amt_ordered
from(
	select o.orderid, o.customerid, od.unitprice, od.quantity
	from orders o
	join orderdetails od 
	on o.orderid = od.orderid
	where od.quantity*od.unitprice >= 10000 -- VIP members over $10,000
	and date_part('year', o.shippeddate) = '1996' -- only in year 1996
)q7
join customers c
on q7.customerid = c.customerid;
-- find companies who ordered over $10k in 1996
