--batch 
use AdventureWorks2008R2
go
--1
declare @tongsoHD int
select @tongsoHD = COUNT(SalesOrderID) from Sales.SalesOrderDetail
where ProductID=778
if @tongsoHD >500 
	print 'san pham 778 co tren 500 don hang '
else 
	print 'san pham 778 co it don dat hang '
print ' so don dat hang cua 778 la: '+convert(varchar(10),@tongsoHD)
go
--2
select SalesOrderID from Sales.SalesOrderHeader

declare @makh int ,@n int ,@nam int
set @nam=2008
set @makh=43793
select @n= COUNT(SalesOrderID) from Sales.SalesOrderHeader
	where YEAR(OrderDate)=@nam
if @n>0
	print 'khach hang '+ convert(varchar(5),@makh) + 'co' + convert(varchar(5),@n) + 'hoa don trong nam'+ convert(varchar(4),@nam)
else 
	print  'khach hang '+convert(varchar(10),@makh)+'khong mua san pham nao trong nam 2008'
go
--3
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like 'linetotal'


select SalesOrderID , Subtotal = SUM(LineTotal),
	discount = case
			when SUM(LineTotal) < 100000 then 0
			when SUM(LineTotal) <120000 then 0.05*SUM(LineTotal)
			when SUM(LineTotal) <150000 then 0.1*SUM(LineTotal)
			else 0.15*SUM(LineTotal)
			end
		
from Sales.SalesOrderDetail
group by SalesOrderID
--having SUM(linetotal) >100000
go

--4
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like 'onorderqty'

select * from Purchasing.ProductVendor

declare @mancc int ,@masp int ,@soluongcc int 
set @mancc=1650
set @masp =4
select @soluongcc= OnOrderQty from Purchasing.ProductVendor
					where ProductID = @masp and BusinessEntityID = @mancc
if @soluongcc is null
	print 'nha cung cap ' + convert(varchar(5),@mancc) + ' khong cung cap san pham '+ convert(varchar(5),@masp) 
else 
	print 'nha cung cap ' + convert(varchar(5),@mancc) + 'cung cap san pham '+ convert(varchar(5),@masp) + 'voi so luong la ' + convert(varchar(5),@soluongcc)
go
--5
while ( select SUM(Rate) from HumanResources.EmployeePayHistory) <6000
 begin 
	update HumanResources.EmployeePayHistory
		set rate =0.1*Rate
	if(select MAX(Rate) from HumanResources.EmployeePayHistory)>150 
		break
	else 
		continue 
 end
 go
 