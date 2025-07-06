import 'package:get/get.dart';
import '../../../data/providers/ranking_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/utils/logger.dart';
import '../../main/controllers/mini_player_controller.dart';
import 'dart:convert';

class TabHomeController extends GetxController {
  final RxString lastPlaylistTitle = ''.obs;
  final RxString lastPlaylistThumbnail = ''.obs;
  final RxString lastPlaylistId = ''.obs;
  final RxList<YoutubeTrack> lastPlaylistTracks = <YoutubeTrack>[].obs;
  final RxBool hasLastPlaylist = false.obs;
  final RxBool isLoadingRankings = false.obs;

  late RankingProvider _rankingProvider;

  @override
  void onInit() {
    super.onInit();

    // RankingProvider가 등록되어 있지 않으면 등록
    if (!Get.isRegistered<RankingProvider>()) {
      Get.put(RankingProvider());
    }
    _rankingProvider = Get.find<RankingProvider>();

    loadLastPlaylist();

    // 랭킹 데이터 로드
    _rankingProvider.loadAllRankings();
  }

  Future<void> loadLastPlaylist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final title = prefs.getString('last_playlist_title') ?? '';
      final thumbnail = prefs.getString('last_playlist_thumbnail') ?? '';
      final playlistId = prefs.getString('last_playlist_id') ?? '';
      final tracksJson = prefs.getString('last_playlist_tracks') ?? '';

      if (title.isNotEmpty && thumbnail.isNotEmpty) {
        lastPlaylistTitle.value = title;
        lastPlaylistThumbnail.value = thumbnail;
        lastPlaylistId.value = playlistId;

        // tracks 데이터 로드
        if (tracksJson.isNotEmpty) {
          try {
            final List<dynamic> tracksList = json.decode(tracksJson);
            final List<YoutubeTrack> tracks = tracksList
                .map(
                  (trackData) => YoutubeTrack.fromJson(
                    Map<String, dynamic>.from(trackData),
                  ),
                )
                .toList();
            lastPlaylistTracks.value = tracks;
            logger.d('마지막 플레이리스트 tracks 로드 완료: ${tracks.length}개');
          } catch (e) {
            logger.e('tracks 데이터 파싱 실패: $e');
            lastPlaylistTracks.clear();
          }
        } else {
          logger.w('저장된 tracks 데이터가 없음');
          lastPlaylistTracks.clear();
        }

        hasLastPlaylist.value = true;
        logger.d('마지막 플레이리스트 로드 완료: $title (${lastPlaylistTracks.length}개 트랙)');
      }
    } catch (e) {
      logger.e('마지막 플레이리스트 로드 실패: $e');
    }
  }

  Future<void> saveLastPlaylist({
    required String title,
    required String thumbnail,
    required String playlistId,
    required List<YoutubeTrack> tracks,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_playlist_title', title);
      await prefs.setString('last_playlist_thumbnail', thumbnail);
      await prefs.setString('last_playlist_id', playlistId);

      // tracks 데이터를 JSON으로 변환하여 저장
      final tracksJson = json.encode(
        tracks.map((track) => track.toJson()).toList(),
      );
      await prefs.setString('last_playlist_tracks', tracksJson);

      lastPlaylistTitle.value = title;
      lastPlaylistThumbnail.value = thumbnail;
      lastPlaylistId.value = playlistId;
      lastPlaylistTracks.value = tracks;
      hasLastPlaylist.value = true;

      logger.d('마지막 플레이리스트 저장 완료: $title (${tracks.length}개 트랙)');
    } catch (e) {
      logger.e('마지막 플레이리스트 저장 실패: $e');
    }
  }

  void playLastPlaylist() {
    logger.d(
      'playLastPlaylist 호출 - hasLastPlaylist: ${hasLastPlaylist.value}, tracks: ${lastPlaylistTracks.length}',
    );

    if (!hasLastPlaylist.value || lastPlaylistTracks.isEmpty) {
      logger.w('재생할 수 없음 - 플레이리스트 없음 또는 트랙 없음');
      return;
    }

    try {
      final miniPlayerController = Get.find<MiniPlayerController>();
      miniPlayerController.playAllTracks(lastPlaylistTracks.toList());
      logger.d('마지막 플레이리스트 재생 시작: ${lastPlaylistTitle.value}');
    } catch (e) {
      logger.e('마지막 플레이리스트 재생 실패: $e');
    }
  }

  void shuffleLastPlaylist() {
    logger.d(
      'shuffleLastPlaylist 호출 - hasLastPlaylist: ${hasLastPlaylist.value}, tracks: ${lastPlaylistTracks.length}',
    );

    if (!hasLastPlaylist.value || lastPlaylistTracks.isEmpty) {
      logger.w('셔플 재생할 수 없음 - 플레이리스트 없음 또는 트랙 없음');
      return;
    }

    try {
      final miniPlayerController = Get.find<MiniPlayerController>();
      miniPlayerController.shuffleAndPlay(lastPlaylistTracks.toList());
      logger.d('마지막 플레이리스트 셔플 재생 시작: ${lastPlaylistTitle.value}');
    } catch (e) {
      logger.e('마지막 플레이리스트 셔플 재생 실패: $e');
    }
  }

  // 인기 차트 getter들
  List<YoutubeTrack> get dailyRankings => _rankingProvider.dailyRankings
      .map((ranking) => ranking.toYoutubeTrack())
      .toList();

  List<YoutubeTrack> get weeklyRankings => _rankingProvider.weeklyRankings
      .map((ranking) => ranking.toYoutubeTrack())
      .toList();

  List<YoutubeTrack> get monthlyRankings => _rankingProvider.monthlyRankings
      .map((ranking) => ranking.toYoutubeTrack())
      .toList();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
