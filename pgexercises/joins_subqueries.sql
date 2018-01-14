-- Retrieve the start times of members' bookings
SELECT starttime FROM cd.bookings NATURAL JOIN cd.members 
WHERE surname = 'Farrell' AND firstname = 'David';

-- Work out the start times of bookings for tennis courts
SELECT starttime AS start, name FROM cd.bookings NATURAL JOIN cd.facilities 
WHERE DATE(starttime) = '2012-09-21' AND name LIKE 'Tennis%' ORDER BY starttime;

-- Produce a list of all members who have recommended another member
SELECT DISTINCT A.firstname, A.surname FROM cd.members A
JOIN cd.members B ON A.memid = B.recommendedby 
ORDER BY surname, firstname;

-- Produce a list of all members, along with their recommender
SELECT A.firstname AS memfname, A.surname AS memsname, B.firstname AS recfname, B.surname AS recsname 
FROM cd.members A 
LEFT JOIN cd.members B ON A.recommendedby = B.memid
ORDER BY A.surname, A.firstname;

-- Produce a list of all members who have used a tennis court
SELECT DISTINCT firstname || ' ' || surname AS member, name FROM cd.members
NATURAL JOIN cd.bookings NATURAL JOIN cd.facilities
WHERE name LIKE 'Tennis%' ORDER BY member;

-- Produce a list of costly bookings
SELECT firstname || ' ' || surname AS member, name AS facility,
CASE WHEN memid = 0 AND guestcost * slots > 30 THEN guestcost * slots WHEN memid != 0 AND membercost * slots > 30 
THEN membercost * slots END AS cost
FROM cd.members NATURAL JOIN cd.bookings NATURAL JOIN cd.facilities
WHERE DATE(starttime) = '2012-09-14' 
AND ((memid = 0 AND guestcost * slots > 30) OR (memid != 0 AND membercost * slots > 30))
ORDER BY cost DESC;

-- Produce a list of all members, along with their recommender, using no joins.
SELECT DISTINCT firstname || ' ' || surname AS member,
(SELECT firstname || ' ' || surname FROM cd.members b WHERE
a.recommendedby = b.memid) AS recommender
FROM cd.members a
ORDER BY member;

-- Produce a list of costly bookings, using a subquery
SELECT firstname || ' ' || surname AS member, name AS facility,
CASE WHEN memid = 0 AND guestcost * slots > 30 THEN guestcost * slots
WHEN memid != 0 AND membercost * slots > 30 THEN membercost * slots END AS cost
FROM (SELECT * FROM cd.members NATURAL JOIN cd.bookings NATURAL JOIN cd.facilities
	 WHERE (memid = 0 AND guestcost * slots > 30) OR (memid != 0 AND membercost * slots > 30)) joined
WHERE DATE(starttime) = '2012-09-14'
ORDER BY cost DESC;
