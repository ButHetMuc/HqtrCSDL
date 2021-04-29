----------- cau 3
/* Viết một trigger thực hiện trên bảng Memployees sao cho khi người dùng thực hiện
chèn thêm một nhân viên mới vào bảng Memployees thì chương trình cập nhật số
nhân viên trong cột NumOfEmployee của bảng MDepartment. Nếu tổng số nhân
viên của phòng tương ứng <=200 thì cho phép chèn thêm, ngược lại thì hiển thị
thông báo “Bộ phận đã đủ nhân viên” và hủy giao tác
*/
use abc
go
select * from MDepartment
select * from MEmployees
go
create table MDepartment
(
DepartmentID int not null primary key,
Name nvarchar(50),
NumOfEmployee int
)
create table Memployees
(
EmployeeID int not null,
Firtname nvarchar(50),
MiddleName nvarchar(50),
LastName nvarchar(50),
DepartmentID int foreign key references MDepartment(DepartmentID)
constraint pk_emp_depart primary key(EmployeeID, DepartmentID)
)
go
create trigger trigger3					-- cach 2 : dung instead of trigger ????
on MEmployees
after insert , update					-- khong can ktra khi delete
as
if exists (select * from inserted i inner join MDepartment d on i.DepartmentID=d.DepartmentID
where NumOfEmployee = 200 )
begin
	print 'phong da du so luong nhan vien'
	rollback
end
else
update MDepartment  
set NumOfEmployee = NumOfEmployee +1
where  DepartmentID = (select DepartmentID from inserted )

-----end-----
go
select * from MDepartment
select * from MEmployees

insert into MDepartment
select 1, 'ketoan', 200

insert into MDepartment
select 2, 'tochuc', 10

insert into Memployees
select 13, 'nguyen' , 'van' , 'tuan', 1

insert into Memployees
select 13, 'nguyen' , 'van' , 'tuan', 2

update Memployees
set DepartmentID = 1
where EmployeeID = 13



---- cau 4 tương tự
--Bảng [Purchasing].[Vendor], chứa thông tin của nhà cung cấp, thuộc tính
--CreditRating hiển thị thông tin đánh giá mức tín dụng, có các giá trị:
--1 = Superior
--2 = Excellent
--3 = Above average
--4 = Average
--5 = Below average
--Viết một trigger nhằm đảm bảo khi chèn thêm một record mới vào bảng
--[Purchasing].[PurchaseOrderHeader], nếu Vendor có CreditRating=5 thì hiển thị
--thông báo không cho phép chèn và đồng thời hủy giao tác.

create trigger trigger4
on
after 
as
--kiemtra nếu Vendor có ....
if exists ....
begin
	print 
	rollback
end


---end trigger


---- cau 5 tương tự