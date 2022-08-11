# RSQL-and-Dashbord-an-AWS
In this project a Database is created on AWS RDS. The used datas are from the fictional Nothwind dataset from Micrisoft. After this on AWS EC2 was Metabase installed and connected to the database. The csv files are in the northind folder.
In northwind.sql are the instructions to install the database.
```bash
psql -f northwind.sql -h "host" -U "User" -W "password" -p 5432
```
creates the Database on the "host" (AWS host) system with Postgres "User" (AWS unser) and the "Password" (AWS pasword).  
In Metabase.sql are some queries for the Dashbord. For example the query
```sql
-- World map sales
SELECT cc.code, SUM(od.unitprice * od.quantity *(1-od.discount)) AS "Sales"
FROM orders AS o
LEFT JOIN country_codes AS cc
ON o.shipcountry = cc.country
LEFT JOIN order_details AS od
ON od.orderid = o.orderid
GROUP BY cc.code;
```
can be used to visualises the salery on the Metabase world map.

__This porject is stoped in case of costs from AWS.__