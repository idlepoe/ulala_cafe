import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/providers/ranking_provider.dart';

class MiniPlayerController extends GetxController {
  late YoutubePlayerController youtubeController;
  final RxBool isPlayerVisible = false.obs;
  final RxBool isPlaying = false.obs;
  final RxString currentVideoId = ''.obs;
  final RxString currentVideoTitle = ''.obs;
  final RxString currentThumbnail = ''.obs;
  final RxDouble currentPosition = 0.0.obs;
  final RxDouble totalDuration = 0.0.obs;

  // 랭킹 업데이트를 위한 RankingProvider
  late RankingProvider _rankingProvider;

  // 플레이리스트 관리
  final RxList<YoutubeTrack> playlist = <YoutubeTrack>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxBool isShuffleMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeYoutubeController();
    _rankingProvider = Get.put(RankingProvider());
  }

  void initializeYoutubeController() {
    youtubeController = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        hideControls: true,
        enableCaption: false,
      ),
    );

    youtubeController.addListener(_playerListener);
  }

  void _playerListener() {
    if (youtubeController.value.isReady) {
      isPlaying.value = youtubeController.value.isPlaying;

      // 진행 시간 업데이트
      final position = youtubeController.value.position.inSeconds.toDouble();
      final duration = youtubeController.value.metaData.duration.inSeconds
          .toDouble();

      currentPosition.value = position;
      totalDuration.value = duration;

      // 재생이 종료되었는지 확인
      if (youtubeController.value.playerState == PlayerState.ended) {
        playNext();
      }
    }
  }

  void playVideo(
    String videoId,
    String title, {
    List<YoutubeTrack>? playlistData,
    int? index,
  }) {
    currentVideoId.value = videoId;
    currentVideoTitle.value = title;
    currentThumbnail.value = YoutubePlayer.getThumbnail(videoId: videoId);

    YoutubeTrack currentTrack;

    // 플레이리스트 설정
    if (playlistData != null) {
      playlist.value = playlistData;
      currentIndex.value = index ?? 0;
      currentTrack = playlistData[index ?? 0];
    } else {
      // 단일 곡 재생 - YoutubeTrack 객체 생성
      currentTrack = YoutubeTrack(
        id: videoId,
        videoId: videoId,
        title: title,
        description: '',
        channelTitle: '',
        thumbnail: YoutubePlayer.getThumbnail(videoId: videoId),
        publishedAt: DateTime.now().toIso8601String(),
      );
      playlist.value = [currentTrack];
      currentIndex.value = 0;
    }

    // 재생 시 랭킹 업데이트 (낙관적 업데이트)
    _rankingProvider.updatePlayCount(currentTrack);

    if (youtubeController.value.isReady) {
      youtubeController.load(videoId);
      isPlaying.value = true;
    } else {
      // 컨트롤러가 준비되지 않았을 때 재초기화
      youtubeController.dispose();
      youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          hideControls: true,
          enableCaption: false,
        ),
      );
      youtubeController.addListener(_playerListener);
      isPlaying.value = true;
    }

    isPlayerVisible.value = true;
  }

  void playAllTracks(List<YoutubeTrack> tracks, {int startIndex = 0}) {
    if (tracks.isEmpty) return;

    isShuffleMode.value = false;
    playlist.value = tracks;
    currentIndex.value = startIndex;

    final track = tracks[startIndex];
    playVideo(
      track.videoId,
      track.title,
      playlistData: tracks,
      index: startIndex,
    );
  }

  void shuffleAndPlay(List<YoutubeTrack> tracks) {
    if (tracks.isEmpty) return;

    isShuffleMode.value = true;
    final shuffledTracks = List<YoutubeTrack>.from(tracks)..shuffle();
    playlist.value = shuffledTracks;
    currentIndex.value = 0;

    final track = shuffledTracks[0];
    playVideo(
      track.videoId,
      track.title,
      playlistData: shuffledTracks,
      index: 0,
    );
  }

  void togglePlayer() {
    if (!youtubeController.value.isReady) return;

    if (youtubeController.value.isPlaying) {
      youtubeController.pause();
      isPlaying.value = false;
    } else {
      youtubeController.play();
      isPlaying.value = true;
    }
  }

  void playPrevious() {
    if (playlist.isEmpty) return;

    if (currentIndex.value > 0) {
      currentIndex.value--;
    } else {
      currentIndex.value = playlist.length - 1; // 마지막 곡으로
    }

    final track = playlist[currentIndex.value];
    _updateCurrentTrack(track);
  }

  void playNext() {
    if (playlist.isEmpty) return;

    if (currentIndex.value < playlist.length - 1) {
      currentIndex.value++;
    } else {
      currentIndex.value = 0; // 첫 번째 곡으로
    }

    final track = playlist[currentIndex.value];
    _updateCurrentTrack(track);
  }

  void _updateCurrentTrack(YoutubeTrack track) {
    currentVideoId.value = track.videoId;
    currentVideoTitle.value = track.title;
    currentThumbnail.value = track.thumbnail;

    if (youtubeController.value.isReady) {
      youtubeController.load(track.videoId);
      isPlaying.value = true;
    } else {
      youtubeController.dispose();
      youtubeController = YoutubePlayerController(
        initialVideoId: track.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          hideControls: true,
          enableCaption: false,
        ),
      );
      youtubeController.addListener(_playerListener);
      isPlaying.value = true;
    }
  }

  void hidePlayer() {
    isPlayerVisible.value = false;
    isPlaying.value = false;
    currentPosition.value = 0.0;
    totalDuration.value = 0.0;
    playlist.clear();
    currentIndex.value = 0;
    isShuffleMode.value = false;
  }

  void seekTo(double seconds) {
    if (youtubeController.value.isReady) {
      youtubeController.seekTo(Duration(seconds: seconds.toInt()));
    }
  }

  @override
  void onClose() {
    youtubeController.removeListener(_playerListener);
    youtubeController.dispose();
    super.onClose();
  }
}
