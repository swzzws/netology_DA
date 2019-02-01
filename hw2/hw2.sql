SELECT 'ФИО: Устинова Т.А.';

-- запрос 1.1

SELECT * FROM public.ratings LIMIT 10;

-- запрос 1.2

SELECT *
FROM public.links
WHERE
imdbid LIKE '%42'
AND
(movieid > 100 AND movieid < 1000)
LIMIT 10;

-- запрос 2.1

SELECT 
links.imdbid
FROM public.links
JOIN public.ratings
    ON links.movieid=ratings.movieid
WHERE 
ratings.rating=5
LIMIT 10;

-- запрос 3.1

SELECT
    COUNT (DISTINCT movieid)
FROM public.ratings
WHERE rating IS NULL;

-- запрос 3.2

SELECT
    userid,
    AVG(rating) as avg_rating
FROM public.ratings
GROUP BY userid
HAVING AVG(rating) >= 3.5
ORDER BY AVG(rating) DESC -- располагаем пользователей в порядке убывания среднего рейтинга
LIMIT 10;

-- Т.к в табл. получили, набор значейний где у всех пользователей средний рейтинг =5, проверяем сколько всего пользователей имеют рейтинг > = 5, получили, что 109.

WITH tmp_table
as
(SELECT
    userid,
    AVG(rating)
FROM public.ratings
GROUP BY userid
HAVING AVG(rating) >= 5)
SELECT
    count(userid)
FROM tmp_table;

-- запрос 4.1

WITH avrrat_table 
as
(SELECT
    movieid,
    AVG(rating)
FROM public.ratings
GROUP BY movieid
HAVING AVG(rating) >= 3.5) -- создали вспом. табл., где рассчитаны средние рейтинги фильмов, и они > = 3.5 
SELECT
    links.imdbid
FROM public.links
JOIN avrrat_table
ON  links.movieid=avrrat_table.movieid -- из табл. links выбрали те imdbid, у которых movieid совпали с аналогичным полем из вспомог. табл.
LIMIT 10;

-- запрос 4.2

WITH useractiv_table
as
(SELECT
    userid,
    COUNT(rating) as count_term,
    SUM(rating) as sum_rating
FROM public.ratings
GROUP BY userid
HAVING COUNT(rating) >= 10) -- создали вспом. табл., куда попали пользователи с кол-вом оценок > =10 и посчитаны сумма их рейтингов, кол-во оценок
SELECT
(SUM(sum_rating))/(SUM(count_term)) -- посчитали средний рейтинг у всех этих пользователей
FROM useractiv_table;

--запрос 4.2 способ 2

WITH useractiv_table 
as
(SELECT
    userid,
    COUNT(rating)
FROM public.ratings
GROUP BY userid
HAVING COUNT(rating) >= 10)
SELECT
    AVG(rating)
FROM public.ratings
JOIN useractiv_table
ON  ratings.userid=useractiv_table.userid;







