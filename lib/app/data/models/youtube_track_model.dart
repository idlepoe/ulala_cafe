import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_track_model.freezed.dart';
part 'youtube_track_model.g.dart';

@freezed
abstract class YoutubeTrack with _$YoutubeTrack {
  const factory YoutubeTrack({
    required String id,
    required String videoId,
    required String title,
    required String description,
    required String thumbnail,
    required String channelTitle,
    required String publishedAt,
    int? duration,
    CreatedBy? createdBy,
  }) = _YoutubeTrack;

  factory YoutubeTrack.fromJson(Map<String, dynamic> json) =>
      _$YoutubeTrackFromJson(json);
}

@freezed
abstract class CreatedBy with _$CreatedBy {
  const factory CreatedBy({
    required String uid,
    required String nickname,
    required String avatarUrl,
  }) = _CreatedBy;

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      _$CreatedByFromJson(json);
}
