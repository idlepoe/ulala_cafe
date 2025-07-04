import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/play_list_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';

class PlayListView extends GetView<PlayListController> {
  const PlayListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(controller.playlistName.value, style: AppTextStyles.h3),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tracks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_note,
                  size: AppSizes.iconXL,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppSizes.marginM),
                Text(
                  '플레이리스트가 비어있습니다.',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.marginXS),
                Text(
                  '검색에서 음악을 추가해보세요.',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppSizes.paddingL),
          itemCount: controller.tracks.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: AppSizes.marginM),
          itemBuilder: (context, index) {
            final track = controller.tracks[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      track.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surfaceVariant,
                          child: Icon(
                            Icons.music_note,
                            size: AppSizes.iconL,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.paddingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: AppTextStyles.h4,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppSizes.marginXS),
                          Text(
                            track.channelTitle,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TODO: 재생 버튼 추가 예정
                  SizedBox(width: AppSizes.marginM),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
