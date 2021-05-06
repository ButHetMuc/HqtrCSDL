-- 5. Viết một trigger thực hiện trên bảng ProductInventory (lưu thông tin số lượng sản 
-- phẩm trong kho). Khi chèn thêm một đơn đặt hàng vào bảng SalesOrderDetail với 
-- số lượng xác định trong field
-- OrderQty, nếu số lượng trong kho 
-- Quantity> OrderQty thì cập nhật 
-- lại số lượng trong kho 
-- Quantity= Quantity- OrderQty, 
-- ngược lại nếu Quantity=0 thì xuất 
-- thông báo “Kho hết hàng” và đồng 
-- thời hủy giao tác.

-- tạo bảng MProduct
create table MProduct
(
	MProductID int not null primary key,
	ProductName nvarchar(50),
	ListPrice money
)

insert MProduct
	(MProductID, ProductName,ListPrice)
select [ProductID], [Name], [ListPrice]
from [Production].[Product]
where [ProductID]<=710
select*
from MProduct

-- tạo bảng MSalesOrderHeader
create table MSalesOrderHeader
(
	MSalesOrderID int not null primary key,
	OrderDate datetime
)

insert MSalesOrderHeader
select [SalesOrderID], [OrderDate]
from [Sales].[SalesOrderHeader]
where [SalesOrderID] in (select [SalesOrderID]
from [Sales].[SalesOrderDetail]
where [ProductID]<=710)
select*
from MSalesOrderHeader

-- tạo bảng MSalesOrderDetail
create table MSalesOrderDetail
(
	SalesOrderDetailID int IDENTITY(1,1) primary key,
	ProductID int not null foreign key(ProductID) references MProduct(MProductID),
	SalesOrderID int not null foreign key (SalesOrderID) references MSalesOrderHeader(MSalesOrderID),
	OrderQty int
)
insert MSalesOrderDetail
	(ProductID, SalesOrderID,OrderQty)
select [ProductID], [SalesOrderID], [OrderQty]
from [Sales].[SalesOrderDetail]
where [ProductID] in(select MProductID
from MProduct)

-- tạo bảng MProduct_inventory
create table MProduct_inventory
(
	productID int not null primary key,
	quantity smallint
)

insert MProduct_inventory
select [ProductID], sum([Quantity]) as sumofquatity
from [Production].[ProductInventory]
group by [ProductID]
go

-- tạo trigger
create trigger bai5 on MSalesOrderDetail
for insert
AS
begin
	DECLARE @Qty int, @Quantity int, @productID int
	select @qty = i.OrderQty, @productID = i.ProductID
	from inserted i

	select @Quantity =  p.Quantity
	FROM MProduct_inventory p
	WHERE @productID = p.ProductID

	if(@Quantity > @Qty)
	begin
		update MProduct_inventory
				set quantity = @Quantity - @Qty
				where productID = @productID
	end
	ELSE if (@Quantity = 0)
	begin
		print N'Kho hết hàng'
		rollback
	end
end
GO

select*
from MSalesOrderDetail
select*
from MSalesOrderHeader
select*
from MProduct_inventory
where [ProductID]=708

---thuc thi trigger
delete from [MSalesOrderDetail]
insert [dbo].[MSalesOrderDetail]
values(708, 43661, 300)