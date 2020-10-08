 -- 1) Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине
 SELECT name FROM users WHERE id in (SELECT user_id FROM orders);


-- 2) Выведите список товаров products и разделов catalogs, который соответствует товару
SELECT p.name as product_name, c.name as product_type 
  FROM products p 
  LEFT JOIN catalogs c
    ON p.catalog_id = c.id;

-- 3)  Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов
SELECT f.id, f.from, f.to
  FROM flights f
  LEFT JOIN cities c
    ON c.label = f.from
  LEFT JOIN c
    ON c.label = f.to