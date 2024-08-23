-- Cuenta el número de usuarios en la tabla users que tienen un nombre
SELECT COUNT(name) FROM users;

-- Cuenta el número de usuarios en la tabla users que no tienen un email
SELECT COUNT(email) FROM users WHERE email IS NULL;