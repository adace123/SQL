-- Count the number of facilities
SELECT COUNT(*) FROM cd.facilities;

-- Count the number of expensive facilities
SELECT COUNT(*) FROM cd.facilities WHERE guestcost >= 10;

-- Count the number of recommendations each member makes.
SELECT B.recommendedby, COUNT(B.recommendedby) FROM cd.members A
JOIN cd.members B ON A.memid = B.recommendedby
GROUP BY B.recommendedby, A.memid
ORDER BY A.memid;

-- List the total slots booked per facility
SELECT facid, SUM(slots)
FROM cd.facilities NATURAL JOIN cd.bookings
GROUP BY facid
ORDER BY facid;

-- List the total slots booked per facility in a given month
SELECT facid, SUM(slots) AS "Total Slots"
FROM cd.facilities NATURAL JOIN cd.bookings
WHERE DATE_PART('month', starttime) = 9 AND DATE_PART('year', starttime) = 2012
GROUP BY facid, DATE_PART('month', starttime)
ORDER BY "Total Slots";

-- List the total slots booked per facility per month
SELECT facid, DATE_PART('month', starttime) as month, SUM(slots) AS "Total Slots"
FROM cd.facilities NATURAL JOIN cd.bookings
WHERE DATE_PART('year', starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;

-- Find the count of members who have made at least one booking 
SELECT COUNT(*)
FROM cd.members
WHERE memid IN (SELECT cd.members.memid FROM cd.members NATURAL JOIN cd.bookings);

-- List facilities with more than 1000 slots booked
SELECT facid, SUM(slots) AS "Total Slots"
FROM cd.facilities NATURAL JOIN cd.bookings
GROUP BY facid HAVING SUM(slots) > 1000
ORDER BY facid;

-- Find the total revenue of each facility
SELECT name, 
SUM(CASE WHEN memid = 0 THEN guestcost * slots WHEN memid > 0 THEN membercost * slots END) AS revenue
FROM cd.facilities NATURAL JOIN cd.bookings
GROUP BY facid
ORDER BY revenue;

-- Find facilities with a total revenue less than 1000
SELECT name, revenue
FROM (SELECT name, SUM(CASE WHEN memid = 0 THEN guestcost * slots WHEN memid > 0 THEN membercost * slots END) AS revenue
FROM cd.bookings NATURAL JOIN cd.facilities
	 GROUP BY name) joined
WHERE revenue < 1000
ORDER BY revenue;

-- Output the facility id that has the highest number of slots booked
WITH a as (SELECT facid, SUM(slots) as total FROM cd.bookings GROUP BY facid)
SELECT facid, total FROM a GROUP BY facid, total HAVING total = (SELECT MAX(total) FROM a);

-- List the total slots booked per facility per month, part 2
WITH results AS (SELECT facid, DATE_PART('month', starttime) AS month, SUM(slots) as slots
				FROM cd.bookings 
				 WHERE DATE_PART('year', starttime) = 2012
				 GROUP BY facid, DATE_PART('month', starttime)
				)
SELECT * FROM results UNION SELECT facid, NULL, SUM(slots) FROM results GROUP BY facid
UNION SELECT NULL, NULL, SUM(slots) FROM results
ORDER BY facid, month ;

-- List the total hours booked per named facility
SELECT facid, name, 
ROUND(SUM(slots)::DECIMAL / 2, 2) as "Total Hours" FROM cd.bookings 
NATURAL JOIN cd.facilities
GROUP BY facid, name
ORDER BY facid;

-- List each member's first booking after September 1st 2012

