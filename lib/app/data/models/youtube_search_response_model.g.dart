// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YoutubeSearchResponse _$YoutubeSearchResponseFromJson(
        Map<String, dynamic> json) =>
    _YoutubeSearchResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => YoutubeTrack.fromJson(e as Map<String, dynamic>))
          .toList(),
      fromCache: json['fromCache'] as bool,
      totalResults: (json['totalResults'] as num).toInt(),
      nextPageToken: json['nextPageToken'] as String?,
    );

Map<String, dynamic> _$YoutubeSearchResponseToJson(
        _YoutubeSearchResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'fromCache': instance.fromCache,
      'totalResults': instance.totalResults,
      'nextPageToken': instance.nextPageToken,
    };
