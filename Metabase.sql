-- 	1. Get the names and the quantities in stock for each product
SELECT productname,unitsinstock FROM products;

--	2. Get a list of current products (Product ID and name).
SELECT productid AS porductnumber,productname AS product FROM products;

-- 3. Get a list of the most and least expensive products
SELECT productname ,unitprice FROM products
WHERE (unitprice = (SELECT MAX(unitprice) FROM products))
   OR (unitprice = (SELECT MIN(unitprice) FROM products));

-- 4. Get products that cost less than $20
SELECT productname, unitprice FROM products WHERE unitprice <= 20;

-- 5. Get products that cost between $15 and $25
SELECT productname , unitprice FROM products
WHERE unitprice BETWEEN 15 AND 25;

-- 6. Get products above average price
SELECT productname , unitprice FROM products
WHERE unitprice > (SELECT AVG(unitprice) FROM products);

-- 7. Find the ten most expensive products
SELECT productname, unitprice FROM products
ORDER BY unitprice DESC LIMIT 10;

-- 8. Get a list of discontinued products
SELECT productid AS "ID", productname AS "Poduct",unitsinstock AS "In Stock"
FROM products WHERE discontinued = 1;

-- 9. Count current and discontinued products
SELECT discontinued, COUNT(productid) AS COUNT
FROM products GROUP BY discontinued;

-- 10. Find products with less units in stock than the quantity on order
SELECT o.orderid, p.productname, (od.quantity-p.unitsinstock) AS "Missing Units" FROM order_details AS od
RIGHT JOIN orders AS o
ON o.orderid = od.orderid
RIGHT JOIN products AS p
ON od.productid = p.productid
WHERE (o.shippeddate  IS NULL) AND (p.unitsinstock < od.quantity)
ORDER BY p.productname;

-- 11. Find the customer who had the highest order amount
SELECT c.companyname AS "Company", SUM(od.unitprice* od.quantity*(1-od.discount)) AS "Order Amount"
FROM orders AS o
RIGHT JOIN order_details AS od
ON od.orderID = o.orderID
RIGHT JOIN customers AS c
ON o.customerid = c.customerid
GROUP BY c.companyname
ORDER BY "Order Amount" DESC NULLS LAST
LIMIT 3
;

-- 12. Get orders for a given employee and the according customer
SELECT c.companyname ,(e.firstname,e.lastname), od.orderid, p.productname,od.quantity, od.unitprice,od.discount FROM orders AS o
RIGHT JOIN order_details AS od
ON o.orderid = od.orderid
RIGHT JOIN products AS p
ON od.productid = p.productid
RIGHT JOIN customers AS c
ON c.customerid = o.customerid
RIGHT JOIN employees AS e
ON e.employeeid = o.employeeid
WHERE (o.employeeid = 1) AND (o.customerid='ERNSH')
ORDER BY o.customerid;

-- 13. Find the hiring age of each employee
SELECT firstname, lastname,
EXTRACT (YEAR FROM AGE(hiredate,birthdate)) AS hireing_age
FROM employees ORDER BY hireing_age;


-- Sales by Coutry
SELECT o.shipcountry,
SUM(od.unitprice* od.quantity*(1-od.discount)) AS "SALES",
SUM(o.orderid)
FROM orders AS o
RIGHT JOIN order_details AS od
ON o.orderid =od.orderid
GROUP BY o.shipcountry;

-- Sales per product with discount
SELECT p.productname,
SUM(od.quantity*od.unitprice*(1-od.discount)) AS "Sales",
SUM(od.quantity*od.unitprice*(od.discount)) AS "Discount"
FROM products AS p
RIGHT JOIN order_details AS od
ON p.productID = od.productID
GROUP BY p.productname;

-- Sales per Weekday
SELECT DATE_PART('isodow',o.orderdate) AS "Weekday",
SUM(od.unitprice*od.quantity*(1-od.discount)) AS "Sales"
FROM orders AS o
LEFT JOIN order_details AS od
ON o.orderid = od.orderid
GROUP BY DATE_PART('isodow',o.orderdate);

-- Shipping sales per weekday
SELECT DATE_PART('isodow',o.shippeddate) AS "Weekday",
SUM(od.unitprice*od.quantity*(1-od.discount)) AS "Sales"
FROM orders AS o
LEFT JOIN order_details AS od
ON o.orderid = od.orderid
GROUP BY DATE_PART('isodow',o.shippeddate);

-- World map sales
SELECT cc.code, SUM(od.unitprice * od.quantity *(1-od.discount)) AS "Sales"
FROM orders AS o
LEFT JOIN country_codes AS cc
ON o.shipcountry = cc.country
LEFT JOIN order_details AS od
ON od.orderid = o.orderid
GROUP BY cc.code;
