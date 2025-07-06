import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../controllers/tab_home_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../main/controllers/mini_player_controller.dart';
import '../../tab_search/widgets/playlist_selector_dialog.dart';

class TabHomeView extends GetView<TabHomeController> {
  const TabHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
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

            SizedBox(height: AppSizes.marginXL),

            // 인기 차트 섹션
            _buildPopularCharts(),
          ],
        ),
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

  Widget _buildPopularCharts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('인기 차트', style: AppTextStyles.h2),
            Obx(
              () => controller.isLoadingRankings.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        SizedBox(height: AppSizes.marginL),

        // 일일 인기
        Obx(() => _buildChartSection('오늘의 인기 음악', controller.dailyRankings)),
        SizedBox(height: AppSizes.marginL),

        // 주간 인기
        Obx(() => _buildChartSection('이번 주 인기 음악', controller.weeklyRankings)),
        SizedBox(height: AppSizes.marginL),

        // 월간 인기
        Obx(() => _buildChartSection('이번 달 인기 음악', controller.monthlyRankings)),
      ],
    );
  }

  Widget _buildChartSection(String title, List<dynamic> tracks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h4),
        SizedBox(height: AppSizes.marginM),

        if (tracks.isEmpty)
          Container(
            height: 200, // 버튼 추가로 높이 증가
            alignment: Alignment.center,
            child: Text(
              '재생된 음악이 없습니다',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          SizedBox(
            height: 200, // 버튼 추가로 높이 증가
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return _buildTrackCard(track, index + 1);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTrackCard(dynamic track, int rank) {
    return Container(
      width: 180, // 카드 폭을 늘림
      margin: EdgeInsets.only(right: AppSizes.marginM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 썸네일과 순위
          GestureDetector(
            onTap: () => _playTrack(track),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusM),
                  ),
                  child: Image.network(
                    track.thumbnail,
                    width: double.infinity,
                    height: 90, // 썸네일 높이를 늘림
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 90,
                      color: AppColors.background,
                      child: const Icon(
                        Icons.music_note,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
                // 순위 표시
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: rank <= 3
                          ? AppColors.primary
                          : Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$rank',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 음악 정보
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8), // 패딩을 늘림
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 제목 (marquee)
                  SizedBox(
                    height: 18,
                    child: Marquee(
                      text: track.title,
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 20.0,
                      velocity: 30.0,
                      pauseAfterRound: Duration(seconds: 1),
                      showFadingOnlyWhenScrolling: true,
                      fadingEdgeStartFraction: 0.1,
                      fadingEdgeEndFraction: 0.1,
                      numberOfRounds: 3,
                      startPadding: 0.0,
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                  SizedBox(height: 4),
                  // 설명 (고정)
                  Text(
                    track.description.isNotEmpty
                        ? track.description
                        : '설명이 없습니다',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Toss 스타일 플레이리스트 추가 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton.icon(
                onPressed: () => _showPlaylistSelector(track),
                icon: Icon(
                  Icons.playlist_add,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: Text(
                  '추가',
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  side: BorderSide(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingS,
                    vertical: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _playTrack(dynamic track) {
    // MiniPlayerController를 통해 바로 재생
    try {
      final miniPlayerController = Get.find<MiniPlayerController>();
      miniPlayerController.playVideo(track.videoId, track.title);
    } catch (e) {
      // 에러 처리
      Get.snackbar(
        '재생 오류',
        '음악을 재생할 수 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showPlaylistSelector(dynamic track) {
    Get.dialog(PlaylistSelectorDialog(track: track), barrierDismissible: true);
  }
}
