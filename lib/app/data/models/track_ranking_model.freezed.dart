// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_ranking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackRanking {
  String get videoId;
  String get title;
  String get channelTitle;
  String get thumbnail;
  String get description;
  String get publishedAt;
  int? get duration;
  int get totalPlayCount;
  Map<String, int> get dailyCounts; // "2024-06-07": 5
  Map<String, int> get weeklyCounts; // "2024-W23": 12
  Map<String, int> get monthlyCounts; // "2024-06": 20
  @TimestampConverter()
  DateTime? get lastPlayedAt;

  /// Create a copy of TrackRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackRankingCopyWith<TrackRanking> get copyWith =>
      _$TrackRankingCopyWithImpl<TrackRanking>(
          this as TrackRanking, _$identity);

  /// Serializes this TrackRanking to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackRanking &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.channelTitle, channelTitle) ||
                other.channelTitle == channelTitle) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.totalPlayCount, totalPlayCount) ||
                other.totalPlayCount == totalPlayCount) &&
            const DeepCollectionEquality()
                .equals(other.dailyCounts, dailyCounts) &&
            const DeepCollectionEquality()
                .equals(other.weeklyCounts, weeklyCounts) &&
            const DeepCollectionEquality()
                .equals(other.monthlyCounts, monthlyCounts) &&
            (identical(other.lastPlayedAt, lastPlayedAt) ||
                other.lastPlayedAt == lastPlayedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      videoId,
      title,
      channelTitle,
      thumbnail,
      description,
      publishedAt,
      duration,
      totalPlayCount,
      const DeepCollectionEquality().hash(dailyCounts),
      const DeepCollectionEquality().hash(weeklyCounts),
      const DeepCollectionEquality().hash(monthlyCounts),
      lastPlayedAt);

  @override
  String toString() {
    return 'TrackRanking(videoId: $videoId, title: $title, channelTitle: $channelTitle, thumbnail: $thumbnail, description: $description, publishedAt: $publishedAt, duration: $duration, totalPlayCount: $totalPlayCount, dailyCounts: $dailyCounts, weeklyCounts: $weeklyCounts, monthlyCounts: $monthlyCounts, lastPlayedAt: $lastPlayedAt)';
  }
}

/// @nodoc
abstract mixin class $TrackRankingCopyWith<$Res> {
  factory $TrackRankingCopyWith(
          TrackRanking value, $Res Function(TrackRanking) _then) =
      _$TrackRankingCopyWithImpl;
  @useResult
  $Res call(
      {String videoId,
      String title,
      String channelTitle,
      String thumbnail,
      String description,
      String publishedAt,
      int? duration,
      int totalPlayCount,
      Map<String, int> dailyCounts,
      Map<String, int> weeklyCounts,
      Map<String, int> monthlyCounts,
      @TimestampConverter() DateTime? lastPlayedAt});
}

/// @nodoc
class _$TrackRankingCopyWithImpl<$Res> implements $TrackRankingCopyWith<$Res> {
  _$TrackRankingCopyWithImpl(this._self, this._then);

  final TrackRanking _self;
  final $Res Function(TrackRanking) _then;

  /// Create a copy of TrackRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? title = null,
    Object? channelTitle = null,
    Object? thumbnail = null,
    Object? description = null,
    Object? publishedAt = null,
    Object? duration = freezed,
    Object? totalPlayCount = null,
    Object? dailyCounts = null,
    Object? weeklyCounts = null,
    Object? monthlyCounts = null,
    Object? lastPlayedAt = freezed,
  }) {
    return _then(_self.copyWith(
      videoId: null == videoId
          ? _self.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      channelTitle: null == channelTitle
          ? _self.channelTitle
          : channelTitle // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as String,
      duration: freezed == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPlayCount: null == totalPlayCount
          ? _self.totalPlayCount
          : totalPlayCount // ignore: cast_nullable_to_non_nullable
              as int,
      dailyCounts: null == dailyCounts
          ? _self.dailyCounts
          : dailyCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      weeklyCounts: null == weeklyCounts
          ? _self.weeklyCounts
          : weeklyCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      monthlyCounts: null == monthlyCounts
          ? _self.monthlyCounts
          : monthlyCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      lastPlayedAt: freezed == lastPlayedAt
          ? _self.lastPlayedAt
          : lastPlayedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TrackRanking extends TrackRanking {
  const _TrackRanking(
      {required this.videoId,
      required this.title,
      required this.channelTitle,
      required this.thumbnail,
      this.description = '',
      this.publishedAt = '',
      this.duration,
      this.totalPlayCount = 0,
      final Map<String, int> dailyCounts = const {},
      final Map<String, int> weeklyCounts = const {},
      final Map<String, int> monthlyCounts = const {},
      @TimestampConverter() this.lastPlayedAt})
      : _dailyCounts = dailyCounts,
        _weeklyCounts = weeklyCounts,
        _monthlyCounts = monthlyCounts,
        super._();
  factory _TrackRanking.fromJson(Map<String, dynamic> json) =>
      _$TrackRankingFromJson(json);

  @override
  final String videoId;
  @override
  final String title;
  @override
  final String channelTitle;
  @override
  final String thumbnail;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String publishedAt;
  @override
  final int? duration;
  @override
  @JsonKey()
  final int totalPlayCount;
  final Map<String, int> _dailyCounts;
  @override
  @JsonKey()
  Map<String, int> get dailyCounts {
    if (_dailyCounts is EqualUnmodifiableMapView) return _dailyCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailyCounts);
  }

// "2024-06-07": 5
  final Map<String, int> _weeklyCounts;
// "2024-06-07": 5
  @override
  @JsonKey()
  Map<String, int> get weeklyCounts {
    if (_weeklyCounts is EqualUnmodifiableMapView) return _weeklyCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weeklyCounts);
  }

// "2024-W23": 12
  final Map<String, int> _monthlyCounts;
// "2024-W23": 12
  @override
  @JsonKey()
  Map<String, int> get monthlyCounts {
    if (_monthlyCounts is EqualUnmodifiableMapView) return _monthlyCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_monthlyCounts);
  }

// "2024-06": 20
  @override
  @TimestampConverter()
  final DateTime? lastPlayedAt;

  /// Create a copy of TrackRanking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackRankingCopyWith<_TrackRanking> get copyWith =>
      __$TrackRankingCopyWithImpl<_TrackRanking>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrackRankingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackRanking &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.channelTitle, channelTitle) ||
                other.channelTitle == channelTitle) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.totalPlayCount, totalPlayCount) ||
                other.totalPlayCount == totalPlayCount) &&
            const DeepCollectionEquality()
                .equals(other._dailyCounts, _dailyCounts) &&
            const DeepCollectionEquality()
                .equals(other._weeklyCounts, _weeklyCounts) &&
            const DeepCollectionEquality()
                .equals(other._monthlyCounts, _monthlyCounts) &&
            (identical(other.lastPlayedAt, lastPlayedAt) ||
                other.lastPlayedAt == lastPlayedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      videoId,
      title,
      channelTitle,
      thumbnail,
      description,
      publishedAt,
      duration,
      totalPlayCount,
      const DeepCollectionEquality().hash(_dailyCounts),
      const DeepCollectionEquality().hash(_weeklyCounts),
      const DeepCollectionEquality().hash(_monthlyCounts),
      lastPlayedAt);

  @override
  String toString() {
    return 'TrackRanking(videoId: $videoId, title: $title, channelTitle: $channelTitle, thumbnail: $thumbnail, description: $description, publishedAt: $publishedAt, duration: $duration, totalPlayCount: $totalPlayCount, dailyCounts: $dailyCounts, weeklyCounts: $weeklyCounts, monthlyCounts: $monthlyCounts, lastPlayedAt: $lastPlayedAt)';
  }
}

/// @nodoc
abstract mixin class _$TrackRankingCopyWith<$Res>
    implements $TrackRankingCopyWith<$Res> {
  factory _$TrackRankingCopyWith(
          _TrackRanking value, $Res Function(_TrackRanking) _then) =
      __$TrackRankingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String videoId,
      String title,
      String channelTitle,
      String thumbnail,
      String description,
      String publishedAt,
      int? duration,
      int totalPlayCount,
      Map<String, int> dailyCounts,
      Map<String, int> weeklyCounts,
      Map<String, int> monthlyCounts,
      @TimestampConverter() DateTime? lastPlayedAt});
}

/// @nodoc
class __$TrackRankingCopyWithImpl<$Res>
    implements _$TrackRankingCopyWith<$Res> {
  __$TrackRankingCopyWithImpl(this._self, this._then);

  final _TrackRanking _self;
  final $Res Function(_TrackRanking) _then;

  /// Create a copy of TrackRanking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? videoId = null,
    Object? title = null,
    Object? channelTitle = null,
    Object? thumbnail = null,
    Object? description = null,
    Object? publishedAt = null,
    Object? duration = freezed,
    Object? totalPlayCount = null,
    Object? dailyCounts = null,
    Object? weeklyCounts = null,
    Object? monthlyCounts = null,
    Object? lastPlayedAt = freezed,
  }) {
    return _then(_TrackRanking(
      videoId: null == videoId
          ? _self.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      channelTitle: null == channelTitle
          ? _self.channelTitle
          : channelTitle // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as String,
      duration: freezed == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPlayCount: null == totalPlayCount
          ? _self.totalPlayCount
          : totalPlayCount // ignore: cast_nullable_to_non_nullable
              as int,
      dailyCounts: null == dailyCounts
          ? _self._dailyCounts
          : dailyCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      weeklyCounts: null == weeklyCounts
          ? _self._weeklyCounts
          : weeklyCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      monthlyCounts: null == monthlyCounts
          ? _self._monthlyCounts
          : monthlyCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      lastPlayedAt: freezed == lastPlayedAt
          ? _self.lastPlayedAt
          : lastPlayedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
