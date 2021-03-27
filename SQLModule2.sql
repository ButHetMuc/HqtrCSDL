use AdventureWorks2008R2
go
--1
select * from Sales.SalesOrderDetail
select * from Sales.SalesOrderHeader
--
select a.SalesOrderID,OrderDate ,SubTotal = SUM(b.OrderQty*b.UnitPrice) 
from Sales.SalesOrderHeader a join Sales.SalesOrderDetail b
on a.SalesOrderID=b.SalesOrderID
where YEAR(a.OrderDate)=2008 and MONTH(OrderDate)=6
group by a.SalesOrderID,OrderDate
having SUM(b.OrderQty*b.UnitPrice) > 70000

go
--2
select * from [Sales].[SalesTerritory]
select * from Sales.SalesOrderDetail
select * from Sales.SalesOrderHeader
select * from Sales.Customer

-- so khach hang co ma vung la us , nhom' cac' khach hang co cung CountryRegionCode , sau do' dem' 
select sokh = COUNT(b.TerritoryID),b.TerritoryID
from Sales.Customer a join sales.SalesTerritory b on a.TerritoryID = b.TerritoryID
where b.CountryRegionCode like 'us'
group by b.TerritoryID
-- tinh subtotal
select SubTotal = sum(a.OrderQty*a.UnitPrice),c.CustomerID,b.TerritoryID
from  Sales.SalesOrderDetail a join Sales.SalesOrderHeader b 
on a.SalesOrderID = b.SalesOrderID join Sales.Customer c
on c.CustomerID = b.CustomerID
group by c.CustomerID,b.TerritoryID

-- 
select t.TerritoryID,SubTotal=SUM(f.SubTotal),CountofCust = COUNT(cu.CustomerID)
from Sales.SalesTerritory t join Sales.Customer cu 
on t.TerritoryID = cu.TerritoryID 
join (select SubTotal = sum(a.OrderQty*a.UnitPrice),c.CustomerID,b.TerritoryID
	from  Sales.SalesOrderDetail a join Sales.SalesOrderHeader b 
	on a.SalesOrderID = b.SalesOrderID join Sales.Customer c
	on c.CustomerID = b.CustomerID
	group by c.CustomerID,b.TerritoryID) f 
on f.TerritoryID = cu.TerritoryID
where t.CountryRegionCode like 'us'
group by t.TerritoryID

--3
select a.SalesOrderID,b.CarrierTrackingNumber,SubTotal = SUM(b.UnitPrice*b.OrderQty)
from Sales.SalesOrderHeader a join Sales.SalesOrderDetail b
on	 a.SalesOrderID = b.SalesOrderID
where b.CarrierTrackingNumber like '4bd%'

