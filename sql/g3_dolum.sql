-- Tablo içeriklerini temizle
TRUNCATE TABLE kayitlar, dersler, telefonlar, salonlar, egitmenler, uyeler RESTART IDENTITY CASCADE;

-- 1. uyeler
INSERT INTO uyeler (uye_id, ad)
SELECT DISTINCT kitap_id, ad FROM kitaplar WHERE kitap_id IS NOT NULL;

-- 2. egitmenler
INSERT INTO egitmenler (ad, brans)
SELECT DISTINCT yazar, tur FROM kitaplar WHERE yazar IS NOT NULL;

-- 3. salonlar
INSERT INTO salonlar (ad, kapasite)
SELECT DISTINCT 'Salon ' || (sayfa % 10 + 1), (sayfa % 50 + 20) FROM kitaplar WHERE sayfa IS NOT NULL;

-- 4. telefonlar
INSERT INTO telefonlar (uye_id, numara)
SELECT DISTINCT kitap_id, yayin_yili::text FROM kitaplar WHERE kitap_id IS NOT NULL AND yayin_yili IS NOT NULL;

-- 5. dersler (Her benzersiz kitap adı için 1 ders kaydı ve MIN sayfa/ücret)
INSERT INTO dersler (ders_id, ad, egitmen_id, salon_id, ucret)
SELECT 
    MIN(k.kitap_id) AS ders_id,
    k.ad,
    (SELECT e.egitmen_id FROM egitmenler e WHERE e.ad = k.yazar LIMIT 1) AS egitmen_id,
    (SELECT s.salon_id FROM salonlar s WHERE s.ad = 'Salon ' || (MIN(k.sayfa) % 10 + 1) LIMIT 1) AS salon_id,
    MIN(k.sayfa) AS ucret
FROM kitaplar k
GROUP BY k.ad, k.yazar;

-- 6. kayitlar (Düz tablodaki 483 satırı doğrudan doğruya ilgili derse bağlama)
INSERT INTO kayitlar (uye_id, ders_id, tarih)
SELECT 
    k.kitap_id AS uye_id,
    d.ders_id,
    CURRENT_DATE - (k.yayin_yili % 365) * INTERVAL '1 day' AS tarih
FROM kitaplar k
JOIN dersler d ON k.ad = d.ad;
