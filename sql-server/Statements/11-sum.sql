-- Suma todas las edades de la tabla users
SELECT SUM(age) FROM users;

-- Suma todas las edades de los usuarios que tienen email
SELECT SUM(age) FROM users WHERE email IS NOT NULL;