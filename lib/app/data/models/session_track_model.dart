import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_track_model.freezed.dart';
part 'session_track_model.g.dart';

@freezed
abstract class SessionTrack with _$SessionTrack {
  const factory SessionTrack({
    required String id,
    required String videoId,
    required String title,
    required String description,
    required String thumbnail,
    required int duration,
    required DateTime startAt,
    required DateTime endAt,
    required DateTime createdAt,
    required AddedBy addedBy,
  }) = _SessionTrack;

  factory SessionTrack.fromJson(Map<String, dynamic> json) =>
      _$SessionTrackFromJson(json);
}

@freezed
abstract class AddedBy with _$AddedBy {
  const factory AddedBy({
    required String uid,
    required String nickname,
    required String avatarUrl,
  }) = _AddedBy;

  factory AddedBy.fromJson(Map<String, dynamic> json) =>
      _$AddedByFromJson(json);
}
