
DROP DATABASE IF EXISTS northwind;
CREATE DATABASE northwind;

\c northwind

CREATE TABLE country_codes(country VARCHAR(80),
  code VARCHAR(2));
  \copy country_codes (country,code) FROM './northwind/northwind_data_clean-master/data/country_code_2.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE categories(categoryID SERIAL PRIMARY KEY,
  categoryName VARCHAR(255) NOT NULL,
  description VARCHAR(255) ,
  picture VARCHAR(500));
\copy categories (categoryID,categoryName,description,picture) FROM './northwind/northwind_data_clean-master/data/categories.csv' DELIMITER ',' CSV HEADER;
-- SELECT * FROM categories;

CREATE TABLE customers(customerID VARCHAR(10) PRIMARY KEY,
  companyName VARCHAR(50) NOT NULL,
  contactName VARCHAR(50) NOT NULL,
  contactTitle VARCHAR(50) ,
  address VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  region VARCHAR(50) NOT NULL,
  postalCode VARCHAR(10) NOT NULL,
  country VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  fax VARCHAR(20));
\copy customers (customerID,companyName,contactName,contactTitle,address,city,region,postalCode,country,phone,fax) FROM './northwind/northwind_data_clean-master/data/customers.csv' DELIMITER ',' CSV HEADER;
-- SELECT * FROM customers;

CREATE TABLE regions(regionID SERIAL PRIMARY KEY,
  regionDescription VARCHAR(20) NOT NULL);
\copy regions(regionID,regionDescription) FROM './northwind/northwind_data_clean-master/data/regions.csv' DELIMITER ',' CSV HEADER;
--SELECT * FROM regions;

CREATE TABLE shippers(shipperID SERIAL PRIMARY KEY,
  companyName VARCHAR(20) NOT NULL,
  phone VARCHAR(20) NOT NULL);
\copy shippers(shipperID,companyName,phone) FROM './northwind/northwind_data_clean-master/data/shippers.csv' DELIMITER ',' CSV HEADER;
--SELECT * FROM shippers;

CREATE TABLE employees(employeeID SERIAL PRIMARY KEY,
  lastName VARCHAR(50) NOT NULL,
  firstName VARCHAR(50) NOT NULL,
  title VARCHAR(50) NOT NULL,
  titleOfCourtesy VARCHAR(50) NOT NULL,
  birthDate TIMESTAMP NOT NULL,
  hireDate TIMESTAMP NOT NULL,
  address VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  region VARCHAR(50)NOT NULL,
  postalCode VARCHAR(10) NOT NULL,
  country VARCHAR(50) NOT NULL,
  homePhone VARCHAR(50) NOT NULL,
  extension INT,
  photo VARCHAR(500),
  notes VARCHAR(255),
  reportsTo VARCHAR(10) NOT NULL,
  photoPath VARCHAR(100));
\copy employees (employeeID,lastName,firstName,title,titleOfCourtesy,birthDate,hireDate,address,city,region,postalCode,country,homePhone,extension,photo,notes,reportsTo,photoPath) FROM './northwind/northwind_data_clean-master/data/employees.csv' DELIMITER ',' CSV HEADER;
-- SELECT * FROM employees;

CREATE TABLE territories(territoryID SERIAL PRIMARY KEY,
  territoryDescription VARCHAR(50),
  regionID INT);
\copy territories(territoryID,territoryDescription,regionID) FROM './northwind/northwind_data_clean-master/data/territories.csv' DELIMITER ',' CSV HEADER;
--SELECT * FROM territories;

CREATE TABLE employee_territories(employeeID INT NOT NULL,
  territoryID INT NOT NULL,
  FOREIGN KEY(employeeID)
  REFERENCES employees(employeeID) ON DELETE CASCADE,
  FOREIGN KEY(territoryID)
  REFERENCES territories(territoryID) ON DELETE CASCADE
);
\copy employee_territories (employeeID,territoryID) FROM './northwind/northwind_data_clean-master/data/employee_territories.csv' DELIMITER ',' CSV HEADER;
--SELECT * FROM employee_territories;

CREATE TABLE suppliers(supplierID SERIAL PRIMARY KEY,
  companyName VARCHAR(50) NOT NULL,
  contactName VARCHAR(50) NOT NULL,
  contactTitle VARCHAR(50) NOT NULL,
  address VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  region VARCHAR(50) NOT NULL,
  postalCode VARCHAR(10) NOT NULL,
  country VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  fax VARCHAR(20),
  homePage VARCHAR(255)
);
\copy suppliers (supplierID,companyName,contactName,contactTitle,address,city,region,postalCode,country,phone,fax,homePage) FROM './northwind/northwind_data_clean-master/data/suppliers.csv' DELIMITER ',' CSV HEADER;
-- SELECT * FROM suppliers;

CREATE TABLE products(productID SERIAL PRIMARY KEY,
  productName VARCHAR(50) NOT NULL,
  supplierID INT NOT NULL,
  categoryID INT NOT NULL,
  quantityPerUnit VARCHAR(50),
  unitPrice FLOAT NOT NULL,
  unitsInStock INT,
  unitsOnOrder INT,
  reorderLevel INT,
  discontinued INT,
  FOREIGN KEY(supplierID)
  REFERENCES suppliers(supplierID) ON DELETE CASCADE,
  FOREIGN KEY(categoryID)
  REFERENCES categories(categoryID) ON DELETE CASCADE
);
\copy products(productID,productName,supplierID,categoryID,quantityPerUnit,unitPrice,unitsInStock,unitsOnOrder,reorderLevel,discontinued) FROM './northwind/northwind_data_clean-master/data/products.csv' DELIMITER ',' CSV HEADER;
--SELECT * FROM products;

CREATE TABLE orders(orderID SERIAL PRIMARY KEY,
  customerID VARCHAR(10) NOT NULL,
  employeeID INT NOT NULL,
  orderDate TIMESTAMP NOT NULL,
  requiredDate TIMESTAMP NOT NULL,
  shippedDate TIMESTAMP,
  shipVia INT NOT NULL,
  freight FLOAT,
  shipName VARCHAR(50),
  shipAddress VARCHAR(50) NOT NULL,
  shipCity VARCHAR(30) NOT NULL,
  shipRegion VARCHAR(30),
  shipPostalCode VARCHAR(10),
  shipCountry VARCHAR(30) NOT NULL,
  FOREIGN KEY(customerID)
  REFERENCES customers(customerID) ON DELETE CASCADE,
  FOREIGN KEY(employeeID)
  REFERENCES employees(employeeID) ON DELETE CASCADE
);
\copy orders(orderID,customerID,employeeID,orderDate,requiredDate,shippedDate,shipVia,freight,shipName,shipAddress,shipCity,shipRegion,shipPostalCode,shipCountry) from './northwind/northwind_data_clean-master/data/orders.csv' DELIMITER ',' CSV HEADER NULL AS 'NULL';
--SELECT * FROM orders;

CREATE TABLE order_details(orderID INT  NOT NULL,
  productID INT NOT NULL,
  unitPrice FLOAT NOT NULL,
  quantity INT NOT NULL,
  discount FLOAT NOT NULL,
  FOREIGN KEY(orderID)
  REFERENCES orders(orderID) ON DELETE CASCADE,
  FOREIGN KEY(productID)
  REFERENCES products(productID) ON DELETE CASCADE
);
\copy order_details (orderID,productID,unitPrice,quantity,discount) FROM './northwind/northwind_data_clean-master/data/order_details.csv' DELIMITER ',' CSV HEADER;
