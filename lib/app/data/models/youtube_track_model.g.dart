// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YoutubeTrack _$YoutubeTrackFromJson(Map<String, dynamic> json) =>
    _YoutubeTrack(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      channelTitle: json['channelTitle'] as String,
      publishedAt: json['publishedAt'] as String,
      duration: (json['duration'] as num?)?.toInt(),
      createdBy: json['createdBy'] == null
          ? null
          : CreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$YoutubeTrackToJson(_YoutubeTrack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'title': instance.title,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'channelTitle': instance.channelTitle,
      'publishedAt': instance.publishedAt,
      'duration': instance.duration,
      'createdBy': instance.createdBy,
    };

_CreatedBy _$CreatedByFromJson(Map<String, dynamic> json) => _CreatedBy(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$CreatedByToJson(_CreatedBy instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
    };
