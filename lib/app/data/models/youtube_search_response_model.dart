import 'package:freezed_annotation/freezed_annotation.dart';
import 'youtube_track_model.dart';

part 'youtube_search_response_model.freezed.dart';
part 'youtube_search_response_model.g.dart';

@freezed
abstract class YoutubeSearchResponse with _$YoutubeSearchResponse {
  const factory YoutubeSearchResponse({
    required bool success,
    required String message,
    required List<YoutubeTrack> data,
    required bool fromCache,
    required int totalResults,
    String? nextPageToken,
  }) = _YoutubeSearchResponse;

  factory YoutubeSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$YoutubeSearchResponseFromJson(json);
}
