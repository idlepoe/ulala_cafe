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
              return const Center(
                child: Text(
                  '검색어를 입력하고 Enter를 눌러주세요',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
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
