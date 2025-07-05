import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/playlist_model.dart';
import '../models/youtube_track_model.dart';
import '../utils/logger.dart';

class PlaylistProvider extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final playlists = <Playlist>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
  }

  /// 플레이리스트 목록 로드
  Future<void> loadPlaylists() async {
    try {
      isLoading.value = true;
      logger.d('플레이리스트 로드 시작');
      final user = _auth.currentUser;
      if (user == null) {
        logger.w('사용자가 로그인하지 않았습니다.');
        isLoading.value = false;
        return;
      }

      final snapshot = await _firestore
          .collection('playlists')
          .where('uid', isEqualTo: user.uid)
          .orderBy('createdAt', descending: false)
          .get();

      final List<Playlist> loadedPlaylists = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final List<dynamic> tracksData = data['tracks'] ?? [];

        final List<YoutubeTrack> tracks = [];
        for (var trackData in tracksData) {
          try {
            final track = YoutubeTrack.fromJson(
              Map<String, dynamic>.from(trackData),
            );
            tracks.add(track);
          } catch (e) {
            logger.w('트랙 데이터 변환 실패: $e');
          }
        }

        final playlist = Playlist(
          id: doc.id,
          uid: data['uid'] as String,
          name: data['name'] as String,
          isDefault: data['isDefault'] ?? false,
          tracks: tracks,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        );
        loadedPlaylists.add(playlist);
      }

      playlists.value = loadedPlaylists;
      logger.d('플레이리스트 로드 완료: ${loadedPlaylists.length}개');
    } catch (e) {
      logger.e('플레이리스트 로드 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 새 플레이리스트 생성
  Future<String?> createPlaylist(String name) async {
    try {
      logger.d('플레이리스트 생성: $name');
      final user = _auth.currentUser;
      if (user == null) {
        logger.w('사용자가 로그인하지 않았습니다.');
        return null;
      }

      final doc = await _firestore.collection('playlists').add({
        'uid': user.uid,
        'name': name,
        'isDefault': false,
        'tracks': [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 플레이리스트 목록 새로고침
      await loadPlaylists();

      logger.d('플레이리스트 생성 완료: ${doc.id}');
      return doc.id;
    } catch (e) {
      logger.e('플레이리스트 생성 실패: $e');
      return null;
    }
  }

  /// 플레이리스트에 트랙 추가
  Future<bool> addTrackToPlaylist(String playlistId, YoutubeTrack track) async {
    try {
      logger.d('트랙 추가: $playlistId, ${track.title}');

      // 중복 확인
      final playlist = playlists.firstWhereOrNull((p) => p.id == playlistId);
      if (playlist != null) {
        final isDuplicate = playlist.tracks.any(
          (t) => t.videoId == track.videoId,
        );
        if (isDuplicate) {
          logger.w('이미 존재하는 트랙입니다.');
          return false;
        }
      }

      final trackData = track.toJson();
      trackData.remove('createdBy');

      await _firestore.collection('playlists').doc(playlistId).update({
        'tracks': FieldValue.arrayUnion([trackData]),
      });

      // 플레이리스트 목록 새로고침
      await loadPlaylists();

      logger.d('트랙 추가 완료');
      return true;
    } catch (e) {
      logger.e('트랙 추가 실패: $e');
      return false;
    }
  }

  /// 플레이리스트에서 트랙 삭제
  Future<bool> removeTrackFromPlaylist(
    String playlistId,
    YoutubeTrack track,
  ) async {
    try {
      logger.d('트랙 삭제: $playlistId, ${track.title}');

      final trackData = track.toJson();
      trackData.remove('createdBy');

      await _firestore.collection('playlists').doc(playlistId).update({
        'tracks': FieldValue.arrayRemove([trackData]),
      });

      // 플레이리스트 목록 새로고침
      await loadPlaylists();

      logger.d('트랙 삭제 완료');
      return true;
    } catch (e) {
      logger.e('트랙 삭제 실패: $e');
      return false;
    }
  }

  /// 자동 플레이리스트 이름 생성
  String generatePlaylistName() {
    int maxNumber = 0;
    final regex = RegExp(r'플레이리스트#(\d+)');

    for (final playlist in playlists) {
      final match = regex.firstMatch(playlist.name);
      if (match != null) {
        final number = int.tryParse(match.group(1) ?? '0') ?? 0;
        if (number > maxNumber) {
          maxNumber = number;
        }
      }
    }

    return '플레이리스트#${maxNumber + 1}';
  }

  /// 플레이리스트 삭제
  Future<bool> deletePlaylist(String playlistId) async {
    try {
      logger.d('플레이리스트 삭제: $playlistId');

      await _firestore.collection('playlists').doc(playlistId).delete();

      // 플레이리스트 목록 새로고침
      await loadPlaylists();

      logger.d('플레이리스트 삭제 완료');
      return true;
    } catch (e) {
      logger.e('플레이리스트 삭제 실패: $e');
      return false;
    }
  }

  /// 플레이리스트 이름 업데이트
  Future<bool> updatePlaylistName(String playlistId, String newName) async {
    try {
      logger.d('플레이리스트 이름 업데이트: $playlistId, $newName');

      await _firestore.collection('playlists').doc(playlistId).update({
        'name': newName,
      });

      // 플레이리스트 목록 새로고침
      await loadPlaylists();

      logger.d('플레이리스트 이름 업데이트 완료');
      return true;
    } catch (e) {
      logger.e('플레이리스트 이름 업데이트 실패: $e');
      return false;
    }
  }
}
