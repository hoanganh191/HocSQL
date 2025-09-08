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

--CÁCH 2
SELECT DIEM.MAMH,TENMH,DIEMLAN1,DIEMLAN2
FROM SINHVIEN SV JOIN DIEM ON SV.MASV = DIEM.MASV
	JOIN MONHOC MH ON DIEM.MAMH = MH.MAMH
WHERE HOTEN LIKE '%BÌNH'


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
WHERE MONHOC.MAMH NOT IN (SELECT MAMH FROM DIEM WHERE DIEM.MASV = '00315' ) 

/*CHO BIẾT ĐIỂM CAO NHẤT CỦA MÔN CSDL*/
SELECT MAX(
    CASE 
        WHEN DIEMLAN1 > DIEMLAN2 THEN DIEMLAN1
        ELSE DIEMLAN2
    END
) AS DiemCaoNhat
FROM DIEM
WHERE MAMH = 'CSDL';

--ĐƯA RA NHỮNG SINH VIÊN CÓ ĐIỂM CAO NHẤT MÔN KNGT
SELECT HOTEN,DIEMLAN1
FROM SINHVIEN SV JOIN DIEM ON SV.MASV = DIEM.MASV
WHERE MAMH='KNGT' AND DIEMLAN1 = (SELECT MAX(DIEMLAN1) FROM DIEM WHERE MAMH = 'KNGT')

/*CHO BIẾT SINH VIÊN CHƯA CÓ ĐIỂM BẤT KỲ MÔN NÀO*/
SELECT MASV,HOTEN
FROM SINHVIEN
WHERE MASV NOT IN (SELECT DISTINCT MASV FROM DIEM)

--CHO BIẾT MÃ SINH VIÊN, TÊN NHỮNG SINH VIÊN CÓ ĐIỂM THI MÔN TRR KHÔNG THẤP NHẤT KHOA
SELECT DIEM.MASV,HOTEN
FROM SINHVIEN SV JOIN DIEM ON SV.MASV = DIEM.MASV
WHERE MAMH = 'TRR' AND DIEMLAN1 > (SELECT MIN(DIEMLAN1)
									FROM DIEM
									WHERE MAMH = 'TRR')

--Cho biết mã sinh viên và tên sinh viên có điểm thi môn CTDL > điểm CTDL của sinh viên 00112 
SELECT DIEM.MASV,HOTEN
FROM SINHVIEN,DIEM
WHERE DIEMLAN1 > (SELECT DIEMLAN1 FROM DIEM WHERE MASV = '00112' AND MAMH = 'CTDL') AND MAMH = 'CTDL' AND SINHVIEN.MASV = DIEM.MASV

--CHO BIẾT SỐ SINH VIÊN PHẢI THI LẠI TOÁN RỜI RẠC
SELECT COUNT(MASV) AS SVTHILAI
FROM DIEM
WHERE MAMH = 'TRR' AND DIEMLAN1 < 4

--CHO BIẾT MÃ SINH VIÊN, TÊN VÀ LỚP CỦA SINH VIÊN ĐẠT ĐIỂM CAO NHẤT KỸ NĂNG GIAO TIẾP
SELECT HOTEN,DIEMLAN1
FROM SINHVIEN JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV 
WHERE MAMH = 'KNGT' AND DIEMLAN1 = (SELECT MAX(DIEMLAN1) FROM DIEM WHERE MAMH = 'KNGT')

--MỖI SINH VIÊN ĐÃ CÓ ĐIỂM BAO NHIÊU MÔN ( LƯU Ý LÀ CÁI NÀY KHÔNG DÙNG JOIN NÊN CHỈ HIỆN THỊ SINH VIÊN CÓ XUẤT HIỆN TRONG BẢNG ĐIỂM )
SELECT DIEM.MASV, COUNT(MAMH)
FROM SINHVIEN,DIEM
WHERE SINHVIEN.MASV = DIEM.MASV
GROUP BY DIEM.MASV

--CÓ BAO NHIÊU SINH VIÊN THI TỪ 2 MÔN TRỞ LÊN
SELECT COUNT(*) AS SINHVIENTHITU2MONTROLEN
FROM (SELECT MASV
		FROM DIEM
		GROUP BY MASV
		HAVING COUNT(*) > 1) AS KETQUADUYET

--14.	*Cho danh sách mã sinh viên, tên sinh viên có điểm cao nhất của mỗi lớp..
SELECT DISTINCT DIEM.MASV,HOTEN,SINHVIEN.LOP,DIEMLAN1
FROM SINHVIEN 
JOIN DIEM ON SINHVIEN.MASV = DIEM.MASV
JOIN (SELECT LOP,MAX(DIEMLAN1) AS DIEMCAONHAT
        FROM DIEM JOIN SINHVIEN ON DIEM.MASV = SINHVIEN.MASV
        GROUP BY LOP) KQ_LOP ON KQ_LOP.LOP = SINHVIEN.LOP AND DIEM.DIEMLAN1 = KQ_LOP.DIEMCAONHAT 

--Tạo thủ tục đưa ra tổng điểm các môn của một sinh viên bất kỳ
create proc tongDiemCacMon(@maSV varchar(5),@tongDiem float output) 
as 
begin
    select @tongDiem = sum(DIEMLAN1) from DIEM where MASV = @maSV and DIEMLAN1 is not null
    PRINT N'Tổng điểm của ' + @maSV + N' là: ' + CONVERT(VARCHAR(2), @tongDiem);
end

   --Có nếu không có output thì k cần exec , còn lại là phải có
DECLARE @tong FLOAT;
EXECUTE tongDiemCacMon '00113', @tong OUTPUT;



--Đưa ra tổng điểm của một môn có mã là CSDL và CTDL của một sinh viên bất kỳ
create proc tongCsvaCT(@maSV varchar(5))
as
begin
    declare @tongCsCt float
    select @tongCsCt = sum(DIEMLAN1) from DIEM where MASV = @maSV and MAMH in ('CSDL','CTDL') and MAMH is not null
    print 'Tong diem cua CSDL và CTDL cua' +  convert(varchar(5),@maSV) + ' là : ' + convert(varchar(2),@tongCsCt)
end
tongCsvaCT '00113'

--So sánh tổng điểm các môn của 2 sinh viên bất kỳ
create proc soSanhTong(@maSv1 varchar(5), @maSv2 varchar(5))
as 
begin
    declare @tongsv1 float
    declare @tongsv2 float
    execute tongDiemCacMon @maSv1, @tongsv1 output
    execute tongDiemCacMon @maSv2, @tongsv2 output
    if @tongsv1 = @tongsv2 print N'Sinh viên ' + convert(varchar(5),@maSv1) + N' bằng ' + N'Sinh viên ' + convert(varchar(5),@maSv2)
    else if @tongsv1 > @tongsv2 print N'Sinh viên ' + convert(varchar(5),@maSv1) + N' lớn hơn ' + N'Sinh viên ' + convert(varchar(5),@maSv2)
    else print N'Sinh viên ' + convert(varchar(5),@maSv1) + N' nhỏ hơn ' + N'Sinh viên ' + convert(varchar(5),@maSv2)
end

soSanhTong '00111','00113'

--So sánh điểm của môn bất kỳ của 2 sinh viên bất kỳ
create proc soSanh2Mon(@maSv1 varchar(5),@maMon1 varchar(5), @maSv2 varchar(5),@maMon2 varchar(5))
as
begin
    declare @diemMon1 float
    declare @diemMon2 float
    select @diemMon1 = DIEMLAN1 from DIEM WHERE MAMH = @maMon1 
    select @diemMon2 = DIEMLAN1 from DIEM WHERE MAMH = @maMon2
    if @diemMon1 = @diemMon2 print N'Môn ' + convert(varchar(5),@maMon1) + N' của ' + convert(varchar(5),@maSv1) + 
        N' bằng ' + N' Môn ' + convert(varchar(5),@maMon2) + N' của ' + convert(varchar(5),@maSv2) 
    else if @diemMon1 > @diemMon2 print N'Môn ' + convert(varchar(5),@maMon1) + N' của ' + convert(varchar(5),@maSv1) + 
        N' lớn hơn ' + N' Môn ' + convert(varchar(5),@maMon2) + N' của ' + convert(varchar(5),@maSv2) 
    else print N'Môn ' + convert(varchar(5),@maMon1) + N' của ' + convert(varchar(5),@maSv1) + 
        N' bằng ' + N' Môn ' + convert(varchar(5),@maMon2) + N' của ' + convert(varchar(5),@maSv2)
end

soSanh2Mon '00111','TRR','00113','CSDL'

