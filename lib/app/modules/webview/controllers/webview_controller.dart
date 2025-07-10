import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AppWebViewController extends GetxController {
  InAppWebViewController? webViewController;
  final RxBool isLoading = true.obs;
  final RxString currentUrl = ''.obs;
  final RxDouble progress = 0.0.obs;
  final RxBool isWebViewFocused = false.obs;

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

  /// 웹뷰 포커스 설정
  Future<void> focusWebView() async {
    try {
      if (webViewController != null) {
        // 웹뷰에 포커스 설정 (JavaScript를 통해)
        await webViewController!.evaluateJavascript(
          source: '''
          (function() {
            try {
              window.focus();
              if (document.body) {
                document.body.focus();
              }
            } catch (e) {
              console.log('Flutter: 웹뷰 포커스 설정 중 오류:', e);
            }
          })();
        ''',
        );
        isWebViewFocused.value = true;
        print('웹뷰 포커스 설정 완료');
      }
    } catch (e) {
      print('웹뷰 포커스 설정 실패: $e');
    }
  }

  /// 웹뷰 키보드 이벤트 처리
  bool handleKeyboardEvent(KeyEvent event) {
    if (!isWebViewFocused.value) {
      // 웹뷰가 포커스되지 않은 경우 포커스 설정 시도
      focusWebView();
      return false;
    }

    // 웹뷰에 키보드 이벤트 전달
    if (event is KeyDownEvent && webViewController != null) {
      // 웹뷰에 키보드 이벤트 전달 (고유한 변수명 사용)
      webViewController!.evaluateJavascript(
        source:
            '''
        // 키보드 이벤트를 웹페이지에 전달
        (function() {
          const flutterKeyEvent = new KeyboardEvent('keydown', {
            key: '${event.character ?? ''}',
            code: '${event.logicalKey.keyLabel}',
            keyCode: ${event.logicalKey.keyId},
            which: ${event.logicalKey.keyId},
            ctrlKey: ${HardwareKeyboard.instance.isControlPressed},
            shiftKey: ${HardwareKeyboard.instance.isShiftPressed},
            altKey: ${HardwareKeyboard.instance.isAltPressed},
            metaKey: ${HardwareKeyboard.instance.isMetaPressed},
            bubbles: true,
            cancelable: true
          });
          document.dispatchEvent(flutterKeyEvent);
        })();
      ''',
      );
      return true;
    }
    return false;
  }

  /// 웹뷰 포커스 복구
  Future<void> restoreWebViewFocus() async {
    try {
      if (webViewController != null) {
        // 잠시 대기 후 포커스 설정
        await Future.delayed(const Duration(milliseconds: 200));
        await focusWebView();

        // 추가로 웹뷰 내부에 포커스 이벤트 전달
        await webViewController!.evaluateJavascript(
          source: '''
          // 웹페이지에 포커스 이벤트 전달 (안전한 스코프 사용)
          (function() {
            try {
              window.focus();
              if (document.body) {
                document.body.focus();
              }
              
              // 키보드 이벤트 리스너가 활성화되었는지 확인
              if (typeof window.restoreKeyboardShortcuts === 'function') {
                window.restoreKeyboardShortcuts();
              }
            } catch (e) {
              console.log('Flutter: 웹뷰 포커스 복구 중 오류:', e);
            }
          })();
        ''',
        );

        print('웹뷰 포커스 복구 완료');
      }
    } catch (e) {
      print('웹뷰 포커스 복구 실패: $e');
    }
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
