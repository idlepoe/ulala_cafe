import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/utils/logger.dart';
import '../../main/controllers/mini_player_controller.dart';

class TabHomeController extends GetxController {
  final RxString lastPlaylistTitle = ''.obs;
  final RxString lastPlaylistThumbnail = ''.obs;
  final RxString lastPlaylistId = ''.obs;
  final RxList<YoutubeTrack> lastPlaylistTracks = <YoutubeTrack>[].obs;
  final RxBool hasLastPlaylist = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastPlaylist();
  }

  Future<void> loadLastPlaylist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final title = prefs.getString('last_playlist_title') ?? '';
      final thumbnail = prefs.getString('last_playlist_thumbnail') ?? '';
      final playlistId = prefs.getString('last_playlist_id') ?? '';

      if (title.isNotEmpty && thumbnail.isNotEmpty) {
        lastPlaylistTitle.value = title;
        lastPlaylistThumbnail.value = thumbnail;
        lastPlaylistId.value = playlistId;
        hasLastPlaylist.value = true;
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

      lastPlaylistTitle.value = title;
      lastPlaylistThumbnail.value = thumbnail;
      lastPlaylistId.value = playlistId;
      lastPlaylistTracks.value = tracks;
      hasLastPlaylist.value = true;
    } catch (e) {
      logger.e('마지막 플레이리스트 저장 실패: $e');
    }
  }

  void playLastPlaylist() {
    if (!hasLastPlaylist.value || lastPlaylistTracks.isEmpty) return;

    final miniPlayerController = Get.find<MiniPlayerController>();
    miniPlayerController.playAllTracks(lastPlaylistTracks.toList());
  }

  void shuffleLastPlaylist() {
    if (!hasLastPlaylist.value || lastPlaylistTracks.isEmpty) return;

    final miniPlayerController = Get.find<MiniPlayerController>();
    miniPlayerController.shuffleAndPlay(lastPlaylistTracks.toList());
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
