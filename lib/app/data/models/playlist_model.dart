import 'package:freezed_annotation/freezed_annotation.dart';
import 'youtube_track_model.dart';

part 'playlist_model.freezed.dart';
part 'playlist_model.g.dart';

@freezed
abstract class Playlist with _$Playlist {
  const factory Playlist({
    required String id,
    required String uid,
    required String name,
    @Default(false) bool isDefault,
    @Default([]) List<YoutubeTrack> tracks,
    DateTime? createdAt,
  }) = _Playlist;

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
}
