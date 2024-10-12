USE NORTHWND1

-- Mostrar los nombres de todos los productos que han sido vendidos 
-- en una orden de pedido (el id del customer, el id de la orden
-- y el nombre del producto)
Select c.CustomerID,o.OrderID, od.ProductID, p.ProductName, ca.CategoryName -- Seleccionar los campos a mostrar
from customers c -- Seleccionar la tabla customers
inner join Orders o -- Unir la tabla Orders
on c.CustomerID = o.CustomerID 
inner join OrderDetails od -- Unir la tabla OrderDetails
on o.OrderID = od.OrderID
inner join products p -- Unir la tabla products
on od.ProductID = p.ProductID
inner join categories ca -- Unir la tabla categories
on p.CategoryID = ca.CategoryID
order by c.CustomerID, o.OrderID -- Ordenar por CustomerID y OrderID

-- Para incluir a todos los vendedores en 
-- los resultados, independientemente de si 
-- estan asignados a un territorio de ventas
Select et.TerritoryID, e.EmployeeID -- Seleccionar los campos a mostrar
from EmployeeTerritories et -- Seleccionar la tabla EmployeeTerritories
right join Employees e -- Unir la tabla Employees independientemente de si estan asignados a un territorio
on et.EmployeeID = e.EmployeeID

-- Mostrar todos los productos
-- independientemente si estan 
-- asignados en una orden de pedido
Select p.ProductID, p.ProductName, od.OrderID -- Seleccionar los campos a mostrar
from Products p -- Seleccionar la tabla Products
left join OrderDetails od -- Unir la tabla OrderDetails
on p.ProductID = od.ProductID -- Unir por ProductID mostrando todos los productos independientemente si estan asignados en una orden de pedido
order by p.ProductID


--Ejercicio 4
--Por cada pais de procedencia del cliente, 
--indicar el nombre del pais
--y la cantidad de pedidos atendidos.
SELECT c.Country, COUNT (o.OrderID) Quantity
FROM Customers C JOIN Orders O 
ON C.CustomerID = O.CustomerID
GROUP BY Country
order by c.Country
-----------

-- Mostrar la cantdiad de pedidos atenediso por empelado, del empleado motrar el codigo, nombre y cantidad de pedidos
Select e.EmployeeID, e.FirstName, e.LastName, COUNT(o.OrderID) QuantityOrders -- Seleccionar los campos a mostrar
FROM Employees e -- Seleccionar la tabla Employees
inner join Orders o -- Unir la tabla Orders
on e.EmployeeID = o.EmployeeID -- Unir por EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName -- Agrupar por EmployeeID, FirstName y LastName
order by e.EmployeeID -- Ordenar por EmployeeID

--Ejercicio 3
--Por cada cliente, indicar el nombre del cliente, los nombres de los
--productos adquiridos
--y la cantidad de items por producto adquirido en total.
SELECT ContactName, ProductName, SUM(Quantity) as ItemsTotal -- Seleccionar los campos a mostrar
FROM Customers C -- Seleccionar la tabla Customers
JOIN Orders O ON C.CustomerId = O.CustomerID -- Unir la tabla Orders
JOIN OrderDetails OD ON O.OrderID = OD.OrderID -- Unir la tabla OrderDetails
JOIN Products P ON OD.ProductID = P.ProductID -- Unir la tabla Products
GROUP BY ContactName, ProductName -- Agrupar por ContactName y ProductName

--Ejercicio 8
--Indicar el nombre del proveedor con la menor cantidad de items de
--productos vendidos.
SELECT CompanyName, Total
FROM
   (SELECT s.CompanyName, SUM(Quantity) as Total
   FROM Products P
   JOIN OrderDetails OD ON P.ProductID = OD.ProductID
   JOIN Suppliers S ON P.SupplierID = S.SupplierID
   GROUP BY s.CompanyName) SQ
where Total = ( SELECT MIN(Total)
           FROM (SELECT s.CompanyName, SUM(Quantity) Total
           FROM Products P
           JOIN OrderDetails OD ON P.ProductID = OD.ProductID
           JOIN Suppliers S ON P.SupplierID = S.SupplierID
           GROUP BY s.CompanyName) SQ);


-- Ejercicio 9
-- Indicar el nombre del proveedor con la menor cantidad de items de
-- productos vendidos y el nombre del proveedor con la mayor cantidad de 4
-- items de productos vendidos

SELECT CompanyName, Total
FROM
   (SELECT s.CompanyName, SUM(Quantity) as Total
   FROM Products P
   JOIN OrderDetails OD ON P.ProductID = OD.ProductID
   JOIN Suppliers S ON P.SupplierID = S.SupplierID
   GROUP BY s.CompanyName) SQ
where Total = ( SELECT MIN(Total)
           FROM (SELECT s.CompanyName, SUM(Quantity) Total
           FROM Products P
           JOIN OrderDetails OD ON P.ProductID = OD.ProductID
           JOIN Suppliers S ON P.SupplierID = S.SupplierID
           GROUP BY s.CompanyName) SQ)
union
SELECT CompanyName, Total
FROM
   (SELECT s.CompanyName, SUM(Quantity) as Total
   FROM Products P
   JOIN OrderDetails OD ON P.ProductID = OD.ProductID
   JOIN Suppliers S ON P.SupplierID = S.SupplierID
   GROUP BY s.CompanyName) SQ
where Total = ( SELECT MAX(Total)
           FROM (SELECT s.CompanyName, SUM(Quantity) Total
           FROM Products P
           JOIN OrderDetails OD ON P.ProductID = OD.ProductID
           JOIN Suppliers S ON P.SupplierID = S.SupplierID
           GROUP BY s.CompanyName) SQ);

-- 2da forma creando tablas virtuales (vistas)

create view Cantidad_items_por_proveedor
as
   SELECT s.CompanyName, SUM(Quantity) as Total
   FROM Products P
   JOIN OrderDetails OD ON P.ProductID = OD.ProductID
   JOIN Suppliers S ON P.SupplierID = S.SupplierID
   GROUP BY s.CompanyName

-- muestra el proveedor con la menor cantidad de items vendidos
-- y el proveedor con la mayor cantidad de item vendidos
SELECT CompanyName, Total
FROM Cantidad_items_por_proveedor
where total = ( select min(total) from Cantidad_items_por_proveedor)
union
SELECT CompanyName, Total
FROM Cantidad_items_por_proveedor
where total = ( select max(total) from Cantidad_items_por_proveedor)




-- Ejercicio 10
-- Indicar el nombre de la categoria con la mayor cantidad de items de
-- productos vendidos.
SELECT CategoryName, Total
from (SELECT CategoryName, SUM(Quantity) as Total
	FROM Products P
	JOIN OrderDetails OD ON P.ProductID = OD.ProductID
	JOIN Categories C ON P.CategoryID = C.CategoryID
	GROUP BY CategoryName) CQ
where Total = (select max(Total)
			FROM (SELECT CategoryName, SUM(Quantity) as Total
			FROM Products P
			JOIN OrderDetails OD ON P.ProductID = OD.ProductID
			JOIN Categories C ON P.CategoryID =
			C.CategoryID
			GROUP BY CategoryName) CQ)

-- Ejercicio 11
-- Para cada empleado que atendio al menos cinco pedidos, indicar el
-- nombre y apellido del empleado, y
-- la cantidad de pedidos que atendio.
SELECT FirstName, LastName, Count(OrderID) as Quantity
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
GROUP BY FirstName,LastName 
HAVING Count(OrderID) >=5
order by Quantity asc

-- Ejercicio 13
-- Listar los nombres de los productos cuyo precio unitario sea mayor a
-- 18, especificamente productos que inicien con letra C
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > 18 and productname like 'C%'

-- Indicar la cantidad de clientes que han realizado pedidos.
SELECT COUNT( DISTINCT (CustomerID))
FROM Orders

-- Ejercicio 22
-- Lista los nombres de las categorias y el precio promedio de sus
-- productos.
SELECT CategoryName, AVG(UnitPrice)
FROM Products P, Categories C
WHERE P.CategoryID = C.CategoryID
GROUP BY CategoryName

SELECT CategoryName, AVG(UnitPrice) as Promedio
FROM Products P
join Categories C on P.CategoryID = C.CategoryID
GROUP BY CategoryName

-- Ejercicio 23
-- Lista la categoria, el nombre del producto con mayor
-- precio, mostrar precio del producto.
SELECT CategoryName, ProductName, UnitPrice
FROM Products P, Categories C
WHERE P.CategoryID = C.CategoryID 
AND UnitPrice = (SELECT MAX(UnitPrice) FROM Products P)

-- mostrar por categoria, el mayor precio
   SELECT CategoryName,  max(UnitPrice) as mayorprecio
	FROM Products P, Categories C
	WHERE P.CategoryID = C.CategoryID 
	Group by CategoryName
	order by CategoryName

-- Listar nombre de productos de cada categor�a  
-- que tiene mayor precio
	SELECT c.CategoryName, P.ProductName, UnitPrice
	FROM Products P, Categories C, 
		(SELECT C.CategoryName, max(UnitPrice) as mayorprecio
		FROM Products P, Categories C
		WHERE P.CategoryID = C.CategoryID 
		Group by C.CategoryName) SQ
	WHERE P.CategoryID = C.CategoryID 
		and C.CategoryName = SQ.CategoryName 
		and UnitPrice in ( select mayorprecio
			from (SELECT CategoryName, max(UnitPrice) as mayorprecio
				  FROM Products P, Categories C
				  WHERE P.CategoryID = C.CategoryID 
				  Group by CategoryName) SQ)


-- Ejercicio 25
-- Listar los nombres de los clientes que no tienen �rdenes registradas.
SELECT ContactName
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID
FROM Orders)


-- Ejercicio 28
-- Indicar el nombre del cliente con mas pedidos y 
-- ademas el cliente con menos pedidos realizados
SELECT Contactname, Quantity
from (SELECT ContactName, COUNT(OrderID) Quantity
		FROM Orders O, Customers C
		WHERE O.CustomerID = C.CustomerID
		GROUP BY ContactName) R
where Quantity = (Select max(Quantity)
				from (SELECT ContactName, COUNT(OrderID) Quantity
				FROM Orders O, Customers C
				WHERE O.CustomerID = C.CustomerID
				GROUP BY ContactName) R)
union
SELECT Contactname, Quantity
from (SELECT ContactName, COUNT(OrderID) Quantity
		FROM Orders O, Customers C
		WHERE O.CustomerID = C.CustomerID
		GROUP BY ContactName) R
where Quantity = (Select min(Quantity)
				from (SELECT ContactName, COUNT(OrderID) Quantity
				FROM Orders O, Customers C
				WHERE O.CustomerID = C.CustomerID
				GROUP BY ContactName) R)

-- Ejercicio 34
-- Lista los nombres de los clientes, N�mero de orden de pedido y fechas
-- de transporte en la cual la fechas de transporte este entre los meses
-- octubre y noviembre del anio 1997 ordenado por nombre de cliente
select C.ContactName, OD.OrderID, OD.ShippedDate
from Orders OD join Customers C
on OD.CustomerID = C.CustomerID
where ShippedDate between '1997-10-1' and '1997-11-1'
order by C.ContactName

-- 2da forma utilizando functions datetime
select C.ContactName, OD.OrderID, OD.ShippedDate
from Orders OD join Customers C
on OD.CustomerID = C.CustomerID
where year(ShippedDate) = 1997 
and (month(ShippedDate)=10 or month(ShippedDate)=11)
order by C.ContactName

-- 3ra forma 
select C.ContactName, OD.OrderID, OD.ShippedDate
from Orders OD join Customers C
on OD.CustomerID = C.CustomerID
where year(ShippedDate) = 1997 
and month(ShippedDate) in (10,11)
order by C.ContactName

-- Ejercicio 35
-- Lista el nombre del cliente Pavarotti, N�mero de orden de pedido y
-- fechas de transporte en la cual la fechas de transporte est� entre los
-- meses octubre y noviembre del anio 1997
select C.ContactName, OD.OrderID, OD.ShippedDate
from Orders OD join Customers C
on OD.CustomerID = C.CustomerID
where ShippedDate between '1997-10-1' and '1997-11-1'
and C.ContactName like '%Pavarotti%'
