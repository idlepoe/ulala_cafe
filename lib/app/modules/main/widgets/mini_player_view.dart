import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../controllers/mini_player_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';

class MiniPlayerView extends GetView<MiniPlayerController> {
  const MiniPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Widget miniPlayer = AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: controller.isPlayerVisible.value
            ? (kIsWeb && controller.showKeyboardShortcuts.value ? 80 : 80)
            : 0,
        child: controller.isPlayerVisible.value
            ? Stack(
                children: [
                  // 숨겨진 YoutubePlayer (실제 재생을 위해 필요)
                  Positioned(
                    left: -1000,
                    top: -1000,
                    child: SizedBox(
                      width: 1,
                      height: 1,
                      child: YoutubePlayer(
                        controller: controller.youtubeController,
                      ),
                    ),
                  ),
                  // Toss 스타일 미니 플레이어 UI
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 진행바
                        Obx(
                          () => LinearProgressIndicator(
                            value: controller.totalDuration.value > 0
                                ? controller.currentPosition.value /
                                      controller.totalDuration.value
                                : 0.0,
                            backgroundColor: const Color(0xFFF5F5F5),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF3182F6),
                            ),
                            minHeight: 2,
                          ),
                        ),
                        // 메인 컨텐츠
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                // 썸네일
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Image.network(
                                      controller.currentThumbnail.value,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: const Color(0xFFF5F5F5),
                                                child: const Icon(
                                                  Icons.music_note,
                                                  color: Color(0xFF8B95A1),
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // 제목
                                Expanded(
                                  child: Text(
                                    controller.currentVideoTitle.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF191F28),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // 컨트롤 버튼들
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 이전 곡 버튼
                                    _buildControlButton(
                                      icon: Icons.skip_previous,
                                      onPressed: controller.playPrevious,
                                    ),
                                    const SizedBox(width: 8),
                                    // 재생/일시정지 버튼
                                    Obx(
                                      () => _buildControlButton(
                                        icon: controller.isPlaying.value
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        onPressed: controller.togglePlayer,
                                        isPrimary: true,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // 다음 곡 버튼
                                    _buildControlButton(
                                      icon: Icons.skip_next,
                                      onPressed: controller.playNext,
                                    ),
                                    const SizedBox(width: 15),
                                    // 닫기 버튼
                                    _buildControlButton(
                                      icon: Icons.close,
                                      onPressed: controller.hidePlayer,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      );

      // 키보드 단축키 기능 추가
      return Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          return controller.handleKeyboardShortcut(event)
              ? KeyEventResult.handled
              : KeyEventResult.ignored;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            miniPlayer,
            // 키보드 단축키 정보 표시 (Toss 스타일) - 웹에서만
            if (kIsWeb &&
                controller.showKeyboardShortcuts.value &&
                controller.isPlayerVisible.value)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  border: Border(
                    top: BorderSide(color: const Color(0xFFE9ECEF), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3182F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('💡', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '키보드 단축키',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191F28),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '스페이스바: 재생/일시정지 • ←→: 이전/다음 곡 • ESC: 닫기 • H: 도움말 토글',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8B95A1),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.toggleKeyboardShortcuts,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Color(0xFF8B95A1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF3182F6) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : const Color(0xFF8B95A1),
          size: isPrimary ? 24 : 20,
        ),
      ),
    );
  }
}
