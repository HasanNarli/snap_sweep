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
  String get continueAction => 'Devam et';

  @override
  String get welcomeTitle => 'SnapSweep\'e hoş geldin';

  @override
  String get onboardingSwipeTitle => 'Kaydır, temizle';

  @override
  String get onboardingSwipeBody =>
      'Silmek için sola, tutmak için sağa. Galerin dakikalar içinde düzenlenir.';

  @override
  String get onboardingReviewTitle => 'Yanlışlıkla hiçbir şey silinmez';

  @override
  String get onboardingReviewBody =>
      'Silmeden önce seçimlerini gözden geçir, istediğin kaydırmayı geri al.';

  @override
  String get onboardingPrivacyTitle => 'Gizliliğin önce gelir';

  @override
  String get onboardingPrivacyBody =>
      'Fotoğrafların telefonundan asla çıkmaz. Yükleme yok, sunucu yok.';

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
  String get homeSwipesLeftToday => 'bugün kaldı';

  @override
  String get homeStartSwiping => 'Kaydırmaya başla';

  @override
  String get homeSpaceFreed => 'Boşaltılan alan';

  @override
  String get homePhotosCleaned => 'Silinen fotoğraf';

  @override
  String get homeSmartCleanup => 'Akıllı temizlik';

  @override
  String get categoryScreenshots => 'Ekran görüntüleri';

  @override
  String get categoryVideos => 'Videolar';

  @override
  String get categoryScreenRecordings => 'Ekran kayıtları';

  @override
  String get categoryDateRange => 'Tarih aralığı';

  @override
  String get pro => 'PRO';

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
  String get swipeFinish => 'Bitir';

  @override
  String get swipeDelete => 'Sil';

  @override
  String get swipeKeep => 'Tut';

  @override
  String get swipeUndo => 'Geri al';

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
  String get reviewTitle => 'Gözden geçir';

  @override
  String get reviewEmpty => 'Silinecek fotoğraf yok';

  @override
  String reviewSelectedCount(int count) {
    return '$count seçili';
  }

  @override
  String get reviewHint => 'Tutmak istediğin fotoğrafa dokun.';

  @override
  String reviewDeleteAction(int count) {
    return '$count fotoğrafı sil';
  }

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
}
