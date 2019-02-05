SELECT 'ФИО: Устинова Т.А.';

-- Часть 1
-- исключаем записи, где мах(рейтинг) - мин(рейтинг) = 0 1) пользователь поставил оценку только 1 фильму 2) все оценки пользователя одинаковые

WITH help_table 
as
(SELECT
    userid,
	MAX(rating) - MIN(rating)
FROM public.ratings
GROUP BY userid
HAVING (MAX(rating) - MIN(rating)) > 0)
SELECT ratings.userId, ratings.movieId,
AVG(rating) OVER (PARTITION BY ratings.userId) as avg_rating,
(rating - MIN(rating) OVER (PARTITION BY ratings.userId))/(MAX(rating) OVER (PARTITION BY ratings.userId) - MIN(rating) OVER (PARTITION BY ratings.userId)) as normed_rating
FROM public.ratings
JOIN help_table
ON  ratings.userid=help_table.userid
WHERE ratings.userId > 2
ORDER BY userId, normed_rating desc 
LIMIT 30;

-- Часть 2

-- Создали таблицу и загрузили в нее данные
CREATE TABLE IF NOT EXISTS keywords1 (id bigint, tags text);

\copy public.keywords1 FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER
  
  -- запрос 1
  
-- SELECT movieId, 
	-- AVG(rating) as avg_rating
-- FROM public.ratings
-- GROUP BY movieId
-- HAVING COUNT(rating) > 50
-- ORDER BY avg_rating DESC, movieId ASC 
-- LIMIT 150;
 
 -- запрос 2
 
 -- WITH top_rated 
 -- as 
 --(SELECT movieId, 
	-- AVG(rating) as avg_rating
-- FROM public.ratings
-- GROUP BY movieId
-- HAVING COUNT(rating) > 50
-- ORDER BY avg_rating DESC, movieId ASC)
-- SELECT keywords1.tags, keywords1.id as movieId, top_rated.avg_rating FROM public.keywords1 -- ввели столбец со средним рейтингом фильма
-- JOIN top_rated
-- ON top_rated.movieId = keywords1.id
-- ORDER BY top_rated.avg_rating desc -- по условиям задания разместили по убыванию рейтинга
-- LIMIT 10;

-- запрос 3

WITH top_rated 
 as 
 (SELECT ratings.movieId, 
	AVG(ratings.rating) as avg_rating
FROM public.ratings
GROUP BY ratings.movieId
HAVING COUNT(ratings.rating) > 50
ORDER BY avg_rating DESC, ratings.movieId ASC)
SELECT keywords1.tags, keywords1.id as movieId, top_rated.avg_rating INTO top_rated_tags1 FROM public.keywords1
JOIN top_rated
ON top_rated.movieId = keywords1.id
ORDER BY top_rated.avg_rating desc
LIMIT 10;

-- сохранили в директорию /usr/local/share/netology/raw_data/ к csv файлам

\copy (SELECT * FROM public.top_rated_tags) to '/usr/local/share/netology/raw_data/top_rated_tags1.csv' with delimiter as E'\t'
