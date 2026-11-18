IF DB_ID('Ventas_Tech_DB') IS NULL
    CREATE DATABASE Ventas_Tech_DB;
GO
USE Ventas_Tech_DB;
GO

-- 1. DROP
-- Primero las tablas que tienen FK, al final las que son referenciadas
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS zona;
DROP TABLE IF EXISTS pais;


-- 2. CREATE

-- 2.1 Tabla zona (va antes de clientes porque clientes la referencia)
CREATE TABLE zona (
id_zona INT PRIMARY KEY,
nombre_zona VARCHAR(50) NOT NULL
);

-- 2.2 Tabla categorias
CREATE TABLE categorias (
id_categoria INT PRIMARY KEY,
nombre_categoria VARCHAR(50) NOT NULL,
descripcion VARCHAR(200)
);

-- 2.3 Tabla clientes, con la FK a zona
CREATE TABLE clientes (
id_cliente INT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
ciudad VARCHAR(50),
fecha_registro DATE NOT NULL,
id_zona INT,

CONSTRAINT FK_clientes_id_zona FOREIGN KEY(id_zona) REFERENCES zona(id_zona)
);

-- 2.4 Tabla productos, con la FK a categorias
CREATE TABLE productos (
id_producto INT PRIMARY KEY,
nombre_producto VARCHAR(100) NOT NULL,
id_categoria INT,
precio DECIMAL(10,2) NOT NULL,
stock INT DEFAULT 0,
activo BIT DEFAULT 1,

CONSTRAINT FK_productos_id_categoria FOREIGN KEY(id_categoria) REFERENCES categorias(id_categoria)
);

-- 2.5 Tabla ventas, con las FK a clientes y productos
CREATE TABLE ventas (
id_venta INT PRIMARY KEY,
id_cliente INT,
id_producto INT,
cantidad INT NOT NULL,
precio_unitario DECIMAL(10,2) NOT NULL,
fecha_venta DATE NOT NULL,

CONSTRAINT FK_ventas_id_cliente FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente),
CONSTRAINT FK_ventas_id_producto FOREIGN KEY(id_producto) REFERENCES productos(id_producto)
);

-- 3. INSERT

-- 3.1 Zonas (antes que clientes, porque clientes las referencia)
INSERT INTO zona (id_zona, nombre_zona) VALUES
  (1, 'Norte'),
  (2, 'Sur'),
  (3, 'Centro'),
  (4, 'Oeste'),
  (5, 'Este');

-- 3.2 Categorias
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
  (1, 'Computación',    'Laptops, PCs y monitores'),
  (2, 'Accesorios',     'Periféricos y complementos'),
  (3, 'Audio',          'Auriculares y parlantes'),
  (4, 'Almacenamiento', 'Discos y memorias');

-- 3.3 Clientes (la última columna es id_zona: ajustala según la consigna)
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro, id_zona) VALUES
  (1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05', 5),
  (2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10', 3),
  (3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01', 3),
  (4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15', 4),
  (5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01', 1);

  -- CUANDO AGREGUE ID-ZONA PARA HACER EL TP5 SE ME ROMPIO LA NORMALIZACION N3F 
  -- PORQUE ID_ZONA SE VINCULA CON CIUDAD DIRECTAMENTE
  -- SI USO ESTA BASE DEBERIA NORMALIZAR CIUDADES O SACAR EL CRITERIO

-- 3.4 Productos
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
  (1, 'Laptop Pro 15',      1, 1200.00, 15, 1),
  (2, 'Mouse Inalámbrico',  2,   28.00, 80, 1),
  (3, 'Monitor 4K 27',      1,  450.00, 12, 1),
  (4, 'Auriculares BT Pro', 3,  120.00, 35, 1),
  (5, 'SSD Externo 1TB',    4,  130.00, 18, 1),
  (6, 'Teclado Mecánico',   2,   95.00, 40, 1);

-- 3.5 Ventas
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
  ( 1, 1, 1, 2, 1200.00, '2024-03-05'),
  ( 2, 2, 2, 5,   28.00, '2024-03-06'),
  ( 3, 3, 3, 1,  450.00, '2024-03-07'),
  ( 4, 1, 4, 2,  120.00, '2024-03-08'),
  ( 5, 4, 5, 3,  130.00, '2024-03-10'),
  ( 6, 2, 6, 4,   95.00, '2024-03-11'),
  ( 7, 5, 1, 1, 1200.00, '2024-03-12'),
  ( 8, 3, 2, 8,   28.00, '2024-03-13'),
  ( 9, 4, 4, 1,  120.00, '2024-03-14'),
  (10, 5, 3, 2,  450.00, '2024-03-15');

-- 4. VALIDACIÓN
SELECT * FROM zona;
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;