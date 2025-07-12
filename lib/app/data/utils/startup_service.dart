import 'dart:io';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class StartupService {
  static final StartupService _instance = StartupService._internal();
  factory StartupService() => _instance;
  StartupService._internal();

  static const String _startupKey = 'auto_startup_enabled';
  final Logger _logger = Logger();
  bool _isInitialized = false;

  /// 초기화
  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      LaunchAtStartup.instance.setup(
        appName: packageInfo.appName,
        appPath: Platform.resolvedExecutable,
      );
      _isInitialized = true;
      _logger.i('LaunchAtStartup 초기화 완료');
    } catch (e) {
      _logger.e('LaunchAtStartup 초기화 실패: $e');
    }
  }

  /// 윈도우 시작시 실행 상태 확인
  Future<bool> isStartupEnabled() async {
    if (!Platform.isWindows) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_startupKey) ?? false;
    } catch (e) {
      _logger.e('시작시 실행 상태 확인 실패: $e');
      return false;
    }
  }

  /// 윈도우 시작시 실행 설정
  Future<bool> setStartupEnabled(bool enabled) async {
    if (!Platform.isWindows) return false;

    try {
      await _initialize();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_startupKey, enabled);

      if (enabled) {
        await LaunchAtStartup.instance.enable();
        _logger.i('윈도우 시작시 실행 활성화 완료');
      } else {
        await LaunchAtStartup.instance.disable();
        _logger.i('윈도우 시작시 실행 비활성화 완료');
      }

      return true;
    } catch (e) {
      _logger.e('시작시 실행 설정 실패: $e');
      return false;
    }
  }

  /// 현재 시스템의 시작시 실행 상태 확인
  Future<bool> isSystemStartupEnabled() async {
    if (!Platform.isWindows) return false;

    try {
      await _initialize();
      return await LaunchAtStartup.instance.isEnabled();
    } catch (e) {
      _logger.e('시스템 시작시 실행 상태 확인 실패: $e');
      return false;
    }
  }

  /// 앱 시작시 시스템 상태와 앱 설정 동기화
  Future<void> syncStartupState() async {
    if (!Platform.isWindows) return;

    try {
      final appSetting = await isStartupEnabled();
      final systemState = await isSystemStartupEnabled();

      if (appSetting != systemState) {
        _logger.w('시작시 실행 상태 불일치 감지: 앱설정=$appSetting, 시스템상태=$systemState');
        await setStartupEnabled(appSetting);
      }
    } catch (e) {
      _logger.e('시작시 실행 상태 동기화 실패: $e');
    }
  }
}
