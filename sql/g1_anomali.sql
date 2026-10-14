-- 1.1 Her eğitmenin düz tabloda kaç kez tekrar ettiği (Güncelleme anomalisinin boyutu)
SELECT yazar AS egitmen, COUNT(*) AS tekrar_sayisi
FROM kitaplar
GROUP BY yazar
ORDER BY tekrar_sayisi DESC;

-- 1.2 Birden fazla farklı ücreti (veya sayfa sayısını) olan derslerin/kitapların tespiti (Tutarsızlık)
SELECT ad AS ders_adi, COUNT(DISTINCT sayfa) AS farkli_ucret_sayisi
FROM kitaplar
GROUP BY ad
HAVING COUNT(DISTINCT sayfa) > 1;
