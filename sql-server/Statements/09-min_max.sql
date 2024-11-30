-- Selecionar el usario de mayor edad y el de menor edad
SELECT * FROM users
WHERE edad = (SELECT MAX(edad) FROM users)
OR edad = (SELECT MIN(edad) FROM users);