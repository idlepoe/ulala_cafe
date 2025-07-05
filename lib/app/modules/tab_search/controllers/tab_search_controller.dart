import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/search_provider.dart';
import '../../../data/models/youtube_track_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/constants/app_constants.dart';
import '../../../data/utils/logger.dart';
import '../../../data/utils/snackbar_util.dart';
import '../widgets/playlist_selector_dialog.dart';

class TabSearchController extends GetxController {
  final SearchProvider _searchProvider = Get.find<SearchProvider>();
  final TextEditingController searchController = TextEditingController();

  final isSearching = false.obs;
  final isLoadingMore = false.obs;
  final searchResults = <YoutubeTrack>[].obs;
  final hasMoreResults = true.obs;
  final recentSearches = <String>[].obs; // 최근 검색어 목록
  String? _nextPageToken;
  String _currentSearch = '';

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // 최근 검색어 로드
  Future<void> _loadRecentSearches() async {
    logger.d('최근 검색어 로드');
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('search_history')
          .orderBy('searchedAt', descending: true)
          .limit(20)
          .get();

      final searches = snapshot.docs
          .map((doc) => doc.data()['keyword'] as String)
          .toSet() // 중복 제거
          .take(20)
          .toList();

      recentSearches.value = searches;
    } catch (e) {
      logger.e('최근 검색어 로드 실패: $e');
    }
  }

  // 검색어 선택 시 즉시 검색
  void onSearchChipTap(String keyword) {
    searchController.text = keyword;
    searchYouTube(keyword);
  }

  Future<void> searchYouTube(String query) async {
    if (query.trim().isEmpty) return;

    try {
      isSearching.value = true;
      _currentSearch = query;
      _nextPageToken = null;
      hasMoreResults.value = true;

      final result = await _searchProvider.youtubeSearch(search: query);
      final tracks = result['tracks'] as List<YoutubeTrack>;
      _nextPageToken = result['nextPageToken'] as String?;

      searchResults.value = tracks;
      hasMoreResults.value = _nextPageToken != null;

      // 검색 후 최근 검색어 다시 로드
      _loadRecentSearches();
    } catch (e) {
      SnackbarUtil.showError(e.toString());
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadMoreResults() async {
    if (_nextPageToken == null ||
        isLoadingMore.value ||
        !hasMoreResults.value) {
      return;
    }

    try {
      isLoadingMore.value = true;

      final result = await _searchProvider.youtubeSearch(
        search: _currentSearch,
        pageToken: _nextPageToken,
      );

      final tracks = result['tracks'] as List<YoutubeTrack>;
      _nextPageToken = result['nextPageToken'] as String?;

      searchResults.addAll(tracks);
      hasMoreResults.value = _nextPageToken != null;
    } catch (e) {
      SnackbarUtil.showError(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
  }

  /// 플레이리스트 선택 다이얼로그 표시
  void showPlaylistSelector(YoutubeTrack track) {
    Get.dialog(PlaylistSelectorDialog(track: track), barrierDismissible: true);
  }
}
