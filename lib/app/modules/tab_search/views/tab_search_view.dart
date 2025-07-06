import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tab_search_controller.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/utils/snackbar_util.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../data/utils/toss_loading_indicator.dart';
import '../widgets/playlist_selector_dialog.dart';

class TabSearchView extends GetView<TabSearchController> {
  const TabSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '검색',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 24.0),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      hintText: '음악을 검색해보세요',
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller.searchYouTube(value);
                      }
                    },
                  ),
                ),
                // 검색창 초기화 버튼
                Obx(() {
                  if (controller.hasSearchText.value) {
                    return GestureDetector(
                      onTap: () {
                        controller.clearSearch();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                          size: 20.0,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(width: 8.0),
                Obx(() {
                  if (controller.isSearching.value) {
                    return const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: TossLoadingIndicator(size: 40, strokeWidth: 3.0),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),

          // 검색 제한 안내 문구
          Obx(() {
            if (controller.isSearchLimited.value) {
              return Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[600],
                      size: 20.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        'YouTube 검색 제한으로 인해 새로운 검색이 제한되었습니다. ${controller.formattedTimeUntilReset} 후 검색 횟수가 충전됩니다.\n(최근 검색어는 계속 사용 가능합니다)',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // 검색 횟수 및 카운트다운 표시
          Obx(() {
            if (controller.showCountdown.value) {
              return Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.blue[600],
                      size: 16.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '검색 가능: ${controller.remainingSearchCount}번 남음 | 충전까지: ${controller.formattedTimeUntilReset}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          const SizedBox(height: 16.0),
          // 최근 검색어 Chips
          Obx(() {
            if (controller.recentSearches.isEmpty)
              return const SizedBox.shrink();
            return SizedBox(
              height: 40.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.recentSearches.length,
                itemBuilder: (context, index) {
                  final keyword = controller.recentSearches[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 8.0,
                      right: index == controller.recentSearches.length - 1
                          ? 0
                          : 0,
                    ),
                    child: ActionChip(
                      label: Text(
                        keyword,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      onPressed: () => controller.onSearchChipTap(keyword),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 16.0),
          Expanded(
            child: Obx(() {
              if (controller.searchResults.isNotEmpty) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      if (controller.hasMoreResults.value &&
                          !controller.isLoadingMore.value) {
                        controller.loadMoreResults();
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        controller.searchResults.length +
                        (controller.hasMoreResults.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.searchResults.length &&
                          controller.hasMoreResults.value) {
                        return _buildLoadingIndicator();
                      }
                      final track = controller.searchResults[index];
                      return _buildSearchResultItem(track);
                    },
                  ),
                );
              }

              // 검색 결과가 없을 때의 중앙 메시지
              if (controller.isSearchLimited.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48.0,
                        color: Colors.orange[400],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'YouTube 검색 제한',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '${controller.formattedTimeUntilReset} 후 검색 횟수가 충전됩니다',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.orange[600],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '(최근 검색어는 계속 사용 가능합니다)',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.orange[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: Text(
                  '음악을 검색해보세요\n(10분마다 3번의 검색 기회가 제공됩니다)',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(YoutubeTrack track) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              track.thumbnail,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: Icon(Icons.music_note, color: Colors.grey[600]),
                );
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  track.description,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.showPlaylistSelector(track),
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.blue,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Center(
        child: TossLoadingIndicator(size: 40, strokeWidth: 3.0),
      ),
    );
  }
}
