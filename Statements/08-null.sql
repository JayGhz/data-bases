-- Selecciona los usuarios que no tienen email
SELECT * FROM users WHERE email IS NULL;

-- Selecciona los usuarios que tienen email
SELECT * FROM users WHERE email IS NOT NULL;