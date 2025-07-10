import 'dart:ui';
import 'dart:io';

import 'package:get/get.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:ulala_cafe/app/data/utils/logger.dart';
import 'package:ulala_cafe/main.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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

  // 웹에서 키보드 단축키 표시용
  final RxBool showKeyboardShortcuts = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeYoutubeController();
    _rankingProvider = Get.put(RankingProvider());

    // 웹에서 키보드 단축키 표시
    if (kIsWeb) {
      showKeyboardShortcuts.value = true;
    }

    // pip 초기화 (웹이 아닌 경우에만)
    if (!kIsWeb) {
      _initPip();
      // 앱 생명주기 감지 (웹이 아닌 경우에만)
      _setupAppLifecycleListener();
    } else {
      logger.i('PiP and lifecycle listener skipped on web platform');
    }
  }

  void initializeYoutubeController() {
    youtubeController = YoutubePlayerController();
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

    // 비디오 로드 및 재생
    youtubeController.loadVideoById(videoId: track.videoId);
    isPlaying.value = true;
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
    if (isPlaying.value) {
      youtubeController.pauseVideo();
      isPlaying.value = false;
    } else {
      youtubeController.playVideo();
      isPlaying.value = true;
    }
  }

  void playPlayer() {
    youtubeController.playVideo();
    isPlaying.value = true;
  }

  void pausePlayer() {
    youtubeController.pauseVideo();
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
    youtubeController.loadVideoById(videoId: track.videoId);
    isPlaying.value = true;
  }

  void hidePlayer() {
    isPlayerVisible.value = false;
    isPlaying.value = false;
    currentPosition.value = 0.0;
    totalDuration.value = 0.0;
    playlist.clear();
    currentIndex.value = 0;
    isShuffleMode.value = false;

    // 플레이어를 숨길 때 PiP 모드 비활성화 (Windows 제외)
    if (!kIsWeb && !Platform.isWindows) {
      _disableAutoPipMode();
    }
  }

  void seekTo(double seconds) {
    youtubeController.seekTo(seconds: seconds);
  }

  /// 키보드 단축키 처리 (웹 전용)
  bool handleKeyboardShortcut(KeyEvent event) {
    if (!kIsWeb || !isPlayerVisible.value) return false;

    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.space:
          togglePlayer();
          return true;
        case LogicalKeyboardKey.arrowLeft:
          playPrevious();
          return true;
        case LogicalKeyboardKey.arrowRight:
          playNext();
          return true;
        case LogicalKeyboardKey.escape:
          hidePlayer();
          return true;
        case LogicalKeyboardKey.keyH:
          // H 키로 키보드 단축키 도움말 토글
          toggleKeyboardShortcuts();
          return true;
        default:
          return false;
      }
    }
    return false;
  }

  /// 키보드 단축키 정보 표시/숨기기 토글
  void toggleKeyboardShortcuts() {
    if (kIsWeb) {
      showKeyboardShortcuts.value = !showKeyboardShortcuts.value;
    }
  }

  @override
  void onClose() {
    // PiP 모드 비활성화 (웹과 Windows 제외)
    if (!kIsWeb && !Platform.isWindows) {
      try {
        _disableAutoPipMode();
      } catch (e) {
        logger.w('PiP disable failed during close: $e');
      }
    }

    try {
      youtubeController.close();
    } catch (e) {
      logger.w('YouTube controller close failed: $e');
    }

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
    // 웹과 Windows 플랫폼에서는 PiP 모드를 지원하지 않으므로 초기화하지 않음
    if (kIsWeb || Platform.isWindows) {
      logger.i('PiP not supported on Windows/Web platform');
      return;
    }

    try {
      // SimplePip 플러그인이 사용 가능한지 먼저 확인
      bool isPipSupported = false;
      try {
        isPipSupported = await SimplePip.isPipAvailable;
        logger.i('PiP Support for autoPipMode: $isPipSupported');
      } catch (e) {
        logger.w('PiP availability check failed: $e');
        return;
      }

      if (isPipSupported) {
        _pip = SimplePip();
        logger.i('PiP instance created successfully');
      }
    } catch (e) {
      logger.e('PiP initialization failed: $e');
    }
  }

  /// AutoPipMode 활성화 (재생 중일 때)
  Future<void> _enableAutoPipMode() async {
    // 웹과 Windows 플랫폼에서는 PiP 모드를 지원하지 않으므로 활성화하지 않음
    if (kIsWeb || Platform.isWindows) {
      return;
    }

    if (_pip != null && isPlaying.value && isPlayerVisible.value) {
      try {
        await _pip!.setAutoPipMode();
        logger.i('AutoPipMode enabled');
      } catch (e) {
        logger.e('Failed to enable AutoPipMode: $e');
      }
    }
  }

  /// AutoPipMode 비활성화 (재생 중이 아닐 때)
  Future<void> _disableAutoPipMode() async {
    // 웹과 Windows 플랫폼에서는 PiP 모드를 지원하지 않으므로 비활성화하지 않음
    if (kIsWeb || Platform.isWindows) {
      return;
    }

    if (_pip != null) {
      try {
        await _pip!.setAutoPipMode(autoEnter: false);
        logger.i('AutoPipMode disabled');
      } catch (e) {
        logger.e('Failed to disable AutoPipMode: $e');
      }
    }
  }

  /// 앱 생명주기 리스너 설정
  void _setupAppLifecycleListener() {
    // 웹과 Windows 플랫폼에서는 PiP 모드를 지원하지 않으므로 리스너를 설정하지 않음
    if (kIsWeb || Platform.isWindows) {
      logger.i('PiP lifecycle listener not set on Windows/Web platform');
      return;
    }

    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          if (isPipModeActive.value) {
            isPipModeActive.value = false;
            isPlayerVisible.value = true;
          }
        },
        suspendingCallBack: () async {
          if (isPlayerVisible.value && isPlaying.value) {
            isPipModeActive.value = true;
            isPlayerVisible.value = false;
          }
        },
      ),
    );
  }
}

/// 앱 생명주기 이벤트 핸들러
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? resumeCallBack;
  final Future<void> Function()? suspendingCallBack;

  LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) await resumeCallBack!();
        break;
      case AppLifecycleState.paused:
        if (suspendingCallBack != null) await suspendingCallBack!();
        break;
      default:
        break;
    }
  }
}
