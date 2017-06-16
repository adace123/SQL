--conditionally all objects and begin transactions
if exists(select * from dbo.sysobjects where id = OBJECT_ID(N'dbo.Employee') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.Employee;
go

if exists(select * from sys.objects where type = 'V' and name = 'EmployeeLastNames')
	drop view EmployeeLastNames;
go

if exists(select * from sys.objects where type = 'P' and name = 'Check_Employee_LastName_ID')
	drop proc Check_Employee_LastName_ID;
go

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'dates') AND xtype IN (N'FN', N'IF', N'TF'))
    DROP FUNCTION dates
GO

begin tran;

--create Employee table

create table Employee
	(
	id int identity, Lastname varchar(50), Firstname varchar(50), DateOfEmployment datetime, IDspouse int,
	constraint PK_Employee primary key(id),
	constraint FK_Employee foreign key(IDspouse) references Employee(id),
	constraint Check_Month check (month(DateOfEmployment) in ('May','June','5','6'))
	);
go

--populate table

insert into Employee values 
('Her', 'Barry', 'May 29, 2017 12 am', 2),
('Her', 'Mary', 'June 8, 2017 12 pm', 1),
('Me', 'Max', 'June 8, 2017 6:45 pm', 4),
('Me', 'Min', 'June 30, 2017 9:50 pm', 3),
('It', 'Thin', getdate(), null);

--show all rows from Employee table and commit
select * from Employee;
commit;

--Step 3
--self join Employee table and output marriages
select E1.Firstname + ' ' + E1.Lastname + ' is married to ' + E2.Firstname + ' ' + E2.Lastname as Marriages
from Employee E1 join Employee E2 on E1.id = E2.IDspouse 
where E1.IDspouse is not null and E2.IDspouse is not null;

--Step 4

--4a
--select last names, how many employees have that last name and last name character counts
select Lastname, count(Lastname) as Lastname_Count, len(Lastname) as Lastname_Length
from Employee group by Lastname;
go

--4b
--create view based on 4a
create view EmployeeLastNames(Lname, Lname_Count, Lname_Length)
as
select Lastname, count(Lastname) as Lastname_Count, len(Lastname) as Lastname_Length
from Employee group by Lastname;
go

--4c
--select from view 
select * from EmployeeLastNames;

--4d
--conditionally drop view
if exists(select * from sys.objects where type = 'V' and name = 'EmployeeLastNames')
	drop view EmployeeLastNames;
go

--Step 5
--declare loop variables
declare @i int = 65;
declare @letter_string varchar(30);
declare @j int = 0;

--start loops
while @i < 91 begin
	set @letter_string = '';
	set @j = 26;
	while @j >= 91-@i begin
		set @letter_string = concat(@letter_string, char(@i));
		set @j = @j - 1;
	end
	set @i=@i+1;
	print @letter_string;
end
go

--Step 6
--6a: create procedure
create proc Check_Employee_LastName_ID (@ID int, @num_employees int output) as
	set @num_employees = (select count(*) from Employee where Lastname = (select Lastname from Employee where id = @ID));	
	select @num_employees as Num_Employees_Matching_Lastname;
go

--6b: set output variable and test procedure with it

declare @result int;
exec Check_Employee_LastName_ID 2, @num_employees = @result;
exec Check_Employee_LastName_ID 5, @num_employees = @result;
exec Check_Employee_LastName_ID 6, @num_employees = @result;

--6c: conditionally drop procedure
if exists(select * from sys.objects where type = 'P' and name = 'Check_Employee_LastName_ID')
	drop proc Check_Employee_LastName_ID;
go

--Step 7
--7a: create function
create function dates(@date_input datetime) returns table as 
	return (select * from Employee where DateOfEmployment < @date_input);
go

--7b: test function
declare @present_datetime datetime = getdate();
select * from dates('June 8, 2017 3:00 pm');
select * from dates(@present_datetime);

--7c: conditionally drop function
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'dates') AND xtype IN (N'FN', N'IF', N'TF'))
    DROP FUNCTION dates
GO

--Step 8
--conditionally drop table
if exists(select * from dbo.sysobjects where id = OBJECT_ID(N'dbo.Employee') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.Employee;
go
