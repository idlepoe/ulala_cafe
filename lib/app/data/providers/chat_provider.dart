import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/chat_message_model.dart';
import '../models/youtube_track_model.dart';
import '../models/playlist_model.dart';
import '../utils/logger.dart';

class ChatProvider extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final messages = <ChatMessage>[].obs;
  final activeUsers = 0.obs;

  String get _cafeCollectionPath => 'cafe_chat';
  String get _activeUsersPath => 'cafe/active_users';

  @override
  void onInit() {
    super.onInit();
    _listenToMessages();
    _trackUserPresence();
  }

  @override
  void onClose() {
    _removeUserPresence();
    super.onClose();
  }

  /// 메시지 스트림 감지
  void _listenToMessages() {
    _firestore
        .collection(_cafeCollectionPath)
        .orderBy('timestamp', descending: false)
        .limit(100) // 최근 100개 메시지만
        .snapshots()
        .listen((snapshot) {
          final List<ChatMessage> loadedMessages = [];

          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();
              data['id'] = doc.id;
              final message = ChatMessage.fromJson(data);
              loadedMessages.add(message);
            } catch (e) {
              logger.w('메시지 파싱 실패: $e');
            }
          }

          messages.value = loadedMessages;
        });
  }

  /// 메시지 전송
  Future<bool> sendMessage(String messageText) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        logger.w('로그인된 사용자가 없습니다.');
        return false;
      }

      final message = ChatMessage(
        id: '', // Firestore에서 자동 생성
        uid: user.uid,
        displayName: user.displayName?.isNotEmpty == true
            ? user.displayName!
            : (user.uid.length >= 5 ? user.uid.substring(0, 5) : user.uid),
        photoUrl: user.photoURL,
        message: messageText.trim(),
        timestamp: DateTime.now(),
        type: 'text',
      );

      await _firestore.collection(_cafeCollectionPath).add(message.toJson());

      logger.d('메시지 전송 완료: $messageText');
      return true;
    } catch (e) {
      logger.e('메시지 전송 실패: $e');
      return false;
    }
  }

  /// 사용자 활성 상태 추적
  void _trackUserPresence() {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final userRef = _database.ref().child('$_activeUsersPath/${user.uid}');

      // 사용자 온라인 상태 설정
      userRef.set({
        'displayName': user.displayName?.isNotEmpty == true
            ? user.displayName!
            : (user.uid.length >= 5 ? user.uid.substring(0, 5) : user.uid),
        'photoUrl': user.photoURL,
        'lastSeen': ServerValue.timestamp,
      });

      // 연결 해제 시 자동 제거
      userRef.onDisconnect().remove();

      // 활성 사용자 수 감지
      _database.ref().child(_activeUsersPath).onValue.listen((event) {
        final data = event.snapshot.value;
        if (data is Map) {
          activeUsers.value = data.length;
        } else {
          activeUsers.value = 0;
        }
      });
    } catch (e) {
      logger.e('사용자 활성 상태 추적 실패: $e');
    }
  }

  /// 사용자 활성 상태 제거
  void _removeUserPresence() {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final userRef = _database.ref().child('$_activeUsersPath/${user.uid}');
      userRef.remove();
    } catch (e) {
      logger.e('사용자 활성 상태 제거 실패: $e');
    }
  }

  /// 메시지 삭제 (본인 메시지만)
  Future<bool> deleteMessage(String messageId, String messageUid) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.uid != messageUid) {
        logger.w('메시지 삭제 권한이 없습니다.');
        return false;
      }

      await _firestore.collection(_cafeCollectionPath).doc(messageId).delete();

      logger.d('메시지 삭제 완료: $messageId');
      return true;
    } catch (e) {
      logger.e('메시지 삭제 실패: $e');
      return false;
    }
  }

  /// 이전 메시지 더 불러오기
  Future<void> loadMoreMessages() async {
    try {
      if (messages.isEmpty) return;

      final lastMessage = messages.first;
      final query = await _firestore
          .collection(_cafeCollectionPath)
          .orderBy('timestamp', descending: true)
          .startAfter([lastMessage.timestamp])
          .limit(20)
          .get();

      final List<ChatMessage> olderMessages = [];

      for (var doc in query.docs) {
        try {
          final data = doc.data();
          data['id'] = doc.id;
          final message = ChatMessage.fromJson(data);
          olderMessages.add(message);
        } catch (e) {
          logger.w('이전 메시지 파싱 실패: $e');
        }
      }

      // 기존 메시지 앞에 추가
      messages.insertAll(0, olderMessages.reversed);
    } catch (e) {
      logger.e('이전 메시지 로드 실패: $e');
    }
  }

  // 사용자의 모든 플레이리스트에서 유튜브 트랙을 가져오는 메서드
  Future<List<YoutubeTrack>> getAllUserTracks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final playlistsSnapshot = await FirebaseFirestore.instance
          .collection('playlists')
          .where('uid', isEqualTo: user.uid)
          .get();

      List<YoutubeTrack> allTracks = [];

      for (var playlistDoc in playlistsSnapshot.docs) {
        final playlist = Playlist.fromJson(playlistDoc.data());
        allTracks.addAll(playlist.tracks);
      }

      return allTracks;
    } catch (e) {
      print('Error getting user tracks: $e');
      return [];
    }
  }
}
