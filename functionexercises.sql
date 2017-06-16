IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'findRepByLetter') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION findRepByLetter
GO

IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'selectQuantity') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION selectQuantity
GO

create function findRepByLetter(@letter char(1))
	 returns table as
	 
	 return(select * from Representative where Last_Name like concat('%',@letter,'%')); 
	 --could also do where Last_Name like substring(@letter,0,2)
 go

select * from findRepByLetter('R');
go 

create function selectQuantity(@quantity int)
	returns table as

	return (select Item_Number, Description from Inventory where Quantity_On_Hand <= @quantity);
go

select * from selectQuantity(500);
go
