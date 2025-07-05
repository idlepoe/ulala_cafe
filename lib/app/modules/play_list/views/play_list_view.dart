import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/play_list_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';

class PlayListView extends GetView<PlayListController> {
  const PlayListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tracks.isEmpty) {
          return const Center(child: Text('플레이리스트가 비어있습니다.'));
        }

        return CustomScrollView(
          slivers: [
            // 상단 이미지와 플레이리스트 정보
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 첫 번째 트랙 이미지
                    Image.network(
                      controller.tracks.first.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.music_note, size: 100),
                      ),
                    ),
                    // 그라데이션 오버레이
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // 플레이리스트 정보
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              controller.playlistName.value,
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${controller.tracks.length}곡',
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 재생 버튼들
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // 전체 재생 버튼
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.playAllTracks,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('전체 재생'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 셔플 재생 버튼
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.shuffleAndPlay,
                        icon: const Icon(Icons.shuffle),
                        label: const Text('셔플 재생'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 트랙 리스트
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final track = controller.tracks[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        track.thumbnail,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 56,
                          color: AppColors.surface,
                          child: const Icon(Icons.music_note),
                        ),
                      ),
                    ),
                    title: Text(
                      track.title,
                      style: AppTextStyles.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      track.channelTitle,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 재생 버튼
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () => controller.playTrack(index),
                        ),
                        // 삭제 버튼
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => controller.removeTrack(index),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: controller.tracks.length),
            ),
          ],
        );
      }),
    );
  }
}
