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


