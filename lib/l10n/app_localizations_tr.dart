// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'SnapSweep';

  @override
  String get comingSoon => 'Çok yakında';

  @override
  String get backToHome => 'Ana sayfaya dön';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get close => 'Kapat';

  @override
  String get notNow => 'Şimdi değil';

  @override
  String get privacyFootnote => 'Fotoğrafların cihazından asla çıkmaz';

  @override
  String get onboardingTitle => 'Yer aç.\nAnılarını koru.';

  @override
  String get onboardingSubtitle =>
      'Unutulmuş fotoğraflarını hızlıca kaydırarak gözden geçir.';

  @override
  String get onboardingTriageTitle => 'Zahmetsiz ayıklama';

  @override
  String get onboardingTriageBody =>
      'Tutmak için sağa, silmek için sola kaydır';

  @override
  String get onboardingUndoTitle => 'Yanlışlıkla hiçbir şey silinmez';

  @override
  String get onboardingUndoBody =>
      'Seçimlerini gözden geçir, istediğini geri al';

  @override
  String get onboardingStorageTitle => 'Anında yer kazan';

  @override
  String get onboardingStorageBody => 'Boşalttığın alanı anbean takip et';

  @override
  String get onboardingAllow => 'Fotoğraflara erişim ver';

  @override
  String get permissionTitle => 'Fotoğraflarına erişim izni ver';

  @override
  String get permissionBody =>
      'SnapSweep\'in fotoğraflarını gösterebilmesi için galeri erişimi gerekiyor. Fotoğrafların telefonundan asla çıkmaz.';

  @override
  String get permissionAllow => 'Erişim ver';

  @override
  String get limitedAccessBody =>
      'SnapSweep yalnızca seçtiğin fotoğrafları görebiliyor.';

  @override
  String get limitedAccessAction => 'Tümüne izin ver';

  @override
  String get greetingMorning => 'Günaydın';

  @override
  String get greetingAfternoon => 'İyi günler';

  @override
  String get greetingEvening => 'İyi akşamlar';

  @override
  String get homeStorageReclaimed => 'Kazanılan alan';

  @override
  String homeThisWeek(String size) {
    return 'Bu hafta +$size';
  }

  @override
  String get homeCleaned => 'Silinen';

  @override
  String homeCleanedValue(int count) {
    return '$count fotoğraf';
  }

  @override
  String get homeSessions => 'Oturum';

  @override
  String get homeAverageSize => 'Ort. boyut';

  @override
  String get homeDailySession => 'Günlük oturum';

  @override
  String homeResetsIn(int hours, int minutes) {
    return '$hours sa $minutes dk sonra yenilenir';
  }

  @override
  String homeReviewsAvailable(int count) {
    return 'Bugün $count fotoğraf hakkın var';
  }

  @override
  String get homeStartCleaning => 'Temizliğe başla';

  @override
  String homeBatchOf(int count) {
    return '$count fotoğraf';
  }

  @override
  String get homeGetMore => 'Daha fazla al';

  @override
  String get homeSmartCategories => 'Akıllı kategoriler';

  @override
  String get outOfSwipesTitle => 'Bugünlük bu kadar';

  @override
  String outOfSwipesBody(int hours, int minutes) {
    return 'Ücretsiz hakların $hours sa $minutes dk sonra yenilenir. Devam etmek ister misin?';
  }

  @override
  String outOfSwipesWatchAd(int count) {
    return 'Reklam izle, +$count hak kazan';
  }

  @override
  String get outOfSwipesGoPro => 'Pro ile sınırsız temizle';

  @override
  String get pro => 'Pro';

  @override
  String get soon => 'Yakında';

  @override
  String get proCardTitle => 'Sınırsız temizlik';

  @override
  String get proCardBody =>
      'Günlük sınırı kaldır, akıllı kategorilerin kilidini aç.';

  @override
  String get upgrade => 'Yükselt';

  @override
  String get categoryScreenshots => 'Ekran görüntüleri';

  @override
  String get categoryScreenshotsHint => 'Fişler, capsler, eski yazışmalar';

  @override
  String get categoryVideos => 'Büyük videolar';

  @override
  String get categoryVideosHint => 'En çok yer kaplayanlar';

  @override
  String get categoryScreenRecordings => 'Ekran kayıtları';

  @override
  String get categoryScreenRecordingsHint => 'Unutulmuş kayıtlar';

  @override
  String get categoryDateRange => 'Tarih aralığı';

  @override
  String get categoryDateRangeHint => 'Bir ayı ya da tatili temizle';

  @override
  String get categoryDuplicates => 'Kopya ve benzerler';

  @override
  String get categoryDuplicatesHint => 'İkiz kareler ve seri çekimler';

  @override
  String get categoryBlurry => 'Bulanık fotoğraflar';

  @override
  String get categoryBlurryHint => 'Odak dışı ve titrek kareler';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsRestore => 'Satın alımları geri yükle';

  @override
  String get settingsPrivacy => 'Gizlilik politikası';

  @override
  String get settingsRate => 'SnapSweep\'i puanla';

  @override
  String get settingsContact => 'Bize ulaş';

  @override
  String swipeCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String get swipeSubtitle => 'Bugünün fotoğrafları';

  @override
  String get swipeFinish => 'Bitir';

  @override
  String get swipeDelete => 'Sil';

  @override
  String get swipeKeep => 'Tut';

  @override
  String get swipeUndo => 'Geri al';

  @override
  String swipeMarkedToast(String size) {
    return 'İşaretlendi • $size';
  }

  @override
  String get swipeNoPhotos => 'Galerinde fotoğraf bulunamadı';

  @override
  String get swipeLoadError => 'Fotoğraflar yüklenemedi';

  @override
  String get swipeDoneTitle => 'Hepsi bu kadar';

  @override
  String swipeMarkedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotoğraf silinmek üzere işaretlendi.',
      zero: 'Tüm fotoğrafları tuttun.',
    );
    return '$_temp0';
  }

  @override
  String swipeReviewAction(int count) {
    return '$count fotoğrafı gözden geçir';
  }

  @override
  String get reviewTitle => 'Silinecekler';

  @override
  String get reviewEmpty => 'Silinecek fotoğraf yok';

  @override
  String reviewSelectedOf(int selected, int total) {
    return '$total fotoğraftan $selected seçili';
  }

  @override
  String reviewPhotosSelected(int count) {
    return '$count fotoğraf seçili';
  }

  @override
  String reviewMarkedSize(String size) {
    return '$size silinecek';
  }

  @override
  String get reviewSelectAll => 'Tümünü seç';

  @override
  String get reviewDeselectAll => 'Seçimi kaldır';

  @override
  String get reviewKept => 'Tutuldu';

  @override
  String get reviewTrashNotePrefix => 'Fotoğraflar galerinin ';

  @override
  String get reviewTrashNoteBold => 'Son Silinenler';

  @override
  String get reviewTrashNoteSuffix =>
      ' klasörüne gider. Genellikle 30 gün içinde geri alabilirsin.';

  @override
  String get reviewHint => 'Korumak istediğin fotoğrafa dokun';

  @override
  String reviewDeleteAction(int count) {
    return '$count fotoğrafı sil';
  }

  @override
  String get reviewKeepAll => 'Hepsini tut';

  @override
  String get reviewNothingSelected => 'Seçili fotoğraf yok';

  @override
  String get reviewDeleteCancelled => 'Hiçbir şey silinmedi.';

  @override
  String get reviewDeleteFailed =>
      'Fotoğraflar silinemedi. Lütfen tekrar dene.';

  @override
  String get resultTitle => 'Tertemiz';

  @override
  String get resultFreed => 'alan boşaltıldı';

  @override
  String resultDeletedCount(int count) {
    return '$count fotoğraf silindi';
  }

  @override
  String get resultRestoreHint =>
      'Fikrini mi değiştirdin? Silinen fotoğrafları genellikle 30 gün boyunca galerinin çöp kutusundan geri alabilirsin.';

  @override
  String categorySummary(int count, String size) {
    return '$count öğe • $size';
  }

  @override
  String categoryLargeVideosSummary(int count, String size) {
    return '50 MB üstü $count video • $size';
  }

  @override
  String get swipeCategoryEmpty => 'Burada temizlenecek bir şey yok';

  @override
  String get paywallTitle => 'SnapSweep Pro';

  @override
  String get paywallSubtitle =>
      'Dilediğin kadar temizle. Her şey yine telefonunda kalır.';

  @override
  String get paywallUnlimited => 'Sınırsız temizlik';

  @override
  String get paywallUnlimitedHint => 'Günlük sınır yok';

  @override
  String get paywallCategories => 'Akıllı kategoriler';

  @override
  String get paywallCategoriesHint => 'Ekran görüntüsü, video, kayıt ve tarih';

  @override
  String get paywallNoAds => 'Reklam yok';

  @override
  String get paywallNoAdsHint => 'Hiçbir zaman reklam izlemen istenmez';

  @override
  String get planYearly => 'Yıllık';

  @override
  String get planYearlyHint => 'Yılda bir kez ödenir';

  @override
  String planPerMonth(String price) {
    return 'Aylık $price, yıllık ödenir';
  }

  @override
  String get planLifetime => 'Ömür boyu';

  @override
  String get planLifetimeHint => 'Bir kez öde, hep senin olsun';

  @override
  String get paywallContinue => 'Devam et';

  @override
  String get paywallRenewNote =>
      'Mağaza hesabının ayarlarından iptal edene kadar her yıl yenilenir.';

  @override
  String get paywallLifetimeNote => 'Tek seferlik ödeme. Abonelik yok.';

  @override
  String get paywallUnavailable => 'Satın alma şu an kullanılamıyor.';

  @override
  String get purchaseWelcome => 'Pro\'ya hoş geldin';

  @override
  String get purchaseFailed => 'Satın alma tamamlanamadı. Lütfen tekrar dene.';

  @override
  String get restoreNone => 'Önceki bir satın alma bulunamadı.';

  @override
  String get restoreDone => 'Satın alman geri yüklendi';

  @override
  String get homeUnlimited => 'Pro ile sınırsız inceleme';
}
