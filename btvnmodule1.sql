create database LeDinhBut
on primary (
	name = 'filedata',
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\filedata.mdf',
	size = 10mb,
	maxsize =20mb,
	filegrowth =20%
)
log on (
	name = 'filedata_log',
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\filedat1.ldf',
	size = 5mb,
	maxsize = 10mb,
	filegrowth =20%
)
go 
use LeDinhBut
go
--1
exec sp_addtype mota,'nvarchar(40)' ,null
exec sp_addtype IDKH , 'char(10)' , 'not null'
exec sp_addtype DT , 'char(12)',null

go
--2
create table SanPham (
	Masp char(6) not null,
	TenSp varchar(20) not null,
	NgayNhap date null,
	DVT char (10) not null,
	SoLuongTon int null,
	DonGiaNhap money not null
)
create table HoaDon (
	Mahd char(10) not null,
	NgayLap date not null,
	NgayGiao date null,
	Makh IDKH ,
	DienGiai mota
)
create table KhachHang (
	MaKH IDKH,
	TenKH nvarchar(30) not null,
	Diachi nvarchar(40) null,
	DienThoai DT
)
create table ChiTietHD(
	MaHD char(10) not null,
	Masp char(6) not null,
	SoLuong int not null,
)
go
--3
alter table HoaDon 
	alter column DienGiai nvarchar(100)
--4
alter table SanPham 
	add TuLeHoaHong float 
--5
alter table SanPham 
	drop column NgayNhap
--6
alter table SanPham 
	add constraint PRK_SanPham primary key (Masp)
alter table HoaDon 
	add constraint PRK_HoaDon primary key (MaHD)
alter table KhachHang 
	add constraint PRK_KhachHang primary key (MaKH)
alter table ChiTietHD 
	add constraint PRK_ChiTietHD primary key (MaHD,Masp)
go
alter table HoaDon 
	add constraint FRK_hd foreign key (Makh) references KhachHang(MaKH)
alter table ChiTietHD 
		add constraint frk_cthd foreign key (MaHd) references HoaDon(MaHD),
			constraint frk_cthd1 foreign key(masp) references SanPham(Masp)
--7
alter table HoaDon 
	add constraint ck_hd check (NgayGiao>= NgayLap),
	constraint ck_hd1 check (MaHD like '[a-z][a-z][0-9][0-9][0-9][0-9]'),
	constraint df_hd default getdate() for NgayLap
--8
--tuong tu bai 7 
	--constraint ck_hd2 check (DVT in ('KG','thung','hop','cai'))
--9 nhap du lieu
--10: xoa 1 hoa don bat ki trong bang HoaDon se k xoa duoc , do mac' phai rang buoc khoa chinh va khoa ngaoi 
-- neu' van muon' xoa' thi` phai nocheck contraint all , hoac xoa constrant 

--11: khong , qua bo nho 

--12 : 
 exec sp_renamedb 'LeDinhBut','BanHang' 