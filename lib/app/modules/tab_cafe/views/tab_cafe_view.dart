import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tab_cafe_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';

class TabCafeView extends GetView<TabCafeController> {
  const TabCafeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CAFE', style: AppTextStyles.h1),
          SizedBox(height: AppSizes.marginL),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: AppSizes.shadowBlurRadius,
                  offset: Offset(0, AppSizes.shadowOffsetY),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.coffee,
                      color: AppColors.primary,
                      size: AppSizes.iconL,
                    ),
                    SizedBox(width: AppSizes.marginM),
                    Text('음악 카페', style: AppTextStyles.h3),
                  ],
                ),
                SizedBox(height: AppSizes.marginM),
                Text(
                  '다른 사람들과 음악을 함께 나누는 공간입니다.',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
