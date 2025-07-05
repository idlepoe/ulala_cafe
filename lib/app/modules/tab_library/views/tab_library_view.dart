import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tab_library_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../play_list/views/play_list_view.dart';

class TabLibraryView extends GetView<TabLibraryController> {
  const TabLibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 기본 라이브러리 화면 (기존 디자인 유지)
          _buildLibraryContent(),
          // 플레이리스트 화면 오버레이
          Obx(() {
            if (controller.showPlaylistView.value) {
              return Container(
                color: AppColors.background,
                child: Stack(
                  children: [
                    const PlayListView(),
                    // 뒤로 가기 버튼
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: controller.closePlaylist,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildLibraryContent() {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.marginL),
          Text('라이브러리', style: AppTextStyles.h1),
          SizedBox(height: AppSizes.marginL),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadPlaylists(),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.playlists.isEmpty) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.playlist_play,
                                size: AppSizes.iconXL,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: AppSizes.marginM),
                              Text(
                                '플레이리스트가 없습니다.',
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
                        ),
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  itemCount: controller.playlists.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppSizes.marginM),
                  itemBuilder: (context, index) {
                    final playlist = controller.playlists[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => controller.openPlaylist(playlist.id),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: playlist.thumbnailUrl.isEmpty
                                  ? Container(
                                      color: AppColors.surfaceVariant,
                                      child: Icon(
                                        Icons.music_note,
                                        size: AppSizes.iconL,
                                        color: AppColors.textSecondary,
                                      ),
                                    )
                                  : Image.network(
                                      playlist.thumbnailUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                      playlist.name,
                                      style: AppTextStyles.h4,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: AppSizes.marginXS),
                                    Text(
                                      '${playlist.trackCount}곡',
                                      style: AppTextStyles.body2.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(AppSizes.paddingM),
                              child: Icon(
                                Icons.chevron_right,
                                color: AppColors.textSecondary,
                                size: AppSizes.iconM,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
