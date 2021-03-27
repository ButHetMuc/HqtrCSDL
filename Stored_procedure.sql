use AdventureWorks2008R2
--1
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like '%totaldu%'
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like 'customerid'
go
create proc tongtien
			@thang int , @nam int 
as 
	begin
		select 
			a.CustomerID,
			SumofTotalDue= SUM(b.TotalDue) 
		from
			Sales.Customer a join Sales.SalesOrderHeader b 
		on 
			a.CustomerID = b.CustomerID 
		where
			MONTH(b.OrderDate) = @thang and YEAR(b.OrderDate)=@nam
		group by 
			a.CustomerID
	end
go
--cach chay 1:
exec tongtien 8,2006
go 
--cach 2
declare 
	@nam int , @thang int 
set 
	@nam=2006
set	
	@thang=8
exec tongtien @thang , @nam	
go
--2
select * 
from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like '%salesperson%'
go
create proc TinhDoanhThu 
			@salesperson int , @salesYTD money	output 
as
	begin
		select 
			@salesYTD = SUM(SubTotal)
		from 
			sales.SalesOrderHeader 
		where 
			SalesPersonID = @salesperson
		if 
			@salesYTD >0 
			return 1
		else 
			return 0
	end
go
-- thuc thi lenh 
declare 
	@tongdoanhthu money 

exec TinhDoanhThu 282,@tongdoanhthu output
select @tongdoanhthu as tongdoanhthu
