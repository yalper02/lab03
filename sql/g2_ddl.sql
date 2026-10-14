-- Var olan tabloları bağımlılık sırasının tersine göre temizle
DROP TABLE IF EXISTS kayitlar CASCADE;
DROP TABLE IF EXISTS dersler CASCADE;
DROP TABLE IF EXISTS telefonlar CASCADE;
DROP TABLE IF EXISTS salonlar CASCADE;
DROP TABLE IF EXISTS egitmenler CASCADE;
DROP TABLE IF EXISTS uyeler CASCADE;

-- 1. Tablo: uyeler
CREATE TABLE uyeler (
    uye_id INT PRIMARY KEY,
    ad VARCHAR(255) NOT NULL
);

-- 2. Tablo: egitmenler
CREATE TABLE egitmenler (
    egitmen_id SERIAL PRIMARY KEY,
    ad VARCHAR(255) NOT NULL,
    brans VARCHAR(100)
);

-- 3. Tablo: salonlar
CREATE TABLE salonlar (
    salon_id SERIAL PRIMARY KEY,
    ad VARCHAR(100) NOT NULL,
    kapasite INT
);

-- 4. Tablo: telefonlar
CREATE TABLE telefonlar (
    telefon_id SERIAL PRIMARY KEY,
    uye_id INT NOT NULL,
    numara VARCHAR(20) NOT NULL,
    FOREIGN KEY (uye_id) REFERENCES uyeler(uye_id)
);

-- 5. Tablo: dersler
CREATE TABLE dersler (
    ders_id INT PRIMARY KEY,
    ad VARCHAR(255) NOT NULL,
    egitmen_id INT,
    salon_id INT,
    ucret DECIMAL(10,2),
    FOREIGN KEY (egitmen_id) REFERENCES egitmenler(egitmen_id),
    FOREIGN KEY (salon_id) REFERENCES salonlar(salon_id)
);

-- 6. Tablo: kayitlar
CREATE TABLE kayitlar (
    kayit_id SERIAL PRIMARY KEY,
    uye_id INT NOT NULL,
    ders_id INT NOT NULL,
    tarih DATE,
    FOREIGN KEY (uye_id) REFERENCES uyeler(uye_id),
    FOREIGN KEY (ders_id) REFERENCES dersler(ders_id)
);
