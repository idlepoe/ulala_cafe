import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'youtube_track_model.dart';

part 'track_ranking_model.freezed.dart';
part 'track_ranking_model.g.dart';

@freezed
abstract class TrackRanking with _$TrackRanking {
  const factory TrackRanking({
    required String videoId,
    required String title,
    required String channelTitle,
    required String thumbnail,
    @Default('') String description,
    @Default('') String publishedAt,
    int? duration,
    @Default(0) int totalPlayCount,
    @Default({}) Map<String, int> dailyCounts, // "2024-06-07": 5
    @Default({}) Map<String, int> weeklyCounts, // "2024-W23": 12
    @Default({}) Map<String, int> monthlyCounts, // "2024-06": 20
    @TimestampConverter() DateTime? lastPlayedAt,
  }) = _TrackRanking;

  factory TrackRanking.fromJson(Map<String, dynamic> json) =>
      _$TrackRankingFromJson(json);

  /// YoutubeTrack으로부터 TrackRanking 생성
  factory TrackRanking.fromYoutubeTrack(YoutubeTrack track) {
    return TrackRanking(
      videoId: track.videoId,
      title: track.title,
      channelTitle: track.channelTitle,
      thumbnail: track.thumbnail,
      description: track.description,
      publishedAt: track.publishedAt,
      duration: track.duration,
      totalPlayCount: 0,
      dailyCounts: {},
      weeklyCounts: {},
      monthlyCounts: {},
      lastPlayedAt: DateTime.now(),
    );
  }

  /// TrackRanking을 YoutubeTrack으로 변환
  const TrackRanking._();
  YoutubeTrack toYoutubeTrack() {
    return YoutubeTrack(
      id: videoId,
      videoId: videoId,
      title: title,
      channelTitle: channelTitle,
      thumbnail: thumbnail,
      description: description,
      publishedAt: publishedAt,
      duration: duration,
      createdBy: null,
    );
  }
}

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.parse(timestamp.toString());
  }

  @override
  dynamic toJson(DateTime? dateTime) =>
      dateTime != null ? Timestamp.fromDate(dateTime) : null;
}
