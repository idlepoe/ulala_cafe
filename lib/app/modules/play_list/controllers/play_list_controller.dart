import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/utils/logger.dart';

class PlayListController extends GetxController {
  final playlistId = ''.obs;
  final playlistName = ''.obs;
  final tracks = <YoutubeTrack>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments = Get.arguments;
    playlistId.value = arguments['playlistId'];
    loadPlaylist();
  }

  Future<void> loadPlaylist() async {
    try {
      isLoading.value = true;
      final doc = await FirebaseFirestore.instance
          .collection('playlists')
          .doc(playlistId.value)
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
      logger.e('플레이리스트 로드 실패: $e');
    } finally {
      isLoading.value = false;
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
