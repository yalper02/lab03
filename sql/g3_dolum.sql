-- Tablo içeriklerini temizle
TRUNCATE TABLE kayitlar, dersler, telefonlar, salonlar, egitmenler, uyeler RESTART IDENTITY CASCADE;

-- 1. Ana Tablo: uyeler
INSERT INTO uyeler (uye_id, ad)
SELECT DISTINCT 
    kitap_id AS uye_id, 
    ad AS ad
FROM kitaplar
WHERE kitap_id IS NOT NULL;

-- 2. Ana Tablo: egitmenler
INSERT INTO egitmenler (ad, brans)
SELECT DISTINCT 
    yazar AS ad,
    tur AS brans
FROM kitaplar
WHERE yazar IS NOT NULL;

-- 3. Ana Tablo: salonlar
INSERT INTO salonlar (ad, kapasite)
SELECT DISTINCT 
    'Salon ' || (sayfa % 10 + 1) AS ad,
    (sayfa % 50 + 20) AS kapasite
FROM kitaplar
WHERE sayfa IS NOT NULL;

-- 4. Bağımlı Tablo: telefonlar (Unnest tekniği ile üye başına teke indirilip aktarılır)
INSERT INTO telefonlar (uye_id, numara)
WITH benzersiz_uyeler AS (
    SELECT DISTINCT 
        kitap_id AS uye_id,
        yayin_yili::text AS telefon_str
    FROM kitaplar
    WHERE kitap_id IS NOT NULL AND yayin_yili IS NOT NULL
)
SELECT 
    uye_id,
    TRIM(numara) AS numara
FROM benzersiz_uyeler,
UNNEST(string_to_array(telefon_str, ',')) AS numara
WHERE TRIM(numara) <> '';

-- 5. Bağımlı Tablo: dersler (MIN ucret kuralı ve JOIN ile SERIAL ID çekimi)
INSERT INTO dersler (ders_id, ad, egitmen_id, salon_id, ucret)
SELECT 
    MIN(k.kitap_id) AS ders_id,
    k.ad AS ad,
    e.egitmen_id,
    s.salon_id,
    MIN(k.sayfa) AS ucret -- En düşük ücret / sayfa kuralı
FROM kitaplar k
LEFT JOIN egitmenler e ON k.yazar = e.ad
LEFT JOIN salonlar s ON ('Salon ' || (k.sayfa % 10 + 1)) = s.ad
GROUP BY k.ad, e.egitmen_id, s.salon_id;

-- 6. Bağımlı Tablo: kayitlar
INSERT INTO kayitlar (uye_id, ders_id, tarih)
SELECT DISTINCT
    k.kitap_id AS uye_id,
    d.ders_id,
    CURRENT_DATE - (k.yayin_yili % 365) * INTERVAL '1 day' AS tarih
FROM kitaplar k
JOIN dersler d ON k.ad = d.ad;
