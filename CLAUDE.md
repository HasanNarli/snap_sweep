# SnapSweep

Tinder tarzı galeri temizleme uygulaması (Flutter, Android + iOS).
Repo: https://github.com/HasanNarli/snap_sweep (private)

## Proje kuralları

<!-- Kullanıcının genel geçer kuralları buraya. Her oturumda bunlara uy. -->

## Ürün kararları

- **Kaydırma:** sol = sil, sağ = kalsın. Kaydırma anında silmez; fotoğraf "silinecekler" listesine eklenir.
- **Toplu silme:** Tur sonunda "Gözden geçir" ekranında liste gösterilir, tek sistem onayıyla hepsi silinir. Geri alma (undo) butonu var.
- **Ücretsiz hak:** Günde 15 rastgele fotoğraf (gruplanmamış, tüm galeriden). Ödüllü reklam izleyene +10, günde en fazla 2 reklam.
- **Premium (abonelik):** Sınırsız kaydırma + filtreler: ekran görüntüleri, ekran kayıtları, videolar, tarih aralığı. Benzer/aynı fotoğraf bulma v1.1'e ertelendi.
- **Fiyatlandırma:** Yıllık + ömür boyu (tek seferlik). Haftalık abonelik YOK. TR pazarında rekabetçi fiyat; kesin TL fiyatı yayına yakın belirlenecek.
- **Konumlandırma:** "Fotoğrafların telefonundan asla çıkmaz" (sunucu yok), boşaltılan alanı (MB/GB) göster, reklamsız sade deneyim (sadece kullanıcının seçtiği ödüllü reklam).
- **İzinler:** Tam galeri erişimi istenir; kısıtlı (iOS "seçili fotoğraflar", Android 14 kısmi) ve reddedilmiş durumlar düzgün ele alınmalı.

## Ekranlar (minimum sayıda)

1. **Karşılama + izin** – 2-3 tanıtım sayfası, son sayfada izin isteği; red/kısıtlı durumda "Ayarlar'a git".
2. **Ana ekran** – kalan günlük hak, toplam boşaltılan alan, "Kaydırmaya başla", kilitli premium kategori kartları.
3. **Kaydırma** – kart destesi, undo, sayaç (7/15), tarih + dosya boyutu, "Bitir".
4. **Gözden geçir & sil** – silinecekler grid'i, seçimden çıkarma, "12 fotoğrafı sil (340 MB)", sonuç/kutlama.
5. **Paywall** – Faz 6.
- **Ayarlar** – bottom sheet: satın alımı geri yükle, gizlilik politikası, puanla, iletişim.

Hak bitince: bottom sheet → [Reklam izle +10] / [Premium: sınırsız].

## Teknik yığın

- `photo_manager` – izin, asset listeleme, thumbnail, silme
- `flutter_card_swiper` – kart destesi
- `flutter_riverpod` – state management
- `shared_preferences` – günlük hak sayacı, istatistikler
- `purchases_flutter` (RevenueCat) – abonelik (Faz 6)
- `google_mobile_ads` – ödüllü reklam (Faz 6; iOS ATT + KVKK/GDPR onayı gerekir)
- Lokalizasyon: TR + EN baştan (`flutter_localizations` + ARB)
- Rastgele seçim: tüm galeriyi belleğe yükleme; toplam sayıyı al, rastgele indekslerden asset çek.

## Yol haritası

- [ ] Faz 0 – Temel yapı: tema, klasör yapısı, routing, TR/EN
- [ ] Faz 1 – Karşılama + izin (tam/kısıtlı/red)
- [ ] Faz 2 – Kaydırma ekranı: rastgele 15, swipe, undo, silinecekler listesi
- [ ] Faz 3 – Gözden geçir & toplu silme, boşalan alan, sonuç ekranı
- [ ] Faz 4 – Ana ekran: günlük hak, istatistik, kilitli kategoriler
- [ ] Faz 5 – Cilalama: ikon, splash, gerçek cihaz testi, büyük galeri performansı
- [ ] Faz 6 – Premium (RevenueCat) + paywall + filtreler + ödüllü reklam
- [ ] Faz 7 – Yayın: gizlilik politikası, mağaza görselleri, önce Android sonra iOS
- [ ] v1.1 – Benzer/aynı fotoğraf tespiti

Bir faz bitince buradaki kutuyu işaretle.

## Geliştirme ortamı

- Windows (Android) + Mac (iOS build/test).
- Tasarım: Google Stitch → Figma; Figma linki verilirse Figma MCP ile okunup Flutter'a aktarılır.
- Bundle ID: `com.snapsweep.snap_sweep`
