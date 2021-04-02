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
go
--4
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like '%verageof%'

select * from Sales.SalesOrderDetail
select * from Production.Product

select  a.Name,a.ProductID,AVG(b.OrderQty) as averageOfQty
from Production.Product a join Sales.SalesOrderDetail b
on a.ProductID=b.ProductID
where b.UnitPrice<25 
group by a.Name,a.ProductID 
having AVG(b.OrderQty)>5
go
--5
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like 'jobtitle'

select JobTitle,countOfperson = COUNT(BusinessEntityID) from HumanResources.Employee
group by JobTitle
having COUNT(BusinessEntityID)>20
go
--6
--Tính tổng số lượng và tổng trị giá của các sản phẩm do các nhà cung cấp có tên 
--kết thúc bằng ‘Bicycles’ và tổng trị giá > 800000, thông tin gồm 
--BusinessEntityID, Vendor_Name, ProductID, SumOfQty, SubTotal
--(sử dụng các bảng [Purchasing].[Vendor], [Purchasing].[PurchaseOrderHeader] và 
--[Purchasing].[PurchaseOrderDetail])

select * from Purchasing.Vendor
select * from purchasing.PurchaseOrderDetail
select * from Purchasing.PurchaseOrderHeader
go

select a.BusinessEntityID,a.Name,c.ProductID,sumOfqty=SUM(c.OrderQty) ,b.SubTotal
from Purchasing.Vendor a join Purchasing.PurchaseOrderHeader b on a.BusinessEntityID=b.VendorID 
join Purchasing.PurchaseOrderDetail c on b.PurchaseOrderID=c.PurchaseOrderID
where a.Name like '%bicycles' --and b.SubTotal=839.79
group by a.BusinessEntityID,a.Name,c.ProductID,b.SubTotal 
having SUM(c.OrderQty*c.UnitPrice)>800000
go

--7) Liệt kê các sản phẩm có trên 500 đơn đặt hàng trong quí 1 năm 2008 và có tổng 
--trị giá >10000, thông tin gồm ProductID, Product_Name, CountOfOrderID và 
--SubTotal
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like 'productid'

select p.ProductID,p.Name as Product_Name , countOfOrderid = COUNT(oh.SalesOrderID), SubTotal=SUM(od.UnitPrice*od.OrderQty)
from Production.Product p join Sales.SalesOrderDetail od
on p.ProductID =od.ProductID join sales.SalesOrderHeader oh
on od.SalesOrderID=oh.SalesOrderID
where DATEPART(q,oh.OrderDate)=1 and YEAR(oh.OrderDate)=2008
group by p.ProductID,p.Name
having COUNT(oh.SalesOrderID)>500 and SUM(od.UnitPrice*od.OrderQty)>10000
go

--8) Liệt kê danh sách các khách hàng có trên 25 hóa đơn đặt hàng từ năm 2007 đến 2008, 
--thông tin gồm mã khách (PersonID) , họ tên (FirstName +' '+ LastName as fullname), Số hóa đơn (CountOfOrders). 
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like 'firstname'
select * from Person.Person

select c.PersonID, p.FirstName +' '+ p.LastName as fullName ,countOfOrder= COUNT(oh.SalesOrderID)
from Person.Person p join Sales.Customer c 
on p.BusinessEntityID = c.PersonID join Sales.SalesOrderHeader oh 
on c.CustomerID = oh.CustomerID 
where YEAR(OrderDate) between 2007 and 2008
group by c.PersonID,p.FirstName+' '+p.LastName
having COUNT(SalesOrderID)>25
go
--9) Liệt kê những sản phẩm có tên bắt đầu với ‘Bike’ và ‘Sport’ có tổng số lượng bán trong mỗi mỗi năm trên 500 sản phẩm, 
--thông tin gồm ProductID, Name, CountofOrderQty, year. (dữ liệu lấy từ các bảng  Sales.SalesOrderHeader, Sales.SalesOrderDetail,
-- and Production.Product) 
select p.ProductID,Name,countOfOrderqty=sum(OrderQty),YEAR(oh.OrderDate) as Nam
from
	Production.Product p join Sales.SalesOrderDetail od
on 
	p.ProductID = od.ProductID
	join sales.SalesOrderHeader oh 
on
	od.SalesOrderID= oh.SalesOrderID
where
	p.Name like 'Bike%' or p.Name like 'Sport%'
group by	
	p.ProductID,Name,YEAR(oh.OrderDate)
having 
	SUM(OrderQty)>500
	go

--10) Liệt kê những phòng ban có lương (Rate: lương theo giờ) trung bình >30, 
-- thông tin gồm Mã phòng ban (DepartmentID), tên phòng ban (name), Lương trung bình (AvgofRate). 
-- Dữ liệu từ các bảng [HumanResources].[Department],  [HumanResources].[EmployeeDepartmentHistory], 
-- [HumanResources].[EmployeePayHistory]
select * from HumanResources.EmployeeDepartmentHistory
select * from HumanResources.Department
select * from HumanResources.EmployeePayHistory

select 
	d.DepartmentID,Name,avgOfRate=AVG(Rate)
from
	HumanResources.Department d join HumanResources.EmployeeDepartmentHistory ed
	on d.DepartmentID=ed.DepartmentID
	join HumanResources.EmployeePayHistory ep
	on ed.BusinessEntityID = ep.BusinessEntityID
group by 
	d.DepartmentID,Name
having 
	AVG(Rate)>30
	go

--SUBQUERY

--1Liệt kê các sản phẩm gồm các thông tin product names và product ID có trên
--100 đơn đặt hàng trong tháng 7 năm 2008
select ProductID,Name 
from 
	Production.Product
where 
	ProductID in(
		select od.ProductID 
		from 
			Sales.SalesOrderHeader oh join sales.SalesOrderDetail od 
			on oh.SalesOrderID=od.SalesOrderID
		where 
			MONTH(oh.OrderDate)=7 and YEAR(oh.OrderDate)=2008
		group by 
			od.ProductID
		having 
			COUNT(*)>100
	)
order by
	ProductID --sort 
	go
----cau 2
--Liệt kê các sản phẩm (ProductID, name) có số hóa đơn đặt hàng nhiều nhất trong
--tháng 7/2008
select 
	ProductID,Name
from 
	Production.Product
where 
	ProductID in(
		select 
			d.ProductID
		from
			Sales.SalesOrderDetail d join Sales.SalesOrderHeader h
			on d.SalesOrderID = h.SalesOrderID
		where 
			MONTH(h.OrderDate)=7 and YEAR(h.OrderDate)=2008
		group by
			d.ProductID
		having 
			COUNT(d.ProductID)>=all (
				select 
						COUNT(h.SalesOrderID)
				from
						Sales.SalesOrderDetail d join Sales.SalesOrderHeader h
						on d.SalesOrderID = h.SalesOrderID
				where 
						MONTH(h.OrderDate)=7 and YEAR(h.OrderDate)=2008
				group by 
						d.ProductID
			)
	)
	go
--3) Hiển thị thông tin của khách hàng có số đơn đặt hàng nhiều nhất, thông tin gồm: 
--CustomerID, Name, CountOfOrder
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like 'name'


select c.CustomerID,Name=p.FirstName+' '+LastName,countOforder=COUNT(h.SalesOrderID) 
from Person.Person p join Sales.Customer c
	 on p.BusinessEntityID=c.CustomerID
	 join Sales.SalesOrderHeader h
	 on c.CustomerID = h.CustomerID
group by c.CustomerID,p.FirstName+' '+LastName
having COUNT(c.CustomerID) >= all(
				select COUNT(h.SalesOrderID) from Sales.Customer c join Sales.SalesOrderHeader h
				on c.CustomerID=h.CustomerID
				group by c.CustomerID			
		)
go
----cau 4
--Liệt kê các sản phẩm (ProductID, Name) thuộc mô hình sản phẩm áo dài tay với
--tên bắt đầu với “Long-Sleeve Logo Jersey”, dùng phép IN và EXISTS, (sử dụng
--bảng Production.Product và Production.ProductModel

select * from Production.Product
select * from Production.ProductModel

select ProductID,Name
from Production.Product
where ProductModelID in (select ProductModelID from Production.ProductModel 
					where Name like 'Long-sleeve logo Jersey%'
					)
--cách 2
select productID ,Name
from Production.Product p
where exists ( select ProductModelID from Production.ProductModel 
					where Name like 'Long-sleeve logo Jersey%' and ProductModelID = p.productModelID)
----cau 5
--Tìm các mô hình sản phẩm (ProductModelID) mà giá niêm yết (list price) tối đa
--cao hơn giá trung bình của tất cả các mô hình.
select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like'%list%'
select * from Production.Product
select * from Production.ProductModel

select  m.ProductModelID,m.Name,MAX(p.ListPrice) as  maxlistprice
from Production.ProductModel m join Production.Product p
	on m.ProductModelID=p.ProductModelID
group by m.ProductModelID,m.Name
having MAX(p.ListPrice)>= (select AVG(p.ListPrice) from Production.ProductModel m join Production.Product p
								on m.ProductModelID=p.ProductModelID
								)
--cau 6
--Liệt kê các sản phẩm gồm các thông tin ProductID, Name, có tổng số lượng đặt
--hàng >5000 (dùng In, exists)
select * from Sales.SalesOrderDetail
select * from Sales.SalesOrderHeader
select p.ProductID,p.Name 
from Production.Product p 
where p.ProductID in ( select d.ProductID from Sales.SalesOrderDetail d 
						group by d.ProductID
						having SUM(OrderQty)>5000
)



