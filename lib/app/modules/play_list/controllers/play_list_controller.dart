import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/utils/logger.dart';
import 'dart:math';
import '../../main/controllers/mini_player_controller.dart';

class PlayListController extends GetxController {
  final playlistId = ''.obs;
  final playlistName = '플레이리스트'.obs;
  final tracks = <YoutubeTrack>[].obs;
  final isLoading = true.obs;
  final miniPlayerController = Get.find<MiniPlayerController>();

  @override
  void onInit() {
    super.onInit();
    logger.d('onInit');
    final arguments = Get.arguments;
    logger.d('arguments: $arguments');
    if (arguments != null && arguments is Map<String, dynamic>) {
      final playlistId = arguments['playlistId'];
      if (playlistId != null) {
        loadPlaylist(playlistId);
      }
    }
    // arguments가 null이어도 기본 상태로 시작
    isLoading.value = false;
  }

  void loadPlaylistById(String id) {
    logger.d('loadPlaylistById: $id');
    playlistId.value = id;
    loadPlaylist(id);
  }

  Future<void> loadPlaylist(String playlistId) async {
    logger.d('loadPlaylist: $playlistId');
    try {
      isLoading.value = true;

      // Firestore에서 플레이리스트 데이터 로딩
      final doc = await FirebaseFirestore.instance
          .collection('playlists')
          .doc(playlistId)
          .get();

      if (!doc.exists) {
        logger.w('플레이리스트를 찾을 수 없습니다.');
        return;
      }

      final data = doc.data()!;
      playlistName.value = data['name'] as String;

      final List<dynamic> trackList = data['tracks'] ?? [];
      final List<YoutubeTrack> loadedTracks = [];

      for (var trackData in trackList) {
        try {
          final track = YoutubeTrack.fromJson(
            Map<String, dynamic>.from(trackData),
          );
          loadedTracks.add(track);
        } catch (e) {
          logger.w('트랙 데이터 변환 실패: $e');
        }
      }

      tracks.value = loadedTracks;
    } catch (e) {
      logger.e('플레이리스트 로딩 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void playTrack(int index) {
    if (index >= 0 && index < tracks.length) {
      miniPlayerController.playAllTracks(tracks.toList(), startIndex: index);
    }
  }

  void playAllTracks() {
    if (tracks.isNotEmpty) {
      miniPlayerController.playAllTracks(tracks.toList());
    }
  }

  void shuffleAndPlay() {
    if (tracks.isNotEmpty) {
      miniPlayerController.shuffleAndPlay(tracks.toList());
    }
  }

  void removeTrack(int index) {
    if (index >= 0 && index < tracks.length) {
      tracks.removeAt(index);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
