create table Student(Student_ID int identity(1000,10) primary key,
Last_Name varchar(20), First_Name varchar(20), City varchar(20) default 'Santa Monica',
State char(2) default 'CA');

create table Course(Department_Name varchar(20), Course_Number int, 
Course_Name varchar(20), Course_Description text, Credit_Hours int default 3,
primary key(Department_Name,Course_Number));

create table Section(Department_Name varchar(20), Course_Number int, Section_Letter char(1) default 'A',
Classroom varchar(20), Instructor_ID int, primary key(Department_Name,Course_Number,Section_Letter),constraint FK_Course foreign key(Department_Name,Course_Number) 
references Course(Department_Name,Course_Number));

create table Enroll(Department_Name varchar(20), Course_Number int, Section_Letter char(1), Student_ID int foreign key references Student(Student_ID),
primary key(Department_Name,Course_Number,Section_Letter,Student_ID), constraint FK_Section foreign key(Department_Name,Course_Number,Section_Letter)
references Section(Department_Name,Course_Number,Section_Letter));

--Step 2
insert into Student values('Smith','John','Venice','CA'); 
insert into Student (Last_Name,First_Name,City) values('Sanchez','Raul','Bakersfield');
insert into Student values('Levy','Isaac','Phoeniz','AZ'); 
insert into Student values('Wong','Amy','New York','NY'); 

insert into Course values('Computer Science','84','Intro to NodeJS','How to build powerful back-end logic for your website',4);
insert into Course values('History','20','History of Japan','Covers the feudal period up to the present.',4);
insert into Course values('Astronomy','3','Cosmology','Big Bang and the early universe',4);

insert into Section values('Computer Science','84','B','Business 201',1234);
insert into Section values('Computer Science','84','C','Business 192',4321);
insert into Section values('Computer Science','84','D','Business 207',2747);
insert into Section values('History','20','E','Humanities 110',7238);
insert into Section values('History','20','F','Humanities 223',7238);
insert into Section values('History','20','G','Humanities 223',7238);
insert into Section values('Astronomy','3','H','Science 150',8192);
insert into Section values('Astronomy','3','I','Science 340',9476);
insert into Section values('Astronomy','3','J','Science 150',8192);

insert into Enroll values('Computer Science','84','B',1000);
insert into Enroll values('History','20','F',1000);
insert into Enroll values('Astronomy','3','J',1000);

insert into Enroll values('History','20','E',1010);
insert into Enroll values('Astronomy','3','I',1010);

insert into Enroll values('Computer Science','84','D',1020);


--Step 3
alter table Section add Class_Day char(5);
alter table Section add Class_Time varchar(20);

--Step 4

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

select * from Section;
commit tran;


--Step 5

begin tran
delete from Enroll where Department_Name='Computer Science' and Course_Number='84' and Section_Letter='B' and Student_ID=1000;
delete from Enroll where Department_Name='History' and Course_Number='20' and Section_Letter='E' and Student_ID=1010;
select * from Enroll;
rollback tran
select * from Enroll;

--Step 6
begin tran
save tran update_one;
update Enroll set Section_Letter='D' where Student_ID=1000 and Department_Name='Computer Science' and Section_Letter='B' and Course_Number='84';

save tran update_two;
update Enroll set Section_Letter='H' where Student_ID=1000 and Department_Name='Astronomy' and Section_Letter='J' and Course_Number='3';

save tran update_three;
update Enroll set Section_Letter='F' where Student_ID=1010 and Department_Name='History' and Section_Letter='E' and Course_Number='20';
rollback tran update_three;
commit

select * from Enroll;

--Step 7
select Student.Student_ID,Last_Name,First_Name,count(Section_Letter) as Number_Of_Sections,sum(Credit_Hours) as Total_Credits from Student join Enroll on
Student.Student_ID=Enroll.Student_ID join Course on Enroll.Course_Number=Course.Course_Number 
group by Student.Student_ID,First_Name,Last_Name order by Student.Student_ID;

--Step 8
drop table if exists Enroll;
drop table if exists Section;
drop table if exists Course;
drop table if exists Student;
