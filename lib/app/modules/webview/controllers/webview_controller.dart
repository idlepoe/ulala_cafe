import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AppWebViewController extends GetxController {
  InAppWebViewController? webViewController;
  final RxBool isLoading = true.obs;
  final RxString currentUrl = ''.obs;
  final RxDouble progress = 0.0.obs;

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
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  void onLoadStart(InAppWebViewController controller, WebUri? url) {
    isLoading.value = true;
    currentUrl.value = url?.toString() ?? '';
  }

  void onLoadStop(InAppWebViewController controller, WebUri? url) {
    isLoading.value = false;
    currentUrl.value = url?.toString() ?? '';
  }

  void onProgressChanged(InAppWebViewController controller, int progressValue) {
    progress.value = progressValue / 100.0;
  }

  void onLoadError(
    InAppWebViewController controller,
    Uri? url,
    int code,
    String message,
  ) {
    isLoading.value = false;
  }

  void reload() {
    webViewController?.reload();
  }

  void goBack() {
    webViewController?.goBack();
  }

  void goForward() {
    webViewController?.goForward();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
