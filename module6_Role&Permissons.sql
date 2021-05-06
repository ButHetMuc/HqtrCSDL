--Hướng dẫn Module 6. ROLE - PERMISSION
---------------------------------------------------------------------
--Chú ý : Sử dụng tài khoản sa để thực hiện các lệnh dưới đây.  
--Nhưng khi test ... : cần connect bằng tài khoản đã được cấp quyền để kiểm chứng quyền đã được cấp
--Có thể connect bằng Object Explorer , hoặc Query editor
--Sinh viên vận dụng phần hướng dẫn dưới đây để làm bài tập trang  ...

---------------------------------------------------------------------
--(1) login vào SQL server bằng tài khoản của SQL Server hoặc Windows OS 
--	 -> chọn chế độ xác thực ...
--(2) tạo một SQL Server Login (3) connect vào SQL Server bằng login vừa tạo (4) Login vừa tạo có quyền gì ?
CREATE LOGIN sinhvien WITH PASSWORD = '123456';

-- Xem thông tin	 
Select * from SYS.SQL_LOGINS

--(5) Tạo user sinhvien cho Login vừa tạo để thao tác với 2 database  (6) User sinhvien có quyền gì trên database ?
USE  northwind
CREATE USER  sinhvien  FOR LOGIN  sinhvien
--test ...
go
USE AdventureWorks2008R2
CREATE USER  sinhvien  FOR LOGIN  sinhvien
--test ...
go
--(7) cấp quyền cho user sinhvien trên database AdventureWorks2008R2 
--Đặt câu hỏi : user sinhvien cần được cấp quyền gì trên database ? => xác định cách cấp quyền phù hợp
-------
--Cách 1: 
GRANT SELECT
ON sales.salesorderheader
TO  sinhvien
go
--test ...
--thu hồi quyền đã cấp
REVOKE SELECT
ON sales.salesorderheader
TO  sinhvien

--Cách 2: 
go
sp_helprole
go
ALTER ROLE db_datareader ADD MEMBER  sinhvien
-- hoặc dùng :  exec sp_addrolemember  'db_datareader' , sinhvien
go
--test ...
--remove user sinhvien khỏi role db_datareader
ALTER ROLE db_datareader DROP MEMBER  sinhvien
-- hoặc dùng :  exec sp_droprolemember  'db_datareader' , sinhvien

--Cách 3:
go
ALTER ROLE db_datareader ADD MEMBER  sinhvien
go
DENY  SELECT
ON sales.salesorderheader
TO  sinhvien
go
-- test ...
-- thu hồi quyền đã cấp
REVOKE  SELECT
ON sales.salesorderheader
TO  sinhvien 
go
ALTER ROLE db_datareader DROP MEMBER  sinhvien
go

--cách 4:
CREATE ROLE  banhang
go
ALTER ROLE banhang ADD MEMBER  sinhvien
go
GRANT SELECT , INSERT , UPDATE ,DELETE 
on  sales.SalesOrderHeader
to banhang
go
GRANT SELECT , INSERT , UPDATE ,DELETE 
on  sales.SalesOrderDetail
to banhang
go
DENY SELECT 
on sales.Store
to banhang
go
ALTER ROLE db_datareader ADD MEMBER  banhang
go
--test ...
--remove user sinhvien khỏi role banhang
ALTER ROLE banhang DROP MEMBER  sinhvien
--xóa role banhang
DROP ROLE  banhang
go

--cách 1(bổ sung 1.1) :
GRANT  SELECT 
ON  sales.SalesOrderHeader
TO  sinhvien  WITH GRANT OPTION 	
go
--- WITH GRANT OPTION : user sinhvien có quyền select trên table sales.SalesOrderHeader
--- và có thể cấp quyền này cho user khác  
---test ...
---
-- thu hồi cả quyền mà các user khác được sinhvien cấp
REVOKE  SELECT
ON sales.salesorderheader
TO  sinhvien CASCADE
---test ...
---




--cách n :
ALTER  SERVER  ROLE   sysadmin  ADD MEMBER  sinhvien
-- test ...
-- remove login sinhvien khỏi sysadmin server role
ALTER  SERVER  ROLE   sysadmin  drop MEMBER  sinhvien







