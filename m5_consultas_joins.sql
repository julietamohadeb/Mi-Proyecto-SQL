USE Ventas_Tech_DB;
GO

-- Consulta 1. Vista base del proyecto
-- Espero ver una tabla donde figuren los datos principales de las ventas, clientes y productos. 
-- De esta forma se entiende mejor el comportamiento de los clientes, las categorias de productos más y menos comprados, la zona principal de donde provienen las ventas y el total de las mismas.

SELECT 
	Ventas.fecha_venta, 
	Clientes.id_cliente, 
	Clientes.nombre, 
	Productos.nombre_producto, 
	ventas.precio_unitario,
	ventas.cantidad,
	zona.nombre_zona, 
	categorias.nombre_categoria,
	(cantidad * precio_unitario) AS total_venta
	
FROM ventas 
INNER JOIN Clientes 
ON Ventas.id_cliente = Clientes.id_cliente
INNER JOIN Productos
ON Ventas.id_producto = Productos.id_producto
INNER JOIN zona
ON clientes.id_zona = zona.id_zona
INNER JOIN categorias
ON productos.id_categoria = categorias.id_categoria;


-- Hallazgos: todas las ventas ocurrieron en el mes de marzo y todos los clientes realizaron dos ventas.
-- Los productos varían en precio significativamente de 28 a 1200. 
-- Las categoría con más ventas es Computación y la de menor ventas Almacenamiento. Igualmente, el ítem más vendido son los Mouse.

-- 2. Clientes sin ventas
-- Sirve para ver quién se registró pero no realizó una compra de manera tal que se pueda aplicar un protocolo de conversión.
SELECT nombre, email, fecha_registro, fecha_venta 
FROM Clientes
LEFT JOIN Ventas
ON Clientes.id_cliente = Ventas.id_cliente
WHERE fecha_venta IS NULL;

-- Hallazgos: No hay clientes sin ventas, lo que indica que todas las personas que se registraron realizaron una compra.

--3. Productos sin ventas
-- Espero ver qué productos no se venden, de forma tal de reconsiderar si deben seguir pidiendose a proveedores.
SELECT nombre_producto, precio, nombre_categoria, fecha_venta
FROM Productos
LEFT JOIN Categorias
ON Productos.id_categoria = Categorias.id_categoria
LEFT JOIN Ventas
ON Productos.id_producto = Ventas.id_producto
WHERE fecha_venta IS NULL;

-- Hallazgos: Todos los productos se venden, por lo que se puede mantener el pedido.

-- 4. Consolidado por canal
-- Espero ver cuál es el peso de la región Este vis a vis el resto de las regiones , comparando la cantidad de ventas, el total facturado y la facturación por venta.
SELECT canal,
       COUNT(*) AS cantidad_ventas,
       SUM(total) AS total_facturado,
       SUM(total) / COUNT(*) AS facturacion_por_venta
FROM (
    SELECT v.fecha_venta, v.cantidad * v.precio_unitario AS total, 'Este (Buenos Aires)' AS canal
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE c.id_zona = 5

    UNION ALL

    SELECT v.fecha_venta, v.cantidad * v.precio_unitario AS total, 'Resto del país' AS canal
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE c.id_zona <> 5
) AS consolidado
GROUP BY canal;

-- Hallazgo: el Este completa 2 de las 10 ventas pero aporta el 41% de la facturación, con $1.320
-- por venta (casi el triple que el resto); la diferencia se explica por la compra de laptops.