import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:window_manager/window_manager.dart';

class AppWebViewController extends GetxController {
  // InAppWebViewController? webViewController; // 필요시만 사용
  final RxBool isLoading = true.obs;
  final RxString currentUrl = ''.obs;
  final RxDouble progress = 0.0.obs;
  // FocusNode만 남김
  late FocusNode webViewFocusNode;

  static const String webUrl = 'https://ulala-cafe-c6399.web.app/';

  InAppWebViewSettings get settings => InAppWebViewSettings(
    javaScriptEnabled: true,
    domStorageEnabled: true,
    databaseEnabled: true,
    allowsInlineMediaPlayback: true,
    mediaPlaybackRequiresUserGesture: false,
    supportZoom: true,
    useOnLoadResource: true,
    useShouldOverrideUrlLoading: false,
    transparentBackground: false,
    clearCache: true,
    cacheEnabled: true,
    verticalScrollBarEnabled: true,
    horizontalScrollBarEnabled: true,
  );

  @override
  void onInit() {
    super.onInit();
    webViewFocusNode = FocusNode();
    if (Platform.isWindows) {
      _setupWindowListener();
    }
  }

  void _setupWindowListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Platform.isWindows) {
        windowManager.addListener(WebViewWindowListener());
      }
    });
  }

  void onWebViewCreated(controller) {
    // webViewController = controller; // 필요시만 사용
    if (Platform.isWindows) {
      Future.delayed(const Duration(milliseconds: 500), () {
        focusWebView();
      });
    }
  }

  void onLoadStart(controller, url) {
    isLoading.value = true;
    currentUrl.value = url?.toString() ?? '';
  }

  void onLoadStop(controller, url) {
    isLoading.value = false;
    currentUrl.value = url?.toString() ?? '';
    if (Platform.isWindows) {
      Future.delayed(const Duration(milliseconds: 300), () {
        focusWebView();
      });
    }
  }

  void onProgressChanged(controller, int progressValue) {
    progress.value = progressValue / 100.0;
  }

  void onLoadError(controller, url, int code, String message) {
    isLoading.value = false;
  }

  Future<void> focusWebView() async {
    try {
      if (webViewFocusNode.canRequestFocus) {
        webViewFocusNode.requestFocus();
      }
    } catch (_) {}
  }

  bool handleKeyboardEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      return true;
    }
    return false;
  }

  Future<void> _activateWindowAndFocus() async {
    try {
      if (Platform.isWindows) {
        await windowManager.focus();
        await Future.delayed(const Duration(milliseconds: 100));
        await focusWebView();
      }
    } catch (_) {}
  }

  Future<void> restoreWebViewFocus() async {
    try {
      final delay = Platform.isWindows ? 500 : 200;
      await Future.delayed(Duration(milliseconds: delay));
      await focusWebView();
    } catch (_) {}
  }

  void reload() {
    // webViewController?.reload();
  }

  void goBack() {
    // webViewController?.goBack();
  }

  void goForward() {
    // webViewController?.goForward();
  }

  @override
  void onClose() {
    webViewFocusNode.dispose();
    if (Platform.isWindows) {
      windowManager.removeListener(WebViewWindowListener());
    }
    super.onClose();
  }
}

class WebViewWindowListener with WindowListener {
  @override
  void onWindowFocus() async {
    if (Get.isRegistered<AppWebViewController>()) {
      final webViewController = Get.find<AppWebViewController>();
      await Future.delayed(const Duration(milliseconds: 200));
      await webViewController.restoreWebViewFocus();
    }
  }

  @override
  void onWindowShow() async {
    if (Get.isRegistered<AppWebViewController>()) {
      final webViewController = Get.find<AppWebViewController>();
      await Future.delayed(const Duration(milliseconds: 300));
      await webViewController.restoreWebViewFocus();
    }
  }

  @override
  void onWindowBlur() async {}
}
