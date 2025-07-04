// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YoutubeTrack {
  String get id;
  String get videoId;
  String get title;
  String get description;
  String get thumbnail;
  String get channelTitle;
  String get publishedAt;
  int? get duration;
  CreatedBy? get createdBy;

  /// Create a copy of YoutubeTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $YoutubeTrackCopyWith<YoutubeTrack> get copyWith =>
      _$YoutubeTrackCopyWithImpl<YoutubeTrack>(
          this as YoutubeTrack, _$identity);

  /// Serializes this YoutubeTrack to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is YoutubeTrack &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.channelTitle, channelTitle) ||
                other.channelTitle == channelTitle) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, videoId, title, description,
      thumbnail, channelTitle, publishedAt, duration, createdBy);

  @override
  String toString() {
    return 'YoutubeTrack(id: $id, videoId: $videoId, title: $title, description: $description, thumbnail: $thumbnail, channelTitle: $channelTitle, publishedAt: $publishedAt, duration: $duration, createdBy: $createdBy)';
  }
}

/// @nodoc
abstract mixin class $YoutubeTrackCopyWith<$Res> {
  factory $YoutubeTrackCopyWith(
          YoutubeTrack value, $Res Function(YoutubeTrack) _then) =
      _$YoutubeTrackCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String videoId,
      String title,
      String description,
      String thumbnail,
      String channelTitle,
      String publishedAt,
      int? duration,
      CreatedBy? createdBy});

  $CreatedByCopyWith<$Res>? get createdBy;
}

/// @nodoc
class _$YoutubeTrackCopyWithImpl<$Res> implements $YoutubeTrackCopyWith<$Res> {
  _$YoutubeTrackCopyWithImpl(this._self, this._then);

  final YoutubeTrack _self;
  final $Res Function(YoutubeTrack) _then;

  /// Create a copy of YoutubeTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? title = null,
    Object? description = null,
    Object? thumbnail = null,
    Object? channelTitle = null,
    Object? publishedAt = null,
    Object? duration = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      videoId: null == videoId
          ? _self.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      channelTitle: null == channelTitle
          ? _self.channelTitle
          : channelTitle // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as String,
      duration: freezed == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      createdBy: freezed == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedBy?,
    ));
  }

  /// Create a copy of YoutubeTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatedByCopyWith<$Res>? get createdBy {
    if (_self.createdBy == null) {
      return null;
    }

    return $CreatedByCopyWith<$Res>(_self.createdBy!, (value) {
      return _then(_self.copyWith(createdBy: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _YoutubeTrack implements YoutubeTrack {
  const _YoutubeTrack(
      {required this.id,
      required this.videoId,
      required this.title,
      required this.description,
      required this.thumbnail,
      required this.channelTitle,
      required this.publishedAt,
      this.duration,
      this.createdBy});
  factory _YoutubeTrack.fromJson(Map<String, dynamic> json) =>
      _$YoutubeTrackFromJson(json);

  @override
  final String id;
  @override
  final String videoId;
  @override
  final String title;
  @override
  final String description;
  @override
  final String thumbnail;
  @override
  final String channelTitle;
  @override
  final String publishedAt;
  @override
  final int? duration;
  @override
  final CreatedBy? createdBy;

  /// Create a copy of YoutubeTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$YoutubeTrackCopyWith<_YoutubeTrack> get copyWith =>
      __$YoutubeTrackCopyWithImpl<_YoutubeTrack>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$YoutubeTrackToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _YoutubeTrack &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.channelTitle, channelTitle) ||
                other.channelTitle == channelTitle) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, videoId, title, description,
      thumbnail, channelTitle, publishedAt, duration, createdBy);

  @override
  String toString() {
    return 'YoutubeTrack(id: $id, videoId: $videoId, title: $title, description: $description, thumbnail: $thumbnail, channelTitle: $channelTitle, publishedAt: $publishedAt, duration: $duration, createdBy: $createdBy)';
  }
}

/// @nodoc
abstract mixin class _$YoutubeTrackCopyWith<$Res>
    implements $YoutubeTrackCopyWith<$Res> {
  factory _$YoutubeTrackCopyWith(
          _YoutubeTrack value, $Res Function(_YoutubeTrack) _then) =
      __$YoutubeTrackCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String videoId,
      String title,
      String description,
      String thumbnail,
      String channelTitle,
      String publishedAt,
      int? duration,
      CreatedBy? createdBy});

  @override
  $CreatedByCopyWith<$Res>? get createdBy;
}

/// @nodoc
class __$YoutubeTrackCopyWithImpl<$Res>
    implements _$YoutubeTrackCopyWith<$Res> {
  __$YoutubeTrackCopyWithImpl(this._self, this._then);

  final _YoutubeTrack _self;
  final $Res Function(_YoutubeTrack) _then;

  /// Create a copy of YoutubeTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? title = null,
    Object? description = null,
    Object? thumbnail = null,
    Object? channelTitle = null,
    Object? publishedAt = null,
    Object? duration = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_YoutubeTrack(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      videoId: null == videoId
          ? _self.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      channelTitle: null == channelTitle
          ? _self.channelTitle
          : channelTitle // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as String,
      duration: freezed == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      createdBy: freezed == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedBy?,
    ));
  }

  /// Create a copy of YoutubeTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatedByCopyWith<$Res>? get createdBy {
    if (_self.createdBy == null) {
      return null;
    }

    return $CreatedByCopyWith<$Res>(_self.createdBy!, (value) {
      return _then(_self.copyWith(createdBy: value));
    });
  }
}

/// @nodoc
mixin _$CreatedBy {
  String get uid;
  String get nickname;
  String get avatarUrl;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreatedByCopyWith<CreatedBy> get copyWith =>
      _$CreatedByCopyWithImpl<CreatedBy>(this as CreatedBy, _$identity);

  /// Serializes this CreatedBy to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreatedBy &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, nickname, avatarUrl);

  @override
  String toString() {
    return 'CreatedBy(uid: $uid, nickname: $nickname, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class $CreatedByCopyWith<$Res> {
  factory $CreatedByCopyWith(CreatedBy value, $Res Function(CreatedBy) _then) =
      _$CreatedByCopyWithImpl;
  @useResult
  $Res call({String uid, String nickname, String avatarUrl});
}

/// @nodoc
class _$CreatedByCopyWithImpl<$Res> implements $CreatedByCopyWith<$Res> {
  _$CreatedByCopyWithImpl(this._self, this._then);

  final CreatedBy _self;
  final $Res Function(CreatedBy) _then;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? nickname = null,
    Object? avatarUrl = null,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CreatedBy implements CreatedBy {
  const _CreatedBy(
      {required this.uid, required this.nickname, required this.avatarUrl});
  factory _CreatedBy.fromJson(Map<String, dynamic> json) =>
      _$CreatedByFromJson(json);

  @override
  final String uid;
  @override
  final String nickname;
  @override
  final String avatarUrl;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreatedByCopyWith<_CreatedBy> get copyWith =>
      __$CreatedByCopyWithImpl<_CreatedBy>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreatedByToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreatedBy &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, nickname, avatarUrl);

  @override
  String toString() {
    return 'CreatedBy(uid: $uid, nickname: $nickname, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class _$CreatedByCopyWith<$Res>
    implements $CreatedByCopyWith<$Res> {
  factory _$CreatedByCopyWith(
          _CreatedBy value, $Res Function(_CreatedBy) _then) =
      __$CreatedByCopyWithImpl;
  @override
  @useResult
  $Res call({String uid, String nickname, String avatarUrl});
}

/// @nodoc
class __$CreatedByCopyWithImpl<$Res> implements _$CreatedByCopyWith<$Res> {
  __$CreatedByCopyWithImpl(this._self, this._then);

  final _CreatedBy _self;
  final $Res Function(_CreatedBy) _then;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? nickname = null,
    Object? avatarUrl = null,
  }) {
    return _then(_CreatedBy(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
