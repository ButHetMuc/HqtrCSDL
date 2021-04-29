
---- cau 1 Tạo một Instead of trigger thực hiện trên view.

create table M_Department
(
DepartmentID int not null primary key,
Name nvarchar(50),
GroupName nvarchar(50)
)
create table M_Employees
(
EmployeeID int not null primary key,
Firstname nvarchar(50),
MiddleName nvarchar(50),
LastName nvarchar(50),
DepartmentID int foreign key references M_Department(DepartmentID)
)
---
go
create view EmpDepart_View 
as
select EmployeeID, FirstName, MiddleName, LastName, 
e.DepartmentID, Name, GroupName
from M_Employees e join M_Department d 
on e.DepartmentID = d.DepartmentID
go
--------------
create trigger trigger1
on EmpDepart_View
instead of Insert
as
insert into M_Department
select DepartmentID, Name, GroupName
from inserted
insert into M_Employees
select EmployeeID, Firstname, MiddleName, LastName, DepartmentID
from inserted

---end trigger
--- test trigger
select * from M_Employees
select * from M_Department

insert EmpDepart_view 
values(1, 'Nguyen','Hoang','Huy', 11,'Marketing','Sales')

insert EmpDepart_view 
values(2, 'Nguyen','Hoang','Huy', 12,'Marketing','Sales')

insert EmpDepart_view 
values(4, 'Nguyen','Hoang','Huy', 11,'Marketing','Sales')



alter trigger trigger1
on EmpDepart_View
instead of Insert
as
if not exists(select * from M_Department d join inserted i on d.DepartmentID=i.DepartmentID)
	insert into M_Department
	select DepartmentID, Name, GroupName
	from inserted
insert into M_Employees
select EmployeeID, Firstname, MiddleName, LastName, DepartmentID
from inserted