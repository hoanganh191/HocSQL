CREATE DATABASE QL_TV
USE QL_TV
CREATE TABLE SACH (
	MASACH VARCHAR(3) PRIMARY KEY,
	TENSACH NVARCHAR(40) NOT NULL,
	NAMXB INT NOT NULL
)

CREATE TABLE DOCGIA(
	MADG VARCHAR(4) PRIMARY KEY,
	HOTEN NVARCHAR(40) NOT NULL,
	GIOITINH NVARCHAR(4) NOT NULL,
	NGAYSINH DATE NOT NULL
)

CREATE TABLE PHIEUMUON(
	MADG VARCHAR(4),
	MASACH VARCHAR(3),
	NGAYMUON DATE NOT NULL,
	NGAYTRA DATE NOT NULL,
	SOLUONG INT CHECK (SOLUONG BETWEEN 1 AND 5) NOT NULL,
	PRIMARY KEY(MADG,MASACH),
	CONSTRAINT FK_MADG FOREIGN KEY (MADG) REFERENCES DOCGIA(MADG),
	CONSTRAINT FK_MASACH FOREIGN KEY(MASACH) REFERENCES SACH(MASACH),
	-- CHECK mức bảng (DO KHONG THE SO SANH RANG BUOC MOT COT NAY SO VOI COT KHAC ,MA PHAI RANG BUOC MUC BANG)
    CONSTRAINT CK_NGAY CHECK (NGAYMUON < NGAYTRA AND NGAYMUON < GETDATE())
)

INSERT INTO SACH VALUES
('S01',N'Giải tích 1',2000),
('S02',N'Đại số tuyến tính',2020),
('S03',N'Hình học Afin',2010),
('S04',N'Hóa học',2019),
('S05',N'Tin học',2020)

SET DATEFORMAT DMY
INSERT INTO DOCGIA VALUES 
('DG01',N'Phạm Văn Bình',N'Nam','24-3-1990'),
('DG02',N'Nguyễn Thị Hoài',N'Nữ','6-4-1991'),
('DG03',N'Trần Ngọc',N'Nam','15-5-1990'),
('DG04',N'Nguyễn Tấn',N'Nam','23-12-1992'),
('DG05',N'Trương Mận',N'Nữ','4-12-1990')

SET DATEFORMAT DMY
INSERT INTO PHIEUMUON VALUES
('DG01','S01','1/2/2024','3/6/2024',1),
('DG02','S02','15/2/2024','3/5/2024',2),
('DG03','S03','17/4/2024','13/7/2024',1),
('DG01','S02','1/4/2024','13/8/2024',3),
('DG02','S03','15/1/2024','3/6/2024',2),
('DG04','S05','15/5/2024','3/7/2024',1)

--3.	Viết câu lệnh thêm ràng buộc cho bảng Độc Giả với điều kiện giới tính Nam hoặc Nữ 
ALTER TABLE DOCGIA ADD CONSTRAINT CK_GIOITINH CHECK (GIOITINH IN (N'Nam',N'Nữ'))

--4.	Viết câu lệnh chèn thêm cột Soluong vào bảng Sach, sau đó nhập dữ liệu cho cột Soluong
ALTER TABLE SACH ADD SOLUONG INT 
UPDATE SACH SET SOLUONG = 10

--5.	Tạo View đưa ra danh sách các độc giả mượn sách Giải tích 1 trong tháng 2
CREATE VIEW CAU5
AS
SELECT MADG
FROM PHIEUMUON JOIN SACH ON PHIEUMUON.MASACH = SACH.MASACH
WHERE TENSACH = N'Giải tích 1' AND MONTH(NGAYMUON) = 2

--6.	Tạo truy vấn đưa ra các cuốn sách không được mượn.
SELECT * FROM SACH
WHERE MASACH NOT IN (SELECT MASACH FROM PHIEUMUON)

--7.	Tạo thủ tục nhập vào 2 mã sách. Đưa ra thông báo xem 2 cuốn sách này có cùng năm xuất bản không.
create proc soSanhNam(@maSach1 varchar(3), @maSach2 varchar(3))
as
begin
	declare @nam1 int
	declare @nam2 int
	select @nam1 = NAMXB FROM SACH WHERE MASACH = @maSach1
	select @nam2 = NAMXB FROM SACH WHERE MASACH = @maSach2
	IF @nam1 > @nam2 print N'Quyển thứ nhất xuất bản trước quyển thứ 2'
	else if @nam1 = @nam2 print N'Quyển thứ nhất xuất bản cùng năm quyển thứ 2'
	else print N'Quyển thứ nhất xuất bản sau quyển thứ 2'
end

soSanhNam 'S02','S01'

--8.	Viết trigger để khi chèn 1 dòng dữ liệu vào bảng phieumuon thì số lượng trong bảng Sach sẽ tự động được cập nhật
CREATE TRIGGER THEM_PHIEU_MUON
ON PHIEUMUON
FOR INSERT
AS
	UPDATE SACH
	SET SACH.SOLUONG = SACH.SOLUONG - I.SOLUONG
	FROM SACH 
	JOIN inserted I ON SACH.MASACH = I.MASACH


SELECT * FROM SACH
SET DATEFORMAT DMY
INSERT INTO PHIEUMUON VALUES
('DG01','S05','1/5/2024','3/12/2024',1)