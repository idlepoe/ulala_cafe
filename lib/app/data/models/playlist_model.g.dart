// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Playlist _$PlaylistFromJson(Map<String, dynamic> json) => _Playlist(
      id: json['id'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      tracks: (json['tracks'] as List<dynamic>?)
              ?.map((e) => YoutubeTrack.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PlaylistToJson(_Playlist instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'isDefault': instance.isDefault,
      'tracks': instance.tracks,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
