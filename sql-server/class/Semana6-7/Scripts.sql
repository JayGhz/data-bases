use Northwind


Alter TABLE Region
Add cantidad int null

select * from region

--Listar los productos por categoría

select C.CategoryID, C.CategoryName, P.ProductID, P.ProductName
from Categories C, Products P
where C.CategoryID = P.CategoryID
order by C.CategoryID

--Listar los productos por categoría
select C.CategoryID, C.CategoryName, P.ProductID, P.ProductName
from Categories C
join Products P on C.CategoryID = P.CategoryID
order by C.CategoryID

-- Mostrar la cantidad de categorias
Select count(*) from Categories
Select count(*) from Products

--Mostrar la cantidad de productos por idcategoria
select C.CategoryID, count(P.ProductID) cantidad_productos
from Categories C
join Products P on C.CategoryID = P.CategoryID
group by C.CategoryID
order by C.CategoryID

--Mostrar la cantidad de productos por idcategoria, categoryname
select C.CategoryID, C.CategoryName, count(P.ProductID) cantidad_productos
from Categories C
join Products P on C.CategoryID = P.CategoryID
group by C.CategoryID, C.CategoryName
order by C.CategoryID

-- Mostrar la cantidad de categorias
--- cuyo nombre inician con la letra c
Select count(*) from Categories
where CategoryName like 'C%'

-- Mostrar la cantidad de productos
--- cuyo precio sea mayor a 30
Select count(*) from Products
where UnitPrice > 30


--Mostrar la cantidad de productos por idcategoria, categoryname
---pero solo aquella cantidad de producto que sea mayor a 10
select C.CategoryID, C.CategoryName, count(P.ProductID) cantidad_productos
from Categories C
join Products P on C.CategoryID = P.CategoryID
group by C.CategoryID, C.CategoryName
having count(P.ProductID) > 10



select C.CategoryID, C.CategoryName, count(P.ProductID) cantidad_productos
from Categories C
join Products P on C.CategoryID = P.CategoryID
where categoryname like '%a%'
group by C.CategoryID, C.CategoryName

select C.CategoryID, C.CategoryName, count(P.ProductID) cantidad_productos
from Categories C
join Products P on C.CategoryID = P.CategoryID
group by C.CategoryID, C.CategoryName
having categoryname like '%a%'

select * from Products
order by UnitPrice desc

select max(unitprice) from products
select min(unitprice) from products