CREATE DATABASE qlsv
USE qlsv
CREATE TABLE SINHVIEN (
    MASV VARCHAR(5) PRIMARY KEY,
    HOTEN NVARCHAR(30) NOT NULL,
    GIOITINH NVARCHAR(3) CHECK(GIOITINH IN (N'NAM' , N'NỮ')) DEFAULT('NAM'),
    LOP NVARCHAR(10)
)

CREATE TABLE MONHOC (
    MAMH VARCHAR(5) PRIMARY KEY,
    TENMH NVARCHAR(30) NOT NULL UNIQUE,
    SOTINCHI INT NOT NULL CHECK (SOTINCHI BETWEEN 0 AND 10)
)

CREATE TABLE DIEM(
    MASV VARCHAR(5),
    MAMH VARCHAR(5),
    DIEMLAN1 INT CHECK (DIEMLAN1 BETWEEN 0 AND 10),
    DIEMLAN2 INT CHECK (DIEMLAN2 BETWEEN 0 AND 10),
    PRIMARY KEY(MASV,MAMH),
	CONSTRAINT fk_ma_sv FOREIGN KEY (MASV) REFERENCES SINHVIEN(MASV),
	CONSTRAINT fk_ma_mh	FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
)

/*KHONG SUA DUOC RANG BUOC*/
ALTER TABLE DIEM 
DROP CONSTRAINT PK__DIEM__C6217CB6A53348B0

ALTER TABLE DIEM
ADD CONSTRAINT pk_diem PRIMARY KEY (MASV,MAMH)

/*Sua kieu du lieu ma sinh vien (Luu y no lien quan bao nhieu bang phai xoa bay nhieu rang buoc vi khoa chinh khong xoa duoc)*/
/*Dau tien ngat het khoa ngoai cua masv cua bang sinh vien voi bang khac*/
alter table DIEM
drop constraint fk_ma_sv

/*Xoa rang buoc masv dang la khoa chinh cua bang sinh vien*/
alter table SINHVIEN
drop constraint PK__SINHVIEN__60228A2894F78479

/*Sua dieu kien masv cua bang phu thuoc*/
alter table SINHVIEN alter column MASV varchar(10) NOT NULL
alter table SINHVIEN add constraint pk_msv primary key(MASV)

/*Sua dieu kien cua bang chinh cuoi cung*/
alter table DIEM alter column MASV varchar(10) not null
alter table DIEM add constraint fk_masv foreign key (MASV) references SINHVIEN(MASV)

alter table MONHOC alter column TENMH nvarchar(50)
alter table MONHOC add GIAOVIEN nvarchar(40) 
alter table MONHOC drop column GIAOVIEN

insert SINHVIEN values('74TT1',N'Ha The Anh',N'NAM','74DCTT23')

/*Cach su nhap ma khong dung deafaul*/
insert SINHVIEN (MASV,HOTEN,LOP) values('74DCTT2','Chau Kiet Luan','73DCTT21')


/*Nhập bảng sinh viên*/
insert SINHVIEN values('00111',N'Đỗ Mai Anh',N'NỮ','L01'),('00112',N'Mai Văn Bình',N'NAM','L01'),
('00113',N'Lê La',N'NỮ','L02'),('00215',N'Đặng Ngọc Anh',N'NỮ','L02'),
('00315',N'Nguyễn Thế Tâm',N'NAM','L03'),('00254',N'Phạm Thị Thuận',N'NỮ','L01')


/*Nhập bảng môn học*/
insert into MONHOC values('TRR',N'Toán rời rạc',4),('CTDL',N'Cấu trúc dữ liệu',3),
('CSDL',N'Cơ sở dữ liệu',4),('KNGT',N'Kỹ năng giao tiếp',2)

/*Nhập bảng Diem*/
insert into DIEM values('00111','TRR',7,NULL),
('00112','CTDL',8,NULL),
('00113','CSDL',2,9),
('00215','KNGT',9,NULL),
('00315','TRR',1,7),
('00254','TRR',2,9),
('00112','CSDL',8,NULL),
('00113','KNGT',9,NULL),
('00215','CTDL',9,NULL)

/*Xoá tất cả điểm của sinh viên có mã 00254*/
DELETE FROM DIEM WHERE MASV = '00254'

/*CHO BIẾT MÃ MÔN HỌC VÀ TÊN HỌC HỌC , ĐIỂM THI CỦA SINH VIÊN TÊN BÌNH*/
SELECT DIEM.MAMH,TENMH,DIEMLAN1,DIEMLAN2
FROM SINHVIEN,MONHOC,DIEM
WHERE HOTEN LIKE N'%Bình%' AND SINHVIEN.MASV = DIEM.MASV AND MONHOC.MAMH = DIEM.MAMH

/*CHO BIẾT MÃ MÔN HỌC VÀ TÊN HỌC HỌC , ĐIỂM THI CỦA LÊ LA PHẢI THI LẠI*/
SELECT DIEM.MAMH,TENMH,DIEMLAN1,DIEMLAN2
FROM SINHVIEN,MONHOC,DIEM
WHERE HOTEN LIKE N'%Lê La%' AND SINHVIEN.MASV = DIEM.MASV AND MONHOC.MAMH = DIEM.MAMH AND DIEMLAN1 < 5

/*CHO BIẾT MÃ SINH VIÊN, TÊN SINH VIÊN ĐÃ THI ÍT NHẤT 1 TRONG 3 MÔN TOÁN RỜI RẠC , CƠ SỞ DỮ LIỆU, KỸ NĂNG GIAO TIẾP*/
SELECT DISTINCT SINHVIEN.MASV, HOTEN 
FROM SINHVIEN,MONHOC,DIEM
WHERE TENMH IN (N'Toán rời rạc',N'Cơ sở dữ liệu',N'Kỹ năng giao tiếp') AND SINHVIEN.MASV = DIEM.MASV AND MONHOC.MAMH = DIEM.MAMH

/*CHO BIẾT MÃ MÔN HỌC VÀ TÊN HỌC HỌC MÀ SINH VIÊN 00315 CHƯA CÓ ĐIỂM*/
SELECT MAMH,TENMH
FROM MONHOC
WHERE MONHOC.MAMH NOT IN (SELECT MAMH FROM DIEM,SINHVIEN WHERE DIEM.MASV = '00315' ) 

/*CHO BIẾT ĐIỂM CAO NHẤT CỦA MÔN CSDL*/
SELECT MAX(
    CASE 
        WHEN DIEMLAN1 > DIEMLAN2 THEN DIEMLAN1
        ELSE DIEMLAN2
    END
) AS DiemCaoNhat
FROM DIEM
WHERE MAMH = 'CSDL';

/*CHO BIẾT SINH VIÊN CHƯA CÓ ĐIỂM BẤT KỲ MÔN NÀO*/
SELECT SINHVIEN.MASV,HOTEN
FROM SINHVIEN
WHERE SINHVIEN.MASV NOT IN (SELECT MASV FROM DIEM)









 