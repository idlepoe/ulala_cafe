import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/utils/logger.dart';
import '../../../data/utils/snackbar_util.dart';
import '../../../data/providers/playlist_provider.dart';
import '../widgets/edit_playlist_modal.dart';
import '../widgets/delete_playlist_dialog.dart';
import '../../tab_library/controllers/tab_library_controller.dart';
import 'dart:math';
import '../../main/controllers/mini_player_controller.dart';
import '../../tab_home/controllers/tab_home_controller.dart';

class PlayListController extends GetxController {
  final playlistId = ''.obs;
  final playlistName = '플레이리스트'.obs;
  final tracks = <YoutubeTrack>[].obs;
  final isLoading = true.obs;
  final miniPlayerController = Get.find<MiniPlayerController>();
  final playlistProvider = Get.find<PlaylistProvider>();

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
      _saveLastPlaylistInfo();
    }
  }

  void playAllTracks() {
    if (tracks.isNotEmpty) {
      miniPlayerController.playAllTracks(tracks.toList());
      _saveLastPlaylistInfo();
    }
  }

  void shuffleAndPlay() {
    if (tracks.isNotEmpty) {
      miniPlayerController.shuffleAndPlay(tracks.toList());
      _saveLastPlaylistInfo();
    }
  }

  void _saveLastPlaylistInfo() {
    if (tracks.isEmpty) return;

    try {
      // 홈 컨트롤러가 등록되어 있는지 확인
      if (Get.isRegistered<TabHomeController>()) {
        final homeController = Get.find<TabHomeController>();
        homeController.saveLastPlaylist(
          title: playlistName.value,
          thumbnail: tracks.first.thumbnail,
          playlistId: playlistId.value,
          tracks: tracks.toList(),
        );
      }
    } catch (e) {
      logger.e('마지막 플레이리스트 정보 저장 실패: $e');
    }
  }

  Future<void> removeTrack(int index) async {
    if (index >= 0 && index < tracks.length) {
      final trackToRemove = tracks[index];

      try {
        final success = await playlistProvider.removeTrackFromPlaylist(
          playlistId.value,
          trackToRemove,
        );

        if (success) {
          // 로컬 리스트에서도 제거
          tracks.removeAt(index);
          logger.d('트랙 삭제 완료: ${trackToRemove.title}');
        } else {
          logger.w('트랙 삭제 실패');
        }
      } catch (e) {
        logger.e('트랙 삭제 중 오류 발생: $e');
      }
    }
  }

  void showEditPlaylistModal() {
    Get.bottomSheet(
      EditPlaylistModal(
        playlistId: playlistId.value,
        currentName: playlistName.value,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((newName) {
      if (newName != null && newName is String) {
        playlistName.value = newName;
      }
    });
  }

  void showDeletePlaylistDialog() {
    Get.dialog(
      DeletePlaylistDialog(
        playlistName: playlistName.value,
        onConfirm: _deletePlaylist,
      ),
    );
  }

  Future<void> _deletePlaylist() async {
    try {
      final success = await playlistProvider.deletePlaylist(playlistId.value);

      if (success) {
        SnackbarUtil.showSuccess('플레이리스트가 삭제되었습니다.');

        // 라이브러리 화면으로 돌아가기
        if (Get.isRegistered<TabLibraryController>()) {
          final libraryController = Get.find<TabLibraryController>();
          libraryController.closePlaylist();
        }

        // 현재 화면 닫기
        Get.back();
      } else {
        SnackbarUtil.showError('플레이리스트 삭제에 실패했습니다.');
      }
    } catch (e) {
      logger.e('플레이리스트 삭제 중 오류 발생: $e');
      SnackbarUtil.showError('플레이리스트 삭제 중 오류가 발생했습니다.');
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
