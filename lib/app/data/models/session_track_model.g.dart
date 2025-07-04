// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionTrack _$SessionTrackFromJson(Map<String, dynamic> json) =>
    _SessionTrack(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      duration: (json['duration'] as num).toInt(),
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      addedBy: AddedBy.fromJson(json['addedBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionTrackToJson(_SessionTrack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'title': instance.title,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'duration': instance.duration,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'addedBy': instance.addedBy,
    };

_AddedBy _$AddedByFromJson(Map<String, dynamic> json) => _AddedBy(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$AddedByToJson(_AddedBy instance) => <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
    };
