import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/utils/logger.dart';
import '../../../data/models/youtube_track_model.dart';

class TabLibraryController extends GetxController {
  final playlists = <PlaylistData>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        logger.w('사용자가 로그인하지 않았습니다.');
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('playlists')
          .where('uid', isEqualTo: user.uid)
          .get();

      final List<PlaylistData> loadedPlaylists = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final List<dynamic> tracks = data['tracks'] ?? [];
        YoutubeTrack? firstTrack;

        if (tracks.isNotEmpty && tracks.first is Map) {
          try {
            firstTrack = YoutubeTrack.fromJson(
              Map<String, dynamic>.from(tracks.first),
            );
          } catch (e) {
            logger.w('트랙 데이터 변환 실패: $e');
            firstTrack = null;
          }
        }

        loadedPlaylists.add(
          PlaylistData(
            id: doc.id,
            name: data['name'] as String,
            trackCount: tracks.length,
            thumbnailUrl: firstTrack?.thumbnail ?? '',
          ),
        );
      }

      playlists.value = loadedPlaylists;
    } catch (e) {
      logger.e('플레이리스트 로드 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class PlaylistData {
  final String id;
  final String name;
  final int trackCount;
  final String thumbnailUrl;

  PlaylistData({
    required this.id,
    required this.name,
    required this.trackCount,
    required this.thumbnailUrl,
  });
}
