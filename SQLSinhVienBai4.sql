CREATE DATABASE QLSV_BAI4
USE QLSV_BAI4

CREATE TABLE KHOA (
	MaKhoa varchar(4) primary key,
	TenKhoa nvarchar(30) NOT NULL,
)

CREATE TABLE SINHVIEN (
	MaSV varchar(4) primary key,
	HoTen nvarchar(50) not null,
	NgaySinh date check (NgaySinh < getdate()) not null,
	MaKhoa varchar(4) not null,
	constraint pk_MaKhoa foreign key (MaKhoa) references KHOA(MaKhoa)
)

CREATE TABLE MONHOC (
	MaMon varchar(4) primary key,
	TenMon nvarchar(50) not null,
	SoTinChi int check (SoTinChi between 1 and 10) not null,
)

CREATE TABLE DANGKYHOC (
	MaSV varchar(4),
	MaMon varchar(4),
	HocKy int check (HocKy between 1 and 8) not null,
	primary key(MaSV,MaMon),
	constraint pk_MaSV foreign key (MaSV) references SINHVIEN(MaSV),
	constraint pk_MaMon foreign key (MaMon) references MONHOC(MaMon)
)

insert into KHOA values ('TOAN',N'Toán - Tin'),('CNTT',N'Công nghệ thông tin'),('DIAL',N'Địa lý'),('HOAH',N'Hóa học')

set dateformat DMY
insert into SINHVIEN values ('K611',N'Phạm Văn Bình','24-2-1990','TOAN'),
('K612',N'Nguyễn Thị Hoài','12-4-1991','CNTT'),
('K613',N'Trần Ngọc','15-4-1990','DIAL'),
('K614',N'Nguyễn Tấn Dũng','3-2-1992','CNTT'),
('K615',N'Trương Tấn Sang','4-12-1990','DIAL')

insert into MONHOC values ('GT1',N'Giải tích 1',2),('DSTT',N'Đại số tuyến tính',3),('HH',N'Hình học Afin',2)

INSERT INTO DANGKYHOC 
VALUES ('K611','GT1','1'),
('K611','DSTT','2'),
('K612','DSTT','1'),
('K612','HH','2'),
('K612','GT1','1'),
('K613','HH','1'),
('K613','GT1','8'),
('K613','DSTT','2'),
('K614','HH','3'),
('K614','DSTT','6'),
('K615','HH','5')

--3.	 Viết câu lệnh sửa dữ liệu bảng MonHoc tên môn ‘Hình học Afin’ thành ‘Hình học’
UPDATE MONHOC SET TenMon = N'Hình học' Where TenMon = N'Hình học Afin'

--4.	 Tạo View đưa ra MaSV, HoTen, TenKhoa, Ngay sinh của sinh viên học khoa Công nghệ thông tin có năm sinh 1991 
CREATE VIEW CAU4
AS
SELECT SINHVIEN.MaSV,HoTen,TenKhoa,NgaySinh
FROM SINHVIEN JOIN KHOA ON SINHVIEN.MaKhoa = KHOA.MaKhoa
WHERE TenKhoa = N'Công nghệ thông tin' AND YEAR(NgaySinh) = 1991

--5.	Tạo truy vấn đưa ra thông tin của sinh viên không đăng ký học môn Giải tích 1
SELECT MASV, HOTEN, NGAYSINH, MAKHOA FROM SINHVIEN 
EXCEPT
SELECT DK.MASV, HOTEN, NGAYSINH, MAKHOA 
FROM DANGKYHOC DK JOIN SINHVIEN ON DK.MASV = SINHVIEN.MASV 
WHERE MAMON = 'GT1'

--6.	Tạo truy vấn đưa ra những sinh viên có đăng ký từ 2 môn trở lên gồm: mã sv, tên sv, tổng số môn
SELECT DANGKYHOC.MaSV,HoTen,COUNT(*) AS TONGSOMON
FROM SINHVIEN JOIN DANGKYHOC ON SINHVIEN.MaSV = DANGKYHOC.MaSV
GROUP BY DANGKYHOC.MaSV,HoTen
HAVING COUNT(MaMon) >= 2

--7.	Đưa ra những môn có số tín chỉ lớn hơn số tín chỉ của môn ‘Giải tích 1’
SELECT * FROM MONHOC WHERE SoTinChi > (SELECT SoTinChi FROM MONHOC WHERE TenMon = N'Giải tích 1')