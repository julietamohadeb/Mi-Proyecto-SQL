USE Ventas_Tech_DB;

-- Consulta 1 — Resumen ejecutivo mensual 

SELECT COUNT(cantidad) AS cantidad_pedidos, SUM(precio_unitario* cantidad) AS total_facturado, AVG(precio_unitario* cantidad) AS ticket_promedio FROM ventas GROUP BY MONTH(fecha_venta);

-- Consulta 2 — Ranking de productos  

SELECT TOP 5 id_producto, SUM(cantidad) AS unidades_vendidas, SUM(precio_unitario* cantidad) AS total_facturado FROM ventas GROUP BY id_producto ORDER BY total_facturado DESC;

-- Consulta 3 — Clientes recurrentes 
SELECT id_cliente, SUM(precio_unitario* cantidad) AS total_gastado, COUNT(*) AS cantidad_pedidos FROM ventas GROUP BY id_cliente HAVING COUNT(*) > 1 ORDER BY total_gastado DESC;

-- Consulta 4 — Productos por encima/por debajo del promedio

WITH promedios AS (
SELECT id_producto, SUM(cantidad* precio_unitario) AS total_facturado FROM ventas GROUP BY id_producto
)
SELECT id_producto, total_facturado,
CASE 
  WHEN total_facturado > (SELECT AVG(total_facturado) FROM promedios) THEN 'Por encima' 
  WHEN total_facturado <  (SELECT AVG(total_facturado) FROM promedios) THEN 'Por debajo'
  ELSE 'Promedio'
END AS relacion_promedio
FROM promedios;


/* A la hora de evaluar cuánto se facturó por producto, hay diferencias significativas en el top 5 con mayor facturación. Mientras se vendieron 3 unidades del producto con la facturación más alta (id 1- Laptop Pro 15), acumulando $3600,  el producto con menor facturación del top 5, el id 2 (Mouse Inalámbrico) facturó $364 en total por 13 unidades vendidas. Vale mencionar que el Mouse fue el producto más vendido, ya que el resto no superó las 4 unidades de ventas.
Todos los clientes realizaron la misma cantidad de pedidos: 2.
Por último, puede observarse que si se saca un promedio del total facturado por producto, solo el id1 y id3 están por encima del promedio. En ambos casos se vendieron 3 unidades, pero corresponden a los dos productos más caros./*
