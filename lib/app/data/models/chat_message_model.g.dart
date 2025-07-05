// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
      id: json['id'] as String,
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      message: json['message'] as String,
      timestamp: const TimestampConverter().fromJson(json['timestamp']),
      type: json['type'] as String? ?? 'text',
      youtubeTrack: json['youtubeTrack'] == null
          ? null
          : YoutubeTrack.fromJson(json['youtubeTrack'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'message': instance.message,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
      'type': instance.type,
      'youtubeTrack': instance.youtubeTrack,
    };
