import 'dart:ui';

import 'package:get/get.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:ulala_cafe/app/data/utils/logger.dart';
import 'package:ulala_cafe/main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/widgets.dart';
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

  // autoPipMode 관리용
  SimplePip? _pip;

  final progressPercentage = 0.0.obs; // 재생 진행률 (0.0 ~ 1.0)

  final isPipModeActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeYoutubeController();
    _rankingProvider = Get.put(RankingProvider());

    // pip 초기화
    _initPip();

    // 앱 생명주기 감지
    _setupAppLifecycleListener();
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

      progressPercentage.value = position / duration;

      // autoPipMode 관리 - 재생 중이고 플레이어가 보일 때만 활성화
      if (isPlaying.value && isPlayerVisible.value) {
        _enableAutoPipMode();
      } else {
        _disableAutoPipMode();
      }

      // 재생이 종료되었는지 확인
      if (youtubeController.value.playerState == PlayerState.ended) {
        _handlePlaybackEnd();
      }
    }
  }

  void _handlePlaybackEnd() {
    // 플레이리스트가 없거나 마지막 곡인 경우 플레이어 닫기
    if (playlist.isEmpty || currentIndex.value >= playlist.length - 1) {
      hidePlayer();
    } else {
      // 다음 곡으로 넘어가기
      currentIndex.value++;
      final track = playlist[currentIndex.value];
      _updateCurrentTrack(track);
    }
  }

  void playVideo(
    YoutubeTrack track, {
    List<YoutubeTrack>? playlistData,
    int? index,
  }) {
    currentVideoId.value = track.videoId;
    currentVideoTitle.value = track.title;
    currentThumbnail.value = track.thumbnail;

    YoutubeTrack currentTrack;

    // 플레이리스트 설정
    if (playlistData != null) {
      playlist.value = playlistData;
      currentIndex.value = index ?? 0;
      currentTrack = playlistData[index ?? 0];
    } else {
      // 단일 곡 재생
      currentTrack = track;
      playlist.value = [track];
      currentIndex.value = 0;
    }

    // 재생 시 랭킹 업데이트 (낙관적 업데이트)
    _rankingProvider.updatePlayCount(currentTrack);

    if (youtubeController.value.isReady) {
      youtubeController.load(track.videoId);
      isPlaying.value = true;
    } else {
      // 컨트롤러가 준비되지 않았을 때 재초기화
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

    isPlayerVisible.value = true;
  }

  void playAllTracks(List<YoutubeTrack> tracks, {int startIndex = 0}) {
    if (tracks.isEmpty) return;

    isShuffleMode.value = false;
    playlist.value = tracks;
    currentIndex.value = startIndex;

    final track = tracks[startIndex];
    playVideo(track, playlistData: tracks, index: startIndex);
  }

  void shuffleAndPlay(List<YoutubeTrack> tracks) {
    if (tracks.isEmpty) return;

    isShuffleMode.value = true;
    final shuffledTracks = List<YoutubeTrack>.from(tracks)..shuffle();
    playlist.value = shuffledTracks;
    currentIndex.value = 0;

    final track = shuffledTracks[0];
    playVideo(track, playlistData: shuffledTracks, index: 0);
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

  void playPlayer() {
    if (!youtubeController.value.isReady) return;
    youtubeController.play();
    isPlaying.value = true;
  }

  void pausePlayer() {
    if (!youtubeController.value.isReady) return;
    youtubeController.pause();
    isPlaying.value = false;
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
      final track = playlist[currentIndex.value];
      _updateCurrentTrack(track);
    } else {
      // 마지막 곡에서 다음 버튼을 눌렀을 때는 첫 번째 곡으로 이동
      currentIndex.value = 0;
      final track = playlist[currentIndex.value];
      _updateCurrentTrack(track);
    }
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

    // 플레이어를 숨길 때 PiP 모드 비활성화
    _disableAutoPipMode();
  }

  void seekTo(double seconds) {
    if (youtubeController.value.isReady) {
      youtubeController.seekTo(Duration(seconds: seconds.toInt()));
    }
  }

  @override
  void onClose() {
    // PiP 모드 비활성화
    _disableAutoPipMode();

    youtubeController.removeListener(_playerListener);
    youtubeController.dispose();
    super.onClose();
  }

  /// 시간을 포맷하는 유틸리티 메서드
  String formatTime(double seconds) {
    if (seconds.isNaN || seconds.isInfinite) return '0:00';

    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// PiP 초기화 (autoPipMode 관리용)
  Future<void> _initPip() async {
    try {
      bool isPipSupported = await SimplePip.isPipAvailable;
      logger.i('PiP Support for autoPipMode: $isPipSupported');

      if (isPipSupported) {
        _pip = SimplePip();
      }
    } catch (e) {
      logger.e('PiP initialization error: $e');
    }
  }

  /// AutoPipMode 활성화 (재생 중일 때)
  Future<void> _enableAutoPipMode() async {
    if (_pip != null && isPlaying.value && isPlayerVisible.value) {
      try {
        await _pip!.setAutoPipMode();
        logger.d('AutoPipMode enabled - playing and visible');
      } catch (e) {
        logger.e('Failed to enable AutoPipMode: $e');
      }
    }
  }

  /// AutoPipMode 비활성화 (재생 중이 아닐 때)
  Future<void> _disableAutoPipMode() async {
    if (_pip != null) {
      try {
        // simple_pip_mode에서 autoPipMode를 비활성화하는 직접적인 방법이 없으므로
        // 새 인스턴스를 생성하여 기본 상태로 리셋
        await _pip!.setAutoPipMode(autoEnter: false);
        logger.d('AutoPipMode disabled - not playing or hidden');
      } catch (e) {
        logger.e('Failed to disable AutoPipMode: $e');
      }
    }
  }

  /// 앱 생명주기 리스너 설정
  void _setupAppLifecycleListener() {
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () async {
          // 앱이 완전히 종료될 때 PiP 모드 비활성화
          logger.d('App detached - disabling PiP mode');
          await _disableAutoPipMode();
        },
        pausedCallBack: () async {
          // 앱이 백그라운드로 갈 때 재생 중이 아니면 PiP 모드 비활성화
          if (!isPlaying.value) {
            logger.d('App paused and not playing - disabling PiP mode');
            await _disableAutoPipMode();
          }
        },
        resumedCallBack: () async {
          // 앱이 포그라운드로 돌아올 때 상태 확인
          logger.d('App resumed - checking PiP mode');
        },
      ),
    );
  }
}

/// 앱 생명주기 이벤트 핸들러
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? detachedCallBack;
  final Future<void> Function()? pausedCallBack;
  final Future<void> Function()? resumedCallBack;

  LifecycleEventHandler({
    this.detachedCallBack,
    this.pausedCallBack,
    this.resumedCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        if (detachedCallBack != null) await detachedCallBack!();
        break;
      case AppLifecycleState.paused:
        if (pausedCallBack != null) await pausedCallBack!();
        break;
      case AppLifecycleState.resumed:
        if (resumedCallBack != null) await resumedCallBack!();
        break;
      default:
        break;
    }
  }
}
