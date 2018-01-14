-- Insert some data into a table
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800);

-- Insert multiple rows of data into a table
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800),
	   (10, 'Squash Court 2', 3.5, 17.5, 5000, 80);
     
-- Insert calculated data into a table
INSERT INTO cd.facilities 
VALUES ((SELECT facid + 1 FROM cd.facilities ORDER BY facid DESC LIMIT 1), 'Spa', 20, 30, 100000, 800);

-- Update some existing data
UPDATE cd.facilities
SET initialoutlay = 10000 WHERE initialoutlay = 8000;

-- Update multiple rows and columns at the same time
UPDATE cd.facilities
SET membercost = 6, guestcost = 30
WHERE name LIKE '%Tennis Court%';

-- Update a row based on the contents of another row
UPDATE cd.facilities
SET membercost = 1.1 * (SELECT membercost FROM cd.facilities 
					   WHERE facid = 1),
guestcost = 1.1 * (SELECT guestcost FROM cd.facilities WHERE facid = 1)
WHERE facid = 1;

-- Delete all bookings
DELETE FROM cd.bookings;

-- Delete a member from the cd.members table
DELETE FROM cd.members WHERE memid = 37;

-- Delete based on a subquery
DELETE FROM cd.members 
WHERE memid IN (SELECT cd.members.memid FROM cd.members LEFT OUTER JOIN 
cd.bookings ON cd.bookings.memid = cd.members.memid WHERE cd.bookings.memid IS NULL);
