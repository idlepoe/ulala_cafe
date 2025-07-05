import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tab_library_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../play_list/views/play_list_view.dart';
import '../../../data/utils/snackbar_util.dart';
import '../../../data/utils/toss_loading_indicator.dart';

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
                if (controller.isLoading) {
                  return const Center(
                    child: TossLoadingIndicator(size: 40, strokeWidth: 3.0),
                  );
                }

                if (controller.isEmpty) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.music_note_outlined,
                              size: 80,
                              color: AppColors.textTertiary,
                            ),
                            SizedBox(height: AppSizes.marginL),
                            Text(
                              '추가한 노래가 없습니다',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: AppSizes.marginS),
                            Text(
                              '플레이리스트를 만들거나 노래를 추가해보세요',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: AppSizes.marginXL),
                            _buildActionButtons(),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                // 플레이리스트 목록 + 추가 버튼
                return ListView.separated(
                  itemCount: controller.playlists.length + 1, // 추가 버튼을 위해 +1
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppSizes.marginM),
                  itemBuilder: (context, index) {
                    // 마지막 인덱스는 추가 버튼
                    if (index == controller.playlists.length) {
                      return _buildAddPlaylistButton();
                    }

                    final playlist = controller.playlists[index];
                    final thumbnailUrl = playlist.tracks.isNotEmpty
                        ? playlist.tracks.first.thumbnail
                        : '';

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
                            // 썸네일
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: thumbnailUrl.isEmpty
                                  ? Container(
                                      color: AppColors.surfaceVariant,
                                      child: Icon(
                                        Icons.music_note,
                                        size: AppSizes.iconL,
                                        color: AppColors.textSecondary,
                                      ),
                                    )
                                  : Image.network(
                                      thumbnailUrl,
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
                                      style: AppTextStyles.h4.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: AppSizes.marginXS),
                                    Text(
                                      '${playlist.tracks.length}곡',
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        // 노래 추가 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.goToSearchTab,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXL,
                vertical: AppSizes.paddingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search, size: 20),
                SizedBox(width: AppSizes.marginS),
                Text(
                  '노래 추가',
                  style: AppTextStyles.button1.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSizes.marginM),
        // 플레이리스트 만들기 버튼
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: controller.showCreatePlaylistModal,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXL,
                vertical: AppSizes.paddingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.playlist_add, size: 20),
                SizedBox(width: AppSizes.marginS),
                Text(
                  '플레이리스트 만들기',
                  style: AppTextStyles.button2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPlaylistButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: controller.showCreatePlaylistModal,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Container(
          height: 80,
          padding: EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Icon(
                  Icons.add,
                  size: AppSizes.iconL,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: AppSizes.marginM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '새 플레이리스트',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: AppSizes.marginXS),
                    Text(
                      '플레이리스트를 생성하세요',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.primary,
                size: AppSizes.iconM,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
