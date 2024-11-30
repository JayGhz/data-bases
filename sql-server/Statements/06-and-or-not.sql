-- Selecciona todos los usuarios cuyo email termine en gmail.com y su nombre empiece por 'A'
SELECT * FROM users WHERE email LIKE '%gmail.com' AND name LIKE 'A%';

-- Selecciona todos los usuarios cuyo email termine en gmail.com o su nombre empiece por 'A'
SELECT * FROM users WHERE email LIKE '%gmail.com' OR name LIKE 'A%';

-- Selecciona todos los usuarios cuyo email no termine en gmail.com
SELECT * FROM users WHERE email NOT LIKE '%gmail.com';