// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_search_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YoutubeSearchResponse {
  bool get success;
  String get message;
  List<YoutubeTrack> get data;
  bool get fromCache;
  int get totalResults;
  String? get nextPageToken;

  /// Create a copy of YoutubeSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $YoutubeSearchResponseCopyWith<YoutubeSearchResponse> get copyWith =>
      _$YoutubeSearchResponseCopyWithImpl<YoutubeSearchResponse>(
          this as YoutubeSearchResponse, _$identity);

  /// Serializes this YoutubeSearchResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is YoutubeSearchResponse &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.fromCache, fromCache) ||
                other.fromCache == fromCache) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults) &&
            (identical(other.nextPageToken, nextPageToken) ||
                other.nextPageToken == nextPageToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      const DeepCollectionEquality().hash(data),
      fromCache,
      totalResults,
      nextPageToken);

  @override
  String toString() {
    return 'YoutubeSearchResponse(success: $success, message: $message, data: $data, fromCache: $fromCache, totalResults: $totalResults, nextPageToken: $nextPageToken)';
  }
}

/// @nodoc
abstract mixin class $YoutubeSearchResponseCopyWith<$Res> {
  factory $YoutubeSearchResponseCopyWith(YoutubeSearchResponse value,
          $Res Function(YoutubeSearchResponse) _then) =
      _$YoutubeSearchResponseCopyWithImpl;
  @useResult
  $Res call(
      {bool success,
      String message,
      List<YoutubeTrack> data,
      bool fromCache,
      int totalResults,
      String? nextPageToken});
}

/// @nodoc
class _$YoutubeSearchResponseCopyWithImpl<$Res>
    implements $YoutubeSearchResponseCopyWith<$Res> {
  _$YoutubeSearchResponseCopyWithImpl(this._self, this._then);

  final YoutubeSearchResponse _self;
  final $Res Function(YoutubeSearchResponse) _then;

  /// Create a copy of YoutubeSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = null,
    Object? fromCache = null,
    Object? totalResults = null,
    Object? nextPageToken = freezed,
  }) {
    return _then(_self.copyWith(
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<YoutubeTrack>,
      fromCache: null == fromCache
          ? _self.fromCache
          : fromCache // ignore: cast_nullable_to_non_nullable
              as bool,
      totalResults: null == totalResults
          ? _self.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int,
      nextPageToken: freezed == nextPageToken
          ? _self.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _YoutubeSearchResponse implements YoutubeSearchResponse {
  const _YoutubeSearchResponse(
      {required this.success,
      required this.message,
      required final List<YoutubeTrack> data,
      required this.fromCache,
      required this.totalResults,
      this.nextPageToken})
      : _data = data;
  factory _YoutubeSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$YoutubeSearchResponseFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  final List<YoutubeTrack> _data;
  @override
  List<YoutubeTrack> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final bool fromCache;
  @override
  final int totalResults;
  @override
  final String? nextPageToken;

  /// Create a copy of YoutubeSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$YoutubeSearchResponseCopyWith<_YoutubeSearchResponse> get copyWith =>
      __$YoutubeSearchResponseCopyWithImpl<_YoutubeSearchResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$YoutubeSearchResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _YoutubeSearchResponse &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.fromCache, fromCache) ||
                other.fromCache == fromCache) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults) &&
            (identical(other.nextPageToken, nextPageToken) ||
                other.nextPageToken == nextPageToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      const DeepCollectionEquality().hash(_data),
      fromCache,
      totalResults,
      nextPageToken);

  @override
  String toString() {
    return 'YoutubeSearchResponse(success: $success, message: $message, data: $data, fromCache: $fromCache, totalResults: $totalResults, nextPageToken: $nextPageToken)';
  }
}

/// @nodoc
abstract mixin class _$YoutubeSearchResponseCopyWith<$Res>
    implements $YoutubeSearchResponseCopyWith<$Res> {
  factory _$YoutubeSearchResponseCopyWith(_YoutubeSearchResponse value,
          $Res Function(_YoutubeSearchResponse) _then) =
      __$YoutubeSearchResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool success,
      String message,
      List<YoutubeTrack> data,
      bool fromCache,
      int totalResults,
      String? nextPageToken});
}

/// @nodoc
class __$YoutubeSearchResponseCopyWithImpl<$Res>
    implements _$YoutubeSearchResponseCopyWith<$Res> {
  __$YoutubeSearchResponseCopyWithImpl(this._self, this._then);

  final _YoutubeSearchResponse _self;
  final $Res Function(_YoutubeSearchResponse) _then;

  /// Create a copy of YoutubeSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = null,
    Object? fromCache = null,
    Object? totalResults = null,
    Object? nextPageToken = freezed,
  }) {
    return _then(_YoutubeSearchResponse(
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<YoutubeTrack>,
      fromCache: null == fromCache
          ? _self.fromCache
          : fromCache // ignore: cast_nullable_to_non_nullable
              as bool,
      totalResults: null == totalResults
          ? _self.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int,
      nextPageToken: freezed == nextPageToken
          ? _self.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
