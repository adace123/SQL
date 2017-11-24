--1
SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'
  
--2
SELECT id,stadium,team1,team2
  FROM game
WHERE id = 1012

--3
SELECT player,teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
WHERE teamid = 'GER'

--4
SELECT team1, team2, player
  FROM game JOIN goal ON (id=matchid)
WHERE player LIKE 'Mario%'

--5
SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam ON teamid = id
 WHERE gtime <= 10
 
 --6
 
