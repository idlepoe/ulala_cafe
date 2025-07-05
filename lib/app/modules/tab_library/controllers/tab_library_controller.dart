import 'package:get/get.dart';
import '../../../data/utils/logger.dart';
import '../../../data/providers/playlist_provider.dart';
import '../../../data/models/playlist_model.dart';
import '../../play_list/controllers/play_list_controller.dart';
import '../widgets/create_playlist_modal.dart';
import '../../main/controllers/main_controller.dart';
import 'package:flutter/material.dart';

class TabLibraryController extends GetxController {
  final PlaylistProvider _playlistProvider = Get.find<PlaylistProvider>();
  final showPlaylistView = false.obs;
  final selectedPlaylistId = ''.obs;

  List<Playlist> get playlists => _playlistProvider.playlists;
  bool get isLoading => _playlistProvider.isLoading.value;
  bool get isEmpty => !isLoading && playlists.isEmpty;

  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    await _playlistProvider.loadPlaylists();
  }

  void openPlaylist(String playlistId) {
    logger.d('openPlaylist: $playlistId');
    selectedPlaylistId.value = playlistId;

    // PlayListController가 없으면 생성
    if (!Get.isRegistered<PlayListController>()) {
      Get.put(PlayListController());
    }

    // PlayListController에 플레이리스트 ID 전달하고 로드
    final playListController = Get.find<PlayListController>();
    playListController.loadPlaylistById(playlistId);

    showPlaylistView.value = true;
  }

  void closePlaylist() {
    showPlaylistView.value = false;
    selectedPlaylistId.value = '';

    // PlayListController 제거
    if (Get.isRegistered<PlayListController>()) {
      Get.delete<PlayListController>();
    }
  }

  void showCreatePlaylistModal() {
    final playlistName = _playlistProvider.generatePlaylistName();

    Get.bottomSheet(
      CreatePlaylistModal(initialName: playlistName),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void goToSearchTab() {
    if (Get.isRegistered<MainController>()) {
      final mainController = Get.find<MainController>();
      mainController.changePage(1); // 검색 탭으로 이동 (인덱스 1)
    }
  }
}
