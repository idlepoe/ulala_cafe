import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/utils/logger.dart';
import '../../tab_search/widgets/playlist_selector_dialog.dart';
import '../../main/controllers/mini_player_controller.dart';

class MusicMessageWidget extends StatelessWidget {
  final YoutubeTrack track;
  final bool isMyMessage;

  const MusicMessageWidget({
    Key? key,
    required this.track,
    required this.isMyMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isMyMessage ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 썸네일
          Stack(
            children: [
              Image.network(
                track.thumbnail,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 120,
                    color: AppColors.background,
                    child: const Icon(
                      Icons.music_note,
                      size: 40,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
              ),
              // 재생 버튼 오버레이
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _playTrack(track),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 음악 정보
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Text(
                  track.title,
                  style: AppTextStyles.h4.copyWith(
                    color: isMyMessage
                        ? AppColors.surface
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // 채널명
                Text(
                  track.channelTitle,
                  style: AppTextStyles.body2.copyWith(
                    color: isMyMessage
                        ? AppColors.surface.withOpacity(0.8)
                        : AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // 설명 (첫 줄만)
                if (track.description.isNotEmpty) ...[
                  Text(
                    track.description,
                    style: AppTextStyles.body2.copyWith(
                      color: isMyMessage
                          ? AppColors.surface.withOpacity(0.7)
                          : AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                ],

                // 버튼들
                Row(
                  children: [
                    // 재생 버튼
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _playTrack(track),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isMyMessage
                              ? AppColors.surface
                              : AppColors.primary,
                          foregroundColor: isMyMessage
                              ? AppColors.primary
                              : AppColors.surface,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text('재생', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // 플레이리스트 추가 버튼
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _addToPlaylist(track),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isMyMessage
                              ? AppColors.surface
                              : AppColors.primary,
                          side: BorderSide(
                            color: isMyMessage
                                ? AppColors.surface
                                : AppColors.primary,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.playlist_add, size: 18),
                        label: const Text('추가', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _playTrack(YoutubeTrack track) {
    logger.d('MusicMessageWidget: 재생 버튼 클릭 - ${track.title}');

    try {
      // MiniPlayerController를 통해 재생
      final miniPlayerController = Get.find<MiniPlayerController>();
      miniPlayerController.playVideo(track.videoId, track.title);

      Get.snackbar(
        '재생 시작',
        track.title,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
        colorText: AppColors.surface,
      );
    } catch (e) {
      logger.e('MusicMessageWidget: 재생 실패 - $e');
      Get.snackbar(
        '재생 실패',
        '음악을 재생할 수 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.error,
        colorText: AppColors.surface,
      );
    }
  }

  void _addToPlaylist(YoutubeTrack track) {
    logger.d('MusicMessageWidget: 플레이리스트 추가 버튼 클릭 - ${track.title}');

    Get.dialog(PlaylistSelectorDialog(track: track), barrierDismissible: true);
  }
}
