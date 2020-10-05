-- 2)Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользоваетелем.
SELECT (SELECT name + ' '+ surname from users WHERE id = best_friend_id) as best_fiend,
        MAX(messages_qty) as messages_qty 
FROM (
SELECT best_friend_id, COUNT(*) as messages_qty FROM (
	SELECT to_user_id as best_friend_id FROM messages WHERE from_user_id = 1
	union all
	SELECT from_user_id  FROM messages WHERE to_user_id = 1
) as T
GROUP BY best_friend_id
) as FD 
GROUP BY best_fiend
ORDER BY  messages_qty desc
LIMIT 1;

-- 3) Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT COUNT(user_id) FROM (
	SELECT user_id, (SELECT birthday 
                     FROM users as u 
					 WHERE u.user_id = l.user_id) as birthday
	FROM likes_posts as l
    ORDER BY birthday desc 
    LIMIT 10
) as tl;

-- 4) Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT sex FROM (
SELECT sex, COUNT((SELECT COUNT(*) FROM likes_posts l where l.user_id = p.user_id)) as likes_count FROM profiles p
WHERE sex = 'm'
GROUP BY sex
UNION all
SELECT sex, COUNT((SELECT COUNT(*) FROM likes_posts l where l.user_id = p.user_id)) FROM profiles p
WHERE sex = 'f'
GROUP BY sex
) as T
GROUP BY sex
ORDER BY MAX(likes_count) desc
LIMIT 1;


-- 5) Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
SELECT (SELECT name + ' '+ surname FROM users where id = user_id) as fullname,  SUM(total.m) as activity
FROM(
	SELECT from_user_id as user_id, COUNT(*) as m  FROM messages
	GROUP BY from_user_id
	UNION all
	SELECT user_id, COUNT(*)  FROM likes_posts
	GROUP BY user_id
	UNION all
	SELECT initiator_user_id, COUNT(*)  FROM friend_requests
	GROUP BY initiator_user_id
	UNION all
	SELECT from_user_id, COUNT(*)  FROM messages
	GROUP BY from_user_id
	UNION all
	SELECT user_id, COUNT(*)  FROM users_communities
	GROUP BY user_id
) as total
GROUP BY fullname
ORDER BY activity
LIMIT 10;