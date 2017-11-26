--2
SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

--3
SELECT id, title, yr
FROM movie
WHERE title like 'Star Trek%'
ORDER BY yr

--4
SELECT id 
FROM actor
WHERE name = 'Glenn Close'

--5
SELECT id 
FROM movie
WHERE title = 'Casablanca'

--6
SELECT name 
FROM actor JOIN casting ON
actorid = actor.id JOIN movie ON
movie.id = casting.movieid
WHERE title = 'Casablanca'

--7
SELECT name 
FROM actor JOIN casting ON
actorid = actor.id JOIN movie ON
movie.id = casting.movieid
WHERE title = 'Alien'

--8
SELECT title 
FROM actor JOIN casting ON
actorid = actor.id JOIN movie ON
movie.id = casting.movieid
WHERE name = 'Harrison Ford'

--9
SELECT title 
FROM actor JOIN casting ON
actorid = actor.id JOIN movie ON
movie.id = casting.movieid
WHERE name = 'Harrison Ford'
AND ord <> 1

--10
SELECT title, name 
FROM actor JOIN casting ON
actorid = actor.id JOIN movie ON
movie.id = casting.movieid
WHERE yr = 1962
AND ord = 1

--11
SELECT yr,COUNT(title) FROM
movie JOIN casting ON movie.id=movieid
JOIN actor ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title) > 2

--12
SELECT title, name 
FROM actor a JOIN casting c ON
actorid = a.id JOIN movie m ON 
movieid = m.id
WHERE ord = 1 
AND yr >= 1935 --Julie Andrews' birth year
AND title IN (SELECT title FROM movie JOIN casting ON
movieid = movie.id JOIN actor ON actorid = actor.id WHERE name = 'Julie Andrews')

--13
SELECT name
FROM actor JOIN casting ON actorid = actor.id
WHERE ord = 1
GROUP BY name 
HAVING COUNT(*) >= 30
ORDER BY name

--14
SELECT title, COUNT(actorid)
FROM movie JOIN casting ON movie.id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title

--15
SELECT name 
FROM actor JOIN casting ON actor.id = actorid
WHERE movieid IN (SELECT movie.id FROM movie 
JOIN casting ON movie.id = movieid JOIN actor ON actorid = actor.id WHERE name = 'Art Garfunkel')
AND name <> 'Art Garfunkel'
