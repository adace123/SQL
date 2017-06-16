--conditionally drop Major and Student tables
if exists (select * from dbo.sysobjects
	where id = OBJECT_ID(N'dbo.Student') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.Student;
go

if exists (select * from dbo.sysobjects
	where id = OBJECT_ID(N'dbo.Major') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.Major;
go

--create tables
create table Major 
	(MajorCode char(1) primary key, 
	MajorName varchar(20));
go

create table Student 
	(ID int identity(3,3) primary key, 
	LastName varchar(20) not null, 
	DateEnrolled datetime default 'May 12, 2017 12:00 AM',
	MajorCode char(1) null,
	constraint FK_Major foreign key(MajorCode) references Major(MajorCode),
	constraint Check_Last_Name check (LastName like 'Fr%' or LastName like 'Ap%'));
go

--Step 2
begin tran
-- populate Major table
insert into Major values ('A', 'Art'),
						 ('B', 'Biology'),
						 ('C', 'Computer Science'),
						 ('D', 'Dancing'),
						 ('E', 'Etiology');

save tran Populate_Major_Table;

--populate Student table
insert into Student values ('Frankenstein', 'February 1, 2000', 'C'),
						   ('Franklin', 'November 30, 2007', 'E'),
						   ('Freed', 'February 29, 2012', 'C'),
						   ('Frosty', 'May 11, 2017', 'A'),
						   ('Friend', default ,null),
						   ('Frumpy', getdate() + 3.0/(24.0) + 5.0/(24.0 * 60.0), 'B');

save tran Student_Six_Rows_Inserted;

insert into Student values ('Apophis', 'April 13, 2036', 'E');

rollback tran Student_Six_Rows_Inserted;

commit;


--Step 3
--select with where clause, delete with where clause and then rollback
begin tran

select * from Student where MajorCode = 'C' or MajorCode = 'E';

delete from Student where MajorCode = 'C' or MajorCode = 'E';

select * from Student;

rollback tran

select * from Student;

--Step 4
--select majors grouped by # of students
select MajorCode, count(*) as Students_Per_Major from Student group by MajorCode;
go 

--Step 5
--select from joined tables
select * from Major full outer join Student on Major.MajorCode = Student.MajorCode;
go

--Step 6
--create view
create view Student_Major as
	select Major.MajorCode, ID, LastName, DateEnrolled from Major full outer join Student on Major.MajorCode = Student.MajorCode;
go

select * from Student_Major where DateEnrolled > 'January 1, 2010 12:00 AM';
go

--conditionally drop view
if exists (select * from sys.views where name = 'Student_Major' and type = 'v')
	drop view Student_Major;
go

--Step 7 
--create index
create index MajorName_Index on Major(MajorName) 
	with pad_index,
	fillfactor = 1;
go

--drop index
drop index Major.MajorName_Index;
go

--Step 8
--conditionally drop tables
if exists (select * from dbo.sysobjects
	where id = OBJECT_ID(N'dbo.Student') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.Student;
go

if exists (select * from dbo.sysobjects
	where id = OBJECT_ID(N'dbo.Major') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.Major;
go
