--crear un procedimiento que muestra
--clientes cuya ciudad contiene la letra M
Create procedure listaClientes
AS
begin
	SELECT * from Customers where Customers.City
	like '%M%'
end
go

--Ejecutar el query
--1era forma 
EXECUTE listaClientes
Execute dbo.listaClientes

---2da forma--
Exec listaclientes


--Modificar el procedimiento
--para que muestre los clientes
--cuya ciudad contiene la letra A
Alter procedure listaClientes
AS
begin
	declare @letra char(3)
	set @letra='%A%'
	SELECT * from Customers where Customers.City like
	@letra
end
go

--Ejecutamos el procedimiento



--procedimiento almacenado
CREATE PROCEDURE usp_Listado_Clientes
AS
begin
	Select CustomerID as codigo_cliente, OrderDate, ShippedDate
	from Orders
end
Go

--Ejecutar el procedimiento
exec usp_Listado_Clientes



--crear un procedimiento que muestra un pedido ingresando
--dos fechas
CREATE PROCEDURE usp_PedidosbyFechas
@f1 DateTime,
@f2 DateTime
AS
begin
Select * from Orders
Where OrderDate BETWEEN @f1 AND @f2
end
go

--Ejecuto Store Procedure, ingreso
-- dos par�metros de entrada
Execute usp_PedidosbyFechas '1997-09-12', '1997-09-23'

Exec usp_PedidosbyFechas '1996-09-12', '1997-09-23'



--crear un prcedimiento
--que muestre los pedidos
--de un determinado a�o. El a�o debe ser ingresado como par�metro.
CREATE PROCEDURE usp_PedidosbyFechas_anio
@f1 int
AS
begin
Select * from Orders
Where year(OrderDate) = @f1
end
go

--Ejecutar procedimiento
Execute usp_PedidosbyFechas_anio 1996
Execute usp_PedidosbyFechas_anio 1997



--crear un procedimiento que muestre los pedidos, fecha de pedido, id del cliente
--de un cliente ingresado como par�metro en un determinado a�o
CREATE PROCEDURE usp_PedidosClienteAnio
@id varchar(5),
@a int = 1996
AS
	Select o.orderid as 'Pedido', OrderDate, C.customerid
	From Orders o JOIN Customers c
	ON o.customerid = c.customerid
	WHERE Year(o.OrderDate) = @a AND c.customerid = @id
Go

SELECT * FROM Customers

--MUESTRA LOS PEDIDOS DEL CLIENTE TORTU DEL A�O 1996
execute usp_PedidosClienteAnio @id= 'TORTU'

--MUESTRA LOS PEDIDOS DEL CLIENTE HANAR DEL A�O 1997
execute usp_PedidosClienteAnio @ID= 'hanar', @a = 1997

--MUESTRA LOS PEDIDOS DEL CLIENTE CHOPS DEL A�O 1997
execute usp_PedidosClienteAnio 'CHOPS', 1998	



--crear un procedimiento que muestre
--el pedido, fecha de pedido, nombre del producto,
--precio unitario y cantidad vendida
--de un cliente determinado en un a�o espec�fico
create PROCEDURE usp_PedidosClienteAnio
@id varchar(5),
@anio int = 1996
AS
BEGIN
	Select  o.OrderID 'Pedido', o.OrderDate, p.ProductName,
	p.UnitPrice as 'Precio', od.Quantity
	From Orders o JOIN OrderDetails od
	ON o.OrderID = od.orderid JOIN Products p
	ON p.ProductID= od.ProductID
	WHERE Year(o.OrderDate) = @anio AND o.CustomerID = @id
END
Go

Exec usp_PedidosClienteAnio @id='VICTE'


Exec usp_PedidosClienteA�o_V2 @id='VICTE', @anio=1998
go

--Implemente un procedimiento almacenado, que retorne los
--pedidos para un determinado a�o y que tenga el a�o un valor por
--defecto de 1998.
CREATE Procedure usp_ConsultaPedidos_x_Anio
	@y int = 1998
	AS
	Select * FROM Orders o
	WHERE YEAR(o.OrderDate) = @y
	Go

--se ejecuta el procedimiento y muestra los pedido del a�o 1998
Exec usp_ConsultaPedidos_x_Anio 

Exec usp_ConsultaPedidos_x_Anio 1996


----------------
--Implemente un procedure que retorne el n�mero de pedidos para
--un determinado a�o.

--El procedimiento debe devolver una variable de salida
--esta variable de salida debe contener la cantidad de pedidos
Create procedure usp_cantidad_pedidos_xanio_v2
@a int,
@b int OUTPUT
AS
BEGIN
	select @b = count(*) from orders
    where year(orderdate)= @a
END

--Eejcutar el procedimiento con variable de salida
Declare @x int
execute usp_cantidad_pedidos_xanio_v2 1997,@x oUTPUT
print @x

------------------
--Implemente un procedure que retorne el numero de pedidos
--para un determinado a�o.

CREATE Procedure usp_CuantosPedidos_x_A�o2
@y int
AS
	Select COUNT(*)
	FROM Orders o
	WHERE YEAR(o.OrderDate) = @y
	Go

exec usp_CuantosPedidos_x_A�o2 1998

------------------
--Implemente un procedure que retorne la cantidad de pedidos y el
--monto total de pedidos, registrados por un determinado c�digo del
--empleado y en determinado a�o.

CREATE Procedure usp_ReportePedidosEmpleado_v2
@id int,
@y int,
@q int OUTPUT,
@monto decimal OUTPUT
AS
Begin
	Select @q= COUNT(distinct o.OrderID), 
	@monto = SUM(UnitPrice*Quantity*(1-Discount))
	FROM Orders o JOIN OrderDetails od
	ON o.OrderID=od.orderID
	join Employees e
	on o.EmployeeID = e.EmployeeID
	WHERE e.EmployeeID =@id AND YEAR(o.OrderDate) = @y
End
Go

	Select COUNT(distinct o.OrderID) as 'cantidad',
	convert(int, SUM(UnitPrice*Quantity*(1-Discount))) as 'Monto total'
	FROM Orders o JOIN OrderDetails od
	ON o.OrderID=od.orderID
	join Employees e
	on o.EmployeeID = e.EmployeeID
	WHERE e.EmployeeID = 2 AND YEAR(o.OrderDate) = 1997


--Ejecutar procedimiento con 2 variables de salida
DECLARE @q int, @m decimal
EXEC usp_ReportePedidosEmpleado_v2 @id=2, @y=1997,
@q=@q OUTPUT, @monto=@m OUTPUT
PRINT 'Cantidad de pedidos colocados:' + Str(@q)
PRINT 'Monto percibido:'+Str(@m)
Go

DECLARE @q int, @m decimal
EXEC usp_ReportePedidosEmpleado_v2 2, 1997, @q OUTPUT, @m OUTPUT
PRINT @q
PRINT @m
Go


-------------------------
--Implemente un procedure que imprima cada uno de los registros
--de los productos, donde al finalizar, visualice el total del
--inventario.

Create PROCEDURE usp_Inventario
AS
DECLARE @Id int, @Nombre varchar(255), @precio decimal, @st int, @inv int
SET @inv=0
DECLARE cproducto CURSOR FOR
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products
-- Apertura del cursor y lectura
OPEN cproducto
FETCH cproducto INTO @id, @Nombre, @precio, @st
WHILE (@@FETCH_STATUS = 0 )
	BEGIN
	--imprimir
	PRINT Str(@id) + space(5) + @nombre + space(5) + Str(@precio) +
	space(5) + Str(@st)
	--acumular1
	SET @inv += @st   
	-- Lectura de la siguiente fila del cursor
	FETCH cproducto INTO @id, @Nombre, @precio, @st
END
-- Cierre del cursor
CLOSE cproducto
DEALLOCATE cproducto
Print 'Inventario de Productos:' + Str(@inv)


Execute usp_Inventario

SELECT ProductID, ProductName, UnitPrice, UnitsInStock
from Products


----Modificar datos con Procedures--
CREATE PROCEDURE usp_Insertacategoria
@id int,
@nombre varchar(15),
@descripcion nvarchar(max)
as
Insert Into Categories(CategoryID, CategoryName, Description)
Values(@id, @nombre, @descripcion)
Go


SET IDENTITY_INSERT categories ON

EXEC usp_Insertacategoria 15, 'Alimentos integrales',
'frutas saludables'
Go

select * from Categories