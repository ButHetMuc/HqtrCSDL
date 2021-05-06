-- 6. Tạo trigger cập nhật tiền thưởng (Bonus) cho nhân viên bán hàng SalesPerson, khi 
-- người dùng chèn thêm một record mới trên bảng SalesOrderHeader, theo quy định 
-- như sau: Nếu tổng tiền bán được của nhân viên có hóa đơn mới nhập vào bảng 
-- SalesOrderHeader có giá trị >10000000 thì tăng tiền thưởng lên 10% của mức 
-- thưởng hiện tại. Cách thực hiện:
--  Tạo hai bảng mới M_SalesPerson và M_SalesOrderHeader
-- create table M_SalesPerson 
-- (
-- 		SalePSID int not null primary key, 
-- 		TerritoryID int,
-- 		BonusPS money
-- )
-- create table M_SalesOrderHeader 
-- (
-- 		SalesOrdID int not null primary key, 
-- 		OrderDate date,
-- 		SubTotalOrd money,
-- 		SalePSID int foreign key references M_SalesPerson(SalePSID) 
-- ) 
-- - Chèn dữ liệu cho hai bảng trên lấy từ SalesPerson và SalesOrderHeader chọn 
-- những field tương ứng với 2 bảng mới tạo.
-- - Viết trigger cho thao tác insert trên bảng M_SalesOrderHeader, khi trigger 
-- thực thi thì dữ liệu trong bảng M_SalesPerson được cập nhật.

CREATE TABLE M_SalesPerson
(
    SalePSID INT NOT NULL PRIMARY KEY,
    TerritoryID INT,
    BonusPS MONEY
)

CREATE TABLE M_SalesOrderHeader
(
    SalesOrdID INT NOT NULL PRIMARY KEY,
    OrderDate DATE,
    SubTotalOrd MONEY,
    SalePSID INT FOREIGN KEY REFERENCES M_SalesPerson(SalePSID)
)

INSERT INTO M_SalesPerson
SELECT s.BusinessEntityID, s.TerritoryID, s.Bonus
FROM Sales.SalesPerson AS s

INSERT INTO M_SalesOrderHeader
SELECT s.SalesOrderID, s.OrderDate, s.SubTotal, s.SalesPersonID
FROM Sales.SalesOrderHeader AS s
GO

CREATE TRIGGER bonus_trigger ON M_SalesOrderHeader
FOR INSERT
AS
	BEGIN
    DECLARE @doanhThu FLOAT, @maNV INT
    SELECT @maNV= i.SalePSID
    FROM inserted i

    SET @doanhThu=(
		SELECT sum([SubTotalOrd])
    FROM [dbo].[M_SalesOrderHeader]
    WHERE SalePSID=@maNV
	)

    IF (@doanhThu > 10000000)
	BEGIN
        UPDATE M_SalesPerson
				SET BonusPS += BonusPS * 0.1
				WHERE SalePSID=@maNV
    END
END
GO