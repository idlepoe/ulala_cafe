import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tab_home_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';

class TabHomeView extends GetView<TabHomeController> {
  const TabHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '홈',
            style: AppTextStyles.h1,
          ),
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
                Text(
                  '울랄라카페에 오신 것을 환영합니다!',
                  style: AppTextStyles.h3,
                ),
                SizedBox(height: AppSizes.marginM),
                Text(
                  '음악을 함께 나누고 즐기는 공간입니다.',
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
