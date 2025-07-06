// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackRanking _$TrackRankingFromJson(Map<String, dynamic> json) =>
    _TrackRanking(
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      channelTitle: json['channelTitle'] as String,
      thumbnail: json['thumbnail'] as String,
      description: json['description'] as String? ?? '',
      publishedAt: json['publishedAt'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt(),
      totalPlayCount: (json['totalPlayCount'] as num?)?.toInt() ?? 0,
      dailyCounts: (json['dailyCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      weeklyCounts: (json['weeklyCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      monthlyCounts: (json['monthlyCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      lastPlayedAt: const TimestampConverter().fromJson(json['lastPlayedAt']),
    );

Map<String, dynamic> _$TrackRankingToJson(_TrackRanking instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'title': instance.title,
      'channelTitle': instance.channelTitle,
      'thumbnail': instance.thumbnail,
      'description': instance.description,
      'publishedAt': instance.publishedAt,
      'duration': instance.duration,
      'totalPlayCount': instance.totalPlayCount,
      'dailyCounts': instance.dailyCounts,
      'weeklyCounts': instance.weeklyCounts,
      'monthlyCounts': instance.monthlyCounts,
      'lastPlayedAt': const TimestampConverter().toJson(instance.lastPlayedAt),
    };
