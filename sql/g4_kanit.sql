-- 4.1 Veri kaybı kontrolü
SELECT 
    (SELECT COUNT(*) FROM kitaplar) AS duz_tablo_satir_sayisi,
    (SELECT COUNT(*) FROM kayitlar) AS kayitlar_satir_sayisi;

-- 4.2 Güncelleme Anomalisinin Karşılaştırılması
-- A) Düz tabloda güncelleme
UPDATE kitaplar 
SET yazar = 'Guncel Egitmen Duz' 
WHERE TRIM(yazar) = (
    SELECT TRIM(yazar) 
    FROM kitaplar 
    GROUP BY TRIM(yazar) 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- B) Normalize edilmiş egitmenler tablosunda güncelleme
UPDATE egitmenler 
SET ad = 'Guncel Egitmen Normalize' 
WHERE egitmen_id = (
    SELECT e.egitmen_id 
    FROM egitmenler e
    JOIN dersler d ON e.egitmen_id = d.egitmen_id
    JOIN kayitlar k ON d.ders_id = k.ders_id
    GROUP BY e.egitmen_id
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);
