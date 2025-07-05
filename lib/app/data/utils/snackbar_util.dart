import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_sizes.dart';

enum SnackbarType { success, error, info, warning }

class SnackbarUtil {
  static void show(
    String message, {
    String? title,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppColors.primary;
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = AppColors.error;
        icon = Icons.error_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning_outlined;
        break;
      case SnackbarType.info:
      default:
        backgroundColor = AppColors.textSecondary;
        icon = Icons.info_outline;
        break;
    }

    Get.snackbar(
      title ?? _getDefaultTitle(type),
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      margin: EdgeInsets.only(
        left: AppSizes.paddingM,
        right: AppSizes.paddingM,
        bottom: 100, // 네비게이션바 높이만큼 여유 공간 확보
      ),
      borderRadius: AppSizes.radiusM,
      icon: Icon(icon, color: textColor, size: AppSizes.iconM),
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static String _getDefaultTitle(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return '성공';
      case SnackbarType.error:
        return '오류';
      case SnackbarType.warning:
        return '경고';
      case SnackbarType.info:
      default:
        return '알림';
    }
  }

  // 편의 메서드들
  static void showSuccess(String message, {String? title, Duration? duration}) {
    show(
      message,
      title: title,
      type: SnackbarType.success,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showError(String message, {String? title, Duration? duration}) {
    show(
      message,
      title: title,
      type: SnackbarType.error,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showWarning(String message, {String? title, Duration? duration}) {
    show(
      message,
      title: title,
      type: SnackbarType.warning,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showInfo(String message, {String? title, Duration? duration}) {
    show(
      message,
      title: title,
      type: SnackbarType.info,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
