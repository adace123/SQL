--Step 1
--conditionally drop tables, create tables and insert data
if exists (select * from dbo.sysobjects 
  where id = object_id(N'dbo.Enroll') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.Enroll;
GO

if exists (select * from dbo.sysobjects 
  where id = object_id(N'dbo.Section') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.Section;
GO

if exists (select * from dbo.sysobjects 
  where id = object_id(N'dbo.Course') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.Course;
GO

if exists (select * from dbo.sysobjects 
  where id = object_id(N'dbo.Student') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.Student;
GO

create table Student(Student_ID int identity(2000,20) primary key,
Last_Name varchar(20), First_Name varchar(20), City varchar(20) default 'Santa Monica',
State char(2) default 'CA');

create table Course(Department_Name varchar(20), Course_Number int, 
Course_Name varchar(30), Course_Description text, Credit_Hours int default 3,
primary key(Department_Name,Course_Number));

create table Section(Department_Name varchar(20), Course_Number int, Section_Letter char(1) default 'A',
Classroom varchar(20), Instructor_ID int, primary key(Department_Name,Course_Number,Section_Letter),constraint FK_Course foreign key(Department_Name,Course_Number) 
references Course(Department_Name,Course_Number));

create table Enroll(Department_Name varchar(20), Course_Number int, Section_Letter char(1), Student_ID int foreign key references Student(Student_ID),
primary key(Department_Name,Course_Number,Section_Letter,Student_ID), constraint FK_Section foreign key(Department_Name,Course_Number,Section_Letter)
references Section(Department_Name,Course_Number,Section_Letter));

insert into Student values('Smith','John','Venice','CA');
insert into Student (Last_Name,First_Name,City) values('Sanchez','Raul','Bakersfield');
insert into Student values
('Levy','Isaac','Phoeniz','AZ'), 
('Wong','Amy','New York','NY'); 

insert into Course values
('Computer Science','84','Intro to NodeJS','How to build powerful back-end logic for your website',4),
('History','20','History of Japan','Covers the feudal period up to the present.',4),
('Astronomy','3','Cosmology','Big Bang and the early universe',4);

insert into Section values
('Computer Science','84','B','Business 201',1234),
('Computer Science','84','C','Business 192',4321),
('Computer Science','84','D','Business 207',2747),
('History','20','E','Humanities 110',7238),
('History','20','F','Humanities 223',7238),
('History','20','G','Humanities 223',7238),
('Astronomy','3','H','Science 150',8192),
('Astronomy','3','I','Science 340',9476),
('Astronomy','3','J','Science 150',8192);

insert into Enroll values
('Computer Science','84','B',2000),
('History','20','F',2000),
('Astronomy','3','J',2000),
('History','20','E',2020),
('Astronomy','3','I',2020),
('Computer Science','84','D',2040);

alter table Section add Class_Day char(7);
alter table Section add Class_Time varchar(20);

begin tran
update Section set Class_Day='MW' where Department_Name='Computer Science' and Course_Number='84' and Section_Letter='B';
update Section set Class_Time='12:00-1:45' where Department_Name='Computer Science' and Course_Number='84' and Section_Letter='B';

update Section set Class_Day='TTh' where Department_Name='Computer Science' and Course_Number='84' and Section_Letter='C';
update Section set Class_Time='12:00-1:45' where Department_Name='Computer Science' and Course_Number='84' and Section_Letter='C';

update Section set Class_Day='F' where Department_Name='Computer Science' and Course_Number='84' and Section_Letter='D';
update Section set Class_Time='9:00-12:00' where Department_Name='Computer Science' and Course_Number='84' and Section_Letter='D';

update Section set Class_Day='MW' where Department_Name='History' and Course_Number='20' and Section_Letter='E';
update Section set Class_Time='12:00-1:45' where Department_Name='History' and Course_Number='20' and Section_Letter='E';

update Section set Class_Day='TTh' where Department_Name='History' and Course_Number='20' and Section_Letter='F';
update Section set Class_Time='12:00-1:45' where Department_Name='History' and Course_Number='20' and Section_Letter='F';

update Section set Class_Day='F' where Department_Name='History' and Course_Number='20' and Section_Letter='G';
update Section set Class_Time='9:00-12:00' where Department_Name='History' and Course_Number='20' and Section_Letter='G';

update Section set Class_Day='MW' where Department_Name='Astronomy' and Course_Number='3' and Section_Letter='H';
update Section set Class_Time='12:00-1:45' where Department_Name='Astronomy' and Course_Number='3' and Section_Letter='H';

update Section set Class_Day='TTh' where Department_Name='Astronomy' and Course_Number='3' and Section_Letter='I';
update Section set Class_Time='12:00-1:45' where Department_Name='Astronomy' and Course_Number='3' and Section_Letter='I';

update Section set Class_Day='F' where Department_Name='Astronomy' and Course_Number='3' and Section_Letter='J';
update Section set Class_Time='9:00-12:00' where Department_Name='Astronomy' and Course_Number='3' and Section_Letter='J';

commit tran;

begin tran

save tran update_one;
update Enroll set Section_Letter='D' where Student_ID=1000 and Department_Name='Computer Science' and Section_Letter='B' and Course_Number='84';

save tran update_two;
update Enroll set Section_Letter='H' where Student_ID=1000 and Department_Name='Astronomy' and Section_Letter='J' and Course_Number='3';

save tran update_three;
update Enroll set Section_Letter='F' where Student_ID=1010 and Department_Name='History' and Section_Letter='E' and Course_Number='20';

rollback tran update_three;
commit

--Step 2
--info for students who are enrolled in one or more sections
select Student.Student_ID, Last_Name, First_Name, Course.Course_Name, Course.Department_Name, Course.Course_Number, Section.Section_Letter from Student 
join Enroll on Student.Student_ID = Enroll.Student_ID
join Course on Enroll.Department_Name = Course.Department_Name
join Section on Enroll.Section_Letter = Section.Section_Letter
order by Student.Student_ID;

--Step 3
--info for students enrolled in zero or more sections
select Student.Student_ID, Last_Name, First_Name, Course.Course_Name, Course.Department_Name, Course.Course_Number, Section.Section_Letter from Enroll
join Course on Enroll.Department_Name = Course.Department_Name
join Section on Section.Section_Letter = Enroll.Section_Letter
right outer join Student on Enroll.Student_ID = Student.Student_ID
order by Student.Student_ID;

--Step 4
--insert one course with no sections 
insert into Course values('Computer Science',12,'Advanced Java Programming','Multithreading, generics, FX and more',4);
insert into Course values('Computer Science',31,'NoSQL Databases','Non-relational databases with MongoDB',4);
--second new course has a section but no students enrolled
insert into Section values('Computer Science','31','K','Business 207',9876,'M','6:45-9:50');

--Step 5
--list of all students enrolled in zero or more sections, all courses with zero or more sections and all sections with zero or more students enrolled
select Student.Student_ID, Student.First_Name, Student.Last_Name, Course.Course_Name, Section.Section_Letter
from Student full outer join Enroll on Student.Student_ID = Enroll.Student_ID
full outer join Section on Enroll.Section_Letter = Section.Section_Letter
full outer join Course on Section.Course_Number = Course.Course_Number;
go
--Step 6
--conditional drop and creation of view to select student first name and last name
if exists(select * from sys.views where name='Student_Names' and type='v')
drop view Student_Names
go

create view Student_Names
as
select First_Name,Last_Name from Student;
go

select * from Student_Names;

--Step 7
--conditional drop and creation of view to list student info
if exists(select * from sys.views where name='Student_Enrollment' and type='v')
drop view Student_Enrollment
go

create view Student_Enrollment
as 
select Student.Student_ID, Student.First_Name+' '+Student.Last_Name+', Student' as Student_Info, Department_Name,Course_Number,Section_Letter from Student
full outer join Enroll on Enroll.Student_ID = Student.Student_ID;
go

select * from Student_Enrollment;

--Step 8
--conditionally drop tables
if exists (select * from dbo.sysobjects 
  where id = object_id(N'dbo.Enroll') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.Enroll;
GO

if exists (select * from dbo.sysobjects 
  where id = object_id(N'dbo.Section') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.Section;
GO

if exists (select * from dbo.sysobjects 
  where id = object_id(N'dbo.Course') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.Course;
GO

if exists (select * from dbo.sysobjects 
  where id = object_id(N'dbo.Student') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.Student;
GO
