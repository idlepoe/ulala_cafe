import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_cafe/app/data/constants/app_colors.dart';
import 'package:ulala_cafe/app/data/constants/app_constants.dart';
import 'package:ulala_cafe/app/data/constants/app_sizes.dart';
import 'package:ulala_cafe/app/data/constants/app_text_styles.dart';
import 'package:ulala_cafe/app/routes/app_pages.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusXXL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: AppSizes.shadowBlurRadius * 2,
                    offset: Offset(0, AppSizes.shadowOffsetY * 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.music_note,
                size: AppSizes.iconXL * 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSizes.marginXL),
            Text(
              AppConstants.appName,
              style: AppTextStyles.h1.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: AppSizes.marginM),
            Text(
              '음악을 함께 나누는 공간',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.surface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
