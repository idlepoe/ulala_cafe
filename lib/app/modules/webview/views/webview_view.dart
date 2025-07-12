import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:window_manager/window_manager.dart';
import '../controllers/webview_controller.dart';
import '../../../data/constants/app_colors.dart';

class WebViewView extends GetView<AppWebViewController> {
  const WebViewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            // InAppWebView를 Focus 위젯으로 감싸서 포커스 관리
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(AppWebViewController.webUrl),
              ),
              initialSettings: controller.settings,
              onWebViewCreated: controller.onWebViewCreated,
              onLoadStart: controller.onLoadStart,
              onLoadStop: controller.onLoadStop,
              onProgressChanged: controller.onProgressChanged,
              onLoadError: controller.onLoadError,
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.white.withOpacity(0.8),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('로딩 중...'),
                    ],
                  ),
                ),
              ),
            // 진행률 표시
            if (controller.progress.value > 0 && controller.progress.value < 1)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: controller.progress.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
          ],
        );
      }),
    );
  }
}
