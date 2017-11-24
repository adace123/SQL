--1
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')
      
--2
SELECT name 
FROM world
WHERE gdp/population > 
(SELECT gdp/population FROM world WHERE name = 'United Kingdom')
AND continent = 'Europe'

--3
SELECT name, continent
FROM world
WHERE continent IN (SELECT continent FROM world WHERE name in ('Argentina', 'Australia'))
ORDER BY name

--4
SELECT name, population
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Canada')
AND population < (SELECT population FROM world WHERE name = 'Poland')

--5
SELECT name, CONCAT(ROUND(population/(SELECT population FROM world WHERE name = 'Germany') * 100,0),'%')
FROM world
WHERE continent = 'Europe'

--6
SELECT name 
FROM world
WHERE gdp > ALL(SELECT gdp FROM world WHERE continent = 'Europe' AND gdp > 0)

--7
SELECT continent, name, area FROM world x
WHERE area >= ALL
(SELECT area FROM world y
WHERE y.continent=x.continent
AND area > 0)
          
--8
SELECT a.continent, a.name
FROM world a
WHERE name = (SELECT name FROM world b WHERE a.continent = b.continent LIMIT 1)

--9

--10
SELECT name, continent
FROM world a
GROUP BY continent, population, name
HAVING population >  
ALL(SELECT 3 * population FROM world b WHERE population > 0 AND a.continent = b.continent AND b.name <> a.name)
