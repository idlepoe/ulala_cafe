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
          Text('홈', style: AppTextStyles.h1),
          SizedBox(height: AppSizes.marginL),

          // 마지막 재생 플레이리스트 섹션
          Obx(() {
            if (!controller.hasLastPlaylist.value) {
              return _buildWelcomeCard();
            }
            return _buildLastPlaylistCard();
          }),

          SizedBox(height: AppSizes.marginL),

          // 환영 메시지
          _buildWelcomeCard(),
        ],
      ),
    );
  }

  Widget _buildLastPlaylistCard() {
    return Container(
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
          Text('마지막 재생 플레이리스트', style: AppTextStyles.h3),
          SizedBox(height: AppSizes.marginM),

          Row(
            children: [
              // 썸네일
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                child: Image.network(
                  controller.lastPlaylistThumbnail.value,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.surface,
                    child: Icon(
                      Icons.music_note,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              SizedBox(width: AppSizes.marginM),

              // 제목과 버튼들
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.lastPlaylistTitle.value,
                      style: AppTextStyles.h4,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSizes.marginM),

                    // 재생 버튼들
                    Row(
                      children: [
                        // 재생 버튼
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.playLastPlaylist,
                            icon: Icon(Icons.play_arrow),
                            label: Text('재생'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: AppSizes.marginS),

                        // 셔플 버튼
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.shuffleLastPlaylist,
                            icon: Icon(Icons.shuffle),
                            label: Text('셔플'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                                side: BorderSide(color: AppColors.border),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
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
          Text('울랄라카페에 오신 것을 환영합니다!', style: AppTextStyles.h3),
          SizedBox(height: AppSizes.marginM),
          Text(
            '음악을 함께 나누고 즐기는 공간입니다.',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
