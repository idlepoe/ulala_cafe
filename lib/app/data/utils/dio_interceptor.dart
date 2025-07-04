import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' as g;
import 'package:logger/logger.dart';

import '../../routes/app_pages.dart';
import 'logger.dart';

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ✅ 요청 시작 시간 기록
    options.extra['startTime'] = DateTime.now();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken(true);
        if (idToken!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $idToken';
        } else {
          logger.w("⚠️ Firebase ID Token is empty");
        }

        handler.next(options);
      } else {
        logger.w("❌ 로그인 안 된 사용자 요청 차단");
        _redirectToLogin();
        handler.reject(
          DioException(
            requestOptions: options,
            error: 'User not authenticated',
            type: DioExceptionType.cancel,
          ),
        );
      }
    } catch (e) {
      logger.e("❌ Firebase 인증 처리 중 오류: $e");
      _redirectToLogin();
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Firebase auth token error',
          type: DioExceptionType.cancel,
        ),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final request = response.requestOptions;
    final startTime = request.extra['startTime'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    final method = request.method;
    final uri = request.uri.toString();

    // 🔍 쿼리 파라미터나 body를 같이 표시
    final params = request.queryParameters.isNotEmpty
        ? 'query: ${request.queryParameters}'
        : (request.data != null ? 'body: ${request.data}' : '');

    // 🔍 응답 데이터 요약
    String shortResponse = '';
    try {
      if (response.data is Map && response.data['data'] != null) {
        final dataStr = response.data['data'].toString();
        final shortData = dataStr.length > 100
            ? dataStr.substring(0, 100) + '...'
            : dataStr;
        shortResponse =
            '{success: ${response.data['success']}, message: ${response.data['message']}, data: $shortData}';
      } else {
        final raw = response.data.toString();
        shortResponse = raw.length > 100 ? raw.substring(0, 100) + '...' : raw;
      }
    } catch (_) {
      shortResponse = 'Non-printable response';
    }

    // 🪵 요청/응답/파라미터/시간을 각 줄마다 구분해서 출력
    logger.i(
      '[POST] $uri\n[param] $params\n[response] $shortResponse\n[time] ${duration}ms',
    );

    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final startTime = request.extra['startTime'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    final method = request.method;
    final uri = request.uri.toString();

    final params = request.queryParameters.isNotEmpty
        ? 'query: ${request.queryParameters}'
        : (request.data != null ? 'body: ${request.data}' : '');

    // 🪵 에러 로깅 - 단일 라인으로 정리
    logger.e(
      "❌ [$method] $uri (${err.response?.statusCode ?? 'ERR'}) (${duration}ms) | $params | ${err.message}",
    );

    super.onError(err, handler);
  }

  void _redirectToLogin() {
    if (g.Get.currentRoute != Routes.SPLASH) {
      g.Get.offAllNamed(Routes.SPLASH);
    }
  }
}
