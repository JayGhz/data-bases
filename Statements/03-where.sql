-- Seleccionar todos los usuarios que tengan 20 años
SELECT * FROM users WHERE age = 20;

-- Seleccionar todos los usuarios que tengan 20 años y sean de la ciudad de 'Buenos Aires'
SELECT * FROM users WHERE age = 20 AND city = 'Buenos Aires';

-- Seleccionar todas las edades de los usuarios que sean de la ciudad de 'Buenos Aires'
SELECT age FROM users WHERE city = 'Buenos Aires';