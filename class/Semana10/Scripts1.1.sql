/*14 DE OCTUBRE*/

--Ejercicio 23
-- Obtener el producto mas caro, mostrar el nombre de la categoria, nombre del producto y precio
SELECT CategoryName, ProductName, UnitPrice
FROM Products P, Categories C
WHERE P.CategoryID = C.CategoryID 
AND UnitPrice = (SELECT MAX(UnitPrice) FROM Products P)

--mostrar por categoría, el mayor precio
   SELECT CategoryName, max(UnitPrice) as mayorprecio
	FROM Products P, Categories C
	WHERE P.CategoryID = C.CategoryID 
	group by CategoryName

	
-- Obtner el producto mas caro de cada categoria
	SELECT C.CategoryName, P.ProductName, UnitPrice 
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
	order by CategoryName

/*1.Muestre el código y nombre de todos 
los clientes (companyname) que tienen órdenes 
pendientes de despachar.*/

select c.CustomerID,c.CompanyName
from Customers c join Orders o on c.CustomerID=o.CustomerID
where o.ShippedDate is null --condiciones de filtro

/*2.Muestre el código y nombre de todos los clientes
 (companyname) que tienen órdenes pendientes de despachar,  
 y la cantidad de órdenes con esa característica.*/


select c.CustomerID,c.CompanyName,COUNT(o.OrderID) 'Q Ordenes'
from Customers c join Orders o on c.CustomerID=o.CustomerID
where o.ShippedDate is null
group by c.CustomerID,c.CompanyName
order by 3 desc, c.CompanyName asc

/*3.Encontrar los pedidos que debieron despacharse a 
una ciudad o código postal diferente de la ciudad o código
 postal del cliente que los solicitó. Para estos pedidos, 
 mostrar el país, ciudad y código postal del destinatario, 
 así como la cantidad total de pedidos por cada destino.*/

select o.ShipCountry,o.ShipCity,o.ShipPostalCode, COUNT(o.OrderID) as Cantidad
from Customers c join Orders o on c.CustomerID=o.CustomerID
where c.City<>o.ShipCity or c.PostalCode<>o.ShipPostalCode
group by o.ShipCountry,o.ShipCity,o.ShipPostalCode


/*4.	Seleccionar todas las compañías de envío 
(código y nombre) que hayan efectuado algún despacho 
a México entre el primero de enero y el 28 de febrero de 1998.
Formatos sugeridos a emplear para fechas:
	Formatos numéricos de fecha (por ejemplo, '15/4/1998')
	Formatos de cadenas sin separar (por ejemplo, '19981207') 
*/

select s.ShipperID,s.CompanyName
from Orders o join Shippers s on o.ShipVia=s.ShipperID
where o.ShipCountry='Mexico' and o.ShippedDate between '19980101' and '19980228'


/*5.Mostrar los nombres y apellidos de los empleados 
junto con los nombres y apellidos de sus respectivos jefes */

select e.EmployeeID,e.LastName,e.FirstName,e.ReportsTo,
		j.LastName,j.FirstName
from Employees e inner join Employees j on e.ReportsTo=j.EmployeeID

select e.EmployeeID,e.LastName,e.FirstName,e.ReportsTo,
		j.LastName,j.FirstName
from Employees e left join Employees j on e.ReportsTo=j.EmployeeID

select e.EmployeeID,e.LastName,e.FirstName,e.ReportsTo,
		j.LastName,j.FirstName
from Employees e right join Employees j on e.ReportsTo=j.EmployeeID

/*6.Mostrar el ranking de venta anual por país de origen
 del empleado, tomando como base la fecha de las órdenes, 
 y mostrando el resultado por año y venta total (descendente).*/

 Select e.Country, YEAR(o.OrderDate) 'Año', convert(int,SUM((od.Quantity*od.UnitPrice)*(1-od.Discount))) as Monto_Venta
 from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				  join OrderDetails od on o.OrderID=od.OrderID
 group by e.Country, YEAR(o.OrderDate)
 order by YEAR(o.OrderDate),3 desc

 --------------------------------------------

 /*1.Mostrar de la tabla Orders, para los pedidos 
 cuya diferencia entre la fecha de despacho y 
 la fecha de  la orden  sea mayor a 4 semanas, 
 las siguientes columnas: 
 OrderId, CustomerId, Orderdate, 
 Shippeddate, diferencia en días,  
 diferencia en semanas y diferencia 
 en meses entre ambas fechas.
 */

 select o.OrderID,o.CustomerID,o.OrderDate,o.ShippedDate,
		DATEDIFF(wk,o.OrderDate,o.ShippedDate) 'Dif Semanas',
		DATEDIFF(D,o.OrderDate,o.ShippedDate) 'Dif Dias',
		DATEDIFF(MONTH,o.OrderDate,o.ShippedDate) 'Dif Meses'
 from Orders o
 where DATEDIFF(WW, o.OrderDate,o.ShippedDate)>4

 /*2.La empresa tiene como política otorgar a los jefes 
 una comisión del 0.5% sobre la venta de sus subordinados. 
 Calcule la comisión mensual que le ha correspondido 
 a cada jefe por cada año (basándose en la fecha de la orden) 
 según las ventas que figuran en la base de datos.
 Muestre el código del jefe, su apellido, el año 
 y mes de cálculo, el monto acumulado  de venta de
  sus subordinados, y la comisión obtenida. */

select j.EmployeeID,j.LastName, YEAR(o.OrderDate) 'Año',
		Mes=MONTH(o.OrderDate),
		Venta=SUM((od.Quantity*od.UnitPrice)*(1-od.Discount)),
		Comision=SUM((od.Quantity*od.UnitPrice)*(1-od.Discount))*0.005
from Employees e join Employees j on e.ReportsTo=j.EmployeeID
				join Orders o on o.EmployeeID=e.EmployeeID
				join OrderDetails od on o.OrderID=od.OrderID
group by j.EmployeeID,j.LastName, YEAR(o.OrderDate) ,
		MONTH(o.OrderDate)


/*3.	Obtener los países donde el importe total anual de 
las órdenes enviadas supera los $45,000. Para determinar el año,
 tome como base la fecha de la orden (orderdate). 
 Ordene el resultado monto total de venta. 
Muestre el país, el año, y el importe anual de venta.
*/

select o.ShipCountry,YEAR(o.OrderDate) 'Año',
		SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) 'Importe_Venta'
from Orders o join OrderDetails od on o.OrderID=od.OrderID
group by o.ShipCountry,YEAR(o.OrderDate)
having SUM(od.UnitPrice*od.Quantity*(1-od.Discount))>45000
order by 3 desc

-- 4.De cada producto que haya tenido venta en por lo 
-- menos 20 transacciones (ordenes) del año 1997 mostrar 
-- el código, nombre y cantidad de unidades vendidas y 
-- cantidad de ordenes en las que se vendió


select p.ProductID,p.ProductName,
		SUM(od.Quantity) 'Unidades Vendidas',
		COUNT(od.OrderID) 'Cantidad de Ordenes'	
from Products p join OrderDetails od on p.ProductID=od.ProductID
				join Orders o on od.OrderID=o.OrderID
where YEAR(o.OrderDate)=1997
group by p.ProductID,p.ProductName
having COUNT(od.ORderID)>=20

/*
5.	Determinar si existe algún problema de 
stock para la atención de las órdenes pendientes de despacho.
Para ello, determinar la relación de productos no 
descontinuados cuyo stock actual (unitsinstock) 
es menor que la cantidad de unidades pendientes de 
despacho (as que figuran en pedidos que no han sido despachados).
Mostrar el nombre del producto, la cantidad pendiente
 de entrega, el stock actual y la cantidad de unidades 
 que falta para la atención de las órdenes.
*/

/*
Discontinued : 
0 = NO DESCONTINUADO
1 = DESCONTINUADO 
*/

select p.ProductName,p.UnitsInStock, SUM (od.Quantity) 'Pendiente',
		SUM(od.Quantity)-p.UnitsInStock 'Stock Faltante'
from Products p join OrderDetails od on p.ProductID=od.ProductID
				join Orders o on od.OrderID=o.OrderID
where o.ShippedDate is null and p.Discontinued=0
group by p.ProductName,p.UnitsInStock
having p.UnitsInStock<SUM (od.Quantity)

/*6.Mostar la lista de productos descontinuados 
(nombre y precio) cuyo precio es menor al precio promedio.*/

/*Discontinued = 1*/

select p.ProductID,p.ProductName,p.UnitPrice
from Products p
where p.Discontinued=1 and p.UnitPrice> (select AVG(p.UnitPrice)
										 from Products p)

select AVG(p.UnitPrice)
from Products p

/*7.Listar aquellas órdenes cuya diferencia entre la 
fecha de la orden y la fecha de despacho es mayor que: 
a.	El promedio en días de  dicha diferencia en todas las órdenes.	
b.	El promedio en semanas de dicha diferencia en todas las órdenes.
*/

select o.OrderID,o.OrderDate,o.ShippedDate,
		DATEDIFF(DD,o.OrderDate,o.ShippedDate)'Diferencia'
from Orders o
where DATEDIFF(DD,o.OrderDate,o.ShippedDate)> (select AVG(DATEDIFF(DD,o.OrderDate,o.ShippedDate))
												from Orders o)

/*8.Mostrar los productos no descontinuados 
(código, nombre de producto, nombre de categoría y precio) 
cuyo precio unitario es mayor al precio promedio de su 
respectiva categoría  */

/*
Discontinued : 
0 = NO DESCONTINUADO
1 = DESCONTINUADO 
*/

select p.ProductID,p.ProductName,p.CategoryID,p.UnitPrice
from Products p
where p.Discontinued=0 and p.UnitPrice >(select AVG(pp.UnitPrice)
										 from Products pp
										 where p.CategoryID=pp.CategoryID
						                 )
order by 1

--lógica
select p.ProductID,p.ProductName,p.CategoryID,p.UnitPrice
from Products p
where p.Discontinued=0

select p.CategoryID,AVG(p.UnitPrice)
from Products p
group by p.CategoryID

/*9.Mostrar la relación de productos (Nombre) no descontinuados 
de la categoría 8 que no han tenido venta entre el 1° y el 15 de 
Agosto de 1996. */

--PASO 1:
--Mostrar la relación de productos (Nombre) no descontinuados 
--de la categoría 8 que HAN tenido venta entre el 1° y el 15 de 
--Agosto de 1996

select p.ProductID,p.ProductName,p.CategoryID
from Products p 
where p.Discontinued=0 and p.CategoryID=8
		and p.ProductID NOT IN (
							select p.ProductID
							from Products p join OrderDetails od on p.ProductID=od.ProductID
											join Orders o on od.OrderID=o.OrderID
							where p.CategoryID=8 and p.Discontinued=0
								  and o.OrderDate between '19960801' and '19960815'
							)

--Mostrar pedidos cuyo pais de embarque no sea ni Francia ni Alemania
select o.OrderID,o.OrderDate,o.ShipCountry
from Orders o
where o.ShipCountry NOT IN ('France','Germany')

/*10.Encontrar la categoría a la que pertenece la mayor 
cantidad de productos. Mostrar el nombre de la categoría 
y la cantidad de productos que comprende*/

select p.CategoryID, c.CategoryName,COUNT(p.ProductID)
from Products p join Categories c on p.CategoryID=c.CategoryID
group by p.CategoryID , c.CategoryName
having COUNT (p.ProductID) >= ALL (select COUNT(p.ProductID)
									from Products p
									group by p.CategoryID )

select COUNT(p.ProductID)
from Products p
group by p.CategoryID 

/*11.Encontrar el producto de cada categoría que tuvo la mayor venta 
(en unidades) durante el año 1997, liste la categoría, 
el código de producto, nombre del producto, y la cantidad vendida.*/

--paso 1

/*Encontrar la venta (en unidades) de cada producto  
durante el año 1997, liste la categoría, 
el código de producto, nombre del producto, y la cantidad vendida.*/


alter view vw_venta_x_producto as
select c.CategoryID,c.CategoryName,
		p.ProductID, p.ProductName, SUM(od.Quantity) 'Cantidad'
from Categories c join Products p on c.CategoryID=p.CategoryID
				  join OrderDetails od on p.ProductID=od.ProductID
				  join Orders o on od.OrderID=o.OrderID
where YEAR(o.OrderDate)=1997
group by c.CategoryID,c.CategoryName,p.ProductID, p.ProductName
order by 1

create view vw_maximo_categoria as
select vw1.CategoryID,vw1.CategoryName,MAX(vw1.Cantidad) 'maximo'
from vw_venta_x_producto vw1
group by vw1.CategoryID,vw1.CategoryName


select * from vw_venta_x_producto
select * from vw_maximo_categoria

select vw1.CategoryID,vw1.CategoryName,vw1.ProductID,vw1.ProductName,vw2.maximo
from vw_venta_x_producto vw1 join vw_maximo_categoria vw2 on vw1.CategoryID=vw2.CategoryID
where vw1.Cantidad=vw2.maximo
order by 1

/*12.Encontrar el pedido de mayor importe por país al cual se despachó. 
Mostrar el país y el monto del pedido,  ordenado por monto de mayor a menor.*/

Create view vw_monto_pais_orden as
select o.ShipCountry,o.OrderID, SUM(od.Quantity*od.UnitPrice*(1-od.Discount))'Monto'
from Orders o join [Order Details] od on o.OrderID=od.OrderID
group by o.ShipCountry,o.OrderID
order by 1

create view vw_maximo_pais as
select vw1.ShipCountry,MAX(vw1.Monto) 'maximo'
from vw_monto_pais_orden vw1
group by vw1.ShipCountry

select * from vw_monto_pais_orden
select * from vw_maximo_pais

select vw1.ShipCountry,vw1.OrderID,vw2.maximo
from vw_monto_pais_orden vw1 join vw_maximo_pais vw2 on vw1.ShipCountry=vw2.ShipCountry
where vw1.Monto=vw2.maximo
order by 3

/*PD11*/
--Ejercicio 1

create function fn_num_emp()
returns int --tipo de dato
as
begin
	--variables
	declare @num_emp int

	--query
	select @num_emp=count(e.EmployeeID)
	from Employees e

	--retornar
	return @num_emp
end

select dbo.fn_num_emp()

/*2.Crear una función que devuelva el número de subordinados
 un jefe (Empleado)*/

create function fn_num_sub(@id_jefe int)
returns int
as
begin
	--declaracion
	declare @totsub int

	--query
	select @totsub=count(e.EmployeeID)
	from Employees e
	where e.ReportsTo=@id_jefe

	--retornar
	return @totsub
end

select dbo.fn_num_sub(2)

/*FUNCIONES*/

/*
--ESCALARES: retornan siempre un valor
--TABULARES: retornan una tabla

*/

/*3.Crear una función que liste el número de ordenes por empleado, 
si solo se conoce parte del nombre del empleado.*/

create function fn_ordenes_x_emp (@nombre nvarchar(10))
returns table 
as
RETURN (
	select e.EmployeeID,e.FirstName,e.LastName, COUNT(o.OrderID) 'q_ordenes'
	from Orders o join Employees e on o.EmployeeID=e.EmployeeID
	where e.FirstName like @nombre
	group by e.EmployeeID,e.FirstName,e.LastName
	)

select *
from dbo.fn_ordenes_x_emp('a%')


/*4.Crear una función que liste para un País (Parámetro de entrada),
 el Nombre de la compañía, Ciudad, País (Suppliers), 
 Nombre de Producto, 
 Cantidad, Precio Unitario y Descuento de Producto.*/

create function fn_detalle_proveedores (@Pais nvarchar(15))
 returns table
 as
 RETURN(
	 select s.CompanyName,s.City,s.Country, p.ProductName,
			od.Quantity,od.UnitPrice,od.Discount
	 from Suppliers s join Products p on s.SupplierID=p.SupplierID
					  join [Order Details] od on od.ProductID=p.ProductID
	 where s.Country like @Pais)

select *
from dbo.fn_detalle_proveedores('_a%')

/*5.Ejecute la función Cos(0), luego la función Getdate( ) 
repetidas veces*/


select cos(0) --Deterministica : no cambian el valor de retorno
select getdate() --No Deterministica: cambian el valor del retorno

/*Procedimientos*/

/*6.Crear un procedimiento almacenado que liste el nombre
 de la compañía, nombre del contacto, ciudad y 
 número de teléfono de los clientes*/

 alter procedure sp_lista_clientes as
 select c.CompanyName,c.ContactName,c.City,c.Phone,c.Fax
 from Customers c

 exec dbo.sp_lista_clientes

 /*7.Crear un procedimiento almacenado que actualice el precio 
 unitario de los productos en un determinado porcentaje 
 para una categoría. (Parámetros % = real, categoria  = entero)*/

select *
from Products
where CategoryID=1

update Products
set UnitPrice=UnitPrice*1.1
where CategoryID=1








/*8. Mostrar en un procedimiento la región(orders) donde 
se ha vendido más durante un año ingresado como parámetro
*/

/*Mostrar en un procedimiento la región donde 
se ha vendido más durante un año ingresado como parámetro*/

create view vw_cantidad_region as
select YEAR(o.OrderDate)'Anio', o.ShipRegion, COUNT(o.OrderID) 'cantidad'
from Orders o join [Order Details] od on o.OrderID=od.OrderID
where o.ShipRegion is not null
group by YEAR(o.OrderDate), o.ShipRegion
--order by 1,3

create view vw_maximo_anio as
select vw1.Anio, MAX(vw1.cantidad) 'maximo'
from vw_cantidad_region vw1
group by vw1.Anio

select * from vw_cantidad_region
select * from vw_maximo_anio

create procedure sp_maximo_x_region @anio int as
select vw1.Anio,vw1.ShipRegion,vw2.maximo
from vw_cantidad_region vw1 join vw_maximo_anio vw2 on vw1.Anio=vw2.Anio
where vw1.cantidad=vw2.maximo and vw1.Anio=@anio

exec dbo.sp_maximo_x_region 1996

/*9.Mostrar en un procedimiento el o los empleado 
que más vendieron (monto) en la región que tuvo mejores 
ventas en un determinado año*/

create view vw_empleado_region as
select YEAR(o.OrderDate) 'Anio',e.EmployeeID,e.FirstName,o.ShipRegion,
		SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) 'Monto'
from [Order Details] od join Orders o on od.OrderID=o.OrderID
						join Employees e on e.EmployeeID=o.EmployeeID
where o.ShipRegion is not null
group by YEAR(o.OrderDate),e.EmployeeID,e.FirstName,o.ShipRegion

create view vw_max_venta_region as
select vw1.Anio, vw1.ShipRegion,MAX(vw1.Monto) 'maximo'
from vw_empleado_region vw1
group by vw1.Anio, vw1.ShipRegion

select * from vw_empleado_region order by Anio,monto
select * from vw_max_venta_region order by Anio,maximo

create procedure sp_maximo_empleado @anio int 
as
select vw1.Anio,vw1.EmployeeID,vw1.FirstName,vw1.ShipRegion,vw2.maximo
from vw_empleado_region vw1 join vw_max_venta_region vw2 on vw1.ShipRegion=vw2.ShipRegion
where vw1.Monto=vw2.maximo and vw1.Anio=@anio

exec sp_maximo_empleado 1996 


/*10. Mostrar en un procedimiento el proveedor que
 tuvo la menor venta de productos en un año*/

create View V_Provedor_x_Monto_Anual as
select Año = YEAR(o.OrderDate), s.CompanyName ,Monto = SUM( od.Quantity * od.UnitPrice * ( 1 - od.Discount))
from Suppliers s join Products p on s.SupplierID = p.SupplierID
				 join [Order Details] od on p.ProductID = od.ProductID
				 join Orders o on o.OrderID = od.OrderID
group by YEAR(o.OrderDate), s.CompanyName

create View V_Min_Proveedor_Monto_Anual as
select Año = PMA.Año , Minimo = MIN(PMA.Monto)
from  V_Provedor_x_Monto_Anual PMA
group by PMA.Año
--order by 1 , 2

Create Procedure Provedor_Menor_Venta @Año int as
select PMA.CompanyName , Año = @Año 
from V_Provedor_x_Monto_Anual PMA join V_Min_Proveedor_Monto_Anual MPMA on PMA.Año = MPMA.Año
where @Año = MPMA.Año and MPMA.Minimo = PMA.Monto

exec Provedor_Menor_Venta 1997