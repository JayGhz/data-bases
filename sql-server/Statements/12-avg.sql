-- Obtiene la media de las edades de los usuarios que tienen email
SELECT AVG(age) FROM users WHERE email IS NOT NULL;

-- Obtiene la media de las edades de los usuarios que no tienen email
SELECT AVG(age) FROM users WHERE email IS NULL;