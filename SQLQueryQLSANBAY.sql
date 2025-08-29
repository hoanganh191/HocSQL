CREATE DATABASE QLMAYBAY
USE QLMAYBAY
CREATE TABLE MAYBAY(
	MAMB VARCHAR(3) PRIMARY KEY,
	SOHIEU VARCHAR(50) UNIQUE,
	TAMBAY INT CHECK(TAMBAY > 0)
)

CREATE TABLE NHANVIEN (
	MANV VARCHAR(4) PRIMARY KEY,
	TEN NVARCHAR(40),
	LUONG INT CHECK( LUONG >= 0)
)

CREATE TABLE CHUNGNHAN (
	MANV VARCHAR(4),
	MAMB VARCHAR(3),
	PRIMARY KEY (MANV,MAMB),
	CONSTRAINT FK_MANV FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV),
	CONSTRAINT FK_MB FOREIGN KEY (MAMB) REFERENCES MAYBAY(MAMB)
)

INSERT INTO MAYBAY 
VALUES ('747','Boeing 747 - 400',13488),
('737','Boeing 737 - 800',5413),
('340','Airbus A340 -300',11100),
('757','Boeing 757 – 300',6415),
('777','Boeing 777 – 300',10350),
('767','Boeing 767 – 400ER',10300),
('154','Airbus A154',21500)

INSERT INTO NHANVIEN 
VALUES ('NV01',N'Lê Thị Hòa',30000000),
('NV02',N'Nguyễn Viết Hưng',50000000),
('NV03',N'Nguyễn Thùy Linh',45000000),
('NV04',N'Lê Văn An',60000000),
('NV05',N'Công Văn Tuyến',50000000)

INSERT INTO CHUNGNHAN
VALUES ('NV01','747'),
('NV01','340'),
('NV01','777'),
('NV02','737'),
('NV02','777'),
('NV02','747'),
('NV04','767'),
('NV05','340')

--1.	Viết các câu lệnh tạo các bảng với các ràng buộc nêu trong đề bài, dựa vào bảng dữ liệu để chọn kiểu dữ liệu phù hợp
--3.	Viết câu lệnh sửa bảng CHUNGNHAN thêm 1 cột mới là cột GHICHU
ALTER TABLE CHUNGNHAN ADD GHICHU NVARCHAR(40)

--4.	 Tạo truy vấn đưa ra tên những nhân viên lái được ít 1 loại máy bay nhất gồm các thông tin: TEN, MANV, Tổng số máy bay
SELECT TEN,CHUNGNHAN.MANV,COUNT(*) AS TONG_MAY_BAY
FROM NHANVIEN JOIN CHUNGNHAN ON NHANVIEN.MANV = CHUNGNHAN.MANV
GROUP BY TEN,CHUNGNHAN.MANV

--5. Tạo truy vấn đưa ra nhân viên lái được cả hai loại máy bay có mã 747 và 777 
SELECT CHUNGNHAN.MANV,TEN
FROM NHANVIEN JOIN CHUNGNHAN ON NHANVIEN.MANV = CHUNGNHAN.MANV
WHERE MAMB IN ('747','777')
GROUP BY CHUNGNHAN.MANV,TEN
HAVING COUNT(*) = 2

--6.	Tạo truy vấn đưa ra những máy bay chưa có trong bảng CHUNGNHAN

