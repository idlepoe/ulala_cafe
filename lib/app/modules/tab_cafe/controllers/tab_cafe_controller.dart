import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_edit_modal.dart';
import '../../../data/providers/chat_provider.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../data/utils/snackbar_util.dart';
import '../../../data/utils/logger.dart';
import '../../../data/models/youtube_track_model.dart';
import '../widgets/music_attach_modal.dart';

class TabCafeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = Rxn<User>();
  final ChatProvider _chatProvider = Get.put(ChatProvider());

  // 채팅 관련
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // 현재 사용자 정보 초기화
    user.value = _auth.currentUser;

    // 사용자 상태 변경 감지
    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
    });

    // 새 메시지가 올 때마다 스크롤을 맨 아래로 (reverse 모드에서는 맨 위로)
    _chatProvider.messages.listen((_) {
      _scrollToBottom();
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // 표시할 사용자 이름 가져오기 (displayName이 없으면 uid 앞 5자 사용)
  String get displayName {
    final currentUser = user.value;
    if (currentUser == null) return 'Guest';
    if (currentUser.displayName?.isNotEmpty == true) {
      return currentUser.displayName!;
    }
    // uid의 앞 5자만 표시
    return currentUser.uid.length >= 5
        ? currentUser.uid.substring(0, 5)
        : currentUser.uid;
  }

  // 프로필 이미지 URL 가져오기
  String? get photoUrl {
    return user.value?.photoURL;
  }

  // 채팅 메시지 목록
  List<ChatMessage> get messages => _chatProvider.messages;

  // 활성 사용자 수
  int get activeUsers => _chatProvider.activeUsers.value;

  // 더 많은 메시지가 있는지 확인
  bool get hasMoreMessages => _chatProvider.hasMoreMessages.value;

  // 더 많은 메시지 로딩 중인지 확인
  bool get isLoadingMore => _chatProvider.isLoadingMore.value;

  // 프로필 수정 모달 표시
  void showProfileEditModal() {
    Get.bottomSheet(
      const ProfileEditModal(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((result) {
      if (result == true) {
        // 프로필 업데이트 후 사용자 정보 새로고침
        _refreshUserInfo();
      }
    });
  }

  // 사용자 정보 새로고침
  Future<void> _refreshUserInfo() async {
    await _auth.currentUser?.reload();
    user.value = _auth.currentUser;
  }

  // 메시지 전송
  Future<void> sendMessage(String messageText) async {
    final success = await _chatProvider.sendMessage(messageText);

    if (success) {
      // 메시지 전송 성공 시 스크롤을 하단으로 이동
      _scrollToBottom();
    } else {
      SnackbarUtil.showError('메시지 전송에 실패했습니다');
    }
  }

  // 텍스트 메시지 전송 (텍스트 필드에서 입력)
  Future<void> sendTextMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) return;

    await sendMessage(messageText);

    // 메시지 전송 완료 후 텍스트 필드 초기화
    messageController.clear();
  }

  // 스크롤을 맨 아래로 (reverse 모드에서는 맨 위로)
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController
              .position
              .minScrollExtent, // reverse 모드에서는 minScrollExtent가 하단
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 메시지 삭제
  Future<void> deleteMessage(ChatMessage message) async {
    final success = await _chatProvider.deleteMessage(message.id, message.uid);

    if (!success) {
      SnackbarUtil.showError('메시지 삭제에 실패했습니다.');
    }
  }

  // 현재 사용자인지 확인
  bool isMyMessage(ChatMessage message) {
    return user.value?.uid == message.uid;
  }

  // 이전 메시지 더 불러오기
  Future<void> loadMoreMessages() async {
    await _chatProvider.loadMoreMessages();
  }

  // 음악 첨부 모달 표시
  void showMusicAttachModal() {
    logger.d('TabCafeController: 음악 첨부 모달 표시');
    Get.bottomSheet(
      MusicAttachModal(
        onTrackSelected: (track) {
          logger.d('TabCafeController: 트랙 선택됨 - ${track.title}');
          _sendMusicMessage(track);
        },
      ),
      isScrollControlled: true,
    );
  }

  // 음악 정보가 포함된 메시지 전송
  void _sendMusicMessage(YoutubeTrack track) {
    logger.d('TabCafeController: 음악 메시지 생성 - ${track.title}');
    _sendMusicMessageWithTrack(track);
  }

  // YoutubeTrack 데이터와 함께 음악 메시지 전송
  Future<void> _sendMusicMessageWithTrack(YoutubeTrack track) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        logger.w('로그인된 사용자가 없습니다.');
        return;
      }

      final message = ChatMessage(
        id: '', // Firestore에서 자동 생성
        uid: user.uid,
        displayName: user.displayName?.isNotEmpty == true
            ? user.displayName!
            : (user.uid.length >= 5 ? user.uid.substring(0, 5) : user.uid),
        photoUrl: user.photoURL,
        message: '🎵 ${track.title}', // 간단한 텍스트
        timestamp: DateTime.now(),
        type: 'music',
        youtubeTrack: track,
      );

      final success = await _chatProvider.sendMusicMessage(message);

      if (success) {
        logger.d('TabCafeController: 음악 메시지 전송 완료');
        _scrollToBottom();
      } else {
        SnackbarUtil.showError('음악 메시지 전송에 실패했습니다');
      }
    } catch (e) {
      logger.e('TabCafeController: 음악 메시지 전송 실패 - $e');
      SnackbarUtil.showError('음악 메시지 전송에 실패했습니다');
    }
  }
}
