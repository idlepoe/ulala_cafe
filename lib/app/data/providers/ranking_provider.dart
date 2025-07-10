import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/track_ranking_model.dart';
import '../models/youtube_track_model.dart';
import '../utils/logger.dart';

class RankingProvider extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'track_ranking';

  final RxList<TrackRanking> dailyRankings = <TrackRanking>[].obs;
  final RxList<TrackRanking> weeklyRankings = <TrackRanking>[].obs;
  final RxList<TrackRanking> monthlyRankings = <TrackRanking>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 초기 랭킹 로드
    loadAllRankings();
  }

  /// 음악 재생 시 랭킹 업데이트 (낙관적 업데이트)
  Future<void> updatePlayCount(YoutubeTrack track) async {
    try {
      logger.d('RankingProvider: 재생 카운트 업데이트 시작 - ${track.title}');
      logger.d('RankingProvider: description 길이 - ${track.description.length}');

      final now = DateTime.now();
      final dayKey = DateFormat('yyyy-MM-dd').format(now);
      final weekKey = _getWeekKey(now);
      final monthKey = DateFormat('yyyy-MM').format(now);

      final docRef = _firestore.collection(_collectionPath).doc(track.videoId);

      // 낙관적 업데이트: 로컬에서 먼저 업데이트
      _updateLocalRankings(track, dayKey, weekKey, monthKey);

      // description이 비어있으면 기본값 설정
      final description = track.description.isNotEmpty
          ? track.description
          : '설명이 없습니다';

      // Firestore 업데이트 (merge와 FieldValue.increment 사용)
      await docRef.set({
        'videoId': track.videoId,
        'title': track.title,
        'channelTitle': track.channelTitle,
        'thumbnail': track.thumbnail,
        'description': description,
        'publishedAt': track.publishedAt,
        'duration': track.duration,
        'totalPlayCount': FieldValue.increment(1),
        'dailyCounts.$dayKey': FieldValue.increment(1),
        'weeklyCounts.$weekKey': FieldValue.increment(1),
        'monthlyCounts.$monthKey': FieldValue.increment(1),
        'lastPlayedAt': Timestamp.fromDate(now),
      }, SetOptions(merge: true));

      logger.d('RankingProvider: 재생 카운트 업데이트 완료 - description: $description');
    } catch (e) {
      logger.e('RankingProvider: 재생 카운트 업데이트 실패 - $e');
      // 실패 시 다시 랭킹 로드하여 동기화
      loadAllRankings();
    }
  }

  /// 로컬 랭킹 낙관적 업데이트
  void _updateLocalRankings(
    YoutubeTrack track,
    String dayKey,
    String weekKey,
    String monthKey,
  ) {
    // 일일 랭킹 업데이트
    _updateLocalRankingList(dailyRankings, track, dayKey, 'daily');

    // 주간 랭킹 업데이트
    _updateLocalRankingList(weeklyRankings, track, weekKey, 'weekly');

    // 월간 랭킹 업데이트
    _updateLocalRankingList(monthlyRankings, track, monthKey, 'monthly');
  }

  void _updateLocalRankingList(
    RxList<TrackRanking> rankingList,
    YoutubeTrack track,
    String timeKey,
    String type,
  ) {
    final existingIndex = rankingList.indexWhere(
      (ranking) => ranking.videoId == track.videoId,
    );

    if (existingIndex != -1) {
      // 기존 항목 업데이트
      final existing = rankingList[existingIndex];
      final updatedCounts = Map<String, int>.from(
        type == 'daily'
            ? existing.dailyCounts
            : type == 'weekly'
            ? existing.weeklyCounts
            : existing.monthlyCounts,
      );
      updatedCounts[timeKey] = (updatedCounts[timeKey] ?? 0) + 1;

      final updated = existing.copyWith(
        totalPlayCount: existing.totalPlayCount + 1,
        dailyCounts: type == 'daily' ? updatedCounts : existing.dailyCounts,
        weeklyCounts: type == 'weekly' ? updatedCounts : existing.weeklyCounts,
        monthlyCounts: type == 'monthly'
            ? updatedCounts
            : existing.monthlyCounts,
        lastPlayedAt: DateTime.now(),
      );

      rankingList[existingIndex] = updated;
    } else {
      // 새 항목 추가
      final newRanking = TrackRanking.fromYoutubeTrack(track).copyWith(
        totalPlayCount: 1,
        dailyCounts: type == 'daily' ? {timeKey: 1} : {},
        weeklyCounts: type == 'weekly' ? {timeKey: 1} : {},
        monthlyCounts: type == 'monthly' ? {timeKey: 1} : {},
      );
      rankingList.add(newRanking);
    }

    // 정렬 (해당 기간의 카운트 기준)
    rankingList.sort((a, b) {
      final aCount = type == 'daily'
          ? (a.dailyCounts[timeKey] ?? 0)
          : type == 'weekly'
          ? (a.weeklyCounts[timeKey] ?? 0)
          : (a.monthlyCounts[timeKey] ?? 0);
      final bCount = type == 'daily'
          ? (b.dailyCounts[timeKey] ?? 0)
          : type == 'weekly'
          ? (b.weeklyCounts[timeKey] ?? 0)
          : (b.monthlyCounts[timeKey] ?? 0);
      return bCount.compareTo(aCount);
    });

    // 상위 30개만 유지
    if (rankingList.length > 30) {
      rankingList.removeRange(30, rankingList.length);
    }
  }

  /// 모든 랭킹 로드
  Future<void> loadAllRankings() async {
    try {
      await Future.wait([
        loadDailyRanking(),
        loadWeeklyRanking(),
        loadMonthlyRanking(),
      ]);
    } catch (e) {
      logger.e('RankingProvider: 전체 랭킹 로드 실패 - $e');
    }
  }

  /// 일일 인기 음악 로드
  Future<void> loadDailyRanking() async {
    try {
      final now = DateTime.now();
      final today = DateFormat('yyyy-MM-dd').format(now);

      // 전체 랭킹 데이터를 가져와서 클라이언트에서 필터링/정렬
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('lastPlayedAt', descending: true)
          .limit(50)
          .get();

      final rankings = <TrackRanking>[];

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();

          // 안전한 데이터 파싱
          final safeData = _safeParseFirestoreData(data);
          final ranking = TrackRanking.fromJson({...safeData, 'id': doc.id});

          // 오늘 재생 수가 있는 트랙만 필터링
          final todayCount = ranking.dailyCounts[today] ?? 0;
          if (todayCount > 0) {
            rankings.add(ranking);
          }
        } catch (e) {
          logger.e('RankingProvider: 문서 파싱 실패 - ${doc.id}: $e');
        }
      }

      // 오늘 재생 수로 정렬
      rankings.sort(
        (a, b) =>
            (b.dailyCounts[today] ?? 0).compareTo(a.dailyCounts[today] ?? 0),
      );

      // 상위 30개만 유지
      if (rankings.length > 30) {
        rankings.removeRange(30, rankings.length);
      }

      dailyRankings.value = rankings;
    } catch (e) {
      logger.e('RankingProvider: 일일 랭킹 로드 실패 - $e');
    }
  }

  /// 주간 인기 음악 로드
  Future<void> loadWeeklyRanking() async {
    try {
      final now = DateTime.now();
      final thisWeek = _getWeekKey(now);

      // 전체 랭킹 데이터를 가져와서 클라이언트에서 필터링/정렬
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('lastPlayedAt', descending: true)
          .limit(50)
          .get();

      final rankings = <TrackRanking>[];

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();

          // 안전한 데이터 파싱
          final safeData = _safeParseFirestoreData(data);
          final ranking = TrackRanking.fromJson({...safeData, 'id': doc.id});

          // 이번 주 재생 수가 있는 트랙만 필터링
          final weekCount = ranking.weeklyCounts[thisWeek] ?? 0;
          if (weekCount > 0) {
            rankings.add(ranking);
          }
        } catch (e) {
          logger.e('RankingProvider: 문서 파싱 실패 - ${doc.id}: $e');
        }
      }

      // 이번 주 재생 수로 정렬
      rankings.sort(
        (a, b) => (b.weeklyCounts[thisWeek] ?? 0).compareTo(
          a.weeklyCounts[thisWeek] ?? 0,
        ),
      );

      // 상위 30개만 유지
      if (rankings.length > 30) {
        rankings.removeRange(30, rankings.length);
      }

      weeklyRankings.value = rankings;
    } catch (e) {
      logger.e('RankingProvider: 주간 랭킹 로드 실패 - $e');
    }
  }

  /// 월간 인기 음악 로드
  Future<void> loadMonthlyRanking() async {
    try {
      final now = DateTime.now();
      final thisMonth = DateFormat('yyyy-MM').format(now);

      // 전체 랭킹 데이터를 가져와서 클라이언트에서 필터링/정렬
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('lastPlayedAt', descending: true)
          .limit(50)
          .get();

      final rankings = <TrackRanking>[];

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();

          // 안전한 데이터 파싱
          final safeData = _safeParseFirestoreData(data);
          final ranking = TrackRanking.fromJson({...safeData, 'id': doc.id});

          // 이번 달 재생 수가 있는 트랙만 필터링
          final monthCount = ranking.monthlyCounts[thisMonth] ?? 0;
          if (monthCount > 0) {
            rankings.add(ranking);
          }
        } catch (e) {
          logger.e('RankingProvider: 문서 파싱 실패 - ${doc.id}: $e');
        }
      }

      // 이번 달 재생 수로 정렬
      rankings.sort(
        (a, b) => (b.monthlyCounts[thisMonth] ?? 0).compareTo(
          a.monthlyCounts[thisMonth] ?? 0,
        ),
      );

      // 상위 30개만 유지
      if (rankings.length > 30) {
        rankings.removeRange(30, rankings.length);
      }

      monthlyRankings.value = rankings;
    } catch (e) {
      logger.e('RankingProvider: 월간 랭킹 로드 실패 - $e');
    }
  }

  /// 주차 계산 (ISO 8601 week)
  String _getWeekKey(DateTime date) {
    // ISO 8601 주차 계산
    final startOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(startOfYear).inDays;
    final weekNumber = ((days + startOfYear.weekday - 1) / 7).ceil();
    return '${date.year}-W${weekNumber.toString().padLeft(2, '0')}';
  }

  /// Firestore 데이터를 안전하게 파싱
  Map<String, dynamic> _safeParseFirestoreData(Map<String, dynamic> data) {
    final result = <String, dynamic>{};

    // 각 counts Map을 재구성
    final dailyCounts = <String, int>{};
    final weeklyCounts = <String, int>{};
    final monthlyCounts = <String, int>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key.startsWith('dailyCounts.')) {
        // dailyCounts.2025-07-06: 1 → dailyCounts['2025-07-06'] = 1
        final dateKey = key.substring('dailyCounts.'.length);
        dailyCounts[dateKey] = (value as num).toInt();
      } else if (key.startsWith('weeklyCounts.')) {
        // weeklyCounts.2025-W27: 1 → weeklyCounts['2025-W27'] = 1
        final weekKey = key.substring('weeklyCounts.'.length);
        weeklyCounts[weekKey] = (value as num).toInt();
      } else if (key.startsWith('monthlyCounts.')) {
        // monthlyCounts.2025-07: 1 → monthlyCounts['2025-07'] = 1
        final monthKey = key.substring('monthlyCounts.'.length);
        monthlyCounts[monthKey] = (value as num).toInt();
      } else if (key == 'dailyCounts' ||
          key == 'weeklyCounts' ||
          key == 'monthlyCounts') {
        // 기존 Map 형태가 있다면 그대로 사용
        if (value is Map) {
          final targetMap = key == 'dailyCounts'
              ? dailyCounts
              : key == 'weeklyCounts'
              ? weeklyCounts
              : monthlyCounts;
          for (var mapEntry in value.entries) {
            targetMap[mapEntry.key.toString()] = (mapEntry.value as num)
                .toInt();
          }
        }
      } else {
        // 일반 필드들
        result[key] = value;
      }
    }

    // 재구성된 counts Map들을 결과에 추가
    result['dailyCounts'] = dailyCounts;
    result['weeklyCounts'] = weeklyCounts;
    result['monthlyCounts'] = monthlyCounts;

    return result;
  }
}
