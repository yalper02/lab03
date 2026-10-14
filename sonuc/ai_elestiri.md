# Yapay Zeka Şema Eleştirisi (Lab 03)

## 1. Kullanılan Araç ve İstem (Prompt)
* **Kullanılan Yapay Zeka Aracı:** ChatGPT (GPT-4o)
* **Verilen İstem (Prompt):**
  > "Aşağıda düz bir tablonun sütun adları ve ilk 5 satırlık örnek verisi yer almaktadır. Bu tabloyu 3NF (Üçüncü Normal Form) kurallarına göre ayrıştırıp bana ilgili PostgreSQL CREATE TABLE DDL kodlarını oluştur:
  > 
  > Sütunlar: kitap_id, ad, yazar, yayin_yili, sayfa, tur
  > Örnek Veri:
  > 1 | Nutuk | Mustafa Kemal Atatürk | 1927 | 543 | Tarih
  > 2 | Dokuzuncu Hariciye Koğuşu | Peyami Safa | 1930 | 112 | Roman
  > 3 | Çalıkuşu | Reşat Nuri Güntekin | 1922 | 416 | Roman
  > 4 | Saatleri Ayarlama Enstitüsü | Ahmet Hamdi Tanpınar | 1961 | 382 | Roman
  > 5 | Huzur | Ahmet Hamdi Tanpınar | 1948 | 322 | Roman"

---

## 2. Yapay Zeka Tarafından Önerilen Şema (Çıktı)

```sql
CREATE TABLE egitmenler (
    egitmen_id SERIAL PRIMARY KEY,
    yazar VARCHAR(255)
);

CREATE TABLE dersler (
    ders_id INT PRIMARY KEY,
    ad VARCHAR(255),
    egitmen_id INT REFERENCES egitmenler(egitmen_id),
    yayin_yili INT,
    sayfa INT,
    tur VARCHAR(100),
    salon_kapasite INT,
    telefon VARCHAR(100)
);

Eleştiri 1: Telefon Sütununun Atomik Sanılması ve 1NF/3NF İhlali
Yapay zeka aracı telefon alanında birden fazla numaranın (virgülle ayrılmış) bulunabileceğini gözden kaçırmış ve bu sütunu doğrudan dersler tablosuna düz bir metin (VARCHAR) olarak yerleştirmiştir. Bu durum First Normal Form (1NF) çoklu değer/atomiklik kuralını ve Dolaylı (Transitive) bağımlılıktan dolayı 3NF kuralını ihlal etmektedir. Üye ile telefon bire-çok (1:N) ilişkide olduğundan ayrı bir tabloda unnest ile ayrıştırılmalıdır.
CREATE TABLE telefonlar (
    telefon_id SERIAL PRIMARY KEY,
    uye_id INT NOT NULL,
    numara VARCHAR(20) NOT NULL,
    FOREIGN KEY (uye_id) REFERENCES uyeler(uye_id)
);
Eleştiri 2: Salon Kapasitesinin Dersler Tablosunda Bırakılması (3NF İhlali)
Yapay zeka salon_kapasite sütununu doğrudan dersler tablosunda bırakmıştır. Oysa salon kapasitesi derse değil, dersin yapıldığı salona bağlıdır (ders_id -> salon_id -> salon_kapasite). Bu durum geçişli bağımlılık (transitive dependency) yaratarak 3NF ihlaline yol açar ve güncelleme anomalilerine sebep olur.
CREATE TABLE salonlar (
    salon_id SERIAL PRIMARY KEY,
    ad VARCHAR(100) NOT NULL,
    kapasite INT
);
Eleştiri 3: Ücret/Sayfa Tutarsızlığı İçin İş Kuralı Eksikliği
Düz tabloda aynı dersin farklı satırlarda farklı ücretlere/sayfa sayılarına sahip olduğu (tutarsızlık) görülmektedir. Yapay zeka bu tutarsızlığı fark edememiş ve tabloyu aktarırken mağduriyeti önleyecek en düşük ücret (MIN(ucret)) seçimi gibi herhangi bir iş kuralı veya GROUP BY yapısı önermemiştir.
