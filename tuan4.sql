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
declare @makh int ,@n int ,@nam int
set @nam=2008
select @n= COUNT(SalesOrderID) from Sales.SalesOrderHeader
	where YEAR(OrderDate)=@nam
if @n>0
	print 'khach hang '+convert(varchar(20),@makh)+'co'+convert(varchar(10),@n)+'hoa don trong nam'+convert(varchar(4),@nam)
else 
	print  'khach hang '+convert(varchar(20),@makh)+'khong mua san pham nao trong nam 2008'