import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:window_manager/window_manager.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/data/constants/app_colors.dart';

SimplePip? pip;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase 초기화 성공');
  } catch (e) {
    print('Firebase 초기화 실패: $e');
  }

  if (!kIsWeb && Platform.isWindows) {
    await windowManager.ensureInitialized();

    // 초기 사이즈 지정
    var initialSize = Size(475, 812);
    await windowManager.setSize(initialSize);
    await windowManager.setMinimumSize(initialSize);
    await windowManager.setMaximumSize(initialSize);
    await windowManager.setResizable(false);
    await windowManager.setTitle("울랄라");
    await windowManager.setIcon('assets/icon/icon-removebg.ico');

    // 창 가운데로 이동
    await windowManager.center();

    windowManager.setPreventClose(true); // X 눌러도 닫히지 않게 설정
  }

  runApp(
    GetMaterialApp(
      title: "Ulala Cafe",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primary.withOpacity(0.3),
          selectionHandleColor: AppColors.primary,
        ),
      ),
    ),
  );
}
