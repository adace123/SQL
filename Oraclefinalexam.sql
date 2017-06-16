
drop table FAJ_Course

create table FAJ_Course (Course_Number char(4),Course_Name varchar2(50))

declare 
con_today constant date:=sysdate; 
var_fullname varchar2(30):='Aaron Feigenbaum'; 
var_Course_Name varchar2(40); 
var_rowcount number(1):=0; 
var_reversed_fullname varchar2(30); 
--var_sub_count is used to loop through var_fullname 
var_sub_count number(30):=length(var_fullname); 
 
begin 
dbms_output.enable; 
dbms_output.put_line('The datetime today is: '||con_today); 
 
--inserting specified rows 
insert into FAJ_Course values ('CS60','Database Concepts and Applications'); 
insert into FAJ_Course values ('CS61','Microsoft SQL Server Database'); 
insert into FAJ_Course values ('CS65','Oracle Programming'); 
 
--var_Course_Name becomes 'Database Concepts and Application' 
select Course_Name into var_Course_Name from FAJ_Course where Course_Number = 'CS60'; 
--print the variable 
dbms_output.put_line(var_Course_Name); 
--var_rowcount holds the number of rows in the table 
select count(*) into var_rowcount from FAJ_Course; 
--print the number of rows 
dbms_output.put_line('There are '||TO_CHAR(var_rowcount)||' rows in the table.'); 
 
--start loop 
for i in reverse 1..length(var_fullname) loop 
--start with the length of the fullname and assign the substring from its last character to the character just before it to var_reversed_fullname 
var_reversed_fullname := var_reversed_fullname || substr(var_fullname,var_sub_count,1); 
--decrement the counter 
var_sub_count:=var_sub_count-1; 
--end loop 
end loop; 
--print the reversed_fullname 
dbms_output.put_line(var_reversed_fullname); 
end; 
