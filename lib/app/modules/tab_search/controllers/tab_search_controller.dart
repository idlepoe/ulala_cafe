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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TabSearchController extends GetxController {
  final SearchProvider _searchProvider = Get.find<SearchProvider>();
  final TextEditingController searchController = TextEditingController();

  final isSearching = false.obs;
  final isLoadingMore = false.obs;
  final searchResults = <YoutubeTrack>[].obs;
  final hasMoreResults = true.obs;
  final recentSearches = <String>[].obs; // 최근 검색어 목록
  final hasSearchText = false.obs; // 검색창에 텍스트가 있는지 확인
  String? _nextPageToken;
  String _currentSearch = '';

  // 검색 제한 관련 변수들
  final searchCount = 0.obs;
  final maxSearchCount = 3;
  final searchTimeLimit = 10 * 60; // 10분 (초 단위)
  DateTime? _firstSearchTime;
  int _currentCycle = 0;

  final isSearchLimited = false.obs;
  final timeUntilReset = 0.obs; // 다음 리셋까지의 시간 (초)
  final showCountdown = false.obs; // 카운트다운 표시 여부

  Timer? _countdownTimer;

  // SharedPreferences 키들
  static const String _searchCountKey = 'search_count';
  static const String _firstSearchTimeKey = 'first_search_time';
  static const String _searchCycleKey = 'search_cycle';

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
    _loadSearchLimitData();

    // 검색 텍스트 변화 감지
    searchController.addListener(() {
      hasSearchText.value = searchController.text.isNotEmpty;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    _countdownTimer?.cancel();
    super.onClose();
  }

  // SharedPreferences에서 검색 제한 데이터 로드
  Future<void> _loadSearchLimitData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedSearchCount = prefs.getInt(_searchCountKey) ?? 0;
      final savedFirstSearchTime = prefs.getString(_firstSearchTimeKey);
      final savedCycle = prefs.getInt(_searchCycleKey) ?? 0;

      if (savedFirstSearchTime != null) {
        _firstSearchTime = DateTime.parse(savedFirstSearchTime);
        _currentCycle = savedCycle;

        // 현재 주기에서의 검색 상태 계산
        await _calculateCurrentSearchStatus();

        // 카운트다운 시작
        _startCountdownTimer();

        logger.d(
          '검색 제한 데이터 로드 완료 - 검색 횟수: ${searchCount.value}, 첫 검색 시간: $_firstSearchTime',
        );
      }
    } catch (e) {
      logger.e('검색 제한 데이터 로드 실패: $e');
    }
  }

  // 현재 검색 상태 계산
  Future<void> _calculateCurrentSearchStatus() async {
    if (_firstSearchTime == null) return;

    final now = DateTime.now();
    final elapsedSeconds = now.difference(_firstSearchTime!).inSeconds;

    // 현재 주기 계산 (10분마다 리셋)
    final actualCurrentCycle = elapsedSeconds ~/ searchTimeLimit;
    final secondsInCurrentCycle = elapsedSeconds % searchTimeLimit;

    if (actualCurrentCycle > _currentCycle) {
      // 새로운 주기 시작 - 검색 횟수 리셋
      searchCount.value = 0;
      _currentCycle = actualCurrentCycle;
      await _saveSearchCycle(_currentCycle);
    } else {
      // 같은 주기 - 저장된 검색 횟수 유지
      final prefs = await SharedPreferences.getInstance();
      searchCount.value = prefs.getInt(_searchCountKey) ?? 0;
    }

    // 다음 리셋까지의 시간 계산
    timeUntilReset.value = searchTimeLimit - secondsInCurrentCycle;

    // 검색 제한 상태 확인
    isSearchLimited.value = searchCount.value >= maxSearchCount;

    // 카운트다운 표시 여부 결정
    showCountdown.value = searchCount.value > 0;
  }

  // 카운트다운 타이머 시작
  void _startCountdownTimer() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeUntilReset.value > 0) {
        timeUntilReset.value--;
      } else {
        // 새로운 주기 시작
        _handleNewCycle();
      }
    });
  }

  // 새로운 주기 처리
  Future<void> _handleNewCycle() async {
    searchCount.value = 0;
    _currentCycle++;
    isSearchLimited.value = false;
    timeUntilReset.value = searchTimeLimit;

    await _saveSearchCycle(_currentCycle);
    await _saveSearchLimitData();

    logger.d('새로운 검색 주기 시작 - 주기: $_currentCycle');
  }

  // 검색 주기 저장
  Future<void> _saveSearchCycle(int cycle) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_searchCycleKey, cycle);
    } catch (e) {
      logger.e('검색 주기 저장 실패: $e');
    }
  }

  // SharedPreferences에 검색 제한 데이터 저장
  Future<void> _saveSearchLimitData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(_searchCountKey, searchCount.value);
      await prefs.setInt(_searchCycleKey, _currentCycle);
      if (_firstSearchTime != null) {
        await prefs.setString(
          _firstSearchTimeKey,
          _firstSearchTime!.toIso8601String(),
        );
      }

      logger.d(
        '검색 제한 데이터 저장 완료 - 검색 횟수: ${searchCount.value}, 주기: $_currentCycle',
      );
    } catch (e) {
      logger.e('검색 제한 데이터 저장 실패: $e');
    }
  }

  // SharedPreferences에서 검색 제한 데이터 삭제
  Future<void> _clearSearchLimitData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_searchCountKey);
      await prefs.remove(_firstSearchTimeKey);
      await prefs.remove(_searchCycleKey);

      searchCount.value = 0;
      _firstSearchTime = null;
      _currentCycle = 0;
      isSearchLimited.value = false;
      timeUntilReset.value = 0;
      showCountdown.value = false;

      _countdownTimer?.cancel();

      logger.d('검색 제한 데이터 삭제 완료');
    } catch (e) {
      logger.e('검색 제한 데이터 삭제 실패: $e');
    }
  }

  // 검색 제한 확인
  Future<bool> _checkSearchLimit() async {
    // 첫 번째 검색이면 허용
    if (_firstSearchTime == null) {
      return true;
    }

    // 현재 상태 업데이트
    await _calculateCurrentSearchStatus();

    // 검색 횟수 제한 확인
    return searchCount.value < maxSearchCount;
  }

  // 다음 리셋까지의 시간을 포맷팅
  String get formattedTimeUntilReset {
    final minutes = timeUntilReset.value ~/ 60;
    final seconds = timeUntilReset.value % 60;
    return '${minutes}분 ${seconds}초';
  }

  // 검색 가능 횟수
  int get remainingSearchCount {
    return maxSearchCount - searchCount.value;
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
    searchYouTube(keyword, isRecentSearch: true);
  }

  Future<void> searchYouTube(
    String query, {
    bool isRecentSearch = false,
  }) async {
    if (query.trim().isEmpty) return;

    // 새로운 검색일 때만 검색 제한 확인 (최근 검색어는 캐시에서 반환되므로 제한하지 않음)
    if (!isRecentSearch && !(await _checkSearchLimit())) {
      SnackbarUtil.showWarning(
        'YouTube 검색 제한으로 인해 검색이 제한되었습니다. ${formattedTimeUntilReset} 후 다시 시도해주세요.',
      );
      return;
    }

    try {
      isSearching.value = true;
      _currentSearch = query;
      _nextPageToken = null;
      hasMoreResults.value = true;

      final result = await _searchProvider.youtubeSearch(search: query);
      final tracks = result['tracks'] as List<YoutubeTrack>;
      _nextPageToken = result['nextPageToken'] as String?;
      final fromCache = result['fromCache'] as bool? ?? false;

      // 실제 YouTube 검색이 일어났을 때만 검색 횟수 증가
      if (!fromCache) {
        // 첫 번째 검색이면 시작 시간 설정
        if (_firstSearchTime == null) {
          _firstSearchTime = DateTime.now();
          timeUntilReset.value = searchTimeLimit;
          _startCountdownTimer();
        }

        searchCount.value++;
        showCountdown.value = true;
        isSearchLimited.value = searchCount.value >= maxSearchCount;

        // SharedPreferences에 저장
        await _saveSearchLimitData();

        logger.d('실제 YouTube 검색 수행 - 검색 횟수: ${searchCount.value}');
      } else {
        logger.d('캐시에서 검색 결과 반환 - 검색 횟수 증가하지 않음');
      }

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
    _currentSearch = '';
    _nextPageToken = null;
    hasMoreResults.value = true;
  }

  /// 플레이리스트 선택 다이얼로그 표시
  void showPlaylistSelector(YoutubeTrack track) {
    Get.dialog(PlaylistSelectorDialog(track: track), barrierDismissible: true);
  }
}
