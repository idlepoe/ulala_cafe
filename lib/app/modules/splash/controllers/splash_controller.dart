import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulala_cafe/app/routes/app_pages.dart';
import 'package:ulala_cafe/app/data/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulala_cafe/app/data/utils/snackbar_util.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _handleAuthentication();
  }

  Future<void> _handleAuthentication() async {
    try {
      // 현재 사용자 확인
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        // 익명 로그인 수행
        await _auth.signInAnonymously();
        logger.i('✅ 익명 로그인 성공');
      } else {
        logger.i('✅ 이미 로그인된 사용자: \\${currentUser.uid}');
      }

      // Firestore에 uid 저장 (낙관적 업데이트, 중복 허용)
      final user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').add({
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        logger.i('✅ Firestore에 uid 저장 완료: \\${user.uid}');
      }

      // 로그인 성공 후 3초 대기
      await Future.delayed(const Duration(seconds: 3));

      // 로그인 상태 재확인
      final userCheck = _auth.currentUser;
      if (userCheck != null) {
        // Windows 플랫폼인 경우 웹뷰로 이동, 그 외에는 메인 화면으로 이동
        if (!kIsWeb && Platform.isWindows) {
          logger.i('✅ 인증 완료, Windows 플랫폼 - 웹뷰 화면으로 이동');
          Get.offAllNamed(Routes.WEBVIEW);
        } else {
          logger.i('✅ 인증 완료, main 화면으로 이동');
          Get.offAllNamed(Routes.MAIN);
        }
      } else {
        logger.e('❌ 인증 상태 확인 실패');
        _showAuthError();
      }
    } catch (error) {
      logger.e('❌ 익명 로그인 실패: $error');
      _showAuthError();
    }
  }

  void _showAuthError() {
    SnackbarUtil.showError(
      '로그인에 실패했습니다. 앱을 다시 시작해주세요.',
      duration: const Duration(seconds: 5),
    );

    // 5초 후 다시 인증 시도
    Future.delayed(const Duration(seconds: 5), () {
      _handleAuthentication();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
