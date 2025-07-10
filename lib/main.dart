import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/data/constants/app_colors.dart';
import 'app/modules/webview/controllers/webview_controller.dart';

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

  runApp(const MyApp());

  // tray_manager 초기화 (Windows에서만)
  if (!kIsWeb && Platform.isWindows) {
    try {
      await TrayManager.instance.setContextMenu(
        Menu(
          items: [
            MenuItem(key: 'show', label: '창 열기'),
            MenuItem.separator(),
            MenuItem(key: 'exit', label: '앱 종료'),
          ],
        ),
      );

      await TrayManager.instance.setToolTip('울랄라');
      await TrayManager.instance.setIcon('assets/icon/icon-removebg.ico');

      TrayManager.instance.addListener(MyTrayListener());

      print('시스템 트레이 초기화 성공');
    } catch (e) {
      print('시스템 트레이 초기화 실패: $e');
    }
  }
}

class MyTrayListener with TrayListener {
  @override
  void onTrayIconMouseDown() async {
    print('시스템 트레이 아이콘 클릭됨');
    // 좌클릭 시 창을 표시
    print('좌클릭으로 창 표시 시도...');
    await _showAndFocusWindow();
  }

  // 창 표시 및 포커스 설정을 위한 헬퍼 메서드
  Future<void> _showAndFocusWindow() async {
    try {
      // 창이 숨겨져 있는지 확인
      final isVisible = await windowManager.isVisible();
      print('창 가시성 상태: $isVisible');

      if (!isVisible) {
        // 창 표시
        await windowManager.show();
        print('창 표시 완료');

        // 잠시 대기 후 포커스 설정
        await Future.delayed(const Duration(milliseconds: 100));
        await windowManager.focus();
        print('창 포커스 설정 완료');

        // 추가로 포커스 강화
        await Future.delayed(const Duration(milliseconds: 50));
        await windowManager.focus();

        // 창을 최상위로 가져오기
        await windowManager.setAlwaysOnTop(true);
        await Future.delayed(const Duration(milliseconds: 50));
        await windowManager.setAlwaysOnTop(false);

        // 웹뷰 포커스 복구
        await _restoreWebViewFocus();

        print('창 복원 완료');
      } else {
        // 이미 보이는 경우 포커스만 설정
        await windowManager.focus();
        print('기존 창에 포커스 설정');

        // 웹뷰 포커스 복구
        await _restoreWebViewFocus();
      }
    } catch (e) {
      print('창 표시/포커스 설정 실패: $e');
    }
  }

  // 웹뷰 포커스 복구
  Future<void> _restoreWebViewFocus() async {
    try {
      // 잠시 대기 후 웹뷰 포커스 복구
      await Future.delayed(const Duration(milliseconds: 300));

      // 웹뷰 컨트롤러가 등록되어 있는지 확인
      if (Get.isRegistered<AppWebViewController>()) {
        final webViewController = Get.find<AppWebViewController>();
        await webViewController.restoreWebViewFocus();
        print('웹뷰 포커스 복구 완료');
      }
    } catch (e) {
      print('웹뷰 포커스 복구 실패: $e');
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    print('시스템 트레이 우클릭됨');
    // 우클릭 시 컨텍스트 메뉴 표시
    print('컨텍스트 메뉴 표시 시도...');
    TrayManager.instance.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    print('메뉴 아이템 클릭: ${menuItem.key}');
    switch (menuItem.key) {
      case 'show':
        print('창 열기 실행');
        await _showAndFocusWindow();
        break;
      case 'exit':
        print('앱 종료 실행');
        await windowManager.destroy();
        break;
    }
  }

  @override
  void onTrayIconMouseUp() {
    print('시스템 트레이 아이콘 마우스 업');
  }

  @override
  void onTrayIconBalloonShow() {
    print('트레이 아이콘 풍선 표시');
  }

  @override
  void onTrayIconBalloonClick() {
    print('트레이 아이콘 풍선 클릭');
  }

  @override
  void onTrayIconBalloonClosed() {
    print('트레이 아이콘 풍선 닫힘');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isWindows) {
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
    if (!kIsWeb && Platform.isWindows) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowClose() async {
    if (!kIsWeb && Platform.isWindows) {
      final isPrevented = await windowManager.isPreventClose();
      if (isPrevented) {
        await windowManager.hide();
      }
    }
  }

  @override
  void onWindowShow() async {
    if (!kIsWeb && Platform.isWindows) {
      print('윈도우 표시 이벤트 발생');
      // 창이 표시될 때 포커스 강화
      await Future.delayed(const Duration(milliseconds: 100));
      await windowManager.focus();
      print('윈도우 표시 후 포커스 설정 완료');

      // 웹뷰 포커스 복구
      await _restoreWebViewFocus();
    }
  }

  @override
  void onWindowFocus() async {
    if (!kIsWeb && Platform.isWindows) {
      print('윈도우 포커스 이벤트 발생');
    }
  }

  // 웹뷰 포커스 복구 (MyAppState용)
  Future<void> _restoreWebViewFocus() async {
    try {
      // 잠시 대기 후 웹뷰 포커스 복구
      await Future.delayed(const Duration(milliseconds: 300));

      // 웹뷰 컨트롤러가 등록되어 있는지 확인
      if (Get.isRegistered<AppWebViewController>()) {
        final webViewController = Get.find<AppWebViewController>();
        await webViewController.restoreWebViewFocus();
        print('웹뷰 포커스 복구 완료');
      }
    } catch (e) {
      print('웹뷰 포커스 복구 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
        // 한글 폰트 설정
        fontFamily: GoogleFonts.notoSansKr().fontFamily,
        // 터치/터치패드 지원을 위한 설정
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // 터치 친화적인 스크롤 설정
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(
            AppColors.primary.withOpacity(0.5),
          ),
          trackColor: MaterialStateProperty.all(
            AppColors.primary.withOpacity(0.1),
          ),
          thickness: MaterialStateProperty.all(8.0),
          radius: const Radius.circular(4.0),
        ),
      ),
      // 터치/터치패드 지원을 위한 스크롤 동작 설정
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: true,
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
    );
  }
}
