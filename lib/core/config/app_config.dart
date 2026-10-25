abstract final class AppConfig {
  static const freeDailySwipes = 15;
  static const rewardedAdBonus = 10;
  static const maxRewardedAdsPerDay = 2;
  static const cardThumbnailSize = 1080;
  static const gridThumbnailSize = 300;
  // Recent thumbnails kept in memory (card + grid sizes).
  static const thumbnailCacheSize = 60;
  // Cards decoded ahead of the one on top.
  static const prefetchAhead = 2;

  // Unlocks premium for testing: --dart-define-from-file=env/local.json.
  // Ignored in release builds so it can never ship.
  static const forcePremium = bool.fromEnvironment('FORCE_PREMIUM');
}
