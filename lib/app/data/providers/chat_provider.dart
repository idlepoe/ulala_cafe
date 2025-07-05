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

  /// 음악 메시지 전송
  Future<bool> sendMusicMessage(ChatMessage message) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        logger.w('로그인된 사용자가 없습니다.');
        return false;
      }

      // 수동으로 JSON 직렬화 처리
      final messageData = <String, dynamic>{
        'id': message.id,
        'uid': message.uid,
        'displayName': message.displayName,
        'photoUrl': message.photoUrl,
        'message': message.message,
        'timestamp': Timestamp.fromDate(message.timestamp),
        'type': message.type,
      };

      // youtubeTrack이 있는 경우 수동으로 추가
      if (message.youtubeTrack != null) {
        messageData['youtubeTrack'] = message.youtubeTrack!.toJson();
      }

      await _firestore.collection(_cafeCollectionPath).add(messageData);

      logger.d('음악 메시지 전송 완료: ${message.message}');
      return true;
    } catch (e) {
      logger.e('음악 메시지 전송 실패: $e');
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
      logger.d('getAllUserTracks 시작');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        logger.w('사용자가 로그인되지 않음');
        return [];
      }

      logger.d('사용자 UID: ${user.uid}');

      final playlistsSnapshot = await FirebaseFirestore.instance
          .collection('playlists')
          .where('uid', isEqualTo: user.uid)
          .get();

      logger.d('플레이리스트 조회 완료: ${playlistsSnapshot.docs.length}개');

      List<YoutubeTrack> allTracks = [];

      for (var playlistDoc in playlistsSnapshot.docs) {
        logger.d('플레이리스트 처리 중: ${playlistDoc.id}');
        final data = playlistDoc.data();
        logger.d('플레이리스트 raw 데이터: ${data.toString()}');

        // tracks 필드 상세 확인
        if (data.containsKey('tracks')) {
          final tracksData = data['tracks'];
          logger.d('tracks 필드 타입: ${tracksData.runtimeType}');
          logger.d(
            'tracks 필드 길이: ${tracksData is List ? tracksData.length : 'N/A'}',
          );
          if (tracksData is List && tracksData.isNotEmpty) {
            logger.d('첫 번째 트랙 데이터: ${tracksData[0]}');
          }
        } else {
          logger.w('플레이리스트에 tracks 필드가 없음: ${playlistDoc.id}');
        }

        try {
          // 안전하게 트랙 데이터 파싱
          final playlistName = data['name'] as String? ?? '알 수 없는 플레이리스트';
          final tracksData = data['tracks'] as List? ?? [];

          logger.d('플레이리스트 "$playlistName" - 트랙 데이터 수: ${tracksData.length}');

          for (var trackData in tracksData) {
            try {
              if (trackData is Map<String, dynamic>) {
                // 필수 필드들이 모두 있는지 확인하고 안전하게 파싱
                final videoId = trackData['videoId'] as String? ?? '';
                final title = trackData['title'] as String? ?? '';
                final description = trackData['description'] as String? ?? '';
                final thumbnail = trackData['thumbnail'] as String? ?? '';
                final channelTitle = trackData['channelTitle'] as String? ?? '';
                final publishedAt = trackData['publishedAt'] as String? ?? '';
                final duration = trackData['duration'] as int?;

                // videoId를 id로 사용하고, 필수 필드들이 비어있지 않은 경우에만 트랙 생성
                if (videoId.isNotEmpty && title.isNotEmpty) {
                  final track = YoutubeTrack(
                    id: videoId, // videoId를 id로 사용
                    videoId: videoId,
                    title: title,
                    description: description,
                    thumbnail: thumbnail,
                    channelTitle: channelTitle,
                    publishedAt: publishedAt,
                    duration: duration,
                    createdBy: null,
                  );

                  allTracks.add(track);
                  logger.d('트랙 추가 성공: $title ($videoId)');
                } else {
                  logger.w('필수 필드가 누락된 트랙 스킵: $trackData');
                }
              } else {
                logger.w('올바르지 않은 트랙 데이터 형식: $trackData');
              }
            } catch (trackError) {
              logger.e('개별 트랙 파싱 실패: $trackError');
              logger.e('문제있는 트랙 데이터: $trackData');
            }
          }
        } catch (e) {
          logger.e('플레이리스트 파싱 실패: ${playlistDoc.id}, 에러: $e');
          logger.e('실패한 데이터: $data');
        }
      }

      logger.d('getAllUserTracks 완료: 총 ${allTracks.length}개 트랙');
      return allTracks;
    } catch (e) {
      logger.e('getAllUserTracks 실패: $e');
      return [];
    }
  }
}
