
--FUNCIONES ESCALARES
--Crear una funcion que retorne el precio promedio de
--todos los productos
Use NORTHWND1



CREATE FUNCTION PrecioPromedio() 
RETURNS decimal
AS
BEGIN
	Declare @prom decimal
	Select @prom=AVG(UnitPrice) From Products
	RETURN @prom
END

print dbo.PrecioPromedio()


======================================

	CREATE PROCEDURE PrecioPromedio_V2
	@prom DECIMAL OUTPUT
	AS
	BEGIN
		Select @prom=AVG(UnitPrice) From Products
	END

	--Ejecuta precio promedio
	Declare @p decimal
	Execute PrecioPromedio_V2 @p output
	print @p


-- 2 
--Crear una funcion que retorne el numero
--total de empleados

CREATE FUNCTION Cuenta_Emp() RETURNS int
AS
BEGIN
	Declare @nemp int
	Select @nemp=COUNT(1) From Employees
	RETURN @nemp
END

print dbo.Cuenta_Emp ()
select dbo.Cuenta_Emp()


--3
--Defina una funcion donde ingrese el id del empleado y
--retorne la cantidad de pedidos registrados en el año 
--2016

select  year(GETDATE())


Alter FUNCTION PedidosEmpleado(@id int) 
RETURNS int
AS
BEGIN
	Declare @q int
	Select @q=COUNT(*) FROM Orders o
	join Employees e
	on o.EmployeeID = e.EmployeeID
	WHERE Year(o.OrderDate)=2016 And e.EmployeeID=@id
	RETURN @q
END
--mostrar el resultado del empleado de codigo 4
print dbo.PedidosEmpleado(4)

	
=================================


Use Northwind

--Defina una funcion donde ingrese el id del empleado y
--retorne la cantidad de pedidos registrados 
--en el presente año

Create FUNCTION PedidosEmpleado_v2(@id int) RETURNS int
AS
BEGIN
	Declare @q int
	Select @q=COUNT(*) FROM Orders o
	join Employees e
	on o.EmployeeID = e.EmployeeID
	WHERE Year(o.OrderDate)=Year(Getdate()) And e.EmployeeID=@id
	RETURN @q
END

print dbo.PedidosEmpleado_v2(4)

====================================

-- Ejemplo: NorthWind:Defina una funcion donde ingrese el nombre del pa�s
-- destinatario del pedido y retorne el total dela 
-- cantidad total de unidades vendidas para dichos pedidos

CREATE FUNCTION TotalUnidades_pais(@pais varchar(15)) 
RETURNS int 
AS 
BEGIN 
	Declare @q int 
	Select @q=SUM(Quantity) 
	FROM orderdetails od JOIN Orders o 
	ON od.orderID=o.orderID 
	WHERE o.ShipCountry=@pais 

	IF @q is NULL 
	 SET @q=0 

	RETURN @q 
END


print dbo.totalunidades_pais('france')

Select SUM(Quantity) 
	FROM orderdetails od JOIN Orders o 
	ON od.orderID=o.orderID 
	WHERE o.ShipCountry= 'france'


--OTRO RESULTADO

print 'cantidad de unidades de Brazil' + str(dbo.TotalUnidades_pais('Brazil'))
print 'cantidad de unidades de Francia' + str(dbo.TotalUnidades_pais('France'))

==============================
Ejemplo: Defina una funcion que liste los registros 
de los clientes,e incluya el nombre del Pa�s

CREATE FUNCTION dbo.Clientes() 
RETURNS TABLE 
AS 
 RETURN select * from customers 
 go
 --ejecutando la funcion
select * from dbo.Clientes() 
where Country = 'france'

-----------------
--crear un procedimiento y/o function que muestre
--el nombre del proveedor con la menor cantidad de �tems de
--productos vendidos.

--Funci�n que muestra la cantidad  total de 
--items de productos vendidos por proveedor
CREATE FUNCTION dbo.itemstotalesxproveedor() 
RETURNS TABLE 
AS 
 RETURN 
    (SELECT s.CompanyName, SUM(Quantity) as Total
   FROM Products P
   JOIN OrderDetails OD ON P.ProductID = OD.ProductID
   JOIN Suppliers S ON P.SupplierID = S.SupplierID
   GROUP BY s.CompanyName)
 go

 select * from dbo.itemstotalesxproveedor()

 --creando  la funcion principal
 Create Function Proveedor_menor_item()
 RETURNS TABLE 
AS 
 RETURN ( 
	SELECT CompanyName, Total
	FROM  dbo.itemstotalesxproveedor()	   
	where Total = (SELECT MIN(Total)
			   FROM dbo.itemstotalesxproveedor()))

--Ejecutar la funcion principal
select * from dbo.proveedor_menor_item()

===========================

Ejercicio: Defina una funcion que liste los registros de
los clientes e incluya :
� C�digo
� Nombre
� Direcci�n
� Pa�s

CREATE FUNCTION dbo.ListaClientesV2() 
RETURNS TABLE
AS
RETURN (Select CustomerID as 'codigo',
		CompanyName as 'Cliente',
		Address as 'direccion',
		Country as 'Pais'
		From customers )
--ejecutando la funcion
Select * from dbo.ListaClientesV2() 
Where Pais='Italy'
Go

========================================

Ejemplo: Defina una funcion que liste los registros
de los pedidos para un determinado año e incluya: 
� El c�digo del pedido 
� La fecha del pedido 
� El nombre del producto � 
-El precio que fue vendido �
La cantidad vendida

CREATE FUNCTION dbo.PedidosAnio(@y int)
RETURNS TABLE 
AS 
RETURN 
	(Select o.OrderID as'Pedido', 
         o.OrderDate as 'FechaPedido', 
         p.Productname as 'NombreProducto', 
         od.UnitPrice as 'Precio', 
          od.Quantity as 'cantidad' 
        From Orders o JOIN OrderDetails od 
        ON o.orderID=od.OrderID 
      JOIN Products p 
        ON od.ProductID=p.productID 
       WHERE Year(OrderDate)=@y) 

go
--ejecutando la funcion 
Select * from dbo.PedidosAnio(2016)


--FUNCIONES DE TABLA MULTISENTENCIAS 
--Ejemplo: Defina una funcion que retorne 
--los PRODUCTOS que se acaban de registrar en la base de datos.

CREATE FUNCTION dbo.Inventario() 
RETURNS @tabla 
   TABLE( idproducto int, 
         nombre varchar(50), 
		 precio decimal, 
		 stock int) 
AS 
BEGIN 
  INSERT INTO @tabla 
  SELECT ProductID, ProductName, UnitPrice, UnitsInStock 
  FROM products
 RETURN 
END 
Go
--ejecutandola funcion 
Select * from dbo.Inventario()

--Ejemplo: Defina una funcion que permita generar un
--reporte de ventas por empleado, por año. En este
--proceso la funcion debe retornar: los datos del empleado,
--la cantidad de pedidos registrados y el monto total por
--empleado

CREATE FUNCTION dbo.ReporteVentas(@y int)
RETURNS @tabla TABLE
(id int, nombre varchar(50), 
cantidad int, monto
decimal)
AS
BEGIN
	INSERT INTO @tabla
	SELECT e.EmployeeID, e.lastname, COUNT(o.OrderID) 'cantidad' , SUM(od.unitprice*od.quantity*(1-od.discount)) 'monto'
	FROM orders o JOIN OrderDetails od
	ON o.OrderID = od.OrderID 
	JOIN Employees e
	ON e.EmployeeID = o.EmployeeID
	WHERE YEAR(o.OrderDate) = @y
	GROUP BY e.EmployeeID, e.lastname
RETURN
END
GO
--imprimir el reporte del año 2016
Select * from dbo.ReporteVentas(2016)


--crear una funcion que muestre
--idempleado, apellido, cantidad de pedidos del empleadi
--monto total 
--en un año espec�fico de un determinado empleado

CREATE FUNCTION dbo.ReporteVentasV2(@y int,@emp int)
RETURNS @tabla TABLE
(id int, nombre varchar(50), 
cantidad int, monto
decimal)
AS
BEGIN
	INSERT INTO @tabla
	SELECT e.EmployeeID, e.lastname, COUNT(o.OrderID) 'cantidad' , SUM(od.unitprice*od.quantity*(1-od.discount)) 'monto'
	FROM orders o JOIN OrderDetails od
	ON o.OrderID = od.OrderID 
	JOIN Employees e
	ON e.EmployeeID = o.EmployeeID
	WHERE YEAR(o.OrderDate) = @y and e.EmployeeID =@emp
	GROUP BY e.EmployeeID, e.lastname
RETURN
END
GO
--imprimir el reporte del año 2016 del idempleado = 2
Select * from dbo.ReporteVentasv2(2016, 2)

