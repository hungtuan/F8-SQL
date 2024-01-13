CREATE TABLE KHACH_HANG (
    MaKH VARCHAR(50) PRIMARY KEY,
    TenKH VARCHAR(50) NOT NULL,
    DiaChi VARCHAR(50) NOT NULL,
    SoDT VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE PHONG (
    MaPhong VARCHAR(50) PRIMARY KEY,
    LoaiPhong VARCHAR(50) NOT NULL,
    SoKhachToiDa INT,
    GiaPhong MONEY DEFAULT 0,
    MoTa TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE DAT_PHONG (
    MaDatPhong VARCHAR(50) PRIMARY KEY,
    MaPhong VARCHAR(50) REFERENCES PHONG(MaPhong),
    MaKH VARCHAR(50) REFERENCES KHACH_HANG(MaKH),
    NgayDat TIMESTAMPTZ DEFAULT NOW(),
    GioBatDau TIMESTAMPTZ DEFAULT NOW(),
    GioKetThuc TIMESTAMPTZ DEFAULT NOW(),
    TienDatCoc TEXT,
    GhiChu VARCHAR(100),
    TrangThaiDat VARCHAR(10),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE DICH_VU_DI_KEM (
    MaDV VARCHAR(50) PRIMARY KEY,
    TenDV VARCHAR(50),
    DonViTinh VARCHAR(10),
    DonGia MONEY DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE CHI_TIET_SU_DUNG_DICH_VU (
    MaDatPhong VARCHAR(50) REFERENCES DAT_PHONG(MaDatPhong),
    MaDV VARCHAR(50) REFERENCES DICH_VU_DI_KEM(MaDV),
    SoLuong INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Thêm dữ liệu vào bảng PHONG
INSERT INTO PHONG (MaPhong, LoaiPhong, SoKhachToiDa, GiaPhong, MoTa)
VALUES 
    ('P0001', 'Loai 1', 20, 60000, ''),
    ('P0002', 'Loai 1', 25, 80000, ''),
    ('P0003', 'Loai 2', 15, 50000, ''),
    ('P0004', 'Loai 3', 20, 50000, '');

-- Thêm dữ liệu vào bảng KHACH_HANG
INSERT INTO KHACH_HANG (MaKH, TenKH, DiaChi, SoDT)
VALUES 
    ('KH0001', 'Nguyên Van A', 'Hoa xuan', '1111111111'),
    ('KH0002', 'Nguyên Van B', 'Hoa hai', '1111111112'),
    ('KH0003', 'Phan Van A', 'Cam le', '1111111113'),
    ('KH0004', 'Phan Van B', 'Hoa xuan', '1111111114');

-- Thêm dữ liệu vào bảng DICH_VU_DI_KEM
INSERT INTO DICH_VU_DI_KEM (MaDV, TenDV, DonViTinh, DonGia)
VALUES 
    ('DV001', 'Beer', 'lon', 10000),
    ('DV002', 'Nuoc ngot', 'lon', 8000),
    ('DV003', 'Trai cay', 'dia', 35000),
    ('DV004', 'Khan uot', 'cai', 2000);

-- Thêm dữ liệu vào bảng DAT_PHONG
INSERT INTO DAT_PHONG (MaDatPhong, MaPhong, MaKH, NgayDat, GioBatDau, GioKetThuc, TienDatCoc, GhiChu, TrangThaiDat)
VALUES 
    ('DP0001', 'P0001', 'KH0002', '2018-03-26', '11:00', '13:30', '100000', '', 'Da dat'),
    ('DP0002', 'P0001', 'KH0003', '2018-03-27', '17:15', '19:15', '50000', '', 'Da huy'),
    ('DP0003', 'P0002', 'KH0002', '2018-03-26', '20:30', '22:15', '100000', '', 'Da dat'),
    ('DP0004', 'P0003', 'KH0001', '2018-04-01', '19:30', '21:15', '200000', '', 'Da dat');

-- Thêm dữ liệu vào bảng CHI_TIET_SU_DUNG_DICH_VU
INSERT INTO CHI_TIET_SU_DUNG_DICH_VU (MaDatPhong, MaDV, SoLuong)
VALUES 
    ('DP0001', 'DV001', 20),
    ('DP0001', 'DV003', 3),
    ('DP0001', 'DV002', 10),
    ('DP0002', 'DV002', 10),
    ('DP0002', 'DV003', 1),
    ('DP0003', 'DV003', 2),
    ('DP0003', 'DV004', 10);

-- Câu 1: Hiển thị MaDatPhong, MaPhong, LoaiPhong, GiaPhong, TenKH, NgayDat, TongTienHat, TongTienSuDungDichVu, TongTienThanhToan tương ứng với từng mã đặt phòng có trong bảng DAT_PHONG.
-- TongTienHat = GiaPhong * (GioKetThuc – GioBatDau) 
-- TongTienSuDungDichVu = SoLuong * DonGia 
-- TongTienThanhToan = TongTienHat + sum (TongTienSuDungDichVu)

SELECT 
    dp.MaDatPhong, 
    dp.MaPhong, 
    p.LoaiPhong, 
    p.GiaPhong, 
    kh.TenKH, 
    dp.NgayDat, 
    (p.GiaPhong * EXTRACT(HOUR FROM (dp.GioKetThuc - dp.GioBatDau))) AS TongTienHat,
    SUM(dvdd.SoLuong * dv.DonGia) AS TongTienSuDungDichVu,
    (p.GiaPhong * EXTRACT(HOUR FROM (dp.GioKetThuc - dp.GioBatDau))) + SUM(dvdd.SoLuong * dv.DonGia) AS TongTienThanhToan
FROM 
    DAT_PHONG dp
JOIN 
    PHONG p ON dp.MaPhong = p.MaPhong
JOIN 
    KHACH_HANG kh ON dp.MaKH = kh.MaKH
LEFT JOIN 
    CHI_TIET_SU_DUNG_DICH_VU dvdd ON dp.MaDatPhong = dvdd.MaDatPhong
LEFT JOIN 
    DICH_VU_DI_KEM dv ON dvdd.MaDV = dv.MaDV
GROUP BY 
    dp.MaDatPhong, p.MaPhong, p.LoaiPhong, p.GiaPhong, kh.TenKH, dp.NgayDat, dp.GioBatDau, dp.GioKetThuc
ORDER BY 
    dp.MaDatPhong;

-- Câu 2: Hiển thị MaKH, TenKH, DiaChi, SoDT của những khách hàng đã từng đặt phòng karaoke có địa chỉ ở “Hoa xuan”

SELECT 
    kh.MaKH, 
    kh.TenKH, 
    kh.DiaChi, 
    kh.SoDT
FROM 
    KHACH_HANG kh
JOIN 
    DAT_PHONG dp ON kh.MaKH = dp.MaKH
WHERE 
    kh.DiaChi = 'Hoa xuan';

-- Câu 3: Hiển thị MaPhong, LoaiPhong, SoKhachToiDa, GiaPhong, SoLanDat của những phòng được khách hàng đặt có số lần đặt lớn hơn 2 lần và trạng thái đặt là “Da dat”

SELECT 
    p.MaPhong, 
    p.LoaiPhong, 
    p.SoKhachToiDa, 
    p.GiaPhong, 
    COUNT(dp.MaDatPhong) AS SoLanDat
FROM 
    PHONG p
JOIN 
    DAT_PHONG dp ON p.MaPhong = dp.MaPhong
WHERE 
    dp.TrangThaiDat = 'Da dat'
GROUP BY 
    p.MaPhong, p.LoaiPhong, p.SoKhachToiDa, p.GiaPhong
HAVING 
    COUNT(dp.MaDatPhong) > 2;
