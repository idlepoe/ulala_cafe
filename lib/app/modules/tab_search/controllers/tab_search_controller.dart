import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/search_provider.dart';
import '../../../data/models/youtube_track_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/constants/app_constants.dart';
import '../../../data/utils/logger.dart';

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
      Get.snackbar('오류', e.toString(), snackPosition: SnackPosition.BOTTOM);
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
      Get.snackbar('오류', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingMore.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
  }

  /// 플레이리스트(좋아요 표시한 곡)에 트랙 추가
  Future<String?> addTrackToPlaylist(YoutubeTrack track) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar(
          '오류',
          '로그인 정보가 없습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
      final uid = user.uid;
      final playlistName = '좋아요 표시한 곡';
      // playlists 컬렉션에서 해당 유저의 기본 플레이리스트 찾기
      final query = await FirebaseFirestore.instance
          .collection('playlists')
          .where('uid', isEqualTo: uid)
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();
      String playlistId;
      if (query.docs.isEmpty) {
        // 없으면 새로 생성
        final trackData = track.toJson()..remove('createdBy');
        final doc = await FirebaseFirestore.instance
            .collection('playlists')
            .add({
              'uid': uid,
              'name': playlistName,
              'isDefault': true,
              'tracks': [trackData],
              'createdAt': FieldValue.serverTimestamp(),
            });
        playlistId = doc.id;
      } else {
        // 있으면 트랙 추가 (중복 방지)
        final doc = query.docs.first;
        playlistId = doc.id;
        final List<dynamic> tracks = doc['tracks'] ?? [];
        if (!tracks.any(
          (t) => t is Map ? t['videoId'] == track.videoId : t == track.videoId,
        )) {
          final trackData = track.toJson()..remove('createdBy');
          await doc.reference.update({
            'tracks': FieldValue.arrayUnion([trackData]),
          });
        }
      }
      return playlistName;
    } catch (e) {
      logger.e('트랙 추가 오류: $e');
      Get.snackbar('오류', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }
}
