class AppConstants {
  AppConstants._();

  // 애니메이션 시간
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // 스플래시 화면 시간
  static const Duration splashDuration = Duration(seconds: 3);

  // API 관련
  static const String baseUrl =
      'https://asia-northeast3-ulala-cafe-c6399.cloudfunctions.net';
  static const Duration apiTimeout = Duration(seconds: 30);

  // 캐시 관련
  static const Duration cacheDuration = Duration(hours: 1);
  static const int maxCacheSize = 100;

  // 페이지네이션
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // 파일 업로드
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxAudioSize = 50 * 1024 * 1024; // 50MB

  // 앱 정보
  static const String appName = '울랄라카페';
  static const String appVersion = '1.0.0';
}
