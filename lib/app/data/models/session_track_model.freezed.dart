// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionTrack {
  String get id;
  String get videoId;
  String get title;
  String get description;
  String get thumbnail;
  int get duration;
  DateTime get startAt;
  DateTime get endAt;
  DateTime get createdAt;
  AddedBy get addedBy;

  /// Create a copy of SessionTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionTrackCopyWith<SessionTrack> get copyWith =>
      _$SessionTrackCopyWithImpl<SessionTrack>(
          this as SessionTrack, _$identity);

  /// Serializes this SessionTrack to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionTrack &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, videoId, title, description,
      thumbnail, duration, startAt, endAt, createdAt, addedBy);

  @override
  String toString() {
    return 'SessionTrack(id: $id, videoId: $videoId, title: $title, description: $description, thumbnail: $thumbnail, duration: $duration, startAt: $startAt, endAt: $endAt, createdAt: $createdAt, addedBy: $addedBy)';
  }
}

/// @nodoc
abstract mixin class $SessionTrackCopyWith<$Res> {
  factory $SessionTrackCopyWith(
          SessionTrack value, $Res Function(SessionTrack) _then) =
      _$SessionTrackCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String videoId,
      String title,
      String description,
      String thumbnail,
      int duration,
      DateTime startAt,
      DateTime endAt,
      DateTime createdAt,
      AddedBy addedBy});

  $AddedByCopyWith<$Res> get addedBy;
}

/// @nodoc
class _$SessionTrackCopyWithImpl<$Res> implements $SessionTrackCopyWith<$Res> {
  _$SessionTrackCopyWithImpl(this._self, this._then);

  final SessionTrack _self;
  final $Res Function(SessionTrack) _then;

  /// Create a copy of SessionTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? title = null,
    Object? description = null,
    Object? thumbnail = null,
    Object? duration = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? createdAt = null,
    Object? addedBy = null,
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
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      addedBy: null == addedBy
          ? _self.addedBy
          : addedBy // ignore: cast_nullable_to_non_nullable
              as AddedBy,
    ));
  }

  /// Create a copy of SessionTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddedByCopyWith<$Res> get addedBy {
    return $AddedByCopyWith<$Res>(_self.addedBy, (value) {
      return _then(_self.copyWith(addedBy: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _SessionTrack implements SessionTrack {
  const _SessionTrack(
      {required this.id,
      required this.videoId,
      required this.title,
      required this.description,
      required this.thumbnail,
      required this.duration,
      required this.startAt,
      required this.endAt,
      required this.createdAt,
      required this.addedBy});
  factory _SessionTrack.fromJson(Map<String, dynamic> json) =>
      _$SessionTrackFromJson(json);

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
  final int duration;
  @override
  final DateTime startAt;
  @override
  final DateTime endAt;
  @override
  final DateTime createdAt;
  @override
  final AddedBy addedBy;

  /// Create a copy of SessionTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionTrackCopyWith<_SessionTrack> get copyWith =>
      __$SessionTrackCopyWithImpl<_SessionTrack>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionTrackToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionTrack &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, videoId, title, description,
      thumbnail, duration, startAt, endAt, createdAt, addedBy);

  @override
  String toString() {
    return 'SessionTrack(id: $id, videoId: $videoId, title: $title, description: $description, thumbnail: $thumbnail, duration: $duration, startAt: $startAt, endAt: $endAt, createdAt: $createdAt, addedBy: $addedBy)';
  }
}

/// @nodoc
abstract mixin class _$SessionTrackCopyWith<$Res>
    implements $SessionTrackCopyWith<$Res> {
  factory _$SessionTrackCopyWith(
          _SessionTrack value, $Res Function(_SessionTrack) _then) =
      __$SessionTrackCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String videoId,
      String title,
      String description,
      String thumbnail,
      int duration,
      DateTime startAt,
      DateTime endAt,
      DateTime createdAt,
      AddedBy addedBy});

  @override
  $AddedByCopyWith<$Res> get addedBy;
}

/// @nodoc
class __$SessionTrackCopyWithImpl<$Res>
    implements _$SessionTrackCopyWith<$Res> {
  __$SessionTrackCopyWithImpl(this._self, this._then);

  final _SessionTrack _self;
  final $Res Function(_SessionTrack) _then;

  /// Create a copy of SessionTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? title = null,
    Object? description = null,
    Object? thumbnail = null,
    Object? duration = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? createdAt = null,
    Object? addedBy = null,
  }) {
    return _then(_SessionTrack(
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
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      addedBy: null == addedBy
          ? _self.addedBy
          : addedBy // ignore: cast_nullable_to_non_nullable
              as AddedBy,
    ));
  }

  /// Create a copy of SessionTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddedByCopyWith<$Res> get addedBy {
    return $AddedByCopyWith<$Res>(_self.addedBy, (value) {
      return _then(_self.copyWith(addedBy: value));
    });
  }
}

/// @nodoc
mixin _$AddedBy {
  String get uid;
  String get nickname;
  String get avatarUrl;

  /// Create a copy of AddedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddedByCopyWith<AddedBy> get copyWith =>
      _$AddedByCopyWithImpl<AddedBy>(this as AddedBy, _$identity);

  /// Serializes this AddedBy to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddedBy &&
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
    return 'AddedBy(uid: $uid, nickname: $nickname, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class $AddedByCopyWith<$Res> {
  factory $AddedByCopyWith(AddedBy value, $Res Function(AddedBy) _then) =
      _$AddedByCopyWithImpl;
  @useResult
  $Res call({String uid, String nickname, String avatarUrl});
}

/// @nodoc
class _$AddedByCopyWithImpl<$Res> implements $AddedByCopyWith<$Res> {
  _$AddedByCopyWithImpl(this._self, this._then);

  final AddedBy _self;
  final $Res Function(AddedBy) _then;

  /// Create a copy of AddedBy
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
class _AddedBy implements AddedBy {
  const _AddedBy(
      {required this.uid, required this.nickname, required this.avatarUrl});
  factory _AddedBy.fromJson(Map<String, dynamic> json) =>
      _$AddedByFromJson(json);

  @override
  final String uid;
  @override
  final String nickname;
  @override
  final String avatarUrl;

  /// Create a copy of AddedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddedByCopyWith<_AddedBy> get copyWith =>
      __$AddedByCopyWithImpl<_AddedBy>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AddedByToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddedBy &&
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
    return 'AddedBy(uid: $uid, nickname: $nickname, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class _$AddedByCopyWith<$Res> implements $AddedByCopyWith<$Res> {
  factory _$AddedByCopyWith(_AddedBy value, $Res Function(_AddedBy) _then) =
      __$AddedByCopyWithImpl;
  @override
  @useResult
  $Res call({String uid, String nickname, String avatarUrl});
}

/// @nodoc
class __$AddedByCopyWithImpl<$Res> implements _$AddedByCopyWith<$Res> {
  __$AddedByCopyWithImpl(this._self, this._then);

  final _AddedBy _self;
  final $Res Function(_AddedBy) _then;

  /// Create a copy of AddedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? nickname = null,
    Object? avatarUrl = null,
  }) {
    return _then(_AddedBy(
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
