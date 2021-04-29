---- baitap trigger (trang 24)
--- cau 1 : instead of  trigger
--- cau 2,6 : after trigger
--- cau 3,4,5 : after hoac instead of trigger
---#############################################

--- cau 2 
--- (cau 6 tương tự)
create table MCustomer
(
CustomerID int not null primary key,
CustPriority int
)
create table MSalesOrders
(
SalesOrderID int not null primary key,
OrderDate date,
SubTotal money,
CustomerID int foreign key references MCustomer(CustomerID) )
----
insert into MCustomer(CustomerID)
	select CustomerID
	from Sales.Customer
	where CustomerID > 30100 and CustomerID < 30118

insert into MSalesOrders
	select SalesOrderID, OrderDate, SubTotal, CustomerID 
	from Sales.SalesOrderHeader
	where CustomerID > 30100 and CustomerID < 30118
-------------------
select * from MCustomer
 where customerid = 30102

select *
from MSalesOrders 
where customerid = 30102

select sum(subtotal)
from MSalesOrders where customerid = 30102    --- 6278.4211
----
---- test trigger  (I/U/D 1 record)
insert into MSalesOrders   
values (80003, '2021/1/1', 50000, 30102)  

delete MSalesOrders 
where SalesOrderID = 80001


update MSalesOrders 
set subtotal = 50000 
where SalesOrderID = 80001
-------------
go
create trigger  trigger2
on MSalesOrders
After Insert						---- inserted table
as
declare @id int , @total money
---LAY THONG TIN VE CUSTOMERid
select @id= customerid from inserted
---tinh tong trigia hd 
select @total =  sum(subtotal)
from  MSalesOrders
where CustomerID = @id
---cap nhat lai priority cua kh moi insert hoadon
update MCustomer
set CustPriority = case 
					when  @total < 10000 then 3
					when  @total < 50000 then 2
					else  1
					end 
where CustomerID = @id

-----
drop trigger trigger2
go
create trigger  trigger2
on MSalesOrders
After Insert, update , delete ---- insert/Update/Delete
as
declare @id int , @total money

if not exists (select * from deleted)		---- insert xay ra
begin
	select @id = customerid from inserted
	select @total =  sum(subtotal) from  MSalesOrders  where CustomerID = @id
	update MCustomer
	set CustPriority = case 
						when  @total < 10000 then 3
						when  @total < 50000 then 2
						else  1
						end 
	where CustomerID = @id
	return
end

if not exists (select * from inserted)    ---- delete xay ra
begin
	select @id = customerid from deleted
	select @total =  sum(subtotal) from  MSalesOrders  where CustomerID = @id
	update MCustomer
	set CustPriority = case 
						when  @total < 10000 then 3
						when  @total < 50000 then 2
						else  1
						end 
	where CustomerID = @id
	return
end

if update(subtotal)			---- update xay ra
begin
	select @id = customerid from inserted
	select @total =  sum(subtotal) from  MSalesOrders  where CustomerID = @id
	update MCustomer
	set CustPriority = case 
						when  @total < 10000 then 3
						when  @total < 50000 then 2
						else  1
						end 
	where CustomerID = @id
end


----
---- viet gon lai
alter trigger  trigger2
on MSalesOrders
After Insert, update , delete ---- insert/Update/Delete
as
declare @id int , @total money

if not exists (select * from deleted)		---- insert/update
	select @id = customerid from inserted
	
else if not exists (select * from inserted)    ---- delete
	select @id = customerid from deleted
	
else if update(subtotal)			---- update
	select @id = customerid from inserted

select @total =  sum(subtotal) from  MSalesOrders  where CustomerID = @id
update MCustomer
	set CustPriority = case 
						when  @total < 10000 then 3
						when  @total < 50000 then 2
						else  1
						end 
	where CustomerID = @id

---- end trigger








