
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем
UPDATE users SET created_at, updated_at = NOW();
-- или
INSERT INTO users (created_at, updated_at) VALUES (NOW(), NOW());

-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения
ALTER TABLE users ADD created_at_new DATETIME, updated_at_new DATETIME;
UPDATE users
SET created_at_new = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
    updated_at_new = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
ALTER TABLE users 
    DROP created_at, DROP updated_at, 
    RENAME COLUMN created_at_new TO created_at, RENAME COLUMN updated_at_new TO updated_at;
    
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех     
SELECT VALUE 
FROM (
      SELECT VALUE, IF(VALUE=0, ~0, VALUE) as nol  
      FROM storehouses_products 
      ORDER BY nol
      ) as result;


-- Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
SELECT name 
FROM users 
WHERE DATE_FORMAT(birthday,'%M') in ('may', 'august');

-- Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
SELECT * FROM catalogs 
WHERE id IN (5, 1, 2) 
ORDER BY FIELD (id, 5, 1, 2);


-- Подсчитайте средний возраст пользователей в таблице users
SELECT AVG(age) AS Avg_age
FROM (
      SELECT YEAR(CURRENT_TIMESTAMP) - YEAR(birthday) as age 
      FROM profiles
      );

-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения
SELECT COUNT(*) as stats 
FROM (SELECT DAYOFWEEK(CONCAT(YEAR(NOW()),'-',MONTH(birthday),'-',DAYOFMONTH(birthday))) as date from profiles) as stats WHERE date=1;
-- где date=1 для понедельника, date=2 для вторника и т.д

