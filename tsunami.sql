--Step 1
--conditional drop and create

set nocount on;
if exists (select * from dbo.sysobjects
	where id = OBJECT_ID(N'dbo.Tsunami') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.Tsunami;
go

create table Tsunami (radius int, wavetime decimal(6,3));
go

--Step 2
--conditionally drop procedure

if exists (select * from sys.objects where type = 'P' and name = 'calculate_tsunami_waves')
	drop proc calculate_tsunami_waves
go

--create procedure

create proc calculate_tsunami_waves 
(@ocean_depth int, @radius1 int, @radius2 int, @wave_speed decimal(6,3) output, @travel_time decimal(6,3) output)
		as
			--check if bad value is passed in
		   if @ocean_depth < 0 or @radius1 < 0 or @radius2 < 0
		   begin
				print 'Error. Values must be positive.';
				return
			end
			
			--declare and set loop variable and tsunami speed variable
		   declare @i int = 0;
		   set @wave_speed  = sqrt(32.1725 * @ocean_depth) * (60.0/88.0);
			
			--insert values into Tsunami table in loop
		   while @i <= 10000 begin
			  insert into Tsunami values (@i,(@i/@wave_speed));	
			  set @i = @i + 100;
		   end
			
			--declare and set radii hit variables and time between them
		   declare @first_radius_hit decimal(6,3) = (select wavetime from Tsunami where radius = @radius1);
		   declare @second_radius_hit decimal(6,3) = (select wavetime from Tsunami where radius = @radius2);
		   set @travel_time = @second_radius_hit - @first_radius_hit;

		   --output info to screen
			print 'CS61_5_Feigenbaum_Aaron.sql';

			print 'Depth: ' + cast(@ocean_depth as varchar) + ' feet';

			print 'Speed: ' + cast(@wave_speed as varchar) + ' miles per hour';

			print 'First radius: ' + cast(@radius1 as varchar) + ' miles'; 

			print 'Second radius: ' + cast(@radius2 as varchar) + ' miles';

			print 'Tsunami reaches 1st radius at ' + cast(@first_radius_hit as varchar) + ' hours.'; 

			print 'Tsunami reaches 2nd radius at ' + cast(@second_radius_hit as varchar) + ' hours.'; 

			print 'It takes ' + cast(@travel_time as varchar) + ' hours for the tsunami to travel from a radius of ' + cast(@radius1 as varchar) + ' miles to a radius of ' + cast(@radius2 as varchar) + ' miles.';  

			print 'This program was tested 10 times.';
			
go

--run procedure with test variables
declare @depth int = 15088;
declare @radius1 int = 0;
declare @radius2 int = 0;
declare @speed decimal(6,3);
declare @time decimal(6,3);

exec calculate_tsunami_waves @depth, @radius1, @radius2, @wave_speed = @speed output, @travel_time = @time output;

--clear table and conditionally drop
delete from Tsunami;

if exists (select * from dbo.sysobjects
	where id = OBJECT_ID(N'dbo.Tsunami') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.Tsunami;
go
