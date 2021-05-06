-- 4. Bảng [Purchasing].[Vendor], chứa thông tin của nhà cung cấp, thuộc tính
-- CreditRating hiển thị thông tin đánh giá mức tín dụng, có các giá trị: 
-- 1 = Superior
-- 2 = Excellent
-- 3 = Above average 
-- 4 = Average
-- 5 = Below average
-- Viết một trigger nhằm đảm bảo khi chèn thêm một record mới vào bảng 
-- [Purchasing].[PurchaseOrderHeader], nếu Vender có CreditRating=5 thì hiển thị 
-- thông báo không cho phép chèn và đồng thời hủy giao tác.
-- Dữ liệu test
-- INSERT INTO Purchasing.PurchaseOrderHeader (RevisionNumber, Status, 
-- EmployeeID, VendorID, ShipMethodID, OrderDate, ShipDate, SubTotal, TaxAmt, 
-- Freight) VALUES ( 2 ,3, 261, 1652, 4 ,GETDATE() ,GETDATE() , 44594.55,
-- ,3567.564, ,1114.8638 );

CREATE TRIGGER Purchasing.CreditRating_trigger ON [Purchasing].[PurchaseOrderHeader]
FOR INSERT
AS
	IF EXISTS (
		SELECT *
FROM [Purchasing].[PurchaseOrderHeader] AS p JOIN inserted AS i
    ON p.PurchaseOrderID = i.PurchaseOrderID JOIN [Purchasing].[Vendor] AS v
    ON p.VendorID = v.BusinessEntityID
WHERE v.CreditRating = 5
	)
		BEGIN
    RAISERROR ('A vendor''s credit rating is too low to accept new purchase orders.', 16, 1);
    ROLLBACK TRANSACTION
END
GO

INSERT INTO Purchasing.PurchaseOrderHeader
    (RevisionNumber, Status, EmployeeID, VendorID, ShipMethodID, OrderDate, ShipDate, SubTotal, TaxAmt, Freight)
VALUES
    ( 2, 3, 261, 1652, 4 , GETDATE() , GETDATE() , 44594.55, 3567.564, 1114.8638 )
